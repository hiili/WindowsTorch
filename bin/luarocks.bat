::rem:: --[[
@setlocal&  set PATH=C:/torch/bin;%PATH% & set luafile="%~f0" & if exist "%~f0.bat" set luafile="%~f0.bat"
@C:/torch/bin/luajit.exe %luafile% %*&  exit /b ]]

package.path = [[C:/torch/lua/?.lua;C:/torch/lua/?/init.lua;]]..package.path

-- this should be loaded first.
local cfg = require("luarocks.cfg")

local loader = require("luarocks.loader")
local command_line = require("luarocks.command_line")

program_description = "LuaRocks main command-line interface"

commands = {
   help = "luarocks.help",
   pack = "luarocks.pack",
   unpack = "luarocks.unpack",
   build = "luarocks.build",
   install = "luarocks.install",
   search = "luarocks.search",
   list = "luarocks.list",
   remove = "luarocks.remove",
   make = "luarocks.make",
   download = "luarocks.download",
   path = "luarocks.path_cmd",
   show = "luarocks.show",
   new_version = "luarocks.new_version",
   lint = "luarocks.lint",
   write_rockspec = "luarocks.write_rockspec",
   purge = "luarocks.purge",
   doc = "luarocks.doc",
   upload = "luarocks.upload",
   config = "luarocks.config_cmd",
}

command_line.run_command(...)
