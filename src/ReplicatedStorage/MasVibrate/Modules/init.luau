local Modules = {}

local HapticService = game:GetService("HapticService")
local Compressor = require(script:WaitForChild("Compressor"))
local Balance = require(script:WaitForChild("Balance"))

local channels = {}

local function getChannel(name)
    local n = name or "Default"
    if not channels[n] then
        channels[n] = {
            leftIntensity = 0,
            rightIntensity = 0,
            activeDelay = nil
        }
    end
    return channels[n]
end

local function stopMotors()
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0)
    end
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
    end
end

local function updateMotorsFromChannels()
    local totalLeft = 0
    local totalRight = 0
    for _, ch in pairs(channels) do
        totalLeft += ch.leftIntensity
        totalRight += ch.rightIntensity
    end

    if totalLeft == 0 and totalRight == 0 then
        stopMotors()
    else
        if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small) then
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, totalLeft)
        end
        if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large) then
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, totalRight)
        end
    end
end

function Modules:Apply(intensity, duration, settings, motorChoice, channelName)
    local ch = getChannel(channelName)
    if ch.activeDelay then
        task.cancel(ch.activeDelay)
        ch.activeDelay = nil
    end

    if not (intensity and duration and settings and settings.Enabled) then
        ch.leftIntensity = 0
        ch.rightIntensity = 0
        updateMotorsFromChannels()
        return
    end

    Compressor:CompressAll(settings)
    local c = (motorChoice or "both"):lower()

    if settings.Balance and settings.Balance.Enabled then
        local left, right = Balance:Calculate(settings, intensity, c)
        ch.leftIntensity = left
        ch.rightIntensity = right
    else
        local s = intensity
        local l = intensity
        if c == "s" or c == "small" then
            l = 0
        elseif c == "l" or c == "large" then
            s = 0
        end
        ch.leftIntensity = s
        ch.rightIntensity = l
    end

    updateMotorsFromChannels()

    ch.activeDelay = task.delay(duration, function()
        ch.leftIntensity = 0
        ch.rightIntensity = 0
        ch.activeDelay = nil
        updateMotorsFromChannels()
    end)
end

function Modules:Stop(channelName)
    local ch = channels[channelName or "Default"]
    if ch then
        if ch.activeDelay then
            task.cancel(ch.activeDelay)
            ch.activeDelay = nil
        end
        ch.leftIntensity = 0
        ch.rightIntensity = 0
    end
    updateMotorsFromChannels()
end

return Modules