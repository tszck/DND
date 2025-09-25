/**
 * D&D Campaign Manager - Database Operations
 * Created: September 26, 2025
 * Description: Supabase integration for normalized D&D database
 */

// Supabase Configuration
const SUPABASE_URL = 'https://oitwwvjgkmzffsdsodzm.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9pdHd3dmpna216ZmZzZHNvZHptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg2MTE2NTMsImV4cCI6MjA3NDE4NzY1M30.T0DqzDbBpn-jSBVhjYPCLe7E7PdjSsYkzt-NgYwvyok';

// Initialize Supabase client (assuming Supabase is loaded via CDN)
let supabase;
if (typeof window !== 'undefined' && window.supabase) {
    supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
}

/**
 * Database API Functions
 */
class DndDatabase {
    
    // =====================================
    // CHARACTER OPERATIONS
    // =====================================
    
    /**
     * Get complete character data with all relationships
     */
    async getCharacterComplete(characterId) {
        try {
            const { data, error } = await supabase
                .from('character_full_view')
                .select('*')
                .eq('character_id', characterId)
                .single();
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error fetching character:', error);
            throw error;
        }
    }

    /**
     * Get basic character data (for editing)
     */
    async getCharacter(characterId) {
        try {
            const { data, error } = await supabase
                .from('characters')
                .select('*')
                .eq('character_id', characterId)
                .single();
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error fetching character:', error);
            throw error;
        }
    }
    
    /**
     * Get all characters (for GM dashboard)
     */
    async getAllCharacters() {
        try {
            const { data, error } = await supabase
                .from('characters')
                .select(`
                    character_id,
                    character_name,
                    race,
                    class,
                    level,
                    max_hp,
                    current_hp,
                    armor_class,
                    username,
                    created_at
                `)
                .order('character_name');
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error fetching characters:', error);
            throw error;
        }
    }
    
    /**
     * Create new character
     */
    async createCharacter(characterData) {
        try {
            const { data, error } = await supabase
                .from('characters')
                .insert([characterData])
                .select()
                .single();
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error creating character:', error);
            throw error;
        }
    }
    
    /**
     * Update character
     */
    async updateCharacter(characterId, updates) {
        try {
            const { data, error } = await supabase
                .from('characters')
                .update(updates)
                .eq('character_id', characterId)
                .select()
                .single();
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error updating character:', error);
            throw error;
        }
    }
    
    /**
     * Delete character and all related data
     */
    async deleteCharacter(characterId) {
        try {
            const { error } = await supabase
                .from('characters')
                .delete()
                .eq('character_id', characterId);
                
            if (error) throw error;
            return { success: true };
        } catch (error) {
            console.error('Error deleting character:', error);
            throw error;
        }
    }
    
    // =====================================
    // EQUIPMENT OPERATIONS
    // =====================================
    
    /**
     * Get all available weapons
     */
    async getWeapons() {
        try {
            const { data, error } = await supabase
                .from('weapons')
                .select('*')
                .order('name');
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error fetching weapons:', error);
            throw error;
        }
    }
    
    /**
     * Get all available armor
     */
    async getArmor() {
        try {
            const { data, error } = await supabase
                .from('armor')
                .select('*')
                .order('name');
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error fetching armor:', error);
            throw error;
        }
    }
    
    /**
     * Get all available items
     */
    async getItems() {
        try {
            const { data, error } = await supabase
                .from('items')
                .select('*')
                .order('category', 'name');
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error fetching items:', error);
            throw error;
        }
    }

    /**
     * Get all available items (alias for GM dashboard)
     */
    async getAllItems() {
        return this.getItems();
    }

    /**
     * Get all available weapons (alias for GM dashboard)
     */
    async getAllWeapons() {
        return this.getWeapons();
    }

    /**
     * Get all available armor (alias for GM dashboard)
     */
    async getAllArmor() {
        return this.getArmor();
    }
    
    /**
     * Add item to character
     */
    async addItemToCharacter(characterId, itemId, quantity = 1, equipped = false) {
        try {
            const { data, error } = await supabase
                .from('character_items')
                .insert([{
                    character_id: characterId,
                    item_id: itemId,
                    quantity: quantity,
                    equipped: equipped
                }])
                .select();
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error adding item to character:', error);
            throw error;
        }
    }
    
    /**
     * Add weapon to character
     */
    async addWeaponToCharacter(characterId, weaponId, quantity = 1, equipped = false, customName = null) {
        try {
            const { data, error } = await supabase
                .from('character_weapons')
                .insert([{
                    character_id: characterId,
                    weapon_id: weaponId,
                    quantity: quantity,
                    equipped: equipped,
                    custom_name: customName
                }])
                .select();
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error adding weapon to character:', error);
            throw error;
        }
    }
    
    /**
     * Update equipment equipped status
     */
    async updateEquipmentStatus(type, characterId, itemId, equipped) {
        try {
            const table = type === 'weapon' ? 'character_weapons' : 
                         type === 'armor' ? 'character_armor' : 'character_items';
            const idField = type === 'weapon' ? 'weapon_id' : 
                           type === 'armor' ? 'armor_id' : 'item_id';
            
            const { data, error } = await supabase
                .from(table)
                .update({ equipped: equipped })
                .eq('character_id', characterId)
                .eq(idField, itemId);
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error updating equipment status:', error);
            throw error;
        }
    }
    
    // =====================================
    // SPELL OPERATIONS
    // =====================================
    
    /**
     * Get all available spells
     */
    async getSpells() {
        try {
            const { data, error } = await supabase
                .from('spells')
                .select('*')
                .order('level', 'name');
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error fetching spells:', error);
            throw error;
        }
    }

    /**
     * Get all available spells (alias for GM dashboard)
     */
    async getAllSpells() {
        return this.getSpells();
    }
    
    /**
     * Add spell to character
     */
    async addSpellToCharacter(characterId, spellId, known = true, prepared = false) {
        try {
            const { data, error } = await supabase
                .from('character_spells')
                .insert([{
                    character_id: characterId,
                    spell_id: spellId,
                    known: known,
                    prepared: prepared
                }])
                .select();
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error adding spell to character:', error);
            throw error;
        }
    }
    
    /**
     * Update spell prepared status
     */
    async updateSpellPrepared(characterId, spellId, prepared) {
        try {
            const { data, error } = await supabase
                .from('character_spells')
                .update({ prepared: prepared })
                .eq('character_id', characterId)
                .eq('spell_id', spellId);
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error updating spell status:', error);
            throw error;
        }
    }
    
    // =====================================
    // SKILL OPERATIONS
    // =====================================
    
    /**
     * Get all skills
     */
    async getSkills() {
        try {
            const { data, error } = await supabase
                .from('skills')
                .select('*')
                .order('name');
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error fetching skills:', error);
            throw error;
        }
    }
    
    /**
     * Get all available skills (alias for GM dashboard)
     */
    async getAllSkills() {
        return this.getSkills();
    }
    
    /**
     * Update character skill proficiency
     */
    async updateSkillProficiency(characterId, skillId, proficient, expertise = false) {
        try {
            const { data, error } = await supabase
                .from('character_skills')
                .upsert([{
                    character_id: characterId,
                    skill_id: skillId,
                    proficient: proficient,
                    expertise: expertise
                }])
                .select();
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error updating skill proficiency:', error);
            throw error;
        }
    }
    
    // =====================================
    // STATUS EFFECT OPERATIONS
    // =====================================
    
    /**
     * Get all status effects
     */
    async getStatusEffects() {
        try {
            const { data, error } = await supabase
                .from('status_effects')
                .select('*')
                .order('name');
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error fetching status effects:', error);
            throw error;
        }
    }
    
    /**
     * Add status effect to character
     */
    async addStatusEffectToCharacter(characterId, effectId, source, durationRemaining = null) {
        try {
            const { data, error } = await supabase
                .from('character_status_effects')
                .insert([{
                    character_id: characterId,
                    effect_id: effectId,
                    source: source,
                    duration_remaining: durationRemaining,
                    applied_at: new Date().toISOString()
                }])
                .select();
                
            if (error) throw error;
            return data;
        } catch (error) {
            console.error('Error adding status effect:', error);
            throw error;
        }
    }
    
    /**
     * Remove status effect from character
     */
    async removeStatusEffectFromCharacter(characterId, effectId, appliedAt) {
        try {
            const { error } = await supabase
                .from('character_status_effects')
                .delete()
                .eq('character_id', characterId)
                .eq('effect_id', effectId)
                .eq('applied_at', appliedAt);
                
            if (error) throw error;
            return { success: true };
        } catch (error) {
            console.error('Error removing status effect:', error);
            throw error;
        }
    }
}

// Create global database instance
const db = new DndDatabase();

/**
 * Utility Functions
 */

/**
 * Calculate ability modifier
 */
function getAbilityModifier(score) {
    return Math.floor((score - 10) / 2);
}

/**
 * Format ability modifier with sign
 */
function formatModifier(modifier) {
    return modifier >= 0 ? `+${modifier}` : `${modifier}`;
}

/**
 * Calculate skill bonus
 */
function calculateSkillBonus(abilityScore, proficient, expertise, proficiencyBonus, customBonus = 0) {
    const abilityMod = getAbilityModifier(abilityScore);
    let bonus = abilityMod + customBonus;
    
    if (proficient) {
        bonus += proficiencyBonus;
    }
    
    if (expertise) {
        bonus += proficiencyBonus; // Double proficiency bonus
    }
    
    return bonus;
}

/**
 * Get proficiency bonus by level
 */
function getProficiencyBonus(level) {
    return Math.ceil(level / 4) + 1;
}

/**
 * Format currency - converts to integer gold pieces
 */
function formatGold(amount) {
    if (typeof amount === 'string') {
        // If it's a string like "5 gp" or "2 sp", convert to integer gp
        const match = amount.match(/(\d+(?:\.\d+)?)\s*(gp|sp|cp)/i);
        if (match) {
            const value = parseFloat(match[1]);
            const unit = match[2].toLowerCase();
            switch (unit) {
                case 'gp': return Math.round(value);
                case 'sp': return Math.round(value / 10);
                case 'cp': return Math.round(value / 100);
                default: return Math.round(value);
            }
        }
        // If it's just a number string, convert to integer
        const numValue = parseFloat(amount);
        return isNaN(numValue) ? 0 : Math.round(numValue);
    }
    // If it's already a number, ensure it's an integer
    return Math.round(amount || 0);
}

/**
 * Display currency as integer gold pieces
 */
function displayGold(amount) {
    const gp = formatGold(amount);
    return `${gp.toLocaleString()} gp`;
}

/**
 * Show loading state
 */
function showLoading(element) {
    if (element) {
        element.innerHTML = '<div class="loading"></div> Loading...';
    }
}

/**
 * Show error message
 */
function showError(message, container = null) {
    const errorHtml = `
        <div class="alert alert-danger">
            <strong>Error:</strong> ${message}
        </div>
    `;
    
    if (container) {
        container.innerHTML = errorHtml;
    } else {
        console.error(message);
    }
}

/**
 * Show success message
 */
function showSuccess(message, container = null) {
    const successHtml = `
        <div class="alert alert-success">
            ${message}
        </div>
    `;
    
    if (container) {
        container.innerHTML = successHtml;
        setTimeout(() => {
            container.innerHTML = '';
        }, 3000);
    }
}

/**
 * Debounce function for search inputs
 */
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

/**
 * Initialize application
 */
document.addEventListener('DOMContentLoaded', function() {
    // Check if Supabase is available
    if (!supabase) {
        console.error('Supabase client not initialized. Please check your configuration.');
        return;
    }
    
    // Set up navigation active states
    const currentPage = window.location.pathname.split('/').pop();
    const navLinks = document.querySelectorAll('.nav-links a');
    
    navLinks.forEach(link => {
        if (link.getAttribute('href') === currentPage) {
            link.classList.add('active');
        }
    });
    
    console.log('D&D Campaign Manager initialized');
});

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { db, DndDatabase };
}