repeat wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

_G.Settings = {
    walkSpeed = false;
}

local Player            = game:GetService("Players").LocalPlayer

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrungBui1289/lua/main/ui/hunterlib.lua"))()
local w       = library:Window("TrungB Scripts", "Pls Doante [RShift]", Color3.fromRGB(182, 0, 182), Enum.KeyCode.RightShift)


local humanoid = game.Players.LocalPlayer.Character.Humanoid

local Mics = w:Tab("Mics", 8916127218)

Mics:Button("Find richer R$", "", function()
    local minimum = 5000

    loadstring(game:HttpGet("https://raw.githubusercontent.com/TrungBui1289/lua/main/Vietnam.lua"))()
    
    if game.PlaceId ~= 8737602449 then return end 
    
    if not game.IsLoaded then game.Loaded:Wait() end

    local highestdono = 0
    local highestplr = nil


    for i,v in pairs(game:GetService("Players"):GetPlayers()) do
       repeat wait() until v:FindFirstChild("leaderstats")
    end

    local function getDonated(plr)
       local stats = plr:WaitForChild("leaderstats")
       local donated = stats:FindFirstChild("Donated")
       if donated == nil then
           return 0
       end
       return donated.Value
    end

    local function shop() -- infinite yield serverhop
       local x = {}
       for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
        if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
        x[#x + 1] = v.id
        end
       end
       if #x > 0 then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)])
        game:GetService("GuiService").UiMessageChanged:Wait()
           shop()
       else
        return error("Couldn't find a server.")
       end
    end

    for i,v in pairs(game:GetService("Players"):GetPlayers()) do
       if i == 1 then continue end
       local dono = getDonated(v)
       if dono > highestdono then
           highestdono = dono
           highestplr = v
       end
    end

    if highestdono >= minimum then
       local richPlayers = {}
       for i,v in pairs(game:GetService("Players"):GetPlayers()) do
           if i == 1 then continue end
           if getDonated(v) >= minimum then
               table.insert(richPlayers,v)
           end
       end
       game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Richest player found!",
    Text = highestplr.Name .. " has donated " .. highestdono .. "R$",
    Duration = 15
    })
    table.foreach(richPlayers,function(i)
       print(richPlayers[i].Name .. " donated " .. tostring(getDonated(richPlayers[i])) .. "R$")
    end)
    else
       shop()
       
    end
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