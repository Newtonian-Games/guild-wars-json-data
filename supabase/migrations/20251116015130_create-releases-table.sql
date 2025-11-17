-- Releases Table (formerly campaigns)
CREATE TABLE releases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  order_index integer NOT NULL,
  description text,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Indexes
CREATE INDEX idx_releases_name ON releases(name);
CREATE INDEX idx_releases_order_index ON releases(order_index);

-- Trigger for releases.updated_at
CREATE TRIGGER trg_update_updated_at_releases
BEFORE UPDATE ON releases
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE releases;

-- Enable Row Level Security (allow read for all authenticated users)
ALTER TABLE releases ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view releases"
  ON releases FOR SELECT
  TO authenticated
  USING (true);
