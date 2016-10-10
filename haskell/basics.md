# Haskell

- functions are the most common thing, so they get the simplest operator -- a space

Math | Haskell
--- | ---
f(x) | f x
f(x, y) | f x y
f(g(x)) |  f (g x)
f(x, g(y)) | f x (g y)
f(x)g(y) | f x * g y

- can use backquotes to make an infix operator
  - i.e.  ``x `f` y`` is the exact same thing as `f x y`

## Curried functions
**take their arguments one at a time**

- functions that take more than one argument can be curried by returning nested functions
