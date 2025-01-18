<p align="center">
  <img src="https://i.imgur.com/OUGbqz4.png" alt="Cool Banner" width="400" />
</p>

<p align="center">
  <!-- DevForum Post -->
  <a href="https://devforum.roblox.com/t/gonna-change">
    <img src="https://img.shields.io/badge/DevForum-Post-blue?logo=roblox" alt="DevForum Link" />
  </a>
  
  <!-- Demo -->
  <a href="https://www.roblox.com/games/135589604350394/MasVibrate-Demo">
    <img src="https://img.shields.io/badge/Demo-Play%20Now!-success?logo=roblox" alt="Demo" />
  </a>
  
  <!-- Roblox Model -->
  <a href="https://create.roblox.com/store/asset/85029294074147/MasVibrate">
    <img src="https://img.shields.io/badge/Roblox%20Model-Get%20It-green?logo=roblox" alt="Roblox Model" />
  </a>
  
  <!-- Main Release -->
  <a href="https://github.com/WunderMaschine/MasVibrate">
    <img src="https://img.shields.io/badge/Main%20Release-GitHub-blue" alt="Main Release" />
  </a>
  
  <!-- RAW Release -->
  <a href="https://github.com/WunderMaschine/MasVibrate/tree/raw">
    <img src="https://img.shields.io/badge/Raw%20Release-GitHub-lightgrey" alt="Raw Release" />
  </a>
  
  <!-- Demo Release -->
  <a href="https://github.com/WunderMaschine/MasVibrate/tree/demo-experience">
    <img src="https://img.shields.io/badge/Demo%20Source-GitHub-yellow" alt="Demo Source" />
  </a>
  
  <!-- GitHub Wiki -->
  <a href="https://github.com/WunderMaschine/MasVibrate/wiki">
    <img src="https://img.shields.io/badge/GitHub%20Wiki-Documentation-blue?logo=github" alt="GitHub Wiki" />
  </a>
  
  <!-- Discord Server -->
  <a href="https://discord.gg/9eT6MpxgX6">
    <img src="https://img.shields.io/badge/Discord-Join%20Server-7289DA?logo=discord" alt="Discord Server" />
  </a>
</p>

<h1 align="center">MasVibrate &mdash; Advanced Vibration Module for Roblox</h1>

> **What is MasVibrate?**  
> MasVibrate is a powerful, multi-channel haptic feedback system designed for Roblox. It streamlines the process of creating, managing and combining various vibration sources &mdash; whether it’s your character jumping, your music’s loudness or anything else.

---

## ✨ Why Is Vibration Important?
- **Immersion:** Subtle rumbles add realism to your actions, making every jump, collision, or hit more pronounced and memorable.  
- **Feedback & Polish:** Vibrations give players immediate tactile confirmation, pushing your game closer to an AAA feel.  
- **Player Engagement:** Properly tuned haptic cues boost the fun factor, keeping gamers more connected to the action.

### I know it sounds a bit overused but trust me, vibration is **magic**. Give it a try in your game and see how your players react.

---

## 🤔 Why Use MasVibrate Instead of Building Your Own?
1. **Plugin-Friendly:** MasVibrate supports a plugin system, so you can easily add new vibration triggers without rewriting core code.  
2. **Multi-Channel Logic:** Different events won’t override each other’s vibrations. You can have background music-based shakes **and** intense explosions at the same time.  
3. **Balance & Compressor:** Built-in modules that automatically split intensities left/right (`Balance`) and clamp or validate values (`Compressor`) so you don’t have to.  
4. **Ease & Flexibility:** A straightforward API (`Vibrate`, `Stop`, and optional advanced methods) that can be customized for any scenario.

---

## 🚀 Highlights
- **Advanced API** &mdash; Simple calls like `Vibrate(intensity, duration, motorChoice, channel)` plus optional advanced methods (`FadeIn`, `FadeOut`, `CustomVibration`)  
- **Separate Channels** &mdash; Sound? Character? UI? Keep them distinct yet running simultaneously.  
- **Optional Plugins** &mdash; For character-based events, audio loudness, or anything else you can dream up.  
- **Multiple Versions** &mdash; From minimal “raw” usage to a fully functional demo.

---

## 🏷 Branches (Versions)

 * **[main](https://github.com/WunderMaschine/MasVibrate)**  
   Contains the core modules (`MasVibrate`, `Modules`, `Compressor`, `Balance`) plus main plugins.  
   - No LocalScripts from demo here.
  
 * **[raw](https://github.com/WunderMaschine/MasVibrate/tree/raw)**  
   Stripped to the absolute essentials.  
   - Use this if you want minimal overhead, doesn't have plugins and LocalScripts.

 * **[demo-experience](https://github.com/WunderMaschine/MasVibrate/tree/demo-experience)**  
   A complete, ready-to-test environment.  
   - Includes LocalScripts for Sound-based vibrations, Character jump/fall, damage and even a VisualDebug UI.

---

## Easier Alternative: [EasyVibration](https://github.com/WunderMaschine/EasyVibration)
If you only need a simple, single-channel approach without multi-channel logic or plugins, consider **EasyVibration** &mdash; a smaller, streamlined module for easier methods. It won’t match the full power of MasVibrate but can be sufficient for simpler projects.

---

# 📦 Installation & Configure
1. **Clone** or **Download** the branch you prefer (usually `main`) into your Roblox project.  
2. Place the `MasVibrate` folder inside `ReplicatedStorage` or a similar accessible place.
3. Require and configure:

```lua
local MasVibrate = require(game.ReplicatedStorage.MasVibrate)

MasVibrate:Configure({
    Enabled = true,
    DefaultIntensity = 1.5,
    DefaultDuration = 0.5,
    MinIntensity = 0.1,
    MaxIntensity = 10,
    Balance = {
        Enabled = false,
        Intensity = 1,
        Sway = 0.3
    }
})
```



# Basic Usage
### Please read the [Wiki](https://github.com/WunderMaschine/MasVibrate/wiki) for advanced usage.


## Single Vibration

```luau
MasVibrate:Vibrate(2, 1)
```

 * Applies intensity=2 for 1 second on the default channel.
 * If motorChoice or channelName are not specified, the system uses defaults ("both" motors, “default” channel).

## Using Channels and motorChoice

```luau
MasVibrate:Vibrate(1.5, 2, "small", "Sound")
```

 * Creates a vibration of intensity=1.5 for 2 seconds on a channel named "Sound".
 * Only the small motor is used (motorChoice="small").

## Stopping Vibrations

```luau
MasVibrate:Stop()         -- stops default channel
MasVibrate:Stop("Sound")  -- stops the 'Sound' channel
```

 * Ends any vibration on the given channel name.
 * Multiple channels can coexist, so you must specify a channel if it’s not the default.

## FadeIn / FadeOut

### FadeIn

```luau
MasVibrate:FadeIn(3, 1.5, "both", "FadeChannel")
```
 * Gradually ramps up to intensity=3 over 1.5 seconds on “FadeChannel”.
 * Requires FadeInEnabled = true in your config.

### FadeOut

```luau
MasVibrate:FadeOut(2, "FadeChannel")
```
 * After 2 seconds, stops “FadeChannel”.
 * Requires FadeOutEnabled = true.

## Plugins

```luau
MasVibrate:Plugin("Character", "Trigger", {
    EventName = "Jump",
    Value = 50,
    MasVibrateSettings = MasVibrate.Settings
})
```

 * Invokes the “Trigger” method of a plugin named "Character".
 * Typically, the plugin calculates an intensity/duration based on EventName (e.g., “Jump”) and calls Modules:Apply(...) under the hood.

## To stop:

```luau
MasVibrate:Plugin("Character", "Stop")
```
* Ends whatever vibration the “Character” plugin created (e.g., on a “Character” channel).

## CustomVibration / PatternVibration

```luau
MasVibrate:CustomVibration("MyPattern", { debug=true }, "both", "CustomChan")
MasVibrate:PatternVibration("BurstPattern", 2, "small", "BurstChan")
```

 * These methods are scaffolding for more specialized patterns.
 * By default, they use the module’s DefaultIntensity/DefaultDuration unless you modify the underlying “Modules” logic or create a plugin that interprets these calls.

# 💸 Donation (Roblox T-Shirts)
### If you’d like to support continued development, feel free to grab one of these T-shirts via Roblox:

[**42** Robux, *Black*](https://www.roblox.com/catalog/116087743551881/MASCHINE-Black-Badge) / [**42** Robux, *White*](https://www.roblox.com/catalog/77484695213270/MASCHINE-White-Badge)

[**250** Robux](https://www.roblox.com/catalog/103095483509247/Event25-Badge)

[**1,010** Robux](https://www.roblox.com/catalog/6976397774/KoN-0-1-Cover)

[**2,400** Robux](https://www.roblox.com/catalog/17515799506/Collection-OG-KoN-font-X-Event24-colors)

[**4,200** Robux](https://www.roblox.com/catalog/95183425347423/MASCHINE-Special-Badge)

[**42,000** Robux](https://www.roblox.com/catalog/112188857442147/Maschine-X-Mas-Mei)



**Your donations keep my projects thriving, ensuring steady development and success.**



<div align="center">
  <h2>Enjoy Using MasVibrate!</h2>
  <p>Empower your Roblox experiences with advanced, multi-channel vibrations.</p>
</div>
