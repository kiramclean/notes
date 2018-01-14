12. use `fetch` with a block to provide defaults (instead of `||`) to allow
`nil` or `false` to be explicitly passed as a key
  - using `||` will treat `nil`, `false`, and a completely missing key all the
    same and result in the same default value
13. if your class has no state you don't need a class -- use a singleton object
or module instead
  - classes in ruby are for sharing behaviour and containing state (e.g.
    ensuring correct initialization, acting as an object factory)
    - if a class is not performing both of those roles, you don't need a class
14. use `&nil` as a second argument to `super` to ensure a block cannot
inadvertendly be passed up the chain to a parent class
15. use the block form of `.fetch(:key) { default }` to avoid running `deafult`
always, whether it's needed or not
  - using `.fetch(:key, default)` executes `default` always, even if the key is
    not missing (and therefore `default` is not needed)
16. use `defined?(super)` to check whether a superclass implements a method that
you (might) be over-writing
  - get a method object from an original method and bind it to `self` for re-use
    later to be absolutely sure you're calling the original version of a method
  - also check out `__send__` for this same use case
17. command methods cause something in the outside world to change
  - as opposed to query methods, which just return some information
  - keep commands and queries separated
    - pay it back or pay it forward, but never both
18. some methods on core classes (eg `Array#+`) are written in C not ruby, and
sometimes the return class is hard coded
  - inheriting from core classes won't behave the way you think
  - use delegation not inheritance to re-use behaviour from core classes
  - `include Enumerable` and delegate `#each` to "inherit" enumerable behaviour
19. add a layer of indirection to reduce coupling between collaborators
  - sometimes overkill, careful not to make method calls too abstract, but
    generally good practice
20. the only time assigning an object/constant to a variable causes ruby to
change the object/constant itself is assigning a name to a Struct
  - assigning an anoymous class/module to a constant in ruby is very special --
    ruby sets the `name` of that class/module to the name of the constant it was
    assigned to
  - can get/set values of a struct using hash syntax
  - equality operator comes for free
  - `Struct`s can introspect and iterate over their elements
  - also come with `Enumerable`
  - `Struct`s can also take a block to have method defined on them
21. serparate domain model logic and UI concerns by pulling out observers and
listeners
  - make the model observable (see gang of four description)
  - create life-cycle methods that get triggered by checking dirty attributes
  - keep controllers' responsibilities limited to current UI state (current
    session, user, response type, etc)
22. do not rescue overly general exception classes
  - do not use rescue inline, except to intercept errors (eg to log or track),
    before passing them along to raise eventually anyway (turning them into
    return values)
  - ruby always stores a reference to the currently raised exception in th `$!`
    variable
    - can `include English` and use `$ERROR_INFO` instead of `$!`
23. tempfiles are removed once the ruby process ends
  - great way to work with clis that expect to work with files as input/output
24. avoid incidental change to make diffs easier to understand
  - no explicit returns (might have to remove them later anyway)
  - use parens when you care about the return value (so you don't have to add
    them later to chain another method, for example)
  - leave a dangling comma at the end of an array to prevent an invalid array if
    you add an element but forget the comma
25. `OpenStruct`s provide a reader method for each key of a hash passed in on
initialization
26. FFI gem allows calling foreign C libraries from within ruby
  - can interface dynamically from within ruby directly to an outside C library,
    and allow the C library to call back in to the ruby program using lambdas
27. use `module_eval` to dynamically define instance methods using a passed-in
key
  - create a new method in the context of a new `Module` (inside an included
    `Module`) to insert it into an object's ancestor chain in a predictable way
  - make generated methods easy to extend by putting them in a module instead of
    adding them to a class
28. can define `.to_s` in an anonymous module to give it a meaningful name
  - can be messy, can also check for a named constant in the current class and
    use that (or a create a new one once) and make its `to_s` method output a
    nice name
29. ruby has special `$stdout` and `$stderr` global variables for standard
output and standard error
  - can define a method to capture output in a `StringIO` object and still
    restore the old `$stdout` afterward
    - `ensure` executes even if an exception is raised inside the block
    - ruby also has `STDOUT` constant that is unaffected by reassigning
      `$stdout`
  - can also capture std io in a separate `Thread` by reading the std output
    using an `IO.pipe`
30. to execute a subprocess in ruby use backticks (can also use `%x{...}`,
useful if the comman itself contains backticks)
  - backticks are actually operator in ruby, so they can be overloaded (but
    don't!)
31. move listener logic into its own classes to make observable pattern easier
to grok
32. block given to a new hash gets executed iff we try to access a missing key
  - useful as a cache for expensive values if the default value is not just a
    value but needs to be calculated or fetched from somewhere, eg via http
  - also useful for defining hashes of arbitrary nesting, can use a new hash
    whose default value is an empty hash, whose default value is an empty hash,
    etc.
33. naming a class is just assigning it to a constant
  - camel cased constants are reserved for class names
  - assigning a class to a constant overwrites the `name` method to be the name
    of the class
34. can use enumerability and introspection features of `Struct` to put data in
and get it out as a hash
  - avoid using `Struct`-specific features (eg `members`) outside of struct
    classes, to make it possible to change the underlying structure of the class
    later
35. use `call` as the method name for executable actions done by an object
  - procs and lambdas respond to `call`, so you can change implementation easily
    without worrying about the callers
  - avoid naming a method something redundant that just reiterates the class
    name (to avoid having things like `notifier.notify`, or `runner.run`)
36. lambdas error with extra arguments, procs will just throw away an extra
argument
  - return statement inside a lambda stops execution of just the lambda itself
  - return statement inside a proc ends execution of the containing method
    - procs contain a reference to their binding (context in which they are run)
      and return acts like a return in _that_ context
37. threequals is the smart equality matcher in ruby
  - used by case statements under the hood
  - Proc class aliases the threequals operator to `call`
  - means you can use them as a predicate in a case statement
38. pass a proc or block as a second argument to a method to allow flexible use
by callers
39. if you don't know how to do something, do a spike -- write some code, don't
worry about testing, and make a skeleton that works
40. can write ruby scripts directly from the command line
  - can change incrementally toward a usable method from this quick and dirty
    approach
  - make small changes so your changes are easy
41. use `scan` on String instead of looping with `match`
42. CPU and IO usually do not kill performance, it's usually RAM
  - ruby is optimized for programmer happiness, not performance
  - e.g. `CSV#read` stores an object in memory for every row it reads
  - use streaming processing by taking advantage of ruby's returning enumerators
    whenever an enumerable method is called without a block
43. `^` is exclusive or in ruby
  - first value must be boolean or nil
44. `one?` returns true iff a collection has only a single truthy value
45. `Hash` uses the same default value everytime if it's given as a default
argument but if it's given a block the block executes on each iteration
46. test right out of the gate to create that culture for your app so that it is
always developed in a test-driven way
47. insert a real thing to check into the system you are testing, so you can be
sure your thing works and that you're not just testing a library
  - add a smoke test that does not get into implementation details to make sure
    you don't completely ruin something when refactoring
48. grab an unbound method object with `instance_method` -- can be bound to a
given instance of a class later with `.bind` and called with `call`
  - use this inside a `memoize` macro to turn any method into one that memoizes
    its return values
49. including a module can be a problem because it makes all that module's
methods part of the public API of the client class
  - it also grabs all the methods in the module, not just the one or two you
    want
  - can solve this by defining a module level version and an instance level
    version of the same method that just calls the module level version
  - module methods intended for internal use only can be made private in a
    module
  - downside is that now you have to define 2 versions of every method you write
  - use ruby's `module_function` macro to do exactly this for free!
50. can put small utility methods inside a top-level namespace to make them
easily and cheaply accessible to client classes
51. structure a project with a top-level file that requires others and a `lib`
directory with the code
  - change the load path (`$LOAD_PATH.unshift(File.expand_path('path/to/lib',
    __FILE__))`) so you can just require your own library and require standard
    libraries inside your code
  - then include your lib modules
52. stubbed objects receiving mocked methods can be hard to understand
  - beware you're not testing implementation details or specific methods, test
    behaviour instead
  - make sure you're testing something real
  - only mock what you own
  - adapter classes are bad to mock -- do not stub external apis
53. test a group of files, just one file, or just one line using your test
library
54. stub an external ffi api and pass it in as an argument on initialization of
a main loop method
55. ruby's `__FILE__` constant always contains the name of the file it is
written in
  - `$PROGRAM_NAME` == `$0` == the name of the currently running program
  - if `$PROGRAM_NAME == __FILE`, the file is being run as a script, so just
    call methods with it using '$stdin' as the input to allow it to double as a
    script and library
  - if they don't match, the file is being used as a library, so don't autorun
    anything
56. use `rcodetools` gem for useful ruby dev tools
  - like `xmpfilter`, it executes ruby code and adds specially formatted
    comments with the value of the previously executed line
  - this is what Avdi uses in the videos to execute code as he goes
57. use rspec mocks instead of minitest combination of `Struct`s, `OpenStruct`s,
and `Mocks` for more readable tests
58. `ARGF` is like a special read-only IO object
  - reading from the `ARGF` constant ruby first looks through the `argv` array
    and treats any arguments there as filenames to open, then it concatenates
    the return values as though all the files were one
  - if there are no arguments in `argv`, ruby treats `ARGF` as an alias for
    `$stdin`
59. an enumerator takes a method that yields mulitple times and can run it
stepwise on demand, instead of all at once
  - turns it into a lazy enumerable block so you can do whatever you want to
    each element
60. use `ascend` from ruby's `Pathname` standard library to see the hierarchy of
directories for a path
61. stub a probe withe a fake method and expect the probe to receive a the
method inside a block to test that the block is really yielded to
  - use `.ordered` option to test that expectations are received in a given
    order
62. an `Enumerator` returns the next value yielded by the method every time
'next' is called
  - `Fiber` is a primitive code block that can be paused and resumed
63. rubygems comes with methods, check them out (e.g. `get_on_gem_name`)
  - write a message first with the arguments you know you'll need and work
    backwards to see what object should be receiving that message
64. ruby's `__callee__` variable always contains the current method name
  - useful to avoid duplication of a method name within itself
65. make sure you clean up resources if you're writing code that is managing a
resource (e.g. a pointer)
  - use `double.as_null_object` to allow a double to receive whatever methods
    you want and don't care about and not blow up
  - use `ensure` to make sure code gets executed even if an exception is raised
    before it
  - make sure it's always possible to access low-level bindings inside of a
    higher-level api
66. avoid calling apis when possible, for performance's sake
  - caching domain objects can be problematic:
    - persisting data means you can't change your domain code unless you
      diligently flush the cache whenever new changes are rolled out
    - adding any new fields also requires flushing the cache, because all old
      cached objects will have `nil` for this new field
    - objects must always be serializable (e.g., cannot store lambdas in them)
  - better to cache raw response bodies rather than domain objects
    - no object version conflicts
    - all available data is there, even the unused parts
    - raw strings are always serializable
67. moneta is an abstraction on top of different types of cache persistence
layers that provides the same interface as a hash
  - build a cache to interface with a hash and moneta can be a drop-in to
    replace the back-end with a number of different storage options
68. invert templating control flow so business objects send messages to a
renderer that knows how to display things to a user
  - models don't care about display logic, they just have to implement a
    `display` method that converts their data into a format a renderer can
    understand
  - this `display` method is the only place where business objects and renderers
    touch, so they can change independently of each other
  - this is one implementation of the builder pattern
69. run tests after every single change -- the sooner you get a failing test,
the more your code stays based in reality
70. `break` can halt execution of any method that yields control to a block --
not just `loop`s
  - still respects `ensure` blocks
71. `break` can take an argument
  - this argument becomes the return value of the method being broken out of --
    the argument to `break` overrides the normal return value
  - reads better and allows you to use loop local variables/methods in the break
    message
72. ruby's file `#read` can take an argument for the number of bytes to read
  - `#seek` can begin reading a file at a given point, given a negative number
    it will read backwards from the given spot
  - `IO` comes with helper constants `IO::SEEK_CUR` and `IO::SEEK_END` that can
    help with reading a file relative to the current stop in the file
73. using `while` as a statement modifier executes the `while` condition first
and then the statement code if necessary
  - adding `while` to modify a `begin` `end` block runs the `while` condition
    _after_ the block has been run at least once
    - same behaviour as a `do` `while` loop in other languages
74. `String#index` gives you the index of the first occurence of the given
character
  - `#rindex` starts from the end of the file and gives you the first occurence
    of the given character
  - strings can be sliced with the subscript operator, `[]`
75. `IO` comes with `#copy_stream` that takes an input and output (both `IO`
objects) and efficiently copies data from one to the other, respecting the
current offset of the input
76. nested loops and complicated conditional statements are characteristic of
unix C source code, but bad style for ruby
  - the point of ruby is that it is easy to read
  - idiomatic ruby has small, descriptive, semantically named methods and few
    conditional statements
77. tracking state as a side effect of a method call is a sign you need a new
object
  - avoid verb-y class names that you try to design to perform a process
    generically
  - try to model entire domain concepts, not processes
78. turn a method that yields into an enumerator with `to_enum`, then you can
control what it does without loops and temporary variables
79. array's `+=` creates a new combined array, `concat` is much faster and
changes the array in place
80. splat operator destructures arrays
  - ruby has multiple assignments
81. implicit splat only works for arrays that are the only argument
  - does not work for `Set`s
  - does not work if the array is the second argument, the whole array just gets
    assigned to the second variable
  - single splatted element in a block behaves like a trailing splatted variable
    in an assignment
82. use inline assignment to make your code more readable and to contain temp
variables to the blocks they're being used in
83. implicit splat doesn't work for `Struct`s
  - ruby decides if something is like an `Array` based on whether or not it
    responds to `.to_ary`
84. ruby can destructure recursively with splat groups, looks like pattern
matching
85. ruby ignores its ignore rules for the `_` variable name
  - you can have `_` multiple times, normally ruby will not let you have the
    same variable name twice in the same scope
86. `super` implicitly sends along all arguments passed into the method
  - you can use just `*` if you never intend to use the arguments you are
    slurping up
    - instead of `*args`, when you don't need any of the arguments, you can just
      use the naked splat `*`
87. extracting a missing domain concept can expose many refactorings
  - think in simple terms and everyday language to come up with good names
88. testing with multiple processes is brittle
  - can use webmock to direct http requests to any rack app to stub network
    requests in a realistic way that still fully tests both ends
89. beware of coincidental duplication (as opposed to true duplication of
knowledge)
  - just because two things appear to be duplicates initially, it doesn't mean
    they really are
  - don't get too attached to old decisions and consider that you may have
    combined too many things together when previously DRYing out your code
90. in ruby, classes are objects, too, and inside a class declaration the `self`
object is the class currently being defined
  - doing `class << self` opens up a window into the class object's singleton
    class, but can be easier to lose track of
91. DCI separates concepts of domain objects and roles those objects play
  - e.g. a `BankAccount` object could be a `TransferSource` or a
    `TransferDestination`
  - same object, but different roles that require different behaviour, so the
    behaviour doesn't belong on the `BankAccount` object
  - can be implemented in ruby using modules and `.extend`
    - `.extend` augments a particular instance (vs. `.include` which augments
      the whole class)
    - a module can never me "un-extended"
    - calling `.extend` can have performance implications in ruby because of how
      it invalidates method lookup tables
  - can be implemented by inheriting from `SimpleDelegator`
    - now the base object and the "role" objects don't have the same class
    - new methods aren't actually added to the model objects themselves (so they
      can't access private methods or instance variables)
  - in ruby 2.x methods defined in a module can be re-bound to any object in the
    system (doesn't have to be of the same class)
92. don't over-dry your code if it means using over-genericized names that
    nobody would actually use in your domain
93. there is no `BooleanClass` in ruby because there is no need to ever
    explicitly declare what type of argument something will be
    - the only shared methods between `TrueClass` and `FalseClass` (`:&`, `:|`,
      `:^`) behave differently for each class -- the only things they ahve in
      common are things they have in common with all objects
94. use `!!` to convert anything to an explicit boolean
99. string subscript operator can take an optional second argument to say which
    match group to return
100. a gateway class knows about an external service and _its_ domain model, but
     does not translate between that domain model and your own
101. use short methods with clear names to explain what you're doing (rather
     than comments)
104. `DateTime._strptime` returns a hash of parsed time parts
105. ruby `$stdout.tty?` will return true if the current standard output is a
     terminal
106. `class << self` opens up the class' singleton class
107. ruby string subscript assignment supports regex groups, named groups, and
     assignment to those groups
108. `nil` means many things in ruby, but the meaning is always contextual
  - many many things return `nil` in ruby
109. Nokogiri SAX parser can take a custom parser that does what it wants in
     response to events
  - model for streaming content: emit an event whenever a relevant node is
    reached

346. user classes tend to really do nothing except map a set of credentials to a
set of roles or permissions
  - you do not need to model your objects in an OO program after actual objects
    in the real world
  - programs never actually interact with the user, they interact with clients
  - name your classes after the relationships and concepts they represent, not
    after real objects in real life
