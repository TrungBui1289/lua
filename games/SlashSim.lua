repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.Settings = {
    slash     = false;
    rebirth   = false;
    walkSpeed = false;
}

local Player            = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local humanoid = game.Players.LocalPlayer.Character.Humanoid

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrungBui1289/lua/main/ui/hunterlib.lua"))()
local w       = library:Window("TrungB Scripts", "WalkSpeed [RShift]", Color3.fromRGB(182, 0, 182), Enum.KeyCode.RightShift)


local Farm     = w:Tab("Farm", nil)

Farm:Toggle("Auto Slash", "", false, function(v)
    _G.Settings.slash = v
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.slash then break end
            Player.PlayerScripts.EssentialForGameplay.AirSlice.Slice:Fire("Start")
            ReplicatedStorage.Remotes.Game.AirSlice:FireServer(true)
        end
    end)
end)


Farm:Toggle("Auto Rebirth", "", false, function(v)
    _G.Settings.rebirth = v
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.rebirth then break end
            print(rebamount)
            ReplicatedStorage.Remotes.Other.Rebirth:FireServer(3500, 12)
        end
    end)
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