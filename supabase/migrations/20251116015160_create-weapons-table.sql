-- Weapons Table
CREATE TABLE weapons (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  category text NOT NULL CHECK (category IN ('martial', 'caster')),
  subcategory text NOT NULL CHECK (subcategory IN ('melee', 'ranged')),
  hands text NOT NULL CHECK (hands IN ('one', 'two')),
  attribute_id uuid REFERENCES attributes(id) ON DELETE SET NULL,
  attribute_profession_id uuid REFERENCES professions(id) ON DELETE SET NULL,
  damage jsonb NOT NULL DEFAULT '{}'::jsonb,
  variants jsonb NOT NULL DEFAULT '[]'::jsonb,
  wiki_url text NOT NULL,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Indexes for common queries
CREATE INDEX idx_weapons_name ON weapons(name);
CREATE INDEX idx_weapons_category ON weapons(category);
CREATE INDEX idx_weapons_subcategory ON weapons(subcategory);
CREATE INDEX idx_weapons_hands ON weapons(hands);
CREATE INDEX idx_weapons_attribute_id ON weapons(attribute_id);
CREATE INDEX idx_weapons_category_subcategory ON weapons(category, subcategory);

-- Full text search index on name
CREATE INDEX idx_weapons_search ON weapons USING gin(to_tsvector('english', name));

-- Trigger for weapons.updated_at
CREATE TRIGGER trg_update_updated_at_weapons
BEFORE UPDATE ON weapons
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE weapons;

-- Enable Row Level Security (allow read for all authenticated users)
ALTER TABLE weapons ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view weapons"
  ON weapons FOR SELECT
  TO authenticated
  USING (true);
