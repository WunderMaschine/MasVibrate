--[[ Made by: WunderMaschine
  __  __        __      ___ _               _       
 |  \/  |       \ \    / (_) |             | |      
 | \  / | __ _ __\ \  / / _| |__  _ __ __ _| |_ ___ 
 | |\/| |/ _` / __\ \/ / | | '_ \| '__/ _` | __/ _ \
 | |  | | (_| \__ \\  /  | | |_) | | | (_| | ||  __/
 |_|  |_|\__,_|___/ \/   |_|_.__/|_|  \__,_|\__\___|

!!! Please read the README file and the documantations on GitHub before using this module !!!]]

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
        Enabled = false,
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
-- Added optional channelName so multiple channels can coexist.
function MasVibrate:Vibrate(intensity, duration, motorChoice, channelName)
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
    Modules:Apply(intensity, duration, self.Settings, motorChoice, channelName)
end

--[]--[]-- STOP --[]--[]--
-- Also supports optional channelName to only stop a specific channel.
function MasVibrate:Stop(channelName)
    Modules:Stop(channelName)
end

--[]--[]-- CUSTOM PATTERNS --[]--[]--
function MasVibrate:CustomVibration(pattern, customData, motorChoice, channelName)
    if self.Settings.Enabled then
        Modules:Apply(self.Settings.DefaultIntensity, self.Settings.DefaultDuration, self.Settings, motorChoice, channelName)
    end
end

function MasVibrate:PatternVibration(pattern, speed, motorChoice, channelName)
    if self.Settings.Enabled then
        Modules:Apply(self.Settings.DefaultIntensity, self.Settings.DefaultDuration, self.Settings, motorChoice, channelName)
    end
end

--[]--[]-- FADE --[]--[]--
function MasVibrate:FadeIn(intensity, duration, motorChoice, channelName)
    if self.Settings.Enabled and self.Settings.FadeInEnabled then
        Modules:Apply(intensity, duration, self.Settings, motorChoice, channelName)
    end
end

function MasVibrate:FadeOut(duration, channelName)
    if self.Settings.Enabled and self.Settings.FadeOutEnabled then
        task.delay(duration, function()
            Modules:Stop(channelName)
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