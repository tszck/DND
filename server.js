/**
 * D&D Campaign Manager — local server
 * Serves static files and provides a REST API backed by SQLite.
 * Start with: npm start
 */

require('dotenv').config();

const express = require('express');
const Database = require('better-sqlite3');
const path = require('path');
const crypto = require('crypto');

const app = express();
const PORT = process.env.PORT || 3000;
const DB_PATH = path.join(__dirname, 'database', 'dnd.db');
const API_KEY = process.env.API_KEY;               // required in production, optional locally
const ALLOWED_ORIGIN = process.env.ALLOWED_ORIGIN; // e.g. https://yourname.github.io

// CORS — open for local dev, restricted to ALLOWED_ORIGIN in production
app.use((req, res, next) => {
    const origin = req.headers.origin;
    if (!ALLOWED_ORIGIN || origin === ALLOWED_ORIGIN || !origin) {
        if (origin) res.setHeader('Access-Control-Allow-Origin', origin);
        res.setHeader('Access-Control-Allow-Headers', 'Content-Type, x-api-key');
        res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
        res.setHeader('Vary', 'Origin');
    }
    if (req.method === 'OPTIONS') return res.sendStatus(204);
    next();
});

// API key auth — only enforced when API_KEY is set in .env
app.use('/api', (req, res, next) => {
    if (API_KEY && req.headers['x-api-key'] !== API_KEY) {
        return res.status(401).json({ error: 'Unauthorized' });
    }
    next();
});

// Middleware
app.use(express.json());
app.use(express.static(__dirname));

// Database
let db;
try {
    db = new Database(DB_PATH);
    db.pragma('foreign_keys = ON');
    db.pragma('journal_mode = WAL');
} catch (err) {
    console.error(`Cannot open database at ${DB_PATH}`);
    console.error('Run "npm run build" first to create the database.');
    process.exit(1);
}

// Parse JSON aggregate fields returned by character_full_view
function parseCharacterFull(row) {
    if (!row) return null;
    for (const field of ['weapons', 'armor', 'items', 'spells', 'skills', 'status_effects']) {
        try {
            row[field] = row[field] ? JSON.parse(row[field]) : [];
        } catch {
            row[field] = [];
        }
    }
    return row;
}

// ─── Health ────────────────────────────────────────────────────────────────

app.get('/api/health', (req, res) => {
    try {
        const { count } = db.prepare('SELECT COUNT(*) as count FROM characters').get();
        res.json({ status: 'ok', characters: count });
    } catch (err) {
        res.status(500).json({ status: 'error', message: err.message });
    }
});

// ─── Characters ────────────────────────────────────────────────────────────

app.get('/api/characters', (req, res) => {
    try {
        const rows = db.prepare(`
            SELECT character_id, character_name, race, class, level,
                   max_hp, current_hp, armor_class, username, created_at
            FROM characters ORDER BY character_name
        `).all();
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.get('/api/characters/:id', (req, res) => {
    try {
        const row = db.prepare('SELECT * FROM characters WHERE character_id = ?').get(req.params.id);
        if (!row) return res.status(404).json({ error: 'Character not found' });
        res.json(row);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.get('/api/characters/:id/complete', (req, res) => {
    try {
        const row = db.prepare('SELECT * FROM character_full_view WHERE character_id = ?').get(req.params.id);
        if (!row) return res.status(404).json({ error: 'Character not found' });
        res.json(parseCharacterFull(row));
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/api/characters', (req, res) => {
    try {
        const data = { ...req.body, character_id: crypto.randomUUID() };
        const cols = Object.keys(data).join(', ');
        const placeholders = Object.keys(data).map(() => '?').join(', ');
        db.prepare(`INSERT INTO characters (${cols}) VALUES (${placeholders})`).run(...Object.values(data));
        const row = db.prepare('SELECT * FROM characters WHERE character_id = ?').get(data.character_id);
        res.status(201).json(row);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.put('/api/characters/:id', (req, res) => {
    try {
        const updates = req.body;
        const sets = Object.keys(updates).map(k => `${k} = ?`).join(', ');
        db.prepare(`UPDATE characters SET ${sets}, updated_at = datetime('now') WHERE character_id = ?`)
            .run(...Object.values(updates), req.params.id);
        const row = db.prepare('SELECT * FROM characters WHERE character_id = ?').get(req.params.id);
        res.json(row);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.delete('/api/characters/:id', (req, res) => {
    try {
        db.prepare('DELETE FROM characters WHERE character_id = ?').run(req.params.id);
        res.json({ success: true });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// ─── Reference tables ──────────────────────────────────────────────────────

for (const table of ['weapons', 'armor', 'items', 'spells', 'skills']) {
    app.get(`/api/${table}`, (req, res) => {
        try {
            res.json(db.prepare(`SELECT * FROM ${table} ORDER BY name`).all());
        } catch (err) {
            res.status(500).json({ error: err.message });
        }
    });
}

app.get('/api/status-effects', (req, res) => {
    try {
        res.json(db.prepare('SELECT * FROM status_effects ORDER BY name').all());
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// ─── Character equipment ───────────────────────────────────────────────────

app.post('/api/characters/:id/items', (req, res) => {
    try {
        const { item_id, quantity = 1, equipped = false } = req.body;
        db.prepare('INSERT INTO character_items (character_id, item_id, quantity, equipped) VALUES (?, ?, ?, ?)')
            .run(req.params.id, item_id, quantity, equipped ? 1 : 0);
        res.status(201).json({ success: true });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/api/characters/:id/weapons', (req, res) => {
    try {
        const { weapon_id, quantity = 1, equipped = false, custom_name = null } = req.body;
        db.prepare('INSERT INTO character_weapons (character_id, weapon_id, quantity, equipped, custom_name) VALUES (?, ?, ?, ?, ?)')
            .run(req.params.id, weapon_id, quantity, equipped ? 1 : 0, custom_name);
        res.status(201).json({ success: true });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.put('/api/characters/:id/equipment', (req, res) => {
    try {
        const { type, item_id, equipped } = req.body;
        const table = type === 'weapon' ? 'character_weapons' : type === 'armor' ? 'character_armor' : 'character_items';
        const idField = type === 'weapon' ? 'weapon_id' : type === 'armor' ? 'armor_id' : 'item_id';
        db.prepare(`UPDATE ${table} SET equipped = ? WHERE character_id = ? AND ${idField} = ?`)
            .run(equipped ? 1 : 0, req.params.id, item_id);
        res.json({ success: true });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// ─── Character spells ──────────────────────────────────────────────────────

app.post('/api/characters/:id/spells', (req, res) => {
    try {
        const { spell_id, known = true, prepared = false } = req.body;
        db.prepare('INSERT INTO character_spells (character_id, spell_id, known, prepared) VALUES (?, ?, ?, ?)')
            .run(req.params.id, spell_id, known ? 1 : 0, prepared ? 1 : 0);
        res.status(201).json({ success: true });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.put('/api/characters/:id/spells/:spellId', (req, res) => {
    try {
        const { prepared } = req.body;
        db.prepare('UPDATE character_spells SET prepared = ? WHERE character_id = ? AND spell_id = ?')
            .run(prepared ? 1 : 0, req.params.id, req.params.spellId);
        res.json({ success: true });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// ─── Character skills ──────────────────────────────────────────────────────

app.put('/api/characters/:id/skills/:skillId', (req, res) => {
    try {
        const { proficient, expertise = false } = req.body;
        db.prepare(`
            INSERT INTO character_skills (character_id, skill_id, proficient, expertise)
            VALUES (?, ?, ?, ?)
            ON CONFLICT(character_id, skill_id) DO UPDATE
            SET proficient = excluded.proficient, expertise = excluded.expertise
        `).run(req.params.id, req.params.skillId, proficient ? 1 : 0, expertise ? 1 : 0);
        res.json({ success: true });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// ─── Character status effects ──────────────────────────────────────────────

app.post('/api/characters/:id/status-effects', (req, res) => {
    try {
        const { effect_id, source, duration_remaining = null } = req.body;
        const applied_at = new Date().toISOString();
        db.prepare(`
            INSERT INTO character_status_effects
                (character_id, effect_id, source, duration_remaining, applied_at)
            VALUES (?, ?, ?, ?, ?)
        `).run(req.params.id, effect_id, source, duration_remaining, applied_at);
        res.status(201).json({ success: true, applied_at });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.delete('/api/characters/:id/status-effects/:effectId', (req, res) => {
    try {
        const { applied_at } = req.query;
        db.prepare(`
            DELETE FROM character_status_effects
            WHERE character_id = ? AND effect_id = ? AND applied_at = ?
        `).run(req.params.id, req.params.effectId, applied_at);
        res.json({ success: true });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// ─── Start ─────────────────────────────────────────────────────────────────

app.listen(PORT, '127.0.0.1', () => {
    console.log(`D&D Campaign Manager running at http://localhost:${PORT}`);
});
