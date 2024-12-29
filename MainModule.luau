--!strict

local rustd = {}



--[[
	Use as a function return signature or variable type, i.e function x(): Result<number,string>
	Result takes 2 generics, the first being the type of the Ok, and the second being the type of the Err.
]] 
export type Result<T, E> = Ok<T> | Err<E>

type __base_result_type<T> = {
	type_of: () -> "Ok" | "Err";
	unwrap: () -> any;
	unwrap_or: <D>(D) -> D | any;
	unwrap_or_else: ((unknown) -> any) -> any;
	err: () -> unknown?;
	ok: () -> unknown?;
	expect: <V>(V) -> V | any;
	match: ({{"Ok" | "Err" | any}}) -> unknown?; 
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
		unwrap = function() return value end;
		unwrap_or = function() return value end;
		unwrap_or_else = function() return value end;
		err = function() return end;
		ok = function() return value end;
		expect = function() return value end;
		match = rustd.match("Ok",value);
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
		unwrap = function() return error("Unwrapped an Err: "..tostring(err)) end;
		unwrap_or = function(default_val) return default_val end;
		unwrap_or_else = function(callback) return callback(err) end;
		err = function() return err end;
		ok = function() return nil end;
		expect = function(msg) return error(msg) end;
		match = rustd.match("Err",err);
	} :: Err<E>
end


function _extract_cases(cases: {{any}}): { any}
	local processed = {}
	for _,item in cases do
		table.insert(processed,item[1])
		table.insert(processed,item[2])
	end
	return processed
end

--[[
	Matches value_to_match with all given cases.
	A case must be defined by using {case_match, return_value_or_function} 
	i.e.
	
	rustd.match (value) {
		{true, function(val: boolean) return "Value is true!" end},
		{"default" = "I'm unsure."}
	}
	
	First parameter of a case's function will be the value passed in match.

]]

function rustd.match<T>(value_to_match: T, r: any?): ({{any}}) -> any
	return function(t: {{any}}): any
		local cases = _extract_cases(t);
		local key = table.find(cases,value_to_match) 
		
		if not key then
			key = table.find(cases,"default")
		end
		
		if key then
			local _, val = next(cases,key)
			if r then value_to_match = r end
			if typeof(val) == "function" then
				return val(value_to_match)
			else
				return val
			end
		end
		warn("No match found; possible non-exhaustive pattern match which can return nil. Try adding more cases, or a 'default' case.")
		return nil
	end
end

--[[
	Searches for a child of the parent with pattern as the name, returning a Result. 
]]
function rustd.find_child(parent: Instance, pattern: string): Result<Instance,string>
	local child = parent:FindFirstChild(pattern)
	if child == nil then
		return rustd.Err("Failed to find child "..pattern.." inside "..parent.Name)
	end
	return rustd.Ok(child)
end

--[[
	Searches for a child of the parent with the given ClassName, returning a Result. 
]]
function rustd.find_child_of_class(parent: Instance, class_name: string): Result<Instance,string>
	local child = parent:FindFirstChildOfClass(class_name);
	if child == nil then
		return rustd.Err("Failed to find child with class "..class_name.." inside "..parent.Name)
	end
	return rustd.Ok(child)
end

--[[
	Searches for a descendant of the parent with pattern as the name, returning a Result. 
]]
function rustd.find_descendant(parent, pattern: string): Result<Instance,string>
	local child = parent:FindFirstChild(pattern,true)
	if child == nil then
		return rustd.Err("Failed to find descendant "..pattern.." inside "..parent.Name)
	end
	return rustd.Ok(child)
end

--[[
	Searches for a descendant of the parent with given ClassName, returning a Result. 
]]
function rustd.find_descendant_of_class(parent, class_name: string): Result<Instance,string>
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

--[[
	Similar to a pcall, but returns a Result instead of (boolean, any)
]]
function rustd.rcall<T>(func: (...any?) -> ...T,...): Result<T,string>
	local success, result = pcall(func,...)
	if success then
		return rustd.Ok(result)
	else
		return rustd.Err(result)
	end
end

-- Pushes an error(red text) without halting execution.
function rustd.push_error(err: string,show_traceback: boolean?): ()
	task.spawn(error,err);
	if show_traceback == nil or show_traceback == true then
		warn("Stack Trace: ".. debug.traceback("",2))
	end
end



return rustd

