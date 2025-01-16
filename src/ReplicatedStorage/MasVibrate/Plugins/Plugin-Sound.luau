local PluginSound = {}

PluginSound.Settings = {
    Enabled = true,
    Sensitivity = 1,
    MusicResponse = 1
}

PluginSound.Config = {
    DefaultVolume = 1,
    VolumeScale = 10,
    BaseDuration = 0.3,
    ExtraDurationScale = 50
}

local Modules = require(script.Parent.Parent.Modules)
local activeDelay

function PluginSound:Trigger(pluginData)
    self:Stop()
    if pluginData and pluginData.Settings then
        if pluginData.Settings.Enabled ~= nil then
            self.Settings.Enabled = pluginData.Settings.Enabled
        end
        if pluginData.Settings.Sensitivity ~= nil then
            self.Settings.Sensitivity = pluginData.Settings.Sensitivity
        end
        if pluginData.Settings.MusicResponse ~= nil then
            self.Settings.MusicResponse = pluginData.Settings.MusicResponse
        end
    end
    if not self.Settings.Enabled then
        return
    end
    local allSettings = pluginData.MasVibrateSettings
    if not allSettings then
        return
    end
    local volume = pluginData.Volume or self.Config.DefaultVolume
    local baseIntensity = (volume / self.Config.VolumeScale)
        * self.Settings.Sensitivity
        * self.Settings.MusicResponse
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