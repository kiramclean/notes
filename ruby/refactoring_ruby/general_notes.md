# General Notes on Refactoring

- most refactorings involve an intermediate step, putting the code in an ephemeral state
  - e.g. removing conditional logic usually means moving that conditional logic to a module and including it, then overrriding all the logic so you can remove the module
  - or introducing a case statement to allow modifying the internals of a class without modifying the callers
