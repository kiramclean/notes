# XOR

- true when either the first or second input (but *not* both) is true
- looks like a circle with a cross in it

`0 XOR 0 = 0`
`0 XOR 1 = 1`
`1 XOR 0 = 1`
`1 XOR 1 = 0`

- XOR can be applied in any order.. doesn't matter (XOR is commutative)
- any bit XOR itself == 0 (false)
- any bit XOR 0 == that bit
  (`a XOR 0 = a`, `0 XOR a = a`)
- `a XOR b XOR a == b`
  (`a XOR b XOR a = a XOR a XOR b`
                  = `0 XOR b`
                  = `b`
                  
- so it's like the first XOR is encrypting `b` and the second is decrypting `b`

## Bitwise XOR

- that (☝️️) only works on a single boolean value or bit
- a bitwise XOR operator performs XOR on each bit in a value

## One-time pads

- perfectly secure if the pad is truly random
- can only be used once
- multi-time pads are vulnerable to crib-dragging
  - looking for small sequences expected to occur with high probability
  - XOR-ing two encrypted texts can tell you a lot about the plain text
- very impractical
- for the key to work it would have to be at least as large as all the information you are transmitting put together
- you would have to transmit those keys securely to all the people you want to communicate with in advance
- generating truly random keys is hard and time consuming
