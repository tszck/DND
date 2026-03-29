/**
 * Build script: creates database/dnd.db from SQL source files.
 * Run with: npm run build
 */

const Database = require('better-sqlite3');
const fs = require('fs');
const path = require('path');

const DB_PATH = path.join(__dirname, 'dnd.db');

if (fs.existsSync(DB_PATH)) {
    fs.unlinkSync(DB_PATH);
    console.log('Removed existing database');
}

const db = new Database(DB_PATH);
db.pragma('journal_mode = WAL');
db.pragma('foreign_keys = ON');

// Apply SQLite schema
const schema = fs.readFileSync(path.join(__dirname, 'schema.sqlite.sql'), 'utf8');
db.exec(schema);
console.log('Schema created');

// Convert PostgreSQL array literals '{a,b}' to JSON '["a","b"]'
function convertArrays(sql) {
    return sql.replace(/'\{([^}]*)\}'/g, (_, content) => {
        if (!content.trim()) return "'[]'";
        const items = content.split(',').map(s => s.trim());
        return `'${JSON.stringify(items)}'`;
    });
}

// Strip SQL line comments and block comments
function stripComments(sql) {
    return sql
        .replace(/--[^\n]*/g, '')
        .replace(/\/\*[\s\S]*?\*\//g, '');
}

// Split SQL into individual statements and execute them, skipping PostgreSQL-specific ones
function execStatements(sql) {
    let count = 0;
    const stmts = convertArrays(sql)
        .split(';')
        .map(s => s.trim())
        .filter(s => s.length > 0);

    for (const stmt of stmts) {
        const upper = stmt.toUpperCase();
        // Skip PostgreSQL-specific constructs
        if (upper.startsWith('DO') || upper.startsWith('DECLARE') || upper.includes('$$')) continue;
        try {
            db.prepare(stmt).run();
            count++;
        } catch (err) {
            // Ignore duplicate key violations for idempotent re-runs
            if (!err.message.includes('UNIQUE constraint failed')) {
                console.warn(`  Warning: ${err.message.split('\n')[0]}`);
            }
        }
    }
    return count;
}

// Transform PostgreSQL DO $$ ... $$ blocks into plain SQLite statements.
// Each block declares a char_id variable, selects it, then uses it in INSERTs.
// We replace char_id with an inline subquery.
function execDoBlocks(sql) {
    const doBlockRe = /DO\s*\$\$\s*DECLARE[^B]*BEGIN\s*([\s\S]*?)\s*END\s*\$\$\s*;/gi;
    let match;
    while ((match = doBlockRe.exec(sql)) !== null) {
        const body = match[1];
        const charNameMatch = body.match(/WHERE\s+character_name\s*=\s*'([^']+)'/i);
        if (!charNameMatch) continue;
        const charName = charNameMatch[1].replace(/'/g, "''");
        const subquery = `(SELECT character_id FROM characters WHERE character_name = '${charName}')`;

        const transformed = body
            // Remove the SELECT INTO line
            .replace(/SELECT\s+character_id\s+INTO\s+char_id[^;]+;/gi, '')
            // Replace all remaining char_id references
            .replace(/\bchar_id\b/g, subquery);

        execStatements(transformed);
    }
}

// Load reference data
console.log('Loading reference data...');
const refSql = stripComments(
    fs.readFileSync(path.join(__dirname, 'dnd_reference_data.sql'), 'utf8')
);
const refCount = execStatements(refSql);
console.log(`  ${refCount} statements executed`);

// Load sample characters
console.log('Loading sample characters...');
const sampleSql = fs.readFileSync(path.join(__dirname, 'dnd_sample_characters_normalized.sql'), 'utf8');
const sampleStripped = stripComments(sampleSql);

// Run plain INSERT statements first (skip DO blocks)
const withoutDo = sampleStripped.replace(/DO\s*\$\$[\s\S]*?END\s*\$\$\s*;/gi, '');
execStatements(withoutDo);

// Then process DO blocks
execDoBlocks(sampleSql);
console.log('  Sample characters and equipment linked');

const charCount = db.prepare('SELECT COUNT(*) as n FROM characters').get().n;
const weaponCount = db.prepare('SELECT COUNT(*) as n FROM weapons').get().n;
const itemCount = db.prepare('SELECT COUNT(*) as n FROM items').get().n;

console.log(`\nDatabase ready: ${DB_PATH}`);
console.log(`  Characters: ${charCount}`);
console.log(`  Weapons: ${weaponCount}`);
console.log(`  Items: ${itemCount}`);

db.close();
