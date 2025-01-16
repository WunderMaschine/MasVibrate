local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local MasVibrate = require(game:GetService("ReplicatedStorage"):WaitForChild("MasVibrate"))

local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local fallStartY = nil
local wasFalling = false

-- Jump event
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

-- Fall event
humanoid.StateChanged:Connect(function(oldState, newState)
    if newState == Enum.HumanoidStateType.Freefall then
        fallStartY = rootPart.Position.Y
        wasFalling = true
    elseif wasFalling then
        if newState == Enum.HumanoidStateType.Landed
        or newState == Enum.HumanoidStateType.Running
        or newState == Enum.HumanoidStateType.Walking
        or newState == Enum.HumanoidStateType.RunningNoPhysics
        or newState == Enum.HumanoidStateType.Seated
        then
            wasFalling = false
            local fallDistance = math.abs(rootPart.Position.Y - (fallStartY or rootPart.Position.Y))
            MasVibrate:Plugin("Character", "Trigger", {
                EventName = "Fall",
                Value = fallDistance,
                MasVibrateSettings = MasVibrate.Settings
            })
        end
    end
end)