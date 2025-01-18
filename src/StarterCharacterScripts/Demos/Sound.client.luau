local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MasVibrate = require(ReplicatedStorage:WaitForChild("MasVibrate"))
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

local function attachSound(soundObj)
    if not soundObj:IsA("Sound") then return end

    local function trigger()
        if soundObj.IsPlaying then
            local loudness = soundObj.PlaybackLoudness or 0
            if loudness > 0 then
                local mappedHeight = math.clamp(loudness / 100, 0, 50)
                MasVibrate:Plugin("Sound", "Trigger", {
                    Height = mappedHeight,
                    MasVibrateSettings = MasVibrate.Settings
                })
                return
            end
        end
        MasVibrate:Stop("Sound")
    end

    local function onHeartbeat()
        if soundObj.IsPlaying then
            trigger()
        end
    end

    if soundObj.IsPlaying then
        trigger()
    end

    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not soundObj or not soundObj.Parent then
            conn:Disconnect()
            MasVibrate:Stop("Sound")
            return
        end
        onHeartbeat()
    end)

    soundObj.Changed:Connect(function(prop)
        if prop == "IsPlaying" and not soundObj.IsPlaying then
            MasVibrate:Stop("Sound")
        end
    end)
end

for _, obj in ipairs(workspace:GetDescendants()) do
    attachSound(obj)
end
workspace.DescendantAdded:Connect(attachSound)

for _, obj in ipairs(SoundService:GetDescendants()) do
    attachSound(obj)
end
SoundService.DescendantAdded:Connect(attachSound)