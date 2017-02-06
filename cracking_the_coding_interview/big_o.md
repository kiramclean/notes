# Big O

## O, Theta, Omega

O -> upper bound on the time
Omega -> lower bound on time
Theta -> both (tight bound on time)

## Best case, worst case, expected case

best case -> not useful, most algorithms can be run with contrived input to obtain a best case runtime
worst case -> usually the same as expected case, good to be aware of
expected case -> real world expectation given normal data, usually the same as worst case

## Big O

- about how a runtime scales -- O(N) is not always better than O(N^2), input matters
- don't care about constants -- don't matter at scale
- drop non-dominant terms -- also don't have meaningful impact at scale
- add runtimes if 2 different chunks of work are done one after the other (do this, then do that -> `+`)
- multiply the runtimes if a chunk of work needs to be done for each element of another iteration (do this for each time you do that -> `*`)
- "Amortized Time" refers to spreading out the worst-case occurences over time to avoid counting the worst case as representative

`O(log N)` -> usually when the number of elements is halved every iteration

- base of the log doesn't matter for the purposes of big O
  - logs of different bases are only different by a constant factor, and we ignore constants anyway
    - `log 2 n` = `(log 5 n) / (log 5 2)` --> `log 5 n` = (`log 2 n`) * `(log 2 n)`
  - bases of exponents DO matter -- they are different by exponential fators, not constant factors
  - `8^n` = `(2^3)^n` = `2^(3n)` = `2^(2n)` * `2^n` != `2^n` !!!


`O(branches ^ depth)` -> when the algorithm is recursive and makes multiple calls
  - `branches` is the number of times each recursive call branches
  - applies to time complexity
  - space complexity can be less (O(N)), because only some of the nodes will exist at any time


