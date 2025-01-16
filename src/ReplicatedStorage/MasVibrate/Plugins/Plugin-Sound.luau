local PluginSound = {}
local Modules = require(script.Parent.Parent.Modules)

PluginSound.Config = {
    DefaultVolume = 1,
    VolumeScale = 10,
    BaseDuration = 0.3,
    ExtraDurationScale = 50
}

local activeDelay

function PluginSound:Trigger(pluginData)
    self:Stop()

    local allSettings = pluginData.Settings
    if not allSettings or not allSettings.Sound or not allSettings.Sound.Enabled then
        return
    end

    local volume = pluginData.Volume or self.Config.DefaultVolume
    local baseIntensity = (volume / self.Config.VolumeScale)
        * allSettings.Sound.Sensitivity
        * allSettings.Sound.MusicResponse

    local intensity = math.clamp(baseIntensity, allSettings.MinIntensity, allSettings.MaxIntensity)
    local duration = self.Config.BaseDuration + (volume / self.Config.ExtraDurationScale)

    Modules:Apply(intensity, duration, allSettings)

    activeDelay = task.delay(duration, function()
        self:Stop()
    end)
end

function PluginSound:Stop()
    if activeDelay then
        task.cancel(activeDelay)
        activeDelay = nil
    end
    Modules:Stop()
end

return PluginSound