local Players = game:GetService("Players")
local player = Players.LocalPlayer
local MasVibrate = require(game:GetService("ReplicatedStorage"):WaitForChild("MasVibrate"))

local oldHealth

local function onCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    oldHealth = humanoid.Health

    humanoid.HealthChanged:Connect(function(newHealth)
        if newHealth < oldHealth then
            local damage = oldHealth - newHealth
            MasVibrate:Plugin("Character", "Trigger", {
                EventName = "Damage",
                Value = damage,
                MasVibrateSettings = MasVibrate.Settings
            })
        end
        oldHealth = newHealth
    end)
end

if player.Character then
    onCharacter(player.Character)
end

player.CharacterAdded:Connect(onCharacter)