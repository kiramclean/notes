# Ecto and Changesets

- Ecto validations are specific to a particular changest and a model can have more than one changeset
  - prevents conditional validations and coupling client-facing validations to the schema
  - this is bad because update strategies need to be specific to a context, not a model
  - validations, error messages, and security measures can be different for the same model given different contexts (API, front-end, mobile client, for example)
  - changesets decouple update policies from the DB schema

- `Ecto.Changeset` implements the interface defined in `Phoenix.HTML.FormData`, to decouple the interface from the implementation of web forms
- a changeset holds everything related to a database change (before and after persistence)
