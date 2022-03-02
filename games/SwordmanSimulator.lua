repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.Settings = {
    autoTap = false;
    walkSpeed     = false;
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player            = game:GetService("Players").LocalPlayer

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrungBui1289/lua/main/ui/hunterlib.lua"))()
local w       = library:Window("TrungB Scripts", "Swordman Simulator [RShift]", Color3.fromRGB(182, 0, 182), Enum.KeyCode.RightShift)


local humanoid = game.Players.LocalPlayer.Character.Humanoid

local Farm = w:Tab("Farming", 6034287535)

Farm:Toggle("Auto Click", "", false, function(v)
    _G.Settings.autoTap = v

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoTap then break end
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Animation.Slash:FireServer()
        end
    end)
end)

local Tele = w:Tab("Teleport", 8916381379)

local Mics = w:Tab("Mics", 6031215984)

Mics:Line()

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
Mics:Slider("WalkSpeed Amount", "",18, 1000, 0, function(v)
    walkSpeed = v
end)

