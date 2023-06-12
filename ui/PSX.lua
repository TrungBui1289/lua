-- Important Variables
local SCRIPT_NAME = "TrungB PSX GUI"
local SCRIPT_VERSION = "v0.1"

-- Detect if the script has executed by AutoExec
local AutoExecuted = false
if not game:IsLoaded() then AutoExecuted = true end

repeat task.wait() until game.PlaceId ~= nil
if not game:IsLoaded() then game.Loaded:Wait() end

--//-------------- SERVICES ----------------//*
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local InputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local ContentProvider = game:GetService("ContentProvider")

--//*--------- GLOBAL VARIABLES -----------//*
local ScriptIsCurrentlyBusy = false
local Character = nil
local Humanoid = nil
local HumanoidRootPart = nil
local CurrentWorld = ""
local CurrentPosition = nil

--//*--------------- WEB HOOK -------------//*
local Webhook_Enabled = false
local Webhook_URL = ""

LocalPlayer.CharacterAdded:Connect(function(char) 
	Character = char
	Humanoid = Character:WaitForChild("Humanoid")
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)


if game.PlaceId == 6284583030 or game.PlaceId == 10321372166 or game.PlaceId == 7722306047 or game.PlaceId == 12610002282 then
	
	local banSuccess, banError = pcall(function() 
		local Blunder = require(game:GetService("ReplicatedStorage"):WaitForChild("X", 10):WaitForChild("Blunder", 10):WaitForChild("BlunderList", 10))
		if not Blunder or not Blunder.getAndClear then LocalPlayer:Kick("Error while bypassing the anti-cheat! (Didn't find blunder)") end
		
		local OldGet = Blunder.getAndClear
		setreadonly(Blunder, false)
		local function OutputData(Message)
		   print("-- PET SIM X BLUNDER --")
		   print(Message .. "\n")
		end
		
		Blunder.getAndClear = function(...)
		   local Packet = ...
			for i,v in next, Packet.list do
			   if v.message ~= "PING" then
				   OutputData(v.message)
				   table.remove(Packet.list, i)
			   end
		   end
		   return OldGet(Packet)
		end
		
		setreadonly(Blunder, true)
	end)

	if not banSuccess then
		LocalPlayer:Kick("Error while bypassing the anti-cheat! (".. banError ..")")
		return
	end
	
	local Library = require(game:GetService("ReplicatedStorage").Library)
	assert(Library, "Oopps! Library has not been loaded. Maybe try re-joining?") 
	while not Library.Loaded do task.wait() end
	
	Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	Humanoid = Character:WaitForChild("Humanoid")
	HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	
	
	local bypassSuccess, bypassError = pcall(function()
		if not Library.Network then 
			LocalPlayer:Kick("Network not found, can't bypass!")
		end
		
		if not Library.Network.Invoke or not Library.Network.Fire then
			LocalPlayer:Kick("Network Invoke/Fire was not found! Failed to bypass!")
		end
		
		hookfunction(debug.getupvalue(Library.Network.Invoke, 1), function(...) return true end)

		local originalPlay = Library.Audio.Play
		Library.Audio.Play = function(...) 
			if checkcaller() then
				local audioId, parent, pitch, volume, maxDistance, group, looped, timePosition = unpack({ ... })
				if type(audioId) == "table" then
					audioId = audioId[Random.new():NextInteger(1, #audioId)]
				end
				if not parent then
					warn("Parent cannot be nil", debug.traceback())
					return nil
				end
				if audioId == 0 then return nil end
				
				if type(audioId) == "number" or not string.find(audioId, "rbxassetid://", 1, true) then
					audioId = "rbxassetid://" .. audioId
				end
				if pitch and type(pitch) == "table" then
					pitch = Random.new():NextNumber(unpack(pitch))
				end
				if volume and type(volume) == "table" then
					volume = Random.new():NextNumber(unpack(volume))
				end
				if group then
					local soundGroup = game.SoundService:FindFirstChild(group) or nil
				else
					soundGroup = nil
				end
				if timePosition == nil then
					timePosition = 0
				else
					timePosition = timePosition
				end
				local isGargabe = false
				if not pcall(function() local _ = parent.Parent end) then
					local newParent = parent
					pcall(function()
						newParent = CFrame.new(newParent)
					end)
					parent = Instance.new("Part")
					parent.Anchored = true
					parent.CanCollide = false
					parent.CFrame = newParent
					parent.Size = Vector3.new()
					parent.Transparency = 1
					parent.Parent = workspace:WaitForChild("__DEBRIS")
					isGargabe = true
				end
				local sound = Instance.new("Sound")
				sound.SoundId = audioId
				sound.Name = "sound-" .. audioId
				sound.Pitch = pitch and 1
				sound.Volume = volume and 0.5
				sound.SoundGroup = soundGroup
				sound.Looped = looped and false
				sound.MaxDistance = maxDistance and 100
				sound.TimePosition = timePosition
				sound.RollOffMode = Enum.RollOffMode.Linear
				sound.Parent = parent
				if not require(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Client")).Settings.SoundsEnabled then
					sound:SetAttribute("CachedVolume", sound.Volume)
					sound.Volume = 0
				end
				sound:Play()
				getfenv(originalPlay).AddToGarbageCollection(sound, isGargabe)
				return sound
			end
			
			return originalPlay(...)
		end
	
	end)
	
	if not bypassSuccess then
		print(bypassError)
		LocalPlayer:Kick("Error while bypassing network, try again or wait for an update!")
		return
	end
	
	LocalPlayer.PlayerScripts:WaitForChild("Scripts", 10):WaitForChild("Game", 10):WaitForChild("Coins", 10)
	LocalPlayer.PlayerScripts:WaitForChild("Scripts", 10):WaitForChild("Game", 10):WaitForChild("Pets", 10)
	wait()
	
	local GetRemoteFunction = debug.getupvalue(Library.Network.Invoke, 2)
		-- OrbList = debug.getupvalue(orbsScript.Collect, 1)
	local CoinsTable = debug.getupvalue(getsenv(LocalPlayer.PlayerScripts.Scripts.Game:WaitForChild("Coins", 10)).DestroyAllCoins, 1)
	local RenderedPets = debug.getupvalue(getsenv(LocalPlayer.PlayerScripts.Scripts.Game:WaitForChild("Pets", 10)).NetworkUpdate, 1)
	
	
	local IsHardcore = Library.Shared.IsHardcore

	local AllGameWorlds = {}
	for name, world in pairs(Library.Directory.Worlds) do 
		if name ~= "WIP" and name ~= "Trading Plaza" and not world.disabled and world.worldOrder and world.worldOrder ~= 0 then
			world.name = name
			table.insert(AllGameWorlds, world)
		end
	end
	
	table.sort(AllGameWorlds, function(a, b) 
		return a.worldOrder < b.worldOrder
	end)
	

	local WorldWithAreas = {}
	for areaName, area in pairs(Library.Directory.Areas) do 
		if area and area.world then
			local world = Library.Directory.Worlds[area.world]
			local containsSpawn = false
			
			if world and world.spawns then
				for spawnName, spawn in pairs(world.spawns) do 
					if spawn.settings and spawn.settings.area and spawn.settings.area == name then 
						containsSpawn = true 
						break 
					end
				end
			end
			
			if containsSpawn then
				if not WorldWithAreas[area.world] then 
					WorldWithAreas[area.world] = {}
				end

				table.insert(WorldWithAreas[area.world], area.name)
			end
		end
	end
	

	function GetAllAreasInWorld(world)

		return WorldWithAreas[world] or {}
	end
	
	--// AUTO COMPLETE game
	local AllGameAreas = {}
	
	for name, area in pairs(Library.Directory.Areas) do
		local world = Library.Directory.Worlds[area.world]
		if world and world.worldOrder and world.worldOrder > 0 then
			if not area.hidden and not area.isVIP then
				local containsArea = false
				if world.spawns then
					for i,v in pairs(world.spawns) do
						if v.settings and v.settings.area and v.settings.area == name then 
							containsArea = true 
							break 
						end
					end
				end
				
				if area.gate or containsArea then
					table.insert(AllGameAreas, name)
				end
			end
		end
	end
	

	
	table.sort(AllGameAreas, function(a, b)
		local areaA = Library.Directory.Areas[a]
		local areaB = Library.Directory.Areas[b]

		local worldA = Library.Directory.Worlds[areaA.world]
		if a == "Ice Tech" then 
			worldA = Library.Directory.Worlds["Fantasy"]
		end
		
		local worldB = Library.Directory.Worlds[areaB.world]
		if b == "Ice Tech" then 
			worldB = Library.Directory.Worlds["Fantasy"]
		end

		if worldA.worldOrder ~= worldB.worldOrder then
			return worldA.worldOrder < worldB.worldOrder
		end
		
		local currencyA = Library.Directory.Currency[worldA.mainCurrency]
		local currencyB = Library.Directory.Currency[worldB.mainCurrency]
		if currencyA.order ~= currencyB.order then
			return currencyA.order < currencyB.order
		end
		
		if not areaA.gate or not areaB.gate then
			return areaA.id < areaB.id
		end
		
		return areaA.gate.cost < areaB.gate.cost
	end)
	

	function GetCurrentAndNextArea()
		local cArea, nArea = "", ""

		
		for i, v in ipairs(AllGameAreas) do 
			if cArea == "" and Library.WorldCmds.HasArea(v) then
				local nxtArea = AllGameAreas[i + 1]
				if nxtArea and not Library.WorldCmds.HasArea(nxtArea) then 
					cArea = v
					nArea = nxtArea
					break
				elseif not nxtArea then
					cArea = v
					nArea = "COMPLETED"
				end
			end
		end
		
		
		return cArea, nArea
	end

	
	function CheckIfCanAffordArea(areaName)
		local saveData = Library.Save.Get()
		local area = Library.Directory.Areas[areaName]
		
		if not saveData then 
			return false 
		end
		
		if not area then return false end
		
		if not area.gate then 
			return true 
		end -- Area is free =)
		
		local gateCurrency = area.gate.currency
		local currency = saveData[gateCurrency]
		if IsHardcore then
			if gateCurrency ~= "Diamonds" then
				currency = saveData.HardcoreCurrency[gateCurrency]
			end
		end
		
		if currency and currency >= area.gate.cost then
			return true
		end
		
		return false
	end


	getgenv().SecureMode = true
	getgenv().DisableArrayfieldAutoLoad = true
	
	local Rayfield = nil
	if isfile("UI/ArrayField.lua") then
		Rayfield = loadstring(readfile("UI/ArrayField.lua"))()
	else
		Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rafacasari/ArrayField/main/v2.lua"))()
	end
	
	-- local Rayfield = (isfile("UI/ArrayField.lua") and loadstring(readfile("UI/ArrayField.lua"))()) or loadstring(game:HttpGet("https://raw.githubusercontent.com/Rafacasari/ArrayField/main/v2.lua"))()
	assert(Rayfield, "Oopps! Rayfield has not been loaded. Maybe try re-joining?") 
	

	local Window = Rayfield:CreateWindow({
	Name = "Pet Simulator GUI | by TrungB ",
	   ConfigurationSaving = {
		  Enabled = true,
		  FolderName = "TrungB",
		  FileName = "PetSimulatorX_" .. tostring(LocalPlayer.UserId)
	   },
	   OldTabLayout = true
	})
	
	coroutine.wrap(function() 
		wait(0.5)
		if not isfile("Rafa/AcceptedTerms.txt") then 
			Window:Prompt({
				Title = 'Disclaimer',
				SubTitle = 'Misuse of this script may result in penalties!',
				Content = "I am not responsible for any harm caused by this tool, use at your own risk.",
				Actions = {
					
					Accept = {
						Name = "Ok",
						Callback = function()
							if not isfolder("Rafa") then makefolder("Rafa") end
							writefile("Rafa/AcceptedTerms.txt", "true")
						end,
						
					}
				}
			})
		end 
	
	end)()
	
	
	function AddCustomFlag(flagName, defaultValue, callback)
		if Rayfield and Rayfield.Flags and not Rayfield.Flags[flagName] then
			local newFlag = {
				CurrentValue = defaultValue
			}
			
			function newFlag:Set(newValue)
				Rayfield.Flags[flagName].CurrentValue = newValue
				
				callback(newValue)
			end
			
			Rayfield.Flags[flagName] = newFlag
		end
	end
	
	function SaveCustomFlag(flagName, value)
		if Rayfield and Rayfield.Flags and Rayfield.Flags[flagName] then
			pcall(function() 
				Rayfield.Flags[flagName]:Set(value)
				
				coroutine.wrap(function()
					Rayfield.SaveConfiguration()
				end)()
			end)
		end
	end

	LocalPlayer.PlayerScripts:WaitForChild("Scripts", 10):WaitForChild("Game", 10)
	
	
	local autoFarmTab = Window:CreateTab("Farm", "13075651575", true)
	local autoFarmSection = autoFarmTab:CreateSection("Auto Farm", false, false, "7785988164")
	local enableAutoFarm = true
	autoFarmTab:CreateToggle({
		Name = "Enable Auto-Farm",
		Info = 'Auto Farm will automatically destroy/farm coins for you, be aware of the risks of abusing it',
		Flag = "AutoFarm_Enabled",
		SectionParent = autoFarmSection,
		CurrentValue = true,
		Callback = function(Value) 
			enableAutoFarm = Value
		end
	})
	
	local AutoFarm_FastMode = true
	autoFarmTab:CreateToggle({
		Name = "Fast Mode (unlegit farm)",
		Flag = "AutoFarm_FastMode", 
		SectionParent = autoFarmSection,
		CurrentValue = true,
		Callback = function(Value) 
			AutoFarm_FastMode = Value
		end
	})
	
	local AutoFarm_FarmSpeed = 0.09
	autoFarmTab:CreateSlider({
	   Name = "Farm Speed",
	   Flag = "AutoFarm_FarmSpeed",
	   SectionParent = autoFarmSection,
	   Range = {0.05, 2},
	   Increment = 0.05,
	   Suffix = "Second(s)",
	   CurrentValue = 0.09,
	   Callback = function(Value)
			AutoFarm_FarmSpeed = Value
	   end,
	})
	
	local farmMaxDistance = 200
	autoFarmTab:CreateSlider({
	   Name = "Farm Max Distance",
	   Flag = "AutoFarm_MaxDistance",
	   SectionParent = autoFarmSection,
	   Range = {100, tonumber(Library.Settings.CoinGrabDistance) or 600},
	   Increment = 5,
	   Suffix = "Studs",
	   CurrentValue = 200,
	   Callback = function(Value)
			farmMaxDistance = Value
	   end,
	})
	
	local farmPreferences = autoFarmTab:CreateSection("Farm Priority", false, true)
	local farmFocusListText = autoFarmTab:CreateParagraph({Title = "Current Farming", Content = "Nothing"}, farmPreferences)

	local DefaultFarmFocusList = {
		"Fruits",
		"Highest Multiplier",
		"Diamonds"
	}
	
	function CalcMultiplier(coinBonus)
		if not coinBonus then return 0 end
		local totalMultiplier = 0	
		if coinBonus.l then
			
			for _, v in pairs(coinBonus.l) do
				pcall(function() 
					if v.m and tonumber(v.m) then
						totalMultiplier = totalMultiplier + v.m
					end
				end)
			end
			
		end
		return totalMultiplier
	end
	

	local FarmFocusList = {}
	local FarmFocusListButtons = {}
	
	
	function UpdateFarmFocusUI()
		local farmingText = ""
		if not FarmFocusList or #FarmFocusList < 1 then
			farmingText = "There is nothing on your priority list!\nAdd some by <b>clicking on buttons</b>!"
		else
			for i, v in ipairs(FarmFocusList) do 
				farmingText = farmingText .. (farmingText == "" and "This is your priority list to farm.\nYou can <b>modify it by clicking on buttons</b>!\n\n" or "\n") .. i .. "° - <b>" .. tostring(v) .. "</b>"
			end
		end
		
		farmFocusListText:Set({Title = "Current Farming", Content = farmingText})
		
		for _, button in pairs(FarmFocusListButtons) do 
			local buttonName = button.Button.Name
			if buttonName then 
				if table.find(FarmFocusList, buttonName) then
					button:Set(nil, "Remove")
				else
					button:Set(nil, "Add")
				end
			end
		end
	end
	

	
	for _, focusName in pairs(DefaultFarmFocusList) do 
		local function UpdateButton(text, interact)
			if not FarmFocusListButtons[focusName] then return end
			while true do
				wait()
				FarmFocusListButtons[focusName]:Set(text, interact)
				break
			end
		end
		
		FarmFocusListButtons[focusName] = autoFarmTab:CreateButton({
			Name = focusName,
			SectionParent = farmPreferences,
			Interact = table.find(FarmFocusList, focusName) and "Remove" or "Add",
			CurrentValue = false,
			Callback = function(Value) 
				if table.find(FarmFocusList, focusName) then
					table.remove(FarmFocusList, table.find(FarmFocusList, focusName))
				else
					table.insert(FarmFocusList, focusName)
				end
				
				
				
				coroutine.wrap(function() 
					while true do 
						wait()
						UpdateFarmFocusUI()
						break
					end
				end)
				
				SaveCustomFlag("AutoFarm_FarmFocusList", FarmFocusList)
			end
		})
		
	end	
	
	
	
	AddCustomFlag("AutoFarm_FarmFocusList", {}, function(newTable)
		FarmFocusList = newTable
		
		local hasChanges = false
		
		for i, v in pairs(FarmFocusList) do 
			if not table.find(DefaultFarmFocusList, v) then
				table.remove(FarmFocusList, i)
				hasChanges = true
			end
		end
		
		
		
		if hasChanges then 
			coroutine.wrap(function() 
				wait()
				SaveCustomFlag("AutoFarm_FarmFocusList", FarmFocusList)
			end)
		end
		
		UpdateFarmFocusUI()
	end)
	
	local farmUtilities = autoFarmTab:CreateSection("Farm Utilities", false, true)
	local FarmUtilities_CollectDrops = false
	local FarmUtilities_CurrentOrbs = {} 
	autoFarmTab:CreateToggle({
		Name = "Collect Drops",
		SectionParent = farmUtilities,
		CurrentValue = true,
		Flag = "FarmUtilities_CollectDrops", 
		Callback = function(Value) 
			FarmUtilities_CollectDrops = Value
			
			if Value then
				table.clear(FarmUtilities_CurrentOrbs)
				FarmUtilities_CurrentOrbs = {}
				CollectAllOrbs()
				CollectAllLootbags()
			end
			
			if not FarmUtilities_CollectDrops then return end
			task.spawn(function() 
				
				while FarmUtilities_CollectDrops do
					wait(0.05)
					if not FarmUtilities_CollectDrops then break end
					if FarmUtilities_CurrentOrbs and #FarmUtilities_CurrentOrbs > 0 then
						Library.Network.Fire("Claim Orbs", FarmUtilities_CurrentOrbs)
						table.clear(FarmUtilities_CurrentOrbs)
						FarmUtilities_CurrentOrbs = {}
					end
				end
				
			end)
		end
	})

	function CollectAllOrbs()			
		pcall(function() 
			
			local OrbsToCollect = {}
			for orbId, orb in pairs(Library.Things:FindFirstChild("Orbs"):GetChildren()) do
				if not FarmUtilities_CollectDrops then break end
				if orbId and orb then
					table.insert(OrbsToCollect, orb.Name)
				end
			end
			
			if OrbsToCollect and #OrbsToCollect > 0 and FarmUtilities_CollectDrops then
				Library.Network.Fire("Claim Orbs", OrbsToCollect)
			end
		end)
	end
	
	function CollectAllLootbags()			
		pcall(function() 
			for _, lootbag in pairs(Library.Things:FindFirstChild("Lootbags"):GetChildren()) do
				if not FarmUtilities_CollectDrops then break end

				if lootbag and not lootbag:GetAttribute("Collected") then
					Library.Network.Fire("Collect Lootbag", lootbag.Name, HumanoidRootPart.Position + Vector3.new(math.random(-0.05, 0.05), math.random(-0.05, 0.05), math.random(-0.05, 0.05)))
					wait(0.03)
				end
			end
		end)
	end
	
	Library.Things:FindFirstChild("Lootbags").ChildAdded:Connect(function(child) 
		wait()
		if FarmUtilities_CollectDrops and child then 
			Library.Network.Fire("Collect Lootbag", child.Name, HumanoidRootPart.Position + Vector3.new(math.random(-0.05, 0.05), math.random(-0.05, 0.05), math.random(-0.05, 0.05)))
		end
	end)
	
	Library.Things:FindFirstChild("Orbs").ChildAdded:Connect(function(child) 
		task.wait()
		if FarmUtilities_CollectDrops and child then
			table.insert(FarmUtilities_CurrentOrbs, child.name)
		end
	end)
		
	
	local instantFall = false
	
	local WorldCoins = Library.Things:WaitForChild("Coins")

	WorldCoins.ChildAdded:Connect(function(ch)
		if instantFall then 
			ch:SetAttribute("HasLanded", true)
			ch:SetAttribute("IsFalling", false)
			
			local coin = ch:WaitForChild("Coin")
			coin:SetAttribute("InstantLand", true)
		end
	end)

	local areaToFarmSection = autoFarmTab:CreateSection("Areas to Farm", true, true)
	for w, world in ipairs(AllGameWorlds) do
		coroutine.wrap(function()
			if world and world.name then
				local containsSpawns = false
				if world.spawns then
					for i,v in pairs(world.spawns) do containsSpawns = true break end
				end
				
				if containsSpawns then
					local worldDropdown = autoFarmTab:CreateDropdown({
						Name = world.name,
						MultiSelection = true,
						CurrentOption = {},
						Flag = "SelectedAreas_" .. world.name,
						Icon = Library.Directory.Currency[world.mainCurrency].tinyImage,
						Options = GetAllAreasInWorld(world),
						SectionParent = areaToFarmSection,
						Callback = function(Option)
							
						end
					})
					worldDropdown:Lock("Coming soon!", true)
				end
			end
		end)()
	end
	
	function GetCoinsInArea(area)
		local coinsInArea = {}

		
		for _, coin in pairs(WorldCoins:GetChildren()) do 
			if coin and coin:GetAttribute("Area") and coin:GetAttribute("Area") == area then 
				table.insert(coinsInArea, coin)
			end
		end
		
		return coinsInArea
	end
	

	
	function SortCoinsByPriority(coins)
		local sortedCoins = {}
		
		
		CoinsTable = debug.getupvalue(getsenv(LocalPlayer.PlayerScripts.Scripts.Game.Coins).DestroyAllCoins, 1)
		
		for _, coin in pairs(coins) do
			local coinMesh = coin:FindFirstChild("Coin")
			local mag = (HumanoidRootPart.Position - coinMesh.Position).magnitude	
			if CoinsTable[coin.Name] and mag <= math.max(math.min(farmMaxDistance, Library.Settings.CoinGrabDistance), 10) and Library.WorldCmds.HasArea(coin:GetAttribute("Area")) then
				table.insert(sortedCoins, coin)
			end
		end
	
	
		table.sort(sortedCoins, function(coinA, coinB)
			local a = CoinsTable[coinA.Name]
			local b = CoinsTable[coinB.Name]
			
			local APriority = GetCoinLowestPriority(a, b)
			local BPriority = GetCoinLowestPriority(b, a)
			
			return APriority < BPriority 
		end)
			
		
		
		return sortedCoins
	end
	
	function SortCoinsByPriorityFastMode(coins)
		local sortedCoins = {}
		
		
		for coinId, coin in pairs(coins) do
			coin.coinId = coinId
			local mag = (HumanoidRootPart.Position - coin.p).magnitude	
			if mag <= math.max(math.min(farmMaxDistance, Library.Settings.CoinGrabDistance), 10) and Library.WorldCmds.HasArea(coin.a) then
				table.insert(sortedCoins, coin)
			end
		end
	
		table.sort(sortedCoins, function(a, b)
			local APriority = GetCoinLowestPriority(a, b)
			local BPriority = GetCoinLowestPriority(b, a)
			
			return APriority < BPriority 
		end)
		
		
		return sortedCoins
	end
	
	function GetCoinLowestPriority(mainCoin, coinToCompare)
		local coin = Library.Directory.Coins[mainCoin.n]
		local coinCompare = Library.Directory.Coins[coinToCompare.n]
		
		local aMagnitude = (HumanoidRootPart.Position - mainCoin.p).magnitude
		local bMagnitude = (HumanoidRootPart.Position - coinToCompare.p).magnitude
		
		local coinIsFruit = coin.breakSound == "fruit"
		local coinIsDiamond = coin.currencyType == "Diamonds"
		
		local coinPriority = 9999999

		
		for priority, priorityName in ipairs(FarmFocusList) do 
			if priorityName == "Fruits" and coinIsFruit then
				mainCoin.priority = priorityName 
				coinPriority = priority
				break
			elseif priorityName == "Diamonds" and coinIsDiamond then
				mainCoin.priority = priorityName
				coinPriority = priority
				break
			end
		end
		
		
		return coinPriority
	end
	
	local petsCurrentlyFarming = {}
	
	coroutine.wrap(function()
		while true do 
				if enableAutoFarm and not ScriptIsCurrentlyBusy then 
					CoinsTable = debug.getupvalue(getsenv(LocalPlayer.PlayerScripts.Scripts.Game.Coins).DestroyAllCoins, 1)
					RenderedPets = debug.getupvalue(getsenv(LocalPlayer.PlayerScripts.Scripts.Game.Pets).NetworkUpdate, 1)
					
					if AutoFarm_FastMode then 

						local foundCoins = SortCoinsByPriorityFastMode(CoinsTable)
						local equippedPets = Library.PetCmds.GetEquipped()
						if equippedPets and #equippedPets > 0 and #foundCoins > 0 then
							for _, pet in pairs(equippedPets) do
								local selectedCoin = foundCoins[1]
								task.spawn(function()
									Library.Network.Invoke("Join Coin", selectedCoin.coinId, {pet.uid}) 
									Library.Network.Fire("Farm Coin", selectedCoin.coinId, pet.uid)
									
								end)
								
								table.remove(foundCoins, 1)
								task.wait(AutoFarm_FarmSpeed)
							end
						end
					else
						local equippedPets = Library.PetCmds.GetEquipped()
						local foundCoins = {}

						for _, ch in ipairs(SortCoinsByPriority(WorldCoins:GetChildren())) do
							local containsMyPet = false
							local coin = CoinsTable[ch.Name]
							local coinMesh = ch:FindFirstChild("Coin")
							local mag = (HumanoidRootPart.Position - coinMesh.Position).magnitude	
			
							for _, pet in pairs(equippedPets) do
								if coin and coin.pets and table.find(coin.pets, pet.uid) then 
									containsMyPet = true
									break
								end
							end
							
							if not containsMyPet and mag <= math.max(math.min(farmMaxDistance, Library.Settings.CoinGrabDistance), 10) and Library.WorldCmds.HasArea(ch:GetAttribute("Area")) then
								table.insert(foundCoins, ch)
							end
						end
						
						
						for i, pet in pairs(RenderedPets) do 
							if ScriptIsCurrentlyBusy or not enableAutoFarm or #foundCoins <= 0 then break end
							if pet.spawned.owner == LocalPlayer and not pet.farming then
								local coin = foundCoins[1]
								if coin then 
									if not coin:FindFirstChild("Pets") then
										local petsFolder = Instance.new("Folder")
										petsFolder.Name = "Pets"
										petsFolder.Parent = coin
									end
									
									-- Legit Mode
									Library.Signal.Fire("Select Coin", coin, pet)

									table.remove(foundCoins, 1)
									wait(AutoFarm_FarmSpeed)
								end

							end
							
						end
					end
				end
			wait(0.1)
		end	
	end)()

	--//*----------- WEBHOOK -----------//-
	local currencyName = "Diamonds"
	
	local plr = game:GetService("Players"):GetPlayerFromCharacter(script.Parent)
	local unixtime = os.time()
	local format = "%H:%M:%S | %a, %d %b %Y"
	local timei = os.date(format, unixtime)

	local updateDelay = 60  -- The delay between updates (in seconds)

	-- Load the library
	local Library = require(game.ReplicatedStorage.Library)
	Library.Load()

	-- Function to format a number with commas
	local function formatNumber(number)
	    return tostring(number):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
	end

	-- Function to get the current amount of the specified currency
	local function getCurrentCurrencyAmount()
	    local saveData = Library.Save.Get()
	    if not saveData then
		return nil
	    end
	    return saveData[currencyName]
	end
	
	function SendWebhookInfo(currentAmount, totalAmount)
		if not Webhook_Enabled or not Webhook_URL or Webhook_URL == "" then return end
		
		local embed = {
			["title"] = "Cập nhật Gems",
			["description"] = "Tổng số gems qua mỗi phút :penguin:",
			["color"] = tonumber("0xe69138", 16), -- Orange
			["fields"] = {
			    {
				["name"] = "",
				["value"] = ":gem: **Hiện có:** ``"..formatNumber(currentAmount).."``\n:gem: **Tổng nhận:** ``"..formatNumber(totalAmount).."``",
			    }
			},
			["footer"] = {text = timei}
		}

		(syn and syn.request or http_request or http.request) {
			Url = Webhook_URL;
			Method = 'POST';
			Headers = {
				['Content-Type'] = 'application/json';
			};
			Body = HttpService:JSONEncode({
				username = "Thông báo", 
				avatar_url = 'https://i.imgur.com/5b6NmEo.png',
				embeds = {embed} 
			})
		}
	end
	
	-- Initialize the current and total amounts
	local currentAmount = getCurrentCurrencyAmount() or 0
	local totalAmount = 0 -- Initialize to 0 instead of currentAmount
	local last5MinAmount = 0
	
	--//*----------- SETTINGS -----------//-
	local settingsTab = Window:CreateTab("Settings", "13075268290", true)
	local discordSettings = settingsTab:CreateSection("Webhook Options", false, true, "13085068876")
	settingsTab:CreateToggle({
		Name = "Enable Webhook",
		CurrentValue = false,
		Flag = "Webhook_Enabled",
		SectionParent = discordSettings,
		Callback = function(value) 
			Webhook_Enabled = value
				
			-- Start a loop to update the currency every 1 minutes
			while true do
			    wait(updateDelay)
			    local newAmount = getCurrentCurrencyAmount() or 0
			    local deltaAmount = newAmount - currentAmount
			    totalAmount = totalAmount + deltaAmount
			    last5MinAmount = deltaAmount
			    currentAmount = newAmount
			    SendWebhookInfo(currentAmount, totalAmount)
			end
		end
	})

	local WebhookURLInput = settingsTab:CreateInput({
	   Name = "Webhook URL",
	   PlaceholderText = "Paste your Discord Webhook here",
	   SectionParent = discordSettings,
	   NumbersOnly = false,
	   OnEnter = false,
	   RemoveTextAfterFocusLost = false,
	   Callback = function(Text)
		SaveCustomFlag("Webhook_URL", Text)
	   end,
	   
	})	
		
	AddCustomFlag("Webhook_URL", "", function(newValue) 
		Webhook_URL = newValue
		if WebhookURLInput and newValue and newValue ~= "" then
			WebhookURLInput:Set(newValue)
		end
	end)
	
	Rayfield.LoadConfiguration()

	for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
		v:Disable()
	end
end

-- Teleport
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(8994.38184, -61.9601894, 2548.96167, 0.999595344, 1.17857162e-07, -0.0284447595, -1.16815023e-07, 1, 3.82990244e-08, 0.0284447595, -3.49607525e-08, 0.999595344)

-- Reduce Lag
loadstring(game:HttpGet("https://raw.githubusercontent.com/TrungBui1289/lua/main/ui/reducelag.lua"))()
