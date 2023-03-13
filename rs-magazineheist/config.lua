Config = {}

-- MANUAL CONFIG
Config.Target = "qtarget" -- Set your target ( "ox_target" or "qtarget" or "bt-target" )
Config.WaitTimeForTask = 5 -- Set cooldown time for minutes
Config.CoolDown = 30 -- Set cooldown time for minutes

-- ITEMS

Config.MagazineTaskPed = {
    pedModel = "a_m_m_soucent_02", -- Set your ped ( https://docs.fivem.net/docs/game-references/ped-models/ )
    pedCoords = vector4(1068.19, -2586.86, 23.19 -1, 104.66),
    target_task_pos = vector3(1068.29, -2586.79, 23.18),
    target_task_length = 1.0,
    target_task_width = 1.0,
    target_task_name = "magazine_task",
    target_task_heading = 0.0,
    target_task_minZ = 19.98,
    target_task_maxZ = 23.98,
}

Config.Items = {
    item1 = "water",
    item2 = "weapon_pistol",
    item3 = "ammo-9",
    item4 = "burger",
    item5 = "weapon_switchblade",
}

Config.Magazine = {
    --------- MAGAZINE 1 ---------
    Gps_1 = {x = 479.13,   y = -106.51,  z = 63.16},
    target_1_pos = vector3(-1096.61, -1042.19, 2.16),
    target_1_length = 1.0,
    target_1_width = 5.4,
    target_1_name = "magazine_entry_1",
    target_1_heading = 30.0,
    target_1_minZ = 0.24,
    target_1_maxZ = 3.76,
    --------- MAGAZINE 2 ---------
    Gps_2 = {x = -215.21,   y = 6250.38,  z = 31.49},
    target_2_pos = vector3(479.13, -106.51, 63.16),
    target_2_length = 1.0,
    target_2_width = 3.0,
    target_2_name = "magazine_entry_2",
    target_2_heading = 340.0,
    target_2_minZ = 60.76,
    target_2_maxZ = 64.76,
    --------- MAGAZINE 3 ---------
    Gps_3 = {x = -1096.61,   y = -1042.19,  z = 2.16},
    target_3_pos = vector3(-215.21, 6250.38, 31.49),
    target_3_length = 1.0, 
    target_3_width = 4.4, 
    target_3_name = "magazine_entry_3", 
    target_3_heading = 45.0, 
    target_3_minZ = 29.69, 
    target_3_maxZ = 33.69,
}