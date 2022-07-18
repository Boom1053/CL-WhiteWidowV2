local QBCore = exports['qb-core']:GetCoreObject()

-- callbacks
QBCore.Functions.CreateCallback('case-whitewidowjob:server:returninventory', function(source, cb)

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local items = Player.PlayerData.items
    local tempCrops = {}
    local tempJoints = {}
    
    local drugsCrops = {
        ['crops_white-widow'] = true,
        ['crops_skunk'] = true,
        ['crops_ak47'] = true,
        ['crops_og-kush'] = true,
    }
    for k, v in pairs(items) do
        if drugsCrops[v.name] then
            -- print(json.encode(v.label))
            tempCrops[#tempCrops+1] = {
                name = v.name,
                amount = v.amount,
                label = v.label,
            }
        end
    end
    
    local drugsBags = {
        ['bag_white_widow'] = true,
        ['bag_skunk'] = true,
        ['bag_ak47'] = true,
        ['bag_og-kush'] = true,
    }
    for k, v in pairs(items) do
        if drugsBags[v.name] then
            -- print(json.encode(v.label))
            tempJoints[#tempJoints+1] = {
                name = v.name,
                amount = v.amount,
                label = v.label,
            }
        end
    end
    cb(tempCrops,tempJoints)
end)

-- Weed bagging
RegisterServerEvent('case-whitewidowjob:server:baggingweed', function(args)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local items = Player.PlayerData.items
    local itemAmount = 0
    local weedBagAmount = 0
    local items = Player.PlayerData.items
    local baggedWeed = ''
    for k, v in pairs(items) do
        if args == v.name then
            itemAmount = v.amount
        end
        if 'empty_weed_bag' == v.name then
            weedBagAmount = v.amount
        end
    end

    if itemAmount < 3 then
        TriggerClientEvent('QBCore:Notify', src, 'You need atleast 3 buds of '..args, 'error')
    else
        if weedBagAmount ~= 0 then
            if args == 'crops_skunk' then
                baggedWeed = 'bag_skunk'
            elseif args == 'crops_white-widow' then
                baggedWeed = "bag_white_widow"
            elseif args == 'crops_ak-47' then
                baggedWeed = "bag_ak47"
            elseif args == 'crops_og-kush' then
                baggedWeed = "bag_ogkush"
            end

            local maxBagCanMake = itemAmount//Config.amountNeeded

            if (weedBagAmount - maxBagCanMake) < 0 then
                maxBagCanMake = weedBagAmount
            end

            Player.Functions.RemoveItem(args, maxBagCanMake * Config.amountNeeded)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[args], "remove", maxBagCanMake * Config.amountNeeded)
            
            Player.Functions.RemoveItem("empty_weed_bag", maxBagCanMake)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['empty_weed_bag'], "remove", maxBagCanMake)
                        
            TriggerClientEvent('qb-whitewidowjob:client:processbag', src, args, maxBagCanMake, baggedWeed)

        else
            TriggerClientEvent('QBCore:Notify', src, 'You need atleast 1 bag', 'error')
        end
    end
end)

-- rolling joints
RegisterServerEvent('case-whitewidowjob:server:RollJoints', function(args)
    local itemLabel = QBCore.Shared.Items[args].label
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local items = Player.PlayerData.items
    local itemJoint = ''
    local amountBag = 0
    local amountRollingPaper = 0
    local bagsNeeded = 0

    if args == 'bag_white_widow' then
        itemJoint = 'joint_white_widow'
    elseif args == 'bag_skunk' then
        itemJoint = 'joint_skunk'
    elseif args == 'bag_ogkush' then
        itemJoint = 'joint_og-kush'
    elseif args == 'bag_ak47' then
        itemJoint = 'joint_ak47'
    end

    for k, v in pairs(items) do
        if args == v.name then
            amountBag = v.amount
        end
        if 'rolling_paper' == v.name then
            amountRollingPaper = v.amount
        end
    end

    if amountBag ~= 0 then
        if amountRollingPaper < 3 then
            TriggerClientEvent('QBCore:Notify', src, 'You need atleast 3 rolling papers to make a set of joints', 'error')
        else
            bagsNeeded = amountRollingPaper//3
            if amountBag - bagsNeeded < 0 then
                bagsNeeded = amountBag
            end
            Player.Functions.RemoveItem(args, bagsNeeded)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[args], "remove", bagsNeeded)

            Player.Functions.RemoveItem('rolling_paper', bagsNeeded * 3)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['rolling_paper'], "remove", bagsNeeded * 3)

            TriggerClientEvent('qb-whitewidowjob:client:processjoint', src, args, itemJoint, bagsNeeded)

            -- Player.Functions.AddItem(itemJoint, bagsNeeded * 3, nil, info, {["quality"] = 100})
            -- TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemJoint], "add", bagsNeeded * 3)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You need atleast 1 bag of ' .. itemLabel .. ' to start making a joint', 'error')
    end
end)

RegisterServerEvent('case-whitewidowjob:server:recievebag', function(maxBagCanMake, baggedWeed)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(baggedWeed, maxBagCanMake, nil, info, {["quality"] = 100})
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[baggedWeed], "add", maxBagCanMake)

end)

RegisterServerEvent('case-whitewidowjob:server:recievejoint', function(itemJoint, bagsNeeded)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(itemJoint, bagsNeeded * 3, nil, info, {["quality"] = 100})
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemJoint], "add", bagsNeeded * 3)

end)

-- Harvest skunk plants

RegisterServerEvent('case-whitewidowjob:server:HarvestSkunk', function() 
    local src = source
    local Player  = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(1, 3)
	if (85 >= math.random(1, 100)) then
        if Player.Functions.AddItem("crops_skunk", 1, slot, {["quality"] = 100}) then
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["crops_skunk"], "add", quantity)
			TriggerClientEvent('QBCore:Notify', src, 'You successfully harvested a skunk plant!', 'success')
		end	
	else
        TriggerClientEvent('QBCore:Notify', src, 'You damaged the plant trying to harvest..', 'error')
	end
end)
-- Harvest og-kush plants
RegisterServerEvent('case-whitewidowjob:server:HarvestOGKush', function() 
    local src = source
    local Player  = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(1, 3)
	if (30 >= math.random(1, 100)) then
        if Player.Functions.AddItem("crops_og-kush", 1, slot, {["quality"] = 100}) then
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["crops_og-kush"], "add", quantity)
			TriggerClientEvent('QBCore:Notify', src, 'You successfully harvested a og-kush plant!', 'success')
		end
	else
        TriggerClientEvent('QBCore:Notify', src, 'You damaged the plant trying to harvest..', 'error')
	end
end)
-- Harvest white-widow plants
RegisterServerEvent('case-whitewidowjob:server:HarvestWhiteWidow', function()
    local src = source
    local Player  = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(1, 3)
	if (75 >= math.random(1, 100)) then
        if  Player.Functions.AddItem("crops_white-widow", 1, slot, {["quality"] = 100}) then
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["crops_white-widow"], "add", quantity)
			TriggerClientEvent('QBCore:Notify', src, 'You successfully harvested a white-widow plant!', 'success')
		end	
	else
        TriggerClientEvent('QBCore:Notify', src, 'You damaged the plant trying to harvest..', 'error')
	end
end)
-- Harvest og-kush plants
RegisterServerEvent('case-whitewidowjob:server:HarvestAK47', function() 
    local src = source
    local Player  = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(1, 3)
	if (10 >= math.random(1, 100)) then
        if Player.Functions.AddItem("crops_ak-47", 1, slot, {["quality"] = 100}) then
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["crops_ak-47"], "add", quantity)
			TriggerClientEvent('QBCore:Notify', src, 'You successfully harvested a ak47 plant!', 'success')
		end	
	else
        TriggerClientEvent('QBCore:Notify', src, 'You damaged the plant trying to harvest..', 'error')
	end
end)
-- White widow billing
RegisterServerEvent("case-whitewidowjob:client:WhiteWidowPay:player")
AddEventHandler("case-whitewidowjob:client:WhiteWidowPay:player", function(playerId, amount)
        local biller = QBCore.Functions.GetPlayer(source)
        local billed = QBCore.Functions.GetPlayer(tonumber(playerId))
        local amount = tonumber(amount)
        if biller.PlayerData.job.name == 'whitewidow' then
            if billed ~= nil then
                if biller.PlayerData.citizenid ~= billed.PlayerData.citizenid then
                    if amount and amount > 0 then
                        exports.oxmysql:insert('INSERT INTO phone_invoices (citizenid, amount, society, sender, sendercitizenid) VALUES (@citizenid, @amount, @society, @sender, @sendercitizenid)', {
                            ['@citizenid'] = billed.PlayerData.citizenid,
                            ['@amount'] = amount,
                            ['@society'] = biller.PlayerData.job.name,
                            ['@sender'] = biller.PlayerData.charinfo.firstname,
                            ['@sendercitizenid'] = biller.PlayerData.citizenid
                        })
                        TriggerClientEvent('qb-phone:RefreshPhone', billed.PlayerData.source)
                        TriggerClientEvent('QBCore:Notify', source, 'Invoice Successfully Sent', 'success')
                        TriggerClientEvent('QBCore:Notify', billed.PlayerData.source, 'New Invoice Received')
                    else
                        TriggerClientEvent('QBCore:Notify', source, 'Must Be A Valid Amount Above 0', 'error')
                    end
                else
                    TriggerClientEvent('QBCore:Notify', source, 'You Cannot Bill Yourself', 'error')
                end
            else
                TriggerClientEvent('QBCore:Notify', source, 'Player Not Online', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', source, 'No Access', 'error')
        end
end)
-- White widow spawn vehicle
RegisterServerEvent('case-whitewidowjob:server:SpawnVehicle')
AddEventHandler('case-whitewidowjob:server:SpawnVehicle', function()
		local src = source
    	local Player = QBCore.Functions.GetPlayer(src)
		local carprice = Player.PlayerData.money["bank"]
		if carprice >= Config.VehicleDeposit then
			Player.Functions.RemoveMoney('bank', Config.VehicleDeposit) 
			TriggerClientEvent('case-whitewidowjob:client:SpawnVehicle', src)
		else
			TriggerClientEvent('QBCore:Notify', src, 'You need $'..Config.VehicleDeposit..' to take out a vehicle', "error")   
		end
end)
-- White widow return vehicle
RegisterServerEvent('case-whitewidowjob:server:DespawnVehicle')
AddEventHandler('case-whitewidowjob:server:DespawnVehicle', function()
		local src = source
    	local Player = QBCore.Functions.GetPlayer(src)
		TriggerClientEvent('case-whitewidowjob:client:DespawnVehicle', src)
end)

--useableitem
-- QBCore.Functions.CreateUseableItem("joint_white_widow", function(source, item)
--     local src = source
--     local Player = QBCore.Functions.GetPlayer(src)
-- 	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
--         TriggerClientEvent("case-whitewidowjob:client:usejoint", src, item.name)
--     end
-- end)

-- Use joints
QBCore.Functions.CreateUseableItem("joint_skunk", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    print(item.name)
    if Player.Functions.GetItemByName(item.name) ~= nil then
        TriggerClientEvent("case-whitewidowjob:client:UseSkunkJoint", source, item)
    end
end)
QBCore.Functions.CreateUseableItem("joint_og-kush", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) ~= nil then
        TriggerClientEvent("case-whitewidowjob:client:UseOGKushJoint", source, item)
    end
end)
QBCore.Functions.CreateUseableItem("joint_white_widow", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) ~= nil then
        TriggerClientEvent("case-whitewidowjob:client:UseWhiteWidowJoint", source, item)
    end
end)
QBCore.Functions.CreateUseableItem("joint_ak47", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) ~= nil then
        TriggerClientEvent("case-whitewidowjob:client:UseAK47Joint", source, item)
    end
end)