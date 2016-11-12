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

