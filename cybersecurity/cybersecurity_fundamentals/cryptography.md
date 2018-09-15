# Cryptography

## Kerckhoff's Principle
- only secrecy of the key provides security

## Shannon's Maxim
- the enemy knows the system
  - why security through obscurity doesn't work
  - have to assume your enemy knows the system

## Symmetric encryption
- uses the same key to encrypt and decrypt the message
- fast, but vulnerable, you have to distribute a secure key over an insecure medium
  - if someone gets the key, they could decrypt, change, then re-encrypt the message without anyone knowing
- includes DES, 3DES, RC4, AES

## Asymmetric encryption
- uses two keys (public and private)
- no key distribution security problem
- slower
- need the private key to decrypt something that was encrypted using the public key and vice-versa
- includes RSA

## Hashing
- about integrity, not confidentiality
- makes sure no bits get changed
- variable length input, fixed length output (digest)
- one-way function, infeasible (would take too much time) to reverse
- deterministic -- hashing the same input always gives the same output
- should be unique (in the universe)
  - no two inputs can result in the same output
  - MD5 and SHA-1 have been shown to not produce unique output
- SHA-256 is more secure

## Certificate Authorities
- like a digital notary public, a trusted third party
- when you visit a website:
  1. the website serves its certificate to your browser
  2. your bowser generates a symmetric key (based on recent mouse movements and key strokes)
  3. your browser encrypts this symmetric key with the certificate's public key (a field in the certificate)
  4. the website's server decrypts the symmetric key with their private key
    - now both sides have a shared secret (both are using that symmetric key)
  5. information is transmitted with the symmetric key, so it cannot be read
    - but the symmetric key is itself encrypted and _that_ can only be decrypted by the private key of the web server

- this is the most common use case for asymmetric encryption -- encrypting shared public secrets (like symmetric keys)
- how do you know that public key is legit?
  - it is signed by the certificate authority
  - how do you know that signature is legit?
    - need to validate that the CA is legit and really did sign the certificate
    - this all needs to happen before the symmetric key is encrypted
- the CA hashes the public key of the website and then encrypts it with _their (the CA's)_ private key, this is also a field on the digital certificate
- your browser retrieves the CA's digital certificate from its trusted root certificate store (stored locally on your machine) and decrypts the encrypted, hashed website public key with the CA's public key
- your browser also hashes the website's public key itself
- if these two hashes are the same, the website's public key is legit because if it decrypts with the CA's public key, it could only have been encrypted with their private key
- if a CA's private key is stolen, you would hear about and they would revoke it
- your browser also checks a certificate revocation list to verify that root certificates from the CA are still valid
- once you can trust that the CA is really the CA, you can trust that the website is really the website

## Public Key Cryptography
- Diffie-Hellman key exchange requires extra communications overhead
  - establishing every shared secret requires communication with each place you share it with
  - can use modular exponentiation to (clock arithmetic)
  - take a number, raise it to some exponent, divide by the modulus, output some number
- lock and unlock are inverse operations
  - you send an unlocked box to someone, they put their message inside, lock it, and send it back
  - only you can unlock it with the key that you never have to share with anyone
  - you can publish the unlocked box openly and let anybody use it to send you a message
  - split the key into an encryption key and a decryption key

- trapdoor function: easy to do, hard to reverse unless you know about the trap door
  - modular exponentiation is a trapdoor function -- hard to undo, unless you know the secret exponent

- prime factorization is a fundamentally hard problem
  - Euclid proved every number has exactly one set of prime factors
  - multiplication is easy -- time complexity increases linearly
  - factorization is hard -- time complexity increases expoentially

- phi function: given a number N, it outputs how many integers are less than or equal to N that do not share any factor with N
  - prime numbers have no factors greater than 1, so the phi of any prime number `P` is `P - 1`
  - phi funciton is multiplicative (`phi(A) * phi(B) == phi(A * B)`)
  - so if `N == P1 * P2`, `phi(N) = (P1 - 1) * (P2 - 1)`
    - this is the trap door for solving phi if you know the factorization for N
  - Euler's theorem: phi function and modular exponentiation together
    - `m ^ (phi(N)) === 1 mod N`
    - `m * (m ^ k(phi(N))) === m mod N`
    - `m ^ (k(phi(N)) + 1) === m mod n`
      - `m ^ e*d === m mod N`
    - `d * e == k*phi(N) + 1`
    - SO: `d == (k * phi(N) + 1) / e`
      - calculating `d` if the factorization of `N` is known is easy
      - `d` is the private key
      - knowing the factorization of N is the trap door



