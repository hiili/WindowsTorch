<a name="CInterface.userargtypes"></a>
## User Types ##

Types available by default in `CInterface` might not be enough for your needs. Also, sometimes you might
need to change sliglty the behavior of existing types. In that sort of cases, you will need to
know more about what is going on under the hood.

When you do a call to [wrap()](highlevelinterface.md#CInterface.wrap),
```lua
interface:wrap(
   "numel", -- the Lua name
   "numel", -- the C function name, here the same
   -- now we describe the 'arguments' of the C function
   -- (or possible returned values)
   {
      {name="DoubleTensor"},
      {name="int", creturned=true} -- this one is returned by the C function
   }
)
```
the method will examine each argument you provide. For example, let's consider:
```lua
{name="int", creturned=true}
```
Considering the argument field `name`, __wrap__ will check if the field
`interface.argtypes['int']` exists or not. If it does not exist, an error will be raised.

In order to describe what happens next, we will now denote
```lua
arg = {name="int", creturned=true}
```
First thing which is done is assigning `interface.argtypes['int']` as a metatable to `arg`:
```lua
setmetatable(arg, interface.argtypes[arg.name])
```
Then, a number of fields are populated in `arg` by __wrap__:
```lua
arg.i = 2 -- argument index (in the argument list) in the wrap() call
arg.__metatable = interface.argtypes[arg.name]
arg.args = ... -- the full list of arguments given in the wrap() call
```

[wrap()](highlevelinterface.md#CInterface.wrap) will then call a several methods which are
assumed to be present in `arg` (see below for the list).  Obviously, in
most cases, methods will be found in the metatable of `arg`, that is in
`interface.argtypes[arg.name]`. However, if you need to override a method
behavior for one particular argument, this method could be defined in the
table describing the argument, when calling [wrap()](highlevelinterface.md#CInterface.wrap).

The extra fields mentionned above (populated by __wrap__) can be used in the argument
methods to suit your needs (they are enough to handle most complex cases).

We will now describe methods which must be defined for each type. We will
take as example `boolean`, to make things more clear. If you want to see
more complex examples, you can have a look into the `types.lua` file,
provided by the __wrap__ package.

<a name='CInterface.arg.helpname'></a>
### helpname(arg) ###

Returns a string describing (in a human readable fashion) the name of the given arg.

Example:
```lua
function helpname(arg)
   return "boolean"
end
```

<a name='CInterface.arg.declare'></a>
### declare(arg) ###

Returns a C code string declaring the given arg.

Example:
```lua
function declare(arg)
   return string.format("int arg%d = 0;", arg.i)
end
```

<a name='CInterface.arg.check'></a>
### check(arg, idx) ###

Returns a C code string checking if the value at index `idx` on the Lua stack
corresponds to the argument type. The string will appended in a `if()`, so it should
not contain a final `;`.

Example:
```lua
function check(arg, idx)
   return string.format("lua_isboolean(L, %d)", idx)
end
```

<a name='CInterface.arg.read'></a>
### read(arg, idx) ###

Returns a C code string converting the value a index `idx` on the Lua stack, into
the desired argument. This method will be called __only if__ the C check given by
[check()](#CInterface.arg.check) succeeded.

Example:
```lua
function read(arg, idx)
   return string.format("arg%d = lua_toboolean(L, %d);", arg.i, idx)
end
```

<a name='CInterface.arg.init'></a>
### init(arg) ###

Returns a C code string initializing the argument by its default
value. This method will be called __only if__ (1) `arg` has a `default`
field and (2) the C check given by [check()](#CInterface.arg.check)
failed (so the C code in [read()](#CInterface.arg.read) was not called).

Example:
```lua
function init(arg)
   local default
   if arg.default then
      default = 1
   else
      default = 0
   end
   return string.format("arg%d = %s;", arg.i, default)
end
```

<a name='CInterface.arg.carg'></a>
### carg(arg) ###

Returns a C code string describing how to pass
the given `arg` as argument when calling the C function.

In general, it is just the C arg name itself (except if you need to pass
the argument "by address", for example).

Example:
```lua
function carg(arg)
   return string.format('arg%d', arg.i)
end
```

<a name='CInterface.arg.creturn'></a>
### creturn(arg) ###

Returns a C code string describing how get the argument if it
is returned from the C function.

In general, it is just the C arg name itself (except if you need to assign
a pointer value, for example).

```lua
function creturn(arg)
   return string.format('arg%d', arg.i)
end
```

<a name='CInterface.arg.precall'></a>
### precall(arg) ###

Returns a C code string if you need to execute specific code related to
`arg`, before calling the C function.

For e.g., if you created an object in the calls before, you might want to
put it on the Lua stack here, such that it is garbage collected by Lua, in case
the C function call fails.

```lua
function precall(arg)
-- nothing to do here, for boolean
end
```

<a name='CInterface.arg.postcall'></a>
### postcall(arg) ###

Returns a C code string if you need to execute specific code related to
`arg`, after calling the C function. You can for e.g. push the argument
on the stack, if needed.

```lua
function postcall(arg)
   if arg.creturned or arg.returned then
      return string.format('lua_pushboolean(L, arg%d);', arg.i)
   end
end
```

