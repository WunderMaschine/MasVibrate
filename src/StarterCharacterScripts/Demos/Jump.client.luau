local Players = game:GetService("Players")
local player = Players.LocalPlayer
local MasVibrate = require(game:GetService("ReplicatedStorage"):WaitForChild("MasVibrate"))

local function setupCharacter(char)
    local humanoid = char:WaitForChild("Humanoid")
    local rootPart = char:WaitForChild("HumanoidRootPart")

    local wasFalling = false
    local fallStartY = 0
    local MIN_FALL_DISTANCE = 2

    humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Freefall then
            wasFalling = true
            fallStartY = rootPart.Position.Y
        elseif wasFalling and oldState == Enum.HumanoidStateType.Freefall then
            wasFalling = false
            local dist = math.abs(rootPart.Position.Y - fallStartY)
            if dist >= MIN_FALL_DISTANCE then
                MasVibrate:Plugin("Character", "Trigger", {
                    EventName = "Fall",
                    Value = dist,
                    MasVibrateSettings = MasVibrate.Settings
                })
            end
        end
    end)

    humanoid.Jumping:Connect(function(isActive)
        if isActive then
            local jumpPower = humanoid.JumpPower or 50
            MasVibrate:Plugin("Character", "Trigger", {
                EventName = "Jump",
                Value = jumpPower,
                MasVibrateSettings = MasVibrate.Settings
            })
        end
    end)
end

local function onCharacterAdded(char)
    setupCharacter(char)
end

if player.Character then
    onCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(onCharacterAdded)