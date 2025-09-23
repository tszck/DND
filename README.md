# D&D Character Management System

A complete web-based character management system for D&D 5e with balanced mechanics, XP tracking, and real-time database integration.

## 🎮 Quick Start

1. **Open `index.html`** - Main landing page with navigation
2. **Create Characters** - Use `character_generator.html` 
3. **Manage Characters** - Use `character_sheet.html`

## 📁 Project Structure

### Core Application
- `index.html` - Main landing page
- `character_generator.html` - Character creation with balanced bonuses
- `character_sheet.html` - Character management and progression
- `player_guide.html` - Game rules and help
- `supabase.js` - Database connection and API functions
- `rpg_style.css` - Discord-inspired dark theme styling
- `dnd_data.json` - Game data (races, classes, items, spells)

### Folders
- `database/` - SQL schemas and migration scripts
- `admin/` - Database tools and debugging utilities
- `docs/` - Documentation and license files

## ⭐ Features

- **Balanced Character Creation** - Each character gets exactly +6 stat bonuses
- **XP System** - Automatic leveling (100 × current level XP required)
- **Real-time Updates** - Supabase integration for live character data
- **Printable Character Sheets** - Professional PDF-ready output
- **Smart Tooltips** - Contextual help throughout the interface
- **Responsive Design** - Works on desktop and mobile

## 🛠 Setup

1. **Configure Database** - Set up Supabase and update credentials in `supabase.js`
2. **Run Migration** - Apply SQL scripts from `database/` folder
3. **Start Local Server** - Use `python -m http.server 8000` for development

## 🎯 Character Balance

### Stat Bonuses (Total: +6 per character)
- **Race Bonus**: +3 distributed across abilities
- **Class Bonus**: +2 distributed across abilities  
- **Background Bonus**: +1 to one ability

### XP Progression
- **Level 1→2**: 100 XP
- **Level 2→3**: 200 XP
- **Level 3→4**: 300 XP
- **Formula**: 100 × current_level XP needed

## 📊 Database Schema

Characters table includes:
- Core info (username, name, race, class, background)
- All ability scores with balanced bonuses applied
- XP tracking with automatic level progression
- JSON arrays for items, equipment, skills, spells
- Timestamps for creation and updates

For detailed database setup, see `database/supabase_schema.sql`

---

*Ready to start your adventure? Open `index.html` and create your first character!*