// supabase.js
const SUPABASE_URL = 'https://oitwwvjgkmzffsdsodzm.supabase.co'; // Replace with your Supabase project URL
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9pdHd3dmpna216ZmZzZHNvZHptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg2MTE2NTMsImV4cCI6MjA3NDE4NzY1M30.T0DqzDbBpn-jSBVhjYPCLe7E7PdjSsYkzt-NgYwvyok'; // Replace with your Supabase anon key

const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Fetch character by username
async function fetchCharacter(username) {
  const { data, error } = await supabaseClient
    .from('characters')
    .select('*')
    .eq('username', username)
    .single();
  if (error) {
    alert('Character not found!');
    return null;
  }
  return data;
}

// Update character (e.g., add item, change stat)
async function updateCharacter(username, updates) {
  // Try update and return the updated row. Retry once on transient failure.
  for (let attempt = 1; attempt <= 2; attempt++) {
    try {
      const resp = await supabaseClient
        .from('characters')
        .update(updates)
        .eq('username', username)
        .select()
        .single();
      const { data, error } = resp;
      if (error) {
        // If this was the first attempt, wait briefly and retry once
        if (attempt === 1) {
          console.warn(`updateCharacter attempt ${attempt} failed, retrying...`, error);
          await new Promise(r => setTimeout(r, 200));
          continue;
        }
        console.warn('Update returned an error; verifying by refetching character...', error);
        try {
          const fetched = await fetchCharacter(username);
          if (fetched) {
            // Verify that fields in `updates` are present in fetched record
            let match = true;
            for (const key of Object.keys(updates)) {
              const val = updates[key];
              const fetchedVal = fetched[key];
              // Compare arrays/objects via JSON, primitives directly
              if (typeof val === 'object') {
                if (JSON.stringify(val) !== JSON.stringify(fetchedVal)) { match = false; break; }
              } else {
                // treat numbers and strings loosely (coerce)
                if ((fetchedVal === undefined && val !== undefined) || String(fetchedVal) !== String(val)) { match = false; break; }
              }
            }
            if (match) {
              console.info('Verification successful: updates present despite reported error.');
              return fetched;
            }
          }
        } catch (vf) {
          console.error('Verification fetch failed:', vf);
        }
        console.error('Update failed:', error);
        alert('Update failed: ' + (error.message || JSON.stringify(error)));
        return null;
      }
      return data;
    } catch (ex) {
      // Network or unexpected error
      if (attempt === 1) {
        console.warn(`updateCharacter attempt ${attempt} threw, retrying...`, ex);
        await new Promise(r => setTimeout(r, 200));
        continue;
      }
      console.error('Update threw an exception:', ex);
      alert('Update failed: ' + (ex.message || ex));
      return null;
    }
  }
}

// Polling for character updates (call this from your UI after login)
window.startCharacterPolling = function(username, updateCallback, intervalMs = 5000) {
  let polling = setInterval(async () => {
    const character = await fetchCharacter(username);
    if (character && typeof updateCallback === 'function') {
      updateCallback(character);
    }
  }, intervalMs);
  return () => clearInterval(polling); // returns a function to stop polling
};

// Expose functions globally
window.fetchCharacter = fetchCharacter;
window.updateCharacter = updateCharacter;
