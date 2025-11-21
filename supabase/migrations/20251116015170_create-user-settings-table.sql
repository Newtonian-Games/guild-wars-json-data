-- User Settings Table (stores user preferences like theme, etc.)
CREATE TABLE user_settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  theme_mode text CHECK (theme_mode IN ('light', 'dark', 'auto')) DEFAULT 'dark',
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  UNIQUE(user_id)
);

-- Trigger for user_settings.updated_at
CREATE TRIGGER trg_update_updated_at_user_settings
BEFORE UPDATE ON user_settings
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Indexes for user_settings
CREATE INDEX idx_user_settings_user_id ON user_settings(user_id);

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE user_settings;

-- Enable Row Level Security
ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;

-- RLS Policies for user_settings
CREATE POLICY "Users can view their own settings"
  ON user_settings FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own settings"
  ON user_settings FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own settings"
  ON user_settings FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own settings"
  ON user_settings FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);
