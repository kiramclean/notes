# Authenticating Users

- persistence is not coupled to change policies in ecto
  - can easily validate the incoming password, even though it is never persisted
- tradeoff is that basic validations must be duplicated accross changesets, but it is better to have each changeset have its own validations and have to duplicate some validations some of the time than it is to apply all validations to a model always and write exceptions to those rules for most cases
- changesets insulate controllers from change policies encoded in the model and keep the model free of side effects

- do a dummy password check (built into Comeonin as `dummy_checkpw`) with variable timing to simulate decrypting the password to protect against timing attacks
- `configure_session(renew: true)` needs to be at the end of the login function
  - tells Plug to send the session cookie back with a different identifier, in case an attacker knew the previous one

- use `configure_session(drop: true)` to drop the whole session
- can use `delete_session(conn, :user_id)` to just drop the user id but keep the session around

## Plugs

- can be a single function or be a module with two functions (`init` and `calc`)
  - `init` is called at compilation time, `call` happens at runtime
  - the return value of `init` _is_ the second argument to `call`
- all plugs take a connection and return a connection
- all connection information is contained in the `Plug.Conn` struct (request and response)
  - request things: `host`, `method`, `path_info`, `req_headers`, `scheme`
    - and more, things like query string, remote IP, port, anything else available from a web server's adapter
  - "fetchable fields": empty until you request them for performance (`cookies`, `params`)
  - fields used to process web requests: `assigns`, `halted`, `state`
  - response things: `resp_body`, `resp_cookies`, `resp_headers` (response type/caching etc), `status`
  - also has private fields reserved for internal use: `adapter`, `private`

- a connection is manipulated at different levels of the stack but is _always the same connection_
  - comes in pretty much blank (just request information)
  - then plugs can do whatever they want to it (parse params |> set data in `assigns` |> render response (set those fields) |> change the `state` of the `conn`)

- plug pipelines explicitly check for the `halted: true` flag between every plug invocation

## Forms

- for a form not backed by any changeset you can just pass `form_for` the `@conn`
