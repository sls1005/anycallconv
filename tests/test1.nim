import anycallconv

type F = proc(x: int): int {.anyconv.}
echo (proc(x: int): int {.cdecl.} = x + 1) is F #true
echo (proc(x: cint): cint {.cdecl.} = x + 1) is F #false
echo (proc(x: int): int {.closure.} = x + 1) is F #true

var f: F = proc(x: int): int {.cdecl.} = x + 1
echo f(0)

doAssert not compiles(
  block:
    var g: F
)
