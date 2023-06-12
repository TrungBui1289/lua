-- <CONFIGURATION>
local LIMIT_BACKGROUND_FPS = true
local NO_BACKGROUND_RENDERING = false
local NO_BACKGROUND_AUDIO = true
local LOW_RENDER_QUALITY = true
local MODIFY_TERRAIN_PROPERTIES = true
local MODIFY_LIGHT_PROPERTIES = true
local MODIFY_OBJECT_EFFECTS = true
local ANTI_AFK = true
-- </CONFIGURATION>

repeat wait() until game:IsLoaded()

local userGameSettings = UserSettings():GetService("UserGameSettings")
local virtualUser = game:GetService("VirtualUser")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local originalVolume = userGameSettings.MasterVolume
local lighting = game.Lighting

local function setupConnections()
    local playerIdledConnection = nil
    local windowFocusedConnection = nil
    local windowUnfocusConnection = nil
    
    if ANTI_AFK then
        playerIdledConnection = game.Players.LocalPlayer.Idled:Connect(function()
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new())
        end)
    end

    if LIMIT_BACKGROUND_FPS or NO_BACKGROUND_RENDERING or NO_BACKGROUND_AUDIO then
        windowFocusedConnection = userInputService.WindowFocused:Connect(function()
            if NO_BACKGROUND_RENDERING then
                runService:Set3dRenderingEnabled(true)
            end
            
            if NO_BACKGROUND_AUDIO then
                userGameSettings.MasterVolume = originalVolume
            end
            
            if LIMIT_BACKGROUND_FPS then
                setfpscap(60)
            end
        end)
        
        windowUnfocusConnection = userInputService.WindowFocusReleased:Connect(function()
            if NO_BACKGROUND_RENDERING then
                runService:Set3dRenderingEnabled(false)
            end

            if NO_BACKGROUND_AUDIO then
                if (userGameSettings.MasterVolume - originalVolume) > 0.01 then
                    originalVolume = userGameSettings.MasterVolume
                end
                
                userGameSettings.MasterVolume = 0
            end
            
            if LIMIT_BACKGROUND_FPS then
                setfpscap(8)
            end
        end)
    end
    
    return { playerIdledConnection, windowFocusedConnection, windowUnfocusConnection }
end

local function modifySettingsAndProperties()
    if LOW_RENDER_QUALITY then
        settings().Rendering.QualityLevel = 1
    end
    
    if MODIFY_TERRAIN_PROPERTIES then
        local terrain = game.Workspace.Terrain
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 0
    end
    
    if MODIFY_LIGHT_PROPERTIES then
        lighting.GlobalShadows = false
        lighting.FogStart = 0
        lighting.FogEnd = 0
        lighting.Brightness = 0
    end
end

local function modifyObjects(delayAmount) 
    if MODIFY_OBJECT_EFFECTS then
        if delayAmount then task.wait(delayAmount) end
        
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("MeshPart") or obj:IsA("Part") or obj:IsA("Union") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            elseif obj:IsA("Explosion") then
                obj.BlastPressure = 1
                obj.BlastRadius = 1
            elseif obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("SpotLight") or obj:IsA("Smoke") or obj:IsA("Trail") or obj:IsA("ParticleEmitter") then
                obj.Enabled = false
            end
        end
        
        for _, effect in pairs(lighting:GetChildren()) do
            if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("SunRaysEffect") then
                effect.Enabled = false
            end
        end
    end
end

setupConnections()
modifySettingsAndProperties()
modifyObjects(15)
