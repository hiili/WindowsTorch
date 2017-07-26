# CWrap package #

The __cwrap__ package helps you to automate the generation of Lua/C wrappers
around existing C functions, such that these functions would be callable
from Lua. This package is used by the __torch__ package, but does not depend on
anything, and could be used by anyone using Lua. 
The documentation is organized as follows :

  * [Example Use Case](example.md)
  * [High Level Interface](highlevelinterface.md)
  * [Argument Types](argumenttypes.md)
  * [User Types](usertypes.md)

__DISCLAIMER__ Before going any further, we assume the reader has a good
knowledge of how to interface C functions with Lua. A good start would be
the [Lua reference manual](http://www.lua.org/manual/5.1), or the book
[Programming in Lua](http://www.inf.puc-rio.br/~roberto/pil2).


