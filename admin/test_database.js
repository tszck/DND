// Database Variable Test Script
// Run this in browser console on character_sheet.html page

async function testDatabaseVariables() {
  console.log('🔍 Testing Database Variables...');
  
  try {
    // Test with existing user
    const character = await fetchCharacter('arin');
    
    if (!character) {
      console.log('❌ Character not found');
      return;
    }
    
    console.log('✅ Character found:', character.name);
    
    const expectedVars = [
      'username', 'name', 'race', 'class', 'background', 'level', 'xp',
      'strength', 'dexterity', 'constitution', 'intelligence', 'wisdom', 'charisma',
      'items', 'equipment', 'skills', 'spells', 'bio', 'created_at', 'updated_at'
    ];
    
    const results = {
      present: [],
      missing: [],
      null: []
    };
    
    expectedVars.forEach(varName => {
      if (character.hasOwnProperty(varName)) {
        if (character[varName] === null || character[varName] === undefined) {
          results.null.push(varName);
        } else {
          results.present.push(varName);
        }
      } else {
        results.missing.push(varName);
      }
    });
    
    console.log('✅ Present variables:', results.present);
    console.log('⚠️ Null variables:', results.null);
    console.log('❌ Missing variables:', results.missing);
    console.log('📋 Full character object:', character);
    
    return results;
    
  } catch (error) {
    console.log('❌ Error:', error.message);
  }
}

// Run the test
testDatabaseVariables();