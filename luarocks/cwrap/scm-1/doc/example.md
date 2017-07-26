## Example Use Case

As an example is often better than lengthy explanations, let's consider the
case of a function

```c
int numel(THDoubleTensor *t);
```

which returns the number of elements of `t`.
Writing a complete wrapper of this function would look like:

```c
static int wrapper_numel(lua_State *L)
{
  THDoubleTensor *t;

  /* always good to check the number of arguments */
  if(lua_gettop(L) != 1)
    error("invalid number of arguments: <tensor> expected");

  /* check if we have a tensor on the stack */
  /* we use the luaT library, which deals with Torch objects */
  /* we assume the torch_DoubleTensor_id has been already initialized */
  t = luaT_checkudata(L, 1, torch_DoubleTensor_id);

  /* push result on stack */
  lua_pushnumber(L, numel(t));

  /* the number of returned variables */
  return 1;
}
```

For anybody familiar with the Lua C API, this should look very simple (and
_it is simple_, Lua has been designed for that!). Nevertheless, the
wrapper contains about 7 lines of C code, for a quite simple
function. Writing wrappers for C functions with multiple arguments, where
some of them might be optional, can become very quickly a tedious task. The
__wrap__ package is here to help the process. Remember however that even
though you might be able to treat most complex cases with __wrap__,
sometimes it is also good to do everything by hand yourself!
