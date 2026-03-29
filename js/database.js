/**
 * D&D Campaign Manager - Database Operations
 * Uses the local REST API (server.js) instead of Supabase.
 *
 * In production (GitHub Pages), js/config.js sets window.API_CONFIG:
 *   { baseUrl: 'https://your-vps', apiKey: 'secret' }
 * Locally, config.js is absent and relative URLs + no auth are used.
 */

// window.API_CONFIG is set by js/config.js (injected at deploy time, gitignored).
// Falls back to empty strings for local development (same-origin, no auth needed).
const _cfg = (typeof window !== 'undefined' && window.API_CONFIG) || {};
const API_BASE = _cfg.baseUrl || '';
const API_KEY  = _cfg.apiKey  || '';


const _apiHeaders = () => {
    const h = {};
    if (API_KEY) h['x-api-key'] = API_KEY;
    return h;
};

class DndDatabase {

    async _get(path) {
        const res = await fetch(`${API_BASE}${path}`, { headers: _apiHeaders() });
        if (!res.ok) throw new Error((await res.json()).error || res.statusText);
        return res.json();
    }

    async _post(path, body) {
        const res = await fetch(`${API_BASE}${path}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', ..._apiHeaders() },
            body: JSON.stringify(body)
        });
        if (!res.ok) throw new Error((await res.json()).error || res.statusText);
        return res.json();
    }

    async _put(path, body) {
        const res = await fetch(`${API_BASE}${path}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json', ..._apiHeaders() },
            body: JSON.stringify(body)
        });
        if (!res.ok) throw new Error((await res.json()).error || res.statusText);
        return res.json();
    }

    async _delete(path) {
        const res = await fetch(`${API_BASE}${path}`, {
            method: 'DELETE',
            headers: _apiHeaders()
        });
        if (!res.ok) throw new Error((await res.json()).error || res.statusText);
        return res.json();
    }

    // ─── Characters ──────────────────────────────────────────────────────────

    async getCharacterComplete(characterId) {
        return this._get(`/api/characters/${characterId}/complete`);
    }

    async getCharacter(characterId) {
        return this._get(`/api/characters/${characterId}`);
    }

    async getAllCharacters() {
        return this._get('/api/characters');
    }

    async createCharacter(characterData) {
        return this._post('/api/characters', characterData);
    }

    async updateCharacter(characterId, updates) {
        return this._put(`/api/characters/${characterId}`, updates);
    }

    async deleteCharacter(characterId) {
        return this._delete(`/api/characters/${characterId}`);
    }

    // ─── Equipment ───────────────────────────────────────────────────────────

    async getWeapons() {
        return this._get('/api/weapons');
    }

    async getAllWeapons() {
        return this.getWeapons();
    }

    async getArmor() {
        return this._get('/api/armor');
    }

    async getAllArmor() {
        return this.getArmor();
    }

    async getItems() {
        return this._get('/api/items');
    }

    async getAllItems() {
        return this.getItems();
    }

    async addItemToCharacter(characterId, itemId, quantity = 1, equipped = false) {
        return this._post(`/api/characters/${characterId}/items`, { item_id: itemId, quantity, equipped });
    }

    async addWeaponToCharacter(characterId, weaponId, quantity = 1, equipped = false, customName = null) {
        return this._post(`/api/characters/${characterId}/weapons`, {
            weapon_id: weaponId, quantity, equipped, custom_name: customName
        });
    }

    async updateEquipmentStatus(type, characterId, itemId, equipped) {
        return this._put(`/api/characters/${characterId}/equipment`, { type, item_id: itemId, equipped });
    }

    // ─── Spells ──────────────────────────────────────────────────────────────

    async getSpells() {
        return this._get('/api/spells');
    }

    async getAllSpells() {
        return this.getSpells();
    }

    async addSpellToCharacter(characterId, spellId, known = true, prepared = false) {
        return this._post(`/api/characters/${characterId}/spells`, { spell_id: spellId, known, prepared });
    }

    async updateSpellPrepared(characterId, spellId, prepared) {
        return this._put(`/api/characters/${characterId}/spells/${spellId}`, { prepared });
    }

    // ─── Skills ──────────────────────────────────────────────────────────────

    async getSkills() {
        return this._get('/api/skills');
    }

    async getAllSkills() {
        return this.getSkills();
    }

    async updateSkillProficiency(characterId, skillId, proficient, expertise = false) {
        return this._put(`/api/characters/${characterId}/skills/${skillId}`, { proficient, expertise });
    }

    // ─── Status Effects ───────────────────────────────────────────────────────

    async getStatusEffects() {
        return this._get('/api/status-effects');
    }

    async addStatusEffectToCharacter(characterId, effectId, source, durationRemaining = null) {
        return this._post(`/api/characters/${characterId}/status-effects`, {
            effect_id: effectId, source, duration_remaining: durationRemaining
        });
    }

    async removeStatusEffectFromCharacter(characterId, effectId, appliedAt) {
        return this._delete(
            `/api/characters/${characterId}/status-effects/${effectId}?applied_at=${encodeURIComponent(appliedAt)}`
        );
    }
}

const db = new DndDatabase();

// ─── Utility Functions ────────────────────────────────────────────────────────

function getAbilityModifier(score) {
    return Math.floor((score - 10) / 2);
}

function formatModifier(modifier) {
    return modifier >= 0 ? `+${modifier}` : `${modifier}`;
}

function calculateSkillBonus(abilityScore, proficient, expertise, proficiencyBonus, customBonus = 0) {
    let bonus = getAbilityModifier(abilityScore) + customBonus;
    if (proficient) bonus += proficiencyBonus;
    if (expertise) bonus += proficiencyBonus;
    return bonus;
}

function getProficiencyBonus(level) {
    return Math.ceil(level / 4) + 1;
}

function formatGold(amount) {
    if (typeof amount === 'string') {
        const match = amount.match(/(\d+(?:\.\d+)?)\s*(gp|sp|cp)/i);
        if (match) {
            const value = parseFloat(match[1]);
            switch (match[2].toLowerCase()) {
                case 'gp': return Math.round(value);
                case 'sp': return Math.round(value / 10);
                case 'cp': return Math.round(value / 100);
            }
        }
        const numValue = parseFloat(amount);
        return isNaN(numValue) ? 0 : Math.round(numValue);
    }
    return Math.round(amount || 0);
}

function displayGold(amount) {
    return `${formatGold(amount).toLocaleString()} gp`;
}

function showLoading(element) {
    if (element) element.innerHTML = '<div class="loading"></div> Loading...';
}

function showError(message, container = null) {
    const html = `<div class="alert alert-danger"><strong>Error:</strong> ${message}</div>`;
    if (container) container.innerHTML = html;
    else console.error(message);
}

function showSuccess(message, container = null) {
    const html = `<div class="alert alert-success">${message}</div>`;
    if (container) {
        container.innerHTML = html;
        setTimeout(() => { container.innerHTML = ''; }, 3000);
    }
}

function debounce(func, wait) {
    let timeout;
    return function(...args) {
        clearTimeout(timeout);
        timeout = setTimeout(() => func(...args), wait);
    };
}

document.addEventListener('DOMContentLoaded', function() {
    const currentPage = window.location.pathname.split('/').pop();
    document.querySelectorAll('.nav-links a').forEach(link => {
        if (link.getAttribute('href') === currentPage) link.classList.add('active');
    });
    console.log('D&D Campaign Manager initialized');
});

if (typeof module !== 'undefined' && module.exports) {
    module.exports = { db, DndDatabase };
}
