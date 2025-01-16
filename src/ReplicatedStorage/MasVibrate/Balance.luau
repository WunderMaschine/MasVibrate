local Balance = {}

local HapticService = game:GetService("HapticService")
local Compressor = require(script.Parent.Compressor)

local activeDelay

function Balance:ApplyBalance(masVibrateSettings, intensity, duration)
    self:Stop()
    if not masVibrateSettings or not masVibrateSettings.Balance or not masVibrateSettings.Balance.Enabled then
        return
    end
    Compressor:CompressAll(masVibrateSettings)
    local b = masVibrateSettings.Balance
    local leftFactor = math.clamp(1 - b.Sway, 0, 1)
    local rightFactor = math.clamp(b.Sway, 0, 1)
    local leftIntensity = intensity * leftFactor * b.Intensity
    local rightIntensity = intensity * rightFactor * b.Intensity
    HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor, leftIntensity)
    HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor, rightIntensity)
    activeDelay = task.delay(duration, function()
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor, 0)
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor, 0)
        activeDelay = nil
    end)
end

function Balance:Stop()
    if activeDelay then
        task.cancel(activeDelay)
        activeDelay = nil
    end
    HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor, 0)
    HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor, 0)
end

return Balance