while not game:IsLoaded() do wait(1) end
wait(4)
targetmulti = 5 -- If The Multiplier Of A Coin Is Higher Or Equal To This It Will Break It
breakgiantchest = true -- Weather To Break The Giant Mine Chest Even If Its Below The Multi
breakbigchests = true -- Weather To Break The Big Mine Chests Even If They Are Below The Multi
WEBHOOK = "https://discord.com/api/webhooks/1113915902153457816/QaLu0QdtM1VGAf-rakKERZ9nCTFxDrd2yhW0d4Yzexf5d2VhISDbTxxjoUdxxOhWKnDs" -- Webhook

loadstring(game:HttpGet("https://raw.githubusercontent.com/TrungBui1289/lua/main/ui/PSX.lua"))()

local oldJob = game.JobId

local v1 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not v1.Loaded do
    game:GetService("RunService").Heartbeat:Wait();
end;

local Network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
local Fire, Invoke = Network.Fire, Network.Invoke

local old
old = hookfunction(getupvalue(Fire, 1), function(...)
   return true
end)

Lib = require(game:GetService("ReplicatedStorage").Library)

wait(6)

local function serverHop()
    repeat
        local data = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&excludeFullGames=true&limit=100"))
        local bestserver
        for i,v in pairs(data.data) do
          if (tonumber(v.playing) < 12) and (tonumber(v.playing) > 1) then
            bestserver = v.id
          end
        end
        
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, bestserver, game.Players.LocalPlayer)
        task.wait(1)
    until oldJob ~= game.JobId
end

local TimeElapsed = 0
local GemsEarned = 0
local TotalGemsEarned = 0
local Library = require(game:GetService("ReplicatedStorage").Library)
local StartingGems = Library.Save.Get().Diamonds

local timer = coroutine.create(function()
    while 1 do
        TimeElapsed = TimeElapsed + 1
        wait(1)
    end
end)
coroutine.resume(timer)

AREATOCHECK = "Mystic Mine"
function add_suffix(inte)
    local gems = inte
    local gems_formatted

    if gems >= 1000000000000 then  -- if gems are greater than or equal to 1 trillion
        gems_formatted = string.format("%.1ft", gems / 1000000000000)  -- display gems in trillions with one decimal point
    elseif gems >= 1000000000 then  -- if gems are greater than or equal to 1 billion
        gems_formatted = string.format("%.1fb", gems / 1000000000)  -- display gems in billions with one decimal point
    elseif gems >= 1000000 then  -- if gems are greater than or equal to 1 million
        gems_formatted = string.format("%.1fm", gems / 1000000)  -- display gems in millions with one decimal point
    elseif gems >= 1000 then  -- if gems are greater than or equal to 1 thousand
        gems_formatted = string.format("%.1fk", gems / 1000)  -- display gems in thousands with one decimal point
    else  -- if gems are less than 1 thousand
        gems_formatted = tostring(gems)  -- display gems as is
    end

    return gems_formatted
end
HttpService = game:GetService("HttpService")
function WH()
	request({
		Url = WEBHOOK,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode{
            ["content"] = "",
            ["embeds"] = {
			    {
			      ["title"] = "Stat Update",
			      ["description"] = "Successfully!! Hopping To New Server!",
			      ["color"] = 15115337,
			      ["fields"] = {
			        {
			          ["name"] = "",
			          ["value"] = ":clock1: **Time:** ``"..TimeElapsed.."s``\n:gem: **Earned:** ``"..add_suffix(GemsEarned).."``\n:gem: **Total:** ``"..add_suffix(TotalGemsEarned).."``"
			        }
			      }
			    }
			  }
			  }
	})
end

function GetMulti(B)
		if not B then return 0 end
		local totalMultiplier = 0	
		if B.l then
			for _, v in pairs(B.l) do
				pcall(function() 
					if v.m and tonumber(v.m) then
						totalMultiplier = totalMultiplier + v.m
					end
				end)
			end
			
		end
		return totalMultiplier
	end
	
	
AllC = Invoke("Get Coins")
AllNeededCoins = {}
for i, v in pairs(AllC) do
	if v.a == "Mystic Mine" then
		M = GetMulti(v.b)
		if breakgiantchest then
			if string.find(v.n, "Giant") then
				AllNeededCoins[i] = v
			end
		end
		if breakbigchests then
			if string.find(tostring(v.mh), "320") then
				AllNeededCoins[i] = v
			end
		end
		if M >= targetmulti then
			AllNeededCoins[i] = v
		end
	end
end
--game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9155.5683608, 18.6334801, 2284.2688, 0.800801218, 5.75998271e-08, 0.59893024, -6.35986268e-08, 1, -1.11364722e-08, -0.59893024, -2.91730391e-08, 0.800801218)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9147.89844, -14.7124605, 2344.86011, -0.7152351114, 4.50237785e-08, -0.698883891, 8.63818528e-09, 1, 5.55821131e-08, 0.698883891, 3.37171926e-08, -0.715235116)

Fire("Performed Teleport")
wait(0.5)
PETS = Lib.Save.Get().PetsEquipped
newP = {}
for i,v in pairs(PETS) do table.insert(newP, i) end
function ForeverPickupOrbs()
      while true do
        orbs = {}
        for i, v in pairs (game.Workspace['__THINGS'].Orbs:GetChildren()) do
            table.insert(orbs, v.Name)
        end
        Fire("Claim Orbs", orbs)
        wait(0.1)
        for i, v in pairs(game.Workspace['__THINGS'].Lootbags:GetChildren()) do
            Fire("Collect Lootbag", v.Name, v.Position)
        end
      end
    end
    c1 = coroutine.create(ForeverPickupOrbs)
    coroutine.resume(c1)
for i, v in pairs(AllNeededCoins) do
	local v86 = Invoke("Join Coin", i, newP)
	for v88, v89 in pairs(v86) do
    	Fire("Farm Coin", i, v88);
	end
	while 1 do
		wait(0.1)
		AllC = Invoke("Get Coins")
		f = false
		for i2,v2 in pairs(AllC) do
			if i2 == i then f = true end
		end
		if not f then break end
	end
end
wait(5)
local EndingGems = Library.Save.Get().Diamonds
GemsEarned = EndingGems - StartingGems
WH()
wait(1)
writefile("HOP.txt", "a")
local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end
function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end

-- If you'd like to use a script before server hopping (Like a Automatic Chest collector you can put the Teleport() after it collected everything.
Teleport()
