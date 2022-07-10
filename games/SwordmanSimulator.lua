repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.Settings = {
    autoTap   = false;
    autoUpgrade  = false;
    autoRebirth  = false;
    autoKill  = false;
    autoTpPlr  = false;
    walkSpeed = false;
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player            = game:GetService("Players").LocalPlayer

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrungBui1289/lua/main/ui/hunterlib.lua"))()
local w       = library:Window("TrungB Scripts", "Swordman Simulator [RShift]", Color3.fromRGB(182, 0, 182), Enum.KeyCode.RightShift)


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

Farm:Toggle("Auto Click", "", false, function(v)
    _G.Settings.autoTap = v

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoTap then break end
            for I,V in pairs(workspace[game.Players.LocalPlayer.Name]:GetChildren()) do
               if V:IsA("Tool") and string.find(tostring(V), "Sword") then
					for i, v in pairs(game:GetService("ReplicatedStorage").Assets.Swords:GetChildren()) do
						if V.Name == v.Name then
							ReplicatedStorage.SwordHit:FireServer(V.Name)
						end
					end
               end
            end
        end
    end)
end)

Farm:Toggle("Auto Rebirth", "", false, function(v)
    _G.Settings.autoRebirth = v

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoRebirth then break end
		ReplicatedStorage.Rebirth:FireServer()
        end
    end)
end)

Farm:Toggle("Auto Upgrade", "", false, function(v)
    _G.Settings.autoUpgrade = v

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoUpgrade then break end
			ReplicatedStorage.Upgrade:InvokeServer("StrengthMultiplier")
			ReplicatedStorage.Upgrade:InvokeServer("WalkSpeed")
			ReplicatedStorage.Upgrade:InvokeServer("JumpPower")
			wait(0.5)
        end
    end)
end)

Farm:Button("Click tp chest", "", function()
	for i, v in pairs(game:GetService("Workspace")["__MAP"]["__CHESTS"]:GetDescendants()) do
		if v:IsA("Part") and v.Name == "Part" then
           humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
           wait(0.1)
           Player.Character.HumanoidRootPart.CFrame = v.CFrame
		   wait(2)
		end
	end
end)

Farm:Toggle("Auto Tp Kill", "", false, function(v)
    _G.Settings.autoKill = v

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoKill then break end
            for i, v in pairs(game:GetService("Players"):GetChildren()) do
                wait(0.35)
                Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame 
            end
        end
    end)
end)

local Tele = w:Tab("Teleport", 8916381379)


local plr = {}
local selectedPlr = {}

for i, v in pairs(game:GetService("Players"):GetChildren()) do
    table.insert(plr, v.Name)
end


Tele:Dropdown("Select Player", plr, function(v)
    selectedPlr = v
end)

Tele:Toggle("Tele to player", "", false, function(v)
    _G.Settings.autoTpPlr = v
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoTpPlr then break end
            for i, v in pairs(game:GetService("Players"):GetChildren()) do
                if v.Name == selectedPlr then
                    wait(0.25)
                    Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame 
                end
            end
        end
    end)
end)

Tele:Line()

for i,  v in pairs(game:GetService("Workspace")["__MAP"]["__KING"]:GetChildren()) do
    if v.Name == "Crown" then
        Tele:Button(v.Name, "", function()
           humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
           wait(0.1)
           Player.Character.HumanoidRootPart.CFrame = v.CFrame
        end)
   end
end

for i, v in pairs(game:GetService("Workspace")["__MAP"]["__WORLDS"]:GetChildren()) do
	if v:IsA("Part") then
		Tele:Button(v.Name, "", function()
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			wait(0.1)
			Player.Character.HumanoidRootPart.CFrame = v.CFrame
		end)
	end
end


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
