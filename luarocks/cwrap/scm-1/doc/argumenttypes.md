<a name="CInterface.argtypes"></a>
## Argument Types ##

Any `CInterface` is initialized with a default `argtypes` list, at
creation. This list tells to `CInterface` how to handle type names given
to the [wrap()](higherlevelinterface.md#CInterface.wrap) method. The user can add more types to
this list, if wanted (see [the next section](usertypes.md#CInterface.userargtypes)).

### Standard C types ###
Standard type names include `unsigned char`, `char`, `short`,
`int`, `long`, `float` and `double`. They define the corresponding
C types, which are converted to/from
[lua_Number](http://www.lua.org/manual/5.1/manual.html#lua_Number).

Additionaly, `byte` is an equivalent naming for `unsigned char`, and
`boolean` is interpreted as a boolean in Lua, and an int in C.

`real` will also be converted to/from a `lua_Number`, while assuming that
it is defined in C as `float` or `double`.

Finally, `index` defines a long C value, which is going to be
automatically incremented by 1 when going from C to Lua, and decremented by
1, when going from Lua to C. This matches Lua policy of having table
indices starting at 1, and C array indices starting at 0.

For all these number values, the `default` field (when defining the
argument in [wrap()](higherlevelinterface.md##CInterface.wrap)) can take two types: either a
number or a function (taking the argument table as argument, and returning a string).

Note that in case of an `index` type, the given default value (or result
given by the default initialization function) will be decremented by 1 when
initializing the corresponging C `long` variable.

Here is an example of defining arguments with a default value:
```lua
{name="int", default=0}
```
defines an optional argument which will of type `int` in C (lua_Number in Lua), and will take
the value `0` if it is not present when calling the Lua function. A more complicated (but typical) example
would be:
```lua
{name="int", default=function(arg)
                       return string.format("%s", arg.args[1]:carg())
                     end}
```
In this case, the argument will be set to the value of the first argument in the Lua function call, if not
present at call time.

### Torch Tensor types ###

`CInterface` also defines __Torch__ tensor types: `ByteTensor`,
`CharTensor`, `ShortTensor`, `IntTensor`, `LongTensor`,
`FloatTensor` and `DoubleTensor`, which corresponds to their
`THByteTensor`, etc... counterparts. All of them assume that the
[luaT](..:luaT) Tensor id (here for ByteTensor)
```
const void *torch_ByteTensor_id;
```
is defined beforehand, and properly initialized.

Additionally, if you use C-templating style which is present in the TH library, you might want
to use the `Tensor` typename, which assumes that `THTensor` is properly defined, as well as
the macro `THTensor_()` and `torch_()` (see the TH library for more details).

Another extra typename of interest is `IndexTensor`, which corresponds to a `THLongTensor` in C. Values in this
LongTensor will be incremented/decremented when going from/to C/Lua to/from Lua/C.

Tensor typenames `default` value in [wrap()](higherlevelinterface.md#CInterface.wrap) can take take two types:
  * A boolean. If `true`, the tensor will be initialized as empty, if not present at the Lua function call
  * A number (index). If not present at the Lua function call, the tensor will be initialized as _pointing_ to the argument at the given index (which must be a tensor of same type!).
For e.g, the list of arguments:
```lua
{
  {name=DoubleTensor, default=3},
  {name=double, default=1.0},
  {name=DoubleTensor}
}
```
The first two arguments are optional. The first one is a DoubleTensor which
will point on the last (3rd) argument if not given. The second argument
will be initialized to `1.0` if not provided.

Tensor typenames can also take an additional field `dim` (a number) which will force a dimension
check. E.g.,
```lua
{name=DoubleTensor, dim=2}
```
expect a matrix of doubles.
