ESX = exports["es_extended"]:getSharedObject()

local cooldown = false

ESX.RegisterServerCallback('rs-getTaskOnMagazine', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    local wystarczy = false

    if cooldown == false then
        wystarczy = true
        TriggerEvent('rs-cooldownMagazine')
    end
    
    cb({    
        data = wystarczy,
    })
end)

ESX.RegisterServerCallback('rs-giveSearchItems', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    Items = {
        Config.Items.item1,
        Config.Items.item2,
        Config.Items.item3,
        Config.Items.item4,
        Config.Items.item5,
    }
    local item = Items[math.random(#Items)]
    xPlayer.addInventoryItem(item, 1)
end)

RegisterNetEvent('rs-cooldownMagazine')
AddEventHandler('rs-cooldownMagazine', function()
    cooldown = true
    Wait(1*60000)
    cooldown = false
end)