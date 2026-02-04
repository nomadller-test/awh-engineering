// Trip Data Configuration
// Trip Data Configuration
const defaultTripEvents = [
    // Day 1: Feb 7
    { id: 'trip_start', title: 'Trip Start: Agra', time: 'Feb 7', description: 'Taj Mahal & Agra Fort Visit', status: 'pending', icon: '🕌', countCheck: true },
    { id: 'agra_delhi', title: 'Transfer to Delhi', time: 'Feb 7', description: 'Evening transfer from Agra to Delhi', status: 'pending', icon: '🚌' },

    // Day 2: Feb 8
    { id: 'delhi_sight_1', title: 'Delhi Sightseeing', time: 'Feb 8', description: 'Qutub Minar, India Gate, Jama Masjid', status: 'pending', icon: '🏛️' },
    { id: 'volvo_board', title: 'Boarding Volvo', time: 'Feb 8', description: 'Overnight journey to Manali', status: 'pending', icon: '🚌', countCheck: true },

    // Day 3: Feb 9
    { id: 'manali_arrival', title: 'Reached Manali', time: 'Feb 9', description: 'Hotel Check-in & Relax', status: 'pending', icon: '🏨' },
    { id: 'manali_local', title: 'Manali Local', time: 'Feb 9', description: 'Hadimba Temple, Mall Road, Van Vihar', status: 'pending', icon: '🛍️' },

    // Day 4: Feb 10
    { id: 'snow_point', title: 'Snow Adventure', time: 'Feb 10', description: 'Solang Valley, Atal Tunnel, Sissu', status: 'pending', icon: '❄️', countCheck: true },

    // Day 5: Feb 11
    { id: 'kullu_rafting', title: 'Kullu Rafting', time: 'Feb 11', description: 'River Rafting in Kullu', status: 'pending', icon: '🌊' },
    { id: 'kasol_transfer', title: 'Grahan Trek Start', time: 'Feb 11', description: 'Move to Kasol & Trek to Grahan Village', status: 'pending', icon: '🥾', countCheck: true },

    // Day 6: Feb 12
    { id: 'grahan_morning', title: 'Village Morning', time: 'Feb 12', description: 'Explore Grahan Village', status: 'pending', icon: '🌄' },
    { id: 'return_volvo', title: 'Return Journey', time: 'Feb 12', description: 'Trek down & Volvo to Delhi', status: 'pending', icon: '🚌', countCheck: true },

    // Day 7: Feb 13
    { id: 'delhi_sight_2', title: 'Delhi Final Day', time: 'Feb 13', description: 'Akshardham, Lotus Temple, Shopping', status: 'pending', icon: '🕌' },

    // Day 8: Feb 14
    { id: 'departure', title: 'Departure', time: 'Feb 14', description: 'Drop at Railway Station / Airport', status: 'pending', icon: '👋' }
];

// Supabase Configuration
// REPLACE THESE WITH YOUR OWN KEYS FROM SUPABASE DASHBOARD
const SUPABASE_URL = 'https://wgdyfxndajymkuiepqrl.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndnZHlmeG5kYWp5bWt1aWVwcXJsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAxNDcwNjgsImV4cCI6MjA4NTcyMzA2OH0.V10YJw5wAOZLY4RsVDENcG-FgDDaWf5recCE4FUwysk';

// Initialize Client (if library is loaded)
let db;
if (window.supabase && window.supabase.createClient) {
    db = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);
    window.db = db; // Expose for Realtime subscripts
}

// Content Management Class (Async Version)
class TripManager {
    constructor() {
        this.events = [];
    }

    // Fetch all events from Supabase
    async fetchEvents() {
        if (!db) return [];

        const { data, error } = await db
            .from('trip_events')
            .select('*')
            .order('sort_order', { ascending: true });

        if (error) {
            console.error('Error fetching events:', error);
            return [];
        }

        this.events = data;
        return data;
    }

    // Update status
    async updateStatus(id, newStatus) {
        let updates = { status: newStatus };

        // Auto-capture live time
        if (newStatus === 'active' || newStatus === 'completed') {
            const now = new Date();
            updates.time = now.toLocaleString('en-US', {
                month: 'short',
                day: 'numeric',
                hour: 'numeric',
                minute: '2-digit',
                hour12: true
            });
        }

        const { error } = await db
            .from('trip_events')
            .update(updates)
            .eq('id', id);

        if (error) console.error('Error updating status:', error);
        return !error;
    }

    // Update time manual
    async updateTime(id, newTime) {
        const { error } = await db
            .from('trip_events')
            .update({ time: newTime })
            .eq('id', id);

        return !error;
    }

    // Toggle Head Count
    async toggleHeadCount(id) {
        // We need current state first
        const event = this.events.find(e => e.id === id);
        if (!event) return false;

        const { error } = await db
            .from('trip_events')
            .update({ head_count_verified: !event.head_count_verified })
            .eq('id', id);

        return !error;
    }

    // Reset Data (Re-applies defaults logic if needed, or just resets columns)
    async resetData() {
        // Resetting everything to pending/default
        // In a real app we might delete and re-insert, or update all.
        // Here we'll just update all to 'pending' and clear custom times?
        // For simplicity, let's just update all status to pending.

        const { error } = await db
            .from('trip_events')
            .update({
                status: 'pending',
                head_count_verified: false,
                // We might want to keep the original hardcoded dates? 
                // For this demo, let's not wipe the dates completely if they are hardcoded rows.
            })
            .neq('id', 'placeholder'); // Update all

        return !error;
    }

    getEvents() {
        return this.events;
    }
}

// Global Instance
window.tripManager = new TripManager();
