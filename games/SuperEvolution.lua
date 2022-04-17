repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.Settings = {
    autoclick = false;
    walkSpeed = false;
}

local Player            = game:GetService("Players").LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local Mouse = Player:GetMouse()
local X, Y = 0, 0

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrungBui1289/lua/main/ui/hunterlib.lua"))()
local w       = library:Window("TrungB Scripts", "WalkSpeed [RShift]", Color3.fromRGB(182, 0, 182), Enum.KeyCode.RightShift)


local humanoid = game.Players.LocalPlayer.Character.Humanoid

local Farm = w:Tab("Farm", 6034287535)

local Enabled = false
Farm:Bind("AutoClick", Enum.KeyCode.F, function(v)
	 _G.Settings.autoclick = not  _G.Settings.autoclick
	 task.spawn(function()
        while task.wait(0.15) do
            if not _G.Settings.autoclick then break end
            X, Y = Mouse.X, Mouse.Y
		VirtualInputManager:SendMouseButtonEvent(X, Y, 0, true, game, 1)
		VirtualInputManager:SendMouseButtonEvent(X, Y, 0, false, game, 1)
        end
    end)
end)

local Energy = w:Tab("Energy", 8916381379)

for _, v in pairs(game:GetService("Workspace").TrainingZones:GetChildren()) do
	for i, V in pairs(v:GetChildren()) do
		if V.Name == "Type" then
			if V.Value == "Meditation" then
				Energy:Button(v.Name, "", function()
					for i, V2 in pairs(v:GetChildren()) do
						if V2:IsA("MeshPart") or V2:IsA("Part") and V2.Name == "Touch" then
							Player.Character.HumanoidRootPart.CFrame = V2.CFrame
						end
					end
				end)
			end
		end
	end
end

local Endu = w:Tab("Endurance", 8916381379)

for _, v in pairs(game:GetService("Workspace").TrainingZones:GetChildren()) do
	for i, V in pairs(v:GetChildren()) do
		if V.Name == "Type" then
			if V.Value == "Endurance" then
				Endu:Button(v.Name, "", function()
					for i, V2 in pairs(v:GetChildren()) do
						if V2:IsA("MeshPart") or V2:IsA("Part") and V2.Name == "Touch" then
							Player.Character.HumanoidRootPart.CFrame = V2.CFrame
						end
					end
				end)
			end
		end
	end
end

local Strength = w:Tab("Strength", 8916381379)

for _, v in pairs(game:GetService("Workspace").TrainingZones:GetChildren()) do
	for i, V in pairs(v:GetChildren()) do
		if V.Name == "Type" then
			if V.Value == "Power" then
				Strength:Button(v.Name, "", function()
					for i, V2 in pairs(v:GetChildren()) do
						if V2:IsA("MeshPart") or V2:IsA("Part") and V2.Name == "Touch" then
							Player.Character.HumanoidRootPart.CFrame = V2.CFrame
						end
					end
				end)
			end
		end
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
