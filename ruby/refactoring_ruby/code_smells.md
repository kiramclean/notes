# Code Smells

## Duplicated Code

same expression in two methods of same class
  --> Extract Method and invoke code from both places

same expression in sibling sub classes
  --> Extract Method in both classes
  --> Pull Up Method

similar but not same expression in sibling sub classes
  --> Extract Method to separate similar from different parts
  --> Form Template Method

same outcome but using different algorithms
  --> Substitude Algorithm

duplication in the middle of a method
  --> Extract Surrounding Method

same code in unrelated classes
  --> Extract Class or Extract Module
  --> use this new class or module in the other

## Long Method

### Modern object oriented languages have virtually eliminated the overhead associated with in-process method calls, so USE THEM

- do not comment anything, if your code is unclear just make the code more clear instead of littering it with comments
- name methods after the intention of the code, not after how the code does something
- to find clumps of code to extract, look for comments, loops, conditionals

temporary variables inside a method
  --> Replace Temp with Chain or Replace Temp with Query

long parameter lists
  --> Introduce Parameter Object
  --> Preserve Whole Object

when there are tons of temporary variables or long parameter lists
  --> Replace Method with Method Object

conditional expressions exist
  --> Decompose Conditional

loops exist
  --> Collection Closure Methods then Extract Method on the call to the closure method and the closure itself

## Large Class

too many instance variables
  --> Extract Class
  --> Extract Subclass
  --> Extract Module when delegation doesn't make sense

a class does not use all of its instance variables all of the time
  --> Extract Class
  --> Extract Subclass
  --> Extract Module when delegation doesn't make sense

a class has a lot of long methods
  --> Extract Method

## Long Parameter List
- only pass in enough so an object at least knows how to get what it does need

too many parameters being passed into a method
  --> Replace Parameter with Method

parameters being passed in are just data
  --> Preserve Whole Object

severeal data parameters with no logical object
  --> Introduce Parameter Object
  --> Introduce Named Parameter to at least make it more clear

## Divergent Change

a class is commonly changed in different ways or for different reasons
  --> Extract Class to extract everything that changes for a particular reason

## Shotgun Surgery

- there should be a one-to-one relationship between changes and classes -- I want to change one thing about how the app works, I should only have to touch one class

have to make a lot of little changes to a lot of different classes to make a change
  --> Move Method and Move Field to gather all changes in a single class
  --> Inline Class to bring behaviour together

## Feature Envy

- the whole point of objects: to package data with the processes used on that data
- put things together that change together

a method seems more interested in a different class than the one in which it is defined
  --> Move Method to put the method where it belongs

part of a method is using mostly data from another class
  --> Extract Method then Move Method

## Data Clumps

parameters or data that always travel around together
  --> Extract Class

when these lists are passed around as parameters
  --> Parameter Object or Preserve Whole Object

- if you removed one of the data values, would the others make sense? If not, you need a class

## Primitive Obsession

- use small objects for small tasks, like special strings for phone numbers or zip codes

conditionals that depend on a type code
  --> Replace Type Code with Polymorphism
  --> Replace Type Code with Module Extension
  --> Replace Type Code with State/Strategy

## Case Statements

case statements exist
  --> Extract Method to extract the case statement
  --> Move Method to move it to the class where the type codes are found
  --> Replace Type Code with Polymorphism
  --> Replace Type Code with Module Extension
  --> Replace Type Code with State/Strategy

one of the conditional cases is null
  --> Introduce Null Object

a few conditional cases that are unlikely to change
  --> Replace Parameter with Explicit Methods

## Parallel Inheritance Hierarchies

- special case of shotgun surgery

have to make a subclass of some class everytime you make a subclass of another
  - obvious when prefixes for names are the same in both hierarchies
  --> Move Method then Move Field to make instances of one hierarchy refer to instances of the other

## Lazy Class

class that doesn't warrant its own existence
  --> Collapse Hierarchy

close to useless class
  --> Inline Class
  --> Inline Module

## Speculative Generality

classes or modules that aren't doing much
  --> Collapse Hierarchy

unnecessary delegation
  --> Inline Class

methods with unused parameters
  --> Rename Parameter

methods with odd names
  --> Rename Method

- when the only users of some code are test cases

## Temporary Field

- an instance variable being set in only some circumstances
- an object should need all of its variables

orphan variables
  --> Extract Class

conditional code where one condition is null
  --> Introduce Null Object

## Message Chains

client is coupled to the structure of the navigation
  --> Hide Delegate
  --> Extract Method for the code that the end object is being used for
  --> Move Method to push this down the chain

## Middle Man

most of a class' methods are delegating to another class
  --> Remove Middle Man and talk to the object of interest directly

some of a class' methods are delegating to another class
  --> Inline Method

delegate methods are actually executing behaviour
  --> Replace Delegation with Hierarchy

## Inappropriate Intimacy

classes know too much about each other
  --> Move Method
  --> Move Field to separate pieces
  --> Change Bidirectional Association to Unidirectional

classes know too much about each other because they have a common interest
  --> Extract Class
  --> Hide Delegate

subclasses know too much about their parents
  --> Replace Inheritance with Delegation

## Alternative Classes with Different Interfaces

more than one method that does the same thing but with different signatures
  --> Rename Method
  --> Move Method until signatures are the same
  --> Extract Module or Introduce Inheritance if this causes duplication

## Incomplete Library Class

behaviour in objects that belongs in a library once specs are clear
  --> Move Method to reopen library class

## Data Class

classes with only attributes and nothing else
  --> Remove Setting Method for any instance variable that should not be changed

collection of instance variables with poor encapsulation
  --> Encapsulate Collection

getter or setter methods are being used by other classes
  --> Move Method
  --> Hide Method on getters and setters

## Refused Bequest

subclasses that do not respond to implementations of the superclass
  --> Push Down Method into sibling class, parent holds only what is common

subclasses do not support public behaviour of the superclass
  --> Replace Inheritance with Delegation

## Comments

- comments are usually present because the code is bad
- refactor until the comments are redundant
- if you must comment, it should be about *why*, not *how*

comment explains what a block of code does
  --> Extract Method

method is extracted but commented to explain what it does
  --> Rename Method

comments explain rules about the required state of a system
  --> Introduce Association

## Metaprogramming Madness

`method_missing` hook that is used other than when an object's interface cannot be determined at coding time
  --> Replace Dynamic Receptor with Dynamic Method Definition

`method_missing` call is necessary
  --> Isolate Dynamic Receptor

## Disjointed API

project does not take advantage of all the configuration options
  --> Introduce Gateway

project is not interacting with an external API in a fluent way
  --> Introduce Expression Builder

## Repetitive Boilerplate

when the purpose of the code can be captured clearly in a declarative statement
  --> Introduce Class Annotation
