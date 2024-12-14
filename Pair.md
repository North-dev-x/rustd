Type for convenient use of `rustd:match.
This type is **UNSAFE**(1) Only use this if you know what you are doing.

This type is mostly used internally to make `Result.into_pair` convenient to match with.

1. Unsafe meaning less type-safe than other types in this module. Nothing is inherently going to be perfectly safe, but `--!strict` helps with type safety.
### Pair
```luau
export type Pair<A,B> = {
	[number]: A | B;
}
```
Type equal to a pair of 2 keys and values.
Constructed with `rustd.Pair(arg1,arg2)` or `rustd.Pair({arg1,arg2})` if you want to use a table.

### Methods
```luau
type_of: () -> "Pair";
```
Returns the fact that the `Pair` is, in fact, a `Pair`.
Used internally for `rustd:match` to decide how to match the methods.
