-------------------------------
---------- CASE#2506 ----------
-------------------------------
Config = {
WhiteWidowItems =  {-- White widow job only store this is set to 50% smoke on water prices if you use case-outdoorweed
    [1] = { name = "empty_weed_bag",       price = 1,    amount = 1000, info = {}, type = "item", slot = 1 },
    [2] = { name = "rolling_paper",        price = 1,    amount = 2000, info = {}, type = "item", slot = 2 },
    [3] = { name = "lighter",              price = 1,    amount = 1000, info = {}, type = "item", slot = 3 },
    [4] = { name = "weed_nutrition",       price = 50,   amount = 1000, info = {}, type = "item", slot = 4 },
},

WhiteWidowSnackTable = { -- Items list for snack table
    [1] = { name = "kurkakola",       	   price = 3,    amount = 100,  info = {}, type = "item", slot = 1 },
    [2] = { name = "water_bottle",         price = 2, 	 amount = 100,  info = {}, type = "item", slot = 2 },
    [3] = { name = "twerks_candy",         price = 2,    amount = 100,  info = {}, type = "item", slot = 3 },
    [4] = { name = "snikkel_candy",        price = 2,    amount = 100,  info = {}, type = "item", slot = 4 },
},

}
Config.WhiteWidowDuty = vector3(180.57, -252.53, 54.87) -- On duty location change heading in client
Config.WhiteWidowStorage = vector3(184.01, -245.08, 54.07) -- Stash location change heading in client
Config.WhiteWidowPay = vector3(188.27, -243.67, 54.07) -- Epos system location change heading in client
Config.WhiteWidowPay2 = vector3(189.04, -241.26, 54.07) -- Epos system 2 location change heading in client
-- Config.WhiteWidowPay3 = vector3(189.04, -241.26, 54.07) -- Epos system 3 location change heading in client
Config.WhiteWidowShop = vector3(194.31, -235.95, 54.07) -- White widow job shop location change heading in client
Config.WhiteWidowTrim = vector3(165.97, -234.15, 50.06) -- Trimming location location change heading in client
Config.WhiteWidowJoints = vector3(185.54, -241.43, 54.07) -- Joint rolling location change heading in client
Config.WhiteWidowSnacks = vector3(187.06, -247.48, 54.07) -- Snack table location change heading in client
Config.WhiteWidowTray = vector3(188.52, -239.73, 54.07) -- Order
Config.WhiteWidowWeed1 = vector3(168.82, -247.26, 50.06) -- Skunk plants location change heading in client
Config.WhiteWidowWeed2 = vector3(162.04, -244.74, 50.06) -- OG-Kush plants location change heading in client
Config.WhiteWidowWeed3 = vector3(164.33, -238.52, 50.06) -- White-Widow plants location change heading in client
Config.WhiteWidowWeed4 = vector3(170.49, -240.93, 50.07) -- AK-47 location change heading in client
Config.WhiteWidowGarage = vector3(194.99, -267.54, 50.18) -- Vehicle garage location change heading in client
Config.Vehicle = 'rumpo' -- Change vehicle here if not using my custom whitewidow van !!ERROR WITH CUSTOM VAN HAS BEEN REMOVED WILL UPDATE WHEN FIXED REFER TO DISCORD FOR INFORMATION!!
Config.VehicleSpawn = {x = 193.14, y = -274.76, z = 48.94, h = 244.06} -- Vehicle spawn location
Config.VehicleSpawnHeading = 244.06 -- Vehicle spawn heading
Config.VehicleDeposit = 100 -- Vehicle deposit price

Config.dict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
Config.anim = "weed_crouch_checkingleaves_idle_01_inspector"

Config.miniGameTime = math.random(7,10)
Config.miniGameCircles = math.random(2,4)
Config.HarvestTime = math.random(15000,20000)
Config.amountNeeded = 3 -- How many needed to fill 1 bag