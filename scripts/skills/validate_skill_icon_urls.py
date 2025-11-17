#!/usr/bin/env python3
"""
Validate skill icon URLs to ensure they return actual image files.

This script checks that all icon URLs in skill JSON files return valid
image content (not HTML error pages or other non-image content).

Usage:
    cd /srv/www/build-wars
    python3 guild-wars-json-data/scripts/skills/validate_skill_icon_urls.py
"""
import json
import os
import sys
import subprocess
import time
from collections import defaultdict

# Ensure we're working from the project root
if os.path.basename(os.getcwd()) in ['skills', 'scripts']:
    os.chdir('/srv/www/build-wars')

SKILLS_DIR = 'guild-wars-json-data/data/skills'

def check_url_content_type(url):
    """
    Check the Content-Type of a URL using curl HEAD request.
    Returns (success, content_type, status_code, error_message)
    """
    try:
        # Use curl with HEAD request to check Content-Type without downloading the file
        result = subprocess.run(
            ['curl', '-sI', '-L', '--max-time', '10', url],
            capture_output=True,
            text=True,
            timeout=15
        )

        if result.returncode != 0:
            return (False, None, None, f"curl failed with code {result.returncode}")

        headers = result.stdout

        # Parse status code
        status_line = headers.split('\n')[0]
        status_code = None
        if 'HTTP' in status_line:
            parts = status_line.split()
            if len(parts) >= 2:
                try:
                    status_code = int(parts[1])
                except ValueError:
                    pass

        # Parse Content-Type header
        content_type = None
        for line in headers.split('\n'):
            if line.lower().startswith('content-type:'):
                content_type = line.split(':', 1)[1].strip()
                break

        # Check if it's an image
        if content_type and content_type.lower().startswith('image/'):
            return (True, content_type, status_code, None)
        else:
            return (False, content_type, status_code, f"Non-image content type: {content_type}")

    except subprocess.TimeoutExpired:
        return (False, None, None, "Request timeout")
    except Exception as e:
        return (False, None, None, f"Exception: {str(e)}")

def load_all_icon_urls():
    """Load all unique icon URLs from skill JSON files."""
    icon_urls = {}  # url -> list of (filename, skill_name)

    for filename in os.listdir(SKILLS_DIR):
        if filename.endswith('.json') and filename != 'skill-types.json':
            filepath = os.path.join(SKILLS_DIR, filename)
            with open(filepath, 'r') as f:
                skills = json.load(f)
                for skill in skills:
                    icon = skill.get('icon')
                    if icon:
                        if icon not in icon_urls:
                            icon_urls[icon] = []
                        icon_urls[icon].append((filename, skill['name']))

    return icon_urls

def main():
    print("=" * 80)
    print("VALIDATING SKILL ICON URLS")
    print("=" * 80)
    print()

    # Load all icon URLs
    print("Loading skill icon URLs...")
    icon_urls = load_all_icon_urls()
    total_unique_urls = len(icon_urls)
    total_usages = sum(len(usages) for usages in icon_urls.values())
    print(f"✓ Found {total_unique_urls} unique icon URLs")
    print(f"✓ Used {total_usages} times across all skills")
    print()

    # Check each URL
    print("Checking URLs (this may take a few minutes)...")
    print("=" * 80)

    valid_urls = []
    invalid_urls = []
    checked = 0

    for url, usages in icon_urls.items():
        checked += 1

        # Show progress
        if checked % 10 == 0:
            print(f"Progress: {checked}/{total_unique_urls} URLs checked...", end='\r')

        # Check the URL
        success, content_type, status_code, error = check_url_content_type(url)

        if success:
            valid_urls.append((url, content_type, status_code, usages))
        else:
            invalid_urls.append((url, content_type, status_code, error, usages))

        # Small delay to be respectful to the server
        time.sleep(0.1)

    print(" " * 80, end='\r')  # Clear progress line
    print("=" * 80)
    print()

    # Report results
    print("=" * 80)
    print("VALIDATION RESULTS")
    print("=" * 80)
    print()
    print(f"Total unique URLs checked:  {total_unique_urls}")
    print(f"✓ Valid image URLs:         {len(valid_urls)}")
    print(f"✗ Invalid/Error URLs:       {len(invalid_urls)}")
    print()

    if len(valid_urls) == total_unique_urls:
        print("🎉 All icon URLs are valid!")
    else:
        print(f"⚠️  {len(invalid_urls)} URL(s) have issues")

    print()

    # Show content type breakdown for valid URLs
    if valid_urls:
        content_types = defaultdict(int)
        for url, content_type, status_code, usages in valid_urls:
            content_types[content_type] += 1

        print("=" * 80)
        print("VALID URLs - Content Type Breakdown")
        print("=" * 80)
        for ct, count in sorted(content_types.items(), key=lambda x: -x[1]):
            print(f"  {ct}: {count} URLs")
        print()

    # Report invalid URLs
    if invalid_urls:
        print("=" * 80)
        print(f"INVALID URLs ({len(invalid_urls)} found)")
        print("=" * 80)
        print()

        for url, content_type, status_code, error, usages in invalid_urls:
            print(f"✗ {url}")
            print(f"  Status: {status_code if status_code else 'N/A'}")
            print(f"  Content-Type: {content_type if content_type else 'N/A'}")
            print(f"  Error: {error}")
            print(f"  Used by {len(usages)} skill(s):")
            for filename, skill_name in usages[:3]:  # Show first 3
                print(f"    - {skill_name} ({filename})")
            if len(usages) > 3:
                print(f"    ... and {len(usages) - 3} more")
            print()

    # Summary statistics
    print("=" * 80)
    print("SUMMARY")
    print("=" * 80)
    total_affected_skills = sum(len(usages) for _, _, _, _, usages in invalid_urls)
    print(f"Total skills with valid icons:   {total_usages - total_affected_skills}")
    print(f"Total skills with invalid icons: {total_affected_skills}")
    print()

    if invalid_urls:
        return 1
    return 0

if __name__ == '__main__':
    sys.exit(main())
