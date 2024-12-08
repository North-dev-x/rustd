A rusty luau module meant to be used with strictly-typed luau.
### Types
`Result<T,E>` - A union of Ok and Err types.
	`Ok<T>` - A success result.
	`Err<T>` - An error result.
`Option<T>` - A union of T and nil. Used as an alternative to `T?` when it might be preferable.
`Pair<A,B>` - Unsafe type used internally to streamline matching with `rustd:match`.

### Functions
`rustd:match<T>(value_to_match: T, ...: {any}): any`

`rustd:find_child(parent: Instance, pattern: string): Result<Instance,string>`

`rustd:find_child_of_class(parent: Instance, class_name: string): Result<Instance,string>`

`rustd:find_descendant(parent: Instance, pattern: string): Result<Instance,string>`

`rustd:find_descendant_of_class(parent: Instance, class_name: string): Result<Instance,string>`
`rustd:push_error(msg: string): ()`

### Documentation
[[Result]]
[[Option]]
[[Pair]]
[[rustd Functions]]

### Conclusion
Please don't be afraid to leave suggestions for other implementations you would want me to try to add in this module! I'll try my best to add them!
