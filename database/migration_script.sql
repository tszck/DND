-- Migration Script: Add Missing Columns and Fix Existing Data
-- Run this in your Supabase SQL Editor

-- Step 1: Add missing columns (if they don't exist)
ALTER TABLE characters 
ADD COLUMN IF NOT EXISTS race VARCHAR(50),
ADD COLUMN IF NOT EXISTS background VARCHAR(50),
ADD COLUMN IF NOT EXISTS xp INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- Step 2: Fix null ability scores with default values
UPDATE characters 
SET 
  strength = COALESCE(strength, 8),
  dexterity = COALESCE(dexterity, 8),
  constitution = COALESCE(constitution, 8),
  intelligence = COALESCE(intelligence, 8),
  wisdom = COALESCE(wisdom, 8),
  charisma = COALESCE(charisma, 8)
WHERE strength IS NULL OR dexterity IS NULL OR constitution IS NULL 
   OR intelligence IS NULL OR wisdom IS NULL OR charisma IS NULL;

-- Step 3: Fix null arrays with empty arrays
UPDATE characters 
SET 
  items = COALESCE(items, '[]'::jsonb),
  equipment = COALESCE(equipment, '[]'::jsonb),
  skills = COALESCE(skills, '[]'::jsonb),
  spells = COALESCE(spells, '[]'::jsonb)
WHERE items IS NULL OR equipment IS NULL OR skills IS NULL OR spells IS NULL;

-- Step 4: Set default values for missing fields
UPDATE characters 
SET 
  race = COALESCE(race, 'Human'),
  background = COALESCE(background, 'Folk Hero'),
  xp = COALESCE(xp, 0),
  bio = COALESCE(bio, ''),
  created_at = COALESCE(created_at, NOW()),
  updated_at = COALESCE(updated_at, NOW())
WHERE race IS NULL OR background IS NULL OR xp IS NULL 
   OR bio IS NULL OR created_at IS NULL OR updated_at IS NULL;

-- Step 5: Add constraints to prevent future null values
ALTER TABLE characters 
ALTER COLUMN strength SET DEFAULT 8,
ALTER COLUMN dexterity SET DEFAULT 8,
ALTER COLUMN constitution SET DEFAULT 8,
ALTER COLUMN intelligence SET DEFAULT 8,
ALTER COLUMN wisdom SET DEFAULT 8,
ALTER COLUMN charisma SET DEFAULT 8,
ALTER COLUMN items SET DEFAULT '[]'::jsonb,
ALTER COLUMN equipment SET DEFAULT '[]'::jsonb,
ALTER COLUMN skills SET DEFAULT '[]'::jsonb,
ALTER COLUMN spells SET DEFAULT '[]'::jsonb,
ALTER COLUMN bio SET DEFAULT '',
ALTER COLUMN xp SET DEFAULT 0;

-- Step 6: Create the update trigger (if it doesn't exist)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_characters_updated_at ON characters;
CREATE TRIGGER update_characters_updated_at 
    BEFORE UPDATE ON characters 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Step 7: Verify the migration worked
SELECT 
  username, 
  name, 
  race, 
  background, 
  level, 
  xp,
  strength, 
  dexterity, 
  constitution, 
  intelligence, 
  wisdom, 
  charisma,
  CASE WHEN items IS NOT NULL THEN 'OK' ELSE 'NULL' END as items_status,
  CASE WHEN equipment IS NOT NULL THEN 'OK' ELSE 'NULL' END as equipment_status,
  CASE WHEN skills IS NOT NULL THEN 'OK' ELSE 'NULL' END as skills_status,
  CASE WHEN spells IS NOT NULL THEN 'OK' ELSE 'NULL' END as spells_status,
  created_at,
  updated_at
FROM characters
ORDER BY username;