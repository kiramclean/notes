12. use `fetch` with a block to provide defaults (instead of `||`) to allow `nil` or `false` to be explicitly passed as a key
  - using `||` will treat `nil`, `false`, and a completely missing key all the same and result in the same default value
13. if your class has no state you don't need a class -- use a singleton object or module instead
  - classes in ruby are for sharing behaviour and containing state (e.g. ensuring correct initialization, acting as an object factory)
    - if a class is not performing both of those roles, you don't need a class
14. use `&nil` as a second argument to `super` to ensure a block cannot inadvertendly be passed up the chain to a parent class
15. use the block form of `.fetch(:key) { default }` to avoid running `deafult` always, whether it's needed or not
  - using `.fetch(:key, default)` executes `default` always, even if the key is not missing (and therefore `default` is not needed)
16. use `defined?(super)` to check whether a superclass implements a method that you (might) be over-writing
  - get a method object from an original method and bind it to `self` for re-use later to be absolutely sure you're calling the original version of a method
  - also check out `__send__` for this same use case
17. command methods cause something in the outside world to change
  - as opposed to query methods, which just return some information
  - keep commands and queries separated
    - pay it back or pay it forward, but never both
18. some methods on core classes (eg `Array#+`) are written in C not ruby, and sometimes the return class is hard coded
  - inheriting from core classes won't behave the way you think
  - use delegation not inheritance to re-use behaviour from core classes
  - `include Enumerable` and delegate `#each` to "inherit" enumerable behaviour
19. add a layer of indirection to reduce coupling between collaborators
  - sometimes overkill, careful not to make method calls too abstract, but generally good practice
20. the only time assigning an object/constant to a variable causes ruby to change the object/constant itself is assigning a name to a Struct
  - assigning an anoymous class/module to a constant in ruby is very special -- ruby sets the `name` of that class/module to the name of the constant it was assigned to
  - can get/set values of a struct using hash syntax
  - equality operator comes for free
  - `Struct`s can introspect and iterate over their elements
  - also come with `Enumerable`
  - `Struct`s can also take a block to have method defined on them
21. serparate domain model logic and UI concerns by pulling out observers and listeners
  - make the model observable (see gang of four description)
  - create life-cycle methods that get triggered by checking dirty attributes
  - keep controllers' responsibilities limited to current UI state (current session, user, response type, etc)
22. do not rescue overly general exception classes
  - do not use rescue inline, except to intercept errors (eg to log or track), before passing them along to raise eventually anyway (turning them into return values)
  - ruby always stores a reference to the currently raised exception in th `$!` variable
    - can `include English` and use `$ERROR_INFO` instead of `$!`
23. tempfiles are removed once the ruby process ends
  - great way to work with clis that expect to work with files as input/output
24. avoid incidental change to make diffs easier to understand
  - no explicit returns (might have to remove them later anyway)
  - use parens when you care about the return value (so you don't have to add them later to chain another method, for example)
  - leave a dangling comma at the end of an array to prevent an invalid array if you add an element but forget the comma
25. `OpenStruct`s provide a reader method for each key of a hash passed in on initialization
26. FFI gem allows calling foreign C libraries from within ruby
  - can interface dynamically from within ruby directly to an outside C library, and allow the C library to call back in to the ruby program using lambdas
27. use `module_eval` to dynamically define instance methods using a passed-in key
  - create a new method in the context of a new `Module` (inside an included `Module`) to insert it into an object's ancestor chain in a predictable way
  - make generated methods easy to extend by putting them in a module instead of adding them to a class
28. can define `.to_s` in an anonymous module to give it a meaningful name
  - can be messy, can also check for a named constant in the current class and use that (or a create a new one once) and make its `to_s` method output a nice name
29. ruby has special `$stdout` and `$stderr` global variables for standard output and standard error
  - can define a method to capture output in a `StringIO` object and still restore the old `$stdout` afterward
    - `ensure` executes even if an exception is raised inside the block
    - ruby also has `STDOUT` constant that is unaffected by reassigning `$stdout`
  - can also capture std io in a separate `Thread` by reading the std output using an `IO.pipe`
30. to execute a subprocess in ruby use backticks (can also use `%x{...}`, useful if the comman itself contains backticks)
  - backticks are actually operator in ruby, so they can be overloaded (but don't!)
31. move listener logic into its own classes to make observable pattern easier to grok
32. block given to a new hash gets executed iff we try to access a missing key
  - useful as a cache for expensive values if the default value is not just a value but needs to be calculated or fetched from somewhere, eg via http
  - also useful for defining hashes of arbitrary nesting, can use a new hash whose default value is an empty hash, whose default value is an empty hash, etc.
33. naming a class is just assigning it to a constant
  - camel cased constants are reserved for class names
  - assigning a class to a constant overwrites the `name` method to be the name of the class
34. can use enumerability and introspection features of `Struct` to put data in and get it out as a hash
  - avoid using `Struct`-specific features (eg `members`) outside of struct classes, to make it possible to change the underlying structure of the class later
35. use `call` as the method name for executable actions done by an object
  - procs and lambdas respond to `call`, so you can change implementation easily without worrying about the callers
  - avoid naming a method something redundant that just reiterates the class name (to avoid having things like `notifier.notify`, or `runner.run`)
36. lambdas error with extra arguments, procs will just throw away an extra argument
  - return statement inside a lambda stops execution of just the lambda itself
  - return statement inside a proc ends execution of the containing method
    - procs contain a reference to their binding (context in which they are run) and return acts like a return in _that_ context
37. threequals is the smart equality matcher in ruby
  - used by case statements under the hood
  - Proc class aliases the threequals operator to `call`
  - means you can use them as a predicate in a case statement
38. pass a proc or block as a second argument to a method to allow flexible use by callers
