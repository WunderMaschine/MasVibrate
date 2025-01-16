local PluginCharacter = {}
local Modules = require(script.Parent.Parent.Modules)

PluginCharacter.Config = {
    JumpScale = 100,
    DamageScale = 50,
    BaseDamageDuration = 0.2,
    DamageDurationScale = 150,
    FallScale = 20,
    BaseFallDuration = 0.2,
    FallDurationScale = 50,
    BaseOverallDuration = 0.3
}

local activeDelay

function PluginCharacter:Trigger(pluginData)
    self:Stop()

    local allSettings = pluginData.Settings
    local eventName = pluginData.EventName
    local rawValue = pluginData.Value or 0

    if not allSettings or not allSettings.Character or not allSettings.Character.Enabled then
        return
    end

    local charCfg = allSettings.Character
    local intensity = 0
    local duration = self.Config.BaseOverallDuration

    if eventName == "Jump" then
        intensity = (rawValue / self.Config.JumpScale) * charCfg.JumpIntensity
    elseif eventName == "Damage" then
        intensity = (rawValue / self.Config.DamageScale) * charCfg.DamageIntensity
        duration = self.Config.BaseDamageDuration + (rawValue / self.Config.DamageDurationScale)
    elseif eventName == "Fall" then
        intensity = (rawValue / self.Config.FallScale) * charCfg.FallIntensity
        duration = self.Config.BaseFallDuration + (rawValue / self.Config.FallDurationScale)
    else
        intensity = rawValue > 0 and rawValue or charCfg.JumpIntensity
    end

    intensity = math.clamp(intensity, allSettings.MinIntensity, allSettings.MaxIntensity)
    Modules:Apply(intensity, duration, allSettings)

    activeDelay = task.delay(duration, function()
        self:Stop()
    end)
end

function PluginCharacter:Stop()
    if activeDelay then
        task.cancel(activeDelay)
        activeDelay = nil
    end
    Modules:Stop()
end

return PluginCharacter