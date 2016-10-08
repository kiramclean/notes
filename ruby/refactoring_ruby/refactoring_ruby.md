# Refactoring Ruby

- any non-modified variable can be passed in as a variable
- if there is a single modified variable, it can be returned
- it is bad to have case statement or a conditional that depends on an attribute of a different object
  - if you must use case/if statements, it should only be on your own data, never someone else's
- keep things that vary with an attribute together on the class that has the attribute
