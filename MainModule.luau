--!strict

local rustd = {}



--[[
	Use as a function return signature or variable type, i.e function x(): Result<number,string>
	Result takes 2 generics, the first being the type of the Ok, and the second being the type of the Err.
]] 
export type Result<T, E> = Ok<T> | Err<E>




type __base_result_type<T> = {
	type_of: () -> "Ok" | "Err";
	into_pair: () -> Pair<any, any>;
	unwrap: () -> any;
	unwrap_or: <D>(D) -> D | any;
	unwrap_or_else: ((unknown) -> any) -> any;
	err: () -> unknown?;
	ok: () -> unknown?;
	expect: <V>(V) -> V | any;
}

-- The Ok variant of a Result.
export type Ok<T> = __base_result_type<T>

--[[
	Wraps value in an Ok.
	Usage:
	rustd.Ok(value)
	i.e. return rustd.Ok(42)
]]
function rustd.Ok<T>(value: T): Ok<T>
	return {
		type_of = function() return "Ok" end;
		into_pair = function() return rustd.Pair("Ok",value) end;
		unwrap = function() return value end;
		unwrap_or = function() return value end;
		unwrap_or_else = function() return value end;
		err = function() return end;
		ok = function() return value end;
		expect = function() return value end;
	} :: Ok<T>
end

-- The Err variant of a Result.
export type Err<E> = __base_result_type<E>;

--[[
	Wraps err in an Err.
	Usage:
	rustd.Err(error_msg)
	Errors can use any type, i.e. rustd.Err(3)
]]
function rustd.Err<E>(err: E): Err<E>
	return {
		type_of = function() return "Err" end;
		into_pair = function() return rustd.Pair("Err",err) end;
		unwrap = function() return error("Unwrapped an Err: "..tostring(err)) end;
		unwrap_or = function(default_val) return default_val end;
		unwrap_or_else = function(callback) return callback(err) end;
		err = function() return err end;
		ok = function() return nil end;
		expect = function(msg) return error(msg) end;
	} :: Err<E>
end

--[[
	[THIS IS UNSAFE]
	Only use if you know what you're doing.

	Used internally by Result.into_pair() in rustd:match to streamline the usage experience.
	Can be used as a return value for functions you want to have the same match behavior.
]]
export type Pair<A,B> = {
	[number]: A | B;
	type_of: () -> "Pair";
}

--[[
	[THIS IS UNSAFE]
	Only use if you know what you're doing.
	
	Constructs a Pair. This is only used for rustd:match(). 
	
	When value_to_match is a Pair, the first parameter of the Pair will be matched, and the second parameter will be passed to case functions.
	This behaviour is mostly used internally to streamline matching Result.type_of().
]]
function rustd.Pair(...): Pair<any,any>
	local args = {...}
	if #args > 2 then
		return error("Pair can only have 2 arguments.")
	end
	if #args == 1 and typeof(args[1]) == "table" then
		args = args[1];
		if #args > 2 then
			return error("Pair can only have 2 arguments.")
		end
	end
	return {
		[1] = args[1];
		[2] = args[2];
		type_of = function() return "Pair" end;
	} :: Pair<any,any>
end

type case<T> = T | string;

--[[
	Matches value_to_match with all given cases.
	A case must be defined by using {case_match, return_value_or_function} 
	i.e.
	{true, function(val: boolean) return "Value is true!" end},
	{"default" = "I'm unsure."}
	
	First parameter of a case's function will be the value passed in match.
	
	When value_to_match is a Pair, the first parameter of the Pair will be matched, and the second parameter will be passed to case functions.
	This behaviour is mostly used internally to streamline matching Result.type_of().
]]
function rustd:match<T>(value_to_match: T, ...: {any}): any
	local cases = {...};
	if typeof(value_to_match) == "table" and value_to_match["type_of"] ~= nil and value_to_match.type_of() == "Pair" then
		-- Logic for Pair
		
		for _,arg: any in ipairs(cases) do
			local case: case<T> = arg[1]
			local value: (any) -> any | any = arg[2];
			if value_to_match[1] == case or case == "default" then
				if type(value) == "function" then
					return value(value_to_match[2]);
				else
					return value
				end
			end
		end
		return nil
		
	else
		-- Logic for non-Pair
		
		for _,arg: any in ipairs(cases) do
			local case: case<T> = arg[1]
			local value: (T) -> any | any = arg[2];
			if value_to_match == case or case == "default" then
				if type(value) == "function" then
					return value(value_to_match);
				else
					return value
				end
			end
		end
		return nil
		
	end

end

--[[
	Same thing as `rustd:match`, but uses a table of cases rather than a variable number of arguments.
]]
function rustd:match_casetbl<T>(value_to_match: T, cases: {any}): any
	if typeof(value_to_match) == "table" and value_to_match["type_of"] ~= nil and value_to_match.type_of() == "Pair" then
		-- Logic for Pair

		for _,arg: any in ipairs(cases) do
			local case: case<T> = arg[1]
			local value: (any) -> any | any = arg[2];
			if value_to_match[1] == case or case == "default" then
				if type(value) == "function" then
					return value(value_to_match[2]);
				else
					return value
				end
			end
		end
		return nil

	else
		-- Logic for non-Pair

		for _,arg: any in ipairs(cases) do
			local case: case<T> = arg[1]
			local value: (T) -> any | any = arg[2];
			if value_to_match == case or case == "default" then
				if type(value) == "function" then
					return value(value_to_match);
				else
					return value
				end
			end
		end
		return nil

	end

end

--[[
	Searches for a child of the parent with pattern as the name, returning a Result. 
]]
function rustd:find_child(parent: Instance, pattern: string): Result<Instance,string>
	local child = parent:FindFirstChild(pattern)
	if child == nil then
		return rustd.Err("Failed to find child "..pattern.." inside "..parent.Name)
	end
	return rustd.Ok(child)
end

--[[
	Searches for a child of the parent with the given ClassName, returning a Result. 
]]
function rustd:find_child_of_class(parent: Instance, class_name: string): Result<Instance,string>
	local child = parent:FindFirstChildOfClass(class_name);
	if child == nil then
		return rustd.Err("Failed to find child with class "..class_name.." inside "..parent.Name)
	end
	return rustd.Ok(child)
end

--[[
	Searches for a descendant of the parent with pattern as the name, returning a Result. 
]]
function rustd:find_descendant(parent, pattern: string): Result<Instance,string>
	local child = parent:FindFirstChild(pattern,true)
	if child == nil then
		return rustd.Err("Failed to find descendant "..pattern.." inside "..parent.Name)
	end
	return rustd.Ok(child)
end

--[[
	Searches for a descendant of the parent with given ClassName, returning a Result. 
]]
function rustd:find_descendant_of_class(parent, class_name: string): Result<Instance,string>
	local child
	for i,v: Instance in ipairs(parent:GetDescendants()) do
		if v.ClassName == class_name then
			child = v
			break;
		end
	end
	if child == nil then
		return rustd.Err("Failed to find descendant with class "..class_name.." inside "..parent.Name)
	end
	return rustd.Ok(child)
end

function rustd:rcall<T>(func: (...any?) -> T,...): Result<T,string>
	local success, result = pcall(func,...)
	if success then
		return rustd.Ok(result)
	else
		return rustd.Err(result)
	end
end

-- Pushes an error(red text) without halting execution.
function rustd:push_error(err: string): ()
	task.spawn(error,err);
end

return rustd
