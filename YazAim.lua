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
-- Bots
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

-- Checks
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

-- Constants / Helpers
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
        -- Optional mirror fallback (uncomment if twix fails)
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
    Bots   = Window:AddTab({Title = "Bots", Icon = "bot"}),
    Checks = Window:AddTab({Title = "Checks", Icon = "list-checks"}),
    Visuals = Window:AddTab({Title = "Visuals", Icon = "box"}),
    Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
}

Window:SelectTab(1)

-- Branding paragraphs
Tabs.Aimbot:AddParagraph({
    Title = "YazAim",
    Content = "Universal Aimbot & ESP Hub\nMade by Yazaki"
})
-- Aimbot Tab UI
local AimbotSection = Tabs.Aimbot:AddSection("Aimbot")

local AimbotToggle = AimbotSection:AddToggle("Aimbot", {
    Title = "Aimbot",
    Description = "Toggles the Aimbot",
    Default = Configuration.Aimbot
})
AimbotToggle:OnChanged(function(Value)
    Configuration.Aimbot = Value
    if not IsComputer then
        Aiming = Value
    end
end)

if IsComputer then
    local OnePressAimingModeToggle = AimbotSection:AddToggle("OnePressAimingMode", {
        Title = "One-Press Mode",
        Description = "Uses One-Press instead of Holding",
        Default = Configuration.OnePressAimingMode
    })
    OnePressAimingModeToggle:OnChanged(function(Value)
        Configuration.OnePressAimingMode = Value
    end)

    local AimKeybind = AimbotSection:AddKeybind("AimKey", {
        Title = "Aim Key",
        Description = "Key to activate aim",
        Default = Configuration.AimKey,
        ChangedCallback = function(Value)
            Configuration.AimKey = Value
        end
    })
    Configuration.AimKey = AimKeybind.Value ~= "RMB" and Enum.KeyCode[AimKeybind.Value] or Enum.UserInputType.MouseButton2
end

local AimModeDropdown = AimbotSection:AddDropdown("AimMode", {
    Title = "Aim Mode",
    Description = "Camera / Mouse / Silent",
    Values = {"Camera"},
    Default = Configuration.AimMode,
    Callback = function(Value)
        Configuration.AimMode = Value
    end
})

if mousemoverel and IsComputer then
    table.insert(AimModeDropdown.Values, "Mouse")
    AimModeDropdown:BuildDropdownList()
end

if hookmetamethod and newcclosure and checkcaller and getnamecallmethod then
    table.insert(AimModeDropdown.Values, "Silent")
    AimModeDropdown:BuildDropdownList()

    local SilentAimMethodsDropdown = AimbotSection:AddDropdown("SilentAimMethods", {
        Title = "Silent Aim Methods",
        Description = "Methods for silent aim",
        Values = {"Mouse.Hit / Mouse.Target", "GetMouseLocation", "Raycast", "FindPartOnRay", "FindPartOnRayWithIgnoreList", "FindPartOnRayWithWhitelist"},
        Multi = true,
        Default = Configuration.SilentAimMethods
    })
    SilentAimMethodsDropdown:OnChanged(function(Value)
        Configuration.SilentAimMethods = {}
        for k in pairs(Value) do
            if typeof(k) == "string" then
                table.insert(Configuration.SilentAimMethods, k)
            end
        end
    end)

    AimbotSection:AddSlider("SilentAimChance", {
        Title = "Silent Aim Chance",
        Description = "Hit chance % for silent aim",
        Default = Configuration.SilentAimChance,
        Min = 1,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            Configuration.SilentAimChance = Value
        end
    })
end

local OffAimbotAfterKillToggle = AimbotSection:AddToggle("OffAimbotAfterKill", {
    Title = "Off After Kill",
    Description = "Disable aim after killing target",
    Default = Configuration.OffAimbotAfterKill
})
OffAimbotAfterKillToggle:OnChanged(function(Value)
    Configuration.OffAimbotAfterKill = Value
end)

local AimPartDropdown = AimbotSection:AddDropdown("AimPart", {
    Title = "Aim Part",
    Description = "Body part to target",
    Values = Configuration.AimPartDropdownValues,
    Default = Configuration.AimPart,
    Callback = function(Value)
        Configuration.AimPart = Value
    end
})

local RandomAimPartToggle = AimbotSection:AddToggle("RandomAimPart", {
    Title = "Random Aim Part",
    Description = "Randomly change part every second",
    Default = Configuration.RandomAimPart
})
RandomAimPartToggle:OnChanged(function(Value)
    Configuration.RandomAimPart = Value
end)

AimbotSection:AddInput("AddAimPart", {
    Title = "Add Aim Part",
    Description = "Enter part name → Enter",
    Finished = true,
    Placeholder = "Part Name",
    Callback = function(Value)
        if #Value > 0 and not table.find(Configuration.AimPartDropdownValues, Value) then
            table.insert(Configuration.AimPartDropdownValues, Value)
            AimPartDropdown:SetValue(Value)
        end
    end
})

AimbotSection:AddInput("RemoveAimPart", {
    Title = "Remove Aim Part",
    Description = "Enter part name → Enter",
    Finished = true,
    Placeholder = "Part Name",
    Callback = function(Value)
        if #Value > 0 and table.find(Configuration.AimPartDropdownValues, Value) then
            if Configuration.AimPart == Value then AimPartDropdown:SetValue(nil) end
            table.remove(Configuration.AimPartDropdownValues, table.find(Configuration.AimPartDropdownValues, Value))
            AimPartDropdown:SetValues(Configuration.AimPartDropdownValues)
        end
    end
})

AimbotSection:AddButton({
    Title = "Clear All Items",
    Description = "Remove all aim parts",
    Callback = function()
        local count = #Configuration.AimPartDropdownValues
        AimPartDropdown:SetValue(nil)
        Configuration.AimPartDropdownValues = {}
        AimPartDropdown:SetValues(Configuration.AimPartDropdownValues)
        Fluent:Notify({
            Title = "YazAim",
            Content = count == 0 and "Nothing cleared!" or count == 1 and "1 item cleared!" or count .. " items cleared!",
            Duration = 3
        })
    end
})
-- Aim Offset Section
local AimOffsetSection = Tabs.Aimbot:AddSection("Aim Offset")

local UseOffsetToggle = AimOffsetSection:AddToggle("UseOffset", {
    Title = "Use Offset",
    Description = "Enable aim offset",
    Default = Configuration.UseOffset
})
UseOffsetToggle:OnChanged(function(Value)
    Configuration.UseOffset = Value
end)

AimOffsetSection:AddDropdown("OffsetType", {
    Title = "Offset Type",
    Description = "Static / Dynamic / Both",
    Values = {"Static", "Dynamic", "Static & Dynamic"},
    Default = Configuration.OffsetType,
    Callback = function(Value)
        Configuration.OffsetType = Value
    end
})

AimOffsetSection:AddSlider("StaticOffsetIncrement", {
    Title = "Static Offset Increment",
    Description = "Static offset value",
    Default = Configuration.StaticOffsetIncrement,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Callback = function(Value)
        Configuration.StaticOffsetIncrement = Value
    end
})

AimOffsetSection:AddSlider("DynamicOffsetIncrement", {
    Title = "Dynamic Offset Increment",
    Description = "Dynamic offset value",
    Default = Configuration.DynamicOffsetIncrement,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Callback = function(Value)
        Configuration.DynamicOffsetIncrement = Value
    end
})

local AutoOffsetToggle = AimOffsetSection:AddToggle("AutoOffset", {
    Title = "Auto Offset",
    Description = "Auto adjust offset",
    Default = Configuration.AutoOffset
})
AutoOffsetToggle:OnChanged(function(Value)
    Configuration.AutoOffset = Value
end)

AimOffsetSection:AddSlider("MaxAutoOffset", {
    Title = "Max Auto Offset",
    Description = "Maximum auto offset limit",
    Default = Configuration.MaxAutoOffset,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Callback = function(Value)
        Configuration.MaxAutoOffset = Value
    end
})

-- Sensitivity & Noise Section
local SensitivityNoiseSection = Tabs.Aimbot:AddSection("Sensitivity & Noise")

local UseSensitivityToggle = SensitivityNoiseSection:AddToggle("UseSensitivity", {
    Title = "Use Sensitivity",
    Description = "Enable aim sensitivity",
    Default = Configuration.UseSensitivity
})
UseSensitivityToggle:OnChanged(function(Value)
    Configuration.UseSensitivity = Value
end)

SensitivityNoiseSection:AddSlider("Sensitivity", {
    Title = "Sensitivity",
    Description = "Aim smoothness (1-100)",
    Default = Configuration.Sensitivity,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        Configuration.Sensitivity = Value
    end
})

local UseNoiseToggle = SensitivityNoiseSection:AddToggle("UseNoise", {
    Title = "Use Noise",
    Description = "Add camera shake when aiming",
    Default = Configuration.UseNoise
})
UseNoiseToggle:OnChanged(function(Value)
    Configuration.UseNoise = Value
end)

SensitivityNoiseSection:AddSlider("NoiseFrequency", {
    Title = "Noise Frequency",
    Description = "Noise intensity (1-100)",
    Default = Configuration.NoiseFrequency,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        Configuration.NoiseFrequency = Value
    end
})

-- Bots Tab
Tabs.Bots:AddParagraph({
    Title = "YazAim Bots",
    Content = "SpinBot & TriggerBot features\nMade by Yazaki"
})

local SpinBotSection = Tabs.Bots:AddSection("SpinBot")

SpinBotSection:AddParagraph({
    Title = "NOTE",
    Content = "SpinBot may not work in RenderStepped mode. Try Heartbeat or Stepped."
})

local SpinBotToggle = SpinBotSection:AddToggle("SpinBot", {
    Title = "SpinBot",
    Description = "Enable spinning",
    Default = Configuration.SpinBot
})
SpinBotToggle:OnChanged(function(Value)
    Configuration.SpinBot = Value
    if not IsComputer then
        Spinning = Value
    end
end)
if IsComputer then
    local OnePressSpinningModeToggle = SpinBotSection:AddToggle("OnePressSpinningMode", {
        Title = "One-Press Mode",
        Description = "One-press instead of hold for spin",
        Default = Configuration.OnePressSpinningMode
    })
    OnePressSpinningModeToggle:OnChanged(function(Value)
        Configuration.OnePressSpinningMode = Value
    end)

    local SpinKeybind = SpinBotSection:AddKeybind("SpinKey", {
        Title = "Spin Key",
        Description = "Key to toggle spin",
        Default = Configuration.SpinKey,
        ChangedCallback = function(Value)
            Configuration.SpinKey = Value
        end
    })
    Configuration.SpinKey = SpinKeybind.Value ~= "RMB" and Enum.KeyCode[SpinKeybind.Value] or Enum.UserInputType.MouseButton2
end

SpinBotSection:AddSlider("SpinBotVelocity", {
    Title = "Spin Velocity",
    Description = "Speed of spin (degrees/frame)",
    Default = Configuration.SpinBotVelocity,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Callback = function(Value)
        Configuration.SpinBotVelocity = Value
    end
})

local SpinPartDropdown = SpinBotSection:AddDropdown("SpinPart", {
    Title = "Spin Part",
    Description = "Body part to spin",
    Values = Configuration.SpinPartDropdownValues,
    Default = Configuration.SpinPart,
    Callback = function(Value)
        Configuration.SpinPart = Value
    end
})

local RandomSpinPartToggle = SpinBotSection:AddToggle("RandomSpinPart", {
    Title = "Random Spin Part",
    Description = "Random part change every second",
    Default = Configuration.RandomSpinPart
})
RandomSpinPartToggle:OnChanged(function(Value)
    Configuration.RandomSpinPart = Value
end)

SpinBotSection:AddInput("AddSpinPart", {
    Title = "Add Spin Part",
    Description = "Enter part name → Enter",
    Finished = true,
    Placeholder = "Part Name",
    Callback = function(Value)
        if #Value > 0 and not table.find(Configuration.SpinPartDropdownValues, Value) then
            table.insert(Configuration.SpinPartDropdownValues, Value)
            SpinPartDropdown:SetValue(Value)
        end
    end
})

SpinBotSection:AddInput("RemoveSpinPart", {
    Title = "Remove Spin Part",
    Description = "Enter part name → Enter",
    Finished = true,
    Placeholder = "Part Name",
    Callback = function(Value)
        if #Value > 0 and table.find(Configuration.SpinPartDropdownValues, Value) then
            if Configuration.SpinPart == Value then SpinPartDropdown:SetValue(nil) end
            table.remove(Configuration.SpinPartDropdownValues, table.find(Configuration.SpinPartDropdownValues, Value))
            SpinPartDropdown:SetValues(Configuration.SpinPartDropdownValues)
        end
    end
})

SpinBotSection:AddButton({
    Title = "Clear All Items",
    Description = "Remove all spin parts",
    Callback = function()
        local count = #Configuration.SpinPartDropdownValues
        SpinPartDropdown:SetValue(nil)
        Configuration.SpinPartDropdownValues = {}
        SpinPartDropdown:SetValues(Configuration.SpinPartDropdownValues)
        Fluent:Notify({
            Title = "YazAim",
            Content = count == 0 and "Nothing cleared!" or count == 1 and "1 item cleared!" or count .. " items cleared!",
            Duration = 3
        })
    end
})

-- TriggerBot Section (only if executor supports mouse1click)
if mouse1click and IsComputer then
    local TriggerBotSection = Tabs.Bots:AddSection("TriggerBot")

    local TriggerBotToggle = TriggerBotSection:AddToggle("TriggerBot", {
        Title = "TriggerBot",
        Description = "Auto-fire when crosshair on target",
        Default = Configuration.TriggerBot
    })
    TriggerBotToggle:OnChanged(function(Value)
        Configuration.TriggerBot = Value
    end)

    local OnePressTriggeringModeToggle = TriggerBotSection:AddToggle("OnePressTriggeringMode", {
        Title = "One-Press Mode",
        Description = "One-press instead of hold",
        Default = Configuration.OnePressTriggeringMode
    })
    OnePressTriggeringModeToggle:OnChanged(function(Value)
        Configuration.OnePressTriggeringMode = Value
    end)

    local SmartTriggerBotToggle = TriggerBotSection:AddToggle("SmartTriggerBot", {
        Title = "Smart TriggerBot",
        Description = "Only trigger when aiming",
        Default = Configuration.SmartTriggerBot
    })
    SmartTriggerBotToggle:OnChanged(function(Value)
        Configuration.SmartTriggerBot = Value
    end)

    local TriggerKeybind = TriggerBotSection:AddKeybind("TriggerKey", {
        Title = "Trigger Key",
        Description = "Key for triggerbot",
        Default = Configuration.TriggerKey,
        ChangedCallback = function(Value)
            Configuration.TriggerKey = Value
        end
    })
    Configuration.TriggerKey = TriggerKeybind.Value ~= "RMB" and Enum.KeyCode[TriggerKeybind.Value] or Enum.UserInputType.MouseButton2

    TriggerBotSection:AddSlider("TriggerBotChance", {
        Title = "TriggerBot Chance",
        Description = "Hit chance % for trigger",
        Default = Configuration.TriggerBotChance,
        Min = 1,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            Configuration.TriggerBotChance = Value
        end
    })
end

-- Checks Tab
Tabs.Checks:AddParagraph({
    Title = "YazAim Checks",
    Content = "Target filtering & visibility checks\nMade by Yazaki"
})

local SimpleChecksSection = Tabs.Checks:AddSection("Simple Checks")

local AliveCheckToggle = SimpleChecksSection:AddToggle("AliveCheck", {
    Title = "Alive Check",
    Description = "Ignore dead players",
    Default = Configuration.AliveCheck
})
AliveCheckToggle:OnChanged(function(Value)
    Configuration.AliveCheck = Value
end)

local GodCheckToggle = SimpleChecksSection:AddToggle("GodCheck", {
    Title = "God Check",
    Description = "Ignore invulnerable/godmode players",
    Default = Configuration.GodCheck
})
GodCheckToggle:OnChanged(function(Value)
    Configuration.GodCheck = Value
end)

local TeamCheckToggle = SimpleChecksSection:AddToggle("TeamCheck", {
    Title = "Team Check",
    Description = "Ignore teammates",
    Default = Configuration.TeamCheck
})
TeamCheckToggle:OnChanged(function(Value)
    Configuration.TeamCheck = Value
end)
local FriendCheckToggle = SimpleChecksSection:AddToggle("FriendCheck", {
    Title = "Friend Check",
    Description = "Ignore friends",
    Default = Configuration.FriendCheck
})
FriendCheckToggle:OnChanged(function(Value)
    Configuration.FriendCheck = Value
end)

local FollowCheckToggle = SimpleChecksSection:AddToggle("FollowCheck", {
    Title = "Follow Check",
    Description = "Ignore players following you",
    Default = Configuration.FollowCheck
})
FollowCheckToggle:OnChanged(function(Value)
    Configuration.FollowCheck = Value
end)

local VerifiedBadgeCheckToggle = SimpleChecksSection:AddToggle("VerifiedBadgeCheck", {
    Title = "Verified Badge Check",
    Description = "Ignore verified players",
    Default = Configuration.VerifiedBadgeCheck
})
VerifiedBadgeCheckToggle:OnChanged(function(Value)
    Configuration.VerifiedBadgeCheck = Value
end)

local WallCheckToggle = SimpleChecksSection:AddToggle("WallCheck", {
    Title = "Wall Check",
    Description = "Ignore players behind walls",
    Default = Configuration.WallCheck
})
WallCheckToggle:OnChanged(function(Value)
    Configuration.WallCheck = Value
end)

local WaterCheckToggle = SimpleChecksSection:AddToggle("WaterCheck", {
    Title = "Water Check",
    Description = "Ignore water when wall check is on",
    Default = Configuration.WaterCheck
})
WaterCheckToggle:OnChanged(function(Value)
    Configuration.WaterCheck = Value
end)

local AdvancedChecksSection = Tabs.Checks:AddSection("Advanced Checks")

local FoVCheckToggle = AdvancedChecksSection:AddToggle("FoVCheck", {
    Title = "FoV Check",
    Description = "Only target players in FoV",
    Default = Configuration.FoVCheck
})
FoVCheckToggle:OnChanged(function(Value)
    Configuration.FoVCheck = Value
end)

AdvancedChecksSection:AddSlider("FoVRadius", {
    Title = "FoV Radius",
    Description = "Field of view radius",
    Default = Configuration.FoVRadius,
    Min = 10,
    Max = 1000,
    Rounding = 1,
    Callback = function(Value)
        Configuration.FoVRadius = Value
    end
})

local MagnitudeCheckToggle = AdvancedChecksSection:AddToggle("MagnitudeCheck", {
    Title = "Magnitude Check",
    Description = "Ignore players too far away",
    Default = Configuration.MagnitudeCheck
})
MagnitudeCheckToggle:OnChanged(function(Value)
    Configuration.MagnitudeCheck = Value
end)

AdvancedChecksSection:AddSlider("TriggerMagnitude", {
    Title = "Trigger Magnitude",
    Description = "Max distance for trigger/aim",
    Default = Configuration.TriggerMagnitude,
    Min = 10,
    Max = 1000,
    Rounding = 1,
    Callback = function(Value)
        Configuration.TriggerMagnitude = Value
    end
})

local TransparencyCheckToggle = AdvancedChecksSection:AddToggle("TransparencyCheck", {
    Title = "Transparency Check",
    Description = "Ignore transparent parts",
    Default = Configuration.TransparencyCheck
})
TransparencyCheckToggle:OnChanged(function(Value)
    Configuration.TransparencyCheck = Value
end)

AdvancedChecksSection:AddSlider("IgnoredTransparency", {
    Title = "Ignored Transparency",
    Description = "Ignore if transparency >= this value",
    Default = Configuration.IgnoredTransparency,
    Min = 0.1,
    Max = 1,
    Rounding = 0.1,
    Callback = function(Value)
        Configuration.IgnoredTransparency = Value
    end
})

local WhitelistedGroupCheckToggle = AdvancedChecksSection:AddToggle("WhitelistedGroupCheck", {
    Title = "Whitelisted Group Check",
    Description = "Only target group members",
    Default = Configuration.WhitelistedGroupCheck
})
WhitelistedGroupCheckToggle:OnChanged(function(Value)
    Configuration.WhitelistedGroupCheck = Value
end)

AdvancedChecksSection:AddInput("WhitelistedGroup", {
    Title = "Whitelisted Group ID",
    Description = "Group ID → Enter",
    Numeric = true,
    Finished = true,
    Placeholder = "Group ID",
    Callback = function(Value)
        Configuration.WhitelistedGroup = tonumber(Value) or 0
    end
})

local BlacklistedGroupCheckToggle = AdvancedChecksSection:AddToggle("BlacklistedGroupCheck", {
    Title = "Blacklisted Group Check",
    Description = "Ignore group members",
    Default = Configuration.BlacklistedGroupCheck
})
BlacklistedGroupCheckToggle:OnChanged(function(Value)
    Configuration.BlacklistedGroupCheck = Value
end)

AdvancedChecksSection:AddInput("BlacklistedGroup", {
    Title = "Blacklisted Group ID",
    Description = "Group ID → Enter",
    Numeric = true,
    Finished = true,
    Placeholder = "Group ID",
    Callback = function(Value)
        Configuration.BlacklistedGroup = tonumber(Value) or 0
    end
})

local ExpertChecksSection = Tabs.Checks:AddSection("Expert Checks")

local IgnoredPlayersCheckToggle = ExpertChecksSection:AddToggle("IgnoredPlayersCheck", {
    Title = "Ignored Players Check",
    Description = "Ignore listed players",
    Default = Configuration.IgnoredPlayersCheck
})
IgnoredPlayersCheckToggle:OnChanged(function(Value)
    Configuration.IgnoredPlayersCheck = Value
end)

local IgnoredPlayersDropdown = ExpertChecksSection:AddDropdown("IgnoredPlayers", {
    Title = "Ignored Players",
    Description = "Players to ignore",
    Values = Configuration.IgnoredPlayersDropdownValues,
    Multi = true,
    Default = Configuration.IgnoredPlayers
})
IgnoredPlayersDropdown:OnChanged(function(Value)
    Configuration.IgnoredPlayers = {}
    for k in pairs(Value) do
        if typeof(k) == "string" then table.insert(Configuration.IgnoredPlayers, k) end
    end
end)

ExpertChecksSection:AddInput("AddIgnoredPlayer", {
    Title = "Add Ignored Player",
    Description = "Name / @name / #id → Enter",
    Finished = true,
    Placeholder = "Player Name/ID",
    Callback = function(Value)
        local name = GetPlayerName(Value) or Value
        if #name > 0 and not table.find(Configuration.IgnoredPlayersDropdownValues, name) then
            table.insert(Configuration.IgnoredPlayersDropdownValues, name)
            IgnoredPlayersDropdown:BuildDropdownList()
        end
    end
})

ExpertChecksSection:AddInput("RemoveIgnoredPlayer", {
    Title = "Remove Ignored Player",
    Description = "Name / @name / #id → Enter",
    Finished = true,
    Placeholder = "Player Name/ID",
    Callback = function(Value)
        local name = GetPlayerName(Value) or Value
        if #name > 0 and table.find(Configuration.IgnoredPlayersDropdownValues, name) then
            table.remove(Configuration.IgnoredPlayersDropdownValues, table.find(Configuration.IgnoredPlayersDropdownValues, name))
            IgnoredPlayersDropdown:SetValues(Configuration.IgnoredPlayersDropdownValues)
        end
    end
})

ExpertChecksSection:AddButton({
    Title = "Deselect All",
    Description = "Clear selection",
    Callback = function()
        IgnoredPlayersDropdown:SetValue({})
    end
})

ExpertChecksSection:AddButton({
    Title = "Clear Unselected",
    Description = "Remove unselected players",
    Callback = function()
        local cache = {}
        for _, v in pairs(Configuration.IgnoredPlayersDropdownValues) do
            if table.find(Configuration.IgnoredPlayers, v) then table.insert(cache, v) end
        end
        Configuration.IgnoredPlayersDropdownValues = cache
        IgnoredPlayersDropdown:SetValues(cache)
    end
})

-- Target Players Section (full code - no omission)
local TargetPlayersCheckToggle = ExpertChecksSection:AddToggle("TargetPlayersCheck", {
    Title = "Target Players Check",
    Description = "Only target listed players",
    Default = Configuration.TargetPlayersCheck
})
TargetPlayersCheckToggle:OnChanged(function(Value)
    Configuration.TargetPlayersCheck = Value
end)

local TargetPlayersDropdown = ExpertChecksSection:AddDropdown("TargetPlayers", {
    Title = "Target Players",
    Description = "Players to only target",
    Values = Configuration.TargetPlayersDropdownValues,
    Multi = true,
    Default = Configuration.TargetPlayers
})
TargetPlayersDropdown:OnChanged(function(Value)
    Configuration.TargetPlayers = {}
    for k in pairs(Value) do
        if typeof(k) == "string" then table.insert(Configuration.TargetPlayers, k) end
    end
end)

ExpertChecksSection:AddInput("AddTargetPlayer", {
    Title = "Add Target Player",
    Description = "Name / @name / #id → Enter",
    Finished = true,
    Placeholder = "Player Name/ID",
    Callback = function(Value)
        local name = GetPlayerName(Value) or Value
        if #name > 0 and not table.find(Configuration.TargetPlayersDropdownValues, name) then
            table.insert(Configuration.TargetPlayersDropdownValues, name)
            TargetPlayersDropdown:BuildDropdownList()
        end
    end
})

ExpertChecksSection:AddInput("RemoveTargetPlayer", {
    Title = "Remove Target Player",
    Description = "Name / @name / #id → Enter",
    Finished = true,
    Placeholder = "Player Name/ID",
    Callback = function(Value)
        local name = GetPlayerName(Value) or Value
        if #name > 0 and table.find(Configuration.TargetPlayersDropdownValues, name) then
            table.remove(Configuration.TargetPlayersDropdownValues, table.find(Configuration.TargetPlayersDropdownValues, name))
            TargetPlayersDropdown:SetValues(Configuration.TargetPlayersDropdownValues)
        end
    end
})

ExpertChecksSection:AddButton({
    Title = "Deselect All",
    Description = "Clear selection",
    Callback = function()
        TargetPlayersDropdown:SetValue({})
    end
})

ExpertChecksSection:AddButton({
    Title = "Clear Unselected",
    Description = "Remove unselected players",
    Callback = function()
        local cache = {}
        for _, v in pairs(Configuration.TargetPlayersDropdownValues) do
            if table.find(Configuration.TargetPlayers, v) then table.insert(cache, v) end
        end
        Configuration.TargetPlayersDropdownValues = cache
        TargetPlayersDropdown:SetValues(cache)
    end
})
-- Visuals Tab
Tabs.Visuals:AddParagraph({
    Title = "YazAim Visuals",
    Content = "FoV Circle & ESP features\nMade by Yazaki"
})

local FoVSection = Tabs.Visuals:AddSection("FoV Circle")

local FoVToggle = FoVSection:AddToggle("FoV", {
    Title = "FoV Circle",
    Description = "Show field of view circle",
    Default = Configuration.FoV
})
FoVToggle:OnChanged(function(Value)
    Configuration.FoV = Value
    if not IsComputer then
        ShowingFoV = Value
    end
end)

if IsComputer then
    local FoVKeybind = FoVSection:AddKeybind("FoVKey", {
        Title = "FoV Toggle Key",
        Description = "Key to show/hide FoV",
        Default = Configuration.FoVKey,
        ChangedCallback = function(Value)
            Configuration.FoVKey = Value
        end
    })
    Configuration.FoVKey = FoVKeybind.Value ~= "RMB" and Enum.KeyCode[FoVKeybind.Value] or Enum.UserInputType.MouseButton2
end

FoVSection:AddSlider("FoVThickness", {
    Title = "Thickness",
    Description = "Line thickness of circle",
    Default = Configuration.FoVThickness,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        Configuration.FoVThickness = Value
    end
})

FoVSection:AddSlider("FoVOpacity", {
    Title = "Opacity",
    Description = "Circle transparency",
    Default = Configuration.FoVOpacity,
    Min = 0.1,
    Max = 1,
    Rounding = 0.1,
    Callback = function(Value)
        Configuration.FoVOpacity = Value
    end
})

local FoVFilledToggle = FoVSection:AddToggle("FoVFilled", {
    Title = "Filled Circle",
    Description = "Fill the FoV area",
    Default = Configuration.FoVFilled
})
FoVFilledToggle:OnChanged(function(Value)
    Configuration.FoVFilled = Value
end)

FoVSection:AddColorpicker("FoVColour", {
    Title = "FoV Color",
    Description = "Color of the circle",
    Default = Configuration.FoVColour,
    Callback = function(Value)
        Configuration.FoVColour = Value
    end
})

-- ESP Section
local ESPSection = Tabs.Visuals:AddSection("ESP")

local SmartESPToggle = ESPSection:AddToggle("SmartESP", {
    Title = "Smart ESP",
    Description = "Hide ESP on ignored/whitelisted",
    Default = Configuration.SmartESP
})
SmartESPToggle:OnChanged(function(Value)
    Configuration.SmartESP = Value
end)

if IsComputer then
    local ESPKeybind = ESPSection:AddKeybind("ESPKey", {
        Title = "ESP Toggle Key",
        Description = "Key to show/hide ESP",
        Default = Configuration.ESPKey,
        ChangedCallback = function(Value)
            Configuration.ESPKey = Value
        end
    })
    Configuration.ESPKey = ESPKeybind.Value ~= "RMB" and Enum.KeyCode[ESPKeybind.Value] or Enum.UserInputType.MouseButton2
end

local ESPBoxToggle = ESPSection:AddToggle("ESPBox", {
    Title = "ESP Box",
    Description = "2D box around players",
    Default = Configuration.ESPBox
})
ESPBoxToggle:OnChanged(function(Value)
    Configuration.ESPBox = Value
    if not IsComputer then
        if Value or Configuration.NameESP or Configuration.HealthESP or Configuration.MagnitudeESP or Configuration.TracerESP then
            ShowingESP = true
        else
            ShowingESP = false
        end
    end
end)

local ESPBoxFilledToggle = ESPSection:AddToggle("ESPBoxFilled", {
    Title = "Filled Box",
    Description = "Fill the ESP box",
    Default = Configuration.ESPBoxFilled
})
ESPBoxFilledToggle:OnChanged(function(Value)
    Configuration.ESPBoxFilled = Value
end)

local NameESPToggle = ESPSection:AddToggle("NameESP", {
    Title = "Name ESP",
    Description = "Show player names",
    Default = Configuration.NameESP
})
NameESPToggle:OnChanged(function(Value)
    Configuration.NameESP = Value
    if not IsComputer then
        if Value or Configuration.ESPBox or Configuration.HealthESP or Configuration.MagnitudeESP or Configuration.TracerESP then
            ShowingESP = true
        else
            ShowingESP = false
        end
    end
end)

ESPSection:AddDropdown("NameESPFont", {
    Title = "Name Font",
    Description = "Font style for names",
    Values = {"UI", "System", "Plex", "Monospace"},
    Default = Configuration.NameESPFont,
    Callback = function(Value)
        Configuration.NameESPFont = Value
    end
})

ESPSection:AddSlider("NameESPSize", {
    Title = "Name Size",
    Description = "Text size for names",
    Default = Configuration.NameESPSize,
    Min = 8,
    Max = 28,
    Rounding = 1,
    Callback = function(Value)
        Configuration.NameESPSize = Value
    end
})

ESPSection:AddColorpicker("NameESPOutlineColour", {
    Title = "Name Outline Color",
    Description = "Outline around name text",
    Default = Configuration.NameESPOutlineColour,
    Callback = function(Value)
        Configuration.NameESPOutlineColour = Value
    end
})

local HealthESPToggle = ESPSection:AddToggle("HealthESP", {
    Title = "Health ESP",
    Description = "Show health % in box",
    Default = Configuration.HealthESP
})
HealthESPToggle:OnChanged(function(Value)
    Configuration.HealthESP = Value
    if not IsComputer then
        if Value or Configuration.ESPBox or Configuration.NameESP or Configuration.MagnitudeESP or Configuration.TracerESP then
            ShowingESP = true
        else
            ShowingESP = false
        end
    end
end)

local MagnitudeESPToggle = ESPSection:AddToggle("MagnitudeESP", {
    Title = "Distance ESP",
    Description = "Show distance in studs",
    Default = Configuration.MagnitudeESP
})
MagnitudeESPToggle:OnChanged(function(Value)
    Configuration.MagnitudeESP = Value
    if not IsComputer then
        if Value or Configuration.ESPBox or Configuration.NameESP or Configuration.HealthESP or Configuration.TracerESP then
            ShowingESP = true
        else
            ShowingESP = false
        end
    end
end)

local TracerESPToggle = ESPSection:AddToggle("TracerESP", {
    Title = "Tracer ESP",
    Description = "Lines to players from screen bottom",
    Default = Configuration.TracerESP
})
TracerESPToggle:OnChanged(function(Value)
    Configuration.TracerESP = Value
    if not IsComputer then
        if Value or Configuration.ESPBox or Configuration.NameESP or Configuration.HealthESP or Configuration.MagnitudeESP then
            ShowingESP = true
        else
            ShowingESP = false
        end
    end
end)

ESPSection:AddSlider("ESPThickness", {
    Title = "ESP Thickness",
    Description = "Line/box thickness",
    Default = Configuration.ESPThickness,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        Configuration.ESPThickness = Value
    end
})

ESPSection:AddSlider("ESPOpacity", {
    Title = "ESP Opacity",
    Description = "Transparency of ESP elements",
    Default = Configuration.ESPOpacity,
    Min = 0.1,
    Max = 1,
    Rounding = 0.1,
    Callback = function(Value)
        Configuration.ESPOpacity = Value
    end
})

ESPSection:AddColorpicker("ESPColour", {
    Title = "ESP Color",
    Description = "Default color for ESP",
    Default = Configuration.ESPColour,
    Callback = function(Value)
        Configuration.ESPColour = Value
    end
})

local ESPUseTeamColourToggle = ESPSection:AddToggle("ESPUseTeamColour", {
    Title = "Use Team Color",
    Description = "ESP matches player team color",
    Default = Configuration.ESPUseTeamColour
})
ESPUseTeamColourToggle:OnChanged(function(Value)
    Configuration.ESPUseTeamColour = Value
end)

local VisualsSection = Tabs.Visuals:AddSection("Visual Effects")

local RainbowVisualsToggle = VisualsSection:AddToggle("RainbowVisuals", {
    Title = "Rainbow Visuals",
    Description = "Cycle colors on FoV/ESP",
    Default = Configuration.RainbowVisuals
})
RainbowVisualsToggle:OnChanged(function(Value)
    Configuration.RainbowVisuals = Value
end)

VisualsSection:AddSlider("RainbowDelay", {
    Title = "Rainbow Speed",
    Description = "Color cycle speed (seconds)",
    Default = Configuration.RainbowDelay,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        Configuration.RainbowDelay = Value
    end
})

-- Settings Tab
Tabs.Settings:AddParagraph({
    Title = "YazAim Settings",
    Content = "UI, performance & config options\nMade by Yazaki"
})

local UISection = Tabs.Settings:AddSection("UI")

UISection:AddDropdown("Theme", {
    Title = "Theme",
    Description = "Change UI appearance",
    Values = Fluent.Themes,
    Default = Fluent.Theme,
    Callback = function(Value)
        Fluent:SetTheme(Value)
        UISettings.Theme = Value
        InterfaceManager:ExportSettings()
    end
})

if Fluent.UseAcrylic then
    UISection:AddToggle("Acrylic", {
        Title = "Acrylic Blur",
        Description = "Blurred background (needs high graphics)",
        Default = Fluent.Acrylic,
        Callback = function(Value)
            if not Value or not UISettings.ShowWarnings then
                Fluent:ToggleAcrylic(Value)
            elseif UISettings.ShowWarnings then
                Window:Dialog({
                    Title = "Warning",
                    Content = "Acrylic can be detected in some games. Enable anyway?",
                    Buttons = {
                        {Title = "Yes", Callback = function() Fluent:ToggleAcrylic(Value) end},
                        {Title = "No", Callback = function() Fluent.Options.Acrylic:SetValue(false) end}
                    }
                })
            end
        end
    })
end

UISection:AddToggle("Transparency", {
    Title = "UI Transparency",
    Description = "Make UI semi-transparent",
    Default = UISettings.Transparency,
    Callback = function(Value)
        Fluent:ToggleTransparency(Value)
        UISettings.Transparency = Value
        InterfaceManager:ExportSettings()
    end
})

if IsComputer then
    UISection:AddKeybind("MinimizeKey", {
        Title = "Minimize Key",
        Description = "Key to hide/show UI",
        Default = Fluent.MinimizeKey,
        ChangedCallback = function()
            UISettings.MinimizeKey = Fluent.Options.MinimizeKey.Value
            InterfaceManager:ExportSettings()
        end
    })
    Fluent.MinimizeKeybind = Fluent.Options.MinimizeKey
end

local NotificationsWarningsSection = Tabs.Settings:AddSection("Notifications & Warnings")

local NotificationsToggle = NotificationsWarningsSection:AddToggle("ShowNotifications", {
    Title = "Show Notifications",
    Description = "Enable pop-up messages",
    Default = UISettings.ShowNotifications
})
NotificationsToggle:OnChanged(function(Value)
    Fluent.ShowNotifications = Value
    UISettings.ShowNotifications = Value
    InterfaceManager:ExportSettings()
end)

local WarningsToggle = NotificationsWarningsSection:AddToggle("ShowWarnings", {
    Title = "Show Warnings",
    Description = "Show security/feature warnings",
    Default = UISettings.ShowWarnings
})
WarningsToggle:OnChanged(function(Value)
    UISettings.ShowWarnings = Value
    InterfaceManager:ExportSettings()
end)

local PerformanceSection = Tabs.Settings:AddSection("Performance")

PerformanceSection:AddParagraph({
    Title = "Rendering Mode Info",
    Content = "Heartbeat: After physics\nRenderStepped: Before render\nStepped: Before physics"
})

PerformanceSection:AddDropdown("RenderingMode", {
    Title = "Rendering Mode",
    Description = "Affects performance & accuracy",
    Values = {"Heartbeat", "RenderStepped", "Stepped"},
    Default = UISettings.RenderingMode,
    Callback = function(Value)
        UISettings.RenderingMode = Value
        InterfaceManager:ExportSettings()
        Fluent:Notify({
            Title = "YazAim",
            Content = "Restart required for mode change!",
            Duration = 5
        })
    end
})
-- Visuals Tab
Tabs.Visuals:AddParagraph({
    Title = "YazAim Visuals",
    Content = "FoV Circle & Full ESP Suite\nMade by Yazaki"
})

local FoVSection = Tabs.Visuals:AddSection("FoV Circle")

local FoVToggle = FoVSection:AddToggle("FoV", {
    Title = "FoV Circle",
    Description = "Display the aim field of view circle",
    Default = Configuration.FoV
})
FoVToggle:OnChanged(function(Value)
    Configuration.FoV = Value
    if not IsComputer then
        ShowingFoV = Value
    end
end)

if IsComputer then
    local FoVKeybind = FoVSection:AddKeybind("FoVKey", {
        Title = "FoV Toggle Key",
        Description = "Toggle visibility of FoV circle",
        Default = Configuration.FoVKey,
        ChangedCallback = function(Value)
            Configuration.FoVKey = Value
        end
    })
    Configuration.FoVKey = FoVKeybind.Value ~= "RMB" and Enum.KeyCode[FoVKeybind.Value] or Enum.UserInputType.MouseButton2
end

FoVSection:AddSlider("FoVThickness", {
    Title = "Thickness",
    Description = "Line thickness of the circle",
    Default = Configuration.FoVThickness,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        Configuration.FoVThickness = Value
    end
})

FoVSection:AddSlider("FoVOpacity", {
    Title = "Opacity",
    Description = "Transparency level of the circle",
    Default = Configuration.FoVOpacity,
    Min = 0.1,
    Max = 1,
    Rounding = 0.1,
    Callback = function(Value)
        Configuration.FoVOpacity = Value
    end
})

local FoVFilledToggle = FoVSection:AddToggle("FoVFilled", {
    Title = "Filled Circle",
    Description = "Fill the inside of the FoV circle",
    Default = Configuration.FoVFilled
})
FoVFilledToggle:OnChanged(function(Value)
    Configuration.FoVFilled = Value
end)

FoVSection:AddColorpicker("FoVColour", {
    Title = "FoV Color",
    Description = "Color of the FoV circle",
    Default = Configuration.FoVColour,
    Callback = function(Value)
        Configuration.FoVColour = Value
    end
})

-- ESP Section (full)
local ESPSection = Tabs.Visuals:AddSection("ESP")

local SmartESPToggle = ESPSection:AddToggle("SmartESP", {
    Title = "Smart ESP",
    Description = "Hide ESP on whitelisted/ignored players",
    Default = Configuration.SmartESP
})
SmartESPToggle:OnChanged(function(Value)
    Configuration.SmartESP = Value
end)

if IsComputer then
    local ESPKeybind = ESPSection:AddKeybind("ESPKey", {
        Title = "ESP Toggle Key",
        Description = "Key to toggle all ESP visibility",
        Default = Configuration.ESPKey,
        ChangedCallback = function(Value)
            Configuration.ESPKey = Value
        end
    })
    Configuration.ESPKey = ESPKeybind.Value ~= "RMB" and Enum.KeyCode[ESPKeybind.Value] or Enum.UserInputType.MouseButton2
end

local ESPBoxToggle = ESPSection:AddToggle("ESPBox", {
    Title = "Box ESP",
    Description = "Draw 2D box around players",
    Default = Configuration.ESPBox
})
ESPBoxToggle:OnChanged(function(Value)
    Configuration.ESPBox = Value
    if not IsComputer then
        ShowingESP = Value or Configuration.NameESP or Configuration.HealthESP or Configuration.MagnitudeESP or Configuration.TracerESP
    end
end)

local ESPBoxFilledToggle = ESPSection:AddToggle("ESPBoxFilled", {
    Title = "Filled Box",
    Description = "Fill the ESP box with color",
    Default = Configuration.ESPBoxFilled
})
ESPBoxFilledToggle:OnChanged(function(Value)
    Configuration.ESPBoxFilled = Value
end)

local NameESPToggle = ESPSection:AddToggle("NameESP", {
    Title = "Name ESP",
    Description = "Display player names above head",
    Default = Configuration.NameESP
})
NameESPToggle:OnChanged(function(Value)
    Configuration.NameESP = Value
    if not IsComputer then
        ShowingESP = Value or Configuration.ESPBox or Configuration.HealthESP or Configuration.MagnitudeESP or Configuration.TracerESP
    end
end)

ESPSection:AddDropdown("NameESPFont", {
    Title = "Name Font",
    Description = "Font style for name text",
    Values = {"UI", "System", "Plex", "Monospace"},
    Default = Configuration.NameESPFont,
    Callback = function(Value)
        Configuration.NameESPFont = Value
    end
})

ESPSection:AddSlider("NameESPSize", {
    Title = "Name Size",
    Description = "Text size for names",
    Default = Configuration.NameESPSize,
    Min = 8,
    Max = 28,
    Rounding = 1,
    Callback = function(Value)
        Configuration.NameESPSize = Value
    end
})

ESPSection:AddColorpicker("NameESPOutlineColour", {
    Title = "Name Outline Color",
    Description = "Outline around name text for visibility",
    Default = Configuration.NameESPOutlineColour,
    Callback = function(Value)
        Configuration.NameESPOutlineColour = Value
    end
})

local HealthESPToggle = ESPSection:AddToggle("HealthESP", {
    Title = "Health ESP",
    Description = "Show health percentage",
    Default = Configuration.HealthESP
})
HealthESPToggle:OnChanged(function(Value)
    Configuration.HealthESP = Value
    if not IsComputer then
        ShowingESP = Value or Configuration.ESPBox or Configuration.NameESP or Configuration.MagnitudeESP or Configuration.TracerESP
    end
end)

local MagnitudeESPToggle = ESPSection:AddToggle("MagnitudeESP", {
    Title = "Distance ESP",
    Description = "Show distance in studs",
    Default = Configuration.MagnitudeESP
})
MagnitudeESPToggle:OnChanged(function(Value)
    Configuration.MagnitudeESP = Value
    if not IsComputer then
        ShowingESP = Value or Configuration.ESPBox or Configuration.NameESP or Configuration.HealthESP or Configuration.TracerESP
    end
end)

local TracerESPToggle = ESPSection:AddToggle("TracerESP", {
    Title = "Tracer Lines",
    Description = "Draw lines from screen bottom to players",
    Default = Configuration.TracerESP
})
TracerESPToggle:OnChanged(function(Value)
    Configuration.TracerESP = Value
    if not IsComputer then
        ShowingESP = Value or Configuration.ESPBox or Configuration.NameESP or Configuration.HealthESP or Configuration.MagnitudeESP
    end
end)

ESPSection:AddSlider("ESPThickness", {
    Title = "ESP Thickness",
    Description = "Line and box thickness",
    Default = Configuration.ESPThickness,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        Configuration.ESPThickness = Value
    end
})

ESPSection:AddSlider("ESPOpacity", {
    Title = "ESP Opacity",
    Description = "Transparency of ESP elements",
    Default = Configuration.ESPOpacity,
    Min = 0.1,
    Max = 1,
    Rounding = 0.1,
    Callback = function(Value)
        Configuration.ESPOpacity = Value
    end
})

ESPSection:AddColorpicker("ESPColour", {
    Title = "ESP Color",
    Description = "Default color for all ESP",
    Default = Configuration.ESPColour,
    Callback = function(Value)
        Configuration.ESPColour = Value
    end
})

local ESPUseTeamColourToggle = ESPSection:AddToggle("ESPUseTeamColour", {
    Title = "Team Colors",
    Description = "Use player team color for ESP",
    Default = Configuration.ESPUseTeamColour
})
ESPUseTeamColourToggle:OnChanged(function(Value)
    Configuration.ESPUseTeamColour = Value
end)

local VisualsSection = Tabs.Visuals:AddSection("Extra Visuals")

local RainbowVisualsToggle = VisualsSection:AddToggle("RainbowVisuals", {
    Title = "Rainbow Mode",
    Description = "Cycle colors through rainbow",
    Default = Configuration.RainbowVisuals
})
RainbowVisualsToggle:OnChanged(function(Value)
    Configuration.RainbowVisuals = Value
end)

VisualsSection:AddSlider("RainbowDelay", {
    Title = "Rainbow Speed",
    Description = "How fast colors cycle (seconds)",
    Default = Configuration.RainbowDelay,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        Configuration.RainbowDelay = Value
    end
})

-- Settings Tab
Tabs.Settings:AddParagraph({
    Title = "YazAim Settings",
    Content = "Customize UI, performance, and config saving\nMade by Yazaki"
})

local UISection = Tabs.Settings:AddSection("UI Appearance")

UISection:AddDropdown("Theme", {
    Title = "UI Theme",
    Description = "Change color scheme",
    Values = Fluent.Themes,
    Default = Fluent.Theme,
    Callback = function(Value)
        Fluent:SetTheme(Value)
        UISettings.Theme = Value
        InterfaceManager:ExportSettings()
    end
})

if Fluent.UseAcrylic then
    UISection:AddToggle("Acrylic", {
        Title = "Acrylic Blur",
        Description = "Enable blurred background (high graphics required)",
        Default = Fluent.Acrylic,
        Callback = function(Value)
            if not Value or not UISettings.ShowWarnings then
                Fluent:ToggleAcrylic(Value)
            elseif UISettings.ShowWarnings then
                Window:Dialog({
                    Title = "Warning",
                    Content = "Acrylic blur may be detectable in some games. Enable anyway?",
                    Buttons = {
                        {Title = "Yes", Callback = function() Fluent:ToggleAcrylic(Value) end},
                        {Title = "No", Callback = function() Fluent.Options.Acrylic:SetValue(false) end}
                    }
                })
            end
        end
    })
end

UISection:AddToggle("Transparency", {
    Title = "UI Transparency",
    Description = "Make the UI semi-transparent",
    Default = UISettings.Transparency,
    Callback = function(Value)
        Fluent:ToggleTransparency(Value)
        UISettings.Transparency = Value
        InterfaceManager:ExportSettings()
    end
})

if IsComputer then
    UISection:AddKeybind("MinimizeKey", {
        Title = "Minimize Key",
        Description = "Key to hide/show the UI window",
        Default = Fluent.MinimizeKey,
        ChangedCallback = function()
            UISettings.MinimizeKey = Fluent.Options.MinimizeKey.Value
            InterfaceManager:ExportSettings()
        end
    })
    Fluent.MinimizeKeybind = Fluent.Options.MinimizeKey
end

local NotificationsWarningsSection = Tabs.Settings:AddSection("Notifications & Warnings")

local NotificationsToggle = NotificationsWarningsSection:AddToggle("ShowNotifications", {
    Title = "Enable Notifications",
    Description = "Show pop-up messages",
    Default = UISettings.ShowNotifications
})
NotificationsToggle:OnChanged(function(Value)
    Fluent.ShowNotifications = Value
    UISettings.ShowNotifications = Value
    InterfaceManager:ExportSettings()
end)

local WarningsToggle = NotificationsWarningsSection:AddToggle("ShowWarnings", {
    Title = "Show Security Warnings",
    Description = "Display warnings for risky features",
    Default = UISettings.ShowWarnings
})
WarningsToggle:OnChanged(function(Value)
    UISettings.ShowWarnings = Value
    InterfaceManager:ExportSettings()
end)

local PerformanceSection = Tabs.Settings:AddSection("Performance")

PerformanceSection:AddParagraph({
    Title = "Rendering Mode Info",
    Content = "Heartbeat: After physics (good for bots)\nRenderStepped: Before render (smooth visuals)\nStepped: Before physics (balanced)"
})

PerformanceSection:AddDropdown("RenderingMode", {
    Title = "Rendering Mode",
    Description = "Changes update timing - restart required",
    Values = {"Heartbeat", "RenderStepped", "Stepped"},
    Default = UISettings.RenderingMode,
    Callback = function(Value)
        UISettings.RenderingMode = Value
        InterfaceManager:ExportSettings()
        Fluent:Notify({
            Title = "YazAim",
            Content = "Rendering mode changed - restart the script for it to take effect!",
            Duration = 5
        })
    end
})

-- Configuration Manager Section (if file system supported)
if isfile and readfile and writefile and delfile then
    local ConfigManagerSection = Tabs.Settings:AddSection("Configuration Manager")

    local AutoImportToggle = ConfigManagerSection:AddToggle("AutoImport", {
        Title = "Auto Import Config",
        Description = "Load game config on join",
        Default = UISettings.AutoImport
    })
    AutoImportToggle:OnChanged(function(Value)
        UISettings.AutoImport = Value
        InterfaceManager:ExportSettings()
    end)

    ConfigManagerSection:AddParagraph({
        Title = "Current Game",
        Content = "Place ID: " .. game.GameId .. "\nConfig file: " .. game.GameId .. ".json"
    })

    ConfigManagerSection:AddButton({
        Title = "Import Config",
        Description = "Load saved config for this game",
        Callback = function()
            pcall(function()
                if isfile(game.GameId .. ".json") then
                    local data = HttpService:JSONDecode(readfile(game.GameId .. ".json"))
                    for k, v in pairs(data) do
                        if Configuration[k] ~= nil then
                            if k:match("Key$") then
                                Fluent.Options[k]:SetValue(v)
                                Configuration[k] = v ~= "RMB" and Enum.KeyCode[v] or Enum.UserInputType.MouseButton2
                            elseif typeof(Configuration[k]) == "table" then
                                Configuration[k] = v
                            elseif k:match("Colour$") then
                                Fluent.Options[k]:SetValueRGB(ColorsHandler:UnpackColour(v))
                            else
                                Fluent.Options[k]:SetValue(v)
                            end
                        end
                    end
                    Fluent:Notify({Title = "YazAim", Content = "Config imported successfully!", Duration = 4})
                else
                    Fluent:Notify({Title = "YazAim", Content = "No config file found for this game.", Duration = 4})
                end
            end)
        end
    })

    ConfigManagerSection:AddButton({
        Title = "Export Config",
        Description = "Save current settings for this game",
        Callback = function()
            pcall(function()
                local exportData = {__LAST_UPDATED__ = os.date()}
                for k, v in pairs(Configuration) do
                    if k:match("Key$") then
                        exportData[k] = Fluent.Options[k].Value
                    elseif k:match("Colour$") then
                        exportData[k] = ColorsHandler:PackColour(v)
                    else
                        exportData[k] = v
                    end
                end
                writefile(game.GameId .. ".json", HttpService:JSONEncode(exportData))
                Fluent:Notify({Title = "YazAim", Content = "Config exported successfully!", Duration = 4})
            end)
        end
    })

    ConfigManagerSection:AddButton({
        Title = "Delete Config",
        Description = "Remove saved config for this game",
        Callback = function()
            if isfile(game.GameId .. ".json") then
                delfile(game.GameId .. ".json")
                Fluent:Notify({Title = "YazAim", Content = "Config deleted.", Duration = 4})
            else
                Fluent:Notify({Title = "YazAim", Content = "No config to delete.", Duration = 4})
            end
        end
    })
end
-- Notifications Handler
local function Notify(Message)
    if Fluent then
        Fluent:Notify({
            Title = "YazAim",
            Content = Message,
            SubContent = "by Yazaki",
            Duration = 3
        })
    end
end

Notify("YazAim Loaded – Enjoy the features!")

-- Player Name Helper (GetPlayerName from string)
local function GetPlayerName(String)
    if typeof(String) == "string" and #String > 0 then
        for _, _Player in pairs(Players:GetPlayers()) do
            if string.lower(_Player.Name):sub(1, #String:lower()) == String:lower() then
                return _Player.Name
            end
        end
    end
    return ""
end

-- Fields Handler (reset aim/spin/trigger/ESP)
local Status = ""
local Fluent = nil
local ShowWarning = false
local RobloxActive = true
local Clock = os.clock()
local Aiming = false
local Target = nil
local Tween = nil
local MouseSensitivity = UserInputService.MouseDeltaSensitivity
local Spinning = false
local Triggering = false
local ShowingFoV = false
local ShowingESP = false

local FieldsHandler = {}
function FieldsHandler:ResetAimbotFields(SaveAiming, SaveTarget)
    Aiming = SaveAiming and Aiming or false
    Target = SaveTarget and Target or nil
    if Tween then Tween:Cancel() Tween = nil end
    UserInputService.MouseDeltaSensitivity = MouseSensitivity
end

function FieldsHandler:ResetSecondaryFields()
    Spinning = false
    Triggering = false
    ShowingFoV = false
    ShowingESP = false
end

-- Input Handler (key/mouse events for toggles)
do
    if IsComputer then
        local InputBegan = UserInputService.InputBegan:Connect(function(Input)
            if not Fluent then return InputBegan:Disconnect() end
            if not UserInputService:GetFocusedTextBox() then
                if Configuration.Aimbot and (Input.KeyCode == Configuration.AimKey or Input.UserInputType == Configuration.AimKey) then
                    Aiming = not Aiming
                    Notify(Aiming and "[Aimbot]: ON" or "[Aimbot]: OFF")
                elseif Configuration.SpinBot and (Input.KeyCode == Configuration.SpinKey or Input.UserInputType == Configuration.SpinKey) then
                    Spinning = not Spinning
                    Notify(Spinning and "[SpinBot]: ON" or "[SpinBot]: OFF")
                elseif mouse1click and Configuration.TriggerBot and (Input.KeyCode == Configuration.TriggerKey or Input.UserInputType == Configuration.TriggerKey) then
                    Triggering = not Triggering
                    Notify(Triggering and "[TriggerBot]: ON" or "[TriggerBot]: OFF")
                elseif Drawing and Drawing.new and Configuration.FoV and (Input.KeyCode == Configuration.FoVKey or Input.UserInputType == Configuration.FoVKey) then
                    ShowingFoV = not ShowingFoV
                    Notify(ShowingFoV and "[FoV Circle]: ON" or "[FoV Circle]: OFF")
                elseif Drawing and Drawing.new and (Configuration.ESPBox or Configuration.NameESP or Configuration.HealthESP or Configuration.MagnitudeESP or Configuration.TracerESP) and (Input.KeyCode == Configuration.ESPKey or Input.UserInputType == Configuration.ESPKey) then
                    ShowingESP = not ShowingESP
                    Notify(ShowingESP and "[ESP]: ON" or "[ESP]: OFF")
                end
            end
        end)

        local InputEnded = UserInputService.InputEnded:Connect(function(Input)
            if not Fluent then return InputEnded:Disconnect() end
            if not UserInputService:GetFocusedTextBox() then
                if Aiming and not Configuration.OnePressAimingMode and (Input.KeyCode == Configuration.AimKey or Input.UserInputType == Configuration.AimKey) then
                    FieldsHandler:ResetAimbotFields()
                    Notify("[Aimbot]: OFF")
                elseif Spinning and not Configuration.OnePressSpinningMode and (Input.KeyCode == Configuration.SpinKey or Input.UserInputType == Configuration.SpinKey) then
                    Spinning = false
                    Notify("[SpinBot]: OFF")
                elseif Triggering and not Configuration.OnePressTriggeringMode and (Input.KeyCode == Configuration.TriggerKey or Input.UserInputType == Configuration.TriggerKey) then
                    Triggering = false
                    Notify("[TriggerBot]: OFF")
                end
            end
        end)

        local WindowFocused = UserInputService.WindowFocused:Connect(function()
            if not Fluent then return WindowFocused:Disconnect() end
            RobloxActive = true
        end)

        local WindowFocusReleased = UserInputService.WindowFocusReleased:Connect(function()
            if not Fluent then return WindowFocusReleased:Disconnect() end
            RobloxActive = false
        end)
    end
end

-- Math Handler (direction, chance, abbreviate)
local MathHandler = {}
function MathHandler:CalculateDirection(Origin, Position, Magnitude)
    return typeof(Origin) == "Vector3" and typeof(Position) == "Vector3" and typeof(Magnitude) == "number" and (Position - Origin).Unit * Magnitude or Vector3.zero
end

function MathHandler:CalculateChance(Percentage)
    return typeof(Percentage) == "number" and math.random(1, 100) <= math.clamp(Percentage, 1, 100) or false
end

function MathHandler:Abbreviate(Number)
    if typeof(Number) == "number" then
        local abbrevs = {"K", "M", "B", "T", "Qd", "Qn", "Sx", "Sp", "O", "N", "D"}
        local div = 1000
        local i = 1
        while Number >= div and i <= #abbrevs do
            Number = Number / div
            i = i + 1
        end
        return i > 1 and string.format("%.2f%s", Number, abbrevs[i-1]) or tostring(Number)
    end
    return tostring(Number)
end

-- Targets Handler (IsReady check for valid target)
local function IsReady(Target)
    if Target and Target:FindFirstChildOfClass("Humanoid") and Configuration.AimPart and Target:FindFirstChild(Configuration.AimPart) and Target:FindFirstChild(Configuration.AimPart).IsA(Target:FindFirstChild(Configuration.AimPart), "BasePart") and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") and Player.Character:FindFirstChild(Configuration.AimPart) and Player.Character:FindFirstChild(Configuration.AimPart).IsA(Player.Character:FindFirstChild(Configuration.AimPart), "BasePart") then
        local _Player = Players:GetPlayerFromCharacter(Target)
        if not _Player or _Player == Player then return false end
        local Humanoid = Target:FindFirstChildOfClass("Humanoid")
        local Head = Target:FindFirstChild("Head")
        local TargetPart = Target:FindFirstChild(Configuration.AimPart)
        local NativePart = Player.Character:FindFirstChild(Configuration.AimPart)
        if Configuration.AliveCheck and Humanoid.Health == 0 or Configuration.GodCheck and (Humanoid.Health >= math.huge or Target:FindFirstChildOfClass("ForceField")) then return false end
        if Configuration.TeamCheck and _Player.TeamColor == Player.TeamColor or Configuration.FriendCheck and _Player:IsFriendsWith(Player.UserId) then return false end
        if Configuration.FollowCheck and _Player.FollowUserId == Player.UserId or Configuration.VerifiedBadgeCheck and _Player.HasVerifiedBadge then return false end
        if Configuration.WallCheck then
            local dir = MathHandler:CalculateDirection(NativePart.Position, TargetPart.Position, (TargetPart.Position - NativePart.Position).Magnitude)
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {Player.Character}
            params.IgnoreWater = not Configuration.WaterCheck
            local result = workspace:Raycast(NativePart.Position, dir, params)
            if not result or not result.Instance or not result.Instance:FindFirstAncestor(_Player.Name) then return false end
        end
        if Configuration.MagnitudeCheck and (TargetPart.Position - NativePart.Position).Magnitude > Configuration.TriggerMagnitude then return false end
        if Configuration.TransparencyCheck and Head and Head.IsA(Head, "BasePart") and Head.Transparency >= Configuration.IgnoredTransparency then return false end
        if Configuration.WhitelistedGroupCheck and _Player:IsInGroup(Configuration.WhitelistedGroup) or Configuration.BlacklistedGroupCheck and not _Player:IsInGroup(Configuration.BlacklistedGroup) then return false end
        if Configuration.IgnoredPlayersCheck and table.find(Configuration.IgnoredPlayers, _Player.Name) or Configuration.TargetPlayersCheck and not table.find(Configuration.TargetPlayers, _Player.Name) then return false end
        local offset = Configuration.UseOffset and (Configuration.AutoOffset and Vector3.new(0, math.min(TargetPart.Position.Y * Configuration.StaticOffsetIncrement * (TargetPart.Position - NativePart.Position).Magnitude / 1000, Configuration.MaxAutoOffset), 0) or Vector3.new(0, TargetPart.Position.Y * Configuration.StaticOffsetIncrement / 10, 0) + Humanoid.MoveDirection * Configuration.DynamicOffsetIncrement / 10 or Vector3.zero)
        local noise = Configuration.UseNoise and Vector3.new(math.random(-Configuration.NoiseFrequency, Configuration.NoiseFrequency)/100, math.random(-Configuration.NoiseFrequency, Configuration.NoiseFrequency)/100, math.random(-Configuration.NoiseFrequency, Configuration.NoiseFrequency)/100) or Vector3.zero
        local viewport = workspace.CurrentCamera:WorldToViewportPoint(TargetPart.Position + offset + noise)
        return true, Target, {viewport}, TargetPart.Position + offset + noise, (TargetPart.Position + offset + noise - NativePart.Position).Magnitude, CFrame.new(TargetPart.Position + offset + noise), TargetPart
    end
    return false
end

-- Silent Aim Handler (metamethod hooks)
do
    if hookmetamethod and newcclosure and checkcaller and getnamecallmethod then
        local OldIndex = hookmetamethod(game, "__index", newcclosure(function(self, Index)
            if Fluent and not checkcaller() and Configuration.AimMode == "Silent" and table.find(Configuration.SilentAimMethods, "Mouse.Hit / Mouse.Target") and Aiming and IsReady(Target) and MathHandler:CalculateChance(Configuration.SilentAimChance) and self == Mouse then
                if Index == "Hit" or Index == "hit" then return select(6, IsReady(Target)) end
                if Index == "Target" or Index == "target" then return select(7, IsReady(Target)) end
                if Index == "X" or Index == "x" then return select(3, IsReady(Target))[1].X end
                if Index == "Y" or Index == "y" then return select(3, IsReady(Target))[1].Y end
                if Index == "UnitRay" or Index == "unitRay" then return Ray.new(self.Origin, (select(6, IsReady(Target)) - self.Origin).Unit) end
            end
            return OldIndex(self, Index)
        end))

        local OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(...)
            local Method = getnamecallmethod()
            local Args = {...}
            local self = Args[1]
            if Fluent and not checkcaller() and Configuration.AimMode == "Silent" and Aiming and IsReady(Target) and MathHandler:CalculateChance(Configuration.SilentAimChance) then
                if table.find(Configuration.SilentAimMethods, "GetMouseLocation") and self == UserInputService and Method:match("GetMouseLocation") then
                    local viewport = select(3, IsReady(Target))[1]
                    return Vector2.new(viewport.X, viewport.Y)
                elseif table.find(Configuration.SilentAimMethods, "Raycast") and self == workspace and Method:match("Raycast") and ValidateArguments(Args, ValidArguments.Raycast) then
                    Args[3] = MathHandler:CalculateDirection(Args[2], select(4, IsReady(Target)), select(5, IsReady(Target)))
                    return OldNameCall(unpack(Args))
                -- (similar for FindPartOnRay, FindPartOnRayWithIgnoreList, FindPartOnRayWithWhitelist - add if needed from original)
            end
            return OldNameCall(...)
        end))
    end
end

-- Bots Handler (spin, trigger)
local function HandleBots()
    if Spinning and Configuration.SpinPart and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") and Player.Character:FindFirstChild(Configuration.SpinPart) and Player.Character:FindFirstChild(Configuration.SpinPart):IsA("BasePart") then
        local spinPart = Player.Character:FindFirstChild(Configuration.SpinPart)
        spinPart.CFrame = spinPart.CFrame * CFrame.Angles(0, math.rad(Configuration.SpinBotVelocity), 0)
    end
    if mouse1click and IsComputer and Triggering and (Configuration.SmartTriggerBot and Aiming or not Configuration.SmartTriggerBot) and Mouse.Target and IsReady(Mouse.Target:FindFirstAncestorOfClass("Model")) and MathHandler:CalculateChance(Configuration.TriggerBotChance) then
        mouse1click()
    end
end

-- Random Parts Handler (random aim/spin part switch)
local function HandleRandomParts()
    if Clock + 1 <= tick() then
        if Configuration.RandomAimPart and #Configuration.AimPartDropdownValues > 0 then
            Configuration.AimPart = Configuration.AimPartDropdownValues[math.random(1, #Configuration.AimPartDropdownValues)]
        end
        if Configuration.RandomSpinPart and #Configuration.SpinPartDropdownValues > 0 then
            Configuration.SpinPart = Configuration.SpinPartDropdownValues[math.random(1, #Configuration.SpinPartDropdownValues)]
        end
        Clock = tick()
    end
end

-- Visuals Handler (FoV visualize, rainbow, clear visuals)
local VisualsHandler = {}
function VisualsHandler:Visualize(Object)
    if Drawing and Drawing.new and typeof(Object) == "string" then
        local drawing = Drawing.new(Object:match("Circle") and "Circle" or "Square" or "Text" or "Line")
        drawing.Visible = false
        drawing.Transparency = 0.8
        drawing.Color = Color3.fromRGB(0, 255, 150)
        return drawing
    end
end

local Visuals = {FoV = VisualsHandler:Visualize("Circle")}

function VisualsHandler:ClearVisual(Visual, Key)
    if Visual then Visual:Remove() end
    if Key then Visuals[Key] = nil end
end

function VisualsHandler:ClearVisuals()
    for k, v in pairs(Visuals) do
        self:ClearVisual(v, k)
    end
end

function VisualsHandler:VisualizeFoV()
    local mouseLoc = UserInputService:GetMouseLocation()
    Visuals.FoV.Position = Vector2.new(mouseLoc.X, mouseLoc.Y)
    Visuals.FoV.Radius = Configuration.FoVRadius
    Visuals.FoV.Thickness = Configuration.FoVThickness
    Visuals.FoV.Transparency = Configuration.FoVOpacity
    Visuals.FoV.Filled = Configuration.FoVFilled
    Visuals.FoV.Color = Configuration.FoVColour
    Visuals.FoV.Visible = ShowingFoV
end

function VisualsHandler:RainbowVisuals()
    if Configuration.RainbowVisuals then
        local hue = tick() % Configuration.RainbowDelay / Configuration.RainbowDelay
        Configuration.FoVColour = Color3.fromHSV(hue, 1, 1)
        Configuration.ESPColour = Color3.fromHSV(hue, 1, 1)
    end
end

-- ESP Library (init/visualize/disconnect for players)
local ESPLibrary = {}
function ESPLibrary:Initialize(_Character)
    if not Drawing or not Drawing.new then return end
    local self = setmetatable({}, ESPLibrary)
    self.Player = Players:GetPlayerFromCharacter(_Character)
    self.Character = _Character
    self.ESPBox = VisualsHandler:Visualize("Square")
    self.NameESP = VisualsHandler:Visualize("Text")
    self.HealthESP = VisualsHandler:Visualize("Text")
    self.MagnitudeESP = VisualsHandler:Visualize("Text")
    self.TracerESP = VisualsHandler:Visualize("Line")
    return self
end

function ESPLibrary:Visualize()
    if not self.Character then return self:Disconnect() end
    local head = self.Character:FindFirstChild("Head")
    local root = self.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = self.Character:FindFirstChildOfClass("Humanoid")
    if head and root and humanoid then
        local isReady = Configuration.SmartESP and IsReady(self.Character) or true
        local rootPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)
        if onScreen then
            local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
            local top = workspace.CurrentCamera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local bottom = workspace.CurrentCamera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
            self.ESPBox.Size = Vector2.new(2350 / rootPos.Z, top.Y - bottom.Y)
            self.ESPBox.Position = Vector2.new(rootPos.X - self.ESPBox.Size.X / 2, rootPos.Y - self.ESPBox.Size.Y / 2)
            self.ESPBox.Filled = Configuration.ESPBoxFilled
            self.ESPBox.Color = Configuration.ESPColour
            self.ESPBox.Transparency = Configuration.ESPOpacity
            self.ESPBox.Thickness = Configuration.ESPThickness
            self.ESPBox.Visible = ShowingESP and Configuration.ESPBox and isReady
            self.NameESP.Text = self.Player.Name
            self.NameESP.Position = Vector2.new(rootPos.X, rootPos.Y - self.ESPBox.Size.Y / 2 - self.NameESP.TextBounds.Y)
            self.NameESP.Color = Configuration.ESPColour
            self.NameESP.Transparency = Configuration.ESPOpacity
            self.NameESP.Visible = ShowingESP and Configuration.NameESP and isReady
            self.HealthESP.Text = math.floor(humanoid.Health) .. "/" .. humanoid.MaxHealth
            self.HealthESP.Position = Vector2.new(rootPos.X - self.ESPBox.Size.X / 2 - self.HealthESP.TextBounds.X - 5, rootPos.Y - self.ESPBox.Size.Y / 2)
            self.HealthESP.Color = Configuration.ESPColour
            self.HealthESP.Transparency = Configuration.ESPOpacity
            self.HealthESP.Visible = ShowingESP and Configuration.HealthESP and isReady
            self.MagnitudeESP.Text = math.floor((Player.Character.Head.Position - head.Position).Magnitude) .. " studs"
            self.MagnitudeESP.Position = Vector2.new(rootPos.X, rootPos.Y + self.ESPBox.Size.Y / 2)
            self.MagnitudeESP.Color = Configuration.ESPColour
            self.MagnitudeESP.Transparency = Configuration.ESPOpacity
            self.MagnitudeESP.Visible = ShowingESP and Configuration.MagnitudeESP and isReady
            self.TracerESP.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
            self.TracerESP.To = Vector2.new(rootPos.X, rootPos.Y + self.ESPBox.Size.Y / 2)
            self.TracerESP.Color = Configuration.ESPColour
            self.TracerESP.Transparency = Configuration.ESPOpacity
            self.TracerESP.Thickness = Configuration.ESPThickness
            self.TracerESP.Visible = ShowingESP and Configuration.TracerESP and isReady
        else
            self.ESPBox.Visible = false
            self.NameESP.Visible = false
            self.HealthESP.Visible = false
            self.MagnitudeESP.Visible = false
            self.TracerESP.Visible = false
        end
    end
end

function ESPLibrary:Disconnect()
    self.ESPBox:Remove()
    self.NameESP:Remove()
    self.HealthESP:Remove()
    self.MagnitudeESP:Remove()
    self.TracerESP:Remove()
    self = nil
end

-- Tracking Handler (ESP for players)
local TrackingHandler = {}
local Tracking = {}
local Connections = {}

function TrackingHandler:VisualizeESP()
    for _, tracked in pairs(Tracking) do
        tracked:Visualize()
    end
end

function TrackingHandler:DisconnectTracking(Key)
    if Tracking[Key] then
        Tracking[Key]:Disconnect()
        Tracking[Key] = nil
    end
end

function TrackingHandler:DisconnectConnection(Key)
    if Connections[Key] then
        for _, conn in pairs(Connections[Key]) do conn:Disconnect() end
        Connections[Key] = nil
    end
end

function TrackingHandler:DisconnectConnections()
    for k in pairs(Connections) do self:DisconnectConnection(k) end
    for k in pairs(Tracking) do self:DisconnectTracking(k) end
end

function TrackingHandler:DisconnectAimbot()
    FieldsHandler:ResetAimbotFields()
    FieldsHandler:ResetSecondaryFields()
    self:DisconnectConnections()
    VisualsHandler:ClearVisuals()
end

local function CharacterAdded(_Character)
    local player = Players:GetPlayerFromCharacter(_Character)
    if player and player ~= Player then
        Tracking[player.UserId] = ESPLibrary:Initialize(_Character)
    end
end

local function CharacterRemoving(_Character)
    for k, tracked in pairs(Tracking) do
        if tracked.Character == _Character then self:DisconnectTracking(k) end
    end
end

function TrackingHandler:InitializePlayers()
    if Drawing and Drawing.new then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player then
                CharacterAdded(player.Character)
                Connections[player.UserId] = {player.CharacterAdded:Connect(CharacterAdded), player.CharacterRemoving:Connect(CharacterRemoving)}
            end
        end
    end
end

TrackingHandler:InitializePlayers()

-- Player Events (teleport queue, added/removing)
local OnTeleport = Player.OnTeleport:Connect(function()
    if queue_on_teleport then
        queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/Yazaki-dev/YazHub/main/YazAim.lua"))()')
    end
    OnTeleport:Disconnect()
end)

local PlayerAdded = Players.PlayerAdded:Connect(function(player)
    if Drawing and Drawing.new then
        Connections[player.UserId] = {player.CharacterAdded:Connect(CharacterAdded), player.CharacterRemoving:Connect(CharacterRemoving)}
    end
end)

local PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
    if player == Player then
        Fluent:Destroy()
        TrackingHandler:DisconnectAimbot()
    else
        TrackingHandler:DisconnectConnection(player.UserId)
        TrackingHandler:DisconnectTracking(player.UserId)
    end
end)

-- Aimbot Loop (main update loop)
local AimbotLoop = RunService[UISettings.RenderingMode]:Connect(function()
    if Fluent.Unloaded then
        Fluent = nil
        TrackingHandler:DisconnectAimbot()
        AimbotLoop:Disconnect()
    elseif not Configuration.Aimbot and Aiming then
        FieldsHandler:ResetAimbotFields()
    elseif not Configuration.SpinBot and Spinning then
        Spinning = false
    elseif not Configuration.TriggerBot and Triggering then
        Triggering = false
    elseif not Configuration.FoV and ShowingFoV then
        ShowingFoV = false
    elseif not (Configuration.ESPBox or Configuration.NameESP or Configuration.HealthESP or Configuration.MagnitudeESP or Configuration.TracerESP) and ShowingESP then
        ShowingESP = false
    end

    if RobloxActive then
        HandleBots()
        HandleRandomParts()
        if Drawing and Drawing.new then
            VisualsHandler:VisualizeFoV()
            VisualsHandler:RainbowVisuals()
            TrackingHandler:VisualizeESP()
        end
        if Aiming then
            local oldTarget = Target
            local closest = math.huge
            if not IsReady(oldTarget) then
                if not Configuration.OffAimbotAfterKill or not oldTarget then
                    for _, player in pairs(Players:GetPlayers()) do
                        local isReady, char, viewport = IsReady(player.Character)
                        if isReady and viewport[2] then
                            local mag = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(viewport[1].X, viewport[1].Y)).Magnitude
                            if mag <= closest and mag <= (Configuration.FoVCheck and Configuration.FoVRadius or closest) then
                                Target = char
                                closest = mag
                            end
                        end
                    end
                else
                    FieldsHandler:ResetAimbotFields()
                end
            end
            local isTargetReady, _, viewport, worldPos = IsReady(Target)
            if isTargetReady then
                if mousemoverel and IsComputer and Configuration.AimMode == "Mouse" then
                    local mouseLoc = UserInputService:GetMouseLocation()
                    local sensitivity = Configuration.UseSensitivity and Configuration.Sensitivity / 5 or 10
                    mousemoverel((viewport[1].X - mouseLoc.X) / sensitivity, (viewport[1].Y - mouseLoc.Y) / sensitivity)
                elseif Configuration.AimMode == "Camera" then
                    UserInputService.MouseDeltaSensitivity = 0
                    if Configuration.UseSensitivity then
                        Tween = TweenService:Create(workspace.CurrentCamera, TweenInfo.new(math.clamp(Configuration.Sensitivity, 9, 99) / 100, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, worldPos)})
                        Tween:Play()
                    else
                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, worldPos)
                    end
                end
            else
                FieldsHandler:ResetAimbotFields(true)
            end
        end
    end
end)
