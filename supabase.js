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
  const { data, error } = await supabaseClient
    .from('characters')
    .update(updates)
    .eq('username', username);
  if (error) {
    alert('Update failed!');
    return null;
  }
  return data;
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
