local Balance = {}
local Compressor = require(script.Parent.Compressor)

function Balance:Calculate(masVibrateSettings, intensity, motorChoice)
    if not masVibrateSettings
        or not masVibrateSettings.Balance
        or not masVibrateSettings.Balance.Enabled
    then
        return intensity, intensity
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

    return leftIntensity, rightIntensity
end

return Balance