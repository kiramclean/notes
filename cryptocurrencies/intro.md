# Introduction to Crypto and Cryptocurrencies

## Hash functions
Must be:
- collision free
  - nobody can find `x` != `y` such that `H(x)` = `H(y)`
  - collisions do exist, but they have to be unfindable
    - given 2^130 random inputs, there's a 99.8% chance that 2 of them will be the same no matter what the hash funciton is, but this takes too long too matter
  - some hash functions are easier to find collisions
  - no hash function has been proven collision-free
  - they need to be though, because we need to use them for hashing
  - if we know `H(x)` = `H(y)`, we can assume `x = y`, since the hash function should be collision-free
    - useful for securely storing sensitive data, also for digesting messages for easy comparison
- hiding
  - if we know `H(x)`, it should be infeasable to determine `x`
  - this is not true if `x` is particularly likely to occur
  - can fix this by choosing an `r` from a probability distribution with high min-entropy (very spread-out) so that given `H(r|x)` it is infeasable to find `x`
    - all possible values of r need to have the same negligible probability of being chosen
  - useful for commitment
    - you can encrypt a value with a given key and make it public, then only those with the right key can decrypt the message later
  - given a hashed commit, it should be infeasible to find the encrypted message
  - also has to be binding -- once a message is committed, it is infeasible to find two messges that are the same but have different hashes

  mathematically:
    `commit(msg) := (H(key|message), key)` where `key` is a random 256-bit value
    `verify(com, key, message) := (H(key|message) == com)`
- puzzle-friendly
  - for every possible output value `y`, if `k` is chosen from a distribution with high min-entropy, it needs to be infeasible to `x` such that `H(key|x) = y`
  - if someone knows the output they're looking for and finds part of the input, they shouldn't be able to find the rest of the input they need to crack the hash
  - given a puzzle id `id` from a high min-entropy distribution and a target `Y`, find a solution `x` such that `H(id|x) belongs to the set Y`
    - if the hash is puzzle-friendly, it means there should be no strategy for solving this than trying random values of x
