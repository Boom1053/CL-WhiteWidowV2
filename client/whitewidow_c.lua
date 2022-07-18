-------------------------------
---------- CASE#2506 ----------
-------------------------------	

local QBCore = exports['qb-core']:GetCoreObject()
isLoggedIn = false
PlayerJob = {}
local onDuty = false


CreateThread(function()

    local modelHash = `prop_50s_jukebox` -- The ` return the jenkins hash of a string. see more at: https://cookbook.fivem.net/2019/06/23/lua-support-for-compile-time-jenkins-hashes/
    if not HasModelLoaded(modelHash) then
        -- If the model isnt loaded we request the loading of the model and wait that the model is loaded
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(1)
        end
    end
    
    -- At this moment the model its loaded, so now we can create the object
    local obj = CreateObject(modelHash, vector3(182.64, -260.71, 53.07), true, false, false)
    SetEntityHeading(obj, 68.22 )

end)

-- Gets player job information on player load
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then
            if PlayerData.job.name == "whitewidow" then
                TriggerServerEvent("QBCore:ToggleDuty")
            end
        end
    end)
end) 

--createuseableitem


RegisterNetEvent('case-whitewidowjob:client:usejoint', function(joint)
    TriggerEvent('animations:client:EmoteCommandStart', {"joint"})
    local ped = PlayerPedId()
    Citizen.Wait(650)
    SetPedMotionBlur(ped, true)
    SetTimecycleModifier("spectator3")
    SetPedMovementClipset(ped, "move_m@hobo@a", true)
    SetPedIsDrunk(ped, true)
    ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 3.0)
    Citizen.Wait(60000) 
    SetPedMoveRateOverride(ped, 1.0)
    SetRunSprintMultiplierForPlayer(ped, 1.0)
    SetPedIsDrunk(ped, false)        
    SetPedMotionBlur(ped, false)
    ResetPedMovementClipset(ped)
    ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)
end)


-- White widow duty menu
RegisterNetEvent('case-whitewidowjob:client:WhiteWidowDutyMenu', function(data)
    exports['qb-menu']:openMenu({
        { 
            header = "On/Off Duty",
            isMenuHeader = true
        },
        { 
            header = "• Clock In/Out",
            txt = "Don't forget to clock in and out!",
            params = {
                event = "case-whitewidowjob:client:SetDuty",
            }
        },
        {
            header = "< Exit",
            txt = "", 
            params = { 
                event = "qb-menu:client:closeMenu"
            }
        },
    })
end)
-- Whitewidow On/off duty settings
RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)
RegisterNetEvent('QBCore:Client:SetDuty')
AddEventHandler('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)
RegisterNetEvent("case-whitewidowjob:client:SetDuty")
AddEventHandler("case-whitewidowjob:client:SetDuty", function()
    TriggerServerEvent("QBCore:ToggleDuty")
end)
-- Targeting for white widow storage location
exports['qb-target']:AddBoxZone("whitewidowstorage", Config.WhiteWidowStorage, 1.0, 1.0, {
        name ="whitewidowstorage",
        heading = 338.36,
        debugPoly = false,
        minZ=52.80,
        maxZ=55.00,
    }, {
        options = {
            {
                event = "case-whitewidowjob:client:WhiteWidowStorage",
                icon = "fas fa-box",
                label = "Storage",
                job = "whitewidow",
            },
        },
        distance = 1.5
    })
-- White widow storage
RegisterNetEvent("case-whitewidowjob:client:WhiteWidowStorage")
AddEventHandler("case-whitewidowjob:client:WhiteWidowStorage", function()
    TriggerEvent("inventory:client:SetCurrentStash", "whitewidowstorage")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "whitewidowstorage", {
        maxweight = 500000,
        slots = 40,
    })
end)

-- Targeting for white widow cash register3
-- exports['qb-target']:AddBoxZone("whitewidowpay3", Config.WhiteWidowPay3, 1.0, 100.0, {
--     name="whitewidowpay3",
--     heading= 116.55,
--     debugPoly=false,
--     minZ=52.664,
--     maxZ=56.664
--     }, {
--     options = {
--         {
--             event = "case-whitewidowjob:client:WhiteWidowPay",
--             parms = "1",
--             icon = "fas fa-credit-card",
--             label = "Charge Customer",
--             job = "whitewidow",
--         },
--     },
--     distance = 1.0
-- })
-- White widow cash register requires qb-input
RegisterNetEvent("case-whitewidowjob:client:WhiteWidowPay", function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Till",
        submitText = "Bill Person",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'id',
                text = 'paypal id'
            },
            {
                type = 'number',
                isRequired = true,
                name = 'amount',
                text = '$ amount!'
            }
        }
    })
    if dialog then
        if not dialog.id or not dialog.amount then return end
        TriggerServerEvent("case-whitewidowjob:client:WhiteWidowPay:player", dialog.id, dialog.amount)
    end
end)

-- Open white widow store customise items in config.lua
RegisterNetEvent('inventory:client:OpenWhiteWidowShop')
AddEventHandler('inventory:client:OpenWhiteWidowShop', function()
    local ShopItems = {}
    ShopItems.label = "White Widow"
    ShopItems.items = Config.WhiteWidowItems
    ShopItems.slots = #Config.WhiteWidowItems
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "White Widow", ShopItems)
end)

-- Open vanilla unicorn store customise items in config.lua
RegisterNetEvent('inventory:client:OpenWhiteWidowSnackTable')
AddEventHandler('inventory:client:OpenWhiteWidowSnackTable', function()
    local ShopItems = {}
    ShopItems.label = "White Widow"
    ShopItems.items = Config.WhiteWidowSnackTable
    ShopItems.slots = #Config.WhiteWidowSnackTable
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "White Widow Snacks", ShopItems)
end)

RegisterNetEvent("case-whitewidowjob:client:OpenTray")
AddEventHandler("case-whitewidowjob:client:OpenTray", function()
    TriggerEvent("inventory:client:SetCurrentStash", "whitewidowtray")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "whitewidowtray", {
        maxweight = 20000,
        slots = 5,
    })
end)

-- processing weed
RegisterNetEvent('qb-whitewidowjob:client:processbag', function(data, time, baggedWeed)
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 5000 * time, false)
    QBCore.Functions.Progressbar("Processing", "Bagging "..data, 5000 * time, false, true, {
        disableMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        -- animDict = "amb@prop_human_parking_meter@female@base",
        -- anim = "givetake1_a",
        -- flags = 8,
    }, {}, {}, function() -- Done
        TriggerServerEvent('case-whitewidowjob:server:recievebag', time, baggedWeed)
        ClearPedTasks(PlayerPedId())
    end, function()
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify("Cancelled..", "error")
    end)
end)

-- processing joint
RegisterNetEvent('qb-whitewidowjob:client:processjoint', function(data, time, baggedWeed)
    print(data, time, baggedWeed)
    print(type(baggedWeed))
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_PARKING_METER", 5000 * baggedWeed, false)
    QBCore.Functions.Progressbar("Processing", "Bagging "..data, 5000 * baggedWeed, false, true, {
        disableMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        -- animDict = "amb@prop_human_parking_meter@female@base",
        -- anim = "givetake1_a",
        -- flags = 8,
    }, {}, {}, function() -- Done
        TriggerServerEvent('case-whitewidowjob:server:recievejoint', time, baggedWeed)
        ClearPedTasks(PlayerPedId())
    end, function()
        ClearPedTasks(PlayerPedId())
        QBCore.Functions.Notify("Cancelled..", "error")
    end)
end)

-- Harvest Plants
RegisterNetEvent('case-whitewidowjob:client:HarvestWhiteWidow', function()
	local playerPed = PlayerPedId()
	local success = exports['qb-lock']:StartLockPickCircle(Config.miniGameCircles, Config.miniGameTime, success)
	if success then
        FreezeEntityPosition(playerPed, true)
        QBCore.Functions.Progressbar("robbing_sign", "Harvesting White Widow...", math.random(Config.HarvestTime), false, true, {
            disableMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = Config.dict,
            anim = Config.anim,
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(ped, Config.dict, Config.anim, 1.0)
            ClearPedTasks(playerPed)
            TriggerServerEvent('case-whitewidowjob:server:HarvestWhiteWidow')
            FreezeEntityPosition(playerPed, false)
        end, function()
            StopAnimTask(ped, Config.dict, Config.anim, 1.0)
            ClearPedTasks(playerPed)
            FreezeEntityPosition(playerPed, false)
        end)
	else
        QBCore.Functions.Notify("Failed to harvest cbd white-widow..", "error", 3500)
        ClearPedTasks(playerPed)
	end
end)

RegisterNetEvent('case-whitewidowjob:client:HarvestAK47', function()
	local playerPed = PlayerPedId()
	local success = exports['qb-lock']:StartLockPickCircle(Config.miniGameCircles, Config.miniGameTime, success)
	if success then
        FreezeEntityPosition(playerPed, true)
        QBCore.Functions.Progressbar("robbing_sign", "Harvesting AK47...", math.random(Config.HarvestTime), false, true, {
            disableMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = Config.dict,
            anim = Config.anim,
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(ped, Config.dict, Config.anim, 1.0)
            ClearPedTasks(playerPed)
            TriggerServerEvent('case-whitewidowjob:server:HarvestAK47')
            FreezeEntityPosition(playerPed, false)
        end, function()
            StopAnimTask(ped, Config.dict, Config.anim, 1.0)
            ClearPedTasks(playerPed)
            FreezeEntityPosition(playerPed, false)
        end)
	else
        QBCore.Functions.Notify("Failed to harvest AK47..", "error", 3500)
        ClearPedTasks(playerPed)
	end
end)

RegisterNetEvent('case-whitewidowjob:client:HarvestOGKush', function()
	local playerPed = PlayerPedId()
	local success = exports['qb-lock']:StartLockPickCircle(Config.miniGameCircles, Config.miniGameTime, success)
	if success then
        FreezeEntityPosition(playerPed, true)
        QBCore.Functions.Progressbar("robbing_sign", "Harvesting OGKush...", math.random(Config.HarvestTime), false, true, {
            disableMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = Config.dict,
            anim = Config.anim,
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(ped, Config.dict, Config.anim, 1.0)
            ClearPedTasks(playerPed)
            TriggerServerEvent('case-whitewidowjob:server:HarvestOGKush')
            FreezeEntityPosition(playerPed, false)
        end, function()
            StopAnimTask(ped, Config.dict, Config.anim, 1.0)
            ClearPedTasks(playerPed)
            FreezeEntityPosition(playerPed, false)
        end)
	else
        QBCore.Functions.Notify("Failed to harvest OGKush..", "error", 3500)
        ClearPedTasks(playerPed)
	end
end)

RegisterNetEvent('case-whitewidowjob:client:HarvestSkunk', function()
	local playerPed = PlayerPedId()
	local success = exports['qb-lock']:StartLockPickCircle(Config.miniGameCircles, Config.miniGameTime, success)
	if success then
        FreezeEntityPosition(playerPed, true)
        QBCore.Functions.Progressbar("robbing_sign", "Harvesting Skunk...", math.random(Config.HarvestTime), false, true, {
            disableMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = Config.dict,
            anim = Config.anim,
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(ped, Config.dict, Config.anim, 1.0)
            ClearPedTasks(playerPed)
            TriggerServerEvent('case-whitewidowjob:server:HarvestSkunk')
            FreezeEntityPosition(playerPed, false)
        end, function()
            StopAnimTask(ped, Config.dict, Config.anim, 1.0)
            ClearPedTasks(playerPed)
            FreezeEntityPosition(playerPed, false)
        end)
	else
        QBCore.Functions.Notify("Failed to harvest Skunk..", "error", 3500)
        ClearPedTasks(playerPed)
	end
end)

-- Whitewidow bagging menu
RegisterNetEvent('case-whitewidow:client:TrimmingMenu', function()
    QBCore.Functions.TriggerCallback('case-whitewidowjob:server:returninventory', function(crops, _)
        print(json.encode(crops))
        local trimMenu = {}
        trimMenu[#trimMenu+1] = {
            isHeader = true,
            header = "Weed Bagging",
            txt = "Requires a minimum of 3 crops",
            icon = 'fa-solid fa-cannabis'
        }
        for k, v in pairs(crops) do
            trimMenu[#trimMenu+1] = {
                isHeader = true,
                header = v.label,
                txt = 'Amount in your inventory: '.. v.amount,
                icon = 'fa-solid fa-face-grin-tears',
                params = {
                    event = "case-whitewidowjob:server:baggingweed",
                    isServer = true,
                    args = v.name
                }
            }
        end
        trimMenu[#trimMenu + 1] = {
                header = "Close",
                params = { 
                    event = "qb-menu:client:closeMenu"
                }
        }
        exports['qb-menu']:openMenu(trimMenu)
    end)
end)

-- Whitewidow roll joints menu
RegisterNetEvent('case-whitewidow:client:RollJoints', function()
    QBCore.Functions.TriggerCallback('case-whitewidowjob:server:returninventory', function(_,joints)
        local jointMenu = {}
        jointMenu[#jointMenu+1] = {
            isHeader = true,
            header = "Rolling Joint",
            txt = "1 bag gives 3 joints",
            icon = 'fa-solid fa-cannabis'
        }
        for k, v in pairs(joints) do
            jointMenu[#jointMenu+1] = {
                isHeader = true,
                header = v.label,
                txt = 'Can make '..(v.amount * 3).. ' '.. v.label,
                icon = 'fa-solid fa-face-grin-tears',
                params = {
                    event = "case-whitewidowjob:server:RollJoints",
                    isServer = true,
                    args = v.name
                }
            }
        end
        jointMenu[#jointMenu + 1] = {
                header = "Close",
                params = { 
                    event = "qb-menu:client:closeMenu"
                }
        }
        exports['qb-menu']:openMenu(jointMenu)
    end)
end)

-- Take out vehicle
RegisterNetEvent('case-whitewidowjob:client:GetVehicle', function()
    exports['qb-menu']:openMenu({
        {
            header = "White Widow Garage",
            txt = "Please return your company van after use!",
            isMenuHeader = true
        },
        {
            header = "Take out a Van",
            txt = "$"..Config.VehicleDeposit.." none refundable deposit required",
            params = {
                event = "case-whitewidowjob:server:SpawnVehicle",
                isServer = true,
            }
        },
		{
		    header = "Return Van",
            txt = "Thank you for returning the van!",
            params = {
                event = "case-whitewidowjob:server:DespawnVehicle",
                isServer = true,
            }
        },
        {
            header = "Close",
            params = {
                event = "case-whitewidowjob:client:StopMenu"
            }
        },
    })
end)

-- White widow vehicle spawner
RegisterNetEvent('case-whitewidowjob:client:SpawnVehicle')
AddEventHandler('case-whitewidowjob:client:SpawnVehicle', function()
	SetNewWaypoint(Config.VehicleSpawn.x, Config.VehicleSpawn.y)
		QBCore.Functions.SpawnVehicle(Config.Vehicle, function(veh)
			exports['LegacyFuel']:SetFuel(veh, 100)
			SetVehicleNumberPlateText(veh, 'WWIDOW')
			SetEntityHeading(veh, Config.VehicleSpawnHeading)
			SetEntityAsMissionEntity(veh, true, true)
			TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
			-- TriggerServerEvent("vehicletuning:server:SaveVehicleProps", QBCore.Functions.GetVehicleProperties(veh))
			SetEntityAsMissionEntity(veh, true, true)
			spawnedveh = veh
			rented = true
		end, Config.VehicleSpawn, true)
end)

-- Despawn vehicle
RegisterNetEvent('case-whitewidowjob:client:DespawnVehicle')
AddEventHandler('case-whitewidowjob:client:DespawnVehicle', function()
	DeleteEntity(spawnedveh)
	rented = false
end)

local function smokeJoint(firstWait, shakeCam, relieveStress,loopAmount, shakeMinWait, shakeMaxWait, shake)
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SMOKING_POT", 0, false)
    Wait(firstWait * 1000)
    ClearPedTasks(ped)
    TriggerServerEvent('hud:server:RelieveStress', relieveStress)
    SetTimecycleModifier("drug_flying_base")
    AddArmourToPed(PlayerPedId(), 12)
    SetPedMotionBlur(ped, true)   
    for i = 0, loopAmount do
        ShakeGameplayCam(shakeCam, shake)
        Wait(math.random(shakeMinWait * 1000, shakeMaxWait * 1000))
        print(loopAmount,i)
    end 
    ShakeGameplayCam(shakeCam, 0.0)
    ClearTimecycleModifier()
    ClearPedTasks(ped)
    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
end

-- Use joint effects
-- Use joint skunk
RegisterNetEvent('case-whitewidowjob:client:UseSkunkJoint', function(item)
	local playerPed = PlayerPedId()
	QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
		if HasItem then
            TriggerEvent('animations:client:EmoteCommandStart', {"joint"})
            QBCore.Functions.Progressbar("robbing_sign", "Smoking a "..item.label, 5000, false, true, {
            }, {}, {}, {}, function() -- Done
                TriggerServerEvent("QBCore:Server:RemoveItem", item.name, 1)
                TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[item.name], "remove")
                smokeJoint(3, "FAMILY5_DRUG_TRIP_SHAKE", math.random(1,5), 3, 3, 5, 0.35 )
            end, function()
                ClearPedTasks(playerPed)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            end)
		else		
			QBCore.Functions.Notify('You need a lighter to smoke..', 'error', 3500)
		end
	end, "lighter")
end)

-- Use joint ogkush
RegisterNetEvent('case-whitewidowjob:client:UseOGKushJoint', function(item)
    local playerPed = PlayerPedId()
	QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
		if HasItem then
            TriggerEvent('animations:client:EmoteCommandStart', {"joint"})
            QBCore.Functions.Progressbar("robbing_sign", "Smoking a "..item.label, 5000, false, true, {
            }, {}, {}, {}, function() -- Done
                TriggerServerEvent("QBCore:Server:RemoveItem", item.name, 1)
                TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[item.name], "remove")
                smokeJoint(3, "FAMILY5_DRUG_TRIP_SHAKE", math.random(1,5), 3, 3, 5, 0.35 )
            end, function()
                ClearPedTasks(playerPed)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            end)
		else		
			QBCore.Functions.Notify('You need a lighter to smoke..', 'error', 3500)
		end
	end, "lighter")
end)

-- Use joint whitewidow
RegisterNetEvent('case-whitewidowjob:client:UseWhiteWidowJoint', function(item)
    local playerPed = PlayerPedId()
	QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
		if HasItem then
            TriggerEvent('animations:client:EmoteCommandStart', {"joint"})
            QBCore.Functions.Progressbar("robbing_sign", "Smoking a "..item.label, 5000, false, true, {
            }, {}, {}, {}, function() -- Done
                TriggerServerEvent("QBCore:Server:RemoveItem", item.name, 1)
                TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[item.name], "remove")
                smokeJoint(3, "FAMILY5_DRUG_TRIP_SHAKE", math.random(1,5), 3, 3, 5, 0.35 )
            end, function()
                ClearPedTasks(playerPed)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            end)
		else		
			QBCore.Functions.Notify('You need a lighter to smoke..', 'error', 3500)
		end
	end, "lighter")
end)

-- Use joint ak47
RegisterNetEvent('case-whitewidowjob:client:UseAK47Joint', function(item)
    local playerPed = PlayerPedId()
	QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
		if HasItem then
            TriggerEvent('animations:client:EmoteCommandStart', {"joint"})
            QBCore.Functions.Progressbar("robbing_sign", "Smoking a "..item.label, 5000, false, true, {
            }, {}, {}, {}, function() -- Done
                TriggerServerEvent("QBCore:Server:RemoveItem", item.name, 1)
                TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items[item.name], "remove")
                smokeJoint(3, "FAMILY5_DRUG_TRIP_SHAKE", math.random(1,5), 3, 3, 5, 0.35 )
            end, function()
                ClearPedTasks(playerPed)
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            end)
		else		
			QBCore.Functions.Notify('You need a lighter to smoke..', 'error', 3500)
		end
	end, "lighter")
end)

-- Targeting for white widow cash register
exports['qb-target']:AddBoxZone("whitewidowpay", Config.WhiteWidowPay, 0.4, 1.0, {
    name="whitewidowpay",
    heading= 340.0,
    debugPoly=false,
    minZ=52.664,
    maxZ=56.664
    }, {
    options = {
        {
            event = "case-whitewidowjob:client:WhiteWidowPay",
            parms = "1",
            icon = "fas fa-credit-card",
            label = "Charge Customer",
            job = "whitewidow",
        },
    },
    distance = 1.0
})
-- Targeting for white widow cash register2
exports['qb-target']:AddBoxZone("whitewidowpay2", Config.WhiteWidowPay2, 0.4, 1.0, {
    name="whitewidowpay2",
    heading= 340.71,
    debugPoly=false,
    minZ=52.664,
    maxZ=56.664
    }, {
    options = {
        {
            event = "case-whitewidowjob:client:WhiteWidowPay",
            parms = "1",
            icon = "fas fa-credit-card",
            label = "Charge Customer",
            job = "whitewidow",
        },
    },
    distance = 1.0
})

-- Targeting for white widow shop
exports['qb-target']:AddBoxZone("whitewidowshop", Config.WhiteWidowShop, 5.6, 5.6, {
    name="whitewidowshop",
    heading= 340.0,
    debugPoly=false,
    minZ=52.664,
    maxZ=54.664
    }, {
    options = {
        {
            event = "inventory:client:OpenWhiteWidowShop",
            icon = "fas fa-box", 
            label = "Open Store",
			job = "whitewidow",
        },
    },
    distance = 1.0
})

-- Targeting for whitewidow joint station
exports['qb-target']:AddBoxZone("whitewidowjoints", Config.WhiteWidowJoints, 0.8, 1, {
    name="whitewidowjoints",
    heading= 250,
    debugPoly=false,
    minZ=53.664,
    maxZ=55.664
    }, {
    options = {
        {
            event = "case-whitewidow:client:RollJoints",
            icon = "fas fa-cannabis", 
            label = "Roll Joints",
			job = "whitewidow",
        },
    },
    distance = 1.0
})

-- Targeting for white widow snacks table
exports['qb-target']:AddBoxZone("whitewidowsnacks", Config.WhiteWidowSnacks, 2.5, 1, {
    name="whitewidowsnacks",
    heading= 339,
    debugPoly=false,
    minZ=50.664,
    maxZ=55.664
    }, {
    options = {
        {
            event = "inventory:client:OpenWhiteWidowSnackTable",
            icon = "fas fa-box", 
            label = "Purchase Snacks",
        },
    },
    distance = 1.0
})

-- Targeting for white widow sales tray
exports['qb-target']:AddBoxZone("whitewidowtray", Config.WhiteWidowTray, 0.6, 1.0, {
    name="whitewidowtray",
    heading= 340,
    debugPoly=false,
    minZ=53.664,
    maxZ=55.664
    }, {
    options = {
        {
            event = "case-whitewidowjob:client:OpenTray",
            icon = "fas fa-box", 
            label = "Collect Order",
        },
    },
    distance = 1.0
})

-- Targeting for white widow trimming location
exports['qb-target']:AddBoxZone("whitewidowtrim", Config.WhiteWidowTrim, 4.5, 4.0, {
    name="whitewidowtrim",
    heading= 165.24,
    debugPoly=false,
    minZ=49.0,
    maxZ=51.664
    }, {
    options = {
        {
            event = "case-whitewidow:client:TrimmingMenu",
            icon = "fas fa-cannabis", 
            label = "Put into Bags",
			job = "whitewidow",
        },
    },
    distance = 1.0
})

-- Targeting for skunk plants
exports['qb-target']:AddBoxZone("skunkplants", Config.WhiteWidowWeed1, 6.6, 6.8, {
    name="skunkplants",
    heading= 340,
    debugPoly=false,
    minZ=49.0,
    maxZ=51.664
    }, {
    options = {
        {
            event = "case-whitewidowjob:client:HarvestSkunk",
            icon = "fas fa-cannabis", 
            label = "Harvest Skunk",
        },
    },
    distance = 1.5
})

-- Targeting for og-kush plants
exports['qb-target']:AddBoxZone("ogplants", Config.WhiteWidowWeed2, 6.6, 6.8, {
    name="ogplants",
    heading= 340,
    debugPoly=false,
    minZ=49.0,
    maxZ=51.664
    }, {
    options = {
        {
            event = "case-whitewidowjob:client:HarvestOGKush",
            icon = "fas fa-cannabis", 
            label = "Harvest OG-Kush",
        },
    },
    distance = 1.5
})

-- Targeting for white-widow plants
exports['qb-target']:AddBoxZone("whitewidowplants", Config.WhiteWidowWeed3, 4.2, 4, {
    name="whitewidowplants",
    heading= 249,
    debugPoly=false,
    minZ=49.0,
    maxZ=51.664
    }, {
    options = {
        {
            event = "case-whitewidowjob:client:HarvestWhiteWidow",
            icon = "fas fa-cannabis", 
            label = "Harvest White-Widow",
        },
    },
    distance = 2.0
})
-- Targeting for ak-47 plants
exports['qb-target']:AddBoxZone("akplants", Config.WhiteWidowWeed4, 4.2, 4, {
    name="akplants",
    heading= 249,
    debugPoly=false,
    minZ=49.0,
    maxZ=51.664
    }, {
    options = {
        {
            event = "case-whitewidowjob:client:HarvestAK47",
            icon = "fas fa-cannabis", 
            label = "Harvest AK-47",
        },
    },
    distance = 1.5
})

-- Whitewidow garage targeting location
exports['qb-target']:AddBoxZone("whitewidowgarage", Config.WhiteWidowGarage, 1.0, 6.0, {
    name="whitewidowgarage",
    heading= 66.80,
    debugPoly=true,
    minZ=48.664,
    maxZ=51.664
    }, {
    options = {
        {
            event = "case-whitewidowjob:client:GetVehicle",
            icon = "fas fa-car", 
            label = "Take Out Vehicle",
			job = "whitewidow",
        },
    },
    distance = 1.5
})

-- Targeting for white widow duty menu
exports['qb-target']:AddBoxZone("whitewidowduty", Config.WhiteWidowDuty, 1.0, 1.0, {
    name="whitewidowduty",
    heading= 181.63,
    debugPoly=false,
    minZ=53.66,
    maxZ=54.64
    }, {
    options = {
        {
            event = "case-whitewidowjob:client:WhiteWidowDutyMenu",
            icon = "fas fa-clock", 
            label = "Clock In/Out",
			job = "whitewidow",
        },
    },
    distance = 1.0
})

-- Do not change anything below here
-- Function to close qb-menu
RegisterNetEvent('case-whitewidowjob:client:StopMenu', function()
    exports['qb-menu']:closeMenu()
    ClearPedTasks(PlayerPedId())
end)

-- Animations function
function playAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do 
      Wait(0) 
    end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
    RemoveAnimDict(animDict)
end

-- Creates blip for white widow
Citizen.CreateThread(function()
    whitewidow = AddBlipForCoord(193.24, -244.53, 54.07)
    SetBlipSprite (whitewidow, 469)
    SetBlipDisplay(whitewidow, 4)
    SetBlipScale  (whitewidow, 0.6)
    SetBlipAsShortRange(whitewidow, true)
    SetBlipColour(whitewidow, 52)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("White Widow")
    EndTextCommandSetBlipName(whitewidow)
end)