import union

type None = object
  ## A type for not having any data

proc search[T, U](x: T, needle: U): union(U | None) =
  # Assignment can be done via explicit conversion
  result = None() as union(U | None)

  let idx = find(x, needle)
  if idx >= 0:
    # Or the `<-` operator which automatically converts the type
    result <- x[idx]

doAssert [1, 2, 42, 20, 1000].search(10) of None
doAssert [1, 2, 42, 20, 1000].search(42) as int == 42
# For `==`, no explicit conversion is necessary
doAssert [1, 2, 42, 20, 1000].search(42) == 42
# Types that are not active at the moment will simply be treated as not equal
doAssert [1, 2, 42, 20, 1000].search(1) != None()

proc `{}`[T](x: seq[T], idx: Natural): union(T | None) =
  ## An array accessor for seq[T] but doesn't raise if the index is not there
  # Using makeUnion, an expression may return more than one type
  makeUnion:
    if idx in 0 ..< x.len:
      x[idx]
    else:
      None()

doAssert @[1]{2} of None
doAssert @[42]{0} == 42

import json

# With unpack(), dispatching based on the union type at runtime is possible!
var x = 42 as union(int | string)

block:
  let j =
    unpack(x):
      # The unpacked variable name is `it` by default
      %it

  doAssert j.kind == JInt

x <- "string"

block:
  let j =
    # You can give the unpacked variable a different name via the second
    # parameter, too.
    unpack(x, upk):
      %upk

  doAssert j.kind == JString
