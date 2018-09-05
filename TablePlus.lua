local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local Resources = require(ReplicatedStorage:WaitForChild("Resources"))
local Debug = Resources:LoadLibrary("Debug")
local Table = Resources:LoadLibrary("Table")
local Typer = Resources:LoadLibrary("Typer")

local RAWSET = rawset

local TablePlus = { }

local function Recurse(Depth, Measure, ToFormat, MainTable)
	local ReturnTable = { }
	if MainTable then MainTable[#MainTable + 1] = ReturnTable end
	if Depth > 1 then
		for _ = 1, Measure do
			Recurse(Depth - 1, Measure, ToFormat, MainTable)
		end
	else
		for _ = 1, Measure do
			local Key, Value = next(ToFormat)
			if Key then
				ReturnTable[#ReturnTable + 1] = Value
				ToFormat[Key] = nil
			end
		end
	end
	
	return ReturnTable
end

TablePlus.Replace = Typer.AssignSignature(Typer.Table, Typer.Any, Typer.Any, Typer.OptionalBoolean, function(MainTable, Find, Replace, Deep)
	local Recursive = Deep or false
	for Index, Value in next, MainTable do
		if Value == Find then
			MainTable[Index] = Replace
		elseif type(Value) == "table" and Recursive then
			TablePlus.Replace(Value, Find, Replace, true)
		end
	end
	return MainTable
end)

TablePlus.Solidify = Typer.AssignSignature(Typer.Table, function(MainTable)
	local Nils = 0
	local MainLength = #MainTable
	for Index = 1, MainLength do
		if MainLength >= 1E6 then
			if MainTable[Index] ~= nil then
				RAWSET(MainTable, Index - Nils, TablePlus.QuickRemove(MainTable, Index))
			else
				Nils = 1
			end
		else
			if MainTable[Index] ~= nil then
				table.insert(MainTable, Index - Nils, table.remove(Table, Index))
			else
				Nils = 1
			end
		end
	end
	return MainTable
end)

TablePlus.Fill = Typer.AssignSignature(Typer.Table, Typer.Any, function(MainTable, Value)
	for Index = 1, #MainTable do
		if MainTable[Index] == nil then
			MainTable[Index] = Value
		end
	end
end)

function TablePlus.QuickRemove(MainTable, Index)
	local Size = #MainTable
	MainTable[Index] = MainTable[Size]
	MainTable[Size] = nil
end

return Table.Lock(TablePlus)
