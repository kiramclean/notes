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
    
## Hash pointers
- tell you where something is, but also whether it changed or not
- used to build data structures
  - can be used for tamper-evident logs
  - each block includes data and a hash pointer to the previous block
  - can't tamper with a linked-list built with hash pointers because eventually you would have to tamper with the genesis hash
  
### Merkle trees
- only need to remember the root hash (256 bits) to hold many items that can't be tampered with without us knowing about it
- can verify membership in the tree in `O(log n)` time and space
- has a sorted variant (data at the bottom of the tree is sorted) and can prove *non*-membership in this in `O(log n)` time and space

- can use hash pointers ina ny pointer-based data structures that has no cycle
  - there has to be some item in the struture that has no pointers coming out of it so we can work backwards
 
## Digital signatures
- only you can sign, but anyone can verify
- tied to a specific document
- requires three operations:
  - generate keys (secret key and public key that go together)
    - only the person with the secret key can make signatures
  - sign (secret key and a message)
  - verify (public key, message, and signature)
    - always deterministic, the other two are randomized algorithms (need a true source or randomness)
- there's a limit to the message size in principle, so we hash the message first and use the hash
  - you can also sign a hash pointer
  - if you sign a hash pointer, the signature applies to the entire data structure underneath that pointer
  
  
    
    
  
  
