print("------------------------------")
print("  BaseBattles by TrungB")
print("------------------------------")

_G.Settings = {
    trigger     = false;
    walkSpeed     = false;
}
local bind = Enum.KeyCode.RightShift

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrungBui1289/lua/main/ui/hunterlib.lua"))()
local w       = library:Window("TrungB Scripts", "BaseBattles [RShift]", Color3.fromRGB(182, 0, 182), bind)

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
    "Hitbox Amount", "", 0, 50, 15,
    function(amount)
        hitboxAmount = amount
    end
)

Battle:Button(
    "HitBoxes", "",
    function()
	
	-- loop
	getgenv().HeadSize = hitboxAmount
	getgenv().Disabled = true
	game:GetService("RunService").Stepped:Connect(function()
	    -- gets all players in the server
	    for _, player in next, game:GetService("Players"):GetPlayers() do
		-- checks if the player found was not the local player, so the local player doesnt get his hitbox extended
		if player ~= game:GetService("Players").LocalPlayer then
		    -- finds humanoid root part, then changes transparecy and can collide so you can walk through the hitbox and it wont be wonky
		    if player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character["HumanoidRootPart"].CanCollide = false
			player.Character["HumanoidRootPart"].Transparency = 0.5
		    end		
		    -- changes the humanoidrootpart size (basically the main code)
		    if player.Character["HumanoidRootPart"].Size ~= Vector3.new(getgenv().HeadSize, getgenv().HeadSize, getgenv().HeadSize) then
			player.Character["HumanoidRootPart"].Size = Vector3.new(getgenv().HeadSize, getgenv().HeadSize, getgenv().HeadSize)
		    end
		end
	    end
	end)
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
local key = Enum.KeyCode.C
--inf ammo
Battle:Bind("Infinity Ammo", key, function()
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

Mics:Button("Destroy", "", function()
    w:Destroy()
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
Mics:Slider("WalkSpeed Amount", "",0, 1000, 18, function(v)
    walkSpeed = v
end)
