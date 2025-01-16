local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MasVibrate = require(ReplicatedStorage:WaitForChild("MasVibrate"))

local function shortWait(seconds)
    task.wait(seconds)
end

task.spawn(function()
    while true do
        warn("===== LOOP TEST: Basic Vibrate (both) =====")
        MasVibrate:Vibrate(2, 1, "both")
        shortWait(2)

        warn("===== LOOP TEST: Small Motor Only =====")
        MasVibrate:Vibrate(3, 1, "small")
        shortWait(2)

        warn("===== LOOP TEST: Large Motor Only =====")
        MasVibrate:Vibrate(4, 1, "large")
        shortWait(2)

        warn("===== LOOP TEST: Balance with Vibrate(3, 2) =====")
        MasVibrate:Configure({
            Balance = {
                Enabled = true,
                Sway = 0.3,
                Intensity = 1
            }
        })
        MasVibrate:Vibrate(3, 2, "both")
        shortWait(3)  -- Wait for extra second

        warn("===== LOOP TEST: FadeIn -> FadeOut =====")
        MasVibrate:FadeIn(3, 1, "both")
        shortWait(2)
        MasVibrate:FadeOut(1)
        shortWait(2)

        warn("===== LOOP TEST: Stop Mid-Vibration =====")
        MasVibrate:Vibrate(4, 3, "both")
        shortWait(1)
        MasVibrate:Stop()
        shortWait(2)

        warn("===== LOOP TEST: CustomVibration =====")
        MasVibrate:CustomVibration("PatternFoo", { debug = true }, "both")
        shortWait(2)

        warn("===== LOOP TEST: PatternVibration =====")
        MasVibrate:PatternVibration("PatternBar", 1, "both")
        shortWait(2)

        warn("===== LOOP TEST: Plugin - Sound =====")
        MasVibrate:Plugin("Plugin-Sound", "Trigger", {
            Volume = 5, 
            MasVibrateSettings = MasVibrate.Settings,
            MotorChoice = "small"
        })
        shortWait(2)

        warn("===== LOOP TEST: Plugin - Character (Jump) =====")
        MasVibrate:Plugin("Plugin-Character", "Trigger", {
            EventName = "Jump",
            Value = 80, 
            MasVibrateSettings = MasVibrate.Settings
        })
        shortWait(2)

        warn("===== LOOP TEST: Character (Damage) =====")
        MasVibrate:Plugin("Plugin-Character", "Trigger", {
            EventName = "Damage",
            Value = 15,
            MasVibrateSettings = MasVibrate.Settings,
            MotorChoice = "large"
        })
        shortWait(2)

        warn("===== LOOP TEST: Character (Fall) =====")
        MasVibrate:Plugin("Plugin-Character", "Trigger", {
            EventName = "Fall",
            Value = 20,
            MasVibrateSettings = MasVibrate.Settings
        })
        shortWait(2)

        warn("===== END OF A LOOP, RESTARTING IN 2s =====")
        shortWait(2)
    end
end)