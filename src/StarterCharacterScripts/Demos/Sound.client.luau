local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MasVibrate = require(ReplicatedStorage:WaitForChild("MasVibrate"))

local function attachSound(soundObj)
    if not soundObj:IsA("Sound") then
        return
    end

    local function triggerVibration()
        if soundObj.IsPlaying then
            MasVibrate:Plugin("Sound", "Trigger", {
                Volume = soundObj.Volume,
                MasVibrateSettings = MasVibrate.Settings
            })
        end
    end

    if soundObj.IsPlaying then
        triggerVibration()
    end

    soundObj.Changed:Connect(function(property)
        if property == "IsPlaying" or property == "Volume" then
            triggerVibration()
        end
    end)
end

for _, descendant in ipairs(SoundService:GetDescendants()) do
    attachSound(descendant)
end

SoundService.DescendantAdded:Connect(function(newDescendant)
    attachSound(newDescendant)
end)