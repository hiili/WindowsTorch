## High Level Interface ##

__wrap__ provides only one class: `CInterface`. Considering our easy example, a typical usage
would be:
```lua
require 'wrap'

interface = wrap.CInterface.new()

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

print(interface:tostring())
```
`CInterface` contains only few methods. [wrap()](highlevelinterface.md#CInterface.wrap) is
the most important one. [tostring()](highlevelinterface.md#CInterface.tostring) returns a
string containing all the code produced until now.  The wrapper generated
by __wrap__ is quite similar to what one would write by hand:
```c
static int wrapper_numel(lua_State *L)
{
  int narg = lua_gettop(L);
  THDoubleTensor *arg1 = NULL;
  int arg2 = 0;
  if(narg == 1
     && (arg1 = luaT_toudata(L, 1, torch_DoubleTensor_id))
    )
  {
  }
  else
    luaL_error(L, "expected arguments: DoubleTensor");
  arg2 = numel(arg1);
  lua_pushnumber(L, (lua_Number)arg2);
  return 1;
}
```

We know describe the methods provided by `CInterface`.

<a name="CInterface.new"></a>
### new() ###

Returns a new `CInterface`.

<a name="CInterface.wrap"></a>
### wrap(luaname, cfunction, arguments, ...) ###

Tells the `CInterface` to generate a wrapper around the C function
`cfunction`. The function will be called from Lua under the name
`luaname`. The Lua _list_ `arguments` must also be provided. It
describes _all_ the arguments of the C function `cfunction`.
Optionally, if the C function returns a value and one would like to return
it in Lua, this additional value can be also described in the argument
list.
```lua
   {
      {name="DoubleTensor"},
      {name="int", creturned=true} -- this one is returned by the C function
   }
```

Each argument is described also as a list. The list must at least contain
the field `name`, which tells to `CInterface` what type of argument you
want to define. In the above example,
```lua
{name="DoubleTensor"}
```
indicates to `CInterface` that the first argument of `numel()` is of type `DoubleTensor`.

Arguments are defined into a table `CInterface.argtypes`, defined at the
creation of the interface.  Given a `typename`, the corresponding field
in `interface.argtypes[typename]` must exist, such that `CInterface`
knows how to handle the specified argument. A lot of types are already
created by default, but the user can define more if needed, by filling
properly the `argtypes` table. See the section [[argumenttypes.md#CInterface.argtypes]]
for more details about defined types, and
[how to define additional ones](usertypes.md#CInterface.userargtypes).

#### Argument fields ####

Apart the field `name`, each list describing an argument can contain several optional fields:

`default`: this means the argument will optional in Lua, and the argument will be initialized
with the given default value if not present in the Lua function call. The `default` value might
have different meanings, depending on the argument type (see [[argumenttypes.md#CInterface.argtypes]] for more details).

`invisible`: the argument will invisible _from Lua_. This special option requires `default` to be set,
such that `CInterface` knows by what initialize this invisible argument.

`returned`: if set to `true`, the argument will be returned by the Lua function. Note that several
values might be returned at the same time in Lua.

`creturned`: if `true`, tells to `CInterface` that this 'argument' is
in fact the value returned by the C function.  This 'argument' cannot have
a `default` value. Also, as in C one can return only one value, only one
'argument' can contain this field! Mixing arguments which are `returned`
and arguments which are `creturned` with `CInterface` is not
recommended: use with care.

While these optional fields are generic to any argument types, some types might define additional optional fields.
Again, see [[argumenttypes.md#CInterface.argtypes]] for more details.

#### Handling multiple variants of arguments ####

Sometimes, one cannot describe fully the behavior one wants with only a set of possible arguments.
Take the example of the `cos()` function: we might want to apply it to a number, if the given argument
is a number, or to a Tensor, if the given argument is a Tensor.

`wrap()` can be called with extra pairs of `cname, args` if needed. (There are no limitations on the number extra paris).
For example, if you need to handle three cases, it might be
```lua
interface:wrap(luaname, cname1, args1, cname2, args2, cname3, args3)
```
For each given C function name `cname`, the corresponding argument list `args` should match.
As a more concrete example, here is a way to generate a wrapper for `cos()`, which would handle both numbers
and DoubleTensors.
```lua
interface:wrap("cos", -- the Lua function name

"THDoubleTensor_cos", { -- C function called for DoubleTensor
{name="DoubleTensor", default=true, returned=true}, -- returned tensor (if not present, we create an empty tensor)
{name="DoubleTensor"} -- input tensor
},

"cos", { -- the standard C math cos function
{name="double", creturned="true"}, -- returned value
{name="double"} -- input value
}
)
```

<a name="CInterface.print"></a>
### print(str) ###

Add some hand-crafted code to the existing generated code. You might want to do that if your wrapper
requires manual tweaks. For e.g., in the example above, the "id" related to `torch.DoubleTensor`
needs to be defined beforehand:
```lua
interface:print([[
const void* torch_DoubleTensor_id;
]])
```

<a name="CInterface.luaname2wrapname"></a>
### luaname2wrapname(name) ###

This method defines the name of each generated wrapping function (like
`wrapper_numel` in the example above), given the Lua name of a function
(say `numel`). In general, this has little importance, as the wrapper is
a static function which is not going to be called outside the scope of the
wrap file. However, if you generate some complex wrappers, you might want
to have a control on this to avoid name clashes. The default is
```lua
function CInterface:luaname2wrapname(name)
   return string.format("wrapper_%s", name)
end
```
Changing it to something else can be easily done with (still following the example above)
```lua
function interface:luaname2wrapname(name)
   return string.format("my_own_naming_%s", name)
end
```

### register(name) ###

Produces C code defining a
[luaL_Reg](http://www.lua.org/manual/5.1/manual.html#luaL_Reg) structure
(which will have the given `name`). In the above example, calling
```lua
interface:register('myfuncs')
```
will generate the following additional code:
```c
static const struct luaL_Reg myfuncs [] = {
  {"numel", wrapper_numel},
  {NULL, NULL}
};
```

This structure is meant to be passed as argument to
[luaL_register](http://www.lua.org/manual/5.1/manual.html#luaL_register),
such that Lua will be aware of your new functions. For e.g., the following
would declare `mylib.numel` in Lua:
```lua
interface:print([[
luaL_register(L, "mylib", myfuncs);
]])
```

<a name="CInterface.tostring"></a>
### tostring() ###

Returns a string containing all the code generated by the `CInterface`
until now. Note that the history is not erased.

<a name="CInterface.tofile"></a>
### tofile(filename) ###

Write in the file (named after `filename`) all the code generated by the
`CInterface` until now. Note that the history is not erased.

<a name="CInterface.clearhhistory"></a>
### clearhistory() ###

Forget about all the code generated by the `CInterface` until now.

