## Mutation
Mutating operations are required to have names ending in `!`.

```
(^foo [] (swap!))
```
```
Fatal error: Const method with non-const body: (foo [])
```