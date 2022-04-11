repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.Settings = {
    slash     = false;
    rebirth   = false;
    pet       = false;
    autocrate = false;
    walkSpeed = false;
}

local Player            = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local humanoid = game.Players.LocalPlayer.Character.Humanoid

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrungBui1289/lua/main/ui/hunterlib.lua"))()
local w       = library:Window("TrungB Scripts", "WalkSpeed [RShift]", Color3.fromRGB(182, 0, 182), Enum.KeyCode.RightShift)


local Farm     = w:Tab("Farm", 6034287535)

Farm:Toggle("Auto Slash", "", false, function(v)
    _G.Settings.slash = v
    task.spawn(function()
    while task.wait(0.05) do
            if not _G.Settings.slash then break end
            Player.PlayerScripts.EssentialForGameplay.AirSlice.Slice:Fire("Start")
            ReplicatedStorage.Remotes.Game.AirSlice:FireServer(true)
        end
    end)
end)

local rebirthAmount  = {10,25,50,150,400,1000,3500,8500,15000,30000}
local selectedAmount = {}

Farm:Dropdown("Select Rebirth Amount", rebirthAmount, function(v)
    selectedAmount = v
end)

Farm:Toggle("Auto Rebirth", "", false, function(v)
    _G.Settings.rebirth = v
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.rebirth then break end
            print(rebamount)
            ReplicatedStorage.Remotes.Other.Rebirth:FireServer(selectedAmount, 12)
        end
    end)
end)

local Pet         = w:Tab("Pet", 6031260792)

local pet          = {}
local petType      = {"Coins","Diamonds","Rebirths"}
local selectedType = {}
local selectedPet  = {}

function teleport(mob)
    Player.Character.HumanoidRootPart.CFrame = mob.CFrame
end

for i, v in pairs(ReplicatedStorage.Assets.Eggs:GetChildren()) do
    if v:IsA("Model") then
        table.insert(pet, v.Name)
    end
end

Pet:Dropdown("Select Pet", pet, function(v)
    selectedPet = v
    
end)

Pet:Dropdown("Select Type Open", petType, function(v)
    selectedType = v
end)

Pet:Toggle("Auto Pet (Must near by the egg)", "", false, function(v)
    _G.Settings.pet = v
    for i, v in pairs(game:GetService("Workspace").EggStands:GetChildren()) do
        if v:IsA("Model") then
            for i2, V in pairs(v:GetChildren()) do
                if V:IsA("MeshPart") and selectedPet == v.Name then
                    print(V.Parent)
                    teleport(V)
               end 
            end
        end
    end
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.pet then break end
            
            ReplicatedStorage.Remotes.Pets.Eggs.HatchEgg:FireServer(selectedPet, selectedType)
        end
    end)
end)

Pet:Button("Remove Egg Animation","",function()
    game:GetService("ReplicatedStorage").Remotes.Pets.Eggs.HatchEggAnimation:FireServer(false)
end)

Pet:Line()

local crates         = {}
local selectedCrates = {}

for i, v in pairs(ReplicatedStorage.Assets.Crates:GetChildren()) do
    if v:IsA("Model") then
        table.insert(crates, v.Name)
    end
end

Pet:Dropdown("Select Crate", crates, function(v)
    selectedCrates = v
end)

Pet:Toggle("Auto Crates", "", false, function(v)
    _G.Settings.autocrate = v
    task.spawn(function()
    while task.wait() do
            if not _G.Settings.autocrate then break end
            ReplicatedStorage.Remotes.Market.AttemptPurchaseCrate:InvokeServer(selectedCrates)
        end
    end)
end)

local Tele = w:Tab("Teleports", 8916381379)

for _, v in pairs(game:GetService("Workspace").TriggerAreas:GetChildren()) do
    Tele:Button(v.Name, "", function()
        for _, V in pairs(v:GetChildren()) do
            if V:IsA("Part") then
                teleport(V)
            end
        end
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
