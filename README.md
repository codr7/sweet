## Counting
`count` may be used to get the number of items from a composite value:

```
(count "foo")
```
`3`

Alternatively the value may be prefixed with `#` as a shorthand:

```
#"foo"
```
`3`

## Methods
Methods may be defined using `^`:

```
(^foo [;Int] 42) 
```
`42`

Methods without a result type always return `_`:
```
(^foo [] 42) 
```
`_`

## Operations
Operations (methods and macros) come in two flavors, const and non-const. You can tell them apart syntactically by the non-const `!`-suffix. Const operations are not allowed to perform non-const operations.

```
(^foo [] (swap!))
```
```
Error in repl@1:10: Const violation in (foo []): (swap!)
```

## Types
`type` may be used to get the most specific type compatible with all arguments:

```
(type 1 2)
```
`Int`
```
(type 1 "foo")
```
`Any`

`isa´ may be used to check if a value is of the specified (or a derived type):

```
(isa 42 Int)
```
`T`

## Packages
Two packages are defined by default, `core` and `user`.

Definitions in other packages may be accessed using fully qualified ids:

```
(core/= 42 42)
```
`T`

Or imported into the current package using `import!`:

```
(import! core =)
(= 42 42)
```
`T`

When launching the REPL, the entire `core` package is imported automagically. Otherwise only `import!`, `core`, and `user` are defined; anything else needs to be imported/fully qualified.

The package may be splatted to import all ids:

```
(import! core*)
```

## Loading
`load!` may be used to load code from files, it takes path arguments:

```
(load! (path "tests/run.sw"))
```