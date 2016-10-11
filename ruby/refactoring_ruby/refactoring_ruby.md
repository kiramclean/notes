# Refactoring Ruby

- any non-modified variable can be passed in as a variable
- if there is a single modified variable, it can be returned
- it is bad to have case statement or a conditional that depends on an attribute of a different object
  - if you must use case/if statements, it should only be on your own data, never someone else's
- keep things that vary with an attribute together on the class that has the attribute

## When to refactor
- do something the first time
- second time put up with the duplication but do it anyway
- third time, refactor

## Productivity killers:
- programs that are hard to read
- programs with duplicated logic
- programs that require additional behaviour that requires changing already-running code
- programs with complex conditional logic

