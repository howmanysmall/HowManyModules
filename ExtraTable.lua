local Resources = require(game:GetService("ReplicatedStorage"):WaitForChild("Resources"))
local Debug = Resources:LoadLibrary("Debug")
local HttpService = game:GetService("HttpService")
local ExtraTable = { }

local function Recurse(Depth, Measure, ToFormat, Table)
	local _Table = { }
	if Table then table.insert(Table, _Table) end
	if Depth > 1 then
		for Number = 1, Measure do
			Recurse(Depth - 1, Measure, ToFormat, Table)
		end
	else
		for Number = 1, Measure do
			local Key, Value = next(ToFormat)
			if Key then
				table.insert(_Table, Value)
				ToFormat[Key] = nil
			end
		end
	end
	return _Table
end

function ExtraTable.Replace(Table, Find, Replace, Recurse)
	-- @param table Table the table you are operating on.
	-- @param ____ Find the value you are changing.
	-- @param ____ Replace the value you are replacing it with.
	-- @param bool Recurse whether you want to replace inside nested tables aswell.
	Debug.Assert(type(Table) == "table", "\"Table\" is not a table; instead got a: " .. typeof(Table))
	Debug.Assert(Find, "\"Find\" was not supplied.")
	Debug.Assert(Replace, "\"Replace\" was not supplied.")
	local Recurse = Recurse or false
	for Index, Value in pairs(Table) do
		if Value == Find then
			Table[Index] = Replace
		elseif type(Value) == "table" and Recurse then
			ExtraTable.Replace(Value, Find, Replace, true)
		end
	end
	return Table
end

function ExtraTable.Solidify(Table)
	-- @param table Table the table you are operating on.
	Debug.Assert(type(Table) == "table", "\"Table\" is not a table; instead got a: " .. typeof(Table))
	local Nils = 0
	for Index = 1, #Table do
		if Table[Index] ~= nil then
			table.insert(Table, Index - Nils, table.remove(Table, Index))
		else
			Nils = 1
		end
	end
	return Table
end

function ExtraTable.Fill(Table, Value)
	-- @param table Table the table you are operating on.
	-- @param ____ Value the value you want to fill empty spaces.
	Debug.Assert(type(Table) == "table", "\"Table\" is not a table; instead got a: " .. typeof(Table))
	Debug.Assert(Value, "\"Value\" was not supplied.")
	for Index = 1, #Table do
		if Table[Index] == nil then
			Table[Index] = Value
		end
	end
end

function ExtraTable.Dimensional(Table, Dimensions)
	-- @param table Table the table you are operating on.
	-- @param number Dimensions how many dimensions you want the new table to be.
	Debug.Assert(type(Table) == "table", "\"Table\" is not a table; instead got a: " .. typeof(Table))
	return Recurse(Dimensions, table.getn(Table) ^ 1 / Dimensions or 2, Table)
end

function ExtraTable.Tostring(Table, Deep)
	-- @param table Table the table you are operating on.
	-- @param bool Deep whether or not you want to recurse in embeded tables.
	Debug.Assert(type(Table) == "table", "\"Table\" is not a table; instead got a: " .. typeof(Table))
	local Temporary = { }
	for Index, Value in pairs(Table) do
		if type(Value) == "table" and Deep then
			for Index2, Value2 in pairs(ExtraTable.Tostring(Value, true)) do
				table.insert(Temporary, tostring(Value2))
			end
		else
			table.insert(Temporary, tostring(Value))
		end
	end
	return table.concat(Temporary)
end

function ExtraTable.Compare(Table1, Table2, Meta, JSON)
	-- @param table Table1 the table you are comparing to Table2.
	-- @param table Table2 the table you are comparing to Table1.
	-- @param bool Meta whether or not you want to compare metatables.
	-- @param bool JSON whether or not you want to use the EncodeJSON function instead of the Tostring function.
	Debug.Assert(type(Table1) == "table", "\"Table1\" is not a table; instead got a: " .. typeof(Table1))
	Debug.Assert(type(Table2) == "table", "\"Table2\" is not a table; instead got a: " .. typeof(Table2))
	if JSON then
		local Same = ExtraTable:EncodeJSON(Table1) == ExtraTable:EncodeJSON(Table2)
		if Meta then
			return Same and ExtraTable:EncodeJSON(getmetatable(Table1)) == ExtraTable:EncodeJSON(getmetatable(Table2))
		else
			return Same
		end
	else
		local Same = ExtraTable.Tostring(Table1) == ExtraTable.Tostring(Table2)
		if Meta then
			return Same and ExtraTable.Tostring(getmetatable(Table1)) == ExtraTable.Tostring(getmetatable(Table2))
		else
			return Same
		end
	end
end

function ExtraTable:EncodeJSON(Table)
	-- @param table Table the table you are operating on.
	Debug.Assert(type(Table) == "table", "\"Table\" is not a table; instead got a: " .. typeof(Table))
	return HttpService:JSONEncode(Table)
end

function ExtraTable:DecodeJSON(Table)
	-- @param table Table the table you are operating on.
	Debug.Assert(type(Table) == "table", "\"Table\" is not a table; instead got a: " .. typeof(Table))
	return HttpService:JSONDecode(Table)
end

return ExtraTable
