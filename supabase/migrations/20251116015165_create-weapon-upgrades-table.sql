-- Weapon Upgrades Table
CREATE TABLE weapon_upgrades (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  type text NOT NULL,
  description text NOT NULL,
  attaches_to text,
  release_id uuid REFERENCES releases(id) ON DELETE SET NULL,
  wiki_url text NOT NULL,
  icon text,
  variables jsonb,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Indexes for common queries
CREATE INDEX idx_weapon_upgrades_name ON weapon_upgrades(name);
CREATE INDEX idx_weapon_upgrades_type ON weapon_upgrades(type);
CREATE INDEX idx_weapon_upgrades_release_id ON weapon_upgrades(release_id);
CREATE INDEX idx_weapon_upgrades_type_release ON weapon_upgrades(type, release_id);

-- Full text search index on name and description
CREATE INDEX idx_weapon_upgrades_search ON weapon_upgrades USING gin(to_tsvector('english', name || ' ' || COALESCE(description, '')));

-- Trigger for weapon_upgrades.updated_at
CREATE TRIGGER trg_update_updated_at_weapon_upgrades
BEFORE UPDATE ON weapon_upgrades
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE weapon_upgrades;

-- Enable Row Level Security (allow read for all authenticated users)
ALTER TABLE weapon_upgrades ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view weapon_upgrades"
  ON weapon_upgrades FOR SELECT
  TO authenticated, anon
  USING (true);
