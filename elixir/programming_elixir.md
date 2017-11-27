# Elixir Basics

_From Programming Elixir, by Dave Thomas_

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

## Dictionary Data Types
### Maps
- when you want to pattern match against a key
- anytime you don't need a keyword
- good performance even when very large

- cannot bind keys in Map pattern matching

### Keyword Lists
- when you need more than one entry with the same key
- when you need to guarantee the elements are ordered

- typically used in the context of options passed to functions
- have access to all `Keyword` and `Enum` module methods


## Processing Collections - Enum and Stream
- `Stream` is like enum but lazy
  - like a ruby `Enumerator`
- use to defer processing until you need data, or to deal wtih enumerating huge collections


_From Function Web Development by Lance Halvorsen_

- Structs are like maps but have compile time checks on the keys and runtime
  checks on the type
