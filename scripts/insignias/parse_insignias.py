#!/usr/bin/env python3
"""
Parse and generate insignias.json from Guild Wars Wiki.

This script should be run from the project root directory:
    cd /srv/www/build-wars
    python3 guild-wars-json-data/scripts/insignias/parse_insignias.py
"""
import json
import re
import os
import subprocess
import time
import urllib.parse

# Ensure we're working from the project root
if os.path.basename(os.getcwd()) in ['insignias', 'scripts']:
    os.chdir('/srv/www/build-wars')

# Load professions data for validation
with open('guild-wars-json-data/data/professions.json', 'r') as f:
    professions_data = json.load(f)
    profession_names = [p['name'] for p in professions_data]

def fetch_page(url):
    """Fetch a wiki page using curl."""
    try:
        result = subprocess.run(
            ['curl', '-s', url],
            capture_output=True,
            text=True,
            timeout=10
        )
        if result.returncode == 0:
            return result.stdout
        return None
    except Exception as e:
        print(f"  ⚠️  Error fetching {url}: {str(e)}")
        return None

def extract_insignia_names_from_main_page():
    """Extract all insignia names, professions, and effects from the main Insignia page."""
    print("Fetching main Insignia page...")
    html = fetch_page("https://wiki.guildwars.com/wiki/Insignia")
    if not html:
        return []

    insignias = []
    profession_map = {}
    effects_map = {}  # Store effects from main page table

    current_profession = None

    # Process HTML sequentially to track profession changes
    # Find all profession icons and table rows, then sort by position
    prof_positions = []
    prof_matches = re.finditer(r'File:([A-Za-z]+)-tango-icon-20\.png', html)
    for prof_match in prof_matches:
        prof_name = prof_match.group(1)
        prof_map = {
            'Any': None,
            'Warrior': 'Warrior',
            'Ranger': 'Ranger',
            'Monk': 'Monk',
            'Necromancer': 'Necromancer',
            'Mesmer': 'Mesmer',
            'Elementalist': 'Elementalist',
            'Assassin': 'Assassin',
            'Ritualist': 'Ritualist',
            'Paragon': 'Paragon',
            'Dervish': 'Dervish'
        }
        if prof_name in prof_map:
            prof_positions.append((prof_match.start(), prof_map[prof_name]))

    # Find all table rows with insignia name and effects
    # Pattern: <tr>...<td>...<a href="/wiki/...Insignia">Name</a></td><td>Effects</td>...</tr>
    # We want to match table rows, not list items (which don't have <tr>)
    row_positions = []
    # Match table rows containing insignia links
    tr_matches = re.finditer(r'<tr[^>]*>.*?</tr>', html, re.DOTALL)
    for tr_match in tr_matches:
        tr_html = tr_match.group(0)
        # Check if this row contains an insignia link and effects
        row_match = re.search(r'<td[^>]*>.*?<a href="/wiki/([^"]*Insignia)"[^>]*>([^<]+)</a>.*?</td>\s*<td[^>]*>(.*?)</td>', tr_html, re.DOTALL)
        if row_match:
            wiki_name = row_match.group(1)
            display_name = row_match.group(2)
            effects_text = row_match.group(3)

            # Skip category pages, special pages, and the main Insignia page itself
            if 'Category' in wiki_name or 'Special:' in wiki_name or wiki_name == 'Insignia':
                continue

            # Skip if this is a list row (contains multiple links separated by •)
            if '•' in effects_text or len(re.findall(r'<a href="/wiki/[^"]*Insignia"', tr_html)) > 1:
                continue

            row_positions.append((tr_match.start(), wiki_name, display_name, effects_text))

    # Process rows in order, tracking current profession
    current_profession = None
    prof_idx = 0

    for row_pos, wiki_name, display_name, effects_text in sorted(row_positions, key=lambda x: x[0]):
        # Update profession if we've passed a profession icon
        while prof_idx < len(prof_positions) and prof_positions[prof_idx][0] < row_pos:
            current_profession = prof_positions[prof_idx][1]
            prof_idx += 1

        # Decode HTML entities
        display_name = display_name.replace('&#39;', "'")

        if wiki_name not in profession_map:
            profession_map[wiki_name] = {
                'wiki_name': wiki_name,
                'display_name': display_name,
                'profession': current_profession
            }
            # Store effects text for later parsing (this also serves as description)
            effects_map[wiki_name] = effects_text

    # Parse effects for each insignia
    for wiki_name, effects_text in effects_map.items():
        profession_map[wiki_name]['effects_text'] = effects_text

    return list(profession_map.values())

def parse_insignia_page(wiki_name, profession):
    """Parse an individual insignia page to extract all data."""
    # wiki_name is already URL-encoded from the wiki (e.g., "Knight%27s_Insignia")
    # Just use it directly
    url = f"https://wiki.guildwars.com/wiki/{wiki_name}"
    html = fetch_page(url)

    if not html:
        return None

    insignia = {
        "name": None,
        "profession": profession,
        "requirements": None,
        "effects": {},
        "description": "",
        "wiki_url": url,
        "icon": None
    }

    # Extract name from infobox title
    name_match = re.search(r'<th[^>]*colspan="2"[^>]*>([^<]*Insignia)</th>', html)
    if name_match:
        name = name_match.group(1)
        name = name.replace('&#39;', "'").replace('&amp;', '&').strip()
        insignia["name"] = name
    else:
        # Fallback: construct name from wiki_name
        name = wiki_name.replace('_', ' ').replace('%27', "'")
        insignia["name"] = name

    # Extract profession from infobox if not already set
    if not profession:
        # Look for profession link in infobox
        prof_section = re.search(r'<th[^>]*>Profession</th>.*?<td>(.*?)</td>', html, re.DOTALL)
        if prof_section:
            prof_html = prof_section.group(1)
            for prof_name in profession_names:
                if prof_name in prof_html:
                    insignia["profession"] = prof_name
                    break

    # Extract requirements (e.g., "Requires 13 Strength")
    req_match = re.search(r'Requires (\d+)\s+<a[^>]*>([^<]+)</a>', html)
    if req_match:
        insignia["requirements"] = {
            "attribute": req_match.group(2),
            "value": int(req_match.group(1))
        }

    # Description will be set from main page effects text (see extract_insignia_names_from_main_page)

    # Parse infobox for effects (more reliable than Stats table)
    infobox_match = re.search(r'<table class="item-infobox".*?</table>', html, re.DOTALL)
    if infobox_match:
        infobox_html = infobox_match.group(0)
        parse_infobox_effects(infobox_html, html, insignia)

    # Also try Stats section for location-based effects
    stats_match = re.search(r'<h2[^>]*>Stats</h2>(.*?)(?:<h2|</div>|</body>)', html, re.DOTALL)
    if stats_match:
        stats_html = stats_match.group(1)
        parse_stats_table(stats_html, html, insignia)

    # If no effects found, try parsing from description/main content
    if not insignia["effects"]:
        parse_description_effects(html, insignia)

    return insignia


def parse_infobox_effects(infobox_html, full_html, insignia):
    """Parse effects from the infobox description."""
    # Look for effect descriptions in the infobox
    # Pattern: Health +15 (on chest armor)<br />Health +10 (on leg armor)<br />Health +5 (on other armor)

    # Health bonuses (location-based)
    health_match = re.search(r'Health\s+\+(\d+)\s+\(on chest[^)]*\)[^<]*Health\s+\+(\d+)\s+\(on leg[^)]*\)[^<]*Health\s+\+(\d+)\s+\(on other', infobox_html, re.IGNORECASE | re.DOTALL)
    if health_match:
        insignia["effects"]["HealthBonus"] = {
            "value": {
                "chest": int(health_match.group(1)),
                "leg": int(health_match.group(2)),
                "other": int(health_match.group(3))
            },
            "cumulative": True
        }

    # Energy bonuses (location-based)
    energy_match = re.search(r'Energy\s+\+(\d+)\s+\(on chest[^)]*\)[^<]*Energy\s+\+(\d+)\s+\(on leg[^)]*\)[^<]*Energy\s+\+(\d+)\s+\(on other', infobox_html, re.IGNORECASE | re.DOTALL)
    if energy_match:
        insignia["effects"]["EnergyBonus"] = {
            "value": {
                "chest": int(energy_match.group(1)),
                "leg": int(energy_match.group(2)),
                "other": int(energy_match.group(3))
            },
            "cumulative": True
        }

    # Armor bonuses
    armor_match = re.search(r'Armor\s+\+(\d+)', infobox_html, re.IGNORECASE)
    if armor_match:
        armor_value = int(armor_match.group(1))
        parse_armor_conditions(full_html, insignia, armor_value)

    # Physical damage reduction
    dmg_reduction_match = re.search(r'Received[^<]*physical damage[^<]*\-(\d+)', infobox_html, re.IGNORECASE)
    if dmg_reduction_match:
        insignia["effects"]["PhysicalDamageReduction"] = {
            "value": int(dmg_reduction_match.group(1)),
            "cumulative": True
        }

    # Hex duration reduction
    hex_match = re.search(r'Reduces[^<]*Hex[^<]*durations[^<]*by (\d+)%', infobox_html, re.IGNORECASE)
    if hex_match:
        hex_reduction = int(hex_match.group(1)) / 100.0
        insignia["effects"]["HexDurationReduction"] = {
            "value": hex_reduction,
            "cumulative": False
        }

    # Knockdown bonus
    knockdown_match = re.search(r'Increases[^<]*knockdown[^<]*time[^<]*by (\d+)[^<]*second', infobox_html, re.IGNORECASE)
    if knockdown_match:
        insignia["effects"]["KnockdownBonus"] = {
            "value": int(knockdown_match.group(1)),
            "cumulative": True
        }

    # Armor penalties
    armor_penalty_match = re.search(r'Armor[^<]*\-(\d+)', infobox_html, re.IGNORECASE)
    if armor_penalty_match and 'ArmorBonus' not in str(insignia["effects"]):
        insignia["effects"]["ArmorPenalty"] = {
            "value": -int(armor_penalty_match.group(1)),
            "cumulative": True
        }

    # Damage penalty
    dmg_penalty_match = re.search(r'damage dealt by you by (\d+)%', infobox_html, re.IGNORECASE)
    if dmg_penalty_match:
        insignia["effects"]["DamagePenalty"] = {
            "value": int(dmg_penalty_match.group(1)) / 100.0,
            "cumulative": False
        }

def parse_stats_table(stats_html, full_html, insignia):
    """Parse the stats table to extract location-based effects."""
    # The stats table has columns: Head, Chest, Arms, Legs, Feet
    # We'll map these to: other, chest, other, leg, other

    # Find table rows with effect data - use more flexible pattern
    rows = re.findall(r'<tr[^>]*>.*?</tr>', stats_html, re.DOTALL)

    for row in rows:
        # Check if this row contains Health data
        if 'Health' in row and '<a href="/wiki/Health"' in row:
            # Extract all td cells, then find numeric values
            # Pattern matches: <td>+5</td> or <td>+15</td> (may be on separate lines)
            health_values = re.findall(r'<td[^>]*>\s*\+(\d+)\s*</td>', row, re.MULTILINE)
            if len(health_values) >= 5:
                # Map: Head=0, Chest=1, Arms=2, Legs=3, Feet=4
                # Combine Head/Arms/Feet as "other"
                chest_val = int(health_values[1])
                leg_val = int(health_values[3])
                other_val = max(int(health_values[0]), int(health_values[2]), int(health_values[4]))

                insignia["effects"]["HealthBonus"] = {
                    "value": {
                        "chest": chest_val,
                        "leg": leg_val,
                        "other": other_val
                    },
                    "cumulative": True
                }

        # Check if this row contains Energy data
        if 'Energy' in row and '<a href="/wiki/Energy"' in row:
            energy_values = re.findall(r'<td[^>]*>\s*\+(\d+)\s*</td>', row, re.MULTILINE)
            if len(energy_values) >= 5:
                chest_val = int(energy_values[1])
                leg_val = int(energy_values[3])
                other_val = max(int(energy_values[0]), int(energy_values[2]), int(energy_values[4]))

                insignia["effects"]["EnergyBonus"] = {
                    "value": {
                        "chest": chest_val,
                        "leg": leg_val,
                        "other": other_val
                    },
                    "cumulative": True
                }

        # Check for Armor data
        if 'Armor' in row and '<a href="/wiki/Armor' in row:
            armor_values = re.findall(r'<td[^>]*>\s*\+(\d+)\s*</td>', row, re.MULTILINE)
            if armor_values:
                # Armor bonuses are usually the same across all locations
                armor_val = int(armor_values[0])
                # Check for conditions in the description
                parse_armor_conditions(full_html, insignia, armor_val)

def parse_armor_conditions(html, insignia, armor_value):
    """Parse armor bonus with conditions from HTML."""
    html_lower = html.lower()

    if 'while attacking' in html_lower:
        insignia["effects"]["ArmorBonusWhileAttacking"] = {
            "value": armor_value,
            "cumulative": False
        }
    elif 'while in a stance' in html_lower or 'while in stance' in html_lower:
        insignia["effects"]["ArmorBonusWhileInStance"] = {
            "value": armor_value,
            "cumulative": False
        }
    elif 'while affected by an enchantment' in html_lower:
        insignia["effects"]["ArmorBonusWhileEnchanted"] = {
            "value": armor_value,
            "cumulative": False
        }
    elif 'while holding an item' in html_lower or 'while holding a bundle' in html_lower:
        insignia["effects"]["ArmorBonusWhileHoldingBundle"] = {
            "value": armor_value,
            "cumulative": False
        }
    elif 'while using a preparation' in html_lower:
        insignia["effects"]["ArmorBonusWhileUsingPreparation"] = {
            "value": armor_value,
            "cumulative": False
        }
    elif 'while your pet is alive' in html_lower:
        insignia["effects"]["ArmorBonusWhilePetAlive"] = {
            "value": armor_value,
            "cumulative": False
        }
    elif 'while affected by a shout' in html_lower or 'while affected by an echo' in html_lower or 'while affected by a chant' in html_lower:
        insignia["effects"]["ArmorBonusWhileShoutEchoChant"] = {
            "value": armor_value,
            "cumulative": False
        }
    elif 'while not affected by an enchantment' in html_lower:
        insignia["effects"]["ArmorBonusWhileNotEnchanted"] = {
            "value": armor_value,
            "cumulative": False
        }
    elif 'vs. physical damage' in html_lower:
        insignia["effects"]["ArmorBonusVsPhysical"] = {
            "value": armor_value,
            "cumulative": False
        }
    elif 'vs. elemental damage' in html_lower:
        insignia["effects"]["ArmorBonusVsElemental"] = {
            "value": armor_value,
            "cumulative": False
        }
    elif 'vs. fire damage' in html_lower:
        insignia["effects"]["ArmorBonusVsFire"] = {
            "value": armor_value,
            "cumulative": False
        }
    elif 'vs. cold damage' in html_lower:
        insignia["effects"]["ArmorBonusVsCold"] = {
            "value": armor_value,
            "cumulative": False
        }
    elif 'vs. lightning damage' in html_lower:
        insignia["effects"]["ArmorBonusVsLightning"] = {
            "value": armor_value,
            "cumulative": False
        }
    elif 'vs. earth damage' in html_lower:
        insignia["effects"]["ArmorBonusVsEarth"] = {
            "value": armor_value,
            "cumulative": False
        }
    else:
        insignia["effects"]["ArmorBonus"] = {
            "value": armor_value,
            "cumulative": False
        }

def parse_main_table_effects_text(effects_text, insignia):
    """Parse effects from the main Insignia page table text."""
    # Health bonuses (location-based)
    # Pattern handles <br /> tags between entries
    health_match = re.search(r'Health\s+\+(\d+)\s+\(on chest[^)]*\)[^<]*(?:<br\s*/?>)?[^<]*Health\s+\+(\d+)\s+\(on leg[^)]*\)[^<]*(?:<br\s*/?>)?[^<]*Health\s+\+(\d+)\s+\(on other', effects_text, re.IGNORECASE | re.DOTALL)
    if health_match:
        insignia["effects"]["HealthBonus"] = {
            "value": {
                "chest": int(health_match.group(1)),
                "leg": int(health_match.group(2)),
                "other": int(health_match.group(3))
            },
            "cumulative": True
        }

    # Energy bonuses (location-based)
    energy_match = re.search(r'Energy\s+\+(\d+)\s+\(on chest[^)]*\)[^<]*(?:<br\s*/?>)?[^<]*Energy\s+\+(\d+)\s+\(on leg[^)]*\)[^<]*(?:<br\s*/?>)?[^<]*Energy\s+\+(\d+)\s+\(on other', effects_text, re.IGNORECASE | re.DOTALL)
    if energy_match:
        insignia["effects"]["EnergyBonus"] = {
            "value": {
                "chest": int(energy_match.group(1)),
                "leg": int(energy_match.group(2)),
                "other": int(energy_match.group(3))
            },
            "cumulative": True
        }

    # Armor bonuses
    armor_match = re.search(r'Armor\s+\+(\d+)', effects_text, re.IGNORECASE)
    if armor_match:
        armor_value = int(armor_match.group(1))
        effects_text_lower = effects_text.lower()

        if 'while attacking' in effects_text_lower:
            insignia["effects"]["ArmorBonusWhileAttacking"] = {
                "value": armor_value,
                "cumulative": False
            }
        elif 'while in a stance' in effects_text_lower or 'while in stance' in effects_text_lower:
            insignia["effects"]["ArmorBonusWhileInStance"] = {
                "value": armor_value,
                "cumulative": False
            }
        elif 'while affected by an enchantment' in effects_text_lower:
            insignia["effects"]["ArmorBonusWhileEnchanted"] = {
                "value": armor_value,
                "cumulative": False
            }
        elif 'while holding an item' in effects_text_lower or 'while holding a bundle' in effects_text_lower:
            insignia["effects"]["ArmorBonusWhileHoldingBundle"] = {
                "value": armor_value,
                "cumulative": False
            }
        elif 'while using a preparation' in effects_text_lower:
            insignia["effects"]["ArmorBonusWhileUsingPreparation"] = {
                "value": armor_value,
                "cumulative": False
            }
        elif 'while your pet is alive' in effects_text_lower:
            insignia["effects"]["ArmorBonusWhilePetAlive"] = {
                "value": armor_value,
                "cumulative": False
            }
        elif 'while affected by a shout' in effects_text_lower or 'while affected by an echo' in effects_text_lower or 'while affected by a chant' in effects_text_lower:
            insignia["effects"]["ArmorBonusWhileShoutEchoChant"] = {
                "value": armor_value,
                "cumulative": False
            }
        elif 'while not affected by an enchantment' in effects_text_lower:
            insignia["effects"]["ArmorBonusWhileNotEnchanted"] = {
                "value": armor_value,
                "cumulative": False
            }
        elif 'vs. physical damage' in effects_text_lower:
            insignia["effects"]["ArmorBonusVsPhysical"] = {
                "value": armor_value,
                "cumulative": False
            }
        elif 'vs. elemental damage' in effects_text_lower:
            insignia["effects"]["ArmorBonusVsElemental"] = {
                "value": armor_value,
                "cumulative": False
            }
        elif 'vs. fire damage' in effects_text_lower:
            insignia["effects"]["ArmorBonusVsFire"] = {
                "value": armor_value,
                "cumulative": False
            }
        elif 'vs. cold damage' in effects_text_lower:
            insignia["effects"]["ArmorBonusVsCold"] = {
                "value": armor_value,
                "cumulative": False
            }
        elif 'vs. lightning damage' in effects_text_lower:
            insignia["effects"]["ArmorBonusVsLightning"] = {
                "value": armor_value,
                "cumulative": False
            }
        elif 'vs. earth damage' in effects_text_lower:
            insignia["effects"]["ArmorBonusVsEarth"] = {
                "value": armor_value,
                "cumulative": False
            }
        else:
            insignia["effects"]["ArmorBonus"] = {
                "value": armor_value,
                "cumulative": False
            }

    # Physical damage reduction
    # Handle HTML tags in the text (e.g., <a href="/wiki/Physical_damage">physical damage</a>)
    # Note: Damage reduction effects don't stack with other sources - you get the highest value
    dmg_reduction_match = re.search(r'Received[^<]*(?:<[^>]+>)?[^<]*physical damage[^<]*(?:<[^>]+>)?[^<]*\-(\d+)', effects_text, re.IGNORECASE)
    if dmg_reduction_match:
        insignia["effects"]["PhysicalDamageReduction"] = {
            "value": int(dmg_reduction_match.group(1)),
            "cumulative": False
        }

    # Hex duration reduction
    # Handle HTML tags - use DOTALL to match across tags
    hex_match = re.search(r'Reduces.*?Hex.*?durations.*?by (\d+)%', effects_text, re.IGNORECASE | re.DOTALL)
    if hex_match:
        hex_reduction = int(hex_match.group(1)) / 100.0
        # Check if it says "Non-stacking" - handle HTML tags splitting the text
        # Pattern: "Non-" followed by HTML tags, then "stacking"
        is_non_stacking = bool(re.search(r'non-.*?stacking', effects_text, re.IGNORECASE | re.DOTALL)) or 'non-stackable' in effects_text.lower()
        insignia["effects"]["HexDurationReduction"] = {
            "value": hex_reduction,
            "cumulative": not is_non_stacking
        }

    # Knockdown bonus
    # Handle HTML tags (e.g., <a href="/wiki/Knockdown">knockdown</a>)
    knockdown_match = re.search(r'Increases[^<]*(?:<[^>]+>)?[^<]*knockdown[^<]*(?:<[^>]+>)?[^<]*time[^<]*by (\d+)[^<]*second', effects_text, re.IGNORECASE)
    if knockdown_match:
        insignia["effects"]["KnockdownBonus"] = {
            "value": int(knockdown_match.group(1)),
            "cumulative": True
        }

    # Armor penalties (check after armor bonuses to avoid false positives)
    # Only add if we don't already have an ArmorBonus effect
    if 'ArmorBonus' not in insignia["effects"]:
        armor_penalty_match = re.search(r'Armor[^<]*\-(\d+)', effects_text, re.IGNORECASE)
        if armor_penalty_match:
            insignia["effects"]["ArmorPenalty"] = {
                "value": -int(armor_penalty_match.group(1)),
                "cumulative": True
            }

    # Damage penalty
    dmg_penalty_match = re.search(r'damage dealt by you by (\d+)%', effects_text, re.IGNORECASE)
    if dmg_penalty_match:
        # Check if it says "Non-stacking" - handle HTML tags splitting the text
        # Pattern: "Non-" followed by HTML tags, then "stacking"
        is_non_stacking = bool(re.search(r'non-.*?stacking', effects_text, re.IGNORECASE | re.DOTALL)) or 'non-stackable' in effects_text.lower()
        insignia["effects"]["DamagePenalty"] = {
            "value": int(dmg_penalty_match.group(1)) / 100.0,
            "cumulative": not is_non_stacking
        }

    # Casting time reduction for corpse-exploiting spells (Bloodstained Insignia)
    casting_time_match = re.search(r'Reduces casting time of spells[^<]*(?:<[^>]+>)?[^<]*that exploit corpses by (\d+)%', effects_text, re.IGNORECASE)
    if casting_time_match:
        reduction = int(casting_time_match.group(1)) / 100.0
        insignia["effects"]["CastingTimeReductionCorpseSpells"] = {
            "value": reduction,
            "cumulative": False
        }

def check_stacking_info(wiki_url, insignia):
    """Check individual page for stacking information and update cumulative values."""
    html = fetch_page(wiki_url)
    if not html:
        return

    html_lower = html.lower()

    # Check for explicit "Non-stacking" or "Non-stackable" mentions
    # This is already handled in parse_main_table_effects_text, but double-check here
    if 'non-stacking' in html_lower or 'non-stackable' in html_lower:
        # Find which effects are mentioned as non-stacking
        for effect_key in list(insignia['effects'].keys()):
            # Check if this specific effect is mentioned as non-stacking
            if effect_key == "HexDurationReduction":
                if 'hex' in html_lower and ('non-stacking' in html_lower or 'non-stackable' in html_lower):
                    insignia['effects'][effect_key]['cumulative'] = False
            elif effect_key == "DamagePenalty":
                if 'damage dealt' in html_lower and ('non-stacking' in html_lower or 'non-stackable' in html_lower):
                    insignia['effects'][effect_key]['cumulative'] = False
            elif effect_key == "CastingTimeReductionCorpseSpells":
                if 'non-stacking' in html_lower or 'non-stackable' in html_lower:
                    insignia['effects'][effect_key]['cumulative'] = False

    # Check for effects that should be cumulative based on common sense
    # Health and Energy bonuses are typically cumulative (stacking)
    if "HealthBonus" in insignia['effects']:
        insignia['effects']["HealthBonus"]['cumulative'] = True
    if "EnergyBonus" in insignia['effects']:
        insignia['effects']["EnergyBonus"]['cumulative'] = True

    # Physical damage reduction is location-specific (non-stacking)
    if "PhysicalDamageReduction" in insignia['effects']:
        insignia['effects']["PhysicalDamageReduction"]['cumulative'] = False

    # Knockdown bonus (Stonefist) is explicitly non-stacking per wiki
    if "KnockdownBonus" in insignia['effects']:
        insignia['effects']["KnockdownBonus"]['cumulative'] = False

    # Armor penalty (Lieutenant's) is explicitly non-stacking per wiki
    if "ArmorPenalty" in insignia['effects']:
        insignia['effects']["ArmorPenalty"]['cumulative'] = False

    # Armor bonuses with conditions are typically non-cumulative (they're conditional)
    for effect_key in insignia['effects'].keys():
        if effect_key.startswith("ArmorBonus") and effect_key != "ArmorBonus":
            # Conditional armor bonuses are non-cumulative
            insignia['effects'][effect_key]['cumulative'] = False
        elif effect_key == "ArmorBonus":
            # Simple armor bonus without conditions - check if it's conditional in description
            if 'vs.' in html_lower or 'while' in html_lower:
                insignia['effects'][effect_key]['cumulative'] = False
            else:
                insignia['effects'][effect_key]['cumulative'] = False  # Armor bonuses don't stack

def parse_description_effects(html, insignia):
    """Parse effects from the main description text."""
    html_lower = html.lower()

    # Physical damage reduction
    dmg_reduction_match = re.search(r'Received[^<]*physical damage[^<]*\-(\d+)', html, re.IGNORECASE)
    if dmg_reduction_match:
        insignia["effects"]["PhysicalDamageReduction"] = {
            "value": int(dmg_reduction_match.group(1)),
            "cumulative": False
        }

    # Hex duration reduction
    hex_match = re.search(r'Reduces[^<]*Hex[^<]*durations[^<]*by (\d+)%', html, re.IGNORECASE)
    if hex_match:
        hex_reduction = int(hex_match.group(1)) / 100.0
        insignia["effects"]["HexDurationReduction"] = {
            "value": hex_reduction,
            "cumulative": False
        }

    # Knockdown bonus
    knockdown_match = re.search(r'Increases[^<]*knockdown[^<]*time[^<]*by (\d+)[^<]*second', html, re.IGNORECASE)
    if knockdown_match:
        insignia["effects"]["KnockdownBonus"] = {
            "value": int(knockdown_match.group(1)),
            "cumulative": False
        }

    # Armor penalties
    armor_penalty_match = re.search(r'Armor[^<]*\-(\d+)', html, re.IGNORECASE)
    if armor_penalty_match and 'ArmorBonus' not in str(insignia["effects"]):
        insignia["effects"]["ArmorPenalty"] = {
            "value": -int(armor_penalty_match.group(1)),
            "cumulative": False
        }

    # Damage penalty
    dmg_penalty_match = re.search(r'damage dealt by you by (\d+)%', html, re.IGNORECASE)
    if dmg_penalty_match:
        insignia["effects"]["DamagePenalty"] = {
            "value": int(dmg_penalty_match.group(1)) / 100.0,
            "cumulative": False
        }

# Main execution
print("=" * 80)
print("Parsing Insignias from Guild Wars Wiki")
print("=" * 80)

# Load existing insignias to preserve icon URLs
existing_icons = {}
output_file = 'guild-wars-json-data/data/insignias.json'
if os.path.exists(output_file):
    try:
        with open(output_file, 'r') as f:
            existing_data = json.load(f)
            existing_icons = {item['name']: item.get('icon') for item in existing_data if item.get('icon')}
            print(f"Loaded {len(existing_icons)} existing icon URLs to preserve")
    except Exception as e:
        print(f"Note: Could not load existing data: {e}")

# Extract all insignia names
insignia_list = extract_insignia_names_from_main_page()
print(f"\nFound {len(insignia_list)} insignias to parse")

insignias = []

for i, insignia_info in enumerate(insignia_list):
    wiki_name = insignia_info['wiki_name']
    profession = insignia_info['profession']
    effects_text = insignia_info.get('effects_text', '')

    print(f"\n[{i+1}/{len(insignia_list)}] Parsing: {wiki_name}")

    insignia = parse_insignia_page(wiki_name, profession)

    if insignia and insignia['name']:
        # Always parse effects from main page table (most reliable source)
        if effects_text:
            parse_main_table_effects_text(effects_text, insignia)

        # Set description from effects text (convert <br /> to {{br}})
        if effects_text:
            description = effects_text.strip()
            # Remove HTML tags but preserve <br /> for conversion
            # First, convert <br /> and <br> to {{br}}
            description = re.sub(r'<br\s*/?>', '{{br}}', description)
            # Remove other HTML tags
            description = re.sub(r'<[^>]+>', '', description)
            # Decode HTML entities
            description = description.replace('&#39;', "'").replace('&amp;', '&')
            # Clean up whitespace
            description = re.sub(r'\s+', ' ', description).strip()
            insignia['description'] = description

        # Check individual page for stacking information to fix cumulative values
        check_stacking_info(insignia['wiki_url'], insignia)

        # Preserve existing icon URL if available
        if insignia['name'] in existing_icons:
            insignia['icon'] = existing_icons[insignia['name']]

        insignias.append(insignia)
        print(f"  ✓ {insignia['name']}")
        if insignia['effects']:
            print(f"    Effects: {', '.join(insignia['effects'].keys())}")
    else:
        print(f"  ❌ Failed to parse")

    # Be nice to the wiki server
    time.sleep(0.5)

# Sort by name
insignias.sort(key=lambda x: x['name'])

# Write to JSON file
with open(output_file, 'w') as f:
    json.dump(insignias, f, indent=2)

print("\n" + "=" * 80)
print(f"Generated {len(insignias)} insignias")
print(f"Saved to {output_file}")
