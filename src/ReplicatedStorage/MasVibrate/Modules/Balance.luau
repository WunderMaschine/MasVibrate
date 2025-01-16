local Balance = {}
local Compressor = require(script.Parent.Compressor)
local HapticService = game:GetService("HapticService")

local activeDelay

function Balance:ApplyBalance(masVibrateSettings, intensity, duration, motorChoice)
    if not masVibrateSettings
        or not masVibrateSettings.Balance
        or not masVibrateSettings.Balance.Enabled
    then
        return
    end

    Compressor:CompressAll(masVibrateSettings)
    local b = masVibrateSettings.Balance

    local angle = math.clamp(b.Sway, 0, 1) * (math.pi / 2)
    local leftFactor = math.cos(angle)
    local rightFactor = math.sin(angle)

    local leftIntensity = intensity * leftFactor * b.Intensity
    local rightIntensity = intensity * rightFactor * b.Intensity

    local choice = (motorChoice or "both"):lower()
    if choice == "s" or choice == "small" then
        rightIntensity = 0
    elseif choice == "l" or choice == "large" then
        leftIntensity = 0
    end

    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, leftIntensity)
    end
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, rightIntensity)
    end

    activeDelay = task.delay(duration, function()
        if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small) then
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)
        end
        if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large) then
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
        end
        activeDelay = nil
    end)
end

function Balance:Stop()
    if activeDelay then
        task.cancel(activeDelay)
        activeDelay = nil
    end
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)
    end
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
    end
end

return Balance