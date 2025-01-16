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
        warn("[Compressor] MinIntensity is greater than MaxIntensity. Swapping values.")
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

local function checkModuleTable(moduleTable, defaultTable)
    if type(moduleTable) ~= "table" then
        warn("[Compressor] Missing or invalid subtable, creating defaults.")
        return defaultTable
    end
    return moduleTable
end

local function handleUnknownKeys(settings, validKeys)
    for key in pairs(settings) do
        if not validKeys[key] then
            warn("[Compressor] Unknown key detected: " .. tostring(key))
        end
    end
end

function Compressor:CheckGeneral(settings)
    ensureMinMax(settings)

    if not isBoolean(settings.Enabled) then
        warn("[Compressor] 'Enabled' is not boolean. Forcing it to false.")
        settings.Enabled = false
    end

    settings.DefaultIntensity = clampValue(settings.DefaultIntensity, settings.MinIntensity, settings.MaxIntensity)
    settings.DefaultDuration = math.max(settings.DefaultDuration, 0)

    if not isBoolean(settings.SmoothingEnabled) then
        warn("[Compressor] 'SmoothingEnabled' is not boolean. Setting to false.")
        settings.SmoothingEnabled = false
    end
    if not isNumber(settings.SmoothingSpeed) then
        warn("[Compressor] 'SmoothingSpeed' is not a number. Setting to 0.05.")
        settings.SmoothingSpeed = 0.05
    else
        settings.SmoothingSpeed = math.max(settings.SmoothingSpeed, 0)
    end

    if not isBoolean(settings.FadeInEnabled) then
        warn("[Compressor] 'FadeInEnabled' is not boolean. Setting to false.")
        settings.FadeInEnabled = false
    end
    settings.FadeInDuration = math.max(settings.FadeInDuration, 0)

    if not isBoolean(settings.FadeOutEnabled) then
        warn("[Compressor] 'FadeOutEnabled' is not boolean. Setting to false.")
        settings.FadeOutEnabled = false
    end
    settings.FadeOutDuration = math.max(settings.FadeOutDuration, 0)

    if not isNumber(settings.PatternSpeed) then
        warn("[Compressor] 'PatternSpeed' is not a number. Setting to 1.")
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
        Sound = true,
        Balance = true,
        Character = true
    }
    handleUnknownKeys(settings, validKeys)
end

function Compressor:CheckSoundData(soundSettings)
    if not soundSettings.Enabled then return end

    if not isNumber(soundSettings.Sensitivity) then
        warn("[Compressor] 'Sensitivity' is not a number. Setting to 1.")
        soundSettings.Sensitivity = 1
    else
        soundSettings.Sensitivity = math.max(soundSettings.Sensitivity, 0)
    end

    if not isNumber(soundSettings.MusicResponse) then
        warn("[Compressor] 'MusicResponse' is not a number. Setting to 1.")
        soundSettings.MusicResponse = 1
    else
        soundSettings.MusicResponse = math.max(soundSettings.MusicResponse, 0)
    end

    local validKeys = {
        Enabled = true,
        Sensitivity = true,
        MusicResponse = true
    }
    handleUnknownKeys(soundSettings, validKeys)
end

function Compressor:CheckBalanceData(balanceSettings)
    if not balanceSettings.Enabled then return end

    if not isNumber(balanceSettings.Intensity) then
        warn("[Compressor] 'Intensity' is not a number. Setting to 1.")
        balanceSettings.Intensity = 1
    else
        balanceSettings.Intensity = math.max(balanceSettings.Intensity, 0)
    end

    if not isNumber(balanceSettings.Sway) then
        warn("[Compressor] 'Sway' is not a number. Setting to 0.5.")
        balanceSettings.Sway = 0.5
    else
        balanceSettings.Sway = math.clamp(balanceSettings.Sway, 0, 1)
    end

    local validKeys = {
        Enabled = true,
        Intensity = true,
        Sway = true
    }
    handleUnknownKeys(balanceSettings, validKeys)
end

function Compressor:CheckCharacterData(charSettings)
    if not charSettings.Enabled then return end

    if not isNumber(charSettings.JumpIntensity) then
        warn("[Compressor] 'JumpIntensity' is not a number. Setting to 1.")
        charSettings.JumpIntensity = 1
    else
        charSettings.JumpIntensity = math.max(charSettings.JumpIntensity, 0)
    end

    if not isNumber(charSettings.DamageIntensity) then
        warn("[Compressor] 'DamageIntensity' is not a number. Setting to 2.")
        charSettings.DamageIntensity = 2
    else
        charSettings.DamageIntensity = math.max(charSettings.DamageIntensity, 0)
    end

    if not isNumber(charSettings.FallIntensity) then
        warn("[Compressor] 'FallIntensity' is not a number. Setting to 1.")
        charSettings.FallIntensity = 1
    else
        charSettings.FallIntensity = math.max(charSettings.FallIntensity, 0)
    end

    local validKeys = {
        Enabled = true,
        JumpIntensity = true,
        DamageIntensity = true,
        FallIntensity = true
    }
    handleUnknownKeys(charSettings, validKeys)
end

function Compressor:CompressAll(masVibrateSettings)
    if not masVibrateSettings then
        warn("[Compressor] No settings passed.")
        return
    end

    -- Make sure submodules exist or set default tables
    masVibrateSettings.Sound = checkModuleTable(masVibrateSettings.Sound, {
        Enabled = true,
        Sensitivity = 1,
        MusicResponse = 1
    })

    masVibrateSettings.Balance = checkModuleTable(masVibrateSettings.Balance, {
        Enabled = true,
        Intensity = 1,
        Sway = 0.5
    })

    masVibrateSettings.Character = checkModuleTable(masVibrateSettings.Character, {
        Enabled = true,
        JumpIntensity = 1,
        DamageIntensity = 2,
        FallIntensity = 1
    })

    self:CheckGeneral(masVibrateSettings)
    self:CheckSoundData(masVibrateSettings.Sound)
    self:CheckBalanceData(masVibrateSettings.Balance)
    self:CheckCharacterData(masVibrateSettings.Character)
end

return Compressor