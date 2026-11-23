-- ============================================================
--   QBX VMSpawn | shared/config.lua
-- ============================================================

Config = {}

-- ── Permission Mode ──────────────────────────────────────────
-- 'group'    → use QBX group check (Config.PermissionGroup below)
-- 'citizen'  → use the citizen ID whitelist (Config.AllowedCitizens below)
-- 'both'     → player passes if they match EITHER the group OR the whitelist
Config.PermissionMode = 'citizen'

-- QBX group required when mode is 'group' or 'both'
-- Options: 'god', 'admin', 'mod'  |  nil = allow everyone (not recommended)
Config.PermissionGroup = 'admin'

-- ── Citizen ID Whitelist ─────────────────────────────────────
-- Add citizen IDs that are allowed to use /vmspawn regardless of group.
-- Format:  ['citizenid'] = true
-- Set an entry to false (or remove it) to revoke access.
--
-- To find a player's citizen ID in-game: /myid  (if your server has it)
-- or check the QB database: players.citizenid
--
Config.AllowedCitizens = {
    ['xxxxxxxx'] = true,  -- Name  
}

-- ── Spawn Settings ───────────────────────────────────────────

-- Spawn the vehicle directly in front of the player
Config.SpawnInFront  = false
Config.SpawnOffset   = 6.0   -- metres ahead of the player

-- Warp the player into the driver seat after spawn
Config.WarpIntoSeat  = true

-- Delete the vehicle the player is currently in before spawning
Config.DeletePrevious = true

-- ── Upgrades applied to every spawned vehicle ───────────────
Config.Upgrades = {
    Engine       = true,   -- Level 3  (Race Engine)
    Transmission = true,   -- Level 3  (Race Transmission)
    Brakes       = true,   -- Level 2  (Race Brakes)
    Armour       = true,   -- Level 4  (Armour)
    Suspension   = false,  -- Level 3  (Race Suspension)
    Turbo        = true,   -- Enabled
}
