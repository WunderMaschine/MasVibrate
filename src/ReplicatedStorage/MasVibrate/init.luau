--[[Hi!
  __  __        __   ___ _             _       
 |  \/  |__ _ __\ \ / (_) |__ _ _ __ _| |_ ___ 
 | |\/| / _` (_-<\ V /| | '_ \ '_/ _` |  _/ -_)
 |_|  |_\__,_/__/ \_/ |_|_.__/_| \__,_|\__\___|
I recommend reading the README and the documentation before using this module]]

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

    Sound = {
        Enabled = true,
        Sensitivity = 1,
        MusicResponse = 1
    },

    Balance = {
        Enabled = true,
        Intensity = 1,
        Sway = 0.5
    },

    Character = {
        Enabled = true,
        JumpIntensity = 1,
        DamageIntensity = 2,
        FallIntensity = 1
    }
}

local Modules = require(script.Parent.Modules)

function MasVibrate:Configure(settingsTable)
    for k, v in pairs(settingsTable) do
        if self.Settings[k] ~= nil then
            self.Settings[k] = v
        end
    end
    warn("[MasVibrate] Configure called.")
end

function MasVibrate:Vibrate(intensity, duration)
    if not self.Settings.Enabled then
        warn("[MasVibrate] Vibrations are disabled.")
        return
    end
    intensity = intensity or self.Settings.DefaultIntensity
    duration = duration or self.Settings.DefaultDuration

    intensity = math.clamp(intensity, self.Settings.MinIntensity, self.Settings.MaxIntensity)
    Modules:Apply(intensity, duration)
    warn("[MasVibrate] Vibrate called. Intensity:", intensity, "Duration:", duration)
end

function MasVibrate:Stop()
    Modules:Stop()
    warn("[MasVibrate] Stop called.")
end

-- Example stubs for custom patterns, fade, etc.
function MasVibrate:CustomVibration(pattern, customData)
    if self.Settings.Enabled then
        Modules:Apply(self.Settings.DefaultIntensity, self.Settings.DefaultDuration)
    end
    warn("[MasVibrate] CustomVibration called. Pattern:", pattern, "Data:", customData)
end

function MasVibrate:PatternVibration(pattern, speed)
    if self.Settings.Enabled then
        Modules:Apply(self.Settings.DefaultIntensity, self.Settings.DefaultDuration)
    end
    warn("[MasVibrate] PatternVibration called. Pattern:", pattern, "Speed:", speed)
end

function MasVibrate:FadeIn(intensity, duration)
    if self.Settings.Enabled and self.Settings.FadeInEnabled then
        Modules:Apply(intensity, duration)
    end
    warn("[MasVibrate] FadeIn. Intensity:", intensity, "Duration:", duration)
end

function MasVibrate:FadeOut(duration)
    if self.Settings.Enabled and self.Settings.FadeOutEnabled then
        task.delay(duration, function()
            Modules:Stop()
        end)
    end
    warn("[MasVibrate] FadeOut. Duration:", duration)
end

-- We removed Sound & Character direct calls; they're now separate plugins.

--[]--[]-- PLUGIN HANDLER --[]--[]--
function MasVibrate:Plugin(pluginName, command, ...)
    local actualName = pluginName
    if pluginName:match("^Plugin%-") then
        actualName = pluginName:gsub("^Plugin%-", "")
    elseif pluginName:match("^Plugin/") then
        actualName = pluginName:gsub("^Plugin/", "")
    end
    warn("[MasVibrate] Plugin invoked. Name:", actualName, "Command:", command, "Vars:", ...)
end

return MasVibrate