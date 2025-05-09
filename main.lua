--[[
Advanced Roblox Luau Hook Injection Protection

version 1.1 alpha
--]]

local AntiHook = {
  _VERSION = "1.1",
  _SIGNATURE = "ARLHP-"..math.random(10000, 99999),
  _HASHMAP = {}
}

do
  -- Lock critical functions
  local function LockFunction(f, name)
      local original = f
      AntiHook._HASHMAP[name] = {original = original, hash = tostring(original):match("function: (%w+)")}

      return setmetatable({}, {
          __call = function(_, ...)
              return original(...)
          end,
          __index = function(_, k)
              return original[k]
          end,
          __newindex = function()
              error("[ARLHP] Attempt to modify a protected function: "..name, 2)
          end,
          __metatable = "Locked"
      })
  end

  getgenv().print = LockFunction(print, "print")
  getgenv().require = LockFunction(require, "require")
  getgenv().getfenv = LockFunction(getfenv, "getfenv")
end

function AntiHook.ScanForHooks()
    -- SIMPLIFIED!!!
    local suspiciousPatterns = {
        ["hookfunction"] = true,
        ["detour"] = true,
        ["hook"] = true,
        ["inject"] = true
    }

    local executorSignatures = {
        ["Synapse"] = {
            memcheck = {"A0 01 00 57 48 8D 0D", "FF 15 ?? ?? ?? ?? 48 8B F8"},
            envcheck = {"getscriptbytecode", "getscriptclosure"}
        },
        ["ScriptWare"] = {
            memcheck = {"48 8B 05 ?? ?? ?? ?? 48 85 C0 74 0A"},
            envcheck = {"sw_getgc", "sw_getinstances"}
        }
    }

    for name, data in pairs(AntiHook._HASHMAP) do
        local current = _G[name] or getgenv()[name]
        if tostring(current):match("function: (%w+)") ~= data.hash then
            return false, "Function hook detected: "..name
        end
    end

    for _, sigList in pairs(executorSignatures) do
        for _, v in ipairs(sigList.envcheck) do
            if getgenv()[v] ~= nil then
                return false, "Executor environment detected"
            end
        end
    end

    return true
end

--[[
Obfuscation (remove if needed)
--]]
(function()
    local key = AntiHook._SIGNATURE
    local function validate()
        if getgenv()._AHK_KEY ~= key then
            game:GetService("Players").LocalPlayer:Kick("AntiHook Script tampering detected")
        end
    end

    getgenv()._AHK_KEY = key
    validate()

    for i = 1, 5 do
        task.delay(math.random(10, 30), validate)
    end
end)()

return AntiHook
