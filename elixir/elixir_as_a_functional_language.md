# Functional vs Object Oriented Programming

- in an OO approach, an instance of a class can have some methods that operate on its own instance variables

- no concept of instance variables or classes in elixir
  - a module knows nothing about state
  - you cannot instantiate or make copies of a module
  - all you have is primitive data types and methods that operate on them

- data in elixir is immutable
  - any method that appears to modify an existing data structure is returning a changed, new copy of the old data structure

- there is no variable assignment in elixir, just pattern matching
- the data structure has to be the same type and have the same number of elements on each side of `=` for assignment to work

- difference between atoms and strings are strings are meant to be surfaced to a user

- `Struct`s are like `Map`s, except better because they can be assigned default values and have extra checks on their values at compile time (can only have values that exist in the `Struct` definition)
- `Struct`s are for data only, have no behaviour or methods
  - they are not instances of anything, they are just primitive data structures
- if you know the properties you're going to be working with, use a struct

- use tuples over lists when an index has a particular meaning

- no such thing as classes or inheritance in elixir
  - to reuse code:
  |keyword|purpose|
  |:---:|:---:|
  |import|take all the functions out of this module and give them to this other module|
  |alias|create a shortcut to this other module, my fingers are lazy|
  |use|I want to do some really really really fancy setup|
