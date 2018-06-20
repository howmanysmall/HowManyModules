local TableLibrary = { }

function TableLibrary:BinSearch(Data, Query)
	assert(type(Data) == "table", "Data is not a table.")
	local Left = 1
	local Right = #Data
	while Left <= Right do
		local Middle = math.floor(0.5 * (Left + Right))
		if Data[Middle] == Query then
			return Middle
		elseif Data[Middle] > Query then
			Right = Middle - 1
		else
			Left = Middle + 1
		end
	end
end

function TableLibrary:Search(Data, Query, DeepSearch)
	assert(type(Data) == "table", "Data is not a table.")
	DeepSearch = DeepSearch or false
	for Index = 1, #Data do
		local Value = Data[Index]
		if Value == Query then
			return true, Index, Value
		elseif DeepSearch and type(Value) == "table" then
			return TableLibrary:Search(Data, Query, true)
		end
	end
end

function TableLibrary:Flatten(Data)
end

function TableLibrary:Flip(Data)
	assert(type(Data) == "table", "Data is not a table.")
	local FlippedTable = { }
	for Key = 1, #Data do
		local Value = Data[Key]
		FlippedTable[Value] = Key
	end
	return FlippedTable
end

function TableLibrary:Reverse(Data)
	assert(type(Data) == "table", "Data is not a table.")
	local ReversedTable = { }
	for Index, Value in ipairs(Data) do
		ReversedTable[#Data - Index + 1] = Value
	end
	return ReversedTable
end

return TableLibrary
