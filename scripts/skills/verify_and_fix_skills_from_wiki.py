#!/usr/bin/env python3
"""
Verify and fix skill data in JSON files against the Guild Wars Wiki.

For each skill:
1. Fetch the wiki page at wiki_url (or derive URL from skill name)
2. If the URL is wrong, fix it
3. If the URL is correct, compare all skill fields and fix mismatches

Usage:
    python3 verify_and_fix_skills_from_wiki.py --all
    python3 verify_and_fix_skills_from_wiki.py --file warrior.json
    python3 verify_and_fix_skills_from_wiki.py --all --dry-run
    python3 verify_and_fix_skills_from_wiki.py --all --resume
"""

import argparse
import copy
import html
import json
import re
import subprocess
import sys
import time
import urllib.parse
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent
DATA_DIR = SCRIPT_DIR.parent.parent / 'data' / 'skills'
PROGRESS_FILE = SCRIPT_DIR / 'verify_skills_progress.json'
REPORT_FILE = SCRIPT_DIR / 'verify_skills_report.json'

WIKI_BASE = 'https://wiki.guildwars.com/wiki/'


def encode_skill_name_for_url(skill_name):
    """Encode skill name for wiki URL."""
    encoded = skill_name.strip()
    encoded = re.sub(r'\s+\(', '_(', encoded)
    encoded = encoded.replace(' ', '_')
    encoded = encoded.replace('"', '%22')
    encoded = encoded.replace("'", '%27')
    return encoded


def build_wiki_url(skill_name):
    return f'{WIKI_BASE}{encode_skill_name_for_url(skill_name)}'


def to_upper_camel_case(text):
    text = text.replace('%', ' Percent ')
    text = text.replace('+', ' Plus ')
    text = text.replace('-', ' Minus ')
    text = re.sub(r'[^a-zA-Z\s]', '', text)
    words = text.split()
    return ''.join(word.capitalize() for word in words if word)


def parse_number(text):
    text = text.strip()
    text = text.replace('½', '.5').replace('&#189;', '.5')
    negative = text.startswith('-') or text.startswith('−')
    text = re.sub(r'[^\d.]', '', text)
    if not text:
        return None
    value = float(text) if '.' in text else int(text)
    if negative:
        value = -value
    return value


def normalize_name(name):
    if not name:
        return ''
    name = html.unescape(name)
    name = name.replace('_', ' ')
    return ' '.join(name.split()).lower()


def names_match(a, b):
    if normalize_name(a) == normalize_name(b):
        return True
    variant_match = re.match(r'^(.+?)\s+\([^)]+\)$', a or '')
    if variant_match and normalize_name(variant_match.group(1)) == normalize_name(b):
        return True
    variant_match = re.match(r'^(.+?)\s+\([^)]+\)$', b or '')
    if variant_match and normalize_name(variant_match.group(1)) == normalize_name(a):
        return True
    if a and b:
        a_norm = re.sub(r'\s*\(attack\)\s*', ' ', a, flags=re.IGNORECASE)
        b_norm = re.sub(r'\s*\(attack\)\s*', ' ', b, flags=re.IGNORECASE)
        if normalize_name(a_norm) == normalize_name(b_norm):
            return True
    return False


def fetch_wiki_html(url):
    try:
        result = subprocess.run(
            ['curl', '-s', '-L', '--max-time', '20', url],
            capture_output=True,
            text=True,
            timeout=25,
        )
        if result.returncode != 0 or not result.stdout:
            return None, None
        page_name = None
        match = re.search(r'"wgPageName":"([^"]+)"', result.stdout)
        if match:
            page_name = match.group(1)
        return result.stdout, page_name
    except Exception:
        return None, None


def html_to_text(fragment):
    fragment = re.sub(
        r'<a[^>]*>(.*?)</a>',
        lambda m: m.group(1),
        fragment,
        flags=re.DOTALL,
    )
    fragment = re.sub(r'<[^>]+>', '', fragment)
    fragment = html.unescape(fragment)
    fragment = fragment.replace('\xa0', ' ')
    return ' '.join(fragment.split())


def get_dl_value(infobox_html, label):
    pattern = (
        rf'<dt[^>]*>.*?{re.escape(label)}.*?</dt>\s*<dd[^>]*>(.*?)</dd>'
    )
    match = re.search(pattern, infobox_html, re.DOTALL | re.IGNORECASE)
    if not match:
        return None
    return match.group(1)


def parse_skill_stats(stats_html):
    costs = {
        'energy': None,
        'adrenaline': None,
        'upkeep': None,
        'sacrifice': None,
        'overcast': None,
    }
    activation = None
    recharge = None

    for li in re.findall(r'<li>(.*?)</li>', stats_html, re.DOTALL):
        hidden = re.search(r'<span style="display:none">([^<]+)</span>', li)
        raw = hidden.group(1) if hidden else re.sub(r'<[^>]+>', '', li).strip()
        value = parse_number(raw.split()[0] if raw.split() else raw)

        if '/Tango-energy' in li or 'title="Energy"' in li:
            costs['energy'] = int(value) if value is not None else None
        elif '/Tango-adrenaline' in li:
            costs['adrenaline'] = int(value) if value is not None else None
        elif '/Tango-upkeep' in li:
            costs['upkeep'] = int(value) if value is not None else None
        elif '/Tango-sacrifice' in li:
            costs['sacrifice'] = int(value) if value is not None else None
        elif '/Tango-overcast' in li:
            costs['overcast'] = int(value) if value is not None else None
        elif '/Tango-activation' in li:
            activation = value
        elif '/Tango-recharge' in li:
            if value is not None:
                recharge = int(value)
            else:
                text = html_to_text(li).lower()
                if 'morale boost' in text:
                    recharge = 'morale boost'

    return costs, activation, recharge


def parse_limitation_from_type(type_html):
    if re.search(r'PvE-only', type_html, re.IGNORECASE):
        return 'PvE-only'
    if re.search(r'monster skill', type_html, re.IGNORECASE):
        return 'monster-only'
    return None


def parse_type_field(type_html):
    links = re.findall(r'<a[^>]*title="([^"]*)"', type_html)
    if not links:
        text = html_to_text(type_html)
        return text, False

    skip_titles = {
        'elite',
        'list of pve-only skills',
        'pve-only',
        'monster skill',
        'special skill',
    }

    is_elite = any(link.lower() == 'elite' for link in links)
    skill_type = None
    for link in links:
        if link.lower() not in skip_titles:
            skill_type = link
            break

    if not skill_type:
        for link in reversed(links):
            if link.lower() != 'elite':
                skill_type = link
                break

    return skill_type, is_elite


def parse_campaign(campaign_html):
    links = re.findall(r'<a[^>]*title="([^"]*)"', campaign_html)
    if links:
        return links[0]
    return html_to_text(campaign_html) or None


def parse_icon_url(infobox_html):
    match = re.search(
        r'<div class="skill-image">.*?src="(/images/[^"]+\.jpg)"',
        infobox_html,
        re.DOTALL,
    )
    if match:
        return f'https://wiki.guildwars.com{match.group(1)}'
    return None


def parse_div_based_progression(prog_html):
    row_match = re.search(r'</th></tr>\s*<tr[^>]*>(.*)', prog_html, re.DOTALL)
    if not row_match:
        return None

    row_content = row_match.group(1)
    td_matches = re.findall(r'<td[^>]*>(.*?)</td>', row_content, re.DOTALL)
    if len(td_matches) < 2:
        return None

    left_side = td_matches[0]
    right_side = td_matches[1]

    attr_match = re.search(r'<div class="attr[^"]*"><a[^>]*>([^<]+)</a></div>', left_side)
    if not attr_match:
        attr_match = re.search(r'<div class="attr[^"]*">([^<]+)</div>', left_side)
    if not attr_match:
        return None

    attribute_name = attr_match.group(1).strip()

    var_div_matches = re.findall(r'<div class="var[^"]*">(.*?)</div>', left_side, re.DOTALL)
    var_divs = []
    for var_html in var_div_matches:
        text = re.sub(r'<[^>]+>', ' ', var_html)
        text = text.replace('&#160;', ' ').strip()
        text = ' '.join(text.split())
        var_divs.append(text)

    if not var_divs:
        return None

    columns = re.findall(
        r'<div class="column"[^>]*>(.*?)</div>\s*(?=<div class="column|</td>|$)',
        right_side,
        re.DOTALL,
    )
    if not columns:
        return None

    variables = {var_name: {} for var_name in var_divs}

    for column in columns:
        attr_level_match = re.search(r'<div class="attr">(\d+)</div>', column)
        if not attr_level_match:
            continue
        attr_level = attr_level_match.group(1)
        var_values = re.findall(r'<div class="var">([^<]+)</div>', column)
        if len(var_values) != len(var_divs):
            continue
        for var_name, value in zip(var_divs, var_values):
            value_clean = value.strip().replace('%', '')
            try:
                if '.' in value_clean:
                    parsed_value = float(value_clean)
                else:
                    parsed_value = int(value_clean)
            except ValueError:
                parsed_value = value_clean
            variables[var_name][attr_level] = parsed_value

    progression = {}
    for original_var_name, values in variables.items():
        camel_name = to_upper_camel_case(original_var_name)
        if camel_name:
            progression[camel_name] = values

    return {
        'attribute_name': attribute_name,
        'progression': progression,
    }


def parse_table_based_progression(table_html):
    rows = re.findall(r'<tr[^>]*>(.*?)</tr>', table_html, re.DOTALL)
    if len(rows) < 2:
        return None

    first_row_cells = re.findall(r'<t[hd][^>]*>(.*?)</t[hd]>', rows[0], re.DOTALL)
    if not first_row_cells:
        return None

    attr_text = re.sub(r'<[^>]+>', ' ', first_row_cells[0]).strip()

    rank_values = []
    for cell in first_row_cells[1:]:
        cell_text = re.sub(r'<[^>]+>', '', cell).strip()
        try:
            rank_values.append(str(int(cell_text)))
        except ValueError:
            continue

    if not rank_values:
        return None

    variables = {}
    for row in rows[1:]:
        cells = re.findall(r'<t[hd][^>]*>(.*?)</t[hd]>', row, re.DOTALL)
        if len(cells) < 2:
            continue
        var_text = re.sub(r'<[^>]+>', ' ', cells[0])
        var_text = var_text.replace('&#160;', ' ').replace('%', '').strip()
        var_text = ' '.join(var_text.split())
        if not var_text:
            continue
        var_values = {}
        for rank, cell in zip(rank_values, cells[1:]):
            cell_text = re.sub(r'<[^>]+>', '', cell).strip()
            try:
                if '.' in cell_text:
                    var_values[rank] = float(cell_text)
                else:
                    var_values[rank] = int(cell_text)
            except ValueError:
                var_values[rank] = cell_text
        if var_values:
            variables[var_text] = var_values

    progression = {}
    for original_var_name, values in variables.items():
        camel_name = to_upper_camel_case(original_var_name)
        if camel_name:
            progression[camel_name] = values

    return {
        'attribute_name': attr_text,
        'progression': progression,
    }


def parse_progression_table(html):
    prog_match = re.search(r'<th colspan="2">Progression.*?</td></tr>', html, re.DOTALL)
    if prog_match:
        return parse_div_based_progression(prog_match.group(0))

    prog_match = re.search(r'<td colspan="\d+"><b>Progression</b>.*?</table>', html, re.DOTALL)
    if prog_match:
        return parse_table_based_progression(prog_match.group(0))

    return None


def parse_concise_description(html):
    match = re.search(
        r'Concise description</dt>\s*<dd></dd></dl>\s*(.*?)</div>',
        html,
        re.DOTALL,
    )
    if not match:
        return None
    return html_to_text(match.group(1))


def matches_dotted_progression(values, ranks):
    rank_list = sorted(int(k) for k in ranks.keys())
    rank_vals = [ranks[str(r)] for r in rank_list]
    value_idx = 0
    for rank_val in rank_vals:
        if rank_val == values[value_idx]:
            value_idx += 1
            if value_idx == len(values):
                return True
    return False


def find_variable_for_range(values, progression):
    for var_name, ranks in progression.items():
        if matches_dotted_progression(values, ranks):
            return var_name
    return None


def normalize_skill_type(type_name):
    if not type_name:
        return type_name
    type_name = type_name.strip()
    if '(' in type_name:
        type_name = type_name.split('(')[0].strip()
    return type_name


def types_equal(json_type, wiki_type, json_is_elite, wiki_is_elite):
    json_type = normalize_skill_type(json_type)
    wiki_type = normalize_skill_type(wiki_type)
    if values_equal(json_type, wiki_type):
        return True
    if json_is_elite and wiki_is_elite and json_type == f'Elite {wiki_type}':
        return True
    if wiki_type and json_type and wiki_type.lower() in json_type.lower():
        return True
    return False


def wiki_concise_to_json_format(wiki_concise, progression):
    if not wiki_concise:
        return wiki_concise

    result = wiki_concise
    pattern = r'(\d+(?:\.\.\.\d+)+)(%?)'
    used_variables = set()

    for match in re.finditer(pattern, wiki_concise):
        range_str = match.group(1)
        percent = match.group(2)
        values = [int(v) for v in range_str.split('...')]

        var_name = None
        if progression:
            for candidate_name, ranks in progression.items():
                if candidate_name in used_variables:
                    continue
                if matches_dotted_progression(values, ranks):
                    var_name = candidate_name
                    used_variables.add(candidate_name)
                    break

        if var_name:
            replacement = f'{{{{{var_name}}}}}{percent}'
        else:
            replacement = match.group(0)

        result = result.replace(match.group(0), replacement, 1)

    return result


def parse_skill_from_html(html):
    if 'infobox skill-box' not in html:
        return None

    infobox_match = re.search(
        r'<div class="infobox skill-box[^"]*">(.*?)</div>\s*(?=<div class="noexcerpt"|<table class="skill-progression")',
        html,
        re.DOTALL,
    )
    if not infobox_match:
        return None

    infobox = infobox_match.group(1)

    name_match = re.search(r'<p class="skill-name heading"><b>(.*?)</b></p>', infobox)
    name = html_to_text(name_match.group(1)) if name_match else None

    stats_match = re.search(r'<div class="skill-stats">(.*?)</div>', infobox, re.DOTALL)
    costs, activation, recharge = parse_skill_stats(stats_match.group(1)) if stats_match else (
        {'energy': None, 'adrenaline': None, 'upkeep': None, 'sacrifice': None, 'overcast': None},
        None,
        None,
    )

    profession_html = get_dl_value(infobox, 'Profession')
    profession = None
    if profession_html:
        prof_links = re.findall(r'title="([^"]*)"', profession_html)
        profession = prof_links[0] if prof_links else html_to_text(profession_html)

    attribute_html = get_dl_value(infobox, 'Attribute')
    attribute_name = None
    if attribute_html:
        attr_links = re.findall(r'title="([^"]*)"', attribute_html)
        attribute_name = attr_links[0] if attr_links else html_to_text(attribute_html)

    type_html = get_dl_value(infobox, 'Type')
    skill_type, is_elite = parse_type_field(type_html or '')

    campaign_html = get_dl_value(infobox, 'Campaign')
    campaign = parse_campaign(campaign_html or '') if campaign_html else None

    icon = parse_icon_url(infobox)
    concise_raw = parse_concise_description(html)
    progression_data = parse_progression_table(html)

    attribute = None
    if attribute_name or progression_data:
        attribute = {
            'name': attribute_name or (progression_data['attribute_name'] if progression_data else None),
            'progression': progression_data['progression'] if progression_data else {},
        }

    concise_description = wiki_concise_to_json_format(
        concise_raw,
        attribute['progression'] if attribute else {},
    )

    limitation = parse_limitation_from_type(type_html or '')
    if not limitation and profession and profession.lower() == 'monster':
        limitation = 'monster-only'

    return {
        'name': name,
        'icon': icon,
        'concise_description': concise_description,
        'type': skill_type,
        'profession': profession,
        'attribute': attribute,
        'costs': costs,
        'activation': activation,
        'recharge': recharge,
        'is_elite': is_elite,
        'campaign': campaign,
        'limitation': limitation,
    }


def values_equal(a, b):
    if a == b:
        return True
    if a is None and b is None:
        return True
    if a is None and b == 0:
        return True
    if b is None and a == 0:
        return True
    if isinstance(a, (int, float)) and isinstance(b, (int, float)):
        return float(a) == float(b)
    if isinstance(a, str) and isinstance(b, str):
        return a.strip().lower() == b.strip().lower()
    return False


def normalize_concise(text):
    if not text:
        return ''
    text = text.replace('[s]', '[s]')
    return ' '.join(text.split())


def compare_progression(json_prog, wiki_prog):
    if not json_prog and not wiki_prog:
        return True
    if not json_prog or not wiki_prog:
        return json_prog == wiki_prog
    if set(json_prog.keys()) != set(wiki_prog.keys()):
        return False
    for key in json_prog:
        if json_prog[key] != wiki_prog[key]:
            return False
    return True


def icon_paths_match(json_icon, wiki_icon, is_high_res, profession):
    if profession and profession.lower() == 'monster':
        return True
    if is_high_res:
        return True
    if not json_icon or not wiki_icon:
        return json_icon == wiki_icon

    def basename(url):
        return urllib.parse.unquote(url.split('/')[-1]).lower()

    return basename(json_icon) == basename(wiki_icon)


def find_correct_wiki_url(skill_name, existing_url=None):
    candidates = []
    if existing_url:
        candidates.append(existing_url)

    candidates.extend([
        build_wiki_url(skill_name),
        build_wiki_url(f'{skill_name} (skill)'),
        build_wiki_url(f'{skill_name} (monster_skill)'),
    ])

    if skill_name.startswith('"') and skill_name.endswith('"'):
        candidates.append(build_wiki_url(skill_name[1:-1]))
        candidates.append(build_wiki_url(f'{skill_name[1:-1]} (skill)'))
    else:
        candidates.append(build_wiki_url(f'"{skill_name}"'))
        candidates.append(build_wiki_url(f'"{skill_name}" (skill)'))

    pain_variant = re.match(r'^Pain \((.+)\)$', skill_name)
    if pain_variant and '(attack)' not in skill_name.lower():
        candidates.append(build_wiki_url(f'Pain (attack) ({pain_variant.group(1)})'))

    seen = set()
    for url in candidates:
        if url in seen:
            continue
        seen.add(url)
        html_content, page_name = fetch_wiki_html(url)
        if html_content and 'infobox skill-box' in html_content:
            parsed = parse_skill_from_html(html_content)
            if parsed and names_match(parsed.get('name'), skill_name):
                return url, html_content, page_name
        time.sleep(0.2)

    return None, None, None


def normalize_attribute(attr):
    if attr is None:
        return None
    if isinstance(attr, str):
        return {'name': attr, 'progression': {}}
    if isinstance(attr, dict):
        return attr
    return None


def compare_skill(skill, wiki_data, url):
    issues = []
    fixes = {}

    if not names_match(skill.get('name'), wiki_data.get('name')):
        issues.append(f'name mismatch: JSON={skill.get("name")} wiki={wiki_data.get("name")}')

    if skill.get('wiki_url') != url:
        fixes['wiki_url'] = url
        issues.append(f'wiki_url fixed to {url}')

    for field in ('profession', 'campaign', 'is_elite'):
        json_val = skill.get(field)
        wiki_val = wiki_data.get(field)
        if not values_equal(json_val, wiki_val):
            issues.append(f'{field}: JSON={json_val} wiki={wiki_val}')
            fixes[field] = wiki_val

    json_type = skill.get('type')
    wiki_type = wiki_data.get('type')
    if not types_equal(
        json_type,
        wiki_type,
        skill.get('is_elite', False),
        wiki_data.get('is_elite', False),
    ):
        issues.append(f'type: JSON={json_type} wiki={wiki_type}')
        if wiki_data.get('is_elite') and wiki_type:
            fixes['type'] = f'Elite {wiki_type}' if not wiki_type.lower().startswith('elite') else wiki_type
        else:
            fixes['type'] = wiki_type

    for field in ('activation', 'recharge'):
        json_val = skill.get(field)
        wiki_val = wiki_data.get(field)
        if wiki_val is None:
            continue
        if not values_equal(json_val, wiki_val):
            issues.append(f'{field}: JSON={json_val} wiki={wiki_val}')
            fixes[field] = wiki_val

    json_limitation = skill.get('limitation')
    wiki_limitation = wiki_data.get('limitation')
    if wiki_limitation and not values_equal(json_limitation, wiki_limitation):
        issues.append(f'limitation: JSON={json_limitation} wiki={wiki_limitation}')
        fixes['limitation'] = wiki_limitation

    json_costs = skill.get('costs') or {}
    wiki_costs = wiki_data.get('costs') or {}
    cost_fixes = {}
    for cost_key in ('energy', 'adrenaline', 'upkeep', 'sacrifice', 'overcast'):
        json_val = json_costs.get(cost_key)
        wiki_val = wiki_costs.get(cost_key)
        if not values_equal(json_val, wiki_val):
            issues.append(f'costs.{cost_key}: JSON={json_val} wiki={wiki_val}')
            cost_fixes[cost_key] = wiki_val
    if cost_fixes:
        fixes['costs'] = {**json_costs, **cost_fixes}

    json_attr = normalize_attribute(skill.get('attribute'))
    wiki_attr = wiki_data.get('attribute')
    if wiki_attr:
        if json_attr is None:
            issues.append('attribute missing in JSON')
            fixes['attribute'] = wiki_attr
        else:
            if not values_equal(json_attr.get('name'), wiki_attr.get('name')):
                issues.append(
                    f'attribute.name: JSON={json_attr.get("name")} wiki={wiki_attr.get("name")}'
                )
                fixes['attribute'] = {
                    'name': wiki_attr.get('name'),
                    'progression': wiki_attr.get('progression', {}),
                }
            elif not compare_progression(
                json_attr.get('progression', {}),
                wiki_attr.get('progression', {}),
            ):
                issues.append('attribute.progression mismatch')
                fixes['attribute'] = {
                    'name': json_attr.get('name'),
                    'progression': wiki_attr.get('progression', {}),
                }
    elif json_attr and json_attr.get('name') is not None and json_attr.get('progression'):
        issues.append('JSON has attribute but wiki has none')
        fixes['attribute'] = None

    wiki_concise = wiki_data.get('concise_description')
    json_concise = skill.get('concise_description')
    if wiki_concise and normalize_concise(json_concise) != normalize_concise(wiki_concise):
        issues.append(f'concise_description: JSON={json_concise} wiki={wiki_concise}')
        fixes['concise_description'] = wiki_concise

    is_high_res = skill.get('is_high_res_icon', False)
    if not icon_paths_match(skill.get('icon'), wiki_data.get('icon'), is_high_res, skill.get('profession')):
        if not is_high_res:
            issues.append(f'icon: JSON={skill.get("icon")} wiki={wiki_data.get("icon")}')
            fixes['icon'] = wiki_data.get('icon')

    return issues, fixes


def apply_fixes(skill, fixes):
    updated = copy.deepcopy(skill)
    for key, value in fixes.items():
        updated[key] = value
    return updated


def load_progress():
    if PROGRESS_FILE.exists():
        with open(PROGRESS_FILE, 'r') as f:
            return json.load(f)
    return {'completed': {}, 'stats': {'ok': 0, 'fixed': 0, 'failed': 0}}


def save_progress(progress):
    with open(PROGRESS_FILE, 'w') as f:
        json.dump(progress, f, indent=2)
        f.write('\n')


def save_report(report):
    with open(REPORT_FILE, 'w') as f:
        json.dump(report, f, indent=2)
        f.write('\n')


def process_file(file_path, dry_run=False, resume=False, delay=0.25):
    filename = file_path.name
    with open(file_path, 'r') as f:
        skills = json.load(f)

    progress = load_progress() if resume else {'completed': {}, 'stats': {'ok': 0, 'fixed': 0, 'failed': 0}}
    report = []
    if REPORT_FILE.exists() and resume:
        with open(REPORT_FILE, 'r') as f:
            report = json.load(f)

    file_key = filename
    completed_names = set(progress['completed'].get(file_key, []))

    for index, skill in enumerate(skills):
        if skill is None:
            continue

        skill_name = skill.get('name', f'index_{index}')
        if skill_name in completed_names:
            continue

        print(f'[{filename}] {skill_name}', flush=True)

        url = skill.get('wiki_url') or build_wiki_url(skill_name)
        html_content, page_name = fetch_wiki_html(url)
        wiki_data = parse_skill_from_html(html_content) if html_content else None

        if not wiki_data or not names_match(skill_name, wiki_data.get('name')):
            correct_url, html_content, page_name = find_correct_wiki_url(
                skill_name,
                skill.get('wiki_url'),
            )
            if correct_url:
                url = correct_url
                wiki_data = parse_skill_from_html(html_content)
                print(f'  URL corrected: {url}', flush=True)
            else:
                print(f'  FAILED: could not find wiki page', flush=True)
                progress['stats']['failed'] += 1
                report.append({
                    'file': filename,
                    'skill': skill_name,
                    'status': 'failed',
                    'error': 'wiki page not found',
                })
                completed_names.add(skill_name)
                progress['completed'][file_key] = list(completed_names)
                save_progress(progress)
                time.sleep(delay)
                continue

        issues, fixes = compare_skill(skill, wiki_data, url)

        if fixes:
            progress['stats']['fixed'] += 1
            print(f'  FIXED ({len(issues)} issues):', flush=True)
            for issue in issues:
                print(f'    - {issue}', flush=True)
            if not dry_run:
                skills[index] = apply_fixes(skill, fixes)
            report.append({
                'file': filename,
                'skill': skill_name,
                'status': 'fixed',
                'issues': issues,
                'fixes': fixes,
            })
        else:
            progress['stats']['ok'] += 1
            print(f'  OK', flush=True)
            report.append({
                'file': filename,
                'skill': skill_name,
                'status': 'ok',
            })

        completed_names.add(skill_name)
        progress['completed'][file_key] = list(completed_names)
        save_progress(progress)
        save_report(report)
        time.sleep(delay)

    if not dry_run:
        with open(file_path, 'w') as f:
            json.dump(skills, f, indent=2)
            f.write('\n')

    return progress['stats']


def main():
    parser = argparse.ArgumentParser(description='Verify and fix skills from Guild Wars Wiki')
    parser.add_argument('--file', type=str, help='Process a specific skill file')
    parser.add_argument('--all', action='store_true', help='Process all skill files')
    parser.add_argument('--dry-run', action='store_true', help='Report issues without saving')
    parser.add_argument('--resume', action='store_true', help='Resume from progress file')
    parser.add_argument('--delay', type=float, default=0.25, help='Delay between wiki requests')
    parser.add_argument('--reset', action='store_true', help='Clear progress and report files')

    args = parser.parse_args()

    if args.reset:
        if PROGRESS_FILE.exists():
            PROGRESS_FILE.unlink()
        if REPORT_FILE.exists():
            REPORT_FILE.unlink()
        print('Progress and report cleared.')

    if not args.file and not args.all:
        parser.print_help()
        return 1

    files = []
    if args.file:
        file_path = DATA_DIR / args.file
        if not file_path.exists():
            print(f'File not found: {file_path}')
            return 1
        files.append(file_path)
    else:
        files = sorted(DATA_DIR.glob('*.json'))

    total_stats = {'ok': 0, 'fixed': 0, 'failed': 0}

    for file_path in files:
        print(f'\n=== Processing {file_path.name} ===', flush=True)
        stats = process_file(file_path, dry_run=args.dry_run, resume=args.resume, delay=args.delay)
        for key in total_stats:
            total_stats[key] += stats.get(key, 0)

    print('\n=== FINAL SUMMARY ===', flush=True)
    print(f'OK: {total_stats["ok"]}', flush=True)
    print(f'Fixed: {total_stats["fixed"]}', flush=True)
    print(f'Failed: {total_stats["failed"]}', flush=True)

    if args.dry_run:
        print('(Dry run - no JSON changes saved)', flush=True)

    return 0 if total_stats['failed'] == 0 else 1


if __name__ == '__main__':
    sys.exit(main())
