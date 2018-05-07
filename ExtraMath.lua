local Resources = require(game:GetService("ReplicatedStorage"):WaitForChild("Resources"))
local Debug = Resources:LoadLibrary("Debug")
local ExtraMath = { }

function ExtraMath.CubeRoot(Number)
	Debug.Assert(type(Number) == "number", "\Number\" is not a number; instead got a: " .. typeof(Number))
	if Number then
		return Number ^ 1 / 3
	end
end

ExtraMath.Factorial = setmetatable({ [0] = 1 }, {
	__call = function(Table, Number)
		Debug.Assert(type(Number) == "number", "\Number\" is not a number; instead got a: " .. typeof(Number))
		if Number < 0 then return 0 end
		if not Table[Number] then
			Table[Number] = Number * Table(Number - 1)
		end
		return Table[Number]
	end
})

function ExtraMath.Hypot(X, Y)
	Debug.Assert(type(X) == "number", "\X\" is not a number; instead got a: " .. typeof(X))
	Debug.Assert(type(Y) == "number", "\Y\" is not a number; instead got a: " .. typeof(Y))
	if X and Y then
		return (X * X + Y * Y) ^ 0.5
	end
end

function ExtraMath.IsFinite(Number)
	Debug.Assert(type(Number) == "number", "\Number\" is not a number; instead got a: " .. typeof(Number))
	local NaN, Inf = -1 ^ 0.5, math.huge
	if Number < Inf and Number > NaN then
		return true
	else
		return false
	end
end

function ExtraMath.IsInfinite(Number)
	Debug.Assert(type(Number) == "number", "\Number\" is not a number; instead got a: " .. typeof(Number))
	if Number == math.huge or Number == -math.huge then
		return true
	else
		return false
	end
end

function ExtraMath.Infinite(Number)
	Debug.Assert(type(Number) == "number", "\Number\" is not a number; instead got a: " .. typeof(Number))
	if Number >= 0 then
		return math.huge
	else
		return -math.huge
	end
end

return ExtraMath
