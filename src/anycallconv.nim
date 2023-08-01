import macros

macro anyconv*(procType: typed): typedesc =
  ## **Example:**
  ##
  ## .. code-block::
  ##   proc invoke(p: proc(x: int) {.anyconv.}) = p(1)
  ##
  ##   invoke(proc(x: int) {.cdecl.} = echo x + 1) # works
  ##   invoke(proc(x: int) {.nimcall.} = echo x - 1) # works
  ##   invoke(proc(x: float) {.nimcall.} = echo x - 1) # error
  if procType.kind == nnkProcDef:
    error("'anyconv' can only be applied to procedural types, not procedure definitions.", procType)
  else:
    procType.expectKind(nnkProcTy)
  var callingConventions = @["cdecl", "closure", "nimcall", "fastcall", "safecall", "stdcall", "syscall", "noconv", "inline"]
  when (NimMajor, NimMinor) > (1, 2):
    callingConventions.add("thiscall")
  result = newEmptyNode()
  for cc in callingConventions:
    var ty = copy(procType)
    ty.pragma = copy(procType.pragma).add(ident(cc))
    if result.kind == nnkEmpty:
      result = ty
    else:
      result = newTree(nnkInfix, bindSym("or"), result, ty)
