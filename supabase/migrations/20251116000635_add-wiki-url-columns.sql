-- Add wiki_url column to professions table
ALTER TABLE professions
ADD COLUMN wiki_url text;

-- Add wiki_url column to attributes table
ALTER TABLE attributes
ADD COLUMN wiki_url text;

-- Add indexes for the new columns
CREATE INDEX idx_professions_wiki_url ON professions(wiki_url);
CREATE INDEX idx_attributes_wiki_url ON attributes(wiki_url);

