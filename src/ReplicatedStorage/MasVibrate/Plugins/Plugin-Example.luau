local PluginExample = {}

local Modules = require(script.Parent.Parent.Modules)


function PluginExample:Trigger(pluginData)
    -- This is where your plugin logic goes
end

function PluginExample:Stop()
    -- Use this to cleanup or stop any ongoing effects
end

return PluginExample