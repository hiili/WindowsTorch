[![Build Status](https://travis-ci.org/torch/sundown-ffi.svg)](https://travis-ci.org/torch/sundown-ffi)

sundown-ffi
===========

A LuaJIT interface to the Sundown library (a Markdown implementation)

# Installation #

torch-rocks install https://raw.github.com/andresy/sundown-ffi/master/rocks/sundown-scm-1.rockspec

# Usage #

## HTML

To render into HTML, the easiest is to use the provided `renderHTML()` function (aliased to `render()`), which interfaces Sundown renderer with Houdini HTML default renderer.

```lua
local sundown = require 'sundown'

local html = sundow.render[[
sundown-ffi
===========

A LuaJIT interface to the Sundown library (a Markdown implementation)

# Installation #

torch-rocks install https://raw.github.com/andresy/sundown-ffi/master/rocks/sundown-scm-1.rockspec
]]
```

You can equivalently call `render()` in `sundown.html`:
```lua
local html = require 'sundown.html'
html.render[[
...
]]
```

## ASCII Markdown Pretty Print

We also provide an extra renderer `renderASCII()` which outputs pretty colored ASCII for Markdown pages.

```lua
local sundown = require 'sundown'
local text = sundown.renderASCII[[
sundown-ffi
===========

A LuaJIT interface to the Sundown library (a Markdown implementation)

# Installation #

torch-rocks install https://raw.github.com/andresy/sundown-ffi/master/rocks/sundown-scm-1.rockspec
]]
```

You can equivalently call `render()` in `sundown.ascii`:
```lua
local ascii = require 'sundown.ascii'
ascii.render[[
...
]]
```


### Styles and Colors

`renderASCII(text[, style])` takes an optional `style` argument, which
defines the printing style of each Markdown element. The default style is the following:
```lua
local color_style = {
   maxlsz = 80,
   none = c.none,
   h1 = c.Magenta,
   h2 = c.Red,
   h3 = c.Blue,
   h4 = c.Cyan,
   h5 = c.Green,
   h6 = c.Yellow,
   blockquote = '',
   hrule = c.Black,
   link = c.green,
   linkcontent = c.Green,
   code = c.cyan,
   emph = c.Black,
   doubleemph = c.Red,
   tripleemph = c.Magenta,
   strikethrough = c._white,
   header = c.White,
   footer = c.White,
   image = c.yellow,
   ulist = c.magenta,
   olist = c.magenta,
   tableheader = c.magenta,
   superscript = '^'
}
```

Where colors are ASCII codes defined with:
```lua
local c = {
   none = '\27[0m',
   black = '\27[0;30m',
   red = '\27[0;31m',
   green = '\27[0;32m',
   yellow = '\27[0;33m',
   blue = '\27[0;34m',
   magenta = '\27[0;35m',
   cyan = '\27[0;36m',
   white = '\27[0;37m',
   Black = '\27[1;30m',
   Red = '\27[1;31m',
   Green = '\27[1;32m',
   Yellow = '\27[1;33m',
   Blue = '\27[1;34m',
   Magenta = '\27[1;35m',
   Cyan = '\27[1;36m',
   White = '\27[1;37m',
   _black = '\27[40m',
   _red = '\27[41m',
   _green = '\27[42m',
   _yellow = '\27[43m',
   _blue = '\27[44m',
   _magenta = '\27[45m',
   _cyan = '\27[46m',
   _white = '\27[47m'
}
```

You can redefine your own if interested. You can also turn color on/off with the following:

```lua
local ascii = require 'sundown.ascii'

ascii.bw() -- black and white output
ascii.render[[
...
]]

ascii.color() -- colored output
ascii.render[[
...
]]
```

# Advanced usage #

All functions from the library `sundown` and `houdini` are accessible through `sundown.C.func` where `func`
is the function of interest.

See the [Sundown library page](https://github.com/vmg/sundown) for more details.

Note that Houdini C function and structure names are prefixed here with `sd_html_` (e.g. `sd_html_renderer`).
Sundown C function and structure names are prefixed with `sd_` (e.g. `sd_markdown_render`).

See sdcdefs.lua and htmlcdefs.lua for what is actually available.
