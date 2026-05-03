local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mainUI

local Theme = {
	MainBackground = Color3.fromRGB(30, 30, 30),
	TopBar = Color3.fromRGB(45, 45, 45),
	Sidebar = Color3.fromRGB(35, 35, 35),
	ElementBackground = Color3.fromRGB(40, 40, 40),
	SecondaryBackground = Color3.fromRGB(30, 30, 30),
	Accent = Color3.fromRGB(0, 170, 255),
	Text = Color3.fromRGB(255, 255, 255),
	SecondaryText = Color3.fromRGB(200, 200, 200),
	Scrollbar = Color3.fromRGB(80, 80, 80),
	SliderBack = Color3.fromRGB(60, 60, 60),
	ToggleOff = Color3.fromRGB(70, 70, 70)
}

local function create(c, p)
	local o = Instance.new(c)
	for i, v in pairs(p) do o[i] = v end
	return o
end

local function applyTween(o, p, t)
	TweenService:Create(o, TweenInfo.new(t or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play()
end

local function drag(f, h)
	h = h or f
	local d, s, sp

	h.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			d = true s = i.Position sp = f.Position

			local connection
			connection = i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					d = false
					connection:Disconnect()
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - s
			f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
		end
	end)
end

local function makeMain(Title, ImageID)
	local gui = create("ScreenGui", {Parent = playerGui, ResetOnSpawn = false, Name = Title.."_Gui"})
	local toggleFrame = create("Frame", {Parent = gui, Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0.005, 0, 0.15, 0), BackgroundTransparency = 1})
	local toggleBtn = create("ImageButton", {Parent = toggleFrame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Image = ImageID})

	drag(toggleFrame)
	drag(toggleBtn)

	local main = create("Frame", {
		Parent = gui,
		Size = UDim2.new(0, 550, 0, 350),
		Position = UDim2.new(0.5, 0, 1.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Theme.MainBackground,
		BorderSizePixel = 0,
		Visible = false,
		ClipsDescendants = true
	})

	create("UICorner", {Parent = main, CornerRadius = UDim.new(0.05, 0)})

	local top = create("Frame", {Parent = main, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.TopBar, BorderSizePixel = 0, ZIndex = 999})
	local filler = create("Frame", {Parent = main, Size = UDim2.new(1, 0, 0, 7), BackgroundColor3 = Theme.TopBar, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 40), ZIndex = 998})
	local title = create("TextLabel", {Parent = top, Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = Title, TextColor3 = Theme.Text, Font = Enum.Font.FredokaOne, TextSize = 24, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 999})
	local closeBtn = create("TextButton", {Parent = top, Size = UDim2.new(0, 45, 1, 0), Position = UDim2.new(1, -45, 0, 0), Text = "X", BackgroundTransparency = 1, TextColor3 = Theme.Text, Font = Enum.Font.FredokaOne, TextSize = 20, ZIndex = 999})

	create("UICorner", {Parent = top, CornerRadius = UDim.new(0.1, 0)})
	drag(main, top)

	local sidebar = create("Frame", {
		Parent = main,
		Size = UDim2.new(0, 120, 1, -45),
		Position = UDim2.new(0, 0, 0, 45),
		BackgroundColor3 = Theme.Sidebar,
		BorderSizePixel = 0,
		Name = "Sidebar"
	})
	create("UIListLayout", {Parent = sidebar, Padding = UDim.new(0, 5), HorizontalAlignment = Enum.HorizontalAlignment.Center})
	create("UIPadding", {Parent = sidebar, PaddingTop = UDim.new(0, 10)})
	create("UICorner", {Parent = sidebar, CornerRadius = UDim.new(0.05, 0)})

	local open = false

	local OpenX = 0
	local OpenY = 0

	local function openUI() open = true main.Visible = true applyTween(main, {Position = UDim2.new(0.5, OpenX, 0.5, OpenY)}, 0.3) end
	local function closeUI() open = false applyTween(main, {Position = UDim2.new(0.5, main.Position.X.Offset, 1.5, main.Position.Y.Offset)}, 0.3) task.delay(0.3, function() if not open then main.Visible = false end end) end

	toggleBtn.MouseButton1Click:Connect(function() 
		if open then 
			closeUI() 

			OpenX = main.Position.X.Offset
			OpenY = main.Position.Y.Offset
		else 
			openUI() 
		end 
	end)
	closeBtn.MouseButton1Click:Connect(closeUI)

	return main
end

mainUI = makeMain("UiFramework", "rbxassetid://85516224537304")

local sectionFrames = {} 
local currentSectionContainer = nil

local function makeSection(name)
	local sectionFrame = create("ScrollingFrame", {
		Parent = mainUI,
		Size = UDim2.new(1, -140, 1, -60),
		Position = UDim2.new(0, 130, 0, 55),
		BackgroundTransparency = 1,
		ScrollBarThickness = 4,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarImageColor3 = Theme.Scrollbar,
		Visible = false,
		ClipsDescendants = true
	})

	create("UIListLayout", {
		Parent = sectionFrame, 
		Padding = UDim.new(0, 10), 
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	create("UIPadding", {
		Parent = sectionFrame,
		PaddingTop = UDim.new(0, 2),
		PaddingBottom = UDim.new(0, 25), 
		PaddingLeft = UDim.new(0, 5),
		PaddingRight = UDim.new(0, 10)
	})

	table.insert(sectionFrames, sectionFrame)

	if #sectionFrames == 1 then
		sectionFrame.Visible = true
	end

	create("TextLabel", {
		Parent = sectionFrame,
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		Text = name:upper(),
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 20,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = -1 
	})

	currentSectionContainer = sectionFrame

	local navBtn = create("TextButton", {
		Parent = mainUI:FindFirstChild("Sidebar"),
		Size = UDim2.new(0.9, 0, 0, 35),
		BackgroundColor3 = Theme.TopBar,
		Text = name,
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 14
	})

	create("UICorner", {Parent = navBtn, CornerRadius = UDim.new(0, 4)})

	navBtn.MouseButton1Click:Connect(function()
		for _, frame in pairs(sectionFrames) do
			frame.Visible = false
		end

		sectionFrame.Visible = true

		local layout = sectionFrame:FindFirstChildOfClass("UIListLayout")
		if layout then
			sectionFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
		end
	end)
end

local function makeToggle(text, callback)
	local frame = create("Frame", {Parent = currentSectionContainer, Size = UDim2.new(1, -10, 0, 45), BackgroundColor3 = Theme.ElementBackground, BorderSizePixel = 0})
	create("UICorner", {Parent = frame, CornerRadius = UDim.new(0, 6)})
	local label = create("TextLabel", {Parent = frame, Size = UDim2.new(0.7, 0, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})
	local switch = create("Frame", {Parent = frame, Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -50, 0.5, -10), BackgroundColor3 = Theme.ToggleOff})
	create("UICorner", {Parent = switch, CornerRadius = UDim.new(1, 0)})
	local knob = create("Frame", {Parent = switch, Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = Theme.Text})
	create("UICorner", {Parent = knob, CornerRadius = UDim.new(1, 0)})
	local state = false

	local function set(v)
		state = v

		if state then
			applyTween(knob, {Position = UDim2.new(1, -17, 0.5, -7)}, 0.2)
			applyTween(switch, {BackgroundColor3 = Theme.Accent}, 0.2)
		else
			applyTween(knob, {Position = UDim2.new(0, 3, 0.5, -7)}, 0.2)
			applyTween(switch, {BackgroundColor3 = Theme.ToggleOff}, 0.2)
		end

		if callback then
			callback(state)
		end
	end

	frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then set(not state) end end)

	return function() return state end, set
end

local function makeSlider(text, min, max, default, callback)
	local frame = create("Frame", {Parent = currentSectionContainer, Size = UDim2.new(1, -10, 0, 65), BackgroundColor3 = Theme.ElementBackground, BorderSizePixel = 0})
	create("UICorner", {Parent = frame, CornerRadius = UDim.new(0, 6)})

	local label = create("TextLabel", {Parent = frame, Size = UDim2.new(1, -30, 0, 30), Position = UDim2.new(0, 15, 0, 5), BackgroundTransparency = 1, Text = text .. ": " .. default, TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})

	local sliderBack = create("Frame", {Parent = frame, Size = UDim2.new(1, -30, 0, 6), Position = UDim2.new(0, 15, 0, 45), BackgroundColor3 = Theme.SliderBack})
	create("UICorner", {Parent = sliderBack, CornerRadius = UDim.new(1, 0)})

	local fill = create("Frame", {Parent = sliderBack, Size = UDim2.new((default - min) / (max - min), 0, 1, 0), BackgroundColor3 = Theme.Accent})
	create("UICorner", {Parent = fill, CornerRadius = UDim.new(1, 0)})

	local knob = create("Frame", {Parent = fill, Size = UDim2.new(0, 16, 0, 16), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = Theme.Text})
	create("UICorner", {Parent = knob, CornerRadius = UDim.new(1, 0)})

	local dragging = false
	local function update(input)
		local pos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
		local val = math.floor(min + (max - min) * pos)
		fill.Size = UDim2.new(pos, 0, 1, 0)
		label.Text = text .. ": " .. val
		callback(val)
	end

	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then update(input) end
	end)
end

local function makeButton(text, callback)
	local btn = create("TextButton", {
		Parent = currentSectionContainer,
		Size = UDim2.new(1, -10, 0, 45),
		BackgroundColor3 = Theme.ElementBackground,
		Text = text,
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 14
	})
	create("UICorner", {Parent = btn, CornerRadius = UDim.new(0, 6)})

	if callback then
		btn.MouseButton1Click:Connect(callback)
	end

	return btn
end

local function makeDescription(text, description)
	local txt = create("TextLabel", {
		Parent = currentSectionContainer,
		Size = UDim2.new(1, -10, 0, 45),
		BackgroundColor3 = Theme.ElementBackground,
		Text = text,
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Position = UDim2.new(0, 5, 0, 0) 
	})

	create("UICorner", {Parent = txt, CornerRadius = UDim.new(0, 6)})

	create("UIPadding", {
		Parent = txt,
		PaddingLeft = UDim.new(0, 10),
		PaddingTop = UDim.new(0, 8)
	})

	local descLabel = create("TextLabel", {
		Parent = txt,
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 0, 0, 18), 
		BackgroundTransparency = 1,
		Text = description,
		TextColor3 = Theme.SecondaryText, 
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true
	})

	return function(newText, newDescription)
		txt.Text = newText
		descLabel.Text = newDescription
	end
end

local function makeDropdown(text, list, callback)
	local frame = create("Frame", {
		Parent = currentSectionContainer, 
		Size = UDim2.new(1, -10, 0, 45), 
		BackgroundColor3 = Theme.ElementBackground, 
		BorderSizePixel = 0, 
		ClipsDescendants = true
	})
	create("UICorner", {Parent = frame, CornerRadius = UDim.new(0, 6)})

	local label = create("TextLabel", {
		Parent = frame, 
		Size = UDim2.new(1, -15, 0, 45), 
		Position = UDim2.new(0, 15, 0, 0),
		BackgroundTransparency = 1, 
		Text = text .. ": None ↓", 
		TextColor3 = Theme.Text, 
		Font = Enum.Font.GothamBold, 
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local btn = create("TextButton", {
		Parent = frame, 
		Size = UDim2.new(1, 0, 0, 45), 
		BackgroundTransparency = 1, 
		Text = ""
	})

	local container = create("Frame", {
		Parent = frame, 
		Size = UDim2.new(1, 0, 0, 0), 
		Position = UDim2.new(0, 0, 0, 45), 
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	})
	create("UIListLayout", {Parent = container})

	local open = false
	btn.MouseButton1Click:Connect(function()
		open = not open
		applyTween(frame, {Size = UDim2.new(1, -10, 0, open and (45 + container.AbsoluteSize.Y) or 45)})
		label.Text = open and (text .. ": " .. ("None") .. " ↑") or (text .. ": " .. ("None") .. " ↓")
	end)

	local function populate(newList)
		for _, child in pairs(container:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end

		for _, v in pairs(newList) do
			local opt = create("TextButton", {
				Parent = container, 
				Size = UDim2.new(1, 0, 0, 30), 
				BackgroundTransparency = 1, 
				Text = v, 
				TextColor3 = Theme.SecondaryText, 
				Font = Enum.Font.Gotham, 
				TextSize = 12
			})

			opt.MouseButton1Click:Connect(function()
				label.Text = text .. ": " .. v .. " ↓"
				callback(v)
				open = false
				applyTween(frame, {Size = UDim2.new(1, -10, 0, 45)})
			end)
		end
	end

	populate(list)

	return populate
end

local function makeField(title, default, callback)
	local frame = create("Frame", {
		Parent = currentSectionContainer,
		Size = UDim2.new(1, -10, 0, 55),
		BackgroundColor3 = Theme.ElementBackground,
		BorderSizePixel = 0
	})
	create("UICorner", {Parent = frame, CornerRadius = UDim.new(0, 6)})

	local label = create("TextLabel", {
		Parent = frame,
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 10, 0, 5),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local box = create("TextBox", {
		Parent = frame,
		Size = UDim2.new(1, -20, 0, 25),
		Position = UDim2.new(0, 10, 0, 25),
		BackgroundColor3 = Theme.SecondaryBackground,
		Text = default or "None",
		TextColor3 = Theme.Text,
		Font = Enum.Font.Gotham,
		TextSize = 14,
		ClearTextOnFocus = false
	})
	create("UICorner", {Parent = box, CornerRadius = UDim.new(0, 4)})

	box.FocusLost:Connect(function()
		if callback then
			callback(box.Text)
		end
	end)

	return function()
		return box.Text
	end
end

local function makeMultiDropdown(text, list, callback)
	local frame = create("Frame", {
		Parent = currentSectionContainer,
		Size = UDim2.new(1, -10, 0, 45),
		BackgroundColor3 = Theme.ElementBackground,
		BorderSizePixel = 0,
		ClipsDescendants = true
	})
	create("UICorner", {Parent = frame, CornerRadius = UDim.new(0, 6)})

	local selected = {}

	local label = create("TextLabel", {
		Parent = frame,
		Size = UDim2.new(1, -15, 0, 45),
		Position = UDim2.new(0, 15, 0, 0),
		BackgroundTransparency = 1,
		Text = text .. ": None ↓",
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local btn = create("TextButton", {
		Parent = frame,
		Size = UDim2.new(1, 0, 0, 45),
		BackgroundTransparency = 1,
		Text = ""
	})

	local container = create("Frame", {
		Parent = frame,
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.new(0, 0, 0, 45),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	})
	create("UIListLayout", {Parent = container})

	local open = false

	local function updateLabel()
		local t = {}
		for k,v in pairs(selected) do
			if v then table.insert(t, k) end
		end
		label.Text = text .. ": " .. (#t > 0 and table.concat(t, ", ") or "None") .. (open and " ↑" or " ↓")
	end

	btn.MouseButton1Click:Connect(function()
		open = not open
		applyTween(frame, {Size = UDim2.new(1, -10, 0, open and (45 + container.AbsoluteSize.Y) or 45)})
		updateLabel()
	end)

	for _,v in pairs(list) do
		selected[v] = false

		local opt = create("TextButton", {
			Parent = container,
			Size = UDim2.new(1, 0, 0, 30),
			BackgroundColor3 = Theme.ElementBackground,
			Text = v,
			TextColor3 = Theme.SecondaryText,
			Font = Enum.Font.Gotham,
			TextSize = 12
		})
		create("UICorner", {Parent = opt, CornerRadius = UDim.new(0,4)})

		local function updateVisual()
			if selected[v] then
				applyTween(opt, {BackgroundColor3 = Theme.ToggleOff}, 0.15)
			else
				applyTween(opt, {BackgroundColor3 = Theme.ElementBackground}, 0.15)
			end
		end

		opt.MouseButton1Click:Connect(function()
			selected[v] = not selected[v]
			updateVisual()
			if callback then
				callback(selected)
			end
			updateLabel()
		end)
	end

	return function()
		return selected
	end
end
