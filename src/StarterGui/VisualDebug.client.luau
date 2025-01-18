-- Experimental

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = require(ReplicatedStorage:WaitForChild("MasVibrate"):WaitForChild("Modules"))
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local gui = script.Parent:WaitForChild("VD_UI")
local circle = gui:WaitForChild("Circle")
local vibrate = circle:WaitForChild("Vibrate")
local numberLabel = vibrate:WaitForChild("Number")

local currentTween
local currentTextTween

local function tweenFrame(object, time, goal)
    if currentTween then
        currentTween:Cancel()
    end
    local info = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    currentTween = TweenService:Create(object, info, goal)
    currentTween:Play()
end

local function tweenTextTransparency(newValue, time)
    if currentTextTween then
        currentTextTween:Cancel()
    end
    local info = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    currentTextTween = TweenService:Create(numberLabel, info, { TextTransparency = newValue })
    currentTextTween:Play()
end

local function mapScale(total)
    if total <= 1 then
        return 0.1 + (total * 0.4)
    else
        local t = math.clamp((total - 1) / 4, 0, 1)
        return 0.5 + (0.5 * t)
    end
end

local function mapColor(total)
    if total > 5 then
        return Color3.fromRGB(255, 0, 255)
    end
    local pct = math.clamp(total / 5, 0, 1)
    return Color3.new(1, 1 - pct, 1 - pct)
end

local function mapTransparency(total)
    if total <= 1 then
        return 0.3 - (0.2 * total)
    else
        local t = math.clamp((total - 1) / 4, 0, 1)
        local val = 0.1 - (0.1 * t)
        return math.clamp(val, 0, 0.3)
    end
end

RunService.Heartbeat:Connect(function()
    local left, right = Modules:GetTotalIntensities() 
    local total = left + right

    local scale = mapScale(total)
    local color = mapColor(total)
    local transp = mapTransparency(total)

    numberLabel.Text = string.format("%.2f", total)
    local textAlpha = total == 0 and 1 or 0
    tweenTextTransparency(textAlpha, 0.15)

    local circleSizeX = circle.AbsoluteSize.X
    local vibrateSizeX = vibrate.AbsoluteSize.X * scale
    local diff = right - left
    local maxOffset = (circleSizeX - vibrateSizeX) * 0.5
    local offset = math.clamp(diff * 10, -maxOffset, maxOffset)

    local pos = UDim2.new(0.5, offset, 0.5, 0)
    local size = UDim2.new(scale, 0, scale, 0)

    if total >= 0.3 then
        local shakeX = math.random(-4, 4)
        local shakeY = math.random(-4, 4)
        local finalPos = UDim2.new(0.5, offset + shakeX, 0.5, shakeY)
        local time = total < 1 and 0.12 or 0.08
        tweenFrame(vibrate, time, {
            Size = size,
            Position = finalPos,
            BackgroundColor3 = color,
            BackgroundTransparency = transp
        })
    else
        tweenFrame(vibrate, 0.15, {
            Size = size,
            Position = pos,
            BackgroundColor3 = color,
            BackgroundTransparency = transp
        })
    end
end)