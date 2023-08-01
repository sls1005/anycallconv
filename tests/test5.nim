# Overloading Test
import anycallconv

proc invoke(f: proc(x: int): int {.cdecl.}): int =
  return f(1)

proc invoke(f: proc(x: int): int {.closure.}): int =
  return f(2)

proc forwordCallback(callback: proc(x: int): int {.anyconv.}): int =
  invoke(callback)

doAssert forwordCallback(proc(x: int): int {.cdecl.} = x) == 1
doAssert forwordCallback(proc(x: int): int {.closure.} = x) == 2
doAssert not compiles forwordCallback(proc(x: int): int {.safecall.} = x)
