# Controller, Views, and Templates

- web development is a problem well suited for functional solutions

```elixir
endpoint
|> router
|> controller
```

In the controller:

```elixir
connection
|> controller_action
|> render_template
```

- controller handles the request
- view renders the template
- template itself is the markup to display your content

## Structs

- better than maps because maps only error on missing keys at runtime
  - structs error on missing keys at compilation

## Views

- views are modules responsible for converting data into a presentation format (HTML, JSON, whatever)
- templates are a function on the view module and are the actual markup/content being rendered
- templates are fast in phoenix because they use linked lists, not string concatenation (like most imperative languages do)
  - elixir holds on to only a single copy of the largest strings in your application

- phoenix uses singular names everywhere, so you never have to think about pluralization rules

- extracting partials is painless and does not cost performance because views are just modules and templates are just functions inside those modules (they get compiled into functions)
