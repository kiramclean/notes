# Related Data

- with Ecto you always have to load associations explicitly, so extra rows are never fetched
- every controller has its own custom `action` function
  - it's a plug that dispatches to the proper action at the end of the controller pipeline
- `^` in front of query params scrubs them to protect against SQL injection

- keep functions with side effects contained in the controllers (not model/view layers)
  - controller encapsulates side effects by readin/writing to the socket

- Ecto fragments allow you to run SQL directly on your database in case you want to do something not supported by Ecto

- you need to manage database integrity
  - can do it in the app layer, this can lead to inconsistent data if every model validation isn't also backed by a database constraint
  - can do it only in the database, but this is hard to maintain and provides a bad user experience because surfacing errors to the UI can be complicated
  - can do a bit of both -- Ecto turns database constraint errors into human-readable error messages and provides a mechanism for you to add them to the app layer too (the other way around from Rails, where the validations/constraints can be in the app layer without any underlying rules in the database)
    - unique or other constraints in ecto models do nothing if there is no matching constraint in the schema

- if a user could do somehting about an error, you should surface the error to them
  - if they can do nothing about it (it's caused by a bug or a data integrity issue), you should just let it crash and investigate

