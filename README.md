## Counting
Values that support counting may be counted by prefixing with `#`.

```
#1:2:3
```
`3`

## Const
Operations come in two flavors, const and non-const. You can tell them apart syntactically by the non-const `!`-suffix. Const operations are not allowed to perform non-const operations.

Mutating operations are required to have names ending in `!`.

```
(^foo [] (swap!))
```
```
Error in repl@1:10: Const violation in (foo []): (swap!)
```