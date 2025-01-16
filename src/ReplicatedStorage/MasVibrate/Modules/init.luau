local Modules = {}

local HapticService = game:GetService("HapticService")
local Compressor = require(script.Parent.Compressor)
local Balance = require(script.Parent.Balance)

local activeDelay

local function stopMotors()
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor, 0)
    end
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor, 0)
    end
end

function Modules:Apply(intensity, duration, masVibrateSettings)
    self:Stop()
    if not intensity or not duration or not masVibrateSettings then
        return
    end

    Compressor:CompressAll(masVibrateSettings)

    if masVibrateSettings.Balance and masVibrateSettings.Balance.Enabled then
        Balance:ApplyBalance(masVibrateSettings, intensity, duration)
    else
        if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor) then
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor, intensity)
        end
        if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor) then
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor, intensity)
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
    Balance:Stop()
    stopMotors()
end

return Modules