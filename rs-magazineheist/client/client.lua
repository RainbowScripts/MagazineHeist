local magazineBlock = false
local magazineSearch1 = false
local magazineSearch2 = false
local magazineSearch3 = false
local magazineSearch4 = false
local magazineSearch5 = false
local lastcoords = nil

ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    local repeater = 0
    modelHash = GetHashKey(Config.MagazineTaskPed.pedModel)
    RequestModel(modelHash)
     repeat
     Wait(50)
     repeater = HasModelLoaded(modelHash)
     until(repeater == 1)
    createMagazineTaskPed()
end)

-- FUNCTIONS

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function createMagazineTaskPed()
	created_ped = CreatePed(0, Config.MagazineTaskPed.pedModel, Config.MagazineTaskPed.pedCoords)
	FreezeEntityPosition(created_ped, true)
	SetEntityInvincible(created_ped, true)
	SetBlockingOfNonTemporaryEvents(created_ped, true)
end

local function getTaskOnMagazine()
    Gps = {
        Config.Magazine.Gps_1,
        Config.Magazine.Gps_2,
        Config.Magazine.Gps_3,
      }

    local locationgps = Gps[math.random(#Gps)]

    ESX.TriggerServerCallback('rs-getTaskOnMagazine', function(cb)
        if cb.data then
            ESX.ShowNotification('Za niedługo przekażę ci informacje o zleceniu, nie budź podejrzeń.')
            -- Wait(Config.WaitTimeForTask*60000)
            Wait(5000)
            magazineBlock = true
            Wait(1500)
            SetNewWaypoint(locationgps.x, locationgps.y)
            ESX.ShowNotification('Udaj się do tego magazynu i go okradnij, magazyn zaznaczyłem ci na GPS.')
        else
            ESX.ShowNotification('Obecnie nie mam dla ciebie żadnego zlecenia, wróć to później!')
        end
    end)
end

local function magazineHeist(id)
    if id == 1 then
            local playerPed = PlayerPedId()
            FreezeEntityPosition(playerPed, true)
            loadAnimDict("amb@prop_human_bum_bin@base")
            TaskPlayAnim(playerPed, "amb@prop_human_bum_bin@base", "base", 3.5, - 8, - 1, 2, 0, 0, 0, 0, 0)
            if exports["k5_skillcheck"]:skillCheck("normal") then
                ClearPedTasks(playerPed)
                FreezeEntityPosition(playerPed, false)
                lastcoords = GetEntityCoords(playerPed)
                DoScreenFadeOut(500)
                Wait(750)
                SetEntityCoords(playerPed, 869.48, 1235.64, -101.26)
                DoScreenFadeIn(500)
                magazineSearch1 = true
                magazineSearch2 = true
                magazineSearch3 = true
                magazineSearch4 = true
                magazineSearch5 = true
            else
                local chanceOnNextTry = math.random(1,2)
                if chanceOnNextTry == 1 then
                ClearPedTasks(playerPed)
                FreezeEntityPosition(playerPed, false)
                ESX.ShowNotification('Dostałem informacje że ktoś wezwał Policję, Uciekaj!')
                magazineBlock = false
            else
                ESX.ShowNotification('Nie udało się włamać, spróbuj jeszcze raz.')
            end
        end
    elseif id == 2 then
                DoScreenFadeOut(500)
                magazineBlock = false
                Wait(750)
                SetEntityCoords(PlayerPedId(), lastcoords)
                DoScreenFadeIn(500)
    end
end

function globalSearch()
    -- W TYM MIEJSCU MOŻESZ DODAĆ SWOJEGO PROGBARA --
    FreezeEntityPosition(PlayerPedId(), true)
    TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_BUM_BIN', 0, true)
    Wait(7500)
    FreezeEntityPosition(PlayerPedId(), false)
    ClearPedTasksImmediately(PlayerPedId())
    ESX.TriggerServerCallback('rs-giveSearchItems', function(cb)
    end)
    if magazineSearch1 == false and magazineSearch2 == false and magazineSearch3 == false and magazineSearch4 == false and magazineSearch5 == false then
       ESX.ShowNotification('Dobra, z tego co widzę okradłeś wszystko co możliwe, teraz zbieraj się z tego gówna przed przyjazdem psów!')
    end
end

local function magazineSearch(id)
    if id == 1 then
        magazineSearch1 = false
        globalSearch()
    elseif id == 2 then
        magazineSearch2 = false
        globalSearch()
    elseif id == 3 then
        magazineSearch3 = false
        globalSearch()
    elseif id == 4 then
        magazineSearch4 = false
        globalSearch()
    elseif id == 5 then
        magazineSearch5 = false
        globalSearch()
    end
end

-- TARGETS
Citizen.CreateThread(function()
    exports[Config.Target]:AddBoxZone(Config.MagazineTaskPed.target_task_name, vector3(Config.MagazineTaskPed.target_task_pos), Config.MagazineTaskPed.target_task_length, Config.MagazineTaskPed.target_task_width, {
        name= Config.MagazineTaskPed.target_task_name,
        heading= Config.MagazineTaskPed.target_task_heading,
        minZ= Config.MagazineTaskPed.target_task_minZ,
        maxZ= Config.MagazineTaskPed.target_task_maxZ,
        }, {
            options = {
                {
                    action = function()
                        getTaskOnMagazine()
                    end,
                    icon = "fas fa-hands",
                    label = "Weź Zlecenie",
                }
            },
            distance = 2.0
    })
    exports[Config.Target]:AddBoxZone(Config.Magazine.target_1_name, vector3(Config.Magazine.target_1_pos), Config.Magazine.target_1_length, Config.Magazine.target_1_width, {
        name= Config.Magazine.target_1_name,
        heading= Config.Magazine.target_1_heading,
        minZ= Config.Magazine.target_1_minZ,
        maxZ= Config.Magazine.target_1_maxZ,
        }, {
            options = {
                {
                    action = function(id)
                        magazineHeist(1)
                    end,
                    icon = "fa-solid fa-lock",
                    label = "Włam się",
                    canInteract = function()
                        return magazineBlock
                    end,
                }
            },
            distance = 2.0
    })
    exports[Config.Target]:AddBoxZone(Config.Magazine.target_2_name, vector3(Config.Magazine.target_2_pos), Config.Magazine.target_2_length, Config.Magazine.target_2_width, {
        name= Config.Magazine.target_2_name,
        heading= Config.Magazine.target_2_heading,
        minZ= Config.Magazine.target_2_minZ,
        maxZ= Config.Magazine.target_2_maxZ,
        }, {
            options = {
                {
                    action = function(id)
                        magazineHeist(1)
                    end,
                    icon = "fa-solid fa-lock",
                    label = "Włam się",
                    canInteract = function()
                        return magazineBlock
                    end,
                }
            },
            distance = 2.0
    })
    exports[Config.Target]:AddBoxZone(Config.Magazine.target_3_name, vector3(Config.Magazine.target_3_pos), Config.Magazine.target_3_length, Config.Magazine.target_3_width, {
        name= Config.Magazine.target_3_name,
        heading= Config.Magazine.target_3_heading,
        minZ= Config.Magazine.target_3_minZ,
        maxZ= Config.Magazine.target_3_maxZ,
        }, {
            options = {
                {
                    action = function(id)
                        magazineHeist(1)
                    end,
                    icon = "fa-solid fa-lock",
                    label = "Włam się",
                    canInteract = function()
                        return magazineBlock
                    end,
                }
            },
            distance = 2.0
    })
    exports['qtarget']:AddBoxZone("magazine_exit", vector3(869.24, 1235.71, -101.26), 1, 1.4, {
        name="magazine_exit",
        heading=90,
        --debugPoly=true,
        minZ=-103.66,
        maxZ=-99.66
    }, {
            options = {
                {
                    action = function(id)
                        magazineHeist(2)
                    end,
                    icon = "fa-solid fa-lock-open",
                    label = "Wyjdź",
                    canInteract = function()
                        return magazineBlock
                    end,
                }
            },
            distance = 2.0
    })
    exports['qtarget']:AddBoxZone("magazine_search1", vector3(877.29, 1238.45, -101.26), 1, 3.6, {
        name="magazine_search1",
        heading=0,
        --debugPoly=true,
        minZ=-104.46,
        maxZ=-100.46
    }, {
            options = {
                {
                    action = function(id)
                        magazineSearch(1)
                    end,
                    icon = "fa-solid fa-hands",
                    label = "Przeszukaj",
                    canInteract = function()
                        return magazineSearch1
                    end,
                }
            },
            distance = 2.0
    })
    exports['qtarget']:AddBoxZone("magazine_search2", vector3(863.99, 1230.98, -101.21), 1, 2.6, {
        name="magazine_search2",
        heading=280,
        --debugPoly=true,
        minZ=-104.81,
        maxZ=-100.81
    }, {
            options = {
                {
                    action = function(id)
                        magazineSearch(2)
                    end,
                    icon = "fa-solid fa-hands",
                    label = "Przeszukaj",
                    canInteract = function()
                        return magazineSearch2
                    end,
                }
            },
            distance = 2.0
    })
    exports['qtarget']:AddBoxZone("magazine_search3", vector3(874.71, 1225.63, -101.26), 1, 1.6, {
        name="magazine_search3",
        heading=90,
        --debugPoly=true,
        minZ=-104.26,
        maxZ=-100.26
    }, {
            options = {
                {
                    action = function(id)
                        magazineSearch(3)
                    end,
                    icon = "fa-solid fa-hands",
                    label = "Przeszukaj",
                    canInteract = function()
                        return magazineSearch3
                    end,
                }
            },
            distance = 2.0
    })
    exports['qtarget']:AddBoxZone("magazine_search4", vector3(880.11, 1233.58, -101.26), 1, 1.8, {
        name="magazine_search4",
        heading=270,
        --debugPoly=true,
        minZ=-104.26,
        maxZ=-100.26
    }, {
            options = {
                {
                    action = function(id)
                        magazineSearch(4)
                    end,
                    icon = "fa-solid fa-hands",
                    label = "Przeszukaj",
                    canInteract = function()
                        return magazineSearch4
                    end,
                }
            },
            distance = 2.0
    })
    exports['qtarget']:AddBoxZone("magazine_search5", vector3(880.09, 1229.77, -101.26), 1, 1.6, {
        name="magazine_search5",
        heading=90,
        --debugPoly=true,
        minZ=-104.26,
        maxZ=-100.26
    }, {
            options = {
                {
                    action = function(id)
                        magazineSearch(5)
                    end,
                    icon = "fa-solid fa-hands",
                    label = "Przeszukaj",
                    canInteract = function()
                        return magazineSearch5
                    end,
                }
            },
            distance = 2.0
    })
end)