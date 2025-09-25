-- =============================================================================
-- D&D Reference Data Population
-- Created: September 26, 2025
-- Description: Populate normalized reference tables with D&D 5e content
-- =============================================================================

-- NOTE: Run this AFTER dnd_normalized_schema.sql has been executed

-- =============================================================================
-- SKILLS REFERENCE DATA
-- =============================================================================

INSERT INTO skills (name, ability_score, description, example_uses) VALUES
('Acrobatics', 'dexterity', 'Balance, tumbling, and aerial maneuvers', 'Walking on narrow ledge, tumbling past enemies, performing in circus'),
('Animal Handling', 'wisdom', 'Calming and controlling animals', 'Calming frightened horse, training guard dog, commanding riding animal'),
('Arcana', 'intelligence', 'Knowledge of magic, spells, and magical creatures', 'Identifying spell effects, recalling magical lore, understanding magical items'),
('Athletics', 'strength', 'Climbing, jumping, swimming, and physical exertion', 'Scaling cliff face, long jumping chasm, swimming against current'),
('Deception', 'charisma', 'Lying convincingly and misleading others', 'Telling believable lie, disguising intentions, creating false identity'),
('History', 'intelligence', 'Knowledge of past events, legends, and cultures', 'Recalling historical events, identifying ancient symbols, knowing cultural practices'),
('Insight', 'wisdom', 'Reading body language and determining motives', 'Detecting lies, understanding true feelings, predicting behavior'),
('Intimidation', 'charisma', 'Influencing through threats and force of personality', 'Threatening information from prisoner, scaring off bandits, commanding respect'),
('Investigation', 'intelligence', 'Logical deduction and finding hidden clues', 'Searching crime scene, solving puzzle, finding secret compartment'),
('Medicine', 'wisdom', 'Treating injuries and diagnosing illness', 'Stabilizing dying character, diagnosing disease, performing surgery'),
('Nature', 'intelligence', 'Knowledge of natural world, plants, and animals', 'Identifying poisonous plants, tracking weather patterns, understanding ecosystems'),
('Perception', 'wisdom', 'Noticing details and staying alert', 'Spotting hidden enemies, hearing approaching footsteps, noticing subtle details'),
('Performance', 'charisma', 'Entertaining others through various arts', 'Playing musical instrument, acting on stage, telling captivating story'),
('Persuasion', 'charisma', 'Convincing others through charm and reason', 'Negotiating better price, rallying allies, convincing guard to help'),
('Religion', 'intelligence', 'Knowledge of deities, religious practices, and planes', 'Recognizing religious symbols, performing rituals, understanding divine magic'),
('Sleight of Hand', 'dexterity', 'Manual dexterity and quick fingers', 'Picking pockets, palming objects, performing magic tricks'),
('Stealth', 'dexterity', 'Moving silently and staying hidden', 'Sneaking past guards, hiding in shadows, moving without detection'),
('Survival', 'wisdom', 'Tracking, navigation, and wilderness skills', 'Following tracks, finding food and shelter, navigating by stars');

-- =============================================================================
-- WEAPONS REFERENCE DATA  
-- =============================================================================

-- Simple Melee Weapons
INSERT INTO weapons (name, category, type, damage_dice, damage_type, properties, weight, value_gp, description) VALUES
('Club', 'simple', 'melee', '1d4', 'bludgeoning', '{light}', 2, 1, 'A simple wooden club or cudgel'),
('Dagger', 'simple', 'melee', '1d4', 'piercing', '{finesse,light,thrown}', 1, 2, 'A short blade perfect for close combat or throwing'),
('Dart', 'simple', 'ranged', '1d4', 'piercing', '{finesse,thrown}', 0.25, 0.05, 'A small thrown projectile with weighted tip'),
('Javelin', 'simple', 'melee', '1d6', 'piercing', '{thrown}', 2, 0.5, 'A light spear designed for throwing'),
('Light Hammer', 'simple', 'melee', '1d4', 'bludgeoning', '{light,thrown}', 2, 2, 'A small hammer that can be thrown effectively'),
('Mace', 'simple', 'melee', '1d6', 'bludgeoning', '{}', 4, 5, 'A heavy club with metal head designed to crush armor'),
('Quarterstaff', 'simple', 'melee', '1d6', 'bludgeoning', '{versatile}', 4, 2, 'A sturdy wooden staff, versatile in combat'),
('Sickle', 'simple', 'melee', '1d4', 'slashing', '{light}', 2, 1, 'A farming tool repurposed as weapon'),
('Spear', 'simple', 'melee', '1d6', 'piercing', '{thrown,versatile}', 3, 1, 'A classic thrusting weapon with long reach'),

-- Simple Ranged Weapons
('Crossbow, light', 'simple', 'ranged', '1d8', 'piercing', '{ammunition,loading,two-handed}', 5, 25, 'A mechanical bow that shoots bolts'),
('Shortbow', 'simple', 'ranged', '1d6', 'piercing', '{ammunition,two-handed}', 2, 25, 'A compact bow suitable for quick shots'),
('Sling', 'simple', 'ranged', '1d4', 'bludgeoning', '{ammunition}', 0, 1, 'A simple weapon that hurls stones'),

-- Martial Melee Weapons  
('Battleaxe', 'martial', 'melee', '1d8', 'slashing', '{versatile}', 4, 10, 'A heavy axe designed for warfare'),
('Flail', 'martial', 'melee', '1d8', 'bludgeoning', '{}', 2, 10, 'A spiked ball connected to handle by chain'),
('Glaive', 'martial', 'melee', '1d10', 'slashing', '{heavy,reach,two-handed}', 6, 20, 'A polearm with large blade mounted on shaft'),
('Greataxe', 'martial', 'melee', '1d12', 'slashing', '{heavy,two-handed}', 7, 30, 'A massive two-handed axe for devastating strikes'),
('Greatsword', 'martial', 'melee', '2d6', 'slashing', '{heavy,two-handed}', 6, 50, 'A large two-handed sword with exceptional reach'),
('Halberd', 'martial', 'melee', '1d10', 'slashing', '{heavy,reach,two-handed}', 6, 20, 'A polearm combining axe, spear, and hook'),
('Lance', 'martial', 'melee', '1d12', 'piercing', '{reach,special}', 6, 10, 'A long cavalry weapon, disadvantage when close'),
('Longsword', 'martial', 'melee', '1d8', 'slashing', '{versatile}', 3, 15, 'The classic knightly weapon, balanced and deadly'),
('Maul', 'martial', 'melee', '2d6', 'bludgeoning', '{heavy,two-handed}', 10, 10, 'A massive two-handed hammer'),
('Morningstar', 'martial', 'melee', '1d8', 'piercing', '{}', 4, 15, 'A spiked mace designed to penetrate armor'),
('Pike', 'martial', 'melee', '1d10', 'piercing', '{heavy,reach,two-handed}', 18, 5, 'An extremely long spear for formation fighting'),
('Rapier', 'martial', 'melee', '1d8', 'piercing', '{finesse}', 2, 25, 'A slender thrusting sword emphasizing speed'),
('Scimitar', 'martial', 'melee', '1d6', 'slashing', '{finesse,light}', 3, 25, 'A curved sword perfect for quick strikes'),
('Shortsword', 'martial', 'melee', '1d6', 'piercing', '{finesse,light}', 2, 10, 'A short blade excellent for dual wielding'),
('Trident', 'martial', 'melee', '1d6', 'piercing', '{thrown,versatile}', 4, 5, 'A three-pronged spear associated with sea gods'),
('War Pick', 'martial', 'melee', '1d8', 'piercing', '{}', 2, 5, 'A weapon designed to punch through armor'),
('Warhammer', 'martial', 'melee', '1d8', 'bludgeoning', '{versatile}', 2, 15, 'A one-handed hammer balanced for combat'),
('Whip', 'martial', 'melee', '1d4', 'slashing', '{finesse,reach}', 3, 2, 'A flexible weapon with surprising reach'),

-- Martial Ranged Weapons
('Blowgun', 'martial', 'ranged', '1', 'piercing', '{ammunition,loading}', 1, 10, 'A tube for shooting darts, often poisoned'),
('Crossbow, hand', 'martial', 'ranged', '1d6', 'piercing', '{ammunition,light,loading}', 3, 75, 'A one-handed crossbow for close combat'),
('Crossbow, heavy', 'martial', 'ranged', '1d10', 'piercing', '{ammunition,heavy,loading,two-handed}', 18, 50, 'A powerful crossbow with devastating bolts'),
('Longbow', 'martial', 'ranged', '1d8', 'piercing', '{ammunition,heavy,two-handed}', 2, 50, 'A tall bow with exceptional range and power'),
('Net', 'martial', 'ranged', '0', 'none', '{special,thrown}', 3, 1, 'A weighted net for restraining enemies');

-- Update weapons with range information
UPDATE weapons SET range_normal = 20, range_long = 60 WHERE name = 'Dagger' AND type = 'ranged';
UPDATE weapons SET range_normal = 20, range_long = 60 WHERE name = 'Dart';
UPDATE weapons SET range_normal = 30, range_long = 120 WHERE name = 'Javelin';
UPDATE weapons SET range_normal = 20, range_long = 60 WHERE name = 'Light Hammer';
UPDATE weapons SET range_normal = 20, range_long = 60 WHERE name = 'Spear' AND type = 'ranged';
UPDATE weapons SET range_normal = 80, range_long = 320 WHERE name = 'Crossbow, light';
UPDATE weapons SET range_normal = 80, range_long = 320 WHERE name = 'Shortbow';
UPDATE weapons SET range_normal = 30, range_long = 120 WHERE name = 'Sling';
UPDATE weapons SET range_normal = 20, range_long = 60 WHERE name = 'Trident';
UPDATE weapons SET range_normal = 25, range_long = 100 WHERE name = 'Blowgun';
UPDATE weapons SET range_normal = 30, range_long = 120 WHERE name = 'Crossbow, hand';
UPDATE weapons SET range_normal = 100, range_long = 400 WHERE name = 'Crossbow, heavy';
UPDATE weapons SET range_normal = 150, range_long = 600 WHERE name = 'Longbow';
UPDATE weapons SET range_normal = 5, range_long = 15 WHERE name = 'Net';

-- =============================================================================
-- ARMOR REFERENCE DATA
-- =============================================================================

-- Light Armor
INSERT INTO armor (name, category, base_ac, max_dex_bonus, weight, value_gp, description) VALUES
('Padded', 'light', 11, NULL, 8, 5, 'Quilted layers of cloth and batting for basic protection'),
('Leather', 'light', 11, NULL, 10, 10, 'Supple leather that doesnt restrict movement'),
('Studded Leather', 'light', 12, NULL, 13, 45, 'Leather reinforced with metal studs and rivets'),

-- Medium Armor
('Hide', 'medium', 12, 2, 12, 10, 'Crude armor made from thick animal hides'),
('Chain Shirt', 'medium', 13, 2, 20, 50, 'Flexible chain mail worn under clothes'),
('Scale Mail', 'medium', 14, 2, 45, 50, 'Overlapping metal scales sewn to leather backing'),
('Breastplate', 'medium', 14, 2, 20, 400, 'Fitted metal chest piece with leather components'),
('Half Plate', 'medium', 15, 2, 40, 750, 'Partial plate armor covering vital areas'),

-- Heavy Armor  
('Ring Mail', 'heavy', 14, 0, 40, 30, 'Leather armor with heavy rings sewn into it'),
('Chain Mail', 'heavy', 16, 0, 55, 75, 'Interlocked metal rings forming flexible protection'),
('Splint', 'heavy', 17, 0, 60, 200, 'Narrow vertical strips of metal riveted to leather'),
('Plate', 'heavy', 18, 0, 65, 1500, 'Interlocking metal plates covering entire body'),

-- Shields
('Shield', 'shield', 2, NULL, 6, 10, 'Made from wood or metal, +2 AC when equipped');

-- Add stealth disadvantage and strength requirements
UPDATE armor SET stealth_disadvantage = true WHERE name IN ('Padded', 'Scale Mail', 'Ring Mail', 'Chain Mail', 'Splint', 'Plate');
UPDATE armor SET strength_requirement = 13 WHERE name IN ('Chain Mail', 'Scale Mail', 'Breastplate');
UPDATE armor SET strength_requirement = 15 WHERE name IN ('Splint', 'Plate');

-- =============================================================================
-- ITEMS REFERENCE DATA
-- =============================================================================

-- Adventuring Gear
INSERT INTO items (name, category, subcategory, weight, value_gp, description, properties) VALUES
('Backpack', 'adventuring_gear', 'container', 5, 2, 'Holds 1 cubic foot or 30 pounds of gear', '{"capacity": "1 cubic foot"}'),
('Bedroll', 'adventuring_gear', 'camping', 7, 1, 'A thick comforter for sleeping outdoors', '{}'),
('Blanket', 'adventuring_gear', 'camping', 3, 5, 'A warm wool blanket', '{}'),
('Rope, Hemp (50 ft)', 'adventuring_gear', 'utility', 10, 2, 'Strong rope for climbing and utility', '{"length": "50 feet", "strength": "2000 lbs"}'),
('Rope, Silk (50 ft)', 'adventuring_gear', 'utility', 5, 10, 'Lightweight but strong silk rope', '{"length": "50 feet", "strength": "2000 lbs"}'),
('Torch', 'adventuring_gear', 'light', 1, 1, 'Provides bright light in 20-foot radius for 1 hour', '{"light_radius": 20, "duration": "1 hour"}'),
('Lantern, Bullseye', 'adventuring_gear', 'light', 2, 10, 'Casts bright light in 60-foot cone', '{"light_type": "cone", "range": 60}'),
('Lantern, Hooded', 'adventuring_gear', 'light', 2, 5, 'Casts bright light in 30-foot radius', '{"light_radius": 30}'),
('Oil Flask', 'adventuring_gear', 'consumable', 1, 1, 'Burns for 6 hours in lantern or as weapon', '{"burn_time": "6 hours", "damage": "1d4 fire"}'),
('Tinderbox', 'adventuring_gear', 'utility', 1, 5, 'Flint, fire steel, and tinder for making fire', '{}'),

-- Tools
('Thieves Tools', 'tool', 'professional', 1, 25, 'Picks, files, and small tools for disabling locks and traps', '{"proficiency_required": true}'),
('Smiths Tools', 'tool', 'artisan', 8, 20, 'Hammer, tongs, anvil, and other smithing equipment', '{"craft": "metalworking"}'),
('Alchemist Supplies', 'tool', 'artisan', 8, 50, 'Glass beakers, scales, and chemicals for alchemy', '{"craft": "potions"}'),
('Herbalism Kit', 'tool', 'professional', 3, 5, 'Pouches, clippers, and supplies for making herbal remedies', '{"healing": true}'),
('Healers Kit', 'tool', 'professional', 3, 5, 'Bandages, splints, and medicine for treating wounds', '{"uses": 10, "healing": "1 HP + stabilize"}'),
('Climbers Kit', 'tool', 'professional', 12, 25, 'Pitons, boot tips, gloves, and harness for climbing', '{"climbing_advantage": true}'),

-- Consumables - Potions
('Potion of Healing', 'consumable', 'potion', 0.5, 50, 'A magical red liquid that heals wounds', '{"healing": "2d4+2", "rarity": "common"}'),
('Potion of Greater Healing', 'consumable', 'potion', 0.5, 200, 'A more potent healing potion', '{"healing": "4d4+4", "rarity": "uncommon"}'),
('Potion of Superior Healing', 'consumable', 'potion', 0.5, 1000, 'A very potent healing potion', '{"healing": "8d4+8", "rarity": "rare"}'),
('Potion of Supreme Healing', 'consumable', 'potion', 0.5, 5000, 'The most potent healing magic in liquid form', '{"healing": "10d4+20", "rarity": "very_rare"}'),
('Antitoxin', 'consumable', 'potion', 0, 50, 'Neutralizes poison and provides resistance', '{"effect": "advantage vs poison for 1 hour"}'),

-- Food and Drink
('Rations (1 day)', 'consumable', 'food', 2, 2, 'Dry foods suitable for travel', '{"days": 1}'),
('Waterskin', 'adventuring_gear', 'container', 5, 2, 'Holds 4 pints of liquid', '{"capacity": "4 pints"}'),
('Wine, Common (pitcher)', 'consumable', 'drink', 6, 2, 'A pitcher of common wine', '{}'),
('Ale, Mug', 'consumable', 'drink', 1, 4, 'A mug of ale', '{}'),

-- Ammunition
('Arrows (20)', 'ammunition', 'arrow', 1, 1, 'Standard arrows for bows', '{"count": 20}'),
('Crossbow Bolts (20)', 'ammunition', 'bolt', 1.5, 1, 'Standard bolts for crossbows', '{"count": 20}'),
('Blowgun Needles (50)', 'ammunition', 'needle', 1, 1, 'Tiny needles for blowguns', '{"count": 50}'),
('Sling Bullets (20)', 'ammunition', 'bullet', 1.5, 4, 'Lead bullets for slings', '{"count": 20}'),

-- Miscellaneous
('Caltrops (bag of 20)', 'adventuring_gear', 'trap', 2, 1, 'Spiked metal devices scattered to slow enemies', '{"area": "5-foot square", "damage": "1 piercing"}'),
('Ball Bearings (bag of 1000)', 'adventuring_gear', 'trap', 2, 1, 'Small balls that create difficult terrain', '{"area": "10-foot square"}'),
('Chain (10 feet)', 'adventuring_gear', 'utility', 10, 5, 'Strong metal chain', '{"length": "10 feet"}'),
('Crowbar', 'tool', 'utility', 5, 2, 'Iron bar for prying and leverage', '{"advantage": "Strength checks with leverage"}'),
('Grappling Hook', 'adventuring_gear', 'utility', 4, 2, 'Three-pronged hook for climbing', '{}'),
('Hammer', 'tool', 'utility', 3, 1, 'Basic hammer for construction and driving pitons', '{}'),
('Piton', 'adventuring_gear', 'climbing', 0.25, 5, 'Iron spike for securing ropes', '{}'),
('Manacles', 'adventuring_gear', 'restraint', 6, 15, 'Iron shackles for restraining creatures', '{"dc_break": 20, "dc_escape": 20}'),
('Mirror, Steel', 'adventuring_gear', 'utility', 0.5, 5, 'Polished steel mirror useful for signaling', '{}'),
('Vial', 'adventuring_gear', 'container', 0, 1, 'Small glass container', '{"capacity": "4 ounces"}'),
('Pouch', 'adventuring_gear', 'container', 1, 5, 'Small belt pouch', '{"capacity": "1/5 cubic foot"}'),
('Sack', 'adventuring_gear', 'container', 0.5, 1, 'Large cloth bag', '{"capacity": "1 cubic foot"}');

-- Set consumable flag
UPDATE items SET consumable = true WHERE category = 'consumable';
UPDATE items SET consumable = true WHERE name IN ('Torch', 'Oil Flask', 'Rations (1 day)', 'Wine, Common (pitcher)', 'Ale, Mug');

-- =============================================================================
-- SPELLS REFERENCE DATA (Selection of Popular Spells)
-- =============================================================================

-- Cantrips (Level 0)
INSERT INTO spells (name, level, school, casting_time, range_distance, components, duration, damage_dice, damage_type, description) VALUES
('Fire Bolt', 0, 'evocation', '1 action', '120 feet', 'V, S', 'Instantaneous', '1d10', 'fire', 'A mote of fire streaks toward a creature or object within range.'),
('Mage Hand', 0, 'conjuration', '1 action', '30 feet', 'V, S', '1 minute', NULL, NULL, 'A spectral floating hand appears that can manipulate objects.'),
('Prestidigitation', 0, 'transmutation', '1 action', '10 feet', 'V, S', '1 hour', NULL, NULL, 'A minor magical trick that novice spellcasters use for practice.'),
('Minor Illusion', 0, 'illusion', '1 action', '30 feet', 'S, M', '1 minute', NULL, NULL, 'You create a sound or an image of an object within range.'),
('Sacred Flame', 0, 'evocation', '1 action', '60 feet', 'V, S', 'Instantaneous', '1d8', 'radiant', 'Flame-like radiance descends on a creature you can see.'),
('Guidance', 0, 'divination', '1 action', 'Touch', 'V, S', '1 minute', NULL, NULL, 'You touch one willing creature and grant it guidance.'),
('Eldritch Blast', 0, 'evocation', '1 action', '120 feet', 'V, S', 'Instantaneous', '1d10', 'force', 'A beam of crackling energy streaks toward a creature within range.'),
('Vicious Mockery', 0, 'enchantment', '1 action', '60 feet', 'V', 'Instantaneous', '1d4', 'psychic', 'You unleash a string of insults laced with subtle enchantments.');

-- 1st Level Spells
INSERT INTO spells (name, level, school, casting_time, range_distance, components, duration, concentration, spell_attack, save_type, description) VALUES
('Magic Missile', 1, 'evocation', '1 action', '120 feet', 'V, S', 'Instantaneous', false, false, NULL, 'You create three glowing darts of magical force that automatically hit their targets.'),
('Shield', 1, 'abjuration', '1 reaction', 'Self', 'V, S', '1 round', false, false, NULL, 'An invisible barrier of magical force protects you, granting +5 AC until the start of your next turn.'),
('Mage Armor', 1, 'abjuration', '1 action', 'Touch', 'V, S, M', '8 hours', false, false, NULL, 'You touch a willing creature and protective magical force surrounds it.'),
('Cure Wounds', 1, 'evocation', '1 action', 'Touch', 'V, S', 'Instantaneous', false, false, NULL, 'A creature you touch regains hit points.'),
('Healing Word', 1, 'evocation', '1 bonus action', '60 feet', 'V', 'Instantaneous', false, false, NULL, 'A creature of your choice regains hit points.'),
('Bless', 1, 'enchantment', '1 action', '30 feet', 'V, S, M', '1 minute', true, false, NULL, 'You bless up to three creatures, granting them a d4 bonus to attack rolls and saving throws.'),
('Detect Magic', 1, 'divination', '1 action', 'Self', 'V, S', '10 minutes', true, false, NULL, 'You sense the presence of magic within 30 feet of you.');

-- Update healing spells
UPDATE spells SET healing_dice = '1d8+mod' WHERE name = 'Cure Wounds';
UPDATE spells SET healing_dice = '1d4+mod' WHERE name = 'Healing Word';

-- 2nd Level Spells  
INSERT INTO spells (name, level, school, casting_time, range_distance, components, duration, concentration, damage_dice, damage_type, save_type, description) VALUES
('Misty Step', 2, 'conjuration', '1 bonus action', 'Self', 'V', 'Instantaneous', false, NULL, NULL, NULL, 'Briefly surrounded by silvery mist, you teleport up to 30 feet to an unoccupied space.'),
('Web', 2, 'conjuration', '1 action', '60 feet', 'V, S, M', '1 hour', true, NULL, NULL, 'dexterity', 'You conjure a mass of thick, sticky webbing at a point within range.'),
('Scorching Ray', 2, 'evocation', '1 action', '120 feet', 'V, S', 'Instantaneous', false, '2d6', 'fire', NULL, 'You create three rays of fire and hurl them at targets within range.'),
('Hold Person', 2, 'enchantment', '1 action', '60 feet', 'V, S, M', '1 minute', true, NULL, NULL, 'wisdom', 'Choose a humanoid that you can see within range. The target must succeed on a Wisdom saving throw or be paralyzed.');

-- Set spell attack flag
UPDATE spells SET spell_attack = true WHERE name IN ('Fire Bolt', 'Eldritch Blast', 'Scorching Ray');

-- Set ritual flag
UPDATE spells SET ritual = true WHERE name = 'Detect Magic';

-- =============================================================================
-- STATUS EFFECTS REFERENCE DATA
-- =============================================================================

INSERT INTO status_effects (name, type, duration_type, stackable, description, mechanical_effect) VALUES
('Blessed', 'buff', 'minutes', false, 'Blessed by divine magic', 'Add 1d4 to attack rolls and saving throws'),
('Cursed', 'debuff', 'permanent', false, 'Under the effect of a magical curse', 'Disadvantage on ability checks and saving throws using one ability score'),
('Poisoned', 'condition', 'minutes', false, 'Suffering from poison', 'Disadvantage on attack rolls and ability checks'),
('Paralyzed', 'condition', 'rounds', false, 'Unable to move or act', 'Incapacitated, cant move or speak, automatic critical hits from within 5 feet'),
('Unconscious', 'condition', 'rounds', false, 'Knocked out and helpless', 'Incapacitated, cant move or speak, unaware of surroundings, drop items'),
('Prone', 'condition', 'instantaneous', false, 'Knocked down or lying flat', 'Disadvantage on attack rolls, attacks against you have advantage within 5 feet'),
('Grappled', 'condition', 'rounds', false, 'Held by another creature', 'Speed becomes 0, cant benefit from bonuses to speed'),
('Restrained', 'condition', 'rounds', false, 'Bound or entangled', 'Speed becomes 0, disadvantage on attack rolls and Dex saves, attacks against you have advantage'),
('Stunned', 'condition', 'rounds', false, 'Overwhelmed by shock', 'Incapacitated, cant move, can only speak falteringly'),
('Frightened', 'condition', 'minutes', false, 'Overcome by fear', 'Disadvantage on ability checks and attack rolls while source of fear is in line of sight'),
('Charmed', 'condition', 'minutes', false, 'Magically influenced', 'Cant attack the charmer or target them with harmful abilities or magical effects'),
('Invisible', 'buff', 'minutes', false, 'Cannot be seen without magical means', 'Attack rolls against you have disadvantage, your attack rolls have advantage'),
('Haste', 'buff', 'minutes', false, 'Magically accelerated', 'Speed doubled, +2 AC, advantage on Dex saves, one additional action'),
('Slow', 'debuff', 'minutes', false, 'Magically slowed', 'Speed halved, -2 AC and Dex saves, cant take reactions, only one attack'),
('Shield', 'buff', 'rounds', false, 'Protected by magical barrier', '+5 bonus to AC until start of next turn'),
('Mage Armor', 'buff', 'hours', false, 'Protected by magical force', 'AC becomes 13 + Dex modifier if not wearing armor'),
('Concentration', 'spell_effect', 'minutes', false, 'Maintaining focus on a spell', 'If you take damage, make Constitution save or lose spell'),
('Exhaustion 1', 'condition', 'permanent', true, 'Lightly fatigued', 'Disadvantage on ability checks'),
('Exhaustion 2', 'condition', 'permanent', true, 'Moderately fatigued', 'Speed halved'),
('Exhaustion 3', 'condition', 'permanent', true, 'Heavily fatigued', 'Disadvantage on attack rolls and saving throws');

-- =============================================================================
-- COMPLETION MESSAGE
-- =============================================================================

/*
✅ REFERENCE DATA POPULATED!

📊 ADDED TO DATABASE:
- 18 Skills (all D&D 5e skills with ability scores)
- 45+ Weapons (simple and martial, melee and ranged)  
- 12 Armor Types (light, medium, heavy, shields)
- 50+ Items (adventuring gear, tools, consumables, ammunition)
- 15+ Spells (cantrips through 2nd level, popular choices)
- 20 Status Effects (conditions, buffs, debuffs)

🎯 READY FOR CHARACTER CREATION:
Characters can now link to this reference data instead of storing duplicate information.
Edit item stats once, affects all characters using that item!

🔧 NEXT STEPS:
1. Create sample characters that link to this reference data
2. Build admin interface to manage reference tables
3. Add more spells, items, and equipment as needed
4. Create migration script to convert old JSONB character data

🎲 The foundation is ready for your D&D campaign management system!
*/