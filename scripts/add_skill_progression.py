#!/usr/bin/env python3
"""
Script to add progression data to skills from the Guild Wars Wiki.
This script fetches EXACT values from wiki progression tables - NO GUESSING OR INTERPOLATION.

NOTE: This script does NOT update descriptions. Description updates require manual review
to ensure patterns are matched to the correct variables based on context.
"""

import json
import subprocess
import re
import sys
import time
import copy

def to_upper_camel_case(text):
    """
    Convert a variable name to UpperCamelCase with only letters.
    Examples:
        "Health degeneration" -> "HealthDegeneration"
        "+ Health degeneration" -> "PlusHealthDegeneration"
        "- Health degeneration" -> "MinusHealthDegeneration"
        "Damage (on death)" -> "DamageOnDeath"
        "Energy cost" -> "EnergyCost"
        "Life stealing" -> "LifeStealing"
        "% of Damage" -> "PercentOfDamage"
    """
    # Convert special symbols to words before processing
    text = text.replace('%', ' Percent ')
    text = text.replace('+', ' Plus ')
    text = text.replace('-', ' Minus ')
    # Remove everything that's not a letter or space
    text = re.sub(r'[^a-zA-Z\s]', '', text)
    # Split on whitespace and capitalize each word
    words = text.split()
    # Join with no spaces
    return ''.join(word.capitalize() for word in words if word)

def encode_skill_name_for_url(skill_name):
    """
    Encode skill name for wiki URL.
    - Replace spaces with underscores
    - Replace quotes with %22
    - Replace apostrophes with %27
    """
    # Replace spaces with underscores first
    encoded = skill_name.replace(' ', '_')
    # Replace quotes
    encoded = encoded.replace('"', '%22')
    # Replace apostrophes
    encoded = encoded.replace("'", '%27')
    return encoded

def fetch_wiki_html(skill_name):
    """
    Fetch the HTML content from the wiki page for a skill.
    Returns: HTML string or None if fetch fails
    """
    encoded_name = encode_skill_name_for_url(skill_name)
    url = f"https://wiki.guildwars.com/wiki/{encoded_name}"

    try:
        result = subprocess.run(
            ['curl', '-s', url],
            capture_output=True,
            text=True,
            timeout=15
        )
        if result.returncode == 0 and result.stdout:
            return result.stdout
        return None
    except Exception as e:
        print(f"ERROR: Failed to fetch wiki page for '{skill_name}': {e}")
        return None

def parse_progression_table(html):
    """
    Parse the progression table from wiki HTML.

    Returns: dict with structure:
        {
            'attribute_name': str,  # e.g., "Death Magic" or "Sunspear rank"
            'max_rank': int,        # e.g., 21 or 10
            'variables': {
                'VariableName': {
                    '0': value,
                    '1': value,
                    ...
                }
            }
        }

    Returns None if no progression table found or if parsing fails.
    """
    # Try DIV-based format first
    prog_match = re.search(r'<th colspan="2">Progression.*?</td></tr>', html, re.DOTALL)
    if prog_match:
        return parse_div_based_progression(prog_match.group(0))

    # Try TABLE-based format (older wiki format)
    prog_match = re.search(r'<td colspan="\d+"><b>Progression</b>.*?</table>', html, re.DOTALL)
    if prog_match:
        return parse_table_based_progression(prog_match.group(0))

    return None

def parse_table_based_progression(table_html):
    """
    Parse the older TABLE-based progression format.
    Format example:
    <td colspan="7"><b>Progression</b></td>
    <tr><th>Attribute name</th><td>0</td><td>1</td>...</tr>
    <tr><th>Variable name</th><td>val0</td><td>val1</td>...</tr>
    """
    # Extract all table rows
    rows = re.findall(r'<tr[^>]*>(.*?)</tr>', table_html, re.DOTALL)
    if len(rows) < 2:
        return None

    # First row should have attribute name and rank values
    first_row_cells = re.findall(r'<t[hd][^>]*>(.*?)</t[hd]>', rows[0], re.DOTALL)
    if not first_row_cells:
        return None

    # Extract attribute name from first cell
    attr_text = re.sub(r'<[^>]+>', ' ', first_row_cells[0])
    attr_text = attr_text.strip()

    # Extract rank values from remaining cells in first row
    rank_values = []
    for cell in first_row_cells[1:]:
        cell_text = re.sub(r'<[^>]+>', '', cell).strip()
        try:
            rank_values.append(str(int(cell_text)))
        except ValueError:
            continue

    if not rank_values:
        return None

    max_rank = max([int(r) for r in rank_values])

    # Parse subsequent rows for variable data
    variables = {}
    for row in rows[1:]:
        cells = re.findall(r'<t[hd][^>]*>(.*?)</t[hd]>', row, re.DOTALL)
        if len(cells) < 2:
            continue

        # First cell is variable name
        var_text = re.sub(r'<[^>]+>', ' ', cells[0])
        var_text = var_text.replace('&#160;', ' ').replace('%', '').strip()
        var_text = ' '.join(var_text.split())

        if not var_text:
            continue

        # Remaining cells are values
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

    if not variables:
        return None

    return {
        'attribute_name': attr_text,
        'max_rank': max_rank,
        'variables': variables
    }

def parse_div_based_progression(prog_html):
    """Parse the newer DIV-based progression table format."""
    # Split into left side (labels) and right side (data)
    # Extract the row after the header
    row_match = re.search(r'</th></tr>\s*<tr[^>]*>(.*)', prog_html, re.DOTALL)
    if not row_match:
        return None

    row_content = row_match.group(1)

    # Extract both <td> sections using regex (handles any attributes)
    td_matches = re.findall(r'<td[^>]*>(.*?)</td>', row_content, re.DOTALL)
    if len(td_matches) < 2:
        return None

    left_side = td_matches[0]
    right_side = td_matches[1]

    # Extract attribute name from left side
    attr_match = re.search(r'<div class="attr[^"]*"><a[^>]*>([^<]+)</a></div>', left_side)
    if not attr_match:
        # Try alternate pattern without link (for some skills like Stone Daggers)
        attr_match = re.search(r'<div class="attr[^"]*">([^<]+)</div>', left_side)
        if not attr_match:
            return None

    attribute_name = attr_match.group(1).strip()

    # Extract variable names from left side (skip the first one which is the attribute)
    # Need to extract all text content from <div class="var">...</div>, including text from multiple links
    var_div_matches = re.findall(r'<div class="var[^"]*">(.*?)</div>', left_side, re.DOTALL)
    var_divs = []
    for var_html in var_div_matches:
        # Remove all HTML tags and get the text content
        text = re.sub(r'<[^>]+>', ' ', var_html)
        # Clean up HTML entities and extra whitespace (but keep % as it's part of variable names)
        text = text.replace('&#160;', ' ').strip()
        text = ' '.join(text.split())  # Normalize whitespace
        var_divs.append(text)
    if not var_divs:
        return None

    # Extract all columns from right side
    columns = re.findall(r'<div class="column"[^>]*>(.*?)</div>\s*(?=<div class="column|</td>|$)', right_side, re.DOTALL)
    if not columns:
        return None

    # Determine max rank from the columns
    attr_levels = []
    for column in columns:
        attr_match = re.search(r'<div class="attr">(\d+)</div>', column)
        if attr_match:
            attr_levels.append(int(attr_match.group(1)))

    if not attr_levels:
        return None

    max_rank = max(attr_levels)

    # Parse each column to build progression data
    variables = {}
    for var_name in var_divs:
        variables[var_name] = {}

    for column in columns:
        # Extract attribute level
        attr_match = re.search(r'<div class="attr">(\d+)</div>', column)
        if not attr_match:
            continue

        attr_level = attr_match.group(1)

        # Extract all variable values in this column
        var_values = re.findall(r'<div class="var">([^<]+)</div>', column)

        # Verify counts match - if not, we have a parsing problem
        if len(var_values) != len(var_divs):
            print(f"WARNING: Column at rank {attr_level} has {len(var_values)} values but expected {len(var_divs)}")
            continue

        # Match values to variable names
        for var_name, value in zip(var_divs, var_values):
            # Clean the value (remove %, convert to int/float)
            value_clean = value.strip().replace('%', '')
            try:
                # Try to parse as int first, then float
                if '.' in value_clean:
                    parsed_value = float(value_clean)
                else:
                    parsed_value = int(value_clean)
            except ValueError:
                # If parsing fails, keep as string
                parsed_value = value_clean

            variables[var_name][attr_level] = parsed_value

    return {
        'attribute_name': attribute_name,
        'max_rank': max_rank,
        'variables': variables
    }

def process_skill(skill, force=False):
    """
    Process a single skill to add progression data.

    Args:
        skill: The skill dict to process
        force: If True, process even if progression data already exists

    Returns: (success: bool, message: str, updated_skill: dict or None)
    """
    skill_name = skill.get('name', 'Unknown')

    # Check if skill needs processing
    if not skill.get('attribute'):
        return False, f"No attribute field", None

    if skill['attribute'].get('name') is None:
        return False, f"Attribute name is null - skipping", None

    # Only skip if already has progression AND we're not forcing
    if not force and skill['attribute'].get('progression') and len(skill['attribute']['progression']) > 0:
        return False, f"Already has progression data - skipping", None

    # Fetch wiki HTML
    html = fetch_wiki_html(skill_name)

    if not html:
        return False, f"Could not fetch wiki page", None

    # Parse progression table
    prog_data = parse_progression_table(html)

    if not prog_data:
        return False, f"No progression table found - skipping", None

    # Verify attribute names match
    wiki_attr = prog_data['attribute_name']
    skill_attr = skill['attribute']['name']

    # Some flexibility in matching (e.g., "Death Magic" in both)
    # But we should warn if they don't match
    if wiki_attr.lower() != skill_attr.lower():
        print(f"  WARNING: Attribute mismatch - JSON has '{skill_attr}', wiki has '{wiki_attr}'")

    # Convert variable names to UpperCamelCase
    progression = {}
    original_to_camel = {}  # Track the mapping

    for original_var_name, values in prog_data['variables'].items():
        camel_name = to_upper_camel_case(original_var_name)
        if not camel_name:
            print(f"  WARNING: Could not convert '{original_var_name}' to valid variable name")
            continue

        progression[camel_name] = values
        original_to_camel[original_var_name] = camel_name

    if not progression:
        return False, f"No valid progression variables found", None

    # Update the skill
    updated_skill = copy.deepcopy(skill)
    updated_skill['attribute']['progression'] = progression

    # Show what variables were added
    print(f"  Added progression variables: {list(progression.keys())}")

    return True, f"Successfully added progression data", updated_skill

def main():
    """
    Main function to process skills.
    """
    import argparse

    parser = argparse.ArgumentParser(description='Add progression data to skills from Guild Wars Wiki')
    parser.add_argument('--skill', type=str, help='Process a single skill by name')
    parser.add_argument('--count', type=int, help='Number of skills to process (finds first X that need processing)', default=1)
    parser.add_argument('--dry-run', action='store_true', help='Show what would be done without saving')
    parser.add_argument('--profession', type=str, help='Process skills for a specific profession (e.g., Necromancer)')

    args = parser.parse_args()

    # Load skills/elementalist.json
    skills_path = '../data/skills/elementalist.json'
    try:
        with open(skills_path, 'r') as f:
            skills = json.load(f)
    except Exception as e:
        print(f"ERROR: Could not load skills/elementalist.json: {e}")
        return 1

    print(f"Loaded {len(skills)} skills")

    # Filter skills to process
    skills_to_process = []

    if args.skill:
        # Process specific skill
        for skill in skills:
            if skill.get('name') == args.skill:
                skills_to_process.append(skill)
                break
        if not skills_to_process:
            print(f"ERROR: Skill '{args.skill}' not found")
            return 1
    elif args.profession:
        # Process skills for a profession
        for skill in skills:
            if skill.get('profession') == args.profession:
                if skill.get('attribute', {}).get('name') is not None:
                    if not skill.get('attribute', {}).get('progression') or len(skill['attribute']['progression']) == 0:
                        skills_to_process.append(skill)
        print(f"Found {len(skills_to_process)} {args.profession} skills needing progression data")
    else:
        # Find skills that need progression data (get more than needed in case some fail)
        for skill in skills:
            if skill.get('attribute', {}).get('name') is not None:
                if not skill.get('attribute', {}).get('progression') or len(skill['attribute']['progression']) == 0:
                    skills_to_process.append(skill)
        print(f"Found {len(skills_to_process)} total skills needing progression data")
        print(f"Will process until {args.count} successful")

    if not skills_to_process:
        print("No skills to process")
        return 0

    # Process each skill
    successful = 0
    failed = 0
    skipped = 0
    attempted = 0

    # Determine target count based on mode
    if args.skill:
        target_count = 1  # Just process the one skill
    elif args.profession:
        target_count = len(skills_to_process)  # Process all for profession
    else:
        target_count = args.count  # Process until we have this many successful

    for skill in skills_to_process:
        # Stop if we've reached our target (unless doing specific skill or profession)
        if not args.skill and not args.profession and successful >= target_count:
            break

        attempted += 1
        print(f"\n[Attempt {attempted}, Success {successful}/{target_count}] Processing: {skill.get('name')}")

        success, message, updated_skill = process_skill(skill, force=bool(args.skill))

        if success:
            print(f"  ✓ {message}")
            successful += 1

            if not args.dry_run:
                # Update the skill in the original list
                skill_name = skill.get('name')
                for j, s in enumerate(skills):
                    if s.get('name') == skill_name:
                        skills[j] = updated_skill
                        break

                # Save after each successful update
                try:
                    with open(skills_path, 'w') as f:
                        json.dump(skills, f, indent=2)
                except Exception as e:
                    print(f"  ERROR: Could not save skills/elementalist.json: {e}")
                    return 1
        elif "skipping" in message.lower():
            print(f"  - {message}")
            skipped += 1
        else:
            print(f"  ✗ {message}")
            failed += 1

        # Be respectful to the wiki server
        time.sleep(0.5)

    # Summary
    print(f"\n=== SUMMARY ===")
    print(f"Attempted: {attempted}")
    print(f"Successful: {successful}")
    print(f"Failed: {failed}")
    print(f"Skipped: {skipped}")

    if args.dry_run:
        print("\n(Dry run - no changes saved)")
    elif successful > 0:
        print(f"\n(Changes saved after each successful update)")

    return 0

if __name__ == '__main__':
    sys.exit(main())
