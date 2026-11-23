-- ============================================================
--   QBX VMSpawn | client/suggestions.lua
-- ============================================================

CreateThread(function()
    Wait(500)
    TriggerEvent('chat:addSuggestion', '/vmspawn', 'Spawn & fully upgrade a vehicle by model name', {
        {
            name = 'Model',
            help = 'Spawn name of the vehicle'
        }
    })
end)
