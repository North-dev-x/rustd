--!strict 
local std = require(script.Parent)
local match = std.match
local Ok = std.Ok
local Err = std.Err
local push_error = std.push_error

function test(test_name: string, func: () -> any?)
	local success, err = pcall(func)
	if success then
		print("TEST PASSED: "..test_name)
	elseif err and not success then
		warn("TEST "..test_name.." FAILED WITH ERROR: ".. err)
	end
end

test("ResultMatch", function() 
	local SomeResult: std.Result<string,string> = Ok("Foo")  

	local result = std.rcall(function()
		return SomeResult.match { 
			{"Ok", function(result) return result end},
			{"Err", function(result) return error(result) end}  
		}   
	end)
	local unwrapped = result.unwrap()
	if unwrapped ~= "Foo" then
		return error("Value should be equal to the value inside of the result")
	end
	return 0;
end)

test("PushError", function()
	push_error("hello")
	return 0
end)

test("StandardMatch", function()
	local num_to_match = 2;
	local matched = match (num_to_match) {
		{1, "Number one!"};
		{2, "Number two!"};
		{"default", "I can't count that high..."}
	}
	print(matched)
	return 0;
end)

test("rcall",function()
	-- single return ok
	local result = std.rcall(function(num)
		num = 30;
		return num
	end, 5)
	local ok = result.expect("should be ok")
	 
	-- single return err
	result = std.rcall(function()
		return error("HELLO")
	end)
	local err = result.err()
	if err == nil then
		return error("That function should error.")
	end
	
	return 0;
end)
