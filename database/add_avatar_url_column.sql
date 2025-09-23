-- Migration: Add avatar_url column to characters table if missing
ALTER TABLE characters 
ADD COLUMN IF NOT EXISTS avatar_url TEXT;