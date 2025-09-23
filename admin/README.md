# Admin Tools

This folder contains database administration and debugging tools.

## Files

- `quick_fix.html` - Simple migration tool with copy-paste SQL
- `migration_helper.html` - Advanced migration tool with database testing
- `database_checker.html` - Database integrity verification tool
- `test_database.js` - Console script for database testing

## Usage

These tools are for database setup and troubleshooting only. Regular users should use the main application files in the root directory.

To run these tools:
1. Start a local server: `python -m http.server 8000`
2. Navigate to `http://localhost:8000/admin/[tool-name].html`