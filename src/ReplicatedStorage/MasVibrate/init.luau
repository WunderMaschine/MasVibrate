--[[
  __  __        __      ___ _               _       
 |  \/  |       \ \    / (_) |             | |      
 | \  / | __ _ __\ \  / / _| |__  _ __ __ _| |_ ___ 
 | |\/| |/ _` / __\ \/ / | | '_ \| '__/ _` | __/ _ \
 | |  | | (_| \__ \\  /  | | |_) | | | (_| | ||  __/
 |_|  |_|\__,_|___/ \/   |_|_.__/|_|  \__,_|\__\___|
 Made by: WunderMaschine
]]

local readmeVersion = require(script:WaitForChild("README"))

local MasVibrate = {}

--[]--[]-- SETTINGS --[]--[]--
MasVibrate.Settings = {
    Enabled = true,          -- Master switch to enable/disable all vibrations
    DefaultIntensity = 1,    -- Used if no intensity is specified
    DefaultDuration = 0.5,   -- Used if no duration is specified
    MinIntensity = 0.1,      -- Lower clamp for any custom intensity
    MaxIntensity = 10,       -- Upper clamp for any custom intensity
    IntensityStep = 0.1,     -- Can be used by UIs or incremental adjustments

    SmoothingEnabled = false,-- If true, uses a smooth transition approach
    SmoothingSpeed = 0.05,   -- Speed factor for smoothing transitions
    FadeInEnabled = false,   -- If true, adds a fade-in effect
    FadeInDuration = 0.2,    -- Duration for fade-in
    FadeOutEnabled = false,  -- If true, adds a fade-out effect
    FadeOutDuration = 0.3,   -- Duration for fade-out
    PatternSpeed = 1,        -- Speed multiplier for pattern-based vibrations

    Balance = {
        Enabled = true,  -- Splits intensity across left and right motors if true
        Intensity = 1,   -- Extra factor applied to balanced intensities
        Sway = 0.5       -- 0 = all left motor, 1 = all right motor, 0.5 = equal split
    }
}

--[]--[]-- DEPENDENCIES --[]--[]--
local Modules = require(script:WaitForChild('Modules'))

--[]--[]-- CONFIGURE --[]--[]--
function MasVibrate:Configure(settingsTable)
    for k, v in pairs(settingsTable) do
        if self.Settings[k] ~= nil then
            self.Settings[k] = v
        end
    end
end

--[]--[]-- VIBRATE --[]--[]--
function MasVibrate:Vibrate(intensity, duration, motorChoice)
    if not self.Settings.Enabled then
        warn("[MasVibrate] Vibrations are disabled.")
        return
    end
    intensity = intensity or self.Settings.DefaultIntensity
    duration = duration or self.Settings.DefaultDuration
    if intensity < self.Settings.MinIntensity then
        intensity = self.Settings.MinIntensity
    elseif intensity > self.Settings.MaxIntensity then
        intensity = self.Settings.MaxIntensity
    end
    Modules:Apply(intensity, duration, self.Settings, motorChoice)
end

--[]--[]-- STOP --[]--[]--
function MasVibrate:Stop()
    Modules:Stop()
end

--[]--[]-- CUSTOM PATTERNS --[]--[]--
function MasVibrate:CustomVibration(pattern, customData, motorChoice)
    if self.Settings.Enabled then
        Modules:Apply(self.Settings.DefaultIntensity, self.Settings.DefaultDuration, self.Settings, motorChoice)
    end
end

function MasVibrate:PatternVibration(pattern, speed, motorChoice)
    if self.Settings.Enabled then
        Modules:Apply(self.Settings.DefaultIntensity, self.Settings.DefaultDuration, self.Settings, motorChoice)
    end
end

--[]--[]-- FADE --[]--[]--
function MasVibrate:FadeIn(intensity, duration, motorChoice)
    if self.Settings.Enabled and self.Settings.FadeInEnabled then
        Modules:Apply(intensity, duration, self.Settings, motorChoice)
    end
end

function MasVibrate:FadeOut(duration)
    if self.Settings.Enabled and self.Settings.FadeOutEnabled then
        task.delay(duration, function()
            Modules:Stop()
        end)
    end
end

--[]--[]-- PLUGIN HANDLER --[]--[]--
function MasVibrate:Plugin(pluginName, command, ...)
    local actualName = pluginName
    if pluginName:match("^Plugin%-") then
        actualName = pluginName:gsub("^Plugin%-", "")
    elseif pluginName:match("^Plugin/") then
        actualName = pluginName:gsub("^Plugin/", "")
    end
    -- warn("[MasVibrate] Plugin invoked. Name:", actualName, "Command:", command, "Vars:", ...)
end

return MasVibrate