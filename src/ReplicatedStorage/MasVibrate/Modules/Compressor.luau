local Compressor = {}

local function clampValue(v, mn, mx)
    if v < mn then
        return mn
    elseif v > mx then
        return mx
    end
    return v
end

local function ensureMinMax(s)
    if s.MinIntensity > s.MaxIntensity then
        local tmp = s.MinIntensity
        s.MinIntensity = s.MaxIntensity
        s.MaxIntensity = tmp
    end
end

local function isBoolean(x)
    return type(x) == "boolean"
end

local function isNumber(x)
    return type(x) == "number"
end

local function checkBalanceTable(tbl)
    if type(tbl) ~= "table" then
        return {
            Enabled = true,
            Intensity = 1,
            Sway = 0.5
        }
    end
    return tbl
end

function Compressor:CheckGeneral(s)
    ensureMinMax(s)
    if not isBoolean(s.Enabled) then
        s.Enabled = false
    end
    s.DefaultIntensity = clampValue(s.DefaultIntensity, s.MinIntensity, s.MaxIntensity)
    s.DefaultDuration = math.max(s.DefaultDuration, 0)
    if not isBoolean(s.SmoothingEnabled) then
        s.SmoothingEnabled = false
    end
    if not isNumber(s.SmoothingSpeed) then
        s.SmoothingSpeed = 0.05
    else
        s.SmoothingSpeed = math.max(s.SmoothingSpeed, 0)
    end
    if not isBoolean(s.FadeInEnabled) then
        s.FadeInEnabled = false
    end
    s.FadeInDuration = clampValue(s.FadeInDuration, 0, s.DefaultDuration)
    if not isBoolean(s.FadeOutEnabled) then
        s.FadeOutEnabled = false
    end
    s.FadeOutDuration = clampValue(s.FadeOutDuration, 0, s.DefaultDuration)
    if not isNumber(s.PatternSpeed) then
        s.PatternSpeed = 1
    else
        s.PatternSpeed = math.max(s.PatternSpeed, 0)
    end
end

function Compressor:CheckBalanceData(b)
    if not b.Enabled then
        return
    end
    if not isNumber(b.Intensity) then
        b.Intensity = 1
    else
        b.Intensity = math.max(b.Intensity, 0)
    end
    if not isNumber(b.Sway) then
        b.Sway = 0.5
    else
        b.Sway = math.clamp(b.Sway, 0, 1)
    end
end

function Compressor:CompressAll(settings)
    if not settings then
        return
    end
    settings.Balance = checkBalanceTable(settings.Balance)
    self:CheckGeneral(settings)
    self:CheckBalanceData(settings.Balance)
end

return Compressor