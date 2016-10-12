# Programming Elixir
_Dave Thomas_

- `and`, `or`, `not` expect literally `true` or `false`
- `&&`, `||`, `!` can take something that is just _truthy_ .. doesn't have to be exactly `true` or `false`

- using `<-` returns the value that couldn't be matched if it fails
  - `=` just throws a `MatchError` when matching fails

- functions in elixir carry the bindings of variables in the scope in which they are defined
  - an inner funciton inherits the scope of the outer function and carries this binding around with it
  - this is closures in elixir -- scopes enclose the bindings of their variables so they can be saved and used later

- common pattern in elixir (and functional programming in general):
  - find simplest possible case with a definite answer and hard code this
  - look for a recursive solution that will eventually end up calling the anchor case

- always use parens around function params in pipelines

*invariant* == a condition that is true on any return from any call or nested call
