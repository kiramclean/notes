# Redux Basics

- separate the job finding the right location in the state tree from applying the update to that location
  - otherwise the app won't scale (see reducer composition)

## Pure Components
- receive all their data as arguments (like pure functions receive all their data as functions)
- have no side effects (no reading data from anywhere else, no initiating network requests, etc.)
- have no internal state
- output (what gets rendered) driven fully by input props
- same input always results in the same output (no hidden state inside the component)

This is amazing because you know what a pure component/function does just by looking at it -- give it some input, and see what it give you for output. There's no need to know anything about the rest of the system to be able to understand.

- state lives in an immutable data structure inside a redux store

- the only way to change the state is by dispatching an action
- `reducer` takes in the previous state of the app and an action and returns the next state of the app
