Type that can be used as an alternative to `T?` in cases where that might not be preferable.
Intended to be used for functions that can return `nil`.

### Option
```lua
export type Option<T> = T | nil
```
Cannot be constructed.

Usage:
```lua
function foo(bar: boolean): rustd.Option<string>
	if bar then
		return "foobar";
	else
		return nil;
	end
end

local result = foo(true) -- "foobar"
local result = foo() -- nil
```
