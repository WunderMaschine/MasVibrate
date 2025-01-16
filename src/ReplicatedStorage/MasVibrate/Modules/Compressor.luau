local Compressor = {}

local function clampValue(value, minVal, maxVal)
    if value < minVal then
        return minVal
    elseif value > maxVal then
        return maxVal
    end
    return value
end

local function ensureMinMax(settings)
    if settings.MinIntensity > settings.MaxIntensity then
        local temp = settings.MinIntensity
        settings.MinIntensity = settings.MaxIntensity
        settings.MaxIntensity = temp
    end
end

local function isBoolean(value)
    return type(value) == "boolean"
end

local function isNumber(value)
    return type(value) == "number"
end

local function handleUnknownKeys(settings, validKeys)
    for key in pairs(settings) do
        if not validKeys[key] then
            -- warn("[Compressor] Unknown key detected:", key)
        end
    end
end

local function checkBalanceTable(balanceTable)
    if type(balanceTable) ~= "table" then
        return {
            Enabled = true,
            Intensity = 1,
            Sway = 0.5
        }
    end
    return balanceTable
end

function Compressor:CheckGeneral(settings)
    ensureMinMax(settings)
    if not isBoolean(settings.Enabled) then
        settings.Enabled = false
    end
    settings.DefaultIntensity = clampValue(settings.DefaultIntensity, settings.MinIntensity, settings.MaxIntensity)
    settings.DefaultDuration = math.max(settings.DefaultDuration, 0)
    if not isBoolean(settings.SmoothingEnabled) then
        settings.SmoothingEnabled = false
    end
    if not isNumber(settings.SmoothingSpeed) then
        settings.SmoothingSpeed = 0.05
    else
        settings.SmoothingSpeed = math.max(settings.SmoothingSpeed, 0)
    end
    if not isBoolean(settings.FadeInEnabled) then
        settings.FadeInEnabled = false
    end
    settings.FadeInDuration = clampValue(settings.FadeInDuration, 0, settings.DefaultDuration)
    if not isBoolean(settings.FadeOutEnabled) then
        settings.FadeOutEnabled = false
    end
    settings.FadeOutDuration = clampValue(settings.FadeOutDuration, 0, settings.DefaultDuration)
    if not isNumber(settings.PatternSpeed) then
        settings.PatternSpeed = 1
    else
        settings.PatternSpeed = math.max(settings.PatternSpeed, 0)
    end
    local validKeys = {
        Enabled = true,
        DefaultIntensity = true,
        DefaultDuration = true,
        MinIntensity = true,
        MaxIntensity = true,
        IntensityStep = true,
        SmoothingEnabled = true,
        SmoothingSpeed = true,
        FadeInEnabled = true,
        FadeInDuration = true,
        FadeOutEnabled = true,
        FadeOutDuration = true,
        PatternSpeed = true,
        Balance = true
    }
    handleUnknownKeys(settings, validKeys)
end

function Compressor:CheckBalanceData(balanceSettings)
    if not balanceSettings.Enabled then
        return
    end
    if not isNumber(balanceSettings.Intensity) then
        balanceSettings.Intensity = 1
    else
        balanceSettings.Intensity = math.max(balanceSettings.Intensity, 0)
    end
    if not isNumber(balanceSettings.Sway) then
        balanceSettings.Sway = 0.5
    else
        balanceSettings.Sway = math.clamp(balanceSettings.Sway, 0, 1)
    end
end

function Compressor:CompressAll(masVibrateSettings)
    if not masVibrateSettings then
        return
    end
    masVibrateSettings.Balance = checkBalanceTable(masVibrateSettings.Balance)
    self:CheckGeneral(masVibrateSettings)
    self:CheckBalanceData(masVibrateSettings.Balance)
end

return Compressor