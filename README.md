## Const
Operations come in two flavors, const and non-const. You can tell them apart syntactically by the non-const `!`-suffix. Const operations are not allowed to perform non-const operations.

Mutating operations are required to have names ending in `!`.

```
(^foo [] (swap!))
```
```
Error in repl@1:10: Const violation in (foo []): (swap!)
```