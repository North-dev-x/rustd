A group of helpful functions!
###### match
```luau
function rustd.match<T>(value_to_match: T): ({{any}}) -> any
```
Matches value_to_match with all given cases.
A case must be defined as `{case_match, return_value_or_function}`

Cases must be defined with function arguments. 

A default case may be defined by using `{"default", return_value_or_function}`, and will be ran if no other match is found.


```luau
local num: number = 3;

local result = rustd.match(num) {
	{0, function() return "Number zero!" end},
	{1, "Number one!"},
	rustd.Pair(2, "Number two!"),
	rustd.Pair("default", function() 
		return error("I can't count that high...") 
	end)
}

print(result)
```
*A small demonstration of different case definitions.*

```luau
local result: Result<number,string> = -- 
result.match {
	{"Ok", function(val: number) print(val) return val end},
	{"Err", function(errmsg: string) return error(errmsg) end}
}
```
*A small demonstration of usage of result.match, in a similar vein to rustd.match.*

###### Ok
```luau
function rustd.Ok<T>(value: T): Ok<T>
```
Wraps `value` in an `Ok`, and returns it.

###### Err
```luau
function rustd.Err<E>(err: E): Err<E>
```
Wraps `err` in an `Err`, and returns it.
`Err` can be of any type, i.e `rustd.Err(3)`

###### Pair
```luau
function rustd.Pair(...:): Pair<any,any>
```
Wraps the given arguments, or a single table of 2 values, in a `Pair`, and returns it.

###### find_child
```luau
function rustd.find_child(parent: Instance, pattern: string): Result<Instance,string>
```
Similar to `Instance:FindFirstChild()`, but returns a Result.
`Ok` if the child is found.
`Err` if the child is not found.

###### find_child_of_class
```luau
function rustd.find_child_of_class(parent: Instance, class_name: string): Result<Instance,string>
```
Similar to `Instance:FindFirstChildOfClass()`, but returns a Result.
`Ok` if the child is found.
`Err` if the child is not found.

###### find_descendant
```luau
function rustd.find_descendant(parent: Instance, pattern: string): Result<Instance,string>
```
Searches for a descendant of `parent` with the given `pattern`.
`Ok` if the descendant is found.
`Err` if the descendant is not found.

###### find_descendant_of_class
```luau
function rustd.find_descendant_of_class(parent: Instance, class_name: string): Result<Instance,string>
```
Searches for a descendant of `parent` of type `class_name`.
`Ok` if the descendant is found.
`Err` if the descendant is not found.

###### rcall
```luau
function rustd.rcall<T>(func: (...any?) -> T,...): Result<T,string>
```
Acts like a lua `pcall`, but returns a Result instead of a boolean and return value.

Usage:
```luau
local result = rustd.rcall(function() 
	if math.random(1,2) == 1 then
		error("Failed")
	else
		return "Number 2!"
	end
end)
print(result.unwrap())
```

###### push_error
```luau
function rustd.push_error(err: string): ()
```
Outputs an error(red text) without halting execution.
