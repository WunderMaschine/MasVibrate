local Modules = {}

local HapticService = game:GetService("HapticService")
local Compressor = require(script:WaitForChild("Compressor"))
local Balance = require(script:WaitForChild("Balance"))

local activeDelay

local function stopMotors()
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)
    end
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
    end
end

function Modules:Apply(intensity, duration, masVibrateSettings, motorChoice)
    self:Stop()

    if not intensity or not duration or not masVibrateSettings then
        return
    end

    Compressor:CompressAll(masVibrateSettings)

    if masVibrateSettings.Balance and masVibrateSettings.Balance.Enabled then
        Balance:ApplyBalance(masVibrateSettings, intensity, duration, motorChoice)
    else
        local choice = (motorChoice or "both"):lower()
        local finalSmall = intensity
        local finalLarge = intensity

        if choice == "s" or choice == "small" then
            finalLarge = 0
        elseif choice == "l" or choice == "large" then
            finalSmall = 0
        end

        if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small) then
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, finalSmall)
        end
        if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large) then
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, finalLarge)
        end

        activeDelay = task.delay(duration, function()
            stopMotors()
            activeDelay = nil
        end)
    end
end

function Modules:Stop()
    if activeDelay then
        task.cancel(activeDelay)
        activeDelay = nil
    end
    stopMotors()
end

return Modules