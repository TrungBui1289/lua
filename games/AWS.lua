repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.Settings = {
	autoBoss = false;
	autoClaimGift = false;
	autoGrips = false;
	autoDumbells = true;
	autoBag = true;
	autoRebirth = false;
	autoClick = true;
	autoNinjaEgg = false;
	autoEventEgg = false;
    walkSpeed = false;
}

local Player            = game:GetService("Players").LocalPlayer

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrungBui1289/lua/main/ui/hunterlib.lua"))()
local w       = library:Window("TrungB Scripts", "AWS [RShift]", Color3.fromRGB(182, 0, 182), Enum.KeyCode.RightShift)

local ReplicatedStorage = game:GetService("ReplicatedStorage").Packages["_Index"]["sleitnick_knit@1.4.7"].knit.Services

local humanoid = game.Players.LocalPlayer.Character.Humanoid

local Farm = w:Tab("Farming", 6034287535)

Farm:Toggle("Auto Claim Gift", "", false, function(v)
    _G.Settings.autoClaimGift = v
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoClaimGift then break end
            for i, v in pairs(ReplicatedStorage.TimedRewardService:GetChildren()) do
			for i2 = 1, 12, 1 do
				if i2 == 4 or i2 == 7 or i2 == 10 then
				
				else
					v.onClaim:FireServer(i2)
					wait(0.5)
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
            for i, v in pairs(ReplicatedStorage.RebirthServer:GetChildren()) do
				v.onRebirthRequest:FireServer()
			end
        end
    end)
end)
Farm:Line()

Farm:Toggle("Auto Click", "", true, function(v)
    _G.Settings.autoClick = v
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoClick then break end
            ReplicatedStorage.ToolService.RE.onClick:FireServer()
			ReplicatedStorage.ArmWrestleService.RE.onClickRequest:FireServer()
        end
    end)
end)
Farm:Toggle("Auto Event Egg (x8)", "", false, function(v)
    _G.Settings.autoEventEgg = v
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoEventEgg then break end
            for i, v in pairs(ReplicatedStorage.EventService.RF:GetChildren()) do
				if v:IsA("RemoteFunction") and v.Name == "ClaimEgg" then
					v:InvokeServer(8)
				end
			end
        end
    end)
end)

Farm:Toggle("Auto Ninja Egg (x8)", "", false, function(v)
    _G.Settings.autoNinjaEgg = v
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoNinjaEgg then break end
            for i, v in pairs(ReplicatedStorage.EventService.RF:GetChildren()) do
				if v:IsA("RemoteFunction") and v.Name == "ClaimEgg" then
					v:InvokeServer(8, true)
				end
			end
        end
    end)
end)

Farm:Line()

Farm:Toggle("Auto Dumbells", "", true, function(v)
    _G.Settings.autoDumbells = v
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoDumbells then break end
			for i2, v2 in pairs(ReplicatedStorage.ToolService.RE:GetChildren()) do
				if v2:IsA("RemoteEvent") then
					if v2.Name == "onEquipRequest" then
						v2:FireServer(3, "Dumbells", "45000Kg")
					end
				end
				ReplicatedStorage.ToolService.RE.onClick:FireServer()
			end
        end
    end)
end)

Farm:Toggle("Auto Grips", "", false, function(v)
    _G.Settings.autoGrips = v
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoGrips then break end
			for i2, v2 in pairs(ReplicatedStorage.ToolService.RE:GetChildren()) do
				if v2:IsA("RemoteEvent") then
					if v2.Name == "onEquipRequest" then
						v2:FireServer(3, "Grips", "45000Kg")
					end
				end
				ReplicatedStorage.ToolService.RE.onClick:FireServer()
			end
        end
    end)
end)

Farm:Toggle("Auto Bag (Must near bag)", "", true, function(v)
    _G.Settings.autoBag = v
    task.spawn(function()
        while task.wait() do
            if not _G.Settings.autoBag then break end
			for i2, v2 in pairs(ReplicatedStorage.PunchBagService.RE:GetChildren()) do
				if v2:IsA("RemoteEvent") then
					if v2.Name == "onGiveStats" then
						v2:FireServer(3, "VIP", true)
						ReplicatedStorage.ToolService.RE.onClick:FireServer()
					end
				end
			end
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

wait(3)
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Zones["3"]["Interactables"].Training.PunchBags.VIP["Axel_Cylinder.281"].CFrame
