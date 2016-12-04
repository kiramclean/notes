# Plug

- an abstraction layer for connection adapters of different web servers
- idea is to unify the concept of a "connection" that we operate on
- unlike other HTTP middleware, like Rack, which separate request and response in the stack
- all plugs must define `init` and `call`
  - init only gets run once
  - the `params` argument in `call` is the return value of `init`, NOT form data, url params, or something like in a cmntroller

- phoenix assumes the controller handler is the very last step in handling a request
  - after a controller handler finishes, it sends the connection back to the user
- inside of a plug, phoenix assumes there could be other things to do on the connection before sending it back to the user
  - have to pass the connection to `halt` to tell it we're done, send back to user
