#!/usr/bin/env python3
"""
Parse and generate runes.json from attributes and professions data.

This script should be run from the project root directory:
    cd /srv/www/build-wars
    python3 guild-wars-json-data/scripts/runes/parse_runes.py
"""
import json
import re
import os

# Ensure we're working from the project root
# Change to project root if we're in the scripts directory
if os.path.basename(os.getcwd()) in ['runes', 'scripts']:
    os.chdir('/srv/www/build-wars')

# Load existing attributes data
with open('guild-wars-json-data/data/attributes.json', 'r') as f:
    attributes = json.load(f)

# Load professions data
with open('guild-wars-json-data/data/professions.json', 'r') as f:
    professions = json.load(f)

def get_rune_icon(profession, rarity):
    """Generate the icon URL for a rune based on profession and rarity."""
    base_url = "https://wiki.guildwars.com/images/"

    # Map rarity to wiki tier naming
    rarity_to_tier = {
        "common": "Minor",
        "uncommon": "Major",
        "rare": "Sup"
    }

    tier = rarity_to_tier.get(rarity, "Minor")

    if profession:
        # Profession-specific rune icons: Rune_{Profession}_{Tier}.png
        filename = f"Rune_{profession}_{tier}.png"
    else:
        # Universal rune icons: Rune_All_{Tier}.png
        filename = f"Rune_All_{tier}.png"

    # Wiki uses underscores in filenames
    return f"{base_url}{filename}"

runes = []

# Get profession attributes (excluding null and rank attributes)
profession_attributes = [attr for attr in attributes if attr['profession'] is not None and 'rank' not in (attr['name'] or '').lower()]

# 1. Generate attribute-based runes (Minor, Major, Superior for each attribute)
for attribute in profession_attributes:
    attr_name = attribute['name']
    profession = attribute['profession']

    # Minor rune
    rune_name = f"Rune of Minor {attr_name}"
    runes.append({
        "name": rune_name,
        "type": "armor",
        "rarity": "common",
        "profession": profession,
        "attribute": attr_name,
        "icon": get_rune_icon(profession, "common"),
        "effects": {
            "AttributeBonus": {
                "value": 1,
                "cumulative": False
            }
        },
        "description": f"{attr_name} +1 (Non-stacking)",
        "wiki_url": f"https://wiki.guildwars.com/wiki/{rune_name.replace(' ', '_')}"
    })

    # Major rune
    rune_name = f"Rune of Major {attr_name}"
    runes.append({
        "name": rune_name,
        "type": "armor",
        "rarity": "uncommon",
        "profession": profession,
        "attribute": attr_name,
        "icon": get_rune_icon(profession, "uncommon"),
        "effects": {
            "AttributeBonus": {
                "value": 2,
                "cumulative": False
            },
            "HealthPenalty": {
                "value": -35,
                "cumulative": True
            }
        },
        "description": f"{attr_name} +2 (Non-stacking)\nHealth -35",
        "wiki_url": f"https://wiki.guildwars.com/wiki/{rune_name.replace(' ', '_')}"
    })

    # Superior rune
    rune_name = f"Rune of Superior {attr_name}"
    runes.append({
        "name": rune_name,
        "type": "armor",
        "rarity": "rare",
        "profession": profession,
        "attribute": attr_name,
        "icon": get_rune_icon(profession, "rare"),
        "effects": {
            "AttributeBonus": {
                "value": 3,
                "cumulative": False
            },
            "HealthPenalty": {
                "value": -75,
                "cumulative": True
            }
        },
        "description": f"{attr_name} +3 (Non-stacking)\nHealth -75",
        "wiki_url": f"https://wiki.guildwars.com/wiki/{rune_name.replace(' ', '_')}"
    })

# 2. Add Absorption runes (Warrior only)
absorption_runes = [
    {
        "name": "Warrior Rune of Minor Absorption",
        "type": "armor",
        "rarity": "common",
        "profession": "Warrior",
        "attribute": None,
        "icon": get_rune_icon("Warrior", "common"),
        "effects": {
            "DamageReduction": {
                "value": 1,
                "cumulative": False
            }
        },
        "description": "Reduces physical damage by 1 (Non-stacking)",
        "wiki_url": "https://wiki.guildwars.com/wiki/Warrior_Rune_of_Minor_Absorption"
    },
    {
        "name": "Warrior Rune of Major Absorption",
        "type": "armor",
        "rarity": "uncommon",
        "profession": "Warrior",
        "attribute": None,
        "icon": get_rune_icon("Warrior", "uncommon"),
        "effects": {
            "DamageReduction": {
                "value": 2,
                "cumulative": False
            }
        },
        "description": "Reduces physical damage by 2 (Non-stacking)",
        "wiki_url": "https://wiki.guildwars.com/wiki/Warrior_Rune_of_Major_Absorption"
    },
    {
        "name": "Warrior Rune of Superior Absorption",
        "type": "armor",
        "rarity": "rare",
        "profession": "Warrior",
        "attribute": None,
        "icon": get_rune_icon("Warrior", "rare"),
        "effects": {
            "DamageReduction": {
                "value": 3,
                "cumulative": False
            }
        },
        "description": "Reduces physical damage by 3 (Non-stacking)",
        "wiki_url": "https://wiki.guildwars.com/wiki/Warrior_Rune_of_Superior_Absorption"
    }
]
runes.extend(absorption_runes)

# 3. Add profession-independent runes (Vigor)
vigor_runes = [
    {
        "name": "Rune of Minor Vigor",
        "type": "armor",
        "rarity": "common",
        "profession": None,
        "attribute": None,
        "icon": get_rune_icon(None, "common"),
        "effects": {
            "HealthBonus": {
                "value": 30,
                "cumulative": False
            }
        },
        "description": "Health +30 (Non-stacking)",
        "wiki_url": "https://wiki.guildwars.com/wiki/Rune_of_Minor_Vigor"
    },
    {
        "name": "Rune of Major Vigor",
        "type": "armor",
        "rarity": "uncommon",
        "profession": None,
        "attribute": None,
        "icon": get_rune_icon(None, "uncommon"),
        "effects": {
            "HealthBonus": {
                "value": 41,
                "cumulative": False
            }
        },
        "description": "Health +41 (Non-stacking)",
        "wiki_url": "https://wiki.guildwars.com/wiki/Rune_of_Major_Vigor"
    },
    {
        "name": "Rune of Superior Vigor",
        "type": "armor",
        "rarity": "rare",
        "profession": None,
        "attribute": None,
        "icon": get_rune_icon(None, "rare"),
        "effects": {
            "HealthBonus": {
                "value": 50,
                "cumulative": False
            }
        },
        "description": "Health +50 (Non-stacking)",
        "wiki_url": "https://wiki.guildwars.com/wiki/Rune_of_Superior_Vigor"
    }
]
runes.extend(vigor_runes)

# 4. Add other profession-independent runes
universal_runes = [
    {
        "name": "Rune of Attunement",
        "type": "armor",
        "rarity": "common",
        "profession": None,
        "attribute": None,
        "icon": get_rune_icon(None, "common"),
        "effects": {
            "EnergyBonus": {
                "value": 2,
                "cumulative": True
            }
        },
        "description": "Energy +2",
        "wiki_url": "https://wiki.guildwars.com/wiki/Rune_of_Attunement"
    },
    {
        "name": "Rune of Vitae",
        "type": "armor",
        "rarity": "common",
        "profession": None,
        "attribute": None,
        "icon": get_rune_icon(None, "common"),
        "effects": {
            "HealthBonus": {
                "value": 10,
                "cumulative": True
            }
        },
        "description": "Health +10",
        "wiki_url": "https://wiki.guildwars.com/wiki/Rune_of_Vitae"
    },
    {
        "name": "Rune of Clarity",
        "type": "armor",
        "rarity": "uncommon",
        "profession": None,
        "attribute": None,
        "icon": get_rune_icon(None, "uncommon"),
        "effects": {
            "ConditionReduction": {
                "value": {
                    "Blind": 0.20,
                    "Weakness": 0.20
                },
                "cumulative": False
            }
        },
        "description": "Reduces Blind duration on you by 20% (Non-stacking)\nReduces Weakness duration on you by 20% (Non-stacking)",
        "wiki_url": "https://wiki.guildwars.com/wiki/Rune_of_Clarity"
    },
    {
        "name": "Rune of Purity",
        "type": "armor",
        "rarity": "uncommon",
        "profession": None,
        "attribute": None,
        "icon": get_rune_icon(None, "uncommon"),
        "effects": {
            "ConditionReduction": {
                "value": {
                    "Disease": 0.20,
                    "Poison": 0.20
                },
                "cumulative": False
            }
        },
        "description": "Reduces Disease duration on you by 20% (Non-stacking)\nReduces Poison duration on you by 20% (Non-stacking)",
        "wiki_url": "https://wiki.guildwars.com/wiki/Rune_of_Purity"
    },
    {
        "name": "Rune of Recovery",
        "type": "armor",
        "rarity": "uncommon",
        "profession": None,
        "attribute": None,
        "icon": get_rune_icon(None, "uncommon"),
        "effects": {
            "ConditionReduction": {
                "value": {
                    "Dazed": 0.20,
                    "Deep Wound": 0.20
                },
                "cumulative": False
            }
        },
        "description": "Reduces Dazed duration on you by 20% (Non-stacking)\nReduces Deep Wound duration on you by 20% (Non-stacking)",
        "wiki_url": "https://wiki.guildwars.com/wiki/Rune_of_Recovery"
    },
    {
        "name": "Rune of Restoration",
        "type": "armor",
        "rarity": "uncommon",
        "profession": None,
        "attribute": None,
        "icon": get_rune_icon(None, "uncommon"),
        "effects": {
            "ConditionReduction": {
                "value": {
                    "Bleeding": 0.20,
                    "Crippled": 0.20
                },
                "cumulative": False
            }
        },
        "description": "Reduces Bleeding duration on you by 20% (Non-stacking)\nReduces Crippled duration on you by 20% (Non-stacking)",
        "wiki_url": "https://wiki.guildwars.com/wiki/Rune_of_Restoration"
    }
]
runes.extend(universal_runes)

# 5. Add container runes
container_runes = [
    {
        "name": "Rune of Holding",
        "type": "inventory",
        "rarity": "common",
        "profession": None,
        "attribute": None,
        "icon": get_rune_icon(None, "common"),
        "effects": {
            "BagSlots": {
                "value": 10,
                "cumulative": False
            }
        },
        "description": "Upgrades bag carrying capacity by +10 slots",
        "wiki_url": "https://wiki.guildwars.com/wiki/Rune_of_Holding"
    },
    {
        "name": "Superior Rune of Holding",
        "type": "inventory",
        "rarity": "rare",
        "profession": None,
        "attribute": None,
        "icon": get_rune_icon(None, "rare"),
        "effects": {
            "BagSlots": {
                "value": 15,
                "cumulative": False
            }
        },
        "description": "Upgrades bag carrying capacity by +15 slots",
        "wiki_url": "https://wiki.guildwars.com/wiki/Superior_Rune_of_Holding"
    },
    {
        "name": "Rune of Belt Holding",
        "type": "inventory",
        "rarity": "rare",
        "profession": None,
        "attribute": None,
        "icon": get_rune_icon(None, "rare"),
        "effects": {
            "BeltPouchSlots": {
                "value": 10,
                "cumulative": False
            }
        },
        "description": "Upgrades belt pouch carrying capacity by +10 slots",
        "wiki_url": "https://wiki.guildwars.com/wiki/Rune_of_Belt_Holding"
    }
]
runes.extend(container_runes)

# Sort runes by name for better organization
runes.sort(key=lambda x: x['name'])

# Write to JSON file
output_file = 'guild-wars-json-data/data/runes.json'
with open(output_file, 'w') as f:
    json.dump(runes, f, indent=2)

print(f"Generated {len(runes)} runes")
print(f"Saved to {output_file}")
