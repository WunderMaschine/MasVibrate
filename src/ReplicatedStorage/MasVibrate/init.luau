--[[Hi!
  __  __        __   ___ _             _       
 |  \/  |__ _ __\ \ / (_) |__ _ _ __ _| |_ ___ 
 | |\/| / _` (_-<\ V /| | '_ \ '_/ _` |  _/ -_)
 |_|  |_\__,_/__/ \_/ |_|_.__/_| \__,_|\__\___|
I recommend reading the README and the documentation before using this module]]

local MasVibrate = {}

--[]--[]-- SETTINGS --[]--[]--
MasVibrate.Settings = {
    Enabled = true,
    DefaultIntensity = 1,
    DefaultDuration = 0.5,
    MinIntensity = 0.1,
    MaxIntensity = 10,
    IntensityStep = 0.1,

    SmoothingEnabled = false,
    SmoothingSpeed = 0.05,
    FadeInEnabled = false,
    FadeInDuration = 0.2,
    FadeOutEnabled = false,
    FadeOutDuration = 0.3,
    PatternSpeed = 1,

    Sound = {
        Enabled = true,
        Sensitivity = 1,
        MusicResponse = 1
    },

    Balance = {
        Enabled = true,
        Intensity = 1,
        Sway = 0.5
    },

    Character = {
        Enabled = true,
        JumpIntensity = 1,
        DamageIntensity = 2,
        FallIntensity = 1
    }
}

-- Pretend these modules exist in the same folder
local SoundModule = require(script.Parent.Sound)
local BalanceModule = require(script.Parent.Balance)
local CharacterModule = require(script.Parent.Character)

local HapticService = game:GetService("HapticService")

-- Local function to handle balance calculations
local function handleBalance(bSettings, intensity, duration)
    BalanceModule.ApplyBalance(bSettings, intensity, duration)
    warn("[MasVibrate] Balance handled.")
end

-- Local function to handle smooth transitions
local function handleSmoothVibration(currentIntensity, targetIntensity, speed)
    warn("[MasVibrate] Smooth transition from:", currentIntensity, "to:", targetIntensity)
end

-- Helper function to apply actual haptic feedback via HapticService
local function applyGamepadVibration(intensity, duration)
    -- Example: Use left/right trigger for gamepad
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftTrigger) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftTrigger, intensity)
    end

    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightTrigger) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightTrigger, intensity)
    end

    -- Clear vibration after duration
    task.delay(duration, function()
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftTrigger, 0)
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightTrigger, 0)
    end)
end

--[]--[]-- CONFIGURE SETTINGS --[]--[]--
function MasVibrate:Configure(settingsTable)
    for k, v in pairs(settingsTable) do
        if self.Settings[k] ~= nil then
            self.Settings[k] = v
        end
    end
    warn("[MasVibrate] Configure called.")
end

--[]--[]-- BASIC VIBRATION --[]--[]--
function MasVibrate:Vibrate(intensity, duration)
    if self.Settings.Balance.Enabled then
        handleBalance(self.Settings.Balance, intensity, duration)
    end

    if self.Settings.Sound.Enabled then
        SoundModule.TriggerSoundVibration(self.Settings.Sound, intensity, duration)
        warn("[MasVibrate] Sound vibration triggered.")
    end

    if self.Settings.SmoothingEnabled then
        handleSmoothVibration(self.Settings.DefaultIntensity, intensity, self.Settings.SmoothingSpeed)
    end

    -- Apply the haptic feedback using Roblox's HapticService
    if self.Settings.Enabled then
        applyGamepadVibration(intensity, duration)
    end

    warn("[MasVibrate] Vibrate called with intensity:", intensity, "duration:", duration)
end

function MasVibrate:Stop()
    -- Cancel or reset any vibration
    HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftTrigger, 0)
    HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightTrigger, 0)
    warn("[MasVibrate] Stop called.")
end

--[]--[]-- CUSTOM PATTERNS --[]--[]--
function MasVibrate:CustomVibration(pattern, customData)
    warn("[MasVibrate] CustomVibration with pattern:", pattern, "data:", customData)
    -- Example: Possibly apply different intensities over time or separate motors
    if self.Settings.Enabled then
        applyGamepadVibration(self.Settings.DefaultIntensity, self.Settings.DefaultDuration)
    end
end

--[]--[]-- PATTERN & FADE FUNCTIONS --[]--[]--
function MasVibrate:PatternVibration(pattern, speed)
    warn("[MasVibrate] PatternVibration. Pattern:", pattern, "Speed:", speed)
    -- Could iterate over pattern steps and apply vibrations
end

function MasVibrate:FadeIn(intensity, duration)
    warn("[MasVibrate] FadeIn. Intensity:", intensity, "Duration:", duration)
    if self.Settings.FadeInEnabled and self.Settings.Enabled then
        applyGamepadVibration(intensity, duration)
    end
end

function MasVibrate:FadeOut(duration)
    warn("[MasVibrate] FadeOut. Duration:", duration)
    if self.Settings.FadeOutEnabled then
        task.delay(duration, function()
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftTrigger, 0)
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightTrigger, 0)
        end)
    end
end

--[]--[]-- SPECIALIZED MODULE TRIGGERS --[]--[]--
function MasVibrate:SoundVibration(soundLevel)
    SoundModule.TriggerSoundVibration(self.Settings.Sound, soundLevel, 0.5)
    if self.Settings.Enabled then
        applyGamepadVibration(soundLevel, 0.5)
    end
    warn("[MasVibrate] SoundVibration. Level:", soundLevel)
end

function MasVibrate:CharacterVibration(eventName, value)
    if self.Settings.Character.Enabled then
        CharacterModule.TriggerCharacterVibration(eventName, value, self.Settings.Character)
    end
    if self.Settings.Enabled then
        applyGamepadVibration(value, 0.3)
    end
    warn("[MasVibrate] CharacterVibration. Event:", eventName, "Value:", value)
end

return MasVibrate