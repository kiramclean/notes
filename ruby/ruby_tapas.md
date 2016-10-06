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
