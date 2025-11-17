-- Add description column to attributes table
ALTER TABLE attributes
ADD COLUMN description text;

-- Add index for the new column
CREATE INDEX idx_attributes_description ON attributes(description);

