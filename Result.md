Type for handling errors as values.
## Types
#### Ok
```luau
export type Ok<T> = {...}
```
The success variant of a Result. Intended to be returned in the "happy path" of a function.
Constructed with `rustd.Ok(value)`.
### Err

```luau
export type Err<E> = {...}
```
The failure variant of a Result. Intended to be returned in failure states of a function.
Constructed with `rustd.Err(value)`.
#### Result
```luau
export type Result<T, E> = Ok<T> | Err<E>
```
A union type of `Ok` and `Err`. Used as a function return signature or variable type.

```luau
function div(a: number,b: number): rustd.Result<number,string>
	if b == 0 then
		return rustd.Err("Cannot divide by zero.")
	end
	return rustd.Ok(a / b)
end
```

## Methods
###### unwrap
```luau
unwrap: () -> any;
```
Unwraps the `Result`, returning the value inside the `Ok` or `Err` value.
Errors if the `Result` is not `Ok`.

Intended to be used as a placeholder for fast prototyping, and replaced with better error handling when security is needed.
```luau
function div(a: number,b: number): rustd.Result<number,string>
	if b == 0 then
		return rustd.Err("Cannot divide by zero.")
	end
	return rustd.Ok(a / b)
end

local divided_num = div(2,1).unwrap()
```

###### match
```luau
match: ({{"Ok" | "Err" | any}}) -> unknown?; 
```
Allows you to match on the result's type, and get its value as a function argument within the match.


This is the main way of handling results.
```luau
function parse_number(str: string): rustd.Result<number,string>
	local num = tonumber(str)
	if not num then
		return rustd.Err("Failed to parse number from string: "..str)
	end
	return rustd.Ok(num)
end

local string_to_parse = "5"
local divided_num = parse_number(string_to_parse).match {
	{"Ok", function(val: number) return val end},
	{"Err", function(err: string) return error(err) end}
}
```

##### unwrap_or
```luau
unwrap_or: <D>(D) -> D | any;
```
Returns the value inside the `Result` if it is `Ok`.
Returns the given default value if it is `Err`.

###### unwrap_or_else
```luau
unwrap_or_else: ((unknown) -> any) -> any;
```
Returns the value inside the `Result` if it is `Ok`.
Calls the function given as callback if it is `Err`, passing the `Err`'s message as first argument.
```luau
local divided_num = div(10,5).unwrap_or_else(function(err: unknown)
	print("Failed division. Reason: "..err)
end)
```
###### expect
```luau
expect: <M>(M) -> M | any;
```
Returns the value inside the `Result` if it is `Ok`.
Throws an error with the given message `M` if the `Result` is `Err`.
```luau
local fail = parse_number("Hello!").expect("Failed.") -- Throws error "Failed."
```
###### type_of
```luau
type_of: () -> "Ok" | "Err";
```
Returns the type of the Result, being "Ok" or "Err".

###### err
```luau
err: () -> unknown?;
```
Returns the error message if the `Result` is `Err`.
Returns `nil` if the `Result` is `Ok`.

###### ok
```luau
ok: () -> unknown?;
```
Returns the `value` if the `Result` is `Ok`.
Returns `nil` if the `Result` is `Err`.


