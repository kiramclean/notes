- `scrub_params` -- no stray empty string in the db
- proper front-end tooling
- performance
- websockets
- reliability (supervision)

- form builders
  - `error_tag` helper (no more custom `show_errors`) helper
- static build tools with ES6 as default (asset pipeline)
- live reloading
- nice error pages with super useful messages
- concurrent test tools (parallel specs by default)
- packages (hex)
- no forwarding of `assigns` in templates (you have to pass everything explicitly to child templates)
- all loading is explicit (if you want an associated record to be available, you have to explicitly specify it.. you have to explicitly say you want an n+1 query)

