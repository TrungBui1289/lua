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
            for I,V in pairs(workspace[game.Players.LocalPlayer.Name]:GetChildren()) do
               if V:IsA("Tool") and string.find(tostring(V), "Sword") then
                   V.Animation.Slash:FireServer()
               end
            end
        end
    end)
end)


local Tele = w:Tab("Teleport", 8916381379)

Tele:Label("Teleport to Position...")
for i,  v in pairs(game:GetService("Workspace")["__MAP"]["__KING"]:GetChildren()) do
    if v.Name == "Crown" then
        Tele:Button(v.Name, "", function()
           humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
           wait(0.1)
           Player.Character.HumanoidRootPart.CFrame = v.CFrame
        end)
   end
end

Tele:Line()
Tele:Label("Teleport to Players....")
for i, v in pairs(game:GetService("Players"):GetChildren()) do
    
    Tele:Button(v.Name, "", function()
    local NewPlayerCFrame = v.Character.HumanoidRootPart.CFrame
        Player.Character.HumanoidRootPart.CFrame = NewPlayerCFrame  
    end)
end


local Mics = w:Tab("Mics", 6031215984)

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

