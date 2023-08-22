This module provides a *macro pragma* which can be applied to procedural parameter types, named `anyconv`. Once applied, it makes the parameter to accept procedures of a particular signature, but regardless of the calling convention.

### Example
```nim
import anycallconv

proc invoke(p: proc(x: int) {.anyconv.}) =
  p(1)

invoke(proc(x: int) {.cdecl.} = echo x + 1) # works
invoke(proc(x: int) {.nimcall.} = echo x - 1) # works
assert not compiles(
  invoke(proc(x: float) {.nimcall.} = echo x - 1)
)
```
In the above example, the macro is expanded into "`proc(x: int) {.cdecl.} or proc(x: int) {.closure.} or proc(x: int) {.nimcall.} or...`" in order to accept callbacks of different calling conventions. If the macro weren't applied, the first call to `invoke` wouldn't pass the compilation, because procedural types without pragmas have `{.closure.}` as the default calling convention, and thus not compatible with procedures other than those with `{.closure.}` or `{.nimcall.}`.

### Note
* This actually produces a *type class*, which leads a procedure with such callback to be  **implicit generic**. That is, calling the procedure many times with callbacks of  *N* different calling conventions will cause it to instantiate at least *N* times.

* Using a *type class* for variable type will **not** make the variable to have multiple types, but instead cause the compiler to perform a check on it and resolve it into a single type, as stated in the language manual. The same applies to *type classes* created with this macro. For example,
    ```nim
    import anycallconv
    
    var f: (proc(x: int): int {.anyconv.}) = (proc(x: int): int {.cdecl.} = x + 1)
    # `f` is resolved to {.cdecl.}
    echo f is proc(x: int): int {.cdecl.} # true
    echo f is proc(x: int): int {.nimcall.} # false
    echo f is proc(x: int): int {.closure.} # false
    echo f is proc(x: float): float {.cdecl.} # also false
  ```
* A procedure taking such a callback should **not** be marked with `{.exportc.}`, or a fatal error is possible.
