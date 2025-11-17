#!/usr/bin/env python3
"""
Validate skill progression data to find issues:
1. Skills with progression but null attribute name
2. Skills with progression that only has a single rank key
3. Skills with progression variables that are likely constants (same value across all ranks)
"""

import json
import os
from pathlib import Path
from collections import defaultdict

def analyze_skill_progression(skill, filename):
    """Analyze a single skill for progression issues."""
    issues = []

    # Handle None skill (from monster.json apparently)
    if skill is None:
        return issues

    skill_name = skill.get('name', 'Unknown')
    attribute = skill.get('attribute')

    # Skip if no attribute field at all, or if attribute is not a dict (e.g., null in monster.json)
    if attribute is None or not isinstance(attribute, dict):
        return issues

    attribute_name = attribute.get('name')
    progression = attribute.get('progression', {})

    # Issue 1: Has progression data but attribute name is null
    # Check if progression dict has actual data (not just empty dict)
    has_progression_data = progression and len(progression) > 0

    if has_progression_data and attribute_name is None:
        issues.append({
            'type': 'NULL_ATTRIBUTE_WITH_PROGRESSION',
            'severity': 'CRITICAL',
            'skill': skill_name,
            'file': filename,
            'description': f'Has progression data but attribute name is null',
            'progression_vars': list(progression.keys()),
            'progression_data': progression
        })

    # Issue 2: Progression variables with only a single rank key
    if progression:
        for var_name, var_data in progression.items():
            if isinstance(var_data, dict):
                rank_count = len(var_data)
                if rank_count == 1:
                    issues.append({
                        'type': 'SINGLE_RANK_PROGRESSION',
                        'severity': 'HIGH',
                        'skill': skill_name,
                        'file': filename,
                        'attribute': attribute_name,
                        'variable': var_name,
                        'description': f'Variable "{var_name}" has only 1 rank key: {list(var_data.keys())}',
                        'data': var_data
                    })

                # Issue 3: All values are the same (likely a constant, not a progression)
                elif rank_count > 1:
                    values = list(var_data.values())
                    if len(set(values)) == 1:
                        # All values are the same - might be intentional (caps at higher ranks)
                        # or might be a data issue
                        issues.append({
                            'type': 'CONSTANT_VALUE_PROGRESSION',
                            'severity': 'LOW',
                            'skill': skill_name,
                            'file': filename,
                            'attribute': attribute_name,
                            'variable': var_name,
                            'description': f'Variable "{var_name}" has same value ({values[0]}) across all {rank_count} ranks',
                            'data': var_data
                        })

    return issues

def analyze_all_skills():
    """Analyze all skill JSON files."""
    script_dir = Path(__file__).parent
    data_dir = script_dir.parent / 'data' / 'skills'

    all_issues = []
    stats = defaultdict(int)

    # Get all JSON files except skill-types.json
    skill_files = [f for f in data_dir.glob('*.json') if f.name != 'skill-types.json']

    print(f"Analyzing {len(skill_files)} skill files...\n")

    for skill_file in sorted(skill_files):
        filename = skill_file.name

        try:
            with open(skill_file, 'r') as f:
                skills = json.load(f)

            stats['total_files'] += 1

            for skill in skills:
                if skill is None:
                    continue

                stats['total_skills'] += 1

                # Count skills with progression (actual data, not empty dict)
                attribute = skill.get('attribute')
                progression = {}
                if attribute and isinstance(attribute, dict):
                    progression = attribute.get('progression', {})
                if progression and len(progression) > 0:
                    stats['skills_with_progression'] += 1

                issues = analyze_skill_progression(skill, filename)
                all_issues.extend(issues)

                for issue in issues:
                    stats[issue['type']] += 1

        except Exception as e:
            import traceback
            print(f"ERROR processing {filename}: {e}")
            print(f"Traceback:")
            traceback.print_exc()

    return all_issues, stats

def print_report(issues, stats):
    """Print a formatted report of issues found."""

    print("=" * 80)
    print("SKILL PROGRESSION VALIDATION REPORT")
    print("=" * 80)
    print()

    print("STATISTICS:")
    print(f"  Total files analyzed: {stats['total_files']}")
    print(f"  Total skills analyzed: {stats['total_skills']}")
    print(f"  Skills with progression data: {stats['skills_with_progression']}")
    print()

    print("ISSUES FOUND:")
    print(f"  CRITICAL - Null attribute with progression: {stats['NULL_ATTRIBUTE_WITH_PROGRESSION']}")
    print(f"  HIGH     - Single rank progressions: {stats['SINGLE_RANK_PROGRESSION']}")
    print(f"  LOW      - Constant value progressions: {stats['CONSTANT_VALUE_PROGRESSION']}")
    print()

    # Group issues by severity
    critical_issues = [i for i in issues if i['severity'] == 'CRITICAL']
    high_issues = [i for i in issues if i['severity'] == 'HIGH']
    low_issues = [i for i in issues if i['severity'] == 'LOW']

    # Print CRITICAL issues
    if critical_issues:
        print("=" * 80)
        print("CRITICAL ISSUES: NULL ATTRIBUTE WITH PROGRESSION")
        print("=" * 80)
        print("These skills have progression data but attribute name is null.")
        print("This is WRONG - if there's no attribute, there should be no progression.\n")

        for issue in critical_issues:
            print(f"File: {issue['file']}")
            print(f"Skill: {issue['skill']}")
            print(f"Progression variables: {', '.join(issue['progression_vars'])}")
            print(f"Data: {json.dumps(issue['progression_data'], indent=2)}")
            print()

    # Print HIGH severity issues
    if high_issues:
        print("=" * 80)
        print("HIGH SEVERITY: SINGLE RANK PROGRESSIONS")
        print("=" * 80)
        print("These variables have only ONE rank key. They should either:")
        print("  a) Have multiple ranks showing how the value scales")
        print("  b) Not be in progression at all (just be constant values)\n")

        # Group by file
        by_file = defaultdict(list)
        for issue in high_issues:
            by_file[issue['file']].append(issue)

        for filename in sorted(by_file.keys()):
            print(f"\n{filename}:")
            for issue in by_file[filename]:
                print(f"  - {issue['skill']}")
                print(f"    Variable: {issue['variable']}")
                print(f"    Attribute: {issue['attribute']}")
                print(f"    Data: {issue['data']}")

    # Print summary of LOW severity issues (don't print all details)
    if low_issues:
        print("\n" + "=" * 80)
        print("LOW SEVERITY: CONSTANT VALUE PROGRESSIONS")
        print("=" * 80)
        print("These variables have the same value across all ranks.")
        print("This might be intentional (skills that cap at higher ranks).")
        print(f"Total: {len(low_issues)} instances")

        # Show a few examples
        print("\nExamples:")
        for issue in low_issues[:5]:
            print(f"  - {issue['file']}: {issue['skill']} -> {issue['variable']}")

def main():
    issues, stats = analyze_all_skills()
    print_report(issues, stats)

    # Return exit code based on critical issues
    if stats['NULL_ATTRIBUTE_WITH_PROGRESSION'] > 0 or stats['SINGLE_RANK_PROGRESSION'] > 0:
        return 1
    return 0

if __name__ == '__main__':
    exit(main())
