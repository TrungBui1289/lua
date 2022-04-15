repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.Settings = {
    pet       = false;
    walkSpeed = false;
}

local Player            = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local humanoid = game.Players.LocalPlayer.Character.Humanoid

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrungBui1289/lua/main/ui/hunterlib.lua"))()
local w       = library:Window("TrungB Scripts", "WalkSpeed [RShift]", Color3.fromRGB(182, 0, 182), Enum.KeyCode.RightShift)

local Farm     = w:Tab("Farm", 6034287535)

local pet = {}
local selectedPet = {}

for _, v in pairs(game:GetService("ReplicatedStorage").Game.Eggs:GetChildren()) do
	if v:IsA("Folder") then
		table.insert(pet, v.Name)
	end
end

Farm:Dropdown("Select Pet", pet, function(v)
	selectedPet = v
end)

Farm:Toggle("Auto Pet", "", false, function(v)
    _G.Settings.pet = v
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.pet then break end
            ReplicatedStorage.Assets.Events.RemoteFunction:InvokeServer("Buy Egg", selectedPet, false)
        end
    end)
end)

local Tele = w:Tab("Teleport", 8916381379)

for _, v in pairs(game:GetService("Workspace")["__MAP"].Teleports:GetChildren()) do
	Tele:Button(v.Name, "", function()
		Player.Character.HumanoidRootPart.CFrame = v.CFrame
	end)
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
Mics:Slider("WalkSpeed Amount", "", 0, 1000, 18, function(v)
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