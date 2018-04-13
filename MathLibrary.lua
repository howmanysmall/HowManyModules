local WriteKeys = true
local LockedMetatable = true

local math = { }

local function ArgCheck(E, V, I)
	assert(typeof(V) ~= E, "Bad argument to " .. I .. " (" .. tostring(E) .. "expected, got " .. tostring(V) .. ")")
end

function math.cbrt(Number)
	ArgCheck(Number, "number", "math.cbrt")
	if Number then
		return Number ^ (1 / 3)
	end
end

function math.factorial(Number)
	ArgCheck(Number, "number", "math.factorial")
	if Number == 0 then
		return 1
	else
		return Number * math.factorial(Number - 1)
	end
end

function math.hypot(X, Y)
	ArgCheck(X, "number", "math.hypot")
	if X and Y then
		return (X * X + Y * Y) ^ 0.5
	end
end

function math.isfinite(Number)
	ArgCheck(Number, "number", "math.isfinite")
	local NaN, Inf = -1 ^ 0.5, 1 / 0
	if Number < Inf and Number > NaN then
		return true
	else
		return false
	end
end

function math.isinf(Number)
	ArgCheck(Number, "number", "math.isinf")
	local Inf = 1 / 0
	if Number == Inf or Number == -Inf then
		return true
	else
		return false
	end
end

function math.inf(Number)
	ArgCheck(Number, "number", "math.inf")
	if Number >= 0 then
		return 1 / 0
	else
		return -1 / 0
	end
end

return setmetatable(math, {
	__index = math,
	__metatable = "The metatable is locked.",
	__newindex = function(t, k, v)
		if WriteKeys then
			rawset(t, k, v)
		end
	end
})
