import anycallconv

proc env(p: proc(x: int) {.anyconv.}): pointer =
  when p is proc(x: int) {.closure.}:
    p.rawEnv()
  else:
    nil

doAssert env(proc(x: int) {.cdecl.} = echo x) == nil