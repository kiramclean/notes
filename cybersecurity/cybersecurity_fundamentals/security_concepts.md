# Security Concepts

## CIA Model
- **C**onfidentiality
  - mainly acheived through encryption
- **I**ntegrity
  - assurance that information is stored and retrieved in its original form
  - mainly acheived through hashing
- **A**vailability
  - people who _are_ authorized to do something should be able to do it without problems

## AAA Model
1. authentication
   - proving you are who you say you are using
     - something you know (password)
     - something you have (cell phone, key fob)
     - something you are (biometrics)
   - combining two or more of these categories is multi-factor authentication, makes it way harder to impersonate someone
   - you cannot change your biometrics like you can change your password
   - using biometrics also compromises anonymity, because these credentials can be directly linked t you (a fingerprint can only belong to one person, and a person only has one fingerprint)
     - you could trace someone's entire pathway through cyberspace
     - also biometrics are really hard and have false positive and false negatives
     - 2FA with SMS is not secure because SMS can be intercepted or redirected
       - should use an authenticator app or USB dongle instead
2. authorization
   - restricting account access based on credentials
     - principle of least privilege: accounts should have exactly enough power to what they need to do, and nothing more
     - should use an account with limited privileges
       - if you get infected with malware as a root user, the malware will be executed with the privileges of your current user
3. accounting
   - keeping track of users and their actions
     - logging all login attempts, including failed ones

## Security vs. Availability
- security and availability are inversely proportional
  - need to balance these two concerns

## Threat Agents
- a goal of cybersecurity is to protect assets
- threat agents are the ones carrying out the threats
  - can be people, can also be nature (e.g. hurricanes, floods, etc.)
- threat agents exploit vulnerabilities
  - weak authentication, default usernames and passwords, incorrectly configures firewalls, naive employees are all vulnerabilities
- exploits are usually named after the vulnerabilities they exploit
- hackers go after low-hanging fruit first (like Windows XP)
- risk is a funciton of both the liklihood of an event occurring and its impact/consequences
  - can mitigate risk (encryption, hashing, VPNs, firewalls, intrusion detection and prevention)
  - can transfer it (buy cybersecurity insurance or use a cloud provider so they are responsible for securing your data)
  - can accept it (if the cost of protecting a resource outweighs the cost of losing or replacing it)

- ask yourself what the critical assets are before you start securing them, pick the ones that would have the highest cost and most negative outcomes if they were lost or stolen
