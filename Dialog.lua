local Resources = require(game:GetService("ReplicatedStorage"):WaitForChild("Resources"))
local Button = Resources:LoadLibrary("Button")
local Colors = Resources:LoadLibrary("Colors")
local Enumeration = Resources:LoadLibrary("Enumeration")
local Tween = Resources:LoadLibrary("Tween")

local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer -- repeat LocalPlayer = Players.LocalPlayer until LocalPlayer or not wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui") --repeat PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") until PlayerGui or not wait()

local DialogBox = Instance.new("ImageLabel")
DialogBox.AnchorPoint = Vector2.new(0.5, 0.5)
DialogBox.BackgroundColor3 = Color3.new(1, 1, 1)
DialogBox.BackgroundTransparency = 1
DialogBox.BorderSizePixel = 0
DialogBox.Size = UDim2.new(0.55, 0, 0.25, 0)
DialogBox.Position = UDim2.new(0.5, 0, 0.5, 0)
DialogBox.Image = "rbxasset://textures/ui/btn_newWhite.png"
DialogBox.ImageTransparency = 0
DialogBox.ScaleType = Enum.ScaleType.Slice
DialogBox.SliceCenter = Rect.new(7, 7, 13, 13)

local Dialog = { }

Enumeration.DialogType = { "Alert", "Menu", "Standard", "Confirmation" }

local TweenCompleted = Enum.TweenStatus.Completed

function Dialog.new(Type, Parent, Title, Message, Dismiss, Affirm) -- Title, Message, Dismiss, Affirm)
	-- @param string Type
	-- Standard, Alert, Menu, Confirmation
	-- @param string Title
	-- @param string Message
	-- @param string Dismiss
	-- @param string Affirm

	local Bindable = Instance.new("BindableEvent")
	local self = { OnClose = Bindable.Event }
	
	local DialogBox = DialogBox:Clone()
	DialogBox.Parent = Parent

	local TitleText = Instance.new("TextLabel")
	TitleText.Text = Title
	TitleText.BackgroundTransparency = 1
	TitleText.Name = "Title"
	TitleText.Position = UDim2.new(0, 27, 0, 27)
	TitleText.Size = UDim2.new(1, -27, 0.22, 0)
	TitleText.TextXAlignment = Enum.TextXAlignment.Left
	TitleText.TextYAlignment = Enum.TextYAlignment.Top
	TitleText.Font = Enum.Font.SourceSans
	TitleText.TextColor3 = Colors.Black
	TitleText.TextSize = 28
	TitleText.TextTransparency = 1 - 0xde / 255
	TitleText.Parent = DialogBox
	
	local MessageText = TitleText:Clone()
	MessageText.Name = "Message"
	MessageText.Position = UDim2.new(0, 27, 0, 72)
	MessageText.Size = UDim2.new(1, -48, 0, 44)
	MessageText.Text = Message
	MessageText.TextSize = 20
	MessageText.TextTransparency = 1 - 0x99 / 255
	MessageText.TextWrapped = true
	MessageText.Parent = DialogBox
	
	local PrimaryButton = Button.new("Flat", DialogBox)
	PrimaryButton.AnchorPoint = Vector2.new(1, 1)
	PrimaryButton.Font = Enum.Font.SourceSansBold
	PrimaryButton.TextSize = 18
	PrimaryButton.Name = "PrimaryButton"
	PrimaryButton.Position = UDim2.new(1, -8, 1, -8)
	PrimaryButton.Size = UDim2.new(0, 88, 0, 36)
	PrimaryButton.Text = Affirm:upper()
	PrimaryButton.TextColor3 = Colors.DeepPurple.Accent[700]
	
	local SecondaryButton = Button.new("Flat", DialogBox)
	SecondaryButton.AnchorPoint = Vector2.new(1, 1)
	SecondaryButton.Font = Enum.Font.SourceSansBold
	SecondaryButton.TextSize = 18
	SecondaryButton.Name = "SecondaryButton"
	SecondaryButton.Position = UDim2.new(1, -104, 1, -8)
	SecondaryButton.Size = UDim2.new(0, 88, 0, 36)
	SecondaryButton.Text = Dismiss:upper()
	SecondaryButton.TextColor3 = Colors.DeepPurple.Accent[700]
	
	
end

--local function CloseDialog(Bindable, DialogBox, TitleText, MessageText, DismissButton, AffirmButton)
--	Unblur()
--	if TitleText then
--		Tween(TitleText, "TextTransparency", 1, EaseOut, nil, 0.4, true)
--	end
--
--	if MessageText then
--		Tween(MessageText, "TextTransparency", 1, EaseOut, nil, 0.4, true)
--	end
--
--	if DismissButton then
--		DismissButton.Corner.Visible = false
--		--DismissButton2:ClearAllChildren()
--		--DismissButton = Clone(DismissButton2)
--		--DismissButton.Parent = DialogBox
--		--Destroy(DismissButton2)
--		DismissButton.BackgroundTransparency = 1
--
--		Tween(DismissButton, "TextTransparency", 1, EaseOut, nil, 0.4, true)
--	end
--
--	if AffirmButton then
--		AffirmButton.Corner.Visible = false
--		--AffirmButton2:ClearAllChildren()
--		--AffirmButton = Clone(AffirmButton2)
--		--AffirmButton.Parent = DialogBox
--		--Destroy(AffirmButton2)
--		AffirmButton.BackgroundTransparency = 1
--
--		Tween(AffirmButton, "TextTransparency", 1, EaseOut, nil, 0.4, true)
--	end
--
--	Tween(DialogBox, "BackgroundTransparency", 1, EaseOut, nil, 0.41, true, function()
--		Destroy(DialogBox)
--		print("Destroying bindable")
--		Destroy(Bindable)
--	end)
--
--	Tween(DialogBox, "Position", DialogPosition - newUDim2(0, 0, 0.1, 0), nil, "Smoother", 0.4)
--end
--
--function UI.MakeDialog(Title, Message, Dismiss, Affirm)
--	-- @param string Title
--	-- @param string message
--	-- @param table Buttons {Affirmative; Dismissive}
--
--	local Connections = {}
--	local Bindable = newInstance("BindableEvent")
--	local DialogBox = Clone(DialogBox)
--	local TitleText, MessageText, DismissButton, AffirmButton
--	local Running
--
--	local self = {OnClose = Bindable.Event}
--
--	Tween(DialogBox, "BackgroundTransparency", 0, EaseOut, nil, 0.4)
--	Tween(DialogBox, "Position", DialogPosition, nil, "Smoother", 0.4)
--
--	if Message then
--		MessageText = newInstance("TextLabel", DialogBox)
--		MessageText.Text = Message
--		MessageText.BackgroundTransparency = 1
--		MessageText.Position = newUDim2(0, 24, 0, 24)
--		MessageText.TextXAlignment = "Left"
--		MessageText.TextYAlignment = "Top"
--		MessageText.Font = Enum.Font.SourceSans
--		MessageText.TextColor3 = CurrentTheme.TextColor
--		MessageText.TextSize = 22
--		MessageText.TextTransparency = 1
--		Tween(MessageText, "TextTransparency", 0.46, EaseOut, nil, 0.4)
--	end
--
--	if Title then
--		TitleText = newInstance("TextLabel", DialogBox)
--		TitleText.Text = Title
--		TitleText.BackgroundTransparency = 1
--		TitleText.Position = newUDim2(0, 24, 0, 24)
--		TitleText.TextXAlignment = "Left"
--		TitleText.TextYAlignment = "Top"
--		TitleText.Font = Enum.Font.SourceSans
--		TitleText.TextColor3 = CurrentTheme.TextColor
--		TitleText.TextSize = 28
--		TitleText.TextTransparency = 1
--		Tween(TitleText, "TextTransparency", BlackDefaultTextTransparency, EaseOut, nil, 0.4)
--
--		if Message then
--			MessageText.Position = newUDim2(0, 24, 0, 24 + 28 + 20)
--		end
--	end
--
--
--	if Dismiss then
--		DismissButton = Button.new("Flat", DialogBox)
--		DismissButton.Text = Dismiss
--		DismissButton.TextColor3 = CurrentTheme.PrimaryColor
--		DismissButton.BackgroundTransparency = 1
--		local TextTransparency = DismissButton.TextTransparency
--		DismissButton.TextTransparency = 1
--		local Corner = DismissButton.Corner
--		Corner.Visible = false
--
--		Connections[1] = Connect(DismissButton.MouseButton1Click, function()
--			if not Running then
--				Running = true
--				for a = 1, (Dismiss and 1 or 0) + (Affirm and 1 or 0) do
--					Disconnect(Connections[a])
--				end
--				Fire(Bindable, false)
--				CloseDialog(Bindable, DialogBox, TitleText, MessageText, DismissButton, AffirmButton)
--			end
--		end)
--
--		Tween(DismissButton, "TextTransparency", TextTransparency, EaseOut, nil, 0.4, nil, function()
--			Corner.Visible = true
--		end)
--	end
--
--	if Affirm then
--		AffirmButton = newButton("Flat", DialogBox)
--		AffirmButton.Text = Affirm
--		AffirmButton.TextColor3 = CurrentTheme.PrimaryColor
--		AffirmButton.BackgroundTransparency = 1
--		local TextTransparency = AffirmButton.TextTransparency
--		AffirmButton.TextTransparency = 1
--		local Corner = AffirmButton.Corner
--		Corner.Visible = false
--
--		Connections[Dismiss and 2 or 1] = Connect(AffirmButton.MouseButton1Click, function()
--			if not Running then
--				Running = true
--				for a = 1, (Dismiss and 1 or 0) + (Affirm and 1 or 0) do
--					Disconnect(Connections[a])
--				end
--				Fire(Bindable, true)
--				CloseDialog(Bindable, DialogBox, TitleText, MessageText, DismissButton, AffirmButton)
--			end
--		end)
--
--		Tween(AffirmButton, "TextTransparency", TextTransparency, EaseOut, nil, 0.4, nil, function()
--			Corner.Visible = true
--		end)
--	end
--
--	--DialogBox.Image =
--	--DialogBox.Size = newUDim2(0, 585, 0, 133) -- first button pos
--	--DialogBox.Target = newUDim2(0.5, -292, 0.5, -67)
--	BlurScreen()
--
--	DialogBox.Parent = Screen or GetScreen()
--	local DismissX = 32 + DismissButton.TextBounds.X
--	local AffirmX = 32 + AffirmButton.TextBounds.X
--	DismissX = DismissX > 64 and DismissX or 64
--	AffirmX = AffirmX > 64 and AffirmX or 64
--	DismissButton.Size = newUDim2(0, DismissX, 0, 36)
--	AffirmButton.Size = newUDim2(0, AffirmX, 0, 36)
--	AffirmButton.Position = newUDim2(1, -AffirmX - 8, 1, -44)
--	DismissButton.Position = newUDim2(1, -DismissX - 16 - AffirmX, 1, -44)
--	return self
--end
--
--local Confirmation = Dialog.new()
--Confirmation.OnClose:Connect(print)

return Dialog
