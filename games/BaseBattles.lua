print("------------------------------")
print("  BaseBattles by TrungB")
print("------------------------------")

_G.Settings = {
    trigger     = false;
    walkSpeed     = false;
}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrungBui1289/lua/main/ui/hunterlib.lua"))()
local w       = library:Window("TrungB Scripts", "BaseBattles [RShift]", Color3.fromRGB(182, 0, 182), Enum.KeyCode.RightShift)

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

local Home = w:Tab("Information", 6026568198)

Home:Button("Games Active (Click me)", "", function()
    library:Notification("  [+] Base Battles       - [+] Eating Simulator\n  [+] Anime Lifting    - [+] Anime Punching\n   [+] Swordman Sim  - [+] Strongest Punch \n [+] Rebirth ChampionX - [+] Lifting Titans\n         [+] Undead Defense Tycoon", "Thanks")
end)

Home:Line()

Home:Button("Discord (Click)","", function()
    setclipboard("TrungB#1230")
    library:Notification("TrungB#1230", "Copied")
end)

--[Battles]--
local Battle = w:Tab("Battles", 6034287535)
Battle:Button(
    "No Recoil", "",
    function()
        for i, v in next, getgc(true) do
            if type(v) == "table" and rawget(v, "damage") then
                v.bloomFactor = 0
                v.noYawRecoil = "true"
                v.recoilCoefficient = 1
            end
        end
    end
)

--HitboxAmount
local hitboxAmount = 15
Battle:Slider(
    "Hitbox Amount", "", 15, 50, 0,
    function(amount)
        hitboxAmount = amount
    end
)

Battle:Button(
    "HitBoxes", "",
    function()
        while true do
            wait(1)
            getgenv().HeadSize = hitboxAmount
            getgenv().Disabled = true

            if getgenv().Disabled then
                for i, v in next, game:GetService("Players"):GetPlayers() do
                    if v.Name ~= game:GetService("Players").LocalPlayer.Name then
                        pcall(
                            function()
                                v.Character.HumanoidRootPart.Name = "xC6M3Vuz7QpsY5nv"
                                v.Character.xC6M3Vuz7QpsY5nv.Size =
                                    Vector3.new(getgenv().HeadSize - 1, getgenv().HeadSize + 1, getgenv().HeadSize - 1)
                                v.Character.xC6M3Vuz7QpsY5nv.Transparency = 0.6
                                v.Character.xC6M3Vuz7QpsY5nv.CanCollide = false
                                v.Character.xC6M3Vuz7QpsY5nv.Color = Color3.fromRGB(145, 133, 99)
                            end
                        )
                    end
                end
            end
        end
    end
)

--Make all guns automatic
Battle:Button(
    "GunAuto", "",
    function()
        for i, v in next, getgc(true) do
            if type(v) == "table" and rawget(v, "damage") then
                v.automatic = "true"
            end
        end
    end
)

--inf ammo
Battle:Button("Infinity Ammo", "", function()
    for i, v in pairs(getgc(true)) do
        if type(v) == "table" and rawget(v, "ammo") then
            v.ammo = math.huge
        end
    end
end)

--Triggerbot
Battle:Toggle("Triggerbot ", "", false, function(v)
    _G.Settings.trigger = v
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.trigger then break end
            game:GetService("RunService").RenderStepped:Connect(
                function()
                    if mouse.Target.Parent:FindFirstChild("Humanoid") and mouse.Target.Parent.Name ~= player.Name then
                        local target = game:GetService("Players"):FindFirstChild(mouse.Target.Parent.Name)
                        if shared.toggle then
                            mouse1press()
                            wait()
                            mouse1release()
                        end
                    end
                end
            )
        end
    end)
end)

--[Mics]--
local Mics = w:Tab("Mics", 6031215984)

Mics:Button("ESP", "", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TrungBui1289/lua/main/ui/ESP.lua"))()
end)

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
