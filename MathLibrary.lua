local NaN, Inf, Pi = -1 ^ 0.5, math.huge, math.pi
local NumberType, TableType = "number", "table"

local DegConvert = 180 / Pi
local RadConvert = Pi / 180

local function EqualValueAndType(X, Y)
	if (X == Y) and (typeof(X) == typeof(Y)) then
		return true
	else
		return false
	end
end

local function NotEqualValueOrType(X, Y)
	if (X == Y) and (typeof(X) == typeof(Y)) then
		return false
	else
		return true
	end
end

local function Digits(Number)
	if Number > 0 then
		return Number % 10, Digits(math.floor(Number * 0.1))
	end
end

-- Gauss-Legendre Quadrature
local Order = 0
local LegendreRoots = { }
local LegendreWeights = { }

local function Legendre(Number, Z)
	if Number == 0 then
		return 1
	elseif Number == 1 then
		return Z
	else
		return ((2 * Number - 1) * Z * Legendre(Number - 1, Z) - (Number - 1) * Legendre(Number - 2, Z)) / Number
	end
end

local function LegendreDerivative(Number, Z)
	if Number == 0 then
		return 0
	elseif Number == 1 then
		return 1
	else
		return (Number * ((Z * Legendre(Number,  Z)) - Legendre(Number - 1, Z))) / (Z * Z - 1)
	end
end

local function GetLegendreRoots()
	local Y, Y1
	
	for Index = 1, Order do
		Y = math.cos(Pi * (Index - 0.25) / (Order + 0.5))
		repeat
			Y1 = Y
			Y = Y - (Legendre(Order, Y) / LegendreDerivative(Order, Y))
		until Y == Y1
		LegendreRoots[#LegendreRoots + 1] = Y
	end
end

local function GetLegendreWeights()
	for Index = 1, Order do
		local Weight = 2 / ((1 - LegendreRoots[Index] * LegendreRoots[Index]) * LegendreDerivative(Order, LegendreRoots[Index]) * LegendreDerivative(Order, LegendreRoots[Index]))
		LegendreWeights[#LegendreWeights + 1] = Weight
	end
end

local Math = { } do
	local OldRandom = math.random
	local RandomTable = { }
	function Math.Random()
		if RandomTable then
			for Index = 1, 97 do
				RandomTable[Index] = OldRandom()
			end
		end
		local xRandom = OldRandom()
		local Index = 1 + math.floor(97 * xRandom)
		xRandom, RandomTable[Index] = RandomTable[Index], xRandom
		return xRandom
	end
end

Math.Factorial = setmetatable({ [0] = 1 }, {
	__call = function(Table, Number)
		if Number < 0 then return 0 end
		if not Table[Number] then Table[Number] = Number * Table(Number - 1) end
		return Table[Number]
	end
})

function Math.Cbrt(Number)
	return Number ^ 0.33333333333333
end


function Math.Hypot(X, Y)
	return (X * X + Y * Y) ^ 0.5
end

function Math.IsFinite(Number)
	return Number == Number and Number ~= 1 / 0 and Number ~= -1 / 0
end

--function Math.IsFinite(Number)
--	if Number < Inf and Number > NaN then
--		return true
--	else
--		return false
--	end
--end

function Math.IsInf(Number)
	if Number == Inf or Number == -Inf then
		return true
	else
		return false
	end
end

function Math.GCD(X, Y)
	return X == 0 and Y or Math.GCD(Y % X, X)
end

function Math.Mod(X, Y)
	return X % Y
end

function Math.Deg(Number)
	return Number * DegConvert
end

function Math.Rad(Number)
	return Number * RadConvert
end

function Math.SquareSum(Number, ...)
	return Number and (Number * Number) + Math.SquareSum(...) or 0
end

function Math.SquareSumT(Table)
	return Math.SquareSum(unpack(Table))
end

Math.Catalan = { [0] = 1 }
setmetatable(Math.Catalan, {
	__index = function(C, Number)
		C[Number] = C[Number - 1] * 2 * (2 * Number - 1) / (Number + 1)
		return C[Number]
	end
})

Math.Happy = setmetatable({ true, false, false, false }, {
	__index = function(self, Number)
		self[Number] = self[Math.SquareSum(Digits(Number))]
		return self[Number]
	end
})

Math.PowerSeries = setmetatable({
	__add = function(Z1, Z2)
		return Math.PowerSeries(function(Number)
			return Z1.Coefficient(Number) + Z2.Coefficient(Number)
		end)
	end,
	
	__sub = function(Z1, Z2)
		return Math.PowerSeries(function(Number)
			return Z1.Coefficient(Number) - Z2.Coefficient(Number)
		end)
	end,
	
	__mul = function(Z1, Z2)
		return Math.PowerSeries(function(Number)
			local Return = 0
			for Index = 0, Number do
				Return = Return + Z1.Coefficient(Index) * Z2.Coefficient(Number - Index)
			end
			return Return
		end)
	end,
	
	__div = function(Z1, Z2)
		return Math.PowerSeries(function(Number)
			local Return = Z1.Coefficient(Number)
			local function Coefficients(A)
				local C = Z1.Coefficient(A)
				for Index = 0, A - 1 do
					C = C - Coefficients(Index) * Z2.Coefficient(A - Index)
				end
				return C / Z2.Coefficient(0)
			end
			
			for Index = 0, Number - 1 do
				Return = Return - Coefficients(Index) * Z2.Coefficient(Number - Index)
			end
			
			return Return / Z2.Coefficient(0)
		end)
	end,
	
	__pow = function(Z1, Power)
		if Power == 0 then
			return Z1
		elseif Power > 0 then
			return Math.PowerSeries(function(Index)
				return Z1.Coefficient(Index + 1) * (Index + 1)
			end) ^ (Power - 1)
		else
			return Math.PowerSeries(function(Index)
				return Z1.Coefficient(Index - 1) / Index
			end) ^ (Power + 1)
		end
	end,
	
	__unm = function(Z1)
		return Math.PowerSeries(function(Number)
			return -Z1.Coefficient(Number)
		end)
	end,
	
	__index = function(Z, Number)
		return Z.Coefficient(Number)
	end,
	
	__call = function(Z, Number)
		local Return = 0
		for Index = 0, 15 do
			Return = Return + Z[Index] * (Number ^ Index)
		end
		return Return
	end
}, { __call = function(Z, F) return setmetatable({ Coefficient = F }, Z) end })

Math.Cosine = Math.PowerSeries(function(Number)
	if Number == 0 then
		return 1
	else
		return -((Math.Sine ^ -1)[Number])
	end
end)

Math.Sine = Math.PowerSeries(function(Number)
	if Number == 0 then
		return 0
	else
		return (Math.Cosine ^ -1)[Number]
	end
end)

function Math.Factors(Number)
	local Factors = { }
	for Index = 1, 0.5 * Number do
		if Number % Index == 0 then
			Factors[#Factors + 1] = Index
		end
	end
	Factors[#Factors + 1] = Number
	return Factors
end

function Math.IsEven(Number)
	return Number % 2 == 0
end

function Math.GaussLegendreQuadrature(Function, LowerLimit, UpperLimit, Number)
	Order = Number do
		GetLegendreRoots()
		GetLegendreWeights()
	end
	
	local C1 = 0.5 * (UpperLimit - LowerLimit)
	local C2 = 0.5 * (UpperLimit + LowerLimit)
	local Sum = 0
	
	for Index = 1, Order do
		Sum = Sum + LegendreWeights[Index] * Function(C1 * LegendreRoots[Index] + C2)
	end
	
	return C1 * Sum
end

function Math.ForwardDifference(X, Y, ...)
	if type(X) == NumberType and type(Y) == NumberType and Y then
		return Y - X, Math.ForwardDifference(Y, ...)
	end
end

function Math.ForwardDifferenceT(Table)
	return { Math.ForwardDifference(unpack(Table)) }
end

Math.Complex = setmetatable({
	__add = function(U, V)
		return Math.Complex(U.Real + V.Real, U.Imaginary + V.Imaginary)
	end,
	
	__sub = function(U, V)
		return Math.Complex(U.Real - V.Real, U.Imaginary - V.Imaginary)
	end,
	
	__mul = function(U, V)
		return Math.Complex(U.Real * V.Real, U.Imaginary * V.Imaginary)
	end,
	
	__div = function(U, V)
		return U * Math.Complex(V.Real / V.Normal, -V.Imaginary / V.Normal)
	end,
	
	__unm = function(U)
		return Math.Complex(-U.Real, -U.Imaginary)
	end,
	
	__concat = function(U, V)
		if type(U) == TableType then
			return U.Real .. " + " .. U.Imaginary .. "i" .. V
		elseif type(U) == "string" or type(U) == NumberType then
			return U .. V.Real .. " + " .. V.Imaginary .. "i"
		end
	end,
	
	__index = function(U, Index)
		local Operations = {
			Normal = function(U)
				return U.Real * U.Real + U.Imaginary * U.Imaginary
			end,
			
			Conjugation = function(U)
				return Math.Complex(U.Real, -U.Imaginary)
			end
		}
		return Operations[Index] and Operations[Index](U)
	end,
	
	__newindex = function() error() end
}, { __call = function(Z, RealPart, ImagPart) return setmetatable({ Real = RealPart, Imaginary = ImagPart }, Math.Complex) end })

do
	local function Coerce(X, Y)
		if type(X) == NumberType then return Math.Rational(X, 1), Y end
		if type(Y) == NumberType then return X, Math.Rational(Y, 1) end
	end
	
	Math.Rational = setmetatable({
		__add = function(X, Y)
			local X, Y = Coerce(X, Y)
			return Math.Rational(X.Numerator * Y.Denominator + X.Denominator * Y.Numerator, X.Denominator * Y.Denominator)
		end,
		
		__sub = function(X, Y)
			local X, Y = Coerce(X, Y)
			return Math.Rational(X.Numerator * Y.Denominator - X.Denominator * Y.Numerator, X.Denominator * Y.Denominator)
		end,
		
		__mul = function(X, Y)
			local X, Y = Coerce(X, Y)
			return Math.Rational(X.Numerator * Y.Numerator, X.Denominator * Y.Denominator)
		end,
		
		__div = function(X, Y)
			local X, Y = Coerce(X, Y)
			return Math.Rational(X.Numerator * Y.Denominator, X.Denominator * Y.Numerator)
		end,
		
		__pow = function(X, Y)
			if type(X) == NumberType then return X ^ (Y.Numerator / Y.Denominator) end
			return Math.Rational(X.Numerator ^ Y, X.Denominator ^ Y)
		end,
		
		__concat = function(X, Y)
			if getmetatable(X) == Math.Rational then
				return X.Numerator .. "/" .. X.Denominator .. Y
			end
			return X .. Y.Numerator .. "/" .. Y.Denominator
		end,
		
		 __unm = function(X) return Math.Rational(-X.Numerator, -X.Denominator) end
	}, {
		__call = function(Z, X, Y)
			return setmetatable({ Numerator = X / Math.GCD(X, Y), Denominator = Y / Math.GCD(X, Y) }, Z)
		end
	})
end

function Math.FindPerfs(Number)
	local Return = { }
	for Index = 1, Number do
		local Sum = Math.Rational(1, Index)
		for Factor = 2, Index ^ 0.5 do
			if Index % Factor == 0 then
				Sum = Sum + Math.Rational(1, Factor) + Math.Rational(Factor, Index)
			end
		end
		if Sum.Denominator == Sum.Numerator then
			Return[#Return + 1] = Index
		end
	end
	return table.concat(Return, "\n")
end

return Math
