local PluginCharacter = {}

PluginCharacter.Settings = {
    Enabled = true,
    JumpIntensity = 1.5,
    DamageIntensity = 2.5,
    FallIntensity = 1.5
}

PluginCharacter.Config = {
    JumpScale = 50,
    DamageScale = 25,
    BaseDamageDuration = 0.05,
    DamageDurationScale = 50,
    FallScale = 20,
    BaseFallDuration = 0.05,
    FallDurationScale = 50,
    BaseOverallDuration = 0.1
}

local Modules = require(script.Parent.Parent.Modules)

function PluginCharacter:Trigger(pluginData)
    self:Stop()

    if pluginData and pluginData.Settings then
        if pluginData.Settings.Enabled ~= nil then
            self.Settings.Enabled = pluginData.Settings.Enabled
        end
        if pluginData.Settings.JumpIntensity ~= nil then
            self.Settings.JumpIntensity = pluginData.Settings.JumpIntensity
        end
        if pluginData.Settings.DamageIntensity ~= nil then
            self.Settings.DamageIntensity = pluginData.Settings.DamageIntensity
        end
        if pluginData.Settings.FallIntensity ~= nil then
            self.Settings.FallIntensity = pluginData.Settings.FallIntensity
        end
    end
    if not self.Settings.Enabled then
        return
    end

    local allSettings = pluginData.MasVibrateSettings
    if not allSettings then
        return
    end

    local eventName = pluginData.EventName
    local rawValue = pluginData.Value or 0
    local intensity = 0
    local duration = self.Config.BaseOverallDuration
    local motorChoice = pluginData.MotorChoice or "both"
    local channelName = "Character" 

    if eventName == "Jump" then
        intensity = (rawValue / self.Config.JumpScale) * self.Settings.JumpIntensity
    elseif eventName == "Damage" then
        intensity = (rawValue / self.Config.DamageScale) * self.Settings.DamageIntensity
        duration = self.Config.BaseDamageDuration + (rawValue / self.Config.DamageDurationScale)
    elseif eventName == "Fall" then
        intensity = (rawValue / self.Config.FallScale) * self.Settings.FallIntensity
        duration = self.Config.BaseFallDuration + (rawValue / self.Config.FallDurationScale)
    else
        intensity = rawValue > 0 and rawValue or self.Settings.JumpIntensity
    end

    intensity = math.clamp(intensity, allSettings.MinIntensity, allSettings.MaxIntensity)
    Modules:Apply(intensity, duration, allSettings, motorChoice, channelName)
end

function PluginCharacter:Stop()
    Modules:Stop("Character")
end

return PluginCharacter