repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.Settings = {
    autoTap     = false;
    autoEgg     = false;
    autoRebirth = false;
    walkSpeed   = false;
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
            ReplicatedStorage.Remotes.Click:InvokeServer()
            ReplicatedStorage.Remotes.swingPick:Fire()
        end
    end)
end)

Farm:Toggle("Auto Rebirth", "", false, function(v)
    _G.Settings.autoRebirth = v

    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoRebirth then break end
            ReplicatedStorage.Remotes.Rebirth:FireServer()
        end
    end)
end)

local pet = {}
local selectedPet = {}

for _, v in pairs(game:GetService("ReplicatedStorage").itemStorage:GetChildren()) do
    if v:IsA("Model") then
        table.insert(pet, v.Name)
    end
end

Farm:Dropdown("Select Pet", pet, function(v)
    selectedPet = v
end)

Farm:Toggle("Auto Egg", "", false, function(v)
    _G.Settings.autoEgg = v
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoEgg then break end
            ReplicatedStorage.Remotes.buyEgg:InvokeServer(selectedPet, 1)
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