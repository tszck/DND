-- SQLite Schema for D&D Campaign Manager
-- Converted from PostgreSQL (dnd_normalized_schema.sql)

PRAGMA foreign_keys = ON;

-- Items Reference Table
CREATE TABLE items (
    item_id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random()) % 4 + 1, 1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))),
    name TEXT NOT NULL UNIQUE,
    category TEXT NOT NULL,
    subcategory TEXT,
    rarity TEXT DEFAULT 'common',
    weight REAL DEFAULT 0,
    value_gp INTEGER DEFAULT 0,
    consumable INTEGER DEFAULT 0,
    magical INTEGER DEFAULT 0,
    attunement_required INTEGER DEFAULT 0,
    description TEXT,
    effect TEXT,
    properties TEXT DEFAULT '{}',
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

-- Weapons Reference Table
CREATE TABLE weapons (
    weapon_id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random()) % 4 + 1, 1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))),
    name TEXT NOT NULL UNIQUE,
    category TEXT NOT NULL,
    type TEXT NOT NULL,
    damage_dice TEXT NOT NULL,
    damage_type TEXT NOT NULL,
    properties TEXT,
    range_normal INTEGER,
    range_long INTEGER,
    weight REAL DEFAULT 0,
    value_gp INTEGER DEFAULT 0,
    magical INTEGER DEFAULT 0,
    enchantment_bonus INTEGER DEFAULT 0,
    rarity TEXT DEFAULT 'common',
    attunement_required INTEGER DEFAULT 0,
    description TEXT,
    special_abilities TEXT DEFAULT '{}',
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

-- Armor Reference Table
CREATE TABLE armor (
    armor_id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random()) % 4 + 1, 1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))),
    name TEXT NOT NULL UNIQUE,
    category TEXT NOT NULL,
    base_ac INTEGER NOT NULL,
    max_dex_bonus INTEGER,
    strength_requirement INTEGER DEFAULT 0,
    stealth_disadvantage INTEGER DEFAULT 0,
    weight REAL DEFAULT 0,
    value_gp INTEGER DEFAULT 0,
    magical INTEGER DEFAULT 0,
    enchantment_bonus INTEGER DEFAULT 0,
    rarity TEXT DEFAULT 'common',
    attunement_required INTEGER DEFAULT 0,
    description TEXT,
    special_abilities TEXT DEFAULT '{}',
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

-- Spells Reference Table
CREATE TABLE spells (
    spell_id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random()) % 4 + 1, 1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))),
    name TEXT NOT NULL UNIQUE,
    level INTEGER NOT NULL CHECK (level >= 0 AND level <= 9),
    school TEXT NOT NULL,
    casting_time TEXT NOT NULL,
    range_distance TEXT NOT NULL,
    components TEXT NOT NULL,
    duration TEXT NOT NULL,
    concentration INTEGER DEFAULT 0,
    ritual INTEGER DEFAULT 0,
    damage_dice TEXT,
    damage_type TEXT,
    save_type TEXT,
    spell_attack INTEGER DEFAULT 0,
    healing_dice TEXT,
    area_of_effect TEXT,
    upcast_scaling TEXT,
    description TEXT NOT NULL,
    higher_level_description TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

-- Skills Reference Table
CREATE TABLE skills (
    skill_id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random()) % 4 + 1, 1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))),
    name TEXT NOT NULL UNIQUE,
    ability_score TEXT NOT NULL,
    description TEXT,
    example_uses TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

-- Status Effects Reference Table
CREATE TABLE status_effects (
    effect_id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random()) % 4 + 1, 1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))),
    name TEXT NOT NULL UNIQUE,
    type TEXT NOT NULL,
    duration_type TEXT,
    stackable INTEGER DEFAULT 0,
    description TEXT NOT NULL,
    mechanical_effect TEXT,
    end_conditions TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

-- Characters Table
CREATE TABLE characters (
    character_id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random()) % 4 + 1, 1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))),
    username TEXT NOT NULL,
    character_name TEXT NOT NULL,
    race TEXT NOT NULL,
    class TEXT NOT NULL,
    subclass TEXT,
    background TEXT,
    alignment TEXT,
    level INTEGER NOT NULL DEFAULT 1 CHECK (level >= 1 AND level <= 20),
    xp INTEGER NOT NULL DEFAULT 0,
    strength INTEGER NOT NULL DEFAULT 10 CHECK (strength >= 1 AND strength <= 30),
    dexterity INTEGER NOT NULL DEFAULT 10 CHECK (dexterity >= 1 AND dexterity <= 30),
    constitution INTEGER NOT NULL DEFAULT 10 CHECK (constitution >= 1 AND constitution <= 30),
    intelligence INTEGER NOT NULL DEFAULT 10 CHECK (intelligence >= 1 AND intelligence <= 30),
    wisdom INTEGER NOT NULL DEFAULT 10 CHECK (wisdom >= 1 AND wisdom <= 30),
    charisma INTEGER NOT NULL DEFAULT 10 CHECK (charisma >= 1 AND charisma <= 30),
    max_hp INTEGER NOT NULL DEFAULT 1,
    current_hp INTEGER NOT NULL DEFAULT 1,
    temp_hp INTEGER DEFAULT 0,
    armor_class INTEGER NOT NULL DEFAULT 10,
    initiative_bonus INTEGER DEFAULT 0,
    speed INTEGER NOT NULL DEFAULT 30,
    proficiency_bonus INTEGER NOT NULL DEFAULT 2,
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
    personality_traits TEXT,
    ideals TEXT,
    bonds TEXT,
    flaws TEXT,
    bio TEXT,
    avatar_url TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

-- Junction Tables
CREATE TABLE character_items (
    character_id TEXT REFERENCES characters(character_id) ON DELETE CASCADE,
    item_id TEXT REFERENCES items(item_id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 1,
    equipped INTEGER DEFAULT 0,
    notes TEXT,
    custom_properties TEXT DEFAULT '{}',
    PRIMARY KEY (character_id, item_id)
);

CREATE TABLE character_weapons (
    character_id TEXT REFERENCES characters(character_id) ON DELETE CASCADE,
    weapon_id TEXT REFERENCES weapons(weapon_id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 1,
    equipped INTEGER DEFAULT 0,
    attuned INTEGER DEFAULT 0,
    custom_enchantment INTEGER DEFAULT 0,
    custom_name TEXT,
    notes TEXT,
    custom_properties TEXT DEFAULT '{}',
    PRIMARY KEY (character_id, weapon_id)
);

CREATE TABLE character_armor (
    character_id TEXT REFERENCES characters(character_id) ON DELETE CASCADE,
    armor_id TEXT REFERENCES armor(armor_id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 1,
    equipped INTEGER DEFAULT 0,
    attuned INTEGER DEFAULT 0,
    custom_enchantment INTEGER DEFAULT 0,
    custom_name TEXT,
    notes TEXT,
    custom_properties TEXT DEFAULT '{}',
    PRIMARY KEY (character_id, armor_id)
);

CREATE TABLE character_spells (
    character_id TEXT REFERENCES characters(character_id) ON DELETE CASCADE,
    spell_id TEXT REFERENCES spells(spell_id) ON DELETE CASCADE,
    known INTEGER DEFAULT 1,
    prepared INTEGER DEFAULT 0,
    spell_attack_bonus INTEGER,
    spell_save_dc INTEGER,
    notes TEXT,
    PRIMARY KEY (character_id, spell_id)
);

CREATE TABLE character_skills (
    character_id TEXT REFERENCES characters(character_id) ON DELETE CASCADE,
    skill_id TEXT REFERENCES skills(skill_id) ON DELETE CASCADE,
    proficient INTEGER DEFAULT 0,
    expertise INTEGER DEFAULT 0,
    custom_bonus INTEGER DEFAULT 0,
    notes TEXT,
    PRIMARY KEY (character_id, skill_id)
);

CREATE TABLE character_status_effects (
    character_id TEXT REFERENCES characters(character_id) ON DELETE CASCADE,
    effect_id TEXT REFERENCES status_effects(effect_id) ON DELETE CASCADE,
    source TEXT,
    duration_remaining INTEGER,
    stacks INTEGER DEFAULT 1,
    applied_at TEXT DEFAULT (datetime('now')),
    expires_at TEXT,
    notes TEXT,
    PRIMARY KEY (character_id, effect_id, applied_at)
);

-- Indexes
CREATE INDEX idx_characters_username ON characters(username);
CREATE INDEX idx_characters_class ON characters(class);
CREATE INDEX idx_characters_level ON characters(level);
CREATE INDEX idx_items_category ON items(category);
CREATE INDEX idx_items_rarity ON items(rarity);
CREATE INDEX idx_weapons_type ON weapons(type);
CREATE INDEX idx_weapons_category ON weapons(category);
CREATE INDEX idx_armor_category ON armor(category);
CREATE INDEX idx_spells_level ON spells(level);
CREATE INDEX idx_spells_school ON spells(school);
CREATE INDEX idx_skills_ability ON skills(ability_score);
CREATE INDEX idx_character_items_equipped ON character_items(equipped);
CREATE INDEX idx_character_weapons_equipped ON character_weapons(equipped);
CREATE INDEX idx_character_armor_equipped ON character_armor(equipped);
CREATE INDEX idx_character_spells_prepared ON character_spells(prepared);
CREATE INDEX idx_character_skills_proficient ON character_skills(proficient);

-- Triggers for updated_at
CREATE TRIGGER update_items_updated_at AFTER UPDATE ON items BEGIN
    UPDATE items SET updated_at = datetime('now') WHERE item_id = NEW.item_id;
END;
CREATE TRIGGER update_weapons_updated_at AFTER UPDATE ON weapons BEGIN
    UPDATE weapons SET updated_at = datetime('now') WHERE weapon_id = NEW.weapon_id;
END;
CREATE TRIGGER update_armor_updated_at AFTER UPDATE ON armor BEGIN
    UPDATE armor SET updated_at = datetime('now') WHERE armor_id = NEW.armor_id;
END;
CREATE TRIGGER update_spells_updated_at AFTER UPDATE ON spells BEGIN
    UPDATE spells SET updated_at = datetime('now') WHERE spell_id = NEW.spell_id;
END;
CREATE TRIGGER update_skills_updated_at AFTER UPDATE ON skills BEGIN
    UPDATE skills SET updated_at = datetime('now') WHERE skill_id = NEW.skill_id;
END;
CREATE TRIGGER update_status_effects_updated_at AFTER UPDATE ON status_effects BEGIN
    UPDATE status_effects SET updated_at = datetime('now') WHERE effect_id = NEW.effect_id;
END;
CREATE TRIGGER update_characters_updated_at AFTER UPDATE ON characters BEGIN
    UPDATE characters SET updated_at = datetime('now') WHERE character_id = NEW.character_id;
END;

-- Complete Character View
CREATE VIEW character_full_view AS
SELECT
    c.*,
    (SELECT json_group_array(json_object(
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

    (SELECT json_group_array(json_object(
        'name', COALESCE(ca.custom_name, a.name),
        'category', a.category,
        'base_ac', a.base_ac,
        'enchantment', a.enchantment_bonus + ca.custom_enchantment,
        'equipped', ca.equipped,
        'attuned', ca.attuned
    )) FROM character_armor ca
    JOIN armor a ON ca.armor_id = a.armor_id
    WHERE ca.character_id = c.character_id) AS armor,

    (SELECT json_group_array(json_object(
        'name', i.name,
        'category', i.category,
        'quantity', ci.quantity,
        'equipped', ci.equipped,
        'consumable', i.consumable,
        'effect', i.effect
    )) FROM character_items ci
    JOIN items i ON ci.item_id = i.item_id
    WHERE ci.character_id = c.character_id) AS items,

    (SELECT json_group_array(json_object(
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

    (SELECT json_group_array(json_object(
        'name', sk.name,
        'ability', sk.ability_score,
        'proficient', csk.proficient,
        'expertise', csk.expertise,
        'bonus', csk.custom_bonus
    )) FROM character_skills csk
    JOIN skills sk ON csk.skill_id = sk.skill_id
    WHERE csk.character_id = c.character_id) AS skills,

    (SELECT json_group_array(json_object(
        'name', se.name,
        'type', se.type,
        'source', cse.source,
        'duration_remaining', cse.duration_remaining,
        'stacks', cse.stacks,
        'description', se.description
    )) FROM character_status_effects cse
    JOIN status_effects se ON cse.effect_id = se.effect_id
    WHERE cse.character_id = c.character_id
    AND (cse.expires_at IS NULL OR cse.expires_at > datetime('now'))) AS status_effects

FROM characters c;
