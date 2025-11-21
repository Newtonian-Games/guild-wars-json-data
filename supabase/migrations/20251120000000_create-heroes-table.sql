-- Heroes Table
CREATE TABLE IF NOT EXISTS heroes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  profession uuid REFERENCES professions(id) ON DELETE SET NULL,
  wiki_url text,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Indexes for heroes
CREATE INDEX IF NOT EXISTS idx_heroes_name ON heroes(name);
CREATE INDEX IF NOT EXISTS idx_heroes_profession ON heroes(profession);
CREATE INDEX IF NOT EXISTS idx_heroes_wiki_url ON heroes(wiki_url);

-- Trigger for heroes.updated_at
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trg_update_updated_at_heroes') THEN
    CREATE TRIGGER trg_update_updated_at_heroes
    BEFORE UPDATE ON heroes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
  END IF;
END $$;

-- Enable Realtime
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE heroes;
  END IF;
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

-- Enable Row Level Security (allow read for all users including anonymous)
ALTER TABLE heroes ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
    AND tablename = 'heroes'
    AND policyname = 'Anyone can view heroes'
  ) THEN
    CREATE POLICY "Anyone can view heroes"
      ON heroes FOR SELECT
      TO authenticated, anon
      USING (true);
  END IF;
END $$;
