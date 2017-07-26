# Lua *system* package

Note: some functions only work on UNIX systems.

## Dependencies
Torch7 (www.torch.ch)

## Install
```
$ luarocks install sys
```

## Use

```lua
$ torch
> require 'sys'
```

### Time / Clock

```lua
> t = sys.clock()  -- high precision clock (us precision)
> sys.tic()
> -- do something
> t = sys.toc()    -- high precision tic/toc
> sys.sleep(1.5)   -- sleep 1.5 seconds
```

### Paths

```lua
> path,fname = sys.fpath()
```

Always returns the path of the file in which this call is made. Useful
to access local resources (non-lua files).

### Execute

By default, Lua's `os.execute` doesn't pipe its results (stdout). This
function uses popen to pipe its results into a Lua string:

```lua
> res = sys.execute('ls -l')
> print(res)
```

Derived from this, a few commands:

```lua
> print(sys.uname())
linux
```

UNIX-only: shortcuts to run bash commands:

```lua
> ls()
> ll()
> lla()
```

### sys.COLORS

If you'd like print in colours, follow the following snippets of code. Let start by listing the available colours

```lua
$ torch
> for k in pairs(sys.COLORS) do print(k) end
```

Then, we can generate a shortcut `c = sys.COLORS` and use it within a `print`

```lua
> c = sys.COLORS
> print(c.magenta .. 'This ' .. c.red .. 'is ' .. c.yellow .. 'a ' .. c.green .. 'rainbow' .. c.cyan .. '!')
```
