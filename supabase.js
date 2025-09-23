// supabase.js
const SUPABASE_URL = 'https://oitwwvjgkmzffsdsodzm.supabase.co'; // Replace with your Supabase project URL
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9pdHd3dmpna216ZmZzZHNvZHptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg2MTE2NTMsImV4cCI6MjA3NDE4NzY1M30.T0DqzDbBpn-jSBVhjYPCLe7E7PdjSsYkzt-NgYwvyok'; // Replace with your Supabase anon key

const supabase = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Fetch character by username
async function fetchCharacter(username) {
  const { data, error } = await supabase
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
  const { data, error } = await supabase
    .from('characters')
    .update(updates)
    .eq('username', username);
  if (error) {
    alert('Update failed!');
    return null;
  }
  return data;
}

// Real-time sync (optional)
supabase
  .from('characters')
  .on('UPDATE', payload => {
    fetchCharacter(payload.new.username).then(character => {
      if (character) updateUI(character);
    });
  })
  .subscribe();

// Expose functions globally
window.fetchCharacter = fetchCharacter;
window.updateCharacter = updateCharacter;
