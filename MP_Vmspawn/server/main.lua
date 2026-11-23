-- ============================================================
--   QBX VMSpawn | server/main.lua
-- ============================================================

local QBX = exports['qbx_core']

local groupLevel = { god = 3, admin = 2, mod = 1 }

local function PassesGroupCheck(source)
    if not Config.PermissionGroup then return true end
    local Player = QBX:GetPlayer(source)
    if not Player then return false end
    local group    = Player.PlayerData.group or ''
    local required = groupLevel[Config.PermissionGroup] or 99
    local current  = groupLevel[group] or 0
    return current >= required
end

local function PassesCitizenCheck(source)
    local Player = QBX:GetPlayer(source)
    if not Player then return false end
    return Config.AllowedCitizens[Player.PlayerData.citizenid] == true
end

local function HasPermission(source)
    local mode = Config.PermissionMode
    if mode == 'citizen' then return PassesCitizenCheck(source)
    elseif mode == 'group' then return PassesGroupCheck(source)
    elseif mode == 'both' then return PassesGroupCheck(source) or PassesCitizenCheck(source)
    end
    return false
end

RegisterCommand('vmspawn', function(source, args)
    if source == 0 then
        print('[VMSpawn] Cannot be executed from the server console.')
        return
    end

    local Player     = QBX:GetPlayer(source)
    local citizenId  = Player and Player.PlayerData.citizenid or 'unknown'
    local playerName = GetPlayerName(source)

    if not HasPermission(source) then
        print(('[VMSpawn] DENIED — %s (ID %d | CID %s) tried to use /vmspawn'):format(playerName, source, citizenId))
        return
    end

    local model = args[1]
    if not model or model == '' then return end

    model = tostring(model):lower():gsub('[^%w_]', '')
    if model == '' then return end

    TriggerClientEvent('vmspawn:spawnVehicle', source, model)
end, true)

RegisterNetEvent('vmspawn:spawned', function(model)
    local src        = source
    local Player     = QBX:GetPlayer(src)
    local citizenId  = Player and Player.PlayerData.citizenid or 'unknown'
    local playerName = GetPlayerName(src)
    print(('[VMSpawn] SUCCESS — %s (ID %d | CID %s) spawned: %s'):format(playerName, src, citizenId, model))
end)

RegisterNetEvent('vmspawn:failed', function(model, reason)
    local src        = source
    local Player     = QBX:GetPlayer(src)
    local citizenId  = Player and Player.PlayerData.citizenid or 'unknown'
    local playerName = GetPlayerName(src)
    print(('[VMSpawn] FAILED — %s (ID %d | CID %s) model "%s": %s'):format(playerName, src, citizenId, model, reason))
end)
