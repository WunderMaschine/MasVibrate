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
    Enabled = true,          
    DefaultIntensity = 1,    
    DefaultDuration = 0.5,   
    MinIntensity = 0.1,      
    MaxIntensity = 10,       
    IntensityStep = 0.1,

    SmoothingEnabled = false,
    SmoothingSpeed = 0.05,
    FadeInEnabled = false,
    FadeInDuration = 0.2,
    FadeOutEnabled = false,
    FadeOutDuration = 0.3,
    PatternSpeed = 1,

    Balance = {
        Enabled = true,
        Intensity = 1,
        Sway = 0.5
    }
}

--[]--[]-- DEPENDENCIES --[]--[]--
local Modules = require(script:WaitForChild("Modules"))

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
    local pluginFolder = script:WaitForChild("Plugins")
    local pluginModule = require(pluginFolder:WaitForChild(pluginName))
    if pluginModule and pluginModule[command] then
        pluginModule[command](pluginModule, ...)
    else
        warn("[MasVibrate] No method '" .. tostring(command) .. "' found in plugin:", pluginName)
    end
end

return MasVibrate