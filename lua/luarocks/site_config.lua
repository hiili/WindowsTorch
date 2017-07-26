local site_config = {}

site_config.LUAROCKS_PREFIX=[[C:/torch/]]
site_config.LUA_INCDIR=[[C:/torch/include]]
site_config.LUA_LIBDIR=[[C:/torch/lib]]
site_config.LUA_BINDIR=[[C:/torch/bin]]
site_config.LUA_INTERPRETER = [[luajit]]
site_config.LUAROCKS_SYSCONFDIR=[[C:/torch/luarocks]]
site_config.LUAROCKS_ROCKS_TREE=[[C:/torch/]]
site_config.LUAROCKS_ROCKS_SUBDIR=[[luarocks]]
site_config.LUA_DIR_SET = true
site_config.LUAROCKS_UNAME_S=[[Windows]]
site_config.LUAROCKS_UNAME_M=[[x64]]
site_config.LUAROCKS_DOWNLOADER=[[wget]]
site_config.LUAROCKS_MD5CHECKER=[[md5sum]]

return site_config
