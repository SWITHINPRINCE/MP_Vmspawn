-- ============================================================
--   QBX VMSpawn | client/main.lua
-- ============================================================

local isSpawning = false

local function ApplyMaxMod(vehicle, modIndex)
    local count = GetNumVehicleMods(vehicle, modIndex)
    if count and count > 0 then
        SetVehicleMod(vehicle, modIndex, count - 1, false)
    end
end

local function FullyUpgrade(vehicle)
    SetVehicleModKit(vehicle, 0)
    Wait(100)

    if Config.Upgrades.Engine       then ApplyMaxMod(vehicle, 11) end
    if Config.Upgrades.Transmission then ApplyMaxMod(vehicle, 13) end
    if Config.Upgrades.Brakes       then ApplyMaxMod(vehicle, 12) end
    if Config.Upgrades.Armour       then ApplyMaxMod(vehicle, 16) end
    if Config.Upgrades.Suspension   then ApplyMaxMod(vehicle, 15) end
    if Config.Upgrades.Turbo        then ToggleVehicleMod(vehicle, 18, true) end

    SetVehicleFixed(vehicle)
    SetVehicleEngineOn(vehicle, true, true, false)
end

local function GetSpawnCoords()
    local ped     = PlayerPedId()
    local pos     = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    if Config.SpawnInFront then
        local rad = math.rad(heading)
        return vector3(
            pos.x + (-math.sin(rad) * Config.SpawnOffset),
            pos.y + ( math.cos(rad) * Config.SpawnOffset),
            pos.z
        ), heading
    end

    return pos, heading
end

local function DeleteCurrentVehicle()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        TaskLeaveVehicle(ped, veh, 16)
        Wait(600)
        if DoesEntityExist(veh) then DeleteVehicle(veh) end
    end
end

local function SpawnVehicle(modelName)
    if isSpawning then return end
    isSpawning = true

    local modelHash = GetHashKey(modelName)

    if not IsModelValid(modelHash) or not IsModelAVehicle(modelHash) then
        lib.notify({ title = 'VMSpawn', description = 'Invalid model: ' .. modelName, type = 'error' })
        TriggerServerEvent('vmspawn:failed', modelName, 'invalid model')
        isSpawning = false
        return
    end

    RequestModel(modelHash)
    local elapsed = 0
    while not HasModelLoaded(modelHash) do
        Wait(100)
        elapsed = elapsed + 100
        if elapsed >= 10000 then
            SetModelAsNoLongerNeeded(modelHash)
            TriggerServerEvent('vmspawn:failed', modelName, 'model load timeout')
            isSpawning = false
            return
        end
    end

    if Config.DeletePrevious then DeleteCurrentVehicle() end

    local coords, heading = GetSpawnCoords()
    local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, heading, true, false)

    local waited = 0
    while not DoesEntityExist(vehicle) do
        Wait(50)
        waited = waited + 50
        if waited >= 5000 then
            SetModelAsNoLongerNeeded(modelHash)
            TriggerServerEvent('vmspawn:failed', modelName, 'entity creation failed')
            isSpawning = false
            return
        end
    end

    FullyUpgrade(vehicle)

    if Config.WarpIntoSeat then
        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end

    SetModelAsNoLongerNeeded(modelHash)
    TriggerServerEvent('vmspawn:spawned', modelName)
    isSpawning = false
end

RegisterNetEvent('vmspawn:spawnVehicle', function(model)
    SpawnVehicle(model)
end)
