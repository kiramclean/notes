# `GenServer`s

- `cast` is for async messages (send `:noreply`)
- `call` is for sync messages (send `:reply`)

- invokes `init` inside the call to `start_link` to set up the initial state


- `init`, `handle_call`, and `handle_cast` are the server implementation, all other functions are part of the client API

- `GenServer` abstracts away the common concerns of managing state in a process
  - setting up references for async messages
  - handling internal references (that can change e.g. when upgrading code)

# `Supervisor`s

- default restart is 3 restarts in 5 seconds

To choose a restart strategy:
- do you care aobut every result?
- is it ok if you lose some sometimes?
- does it makes sense to re-try the computation?
- is the result time-sensitive?


Supervision strategy:
Difference between `one_for_one` and `simple_one_for_one`: `simple_one_for_one` won't automatically start any children, it waits until you tell it to start them.
