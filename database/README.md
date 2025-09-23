# Database Schema and Migration

This folder contains all database-related SQL files for the D&D Character Management System.

## Files

### `supabase_schema.sql`
Complete database schema for new installations. Use this when setting up a fresh database.

### `migration_script.sql` 
Migration script to update existing databases with missing columns and fix null values.

## Usage

### New Database Setup
Run `supabase_schema.sql` in your Supabase SQL Editor to create the complete table structure.

### Existing Database Migration
Run `migration_script.sql` to add missing columns and fix existing data.

## Schema Overview

The `characters` table includes:
- User identification (username, name)
- Character attributes (race, class, background, level, xp)
- Ability scores (strength, dexterity, constitution, intelligence, wisdom, charisma)
- Dynamic content (items, equipment, skills, spells as JSONB arrays)
- Metadata (bio, created_at, updated_at)