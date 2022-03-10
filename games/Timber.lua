repeat wait() until game:IsLoaded()

print("------------------------------")
print("  Timber by TrungB")
print("------------------------------")
    
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.Settings = {
	autoFarm = false;
	autoMega = false;
	autoStrength = false;
	autoMiniTree = false;
    walkSpeed = false;
}

local Player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

function tele(pos)
	Player.Character.HumanoidRootPart.CFrame = pos.CFrame
end

local treeisland = game:GetService("Workspace").TreeIslands

local function getPlot()
   local plot = nil
   for i, v in next, workspace.Plots:GetChildren() do
       if v:WaitForChild("Owner").Value == game.Players.LocalPlayer or v:WaitForChild("Owner").Value == game.Players.LocalPlayer.Character then
           plot = v
       end
   end
   
   return plot
end

local function getBase(plot)
	local base = nil
	for a,x in next, plot:GetChildren() do
		if x:IsA("Model") then
			for l,d in next, x:GetChildren() do
				if d.IsA("Part") and d.Name == "Base" then
					base = d
				end
			end
		end
	end
   
	return base
end

local function getRandomTree(plot)
   local randomTree=nil
   local branch=nil
   for a,x in next, plot:GetChildren() do
       if x:IsA("Model") then
           for l,d in next, x:GetChildren() do
               if string.find(d.Name, "Tree") then
                   randomTree=d
                   branch=x
                   break
               end
           end
       end
   end
   
   return randomTree, branch
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrungBui1289/lua/main/ui/hunterlib.lua"))()
local w       = library:Window("TrungB Scripts", "Timber [RShift]", Color3.fromRGB(182, 0, 182), Enum.KeyCode.RightShift)


local humanoid = game.Players.LocalPlayer.Character.Humanoid

local Home = w:Tab("Information", 6026568198)

Home:Button("Games Active (Click me)", "", function()
    library:Notification("  [+] Base Battles       - [+] Eating Simulator\n  [+] Anime Lifting    - [+] Anime Punching\n   [+] Swordman Sim  - [+] Strongest Punch \n [+] Rebirth ChampionX - [+] Lifting Titans\n         [+] Undead Defense Tycoon", "Thanks")
end)

Home:Line()

Home:Button("Discord (Click)","", function()
    setclipboard("TrungB#1230")
    library:Notification("TrungB#1230", "Copied")
end)

local Farm = w:Tab("Farming", 6034287535)

local tree = {}
local selectedTree = {}

for i, v in pairs(game:GetService("Workspace").TreeIslands:GetChildren()) do
	if v:IsA("Model") then
		table.insert(tree, v.Name)
	end
end

Farm:Toggle("Auto Farm Legit (Kick < 10%)", "", false, function(v)
    _G.Settings.autoFarm = v
	
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoFarm then break end
			wait(0.7)
			local plot = getPlot()
			local choice, branch = getRandomTree(getPlot())
			local treeNumber = string.gsub(choice.Name, "Tree_", "")
			game.Players.LocalPlayer.Character.Humanoid:MoveTo(choice:WaitForChild("Base").Position)
			if choice ~= nil and branch ~= nil then
				ReplicatedStorage.Communication.Remotes.HitTree:FireServer(plot.Name,tostring(branch),treeNumber)
			end
        end
    end)
end)

Farm:Button("Sell (Coming soon...)", "", function()
	library:Notification("BRUHHH!", "Close")
end)

Farm:Dropdown("Select level mega tree", tree, function(v)
	selectedTree = v
end)

Farm:Toggle("Auto Mega Tree", "", false, function(v)
    _G.Settings.autoMega = v
	
	for i, v in pairs(treeisland:GetDescendants()) do
		if selectedTree == v.Name then
			if v.Name == "1" then
				tele(v.Base)
				break
			elseif v.Name == "2" then
				tele(v.Base)
				break
			elseif v.Name == "3" then
				tele(v.Base)
				break
			elseif v.Name == "4" then
				tele(v.Base)
				break
			elseif v.Name == "5" then
				tele(v.Base)
				break
			elseif v.Name == "6" then
				tele(v.Base)
				break
			end
		end
	end
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoMega then break end
			ReplicatedStorage.Communication.Remotes.HitMegaTree:FireServer(selectedTree)
        end
    end)
end)

Farm:Toggle("Auto Mini Tree (Must near mini tree)", "", false, function(v)
    _G.Settings.autoMiniTree = v
	
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoMiniTree then break end
			ReplicatedStorage.Communication.Remotes.HitMiniMegaTree:FireServer(getPlot().Name)
        end
    end)
end)

Farm:Toggle("Auto Buy Strength", "", false, function(v)
    _G.Settings.autoStrength = v
	
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoStrength then break end
			ReplicatedStorage.Communication.Remotes.Upgrade:FireServer("AxeStrength")
			if ReplicatedStorage.Communication.Remotes.MegaTreeDestroyed then
				v = false
			end
        end
    end)
end)


local Tele = w:Tab("Teleport", 8916381379)

Tele:Button("Tp to Base", "", function()
	for i, v in next, workspace.Plots:GetChildren() do
		if v:WaitForChild("Owner").Value == game.Players.LocalPlayer
			or v:WaitForChild("Owner").Value == game.Players.LocalPlayer.Character then
			if v:IsA("Model") then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				wait(0.1)
				tele(v:WaitForChild("Base"))
			end
		end
	end
end)

Tele:Button("Missions", "", function()
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	wait(0.1)
	tele(ReplicatedStorage.Storage.Core.MissionsPart)
end)
local Mics = w:Tab("Mics", 8916127218)

Mics:Toggle("Walk Speed", "", false, function(v)
    _G.Settings.walkSpeed = v
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.walkSpeed then break end
            game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
        end
    end)
end)

local walkspeed = 18
Mics:Slider("WalkSpeed Amount", "", 18, 1000, 0, function(v)
    walkSpeed = v
end)


Mics:Line()

Mics:Button("Rejoin", "", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId,game.Players.LocalPlayer)
end)

Mics:Button("Serverhop", "", function()
    while task.wait() do
        local Servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        for i,v in pairs(Servers.data) do
            if v.id ~= game.JobId then
                task.wait()
                game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, v.id)
            end
        end
    end
end)

Mics:Button("Serverhop Low Server", "", function()
    while task.wait() do
        local Servers = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        for i,v in pairs(Servers.data) do
            if v.id ~= game.JobId and v.playing <= 3 then
                task.wait()
                game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, v.id)
            end
        end
    end
end)
