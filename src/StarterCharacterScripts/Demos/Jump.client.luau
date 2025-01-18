local Players = game:GetService("Players")
local player = Players.LocalPlayer
local MasVibrate = require(game:GetService("ReplicatedStorage"):WaitForChild("MasVibrate"))

local function setupCharacter(char)
    local humanoid = char:WaitForChild("Humanoid")
    local rootPart = char:WaitForChild("HumanoidRootPart")

    local wasInAir = false
    local fallStartY = 0

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

    humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
        local currentMat = humanoid.FloorMaterial
        if currentMat == Enum.Material.Air then
            wasInAir = true
            fallStartY = rootPart.Position.Y
        else
            if wasInAir then
                wasInAir = false
                local dist = math.abs(rootPart.Position.Y - fallStartY)
                if dist > 0.5 then
                    MasVibrate:Plugin("Character", "Trigger", {
                        EventName = "Fall",
                        Value = dist,
                        MasVibrateSettings = MasVibrate.Settings
                    })
                end
            end
        end
    end)
end

local function onCharacterAdded(char)
    setupCharacter(char)
end

local initialChar = player.Character or player.CharacterAdded:Wait()
onCharacterAdded(initialChar)

player.CharacterAdded:Connect(onCharacterAdded)