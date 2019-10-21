# For this version:

## In general

  - [x] better API for building the environment fallback
  - [ ] add `defn` to the core
  - [ ] reduce the size of the stack used for calls
  - [ ] add TCO
  - [x] remove the lambdas from core implementation when not necessary
  - [ ] named parameters? (as keywords?)
  - [ ] add an API to give name to functions
    - I want to be able to get better errors:
      "def wants 2 args instead of X" instead of "wants 2 instead of X"

## The language

  - [ ] add literal for multi-arity funcs
  - [ ] add literal for keywords
  - [ ] add literal for maps
  - [ ] namespaces
