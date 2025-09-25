-- =============================================================================
-- D&D Normalized Database Schema
-- Created: September 26, 2025
-- Description: Normalized database with separate tables for items, weapons, spells, etc.
--              Characters link to these through junction tables for easy editing
-- =============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- CORE REFERENCE TABLES
-- =============================================================================

-- Items Reference Table
CREATE TABLE items (
    item_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(50) NOT NULL, -- consumable, tool, adventuring_gear, magical, etc.
    subcategory VARCHAR(50), -- potion, rope, torch, etc.
    rarity VARCHAR(20) DEFAULT 'common', -- common, uncommon, rare, very_rare, legendary
    weight DECIMAL(5,2) DEFAULT 0,
    value_gp INTEGER DEFAULT 0,
    consumable BOOLEAN DEFAULT false,
    magical BOOLEAN DEFAULT false,
    attunement_required BOOLEAN DEFAULT false,
    description TEXT,
    effect TEXT,
    properties JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Weapons Reference Table  
CREATE TABLE weapons (
    weapon_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(50) NOT NULL, -- simple, martial
    type VARCHAR(50) NOT NULL, -- melee, ranged
    damage_dice VARCHAR(20) NOT NULL, -- 1d8, 2d6, etc.
    damage_type VARCHAR(20) NOT NULL, -- slashing, piercing, bludgeoning
    properties TEXT[], -- versatile, finesse, heavy, light, etc.
    range_normal INTEGER, -- for ranged weapons
    range_long INTEGER, -- for ranged weapons
    weight DECIMAL(5,2) DEFAULT 0,
    value_gp INTEGER DEFAULT 0,
    magical BOOLEAN DEFAULT false,
    enchantment_bonus INTEGER DEFAULT 0,
    rarity VARCHAR(20) DEFAULT 'common',
    attunement_required BOOLEAN DEFAULT false,
    description TEXT,
    special_abilities JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Armor Reference Table
CREATE TABLE armor (
    armor_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(50) NOT NULL, -- light, medium, heavy, shield
    base_ac INTEGER NOT NULL,
    max_dex_bonus INTEGER, -- NULL for no limit
    strength_requirement INTEGER DEFAULT 0,
    stealth_disadvantage BOOLEAN DEFAULT false,
    weight DECIMAL(5,2) DEFAULT 0,
    value_gp INTEGER DEFAULT 0,
    magical BOOLEAN DEFAULT false,
    enchantment_bonus INTEGER DEFAULT 0,
    rarity VARCHAR(20) DEFAULT 'common',
    attunement_required BOOLEAN DEFAULT false,
    description TEXT,
    special_abilities JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Spells Reference Table
CREATE TABLE spells (
    spell_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE,
    level INTEGER NOT NULL CHECK (level >= 0 AND level <= 9),
    school VARCHAR(50) NOT NULL, -- abjuration, conjuration, etc.
    casting_time VARCHAR(100) NOT NULL,
    range_distance VARCHAR(100) NOT NULL,
    components TEXT NOT NULL, -- V, S, M
    duration VARCHAR(100) NOT NULL,
    concentration BOOLEAN DEFAULT false,
    ritual BOOLEAN DEFAULT false,
    damage_dice VARCHAR(20), -- 1d4, 8d6, etc.
    damage_type VARCHAR(20), -- fire, cold, radiant, etc.
    save_type VARCHAR(20), -- dexterity, wisdom, etc.
    spell_attack BOOLEAN DEFAULT false,
    healing_dice VARCHAR(20), -- for healing spells
    area_of_effect VARCHAR(100), -- 20-foot radius, 30-foot cone, etc.
    upcast_scaling TEXT, -- how spell scales with higher slots
    description TEXT NOT NULL,
    higher_level_description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Skills Reference Table
CREATE TABLE skills (
    skill_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) NOT NULL UNIQUE,
    ability_score VARCHAR(20) NOT NULL, -- strength, dexterity, etc.
    description TEXT,
    example_uses TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Status Effects Reference Table
CREATE TABLE status_effects (
    effect_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE,
    type VARCHAR(50) NOT NULL, -- buff, debuff, condition, spell_effect
    duration_type VARCHAR(50), -- rounds, minutes, hours, permanent, concentration
    stackable BOOLEAN DEFAULT false,
    description TEXT NOT NULL,
    mechanical_effect TEXT,
    end_conditions TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================================================
-- CHARACTER TABLE (Simplified)
-- =============================================================================

CREATE TABLE characters (
    character_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) NOT NULL,
    character_name VARCHAR(100) NOT NULL,
    race VARCHAR(50) NOT NULL,
    class VARCHAR(50) NOT NULL,
    subclass VARCHAR(50),
    background VARCHAR(50),
    alignment VARCHAR(50),
    level INTEGER NOT NULL DEFAULT 1 CHECK (level >= 1 AND level <= 20),
    xp INTEGER NOT NULL DEFAULT 0,
    
    -- Ability Scores
    strength INTEGER NOT NULL DEFAULT 10 CHECK (strength >= 1 AND strength <= 30),
    dexterity INTEGER NOT NULL DEFAULT 10 CHECK (dexterity >= 1 AND dexterity <= 30),
    constitution INTEGER NOT NULL DEFAULT 10 CHECK (constitution >= 1 AND constitution <= 30),
    intelligence INTEGER NOT NULL DEFAULT 10 CHECK (intelligence >= 1 AND intelligence <= 30),
    wisdom INTEGER NOT NULL DEFAULT 10 CHECK (wisdom >= 1 AND wisdom <= 30),
    charisma INTEGER NOT NULL DEFAULT 10 CHECK (charisma >= 1 AND charisma <= 30),
    
    -- Combat Stats
    max_hp INTEGER NOT NULL DEFAULT 1,
    current_hp INTEGER NOT NULL DEFAULT 1,
    temp_hp INTEGER DEFAULT 0,
    armor_class INTEGER NOT NULL DEFAULT 10,
    initiative_bonus INTEGER DEFAULT 0,
    speed INTEGER NOT NULL DEFAULT 30,
    proficiency_bonus INTEGER NOT NULL DEFAULT 2,
    
    -- Resources
    gold_pieces INTEGER DEFAULT 0,
    spell_slots_1 INTEGER DEFAULT 0,
    spell_slots_2 INTEGER DEFAULT 0,
    spell_slots_3 INTEGER DEFAULT 0,
    spell_slots_4 INTEGER DEFAULT 0,
    spell_slots_5 INTEGER DEFAULT 0,
    spell_slots_6 INTEGER DEFAULT 0,
    spell_slots_7 INTEGER DEFAULT 0,
    spell_slots_8 INTEGER DEFAULT 0,
    spell_slots_9 INTEGER DEFAULT 0,
    
    -- Character Details
    personality_traits TEXT,
    ideals TEXT,
    bonds TEXT,
    flaws TEXT,
    bio TEXT,
    avatar_url TEXT,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================================================
-- JUNCTION TABLES (Many-to-Many relationships)
-- =============================================================================

-- Character Items Junction Table
CREATE TABLE character_items (
    character_id UUID REFERENCES characters(character_id) ON DELETE CASCADE,
    item_id UUID REFERENCES items(item_id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 1,
    equipped BOOLEAN DEFAULT false,
    notes TEXT,
    custom_properties JSONB DEFAULT '{}', -- for character-specific modifications
    PRIMARY KEY (character_id, item_id)
);

-- Character Weapons Junction Table
CREATE TABLE character_weapons (
    character_id UUID REFERENCES characters(character_id) ON DELETE CASCADE,
    weapon_id UUID REFERENCES weapons(weapon_id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 1,
    equipped BOOLEAN DEFAULT false,
    attuned BOOLEAN DEFAULT false,
    custom_enchantment INTEGER DEFAULT 0, -- additional bonus beyond base weapon
    custom_name VARCHAR(100), -- "Flamebrand" instead of "Longsword +1"
    notes TEXT,
    custom_properties JSONB DEFAULT '{}',
    PRIMARY KEY (character_id, weapon_id)
);

-- Character Armor Junction Table
CREATE TABLE character_armor (
    character_id UUID REFERENCES characters(character_id) ON DELETE CASCADE,
    armor_id UUID REFERENCES armor(armor_id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 1,
    equipped BOOLEAN DEFAULT false,
    attuned BOOLEAN DEFAULT false,
    custom_enchantment INTEGER DEFAULT 0,
    custom_name VARCHAR(100),
    notes TEXT,
    custom_properties JSONB DEFAULT '{}',
    PRIMARY KEY (character_id, armor_id)
);

-- Character Spells Junction Table  
CREATE TABLE character_spells (
    character_id UUID REFERENCES characters(character_id) ON DELETE CASCADE,
    spell_id UUID REFERENCES spells(spell_id) ON DELETE CASCADE,
    known BOOLEAN DEFAULT true,
    prepared BOOLEAN DEFAULT false,
    spell_attack_bonus INTEGER, -- character-specific modifier
    spell_save_dc INTEGER, -- character-specific DC
    notes TEXT,
    PRIMARY KEY (character_id, spell_id)
);

-- Character Skills Junction Table
CREATE TABLE character_skills (
    character_id UUID REFERENCES characters(character_id) ON DELETE CASCADE,
    skill_id UUID REFERENCES skills(skill_id) ON DELETE CASCADE,
    proficient BOOLEAN DEFAULT false,
    expertise BOOLEAN DEFAULT false, -- double proficiency bonus
    custom_bonus INTEGER DEFAULT 0, -- additional bonuses from items/effects
    notes TEXT,
    PRIMARY KEY (character_id, skill_id)
);

-- Character Status Effects Junction Table
CREATE TABLE character_status_effects (
    character_id UUID REFERENCES characters(character_id) ON DELETE CASCADE,
    effect_id UUID REFERENCES status_effects(effect_id) ON DELETE CASCADE,
    source VARCHAR(100), -- "Cleric spell", "Magic item", etc.
    duration_remaining INTEGER, -- in seconds, rounds, etc.
    stacks INTEGER DEFAULT 1, -- for stackable effects
    applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    PRIMARY KEY (character_id, effect_id, applied_at)
);

-- =============================================================================
-- INDEXES FOR PERFORMANCE
-- =============================================================================

-- Character indexes
CREATE INDEX idx_characters_username ON characters(username);
CREATE INDEX idx_characters_class ON characters(class);
CREATE INDEX idx_characters_level ON characters(level);

-- Reference table indexes
CREATE INDEX idx_items_category ON items(category);
CREATE INDEX idx_items_rarity ON items(rarity);
CREATE INDEX idx_weapons_type ON weapons(type);
CREATE INDEX idx_weapons_category ON weapons(category);
CREATE INDEX idx_armor_category ON armor(category);
CREATE INDEX idx_spells_level ON spells(level);
CREATE INDEX idx_spells_school ON spells(school);
CREATE INDEX idx_skills_ability ON skills(ability_score);

-- Junction table indexes
CREATE INDEX idx_character_items_equipped ON character_items(equipped);
CREATE INDEX idx_character_weapons_equipped ON character_weapons(equipped);
CREATE INDEX idx_character_armor_equipped ON character_armor(equipped);
CREATE INDEX idx_character_spells_prepared ON character_spells(prepared);
CREATE INDEX idx_character_skills_proficient ON character_skills(proficient);

-- =============================================================================
-- TRIGGERS FOR UPDATED_AT
-- =============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for all main tables
CREATE TRIGGER update_items_updated_at BEFORE UPDATE ON items FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_weapons_updated_at BEFORE UPDATE ON weapons FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_armor_updated_at BEFORE UPDATE ON armor FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_spells_updated_at BEFORE UPDATE ON spells FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_skills_updated_at BEFORE UPDATE ON skills FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_status_effects_updated_at BEFORE UPDATE ON status_effects FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_characters_updated_at BEFORE UPDATE ON characters FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================================================
-- SAMPLE VIEWS FOR EASY QUERYING
-- =============================================================================

-- Complete Character View with all equipment
CREATE VIEW character_full_view AS
SELECT 
    c.*,
    -- Equipped weapons
    (SELECT json_agg(json_build_object(
        'name', COALESCE(cw.custom_name, w.name),
        'damage_dice', w.damage_dice,
        'damage_type', w.damage_type,
        'properties', w.properties,
        'enchantment', w.enchantment_bonus + cw.custom_enchantment,
        'equipped', cw.equipped,
        'attuned', cw.attuned,
        'quantity', cw.quantity
    )) FROM character_weapons cw 
    JOIN weapons w ON cw.weapon_id = w.weapon_id 
    WHERE cw.character_id = c.character_id) AS weapons,
    
    -- Equipped armor
    (SELECT json_agg(json_build_object(
        'name', COALESCE(ca.custom_name, a.name),
        'category', a.category,
        'base_ac', a.base_ac,
        'enchantment', a.enchantment_bonus + ca.custom_enchantment,
        'equipped', ca.equipped,
        'attuned', ca.attuned
    )) FROM character_armor ca 
    JOIN armor a ON ca.armor_id = a.armor_id 
    WHERE ca.character_id = c.character_id) AS armor,
    
    -- All items
    (SELECT json_agg(json_build_object(
        'name', i.name,
        'category', i.category,
        'quantity', ci.quantity,
        'equipped', ci.equipped,
        'consumable', i.consumable,
        'effect', i.effect
    )) FROM character_items ci 
    JOIN items i ON ci.item_id = i.item_id 
    WHERE ci.character_id = c.character_id) AS items,
    
    -- Known/Prepared spells
    (SELECT json_agg(json_build_object(
        'name', s.name,
        'level', s.level,
        'school', s.school,
        'known', cs.known,
        'prepared', cs.prepared,
        'damage_dice', s.damage_dice,
        'save_type', s.save_type,
        'description', s.description
    )) FROM character_spells cs 
    JOIN spells s ON cs.spell_id = s.spell_id 
    WHERE cs.character_id = c.character_id) AS spells,
    
    -- Skills with bonuses
    (SELECT json_agg(json_build_object(
        'name', sk.name,
        'ability', sk.ability_score,
        'proficient', csk.proficient,
        'expertise', csk.expertise,
        'bonus', csk.custom_bonus
    )) FROM character_skills csk 
    JOIN skills sk ON csk.skill_id = sk.skill_id 
    WHERE csk.character_id = c.character_id) AS skills,
    
    -- Active status effects
    (SELECT json_agg(json_build_object(
        'name', se.name,
        'type', se.type,
        'source', cse.source,
        'duration_remaining', cse.duration_remaining,
        'stacks', cse.stacks,
        'description', se.description
    )) FROM character_status_effects cse 
    JOIN status_effects se ON cse.effect_id = se.effect_id 
    WHERE cse.character_id = c.character_id 
    AND (cse.expires_at IS NULL OR cse.expires_at > NOW())) AS status_effects

FROM characters c;

-- =============================================================================
-- COMPLETION MESSAGE
-- =============================================================================

/*
✅ NORMALIZED D&D DATABASE SCHEMA CREATED!

🏗️ STRUCTURE:
- 6 Reference Tables: items, weapons, armor, spells, skills, status_effects
- 1 Character Table: characters (simplified, no JSONB arrays)
- 6 Junction Tables: character_* (linking characters to reference data)

🔗 RELATIONSHIPS:
- Many-to-Many: Characters can have multiple items, items can belong to multiple characters
- Custom Properties: Junction tables store character-specific modifications
- Flexible Linking: Easy to add/remove items without touching character data

📊 BENEFITS:
- Easy Editing: Change item stats once, affects all characters
- Data Consistency: No duplicate item definitions
- Flexible Queries: Rich filtering and joining capabilities
- Performance: Proper indexing on commonly queried fields

🛠️ READY FOR:
1. Populate reference tables with D&D items, weapons, spells, etc.
2. Create characters that link to reference data
3. Build admin interface to manage reference tables
4. Import existing character data using migration scripts

Next step: Populate reference tables with D&D content!
*/