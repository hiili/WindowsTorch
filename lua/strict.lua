
local IGNORED_WRITES = {}
local IGNORED_READS = {
    qt=true,
    _PROMPT=true,
    _PROMPT2=true,
    writeObjects=true,
    arg=true,
}

-- Raises an error when an undeclared variable is read.
local function guardGlobals()
    assert(getmetatable(_G) == nil, "another global metatable exists")

    -- The detecting of undeclared vars is discussed on:
    -- http://www.lua.org/pil/14.2.html
    -- http://lua-users.org/wiki/DetectingUndefinedVariables
    setmetatable(_G, {
        __newindex = function (table, key, value)
            if not IGNORED_WRITES[key] then
                local info = debug.getinfo(2, "Sl")
                io.stderr:write(string.format(
                    "strict: %s:%s: write to undeclared variable: %s\n",
                    tostring(info.short_src), tostring(info.currentline), key))
            end
            rawset(table, key, value)
        end,
        __index = function (table, key)
            if IGNORED_READS[key] then
                return
            end
            error("attempt to read undeclared variable "..key, 2)
        end,
    })

    local origRequire = require
    function require(modname)
        IGNORED_WRITES[modname] = true
        return origRequire(modname)
    end
end

guardGlobals()
