## Counting
Values with lengths may be counted by prefixing with `#`.

```
#1:2:3
```
`3`

## Const
Operations come in two flavors, const and non-const. You can tell them apart syntactically by the non-const `!`-suffix. Const operations are not allowed to perform non-const operations.

```
(^foo [] (swap!))
```
```
Error in repl@1:10: Const violation in (foo []): (swap!)
```

## Packages
Two packages are defined by default, `core` and `user`.

Definitions in other packages may be accessed using fully qualified ids:

```
(core/= 42 42)
```
`T`

Or imported into the current package using `impoer!`:

```
(import! core =)
(= 42 42)
```
`T`

When launching the REPL, the entire `core` package is imported automagically. Otherwise only `import!`, `core`, and `user` are defined; anything else needs to be imported/fully qualified.

The source package may be splatted to import all ids:

```
(import! core*)
```