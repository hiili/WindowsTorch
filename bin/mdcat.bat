@echo off
"C:\torch\bin\luajit" -e "package.path=\"C:\\Users\\pwagner.increment\\AppData\\Roaming/.luarocks/share/lua/5.1/?.lua;C:\\Users\\pwagner.increment\\AppData\\Roaming/.luarocks/share/lua/5.1/?/init.lua;C:/torch/lua/?.lua;C:/torch/lua/?/init.lua;C:/torch/\\lua\\?.lua;\"..package.path; package.cpath=\"C:\\Users\\pwagner.increment\\AppData\\Roaming/.luarocks/lib/lua/5.1/?.dll;C:/torch/bin/?.dll;\"..package.cpath" -e "local k,l,_=pcall(require,\"luarocks.loader\") _=k and l.add_context(\"sundown\",\"scm-1\")" "C:\torch\luarocks\sundown\scm-1\bin\mdcat" %*
exit /b %ERRORLEVEL%
