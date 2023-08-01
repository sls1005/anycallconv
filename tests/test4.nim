import anycallconv

var f: (proc(x: int): int {.anyconv.}) = (proc(x: int): int {.cdecl.} = x + 1)
# `f` is resolved to {.cdecl.}
doAssert(f is proc(x: int): int {.cdecl.})
doAssert((
    f isnot proc(x: int): int {.nimcall.}
  ) and (
    f isnot proc(x: int): int {.closure.}
  ) and (
    f isnot proc(x: float): float {.cdecl.}
  )
)
