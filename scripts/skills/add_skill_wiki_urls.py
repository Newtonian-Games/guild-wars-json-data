#!/usr/bin/env python3
"""
Script to add wiki URLs to all skills in the JSON data files.
Uses the same encoding logic as add_skill_progression.py
"""

import json
import sys
import os
from pathlib import Path

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

def build_wiki_url(skill_name):
    """
    Build the full wiki URL for a skill.
    """
    encoded_name = encode_skill_name_for_url(skill_name)
    return f"https://wiki.guildwars.com/wiki/{encoded_name}"

def process_skill_file(file_path, dry_run=False):
    """
    Process a single skill file to add wiki URLs.

    Args:
        file_path: Path to the skill JSON file
        dry_run: If True, show what would be done without saving

    Returns: (success: bool, message: str)
    """
    try:
        with open(file_path, 'r') as f:
            skills = json.load(f)
    except Exception as e:
        return False, f"ERROR: Could not load {file_path}: {e}"

    if not isinstance(skills, list):
        return False, f"ERROR: Expected a list of skills in {file_path}"

    # Process each skill
    modified_count = 0
    for skill in skills:
        if 'name' not in skill:
            print(f"  WARNING: Skill without name field, skipping")
            continue

        skill_name = skill['name']
        wiki_url = build_wiki_url(skill_name)

        # Add or update the wiki_url field
        if 'wiki_url' not in skill or skill['wiki_url'] != wiki_url:
            skill['wiki_url'] = wiki_url
            modified_count += 1
            print(f"  {'[DRY RUN] ' if dry_run else ''}Added URL for: {skill_name}")
            print(f"    -> {wiki_url}")

    if modified_count == 0:
        return True, f"No changes needed (all {len(skills)} skills already have wiki URLs)"

    # Save the file if not dry run
    if not dry_run:
        try:
            with open(file_path, 'w') as f:
                json.dump(skills, f, indent=2)
                # Add newline at end of file
                f.write('\n')
        except Exception as e:
            return False, f"ERROR: Could not save {file_path}: {e}"

        return True, f"Successfully added wiki URLs to {modified_count} of {len(skills)} skills"
    else:
        return True, f"[DRY RUN] Would add wiki URLs to {modified_count} of {len(skills)} skills"

def main():
    """
    Main function to process skill files.
    """
    import argparse

    parser = argparse.ArgumentParser(description='Add wiki URLs to skills in JSON data files')
    parser.add_argument('--file', type=str, help='Process a specific file (e.g., common.json)')
    parser.add_argument('--all', action='store_true', help='Process all skill files')
    parser.add_argument('--dry-run', action='store_true', help='Show what would be done without saving')

    args = parser.parse_args()

    # Determine the data directory
    script_dir = Path(__file__).parent
    data_dir = script_dir.parent / 'data' / 'skills'

    if not data_dir.exists():
        print(f"ERROR: Skills directory not found: {data_dir}")
        return 1

    # Determine which files to process
    files_to_process = []

    if args.file:
        # Process specific file
        file_path = data_dir / args.file
        if not file_path.exists():
            print(f"ERROR: File not found: {file_path}")
            return 1
        files_to_process.append(file_path)
    elif args.all:
        # Process all JSON files (excluding skill-types.json which belongs in data/ not data/skills/)
        files_to_process = sorted([f for f in data_dir.glob('*.json') if f.name != 'skill-types.json'])
        if not files_to_process:
            print(f"ERROR: No JSON files found in {data_dir}")
            return 1
    else:
        print("ERROR: You must specify either --file or --all")
        parser.print_help()
        return 1

    # Process each file
    print(f"Processing {len(files_to_process)} file(s)...")
    if args.dry_run:
        print("(DRY RUN MODE - no changes will be saved)")
    print()

    success_count = 0
    failure_count = 0

    for file_path in files_to_process:
        print(f"Processing: {file_path.name}")
        success, message = process_skill_file(file_path, dry_run=args.dry_run)

        if success:
            print(f"  ✓ {message}")
            success_count += 1
        else:
            print(f"  ✗ {message}")
            failure_count += 1
        print()

    # Summary
    print("=== SUMMARY ===")
    print(f"Successful: {success_count}")
    print(f"Failed: {failure_count}")

    if args.dry_run:
        print("\n(Dry run - no changes saved)")

    return 0 if failure_count == 0 else 1

if __name__ == '__main__':
    sys.exit(main())
