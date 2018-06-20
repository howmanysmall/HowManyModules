# HowManyModules

HowManySmall's modules for RoStrap.

## Usage

Let's load the modules using RoStrap.

```Lua
local Resources = require(game:GetService("ReplicatedStorage"):WaitForChild("Resources"))
local ButtonMake = Resources:LoadLibrary("ButtonMake")
local Dialog = Resources:LoadLibrary("Dialog")
local MathLibrary = Resources:LoadLibrary("MathLibrary")
local TableLibrary = Resources:LoadLibrary("TableLibrary")
```

## ButtonMake

This is almost exactly like the default Button library, except it uses Make formatting.

```Lua
ButtonMake.new(
	String Type, -- The type of Button, same as the default Button.
	Object Parent, -- The parent of the button.
	Table Properties -- The properties of the button.
)

local Example = ButtonMake.new("Flat", script.Parent, {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Name = "ButtonMake",
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, 150, 0, 35),
	Font = Enum.Font.SourceSansBold,
	Text = "BUTTONMAKE",
	TextColor3 = Color3.fromRGB(0, 121, 107),
	TextSize = 24
})
```

## Dialog

This is a Dialog library I was asked to make by Validark. It's not finished yet, and I'm more than likely incapable of finishing it.

## MathLibrary

This is a huge library with lots of functions, so I'll just go over what I believe are the most useful ones.

```Lua
-- Returns the factorial of a number. (Number!)
Math.Factorial(
	Number Number -- The number you want the factorial of.
)
print(Math.Factorial(5)) -- returns 120.

-- Returns the cube root of a number.
Math.Cbrt(
	Number Number -- The number you want the cube root of.
)
print(Math.Cbrt(8)) -- returns 2

-- Returns the hypotenuse of a right angle triangle.
Math.Hypot(
	Number X,
	Number Y
)
print(Math.Hypot(8, 6)) -- returns 10.

-- Returns the GCD of two numbers.
Math.GCD(
	Number X,
	Number Y
)
print(Math.GCD(100, 15)) -- returns 5.

-- Returns the factors of a number.
Math.Factors(
	Number Number -- The number you want the factors of.
)
table.foreach(Math.Factors(100), print)
--[[
Returns:
	1 1
	2 2
	3 4
	4 5
	5 10
	6 20
	7 25
	8 50
	9 100
]]--

-- Returns if a bool determining if the number is even or not.
Math.IsEven(
	Number Number
)
print(Math.IsEven(6)) -- Returns true
print(Math.IsEven(5)) -- Returns false
```

## TableLibrary

A library for table functions I was working on in my free time.

```Lua
TableLibrary.Replace(
	table Table, -- The table you are modifying.
	Value Find, -- The value you are changing.
	Value Replace, -- The value you are replacing it with.
	bool Recurse -- Whether or not the function is recursive.
)
local ToReplace = { "RoStrap", "RoStrap", "NevermoreEngine", "RoStrap", "NevermoreEngine", "NevermoreEngine", "RoStrap" }
table.foreach(TableLibrary.Replace(ToReplace, "NevermoreEngine", "RoStrap"), print)
--[[
Returns:
	1 RoStrap
	2 RoStrap
	3 RoStrap
	4 RoStrap
	5 RoStrap
	6 RoStrap
	7 RoStrap
]]

TableLibrary.Solidify(
	table Table -- The table you are operating on.
)
local ToSolidify = { "One", nil, "Two", "Three", 4, nil, 5 }
table.foreach(TableLibrary.Solidify(ToSolidify), print)
--[[
Returns:
	1 One
	2 Two
	3 3
	4 4
	5 5
	6 Three
]]--

-- Finish later okay
```