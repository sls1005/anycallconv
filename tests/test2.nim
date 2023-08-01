import anycallconv

proc invoke(p: proc(x: int) {.anyconv.}) =
  p(1)

invoke(proc(x: int) {.cdecl.} = echo x + 1)
invoke(proc(x: int) {.nimcall.} = echo x - 1)
doAssert not compiles invoke(proc(x: float) {.nimcall.} = echo x - 1)