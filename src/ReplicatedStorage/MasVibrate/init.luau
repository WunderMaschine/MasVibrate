--[[Hi!
  __  __        __   ___ _             _       
 |  \/  |__ _ __\ \ / (_) |__ _ _ __ _| |_ ___ 
 | |\/| / _` (_-<\ V /| | '_ \ '_/ _` |  _/ -_)
 |_|  |_\__,_/__/ \_/ |_|_.__/_| \__,_|\__\___|
I recommend reading the README and the documentation before using this module]]

--[]--[]-- MAIN MODULE --[]--[]--
local MasVibrate = {}

--[]--[]-- SETTINGS --[]--[]--
MasVibrate.Settings = {
    -- Master on/off switch
    Enabled = true,

    -- Default intensity/duration if none provided
    DefaultIntensity = 1,
    DefaultDuration = 0.5,

    -- Bounds for custom intensities
    MinIntensity = 0.1,
    MaxIntensity = 10,
    IntensityStep = 0.1,

    -- Smooth transitions
    SmoothingEnabled = false,
    SmoothingSpeed = 0.05,

    -- Fade options
    FadeInEnabled = false,
    FadeInDuration = 0.2,
    FadeOutEnabled = false,
    FadeOutDuration = 0.3,

    -- Pattern speed multiplier
    PatternSpeed = 1,

    -- Sound-based vibration
    Sound = {
        Enabled = true,
        Sensitivity = 1,
        MusicResponse = 1
    },

    -- Balanced vibration between left/right motors
    Balance = {
        Enabled = true,
        Intensity = 1,
        Sway = 0.5
    },

    -- Character-driven vibration
    Character = {
        Enabled = true,
        JumpIntensity = 1,
        DamageIntensity = 2,
        FallIntensity = 1
    }
}

--[]--[]-- DEPENDENCIES --[]--[]--
-- Assuming this script is directly inside the "MasVibrate" folder
-- and "Modules" is a sibling folder also under "MasVibrate".
local ModulesFolder = script:WaitForChild("Modules")
local SoundModule = require(ModulesFolder:WaitForChild("Sound"))
local BalanceModule = require(ModulesFolder:WaitForChild("Balance"))
local CharacterModule = require(ModulesFolder:WaitForChild("Character"))

local HapticService = game:GetService("HapticService")

--[]--[]-- INTERNAL BALANCE LOGIC --[]--[]--
local function handleBalance(bSettings, intensity, duration)
    BalanceModule.ApplyBalance(bSettings, intensity, duration)
    warn("[MasVibrate] Balance handled.")
end

--[]--[]-- SMOOTH VIBRATION --[]--[]--
local function handleSmoothVibration(currentIntensity, targetIntensity, speed)
    warn("[MasVibrate] Smooth transition from:", currentIntensity, "to:", targetIntensity)
end

--[]--[]-- GAMEPAD VIBRATION --[]--[]--
local function applyGamepadVibration(intensity, duration)
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor, intensity)
    end
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor, intensity)
    end

    task.delay(duration, function()
        if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor) then
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor, 0)
        end
        if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor) then
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor, 0)
        end
    end)
end

--[]--[]-- CONFIGURE --[]--[]--
function MasVibrate:Configure(settingsTable)
    for k, v in pairs(settingsTable) do
        if self.Settings[k] ~= nil then
            self.Settings[k] = v
        end
    end
    warn("[MasVibrate] Configure called.")
end

--[]--[]-- CORE VIBRATION --[]--[]--
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
    if self.Settings.Enabled then
        applyGamepadVibration(intensity, duration)
    end
    warn("[MasVibrate] Vibrate called with intensity:", intensity, "duration:", duration)
end

--[]--[]-- STOP VIBRATION --[]--[]--
function MasVibrate:Stop()
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor, 0)
    end
    if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor) then
        HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor, 0)
    end
    warn("[MasVibrate] Stop called.")
end

--[]--[]-- CUSTOM PATTERNS --[]--[]--
function MasVibrate:CustomVibration(pattern, customData)
    warn("[MasVibrate] CustomVibration with pattern:", pattern, "data:", customData)
    if self.Settings.Enabled then
        applyGamepadVibration(self.Settings.DefaultIntensity, self.Settings.DefaultDuration)
    end
end

function MasVibrate:PatternVibration(pattern, speed)
    warn("[MasVibrate] PatternVibration. Pattern:", pattern, "Speed:", speed)
end

--[]--[]-- FADE --[]--[]--
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
            if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor) then
                HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftMotor, 0)
            end
            if HapticService:IsMotorSupported(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor) then
                HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.RightMotor, 0)
            end
        end)
    end
end

--[]--[]-- SOUND & CHARACTER --[]--[]--
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

--[]--[]-- PLUGIN HANDLER --[]--[]--
function MasVibrate:Plugin(pluginName, command, ...)
    local actualName = pluginName
    if pluginName:match("^Plugin%-") then
        actualName = pluginName:gsub("^Plugin%-", "")
    elseif pluginName:match("^Plugin/") then
        actualName = pluginName:gsub("^Plugin/", "")
    end
    warn("[MasVibrate] Plugin invoked. Name:", actualName, "Command:", command, "Vars:", ...)
end

return MasVibrate