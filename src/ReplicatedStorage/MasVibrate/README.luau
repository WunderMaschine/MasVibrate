--[[
  __  __        __      ___ _               _       
 |  \/  |       \ \    / (_) |             | |      
 | \  / | __ _ __\ \  / / _| |__  _ __ __ _| |_ ___ 
 | |\/| |/ _` / __\ \/ / | | '_ \| '__/ _` | __/ _ \
 | |  | | (_| \__ \\  /  | | |_) | | | (_| | ||  __/
 |_|  |_|\__,_|___/ \/   |_|_.__/|_|  \__,_|\__\___|
 Made by: WunderMaschine


 DO NOT DELETE THIS FILE  DO NOT DELETE THIS FILE  DO NOT DELETE THIS FILE  DO NOT DELETE THIS FILE


This project is designed to create an advanced vibration and feedback system in Roblox.
Below is an overview of how each part works, presented clearly so you can adapt and expand it as needed.

--------------------------------------------------------------------------------
1) FOLDER AND MODULE STRUCTURE
--------------------------------------------------------------------------------
• MasVibrate:
  - The main module housing core settings (Settings) and providing essential methods 
    (Configure, Vibrate, Stop). 
  - Integrates with other modules through the central Modules script.
  - You can load custom plugins via its Plugin method.

• Modules:
  - The core script handling all actual vibration logic. 
  - Accepts intensity and duration, processes them (optionally via Balance and Compressor),
    and applies them to the gamepad motors.

• Compressor:
  - Validates settings by clamping values (e.g., intensities, durations) to prevent 
    errors or illogical behavior.
  - Called before any major vibration to ensure consistency.

• Balance:
  - Distributes vibration intensity between left and right motors. 
  - Uses parameters like Sway, Intensity and Duration to give a realistic, split feel.
  - Kicks in when Balance.Enabled is true.

• Plugins (e.g., Plugin-Character, Plugin-Sound, Plugin-Example):
  - Extend MasVibrate’s functionality. Each plugin provides Trigger (to execute its logic) 
    and Stop (to halt effects).
  - Useful for adding targeted features like character-based or sound-based vibrations.

--------------------------------------------------------------------------------
2) USAGE STEPS
--------------------------------------------------------------------------------
• Set up or override the default configuration:
  MasVibrate:Configure({
      Enabled = true,
      DefaultIntensity = 2,
      Balance = {
          Enabled = false,
          Sway = 0.3,
          Intensity = 1.5
      }
      -- etc.
  })

• Trigger vibration:
  MasVibrate:Vibrate(3, 1)
  -- Vibrates at intensity 3 for 1 second (both motors by default).

• Select a specific motor:
  MasVibrate:Vibrate(3, 1, "small")
  -- Vibrates only the small motor at intensity 3 for 1 second.
  MasVibrate:Vibrate(3, 1, "large")
  -- Vibrates only the large motor.
  MasVibrate:Vibrate(3, 1, "both")
  -- Vibrates both motors.

• Stop vibration:
  MasVibrate:Stop()
  -- Immediately ends any active vibration.

• Call a plugin (example):
  MasVibrate:Plugin("Character", "Trigger", {
      EventName = "Damage",
      Value = 20,
      Settings = MasVibrate.Settings
  })
  -- Calls the Damage event with intensity based on the passed value.

--------------------------------------------------------------------------------
3) EXAMPLE SCENARIOS
--------------------------------------------------------------------------------
• Increasing vibration as a character jumps higher.
• Intensifying vibration when in-game sounds get louder.
• Constant subtle vibration when a character’s health is low.

--------------------------------------------------------------------------------
4) EXTENSIBILITY AND MAINTENANCE
--------------------------------------------------------------------------------
• Each module focuses on a single responsibility. Compressor reduces errors by validating 
  incoming settings, Balance orchestrates left/right distribution, etc.
• The plugin system makes it easy to add new vibration scenarios without modifying the 
  main code.
• The code is structured to minimize coupling, so changes in one module rarely break others.

--------------------------------------------------------------------------------
5) PERFORMANCE TIPS
--------------------------------------------------------------------------------
• Don’t trigger vibrations excessively in tight loops; it can be resource-heavy.
• Also you can give me some feedback on how to improve this system, for better performance..

--------------------------------------------------------------------------------
6) CONCLUSION
--------------------------------------------------------------------------------
With this system, you can add dynamic, powerful vibration feedback to your Roblox game.
The modular design and plugin interface make it easy to expand, customize and maintain 
over time. Future integrationscan also be implemented without overhauling the entire setup.

--------------------------------------------------------------------------------
7) EASIER SOLUTION
--------------------------------------------------------------------------------
If you prefer something simpler or don’t need all the advanced functionality, consider 
using EasyVibrate. It’s a more streamlined module that focuses on quickly triggering 
vibrations. You simply call something like `EasyVibrate:Vibrate(intensity, duration)` 
without worrying about compressors, balance distribution or plugins. It’s perfect for 
smaller projects or quick prototypes.

EasyVibration's github link: https://github.com/WunderMaschine/EasyVibration

--------------------------------------------------------------------------------
--]]

return 'V0.2'