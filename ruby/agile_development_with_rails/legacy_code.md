# Approaching Legacy Code

- always mount a scratch monkey
  - always work on a branch of your code so you can afford to completely fuck up

- learn the user stories so you can understand what the code is _supposed_ to be doing


## Class-Responsibility-Collaborator Cards

for each entity:
  - list its responsbilities
    - things that it does or things that it knows
  - list its collaborators
    - things that it doesn't do or know directly but can work with another entity to know or do


## Understand the Code

### User Stories

- highlight nouns in user stories as candidates for classes
- highlight verbs in user stories as candidates for methods

### Informal Quality Control and Docs

- use static analysis tools (reek, flog, flay, saikuro)
- rake states to see code/test ratio and codebase size

other places to look:
- major models/controllers/views
- old mockups/user stories
- archived emails, wikis, blog posts, internal comms
- commit logs
- dump the schema
- check a diagram of how things are related

Goal: identify all the places where you will have to make changes to add the thing you want to add

## Adding Tests

- don't want to write code without tests
- there are no tests
- can't create tests without understanding the code
== infinite loop

- start with characterization tests (feature/integration tests)
- DO NOT start to make changes or improvements at this stage
- start with watching someone use the app, then copy that into a feature spec
  - check out capybara with mechanize if you really don't have access to the code to run on your dev machine
- write tests to learn as you go.. make up bogus expectations and let RSPec tell you what it was expecting
