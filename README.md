A rusty Luau module meant to be used with strictly-typed luau.

[Toolbox link](https://create.roblox.com/store/asset/123174237649775/rustd)

### Types
`Result<T,E>` - A union of Ok and Err types.

`Ok<T>` - A success result.
 
`Err<T>` - An error result.

### Functions
`function rustd.match<T>(value_to_match: T, r: any?): ({{any}}) -> any`

`rustd:find_child(parent: Instance, pattern: string): Result<Instance,string>`

`rustd:find_child_of_class(parent: Instance, class_name: string): Result<Instance,string>`

`rustd:find_descendant(parent: Instance, pattern: string): Result<Instance,string>`

`rustd:find_descendant_of_class(parent: Instance, class_name: string): Result<Instance,string>`

`rustd:rcall<T>(func: (...any?) -> T,...): Result<T,string>`

`rustd:push_error(msg: string): ()`

### Documentation
[Result](Result.md)

[rustd Functions](rustd%20Functions.md)


### Conclusion
Please don't be afraid to leave suggestions for other implementations you would want me to try to add in this module! I'll try my best to add them!
This module will not work with the new type solver until it is fully released, unfortunately.
