-- =============================================================================
-- D&D Normalized Sample Characters
-- Created: September 26, 2025  
-- Description: Sample characters using normalized database structure
-- =============================================================================

-- NOTE: Run this AFTER dnd_normalized_schema.sql AND dnd_reference_data.sql

-- =============================================================================
-- SAMPLE FIGHTER CHARACTER
-- =============================================================================

-- Create the character
INSERT INTO characters (
    username, character_name, race, class, background, alignment, level, xp,
    strength, dexterity, constitution, intelligence, wisdom, charisma,
    max_hp, current_hp, armor_class, initiative_bonus, speed, proficiency_bonus,
    gold_pieces, personality_traits, ideals, bonds, flaws, bio
) VALUES (
    'sample_user',
    'Sir Gareth Ironbane', 
    'Human',
    'Fighter',
    'Soldier',
    'Lawful Good',
    5,
    6500,
    16, 14, 15, 12, 13, 10, -- ability scores
    42, 42, 18, 2, 30, 3, -- combat stats
    150, -- gold
    'I judge others harshly and myself even more severely.',
    'I fight for those who cannot fight for themselves.',
    'I will never forget the crushing defeat my company suffered or the enemies who dealt it.',
    'The monstrous enemy we faced in battle still leaves me quivering with fear.',
    'A seasoned warrior who has seen many battles and carries the weight of command.'
);

-- Get the character ID for linking
DO $$
DECLARE
    char_id UUID;
BEGIN
    -- Get the character ID we just created
    SELECT character_id INTO char_id FROM characters WHERE character_name = 'Sir Gareth Ironbane';
    
    -- Add weapons
    INSERT INTO character_weapons (character_id, weapon_id, quantity, equipped, custom_enchantment, custom_name)
    SELECT char_id, weapon_id, 1, true, 1, 'Longsword +1' FROM weapons WHERE name = 'Longsword';
    
    INSERT INTO character_weapons (character_id, weapon_id, quantity, equipped)
    SELECT char_id, weapon_id, 1, false FROM weapons WHERE name = 'Crossbow, heavy';
    
    INSERT INTO character_weapons (character_id, weapon_id, quantity, equipped)
    SELECT char_id, weapon_id, 2, false FROM weapons WHERE name = 'Javelin';
    
    INSERT INTO character_weapons (character_id, weapon_id, quantity, equipped)
    SELECT char_id, weapon_id, 3, false FROM weapons WHERE name = 'Dagger';
    
    -- Add armor
    INSERT INTO character_armor (character_id, armor_id, quantity, equipped)
    SELECT char_id, armor_id, 1, true FROM armor WHERE name = 'Plate';
    
    INSERT INTO character_armor (character_id, armor_id, quantity, equipped, custom_enchantment, custom_name)
    SELECT char_id, armor_id, 1, true, 1, 'Shield +1' FROM armor WHERE name = 'Shield';
    
    -- Add items  
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 5 FROM items WHERE name = 'Potion of Healing';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 2 FROM items WHERE name = 'Potion of Greater Healing';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 15 FROM items WHERE name = 'Rations (1 day)';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 1 FROM items WHERE name = 'Rope, Silk (50 ft)';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 1 FROM items WHERE name = 'Backpack';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 1 FROM items WHERE name = 'Bedroll';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 2 FROM items WHERE name = 'Waterskin';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 1 FROM items WHERE name = 'Climbers Kit';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 1 FROM items WHERE name = 'Healers Kit';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 40 FROM items WHERE name = 'Crossbow Bolts (20)';
    
    -- Add skills with proficiency
    INSERT INTO character_skills (character_id, skill_id, proficient, custom_bonus)
    SELECT char_id, skill_id, true, 3 FROM skills WHERE name = 'Athletics';
    
    INSERT INTO character_skills (character_id, skill_id, proficient, custom_bonus)  
    SELECT char_id, skill_id, true, 0 FROM skills WHERE name = 'Intimidation';
    
    INSERT INTO character_skills (character_id, skill_id, proficient, custom_bonus)
    SELECT char_id, skill_id, true, 1 FROM skills WHERE name = 'Perception';
    
    INSERT INTO character_skills (character_id, skill_id, proficient, custom_bonus)
    SELECT char_id, skill_id, true, 1 FROM skills WHERE name = 'Survival';
    
    INSERT INTO character_skills (character_id, skill_id, proficient, custom_bonus)
    SELECT char_id, skill_id, true, 2 FROM skills WHERE name = 'History';
    
    -- Add status effects
    INSERT INTO character_status_effects (character_id, effect_id, source, duration_remaining, notes)
    SELECT char_id, effect_id, 'Party Cleric', 450, 'Cast during morning preparations' 
    FROM status_effects WHERE name = 'Blessed';
    
END $$;

-- =============================================================================
-- SAMPLE WIZARD CHARACTER  
-- =============================================================================

INSERT INTO characters (
    username, character_name, race, class, background, alignment, level, xp,
    strength, dexterity, constitution, intelligence, wisdom, charisma,
    max_hp, current_hp, armor_class, initiative_bonus, speed, proficiency_bonus,
    gold_pieces, spell_slots_1, spell_slots_2, spell_slots_3,
    personality_traits, ideals, bonds, flaws, bio
) VALUES (
    'sample_user',
    'Elara Moonwhisper',
    'High Elf', 
    'Wizard',
    'Sage',
    'Neutral Good',
    5,
    6500,
    8, 14, 13, 16, 12, 11, -- ability scores (INT primary)
    27, 27, 12, 2, 30, 3, -- combat stats  
    75, -- gold
    4, 3, 2, -- spell slots
    'I am horribly, horribly awkward in social situations.',
    'Knowledge is power, and the key to all other forms of power.',
    'The workshop where I learned my trade is the most important place in the world to me.',
    'I speak without really thinking through my words, invariably insulting others.',
    'A young scholar who seeks to unlock the mysteries of magic and the cosmos.'
);

DO $$
DECLARE
    char_id UUID;
BEGIN
    SELECT character_id INTO char_id FROM characters WHERE character_name = 'Elara Moonwhisper';
    
    -- Add weapons
    INSERT INTO character_weapons (character_id, weapon_id, quantity, equipped)
    SELECT char_id, weapon_id, 1, true FROM weapons WHERE name = 'Quarterstaff';
    
    INSERT INTO character_weapons (character_id, weapon_id, quantity, equipped)
    SELECT char_id, weapon_id, 2, false FROM weapons WHERE name = 'Dagger';
    
    -- Add items
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 4 FROM items WHERE name = 'Potion of Healing';
    
    INSERT INTO character_items (character_id, item_id, quantity, notes)
    SELECT char_id, item_id, 1, 'Contains spells: Magic Missile, Shield, Mage Armor, Detect Magic, Misty Step, Web, Fireball, Counterspell' FROM items WHERE name = 'Backpack'; -- Using backpack as spellbook placeholder
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 10 FROM items WHERE name = 'Rations (1 day)';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 1 FROM items WHERE name = 'Rope, Hemp (50 ft)';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 1 FROM items WHERE name = 'Bedroll';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 1 FROM items WHERE name = 'Waterskin';
    
    -- Add skills
    INSERT INTO character_skills (character_id, skill_id, proficient, custom_bonus)
    SELECT char_id, skill_id, true, 3 FROM skills WHERE name = 'Arcana';
    
    INSERT INTO character_skills (character_id, skill_id, proficient, custom_bonus)
    SELECT char_id, skill_id, true, 3 FROM skills WHERE name = 'History';
    
    INSERT INTO character_skills (character_id, skill_id, proficient, custom_bonus) 
    SELECT char_id, skill_id, true, 3 FROM skills WHERE name = 'Investigation';
    
    INSERT INTO character_skills (character_id, skill_id, proficient, custom_bonus)
    SELECT char_id, skill_id, true, 1 FROM skills WHERE name = 'Insight';
    
    -- Add known spells
    INSERT INTO character_spells (character_id, spell_id, known, prepared, spell_attack_bonus, spell_save_dc)
    SELECT char_id, spell_id, true, true, 6, 14 FROM spells WHERE name = 'Fire Bolt';
    
    INSERT INTO character_spells (character_id, spell_id, known, prepared, spell_save_dc)
    SELECT char_id, spell_id, true, true, 14 FROM spells WHERE name = 'Mage Hand';
    
    INSERT INTO character_spells (character_id, spell_id, known, prepared, spell_save_dc)
    SELECT char_id, spell_id, true, true, 14 FROM spells WHERE name = 'Prestidigitation';
    
    INSERT INTO character_spells (character_id, spell_id, known, prepared, spell_save_dc)
    SELECT char_id, spell_id, true, true, 14 FROM spells WHERE name = 'Minor Illusion';
    
    INSERT INTO character_spells (character_id, spell_id, known, prepared, spell_attack_bonus, spell_save_dc)
    SELECT char_id, spell_id, true, true, 6, 14 FROM spells WHERE name = 'Magic Missile';
    
    INSERT INTO character_spells (character_id, spell_id, known, prepared, spell_save_dc)
    SELECT char_id, spell_id, true, true, 14 FROM spells WHERE name = 'Shield';
    
    INSERT INTO character_spells (character_id, spell_id, known, prepared, spell_save_dc)
    SELECT char_id, spell_id, true, true, 14 FROM spells WHERE name = 'Mage Armor';
    
    INSERT INTO character_spells (character_id, spell_id, known, prepared, spell_save_dc)
    SELECT char_id, spell_id, true, true, 14 FROM spells WHERE name = 'Detect Magic';
    
    INSERT INTO character_spells (character_id, spell_id, known, prepared, spell_save_dc)
    SELECT char_id, spell_id, true, true, 14 FROM spells WHERE name = 'Misty Step';
    
    INSERT INTO character_spells (character_id, spell_id, known, prepared, spell_save_dc)
    SELECT char_id, spell_id, true, false, 14 FROM spells WHERE name = 'Web';
    
    INSERT INTO character_spells (character_id, spell_id, known, prepared, spell_attack_bonus, spell_save_dc)  
    SELECT char_id, spell_id, true, false, 6, 14 FROM spells WHERE name = 'Scorching Ray';
    
    -- Add status effects
    INSERT INTO character_status_effects (character_id, effect_id, source, duration_remaining, notes)
    SELECT char_id, effect_id, 'Self-cast at dawn', 28800, 'Daily preparation ritual'
    FROM status_effects WHERE name = 'Mage Armor';
    
END $$;

-- =============================================================================
-- SAMPLE ROGUE CHARACTER
-- =============================================================================

INSERT INTO characters (
    username, character_name, race, class, background, alignment, level, xp,
    strength, dexterity, constitution, intelligence, wisdom, charisma,  
    max_hp, current_hp, armor_class, initiative_bonus, speed, proficiency_bonus,
    gold_pieces, personality_traits, ideals, bonds, flaws, bio
) VALUES (
    'sample_user',
    'Shadow Nightwhisper',
    'Halfling',
    'Rogue', 
    'Criminal',
    'Chaotic Neutral',
    4,
    2700,
    10, 18, 14, 13, 12, 14, -- ability scores (DEX primary)
    28, 28, 15, 4, 25, 2, -- combat stats
    200, -- gold
    'I have a joke for every occasion, especially occasions where humor is inappropriate.',
    'I never target people who cant afford to lose a few coins.',
    'Someone I loved died because of a mistake I made. That will never happen again.',
    'When I see something valuable, I cant think about anything but how to steal it.',
    'A nimble halfling who lives in the shadows and makes a living through less-than-legal means.'
);

DO $$
DECLARE  
    char_id UUID;
BEGIN
    SELECT character_id INTO char_id FROM characters WHERE character_name = 'Shadow Nightwhisper';
    
    -- Add weapons
    INSERT INTO character_weapons (character_id, weapon_id, quantity, equipped)
    SELECT char_id, weapon_id, 2, true FROM weapons WHERE name = 'Shortsword';
    
    INSERT INTO character_weapons (character_id, weapon_id, quantity, equipped) 
    SELECT char_id, weapon_id, 1, true FROM weapons WHERE name = 'Shortbow';
    
    INSERT INTO character_weapons (character_id, weapon_id, quantity, equipped)
    SELECT char_id, weapon_id, 4, false FROM weapons WHERE name = 'Dagger';
    
    -- Add armor
    INSERT INTO character_armor (character_id, armor_id, quantity, equipped)
    SELECT char_id, armor_id, 1, true FROM armor WHERE name = 'Studded Leather';
    
    -- Add items
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 1 FROM items WHERE name = 'Thieves Tools';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 1 FROM items WHERE name = 'Crowbar';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 1 FROM items WHERE name = 'Rope, Silk (50 ft)';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 1 FROM items WHERE name = 'Grappling Hook';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 2 FROM items WHERE name = 'Caltrops (bag of 20)';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 1 FROM items WHERE name = 'Ball Bearings (bag of 1000)';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 1 FROM items WHERE name = 'Potion of Healing';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 3 FROM items WHERE name = 'Arrows (20)';
    
    INSERT INTO character_items (character_id, item_id, quantity)
    SELECT char_id, item_id, 5 FROM items WHERE name = 'Rations (1 day)';
    
    -- Add skills (with expertise)
    INSERT INTO character_skills (character_id, skill_id, proficient, expertise, custom_bonus)
    SELECT char_id, skill_id, true, true, 4 FROM skills WHERE name = 'Stealth'; -- Expertise: (4 DEX + 2 Prof) * 2 = 12, but showing base
    
    INSERT INTO character_skills (character_id, skill_id, proficient, expertise, custom_bonus)
    SELECT char_id, skill_id, true, true, 4 FROM skills WHERE name = 'Sleight of Hand';
    
    INSERT INTO character_skills (character_id, skill_id, proficient, custom_bonus)
    SELECT char_id, skill_id, true, 4 FROM skills WHERE name = 'Acrobatics';
    
    INSERT INTO character_skills (character_id, skill_id, proficient, custom_bonus)
    SELECT char_id, skill_id, true, 2 FROM skills WHERE name = 'Deception';
    
    INSERT INTO character_skills (character_id, skill_id, proficient, custom_bonus)
    SELECT char_id, skill_id, true, 1 FROM skills WHERE name = 'Insight';
    
    INSERT INTO character_skills (character_id, skill_id, proficient, custom_bonus)
    SELECT char_id, skill_id, true, 2 FROM skills WHERE name = 'Intimidation';
    
    INSERT INTO character_skills (character_id, skill_id, proficient, custom_bonus)
    SELECT char_id, skill_id, true, 1 FROM skills WHERE name = 'Perception';
    
END $$;

-- =============================================================================
-- HELPFUL QUERIES TO VIEW CHARACTER DATA
-- =============================================================================

-- Query to see a character's complete loadout
/*
SELECT * FROM character_full_view WHERE character_name = 'Sir Gareth Ironbane';

-- Query to see all weapons a character has
SELECT 
    c.character_name,
    w.name AS weapon_name,
    w.damage_dice,
    w.damage_type,
    cw.equipped,
    cw.quantity,
    COALESCE(cw.custom_name, w.name) AS display_name,
    (w.enchantment_bonus + cw.custom_enchantment) AS total_enchantment
FROM characters c
JOIN character_weapons cw ON c.character_id = cw.character_id  
JOIN weapons w ON cw.weapon_id = w.weapon_id
WHERE c.character_name = 'Sir Gareth Ironbane';

-- Query to see character's skill bonuses
SELECT 
    c.character_name,
    s.name AS skill_name,
    s.ability_score,
    cs.proficient,
    cs.expertise,
    cs.custom_bonus,
    CASE 
        WHEN cs.expertise THEN (c.proficiency_bonus * 2) + cs.custom_bonus
        WHEN cs.proficient THEN c.proficiency_bonus + cs.custom_bonus  
        ELSE cs.custom_bonus
    END AS total_bonus
FROM characters c
JOIN character_skills cs ON c.character_id = cs.character_id
JOIN skills s ON cs.skill_id = s.skill_id  
WHERE c.character_name = 'Shadow Nightwhisper'
ORDER BY s.name;

-- Query to see prepared spells for a character
SELECT 
    c.character_name,
    sp.name AS spell_name,
    sp.level,
    sp.school,
    cs.prepared,
    cs.spell_attack_bonus,
    cs.spell_save_dc
FROM characters c
JOIN character_spells cs ON c.character_id = cs.character_id
JOIN spells sp ON cs.spell_id = sp.spell_id
WHERE c.character_name = 'Elara Moonwhisper' AND cs.prepared = true
ORDER BY sp.level, sp.name;
*/

-- =============================================================================
-- COMPLETION MESSAGE
-- =============================================================================

/*
✅ SAMPLE CHARACTERS CREATED WITH NORMALIZED STRUCTURE!

🎭 CHARACTERS ADDED:
1. Sir Gareth Ironbane (Fighter, Level 5)
   - Full plate armor with enchanted shield
   - Magical longsword and tactical weapons  
   - Military skills and battlefield experience
   
2. Elara Moonwhisper (Wizard, Level 5) 
   - Comprehensive spellbook with 12+ spells
   - Academic skills and magical knowledge
   - Spell attack bonuses and save DCs calculated
   
3. Shadow Nightwhisper (Rogue, Level 4)
   - Stealth equipment and thieves' tools
   - Expertise in key rogue skills 
   - Criminal background equipment

🔗 BENEFITS DEMONSTRATED:
- Items linked by reference (change item stats once, affects all characters)
- Skills calculated with proficiency and expertise 
- Spells prepared separately from spells known
- Custom enchantments and naming for personalization
- Clean separation of character data from reference data

📊 READY TO USE:
- Query the character_full_view for complete character sheets
- Admin can edit reference tables to balance items/spells
- Easy to add new characters linking to existing gear
- Performance optimized with proper indexing

🎲 Your normalized D&D database is ready for adventure!
*/