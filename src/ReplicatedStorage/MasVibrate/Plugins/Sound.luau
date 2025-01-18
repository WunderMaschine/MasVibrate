local PluginSound = {}

PluginSound.Settings = {
    Enabled = true,
    Sensitivity = 1,
    MusicResponse = 1
}

PluginSound.Config = {
    DefaultHeight = 1,
    HeightScale = 10,
    BaseDuration = 0.3,
    ExtraDurationScale = 50
}

local Modules = require(script.Parent.Parent.Modules)

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

    local height = pluginData.Height or self.Config.DefaultHeight
    local baseIntensity = (height / self.Config.HeightScale)
        * self.Settings.Sensitivity
        * self.Settings.MusicResponse
    local intensity = math.clamp(baseIntensity, allSettings.MinIntensity, allSettings.MaxIntensity)
    local duration = self.Config.BaseDuration + (height / self.Config.ExtraDurationScale)
    local motorChoice = pluginData.MotorChoice or "both"

    Modules:Apply(intensity, duration, allSettings, motorChoice, "Sound")
end

function PluginSound:Stop()
    Modules:Stop("Sound")
end

return PluginSound