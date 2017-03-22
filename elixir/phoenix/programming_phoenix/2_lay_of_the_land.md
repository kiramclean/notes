# The Lay of the Land

- connection comes into phoenix, phoenix operates on the connection, then the connection comes out
  - initially the connection contains information about the request (http(s), url, params)
  - after, it contains information about the response as well

How phoenix works:

```elixir
connection
|> endpoint
|> router
|> pipelines
|> controller
|> common_services
|> action
```

- limit functions with side-effects to the controller
  - leave functions in models and views pure (no side effects)
- process data in models, but only write or read it in controllers
  - any code that changes information lives in controllers, any code that just transforms the shape of information lives in models
- a phoenix app is just a series of functions that do something to a connection, including rendering the result

## Organizing a Phoenix App

- configuration and tests go in... `config` and `test`
- supervision trees and long-running processe go in `lib`
- web-related code (models, views, controllers, templates, etc) goes in `web`

  - code in `web` is auto-reloaded, code in `lib` is not

- endpoint has functions

