- rails is slow
  - to make it faster:
    - more $$$ (more servers, more processors)
    - caching
  - caching sucks, makes code complicated and makes concurrency hard
  - don't need third party dependencies (eg redis, sidekiq).. more complete ecosystem, also cheaper (less instances)

- pros of elixir:
  - (almost) immutable data
  - easy syntax (compared to haskell, clojure, erlang, etc.)

- switching from rails
  - stop thinking of content types as models, start thinking of them as just content that flows through a pipeline
  - use changesets to validate against different content types/conditions

