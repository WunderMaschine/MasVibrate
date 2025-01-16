local Balance = {}

local HapticService = game:GetService("HapticService")
local Compressor = require(script.Parent.Compressor)

local activeDelay

local function setMotorIfAvailable(userInputType, motor, intensity)
    if HapticService:IsMotorSupported(userInputType, motor) then
        HapticService:SetMotor(userInputType, motor, intensity)
    end
end

function Balance:ApplyBalance(masVibrateSettings, intensity, duration)
    self:Stop()
    if not masVibrateSettings or not masVibrateSettings.Balance or not masVibrateSettings.Balance.Enabled then
        return
    end

    Compressor:CompressAll(masVibrateSettings)
    local b = masVibrateSettings.Balance
    
    local angle = math.clamp(b.Sway, 0, 1) * (math.pi / 2)
    local leftFactor = math.cos(angle)
    local rightFactor = math.sin(angle)
    
    local leftIntensity = intensity * leftFactor * b.Intensity
    local rightIntensity = intensity * rightFactor * b.Intensity

    local leftSupported = HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor)
    local rightSupported = HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor)

    if leftSupported and rightSupported then
        setMotorIfAvailable(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor, leftIntensity)
        setMotorIfAvailable(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor, rightIntensity)
    elseif leftSupported then
        setMotorIfAvailable(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor, leftIntensity + rightIntensity)
    elseif rightSupported then
        setMotorIfAvailable(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor, leftIntensity + rightIntensity)
    else
        return
    end

    activeDelay = task.delay(duration, function()
        self:Stop()
    end)
end

function Balance:Stop()
    if activeDelay then
        task.cancel(activeDelay)
        activeDelay = nil
    end
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor, 0)
    end
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor, 0)
    end
end

return Balance