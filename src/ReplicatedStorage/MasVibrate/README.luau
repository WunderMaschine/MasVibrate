--[[
  __  __        __      ___ _               _       
 |  \/  |       \ \    / (_) |             | |      
 | \  / | __ _ __\ \  / / _| |__  _ __ __ _| |_ ___ 
 | |\/| |/ _` / __\ \/ / | | '_ \| '__/ _` | __/ _ \
 | |  | | (_| \__ \\  /  | | |_) | | | (_| | ||  __/
 |_|  |_|\__,_|___/ \/   |_|_.__/|_|  \__,_|\__\___|
 Made by: WunderMaschine

 MasVibrate's GitHub Link: https://github.com/WunderMaschine/MasVibrate

DO NOT DELETE THIS FILE  DO NOT DELETE THIS FILE  DO NOT DELETE THIS FILE  DO NOT DELETE THIS FILE


MasVibrate is an advanced, multi-channel vibration (haptic feedback) system for Roblox.
Below you will find detailed information about how the system is structured, how to use it,
and how you can extend it.

--------------------------------------------------------------------------------
1) FOLDER AND MODULE STRUCTURE
--------------------------------------------------------------------------------
• MasVibrate:
  - The main module with core Settings and methods (Configure, Vibrate, Stop, etc.).
  - Integrates with a central "Modules" script for final motor control.
  - Can load extra plugins via :Plugin(name, command, data).

• Modules:
  - Handles the core vibration logic and manages multiple channels. 
  - Each channel can run its own vibration without overriding others.
  - Balances and sums intensities from all channels, applying them to the gamepad motors.

• Compressor:
  - Validates settings, ensuring intensities, durations, and other values stay logical.
  - Doesn't handle multi-channel logic, just clamps and checks numeric ranges.

• Balance:
  - Splits or transforms an intensity into left/right values, based on parameters like Sway.
  - Returns calculated left/right intensities to "Modules," which merges them into the overall system.

• Plugins (e.g., Character, Sound, etc.):
  - Extend MasVibrate’s functionality for specific use-cases.
  - Each plugin has Trigger(...) and Stop(...) methods.
  - Examples:
    - Character plugin responds to Jump, Damage, Fall etc.
    - Sound plugin responds to volume or loudness changes.

--------------------------------------------------------------------------------
2) USAGE STEPS (MULTI-CHANNEL)
--------------------------------------------------------------------------------
• Basic Config:
  MasVibrate:Configure({
      Enabled = true,
      DefaultIntensity = 2,
      Balance = {
          Enabled = true,
          Sway = 0.3,
          Intensity = 1.5
      }
      -- etc.
  })

• Vibrate:
  MasVibrate:Vibrate(3, 1, "both", "MyChannel")
  - Intensity=3, Duration=1 second, Motor="both", Channel="MyChannel"
  - If you omit "MyChannel," it defaults to "Default" channel.
  - Multi-channel means multiple vibrations can coexist without overwriting each other.

• Stop:
  MasVibrate:Stop("MyChannel")
  - Stops only that channel’s vibration. If other channels are active, they continue.

• Motor Choice:
  - "small" => affects only the small motor
  - "large" => affects only the large motor
  - "both" => uses both motors

• Plugins:
  MasVibrate:Plugin("Character", "Trigger", {
      EventName = "Damage",
      Value = 20,
      MasVibrateSettings = MasVibrate.Settings
  })
  - Calls the “Damage” event inside the Character plugin. 
  - Plugin logic calculates final intensity, then calls Modules:Apply(...) on its own channel.

• FadeIn / FadeOut:
  MasVibrate:FadeIn(3, 2, "both", "SomeChannel")
  - Gradually applies a vibration. 
  MasVibrate:FadeOut(2, "SomeChannel")
  - Delays 2 seconds before clearing that channel.

--------------------------------------------------------------------------------
3) EXAMPLE SCENARIOS
--------------------------------------------------------------------------------
• Multiple vibrations: a "Sound" plugin with background music, plus a "Character" plugin for jump or damage events, each on separate channels. 
• Fine-tuning “Balance” to shift the intensity left/right for more realism.
• Combining multiple channels: e.g. “Sound” channel + “Character” channel => the final motor intensities are summed.

--------------------------------------------------------------------------------
4) EXTENSIBILITY AND MAINTENANCE
--------------------------------------------------------------------------------
• Compressor focuses on clamping and validation. 
• Balance purely calculates left/right intensities, no direct motor calls.
• Modules merges intensities from all channels, sums or maxes them, and sets the gamepad motors.
• Plugins add specialized logic for unique gameplay elements or feedback scenarios.

--------------------------------------------------------------------------------
5) PERFORMANCE TIPS
--------------------------------------------------------------------------------
• Avoid calling Vibrate or Plugin triggers every frame in a tight loop. 
• Multi-channel logic is more complex, so keep an eye on how often you start new vibrations or recalculate them.
• Use short durations or checks to ensure you’re not constantly overriding the same channel unnecessarily.

--------------------------------------------------------------------------------
6) CONCLUSION
--------------------------------------------------------------------------------
With this multi-channel design, you can run multiple vibrations simultaneously. 
Each plugin or system can manage its own channel, letting them stack or merge intensities 
instead of overwriting one another.

--------------------------------------------------------------------------------
7) EASIER SOLUTION
--------------------------------------------------------------------------------
If you only need a single basic vibration at a time (no multi-channel features rn), consider 
using my EasyVibrate module. It’s simpler, focusing on quick vibrations (intensity, duration) 
without advanced features like balance or plugins (gonna add plugin tho, but simpler).

EasyVibration's GitHub Link: https://github.com/WunderMaschine/EasyVibration

--------------------------------------------------------------------------------
--]]

return 'V1'