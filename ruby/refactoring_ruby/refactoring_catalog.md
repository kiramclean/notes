# Refactorings

- name
- summary
- motivation
- mechanics
- examples

## Composing Methods

### Extract Method
pp 102-108

- a fragment of code that can be grouped together
- turn the fragment into a method whose name explains the purpose of the method

- enables reuse when methods are very small
- makes code more readable because higher level methods read like comments

1. create a new method and name it after the intention of the method (_what_ it does, not _how_ it does it)
2. copy the extracted code from the source method into the new target
3. check for local variables and parameters local to the source method
  - if local variables are just read and not changed they can just be passed in to the new method as parameters
  - if they are changed but only in the extracted code just move the temp into the extracted code
  - if they are changed _and_ used outside the extracted code, you have to return the changed value
4. declare any temp variables in the extracted code in the target method
5. check whether any of these local variables are modified by the extracted code
6. pass local variables into the target method as parameters
7. replace the extracted code in the source method with a call to the new method

- local variables that are read but not changes can be passed as params
- assignment to param => Remove Assignments to Parameters
- tons of temp variables everywhere => Replace Temp with Query
- still have messy methods => Replace Method with Method Object

### Inline Method
pp 108-110

- when a method's body is just as clear as its name it doesn't justify its own existence

1. check that the method is not polymorphic and not being overridden by any subclasses
2. find all calls to the method
3. replace each call with the method body
4. delete the old method

- if there's anything complicated (recursion, multiple return points, no access to instance variables), don't do this

### Inline Temp
p 110

- temp assigned to a simple expression once
- mostly used in conjunction with Replace Temp with Query

1. find all references to the temp, replace with the assignment
2. remove declaration and assignment of the temp

### Replace Temp with Query
pp 111-114

- using a temp variable to store the result of an expression
- move this temp to a method

1. extract the expression into a private method
2. make sure the extracted method has no side effects, otherwise use Separate Query from Modifier
3. inline temp on the temp

### Replace Temp with Chain
pp 114-117

- using a temp to store the result of an expression
- chain together subsequent calls to the same object

1. return `self` from methods that you want to allow chaining from
2. remove local variable and chain the method calls

### Introduce Explaining Variable
pp 117-121

- explain a complicated expression with a variable that describes it
- avoid introducing temps if you can

1. assign a variable to the result of the complicated expression
2. replace the expression with the new variable

### Split Temporary Variable
pp 121-124

- the same temp is assigned to more than once
- use different variable names for different temp variables
- do not use the same temp variable name twice

1. change the name of a temp at the first assignment
2. change all the references to the temp up to the second assignment
3. repeat, renaming each assignment and changing references until next assignment

### Remove Assignments to Parameters
pp 124-127

- don't do this, use a temp variable instead
- ruby uses exclusively pass by value (as opposed to pass by reference)

1. create a temp variable for the parameter
2. replace all references to the parameter after the assignment to the temp
3. change the assignment to refer to the temp

- object reference is always passed by value, so you can change the state by calling the given reference and those changes get propagated up the stack
- assigning to the reference does not affect the value outside the scope of the method body though

### Replace Method with Method Object
pp 127-131

- local variables are used in a long method that prevents use of Extract Method
- turn the long method into its own object and all the local variables become instance variables on that object
- then decompose the method into other methods on the same object

1. create a new class, name it after the long method
2. give the new class an attribute for the object that had the original method
3. initialize the new object with the source object and each local variable as a param
4. give the new class a method named `call`
5. copy the body of the original method into `call`, using the source object instance variable for any invocations of methods on the original object
6. replace old method with one that creates the new object and calls `call`


### Substitute Algorithm
pp 131-132

- your algorithms should be as simple as possible

1. prepare the alternative algorithm that outputs the same thing
2. substitute it if it works

- use the old algorithm to compare output to make sure they're the same

### Replace Loop with Collection Closure method
pp 133-135

- don't use loops in ruby, use enum methods

1. identify the basic pattern of the loop
2. replace the loop with the appropriate collection closure method

### Extract Surrounding Method
pp 135-139

- two methods are almost identical except for the middle part
- extract duplication into a method that takes a block and yields back to caller to execute different code

1. use Extract Method on one piece of duplication, name if for the duplicated behaviour
2. modify the calling method to pass a block to the above surrounding method
3. copy the unique logic from the surrounding method into the block
4. replace the unique logic in the extracted method with the yield keyword
5. pass any variables needed by the unique logic as params to the yield call
7. modify other methods that can use the new surrounding method

### Introduce Class Annotation
pp 139-142

- initialization steps are so simple they can be hidden

1. declare the signature of the annotation in the right class
2. convert original method to a class method and make it work in class scope -- make sure it is defined before the class annotation
3. consider Extract Module on the class method to make the annotation more prominent

### Introduce Named Parameter
pp 142-147

- parameters are not obvious from the name of the method
- use named keyword arguments

1. choose the params that should be named
2. replace the params in the calling code with key/value pairs
3. replace params in the receiving method

### Remove Named Parameter
pp 147-150

- more readability isn't worth the indirection
- put back the named params to standard param list

1. choose the param whose name you want to remove and move it to the beginning of the param list
2. replcae the named param in the calling code

### Remove Unused Default Parameter
pp 150-152

- method param has a default value, but the method is never called without this param
- unused flexibility is bad

1. remove the default from the method signature
2. remove any code that checks for the default value

### Dynamic Method Definition
pp 152-158

- methods could be more concise if they were defined dynamically

1. dynamically define one of the similar methods
2. convert the additional similar methods to use the dynamic definition

### Replace Dynamic Receptor with Dynamic Method Definition
pp 158-160

- you want to define methods dynamically but not have to deal with the pain of debugging `method_missing`
- use dynamic method definition instead of dynamic method receiving
- only use `method_missing` if your class absolutely must respond to unknown method calls -- can lead to the wrong class raising a `NoMethodError`


1. dynamically define the necessary methods
2. remove `method_missing`

### Isolate Dynamic Receptor
pp 160-165

- move `method_missing` logic to its own class when a class containing it has become painful to change
- when the interface of a class really cannot be predetermined and you have to use `method_missing`, isolate its use

1. create  new class whose sole responsibility is handling dynamic method calls
2. copy the logic from `method_missing` on the original class to the `method_missing` of the new class
3. create a method on the original class to return an instance of the new class
4. change all client code that previously called the dynamic methods on the original object to call the new delegator method
5. remove `method_missing` from the original object

### Move Eval from Runtime to Parse Time
pp 165-166

- if you need `eval`, limit its use to parse time
- move it from within the method definition to defining the method itself

1. expand the scope of the string being `eval`-ed to include the method definition itself

## Moving Features Between Objects

### Move Method
pp 167-172

- a method is or will be used more by another class than its own class
- move the method to the class that uses it the most

1. examine all the features used by the source method that are defined on the source class, consider whether these should be moved, too
2. check sub- and super-classes of the source class for other definitions of the method
3. define the method in the target class
4. copy code from source to target
5. reference the right target from the source
6. turn the source method into a delegating method
7. decide to either remove the source method completely or leave it as a delgating method
8. if you remove the source method, replace all the references with references to the target method

### Move Field
pp 172-175

- a field is or will be used more by another class than its own class
- create a new attribute reader in the target class and change all its users

1. use Self Encapsulate Field if the methods that access the field will be moving too or if a lot of methods access the field
2. create a reader in the target class
3. reference the target object from the source
4. replace all references to the source field with references to the target

### Extract Class
pp 175-179

- a class is a crisp abtraction with a few clear responsibilities
- extract subsets od data and subsets of methods that go together

1. split the responsbilities of the class
2. create a new class to express these new responsbilities
3. link to the new class from the old
4. use Move Field on each field you're moving
5. use Move Method on each method you're moving, starting with lower level methods
6. review and reduce the interfaces of each class, try to make only one-way links
7. decide whether multiple clients are allowed to access this new class, if so, decide whether the new class should be a reference object or immutable value object

- good for concurrency because you can have separate locks on the separate classes

### Inline Class
pp 179-181

- a class doesn't really do anything
- move the runt class to the other class that uses it the most

1. declare the public api of the source class onto the absorbing class and delegate all methods to the source class
2. change all reference from the source class to the absorbing class
3. use Move Method and Move Field to move features from source to absorbing until there is nothing left

### Hide Delegate
pp 182-184

- a client calls a delegate class of an object
- objects need to know as little as possible about the system as a whole

1. for each method on the delegate, create a simple delegating method on the sender
2. adjust the client call to the sender
3. if no one needs the delegate anymore, remove the accessor for it

### Remove Middle Man
pp 185-186

- when there is too much delegation
- call the delegate directly

1. create an accessor for the delegate
2. remove the method from the sender and replace the client call to the method directly on the delegate

## Organizing Data

### Self Encapsulate Field
pp 188-191

- accessing a field directly has caused awkward coupling
- use getters and setters
- advantages of indirect variable access:
  - allows subclasses to override how they want to get that information
  - supports more flexibility in managing data (e.g. lazy initialization)
- advantages of direct variable access:
  - code is easier to read

1. create a setting method for the field
2. find all the references to the field and replace them with the getters and setters
3. double check you got all the references

### Replace Data with Value Object
pp 191-194

- data needs behaviour
- turn the data into an object

1. create a class for the value
2. change the attribute reader in the source class to call the reader in the new class
3. assign the field in the source class using the consstructor in the new class if the field is in the source class constructor
4. change the attribute reader to create a new instance of the new class
5. maybe do Change Value to Reference

- value objects should be immutable
- if you need a value object to change or to be associated with many other objects, use Change Value to Reference

### Change Value to Reference
pp 194-198

- a class has many equal instances that can be replaced with a single object
- turn the object into a reference object
- reference objects stand for one object in the real world (customer, order, account), use object identity to test whether they are equal
- value objects are defined only through their data values, can have many duplicates floating around, use values to test whether they are equal

1. use Replace Constructor with Factory Method
2. decide what object is responsible for providing access to the objects
3. decide whether the objects are pre-made or created on the fly
4. alter the factory method to return the reference object

### Change Reference to Value
pp 198-201

- a reference object existst that is small, immutable, and awkward to manage
- make it a value object
- do this when a reference object becomes difficult to manage
- value objects must be immutable
- relationships to value objects can change, but the objects themselves cannot

1. check that the candidate object is immutable or can be made immutable
2. create an `==` method and an `eql?` method
3. create a hash method
4. consider removing any factory method and making a constructor public

- need to write a `hash` method or else `Hash` and any collection that relies on hashing, like `Array`'s `uniq` method will be weird

### Replace Array with Object
pp 201-206

- an array exists where different elements mean different things
- replace the array with an object that has a field for each element
- use arrays only to contain a collection of similar objects in some order
- don't count on remembering the order of an array's elements

1. create a class to represent the information in the `Array`
2. define `[]` and `[]=` methods so callers expecting an array can be changed one by one
3. construct the new object wherever the `Array` was instantiated
4. add readers for each element in the `Array`, named after the purpose of the `Array` element, changing the clients to use this reader
5. add writers for any attribute in the `Array` that is written to by a client, named after the purpose of the `Array` element, changing the clients to use these writers
6. when all `Array` accesses are replaced by custom accessors, remove the `[]` and `[]=` methods

### Replace Hash with Object
pp 206-210

- a hash exists that is storing many different types of objects and is used for more than one purpose
- replace the hash with an object that has a field for each key
- only use hashes to store similar values
- you shouldn't have to remember what keys a hash has to know what it is for

1. create a new class to represent the information in the `Hash`
2. define `[]` and `[]=` so callers expecting a hash can be changed one by one
3. construct the new object wherever the `Hash` was instantiated
4. add readers for any attribute in the `Hash` that is read, name the reader after the key, change the clients to use this reader
5. add writers for any attribute in the `Hash` that is written to, name the writer after the key, change the clients to use the writer
6. when all the `Hash` accesses are replaced by custom accessors, remove the `[]` and `[]=` methods

### Change Unidirectional Association to Bidirectional
pp 210-213

- two classes are using each others' features, but there is only a one-way link
- add back pointers and change modifiers to update both sets
- an object needs to get access to other objects that refer to it.. this is going backwards along the pointer
- pointers are one-way links, so you have to use a back pointer

1. add a field for the back pointer
2. decide which class will control the association
3. create a helper on the non-controlling side of the association, name it to show its restricted use
4. if the existing modifier is on the controlling side, modify it to update the back pointers
  - if the existing modifier is on the controlled side, create a controlling method on the controlling side and call it from the existing modifier

- use a set if you want a collection that cannot contain the same item more than once
- pattern is always: tell the other object to remove its reference to you, set your pointer to the new object, tell the new object to add a pointer to you

### Change Bidirectional Association to Unidirectional
pp 214-217

- two classes are using each others' features and one no longer needs features from the other
- drop the unneeded end of the association
- bidirectional associations can lead to zombie objects, that should be gone but aren't because of a reference that wasn't cleared

1. examine the readers of the field that holds the pointer to see if you can remove it
  - see if it's possible to determine the other object without using the pointer
2. if clients need the reader, use Self Encapsulate Field, then use Substitute Algorithm on the attribute reader
3. if clients don't need the reader, change each user of the field so it gets the object field in a different way
4. once there is no reader left in hte field, remove all updates to the field and remove it

### Replace Magic Number with Symbolic Constant
pp 217-218

- a literal number has a particular meaning
- create a constant and name it after the meaning then replace the number with it
- numbers with special meaning that is not obvious are bad

1. declare a constant and set it to the value of the magic number
2. find all occurrences of hte magic nuimber
3. if the number is the same as the constant, use the constant instead

### Encapsulate Collection
pp 219-224

- a method returns a collection
- return a copy of the collection instead and provide add/remove methods
- client accessors should not be able to alter the contents of another object's collections
- any accessor for a collection should prevent manipulation of the collection and hide details about its structure
- only expose a way to add or remove elements, not to change the existing elements in the collection -- the owning class owns the collection

1. add `add` and `remove` methods for the collection
2. initialize the field to an empty collection
3. find callers of the attribute writer, modify the writer to use `add` and `remove`
4. find all users of the reader that modify the collection, change them to use the `add` and `remove` methods
5. when all the uses of the reader that modify the collection have been changed, modify the reader to return a copy of the collection
6. find the users of the attribute reader, move code to the host object where necessary

### Replace Record with Data Class
pp 224

- you need to interface with a record struture in a traditional programming environment
- make a dumb data object for the record
- can be useful to create an interfacing class to deal with the external record
- also when you have an Array where an index has a special meaning (use Replace Array with Object)

1. create a class to represent the record
2. give the class a field with an accessor for each data item
3. now you have a dumb data object with no behaviour

### Replace Type Code with Polymorphism
pp 225-232

- a type code affects the behaviour of the class
- replace the type code with classes - one for each type code variant
- can usually tell by the presence of a case statement
- when removing conditional logic, use:
  - Replace Type Code with Polymorhpism
    - when the methods using the type code make up most of the class
  - Replace Type Code with Module Extension or Replace Type Code with State/Strategy
    - when the class has a lot of behaviour that doesn't depend on the type code
    - Module Extension mixes in type code behaviour, instance variables are automatically shared bewteen object and module, which is simpler
    - State/Strategy uses delegation, no sharing of instance variables, but this extra behaviour can be limited (unlike Modules, which you can't unmix)

1. create a class to represent each type variant
2. change the class that uses the type code into a module, include this module in each of the new type classes
3. choose one of the methods that uses the type code, override this method on one of the type classes
4. do the same for all the other type classes, removing the method on the module when you're done
5. repeat for the other methods that use the type code
6. remove the module if it no longer houses any behaviour

### Replace Type Code with Module Extension
pp 232-238

- type code affects the behaviour of a class
- replace hte type code with dynamic module extension
- the original class and the module both have access to the same instance variables
- modules cannot be unmixed -- once they are included in a class, their behaviour is hard to remove

1. perform Self-Encapsulate Field on the type code
2. create a module for each type code variant
3. make the type code writer extend the type module appropriately
4. choose one of the methods that use the type code and override this method on one of the type modules
5. do the same for the other type modules, returning default behaviour from the class
6. repeat for other methods that use the type code
7. pass the module into the type code setter instead of the old type code

### Replace Type Code with State/Strategy
pp 239-251

- a type code affects behaviour of a class and the type code changes at runtime
- replace the type code with a state object
- goal is to remove conditional logic
- use when the type code is changed at runtime and change procedure is complex enough that module extension doesn't work
- strategy is a better term for simplifying a single algorithm
- if you're moving state-specific data and the object is changing states, use "state pattern"

1. perform Self Encapsulate Field on the type code
2. create empty classes for each of the polymorphic objets and a new instance variable to represent each of the types (this is object that we delegate to)
3. use the old type code to determine which of the new type objects should be assigned to the type instance variable
4. choose a method to behave polymorphically, add a method with the same name on the type classes and delegate to it from the parent object
5. repeat for the other type classes
6. repeat for all the other methods that use the type code

### Replace Subclass with Fields
pp 251-255

- subclasses that vary only in methods and return constant data
- change the methods to superclass fields and eliminate the subclasses
- any class that has only constant methods does not justify its existence

1. Replace Constructor with Factory Method on the subclasses
2. modify the superclass constructor to initialize a field for each constant method
3. add or modify subclass constructors to call the new superclass constructor
4. implement each constant method in the superclass to return the field and remove the method from the subclasses
5. when all the subclass methods have been removed, use Inline Method to inline the constructor into the factory method of the superclass
6. remove the subclass
7. repeat inlining the constructor and eliminating each subclass until they are all gone

### Lazily Initialized Attribute
pp 255-257

- initialize an attribute on access instead of at construction time
- makes code more readable because lazily initialized attributes can encapsulate all their initialization logic within the methods

1. move initialization logic to the attribute reader

- typical idiom is to use `||=`, but this doesn't work when `false` or `nil` are valid values for the attribute
  - in that case use `instance_variable_defined?`

### Eagerly Initialized Attribute
pp 257-259

- initialize an attribute at construction instead of on first access
- lazy loaded attributes can change their values on access, eagerly initialized attributes encapsulate all initialization logic in the constructor and return consistent results

1. move initialization logic to the constructor

## Simplifying Conditional Expressions

### Decompose Conditional
pp 261-264

- extract methods from the `elsif` and `else` branches of a conditional statement

1. extract conditions into methods
2. extract the branches into methods

### Recompose Conditional
pp 264-265

- use `||` instead of ternary operator when you're checking for `nil`
- use guard clauses instead of simple `if/else` statements

### Consolidate Conditional Expression
pp 265-267

- you have a sequence of conditional tests that all return the same thing
- use `&&` and `||` then extract a method that explains what you're really looking for and use it

1. check that none of the conditionals has side effects
2. replace the string of conditionals with a single statement using `&&` and/or `||`s
3. consider Extract Method on the condition

### Consolidate Duplicate Conditional Fragments
pp 268-269

- same code appears in all branches of a conditional statement
- move it outside the conditional statement

1. identify code that is executed the same way regardless of the condition
2. if the common code is at the beginning, move it to before the conditional, if it's at the end, move it outside after the conditional

### Remove Conditional Flag
pp 269-274

- a variable is acting as a control flag for a series of boolean expressions
- use `break` or `return` instead

1. find the value of the control flag that gets you out of the logic statement
2. replace assignments of the break-out value wtih a `break` or `next` statement

- can also use `return`

### Replace Nested Conditional with Guard Clauses
pp 274-279

- use when a conditional statement is confusing and does not make the path of execution clear
- remove all nesting and use guard clauses instead

1. put in a guard clause for each check being done inside a nested conditional

### Replace Conditional with Polymorphism
pp 279-284

- you have a conditional that chooses different behaviour depending on the type of an object
- move each leg of the conditional to a method in an object that can be called polymorphically

1. if the conditional is one part of a larger method, take apart the conditional statement and use Extract Method
2. Move Method if necessary to put the conditional in the right place in the object
3. create a method on one of the polymorphic objects that will override the conditional statement method
4. remove the copied leg of the conditional statement
5. repeat for each leg of the conditional until all legs are turned into polymorphic methods

### Introduce Null Object
pp 284-292

- you check for `nil`
- replace `nil` with a null object

1. create the null object class
2. return this object instead of `nil` wherever `nil` could come up
3. look for places where you're checking for `nil`
4. define the method being checked in your null object and remove the check for `nil`

- define `missing?` and switch all the checks for `nil` with this new method as an intermediary step

### Introduce Assertion
pp 292-295

- a piece of code is assuming something about the current state of the program
- make the assumption explicit with an assertion

1. when you see a condition that is assumed to be true, explicitly assert it instead

- avoid doing this in production because it is slow, set up to only evaluate in dev

## Making Method Calls Simpler

- be careful replacing parameter lists with with objects, unless they are immutable
- be diligent about clearly separating methods that change state and methods that query state
- all data should be hidden
- interfaces should be as minimal as possible

### Rename Method
pp 298-300

- a method name does not reveal its purpose
- code is for humans first, computers second

1. check to see whether the method signature is implemented by any sub- or super-classes, if it is, change those too
2. declare a new method with the new name
3. copy the old method code into the new method and make it work
4. change the old method to just call the new method
5. find all references to the old method name and change them to refer to the new method name
6. remove the old method
  - if you can't, mark it as deprecated and add a warning for a future release

### Add Parameter
pp 300-302

- a method needs more information from its caller
- consider carefully whether you need this
  - can an object you're already passing get the relevant information?
  - should the behaviour be on another object?
  - are there any data clumps in your params?

1. check whether the method signature is implemented anywhere else
2. declare a new method with the added parameter
3. change the body of the old method so it calls the new one
4. find all references to the old method and change them to refer to the new one
5. remove the old method

### Remove Parameter
pp 302-303

- a method is no longer using one of the parameters it is being given
- a parameter indicated necessary information; if it's unnecessary, remove it

1. check whether the method signature is implemented anywhere else
2. declare a new method without the parameter and copy the old method body into it
3. change the body of the old method to call the new one
4. find all references to the old method and change them to refer to the new one
5. remove the old method
6. rename the new method to make it the old method's name

### Separate Query from Modifier
pp 303-307

- a method returns a value and changes the state of an object
- create two methods for the different responsibilities
- clearly signal the difference between methods with side effects and methods without
- any method whose return value is intended to be used by the caller should have no side effects

1. create a query that returns the same value as the original method
2. modify the original method so it returns only the result of calling the new query method
3. for each caller, add to the single call to the original method a call to the new query method
4. remove the return expressions from the original method

- for ruby or other languages with bad concurrency models, create one `query_and_modify` method that calls two separate `query` and `modify` methods, so that the code is executed synchronously in the right order

### Parameterize Method
pp 307-310

- several methods do simliar things but just with different values in the method body
- extract the different part into a parameter and make a method that takes an argument

1. create a parameterized method that can be substituted for each repetitive method
2. replace one old method with a call to the new one
3. repeat for all the methods

### Replace Parameter with Explicit Methods
pp 310-313

- code runs differently depending on the value of an enumerated parameter
- create a separate method for each value of the parameter
- do this if you see conditional checks on a method param inside of a method

1. create an explicit method for each value of the parameter
2. for each leg of the conditional, call the appropriate new method
3. replace each caller of the conditional method with a call to the appropriate new method
4. when all callers are changed, remove the conditional method

### Preserve Whole Object
pp 313-317

- you get several values from an object and pass them as parameters in a method call
- send the whole object along instead of breaking it up into parameters
- this makes it difficult to change all the calls to that method that takes a ton of params later

1. create a new parameter for the whole object from which the data comes
2. determine which parameters should be obtained from the whole object
3. take one parameter and replace references to it within the method body by invoking an appropriate method on the whole object parameter
4. delete the parameter
5. repeat for each parameter that is now on the whole object
6. remove code in the calling method that gets the deleted parameter

### Replace Parameter with Method
pp 317-320

- an object invokes a method, then passes the result as a parameter for a method
- just let the receiver invoke the method and remove the parameter
- reducing the length of parameter lists is good, so if a method can get a value it needs in another way than as a parameter, it should

1. extract any calculation of the parameter into a method
2. replace references to the parameter in method modies with references to the new method
3. use remove parameter on the parameter

### Introduce Parameter Object
pp 320-324

- you have a group of parameters that naturally go together
- replace them with an object

1. create a new class to represent the group of parameters you are replacing and make it immutable
2. use add parameter for the new data clump and give it a default value
3. for each parameter in the data clump, remove the parameter from the signature
4. modify the callers and method body to use the parameter object for that value
5. when you have removed the parameters, look for behaviour that you can move into the parameter object with move method
6. remove the default value for the new parameter because this new method should never be used without the parameter

### Remove Setting Method
pp 324-327

- a field should be set at creation time and never altered
- remove all setting methods for that field
- exposing a setting method indicates that a field can be changed
- if it shouldn't be changed, remove the setter method

1. check that the setting method is only used in the constructor
2. modify the constructor to access the variables directly
3. remove the setting method

### Hide Method
pp 327-328

- any method that is not being used by any other class should be private

1. check regularly for opportunities to make a method more private
2. make every method as private as you can

### Replace Constructor with Factory Method
pp 328-

- when an object requires more than simple constructor, move initialization to a factory method
- prevents duplication of initialization logic
- encapsulates knowledge of an object's attributes into the object itself

1. do Extract Method to isolate construction logic
2. Move Method to the desired object if you have to
3. remove the original constructor
