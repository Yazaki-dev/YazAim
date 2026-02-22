local DEBUG = false

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Interface Manager (config save/load)
local UISettings = {
    TabWidth = 160,
    Size = {580, 460},
    Theme = "VSC Dark High Contrast",
    Acrylic = false,
    Transparency = true,
    MinimizeKey = "RightShift",
    ShowNotifications = true,
    ShowWarnings = true,
    RenderingMode = "RenderStepped",
    AutoImport = true
}

local InterfaceManager = {}
function InterfaceManager:ImportSettings()
    pcall(function()
        if not DEBUG and isfile and readfile and isfile("YazAimUISettings.json") then
            local data = HttpService:JSONDecode(readfile("YazAimUISettings.json"))
            for k, v in pairs(data) do UISettings[k] = v end
        end
    end)
end

function InterfaceManager:ExportSettings()
    pcall(function()
        if not DEBUG and writefile then
            writefile("YazAimUISettings.json", HttpService:JSONEncode(UISettings))
        end
    end)
end

InterfaceManager:ImportSettings()
UISettings.__LAST_RUN__ = os.date()
InterfaceManager:ExportSettings()

-- Colors Handler
local ColorsHandler = {}
function ColorsHandler:PackColour(c) return typeof(c) == "Color3" and {R = c.R*255, G = c.G*255, B = c.B*255} or c or {R=255,G=255,B=255} end
function ColorsHandler:UnpackColour(c) return typeof(c) == "table" and Color3.fromRGB(c.R, c.G, c.B) or c or Color3.fromRGB(255,255,255) end

-- Configuration (imported or defaults)
local ImportedConfiguration = {}
pcall(function()
    if not DEBUG and isfile and readfile and isfile(game.GameId .. ".json") and UISettings.AutoImport then
        ImportedConfiguration = HttpService:JSONDecode(readfile(game.GameId .. ".json"))
        for k, v in pairs(ImportedConfiguration) do
            if k:match("Colour$") then ImportedConfiguration[k] = ColorsHandler:UnpackColour(v) end
        end
    end
end)

local Configuration = {}
-- Aimbot
Configuration.Aimbot                  = ImportedConfiguration.Aimbot or false
Configuration.OnePressAimingMode      = ImportedConfiguration.OnePressAimingMode or false
Configuration.AimKey                  = ImportedConfiguration.AimKey or "RMB"
Configuration.AimMode                 = ImportedConfiguration.AimMode or "Camera"
Configuration.SilentAimMethods        = ImportedConfiguration.SilentAimMethods or {"Mouse.Hit / Mouse.Target", "GetMouseLocation"}
Configuration.SilentAimChance         = ImportedConfiguration.SilentAimChance or 100
Configuration.OffAimbotAfterKill      = ImportedConfiguration.OffAimbotAfterKill or false
Configuration.AimPart                 = ImportedConfiguration.AimPart or "HumanoidRootPart"
Configuration.AimPartDropdownValues   = ImportedConfiguration.AimPartDropdownValues or {"Head", "HumanoidRootPart"}
Configuration.RandomAimPart           = ImportedConfiguration.RandomAimPart or false
Configuration.UseOffset               = ImportedConfiguration.UseOffset or false
Configuration.OffsetType              = ImportedConfiguration.OffsetType or "Static"
Configuration.StaticOffsetIncrement   = ImportedConfiguration.StaticOffsetIncrement or 10
Configuration.DynamicOffsetIncrement  = ImportedConfiguration.DynamicOffsetIncrement or 10
Configuration.AutoOffset              = ImportedConfiguration.AutoOffset or false
Configuration.MaxAutoOffset           = ImportedConfiguration.MaxAutoOffset or 50
Configuration.UseSensitivity          = ImportedConfiguration.UseSensitivity or false
Configuration.Sensitivity             = ImportedConfiguration.Sensitivity or 50
Configuration.UseNoise                = ImportedConfiguration.UseNoise or false
Configuration.NoiseFrequency          = ImportedConfiguration.NoiseFrequency or 50

-- Bots (Spin/Trigger)
Configuration.SpinBot                 = ImportedConfiguration.SpinBot or false
Configuration.OnePressSpinningMode    = ImportedConfiguration.OnePressSpinningMode or false
Configuration.SpinKey                 = ImportedConfiguration.SpinKey or "Q"
Configuration.SpinBotVelocity         = ImportedConfiguration.SpinBotVelocity or 50
Configuration.SpinPart                = ImportedConfiguration.SpinPart or "HumanoidRootPart"
Configuration.SpinPartDropdownValues  = ImportedConfiguration.SpinPartDropdownValues or {"Head", "HumanoidRootPart"}
Configuration.RandomSpinPart          = ImportedConfiguration.RandomSpinPart or false
Configuration.TriggerBot              = ImportedConfiguration.TriggerBot or false
Configuration.OnePressTriggeringMode  = ImportedConfiguration.OnePressTriggeringMode or false
Configuration.SmartTriggerBot         = ImportedConfiguration.SmartTriggerBot or false
Configuration.TriggerKey              = ImportedConfiguration.TriggerKey or "E"
Configuration.TriggerBotChance        = ImportedConfiguration.TriggerBotChance or 100

-- Checks (alive, team, wall, FoV, etc.)
Configuration.AliveCheck              = ImportedConfiguration.AliveCheck or false
Configuration.GodCheck                = ImportedConfiguration.GodCheck or false
Configuration.TeamCheck               = ImportedConfiguration.TeamCheck or false
Configuration.FriendCheck             = ImportedConfiguration.FriendCheck or false
Configuration.FollowCheck             = ImportedConfiguration.FollowCheck or false
Configuration.VerifiedBadgeCheck      = ImportedConfiguration.VerifiedBadgeCheck or false
Configuration.WallCheck               = ImportedConfiguration.WallCheck or false
Configuration.WaterCheck              = ImportedConfiguration.WaterCheck or false
Configuration.FoVCheck                = ImportedConfiguration.FoVCheck or false
Configuration.FoVRadius               = ImportedConfiguration.FoVRadius or 100
Configuration.MagnitudeCheck          = ImportedConfiguration.MagnitudeCheck or false
Configuration.TriggerMagnitude        = ImportedConfiguration.TriggerMagnitude or 500
Configuration.TransparencyCheck       = ImportedConfiguration.TransparencyCheck or false
Configuration.IgnoredTransparency     = ImportedConfiguration.IgnoredTransparency or 0.5
Configuration.WhitelistedGroupCheck   = ImportedConfiguration.WhitelistedGroupCheck or false
Configuration.WhitelistedGroup        = ImportedConfiguration.WhitelistedGroup or 0
Configuration.BlacklistedGroupCheck   = ImportedConfiguration.BlacklistedGroupCheck or false
Configuration.BlacklistedGroup        = ImportedConfiguration.BlacklistedGroup or 0
Configuration.IgnoredPlayersCheck     = ImportedConfiguration.IgnoredPlayersCheck or false
Configuration.IgnoredPlayersDropdownValues = ImportedConfiguration.IgnoredPlayersDropdownValues or {}
Configuration.IgnoredPlayers         = ImportedConfiguration.IgnoredPlayers or {}
Configuration.TargetPlayersCheck      = ImportedConfiguration.TargetPlayersCheck or false
Configuration.TargetPlayersDropdownValues = ImportedConfiguration.TargetPlayersDropdownValues or {}
Configuration.TargetPlayers           = ImportedConfiguration.TargetPlayers or {}
Configuration.PremiumCheck            = ImportedConfiguration.PremiumCheck or false

-- Visuals
Configuration.FoV                     = ImportedConfiguration.FoV or false
Configuration.FoVKey                  = ImportedConfiguration.FoVKey or "R"
Configuration.FoVThickness            = ImportedConfiguration.FoVThickness or 2
Configuration.FoVOpacity              = ImportedConfiguration.FoVOpacity or 0.8
Configuration.FoVFilled               = ImportedConfiguration.FoVFilled or false
Configuration.FoVColour               = ImportedConfiguration.FoVColour or Color3.fromRGB(0, 255, 150) -- Yaz green
Configuration.SmartESP                = ImportedConfiguration.SmartESP or false
Configuration.ESPKey                  = ImportedConfiguration.ESPKey or "T"
Configuration.ESPBox                  = ImportedConfiguration.ESPBox or false
Configuration.ESPBoxFilled            = ImportedConfiguration.ESPBoxFilled or false
Configuration.NameESP                 = ImportedConfiguration.NameESP or false
Configuration.NameESPFont             = ImportedConfiguration.NameESPFont or "Monospace"
Configuration.NameESPSize             = ImportedConfiguration.NameESPSize or 16
Configuration.NameESPOutlineColour    = ImportedConfiguration.NameESPOutlineColour or Color3.fromRGB(0,0,0)
Configuration.HealthESP               = ImportedConfiguration.HealthESP or false
Configuration.MagnitudeESP            = ImportedConfiguration.MagnitudeESP or false
Configuration.TracerESP               = ImportedConfiguration.TracerESP or false
Configuration.ESPThickness            = ImportedConfiguration.ESPThickness or 2
Configuration.ESPOpacity              = ImportedConfiguration.ESPOpacity or 0.8
Configuration.ESPColour               = ImportedConfiguration.ESPColour or Color3.fromRGB(0, 255, 150)
Configuration.ESPUseTeamColour        = ImportedConfiguration.ESPUseTeamColour or false
Configuration.RainbowVisuals          = ImportedConfiguration.RainbowVisuals or false
Configuration.RainbowDelay            = ImportedConfiguration.RainbowDelay or 5

-- Constants / Helpers (kept minimal)
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local IsComputer = UserInputService.KeyboardEnabled and UserInputService.MouseEnabled

-- Load Fluent UI
local Fluent
do
    local Success, Result = pcall(game.HttpGet, game, "https://twix.cyou/Fluent.txt", true)
    if Success and Result and Result:find("dawid") then
        Fluent = loadstring(Result)()
    else
        -- Mirror fallback (uncomment if needed)
        -- Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua"))()
        return -- exit if load fails
    end
end

-- Window - YazAim branded
local Window = Fluent:CreateWindow({
    Title = "YazAim <b><i>Universal</i></b>",
    SubTitle = "by Yazaki",
    TabWidth = UISettings.TabWidth,
    Size = UDim2.fromOffset(table.unpack(UISettings.Size)),
    Theme = UISettings.Theme,
    Acrylic = UISettings.Acrylic,
    MinimizeKey = UISettings.MinimizeKey
})

local Tabs = {
    Aimbot = Window:AddTab({Title = "Aimbot", Icon = "crosshair"}),
    Bots = Window:AddTab({Title = "Bots", Icon = "bot"}),
    Checks = Window:AddTab({Title = "Checks", Icon = "list-checks"}),
    Visuals = Window:AddTab({Title = "Visuals", Icon = "box"}),
    Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
}

Window:SelectTab(1)

-- Branding
Tabs.Aimbot:AddParagraph({
    Title = "YazAim",
    Content = "Universal Aimbot & ESP Hub\nMade by Yazaki"
})

-- (The rest of the UI creation, hooks, loops, ESP library, tracking, etc. remain unchanged from your original paste except for Notify calls and titles)
-- Replace all Notify calls to use "YazAim" title
local function Notify(Message)
    if Fluent then
        Fluent:Notify({
            Title = "YazAim",
            Content = Message,
            Duration = 2
        })
    end
end

-- Example usage in code (you can search/replace in your editor)
-- Notify("[Aiming Mode]: ON") → becomes YazAim notification

-- At end of script (instead of premium notify)
Notify("YazAim Loaded – Enjoy!")

-- The full logic continues exactly as in your paste (IsReady function, metamethod hooks, bot handling, ESP visualization, main AimbotLoop on RenderStepped/etc.)
-- Paste your original code body here after the UI setup, changing only Notify calls and any remaining "Open Aimbot" strings to "YazAim"
