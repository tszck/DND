-- D&D Character Management Database Schema
-- This file contains the complete table structure for storing character data

CREATE TABLE IF NOT EXISTS characters (
  id BIGSERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL,
  race VARCHAR(50),
  class VARCHAR(50),
  background VARCHAR(50),
  level INTEGER DEFAULT 1,
  xp INTEGER DEFAULT 0,
  
  -- Ability Scores
  strength INTEGER DEFAULT 8,
  dexterity INTEGER DEFAULT 8,
  constitution INTEGER DEFAULT 8,
  intelligence INTEGER DEFAULT 8,
  wisdom INTEGER DEFAULT 8,
  charisma INTEGER DEFAULT 8,
  
  -- JSON Arrays for dynamic content
  items JSONB DEFAULT '[]'::jsonb,
  equipment JSONB DEFAULT '[]'::jsonb,
  skills JSONB DEFAULT '[]'::jsonb,
  spells JSONB DEFAULT '[]'::jsonb,
  
  -- Character description
  bio TEXT DEFAULT '',
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create an index on username for faster lookups
CREATE INDEX IF NOT EXISTS idx_characters_username ON characters(username);

-- Create a trigger to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_characters_updated_at 
    BEFORE UPDATE ON characters 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();