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
