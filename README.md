# RBX-ANTIHOOK
A Advanced Roblox Luau Sandbox that protects from Hooks injected by executors, **WARNING**: IT MAY KICK YOU IF YOU USE HOOKS IN SCRIPTS!

# Implementation Guide
## 1. Server-Side Integration
Example:
```lua
local AntiHook = require(path.to.module)

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        local success, result = pcall(AntiHook.ScanForHooks)
        if not success or not result then
            player:Kick("Security violation (AH01)")
        end
    end)
end)
```
## 2. Client-Side Protection
Example:
```lua
local AntiHook = require(path.to.module)

-- Add random checks throughout your code
local function randomCheck()
    if math.random(1, 100) == 50 then
        AntiHook.ScanForHooks()
    end
end
```
