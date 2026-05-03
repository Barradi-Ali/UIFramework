local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- // THEME CONFIGURATION
local theme = {
	Main = Color3.fromRGB(25, 25, 25),
	Accent = Color3.fromRGB(0, 170, 255),
	TopBar = Color3.fromRGB(35, 35, 35),
	Sidebar = Color3.fromRGB(30, 30, 30),
	Section = Color3.fromRGB(40, 40, 40),
	Text = Color3.fromRGB(255, 255, 255),
	SubText = Color3.fromRGB(180, 180, 180),
	Placeholder = Color3.fromRGB(20, 20, 20)
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
	local toggleFrame = create("Frame", {Parent = gui, Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0.01, 0, 0.15, 0), BackgroundTransparency = 1})
	local toggleBtn = create("ImageButton", {Parent = toggleFrame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0, BackgroundColor3 = theme.TopBar, Image = ImageID})
	create("UICorner", {Parent = toggleBtn, CornerRadius = UDim.new(1, 0)})
	create("UIStroke", {Parent = toggleBtn, Color = theme.Accent, Thickness = 2})

	drag(toggleFrame)

	local main = create("Frame", {
		Parent = gui,
		Size = UDim2.new(0, 550, 0, 350),
		Position = UDim2.new(0.5, 0, 1.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Main,
		BorderSizePixel = 0,
		Visible = false,
		ClipsDescendants = true
	})

	create("UICorner", {Parent = main, CornerRadius = UDim.new(0, 12)})
	create("UIStroke", {Parent = main, Color = theme.Accent, Thickness = 1.5, Transparency = 0.5})

	local top = create("Frame", {Parent = main, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = theme.TopBar, BorderSizePixel = 0, ZIndex = 999})
	local title = create("TextLabel", {Parent = top, Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = Title, TextColor3 = theme.Text, Font = Enum.Font.FredokaOne, TextSize = 20, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 999})
	local closeBtn = create("TextButton", {Parent = top, Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(1, -40, 0, 0), Text = "×", BackgroundTransparency = 1, TextColor3 = theme.Text, Font = Enum.Font.GothamBold, TextSize = 28, ZIndex = 999})

	drag(main, top)

	local sidebar = create("Frame", {
		Parent = main,
		Size = UDim2.new(0, 130, 1, -40),
		Position = UDim2.new(0, 0, 0, 40),
		BackgroundColor3 = theme.Sidebar,
		BorderSizePixel = 0,
		Name = "Sidebar"
	})
	create("UIListLayout", {Parent = sidebar, Padding = UDim.new(0, 5), HorizontalAlignment = Enum.HorizontalAlignment.Center})
	create("UIPadding", {Parent = sidebar, PaddingTop = UDim.new(0, 10)})

	local open = false
	local OpenX, OpenY = 0, 0

	local function openUI() 
		open = true 
		main.Visible = true 
		applyTween(main, {Position = UDim2.new(0.5, OpenX, 0.5, OpenY)}, 0.4) 
	end

	local function closeUI() 
		open = false 
		OpenX, OpenY = main.Position.X.Offset, main.Position.Y.Offset
		applyTween(main, {Position = UDim2.new(0.5, OpenX, 1.5, OpenY)}, 0.4) 
		task.delay(0.4, function() if not open then main.Visible = false end end) 
	end

	toggleBtn.MouseButton1Click:Connect(function() if open then closeUI() else openUI() end end)
	closeBtn.MouseButton1Click:Connect(closeUI)

	return main
end

local mainUI = makeMain("UIFramework", "rbxassetid://85516224537304")
local sectionFrames = {} 
local currentSectionContainer = nil

local function makeSection(name)
	local sectionFrame = create("ScrollingFrame", {
		Parent = mainUI,
		Size = UDim2.new(1, -145, 1, -55),
		Position = UDim2.new(0, 140, 0, 45),
		BackgroundTransparency = 1,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = theme.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false
	})

	create("UIListLayout", {Parent = sectionFrame, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})
	create("UIPadding", {Parent = sectionFrame, PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 20), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 8)})

	table.insert(sectionFrames, sectionFrame)
	if #sectionFrames == 1 then sectionFrame.Visible = true end

	currentSectionContainer = sectionFrame

	local navBtn = create("TextButton", {
		Parent = mainUI.Sidebar,
		Size = UDim2.new(0.9, 0, 0, 35),
		BackgroundColor3 = theme.Section,
		Text = name,
		TextColor3 = theme.SubText,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		TextSize = 13
	})
	create("UICorner", {Parent = navBtn, CornerRadius = UDim.new(0, 6)})

	navBtn.MouseButton1Click:Connect(function()
		for i, frame in pairs(sectionFrames) do 
			frame.Visible = false 
			mainUI.Sidebar:GetChildren()[i+2].TextColor3 = theme.SubText 
		end
		sectionFrame.Visible = true
		navBtn.TextColor3 = theme.Accent
	end)

	if #sectionFrames == 1 then navBtn.TextColor3 = theme.Accent end
end

local function makeToggle(text, callback)
	local frame = create("Frame", {Parent = currentSectionContainer, Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = theme.Section})
	create("UICorner", {Parent = frame, CornerRadius = UDim.new(0, 6)})

	local label = create("TextLabel", {Parent = frame, Size = UDim2.new(0.7, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = theme.Text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})

	local switch = create("Frame", {Parent = frame, Size = UDim2.new(0, 36, 0, 20), Position = UDim2.new(1, -48, 0.5, -10), BackgroundColor3 = theme.Placeholder})
	create("UICorner", {Parent = switch, CornerRadius = UDim.new(1, 0)})

	local knob = create("Frame", {Parent = switch, Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = theme.Text})
	create("UICorner", {Parent = knob, CornerRadius = UDim.new(1, 0)})

	local state = false
	local function set(v)
		state = v
		applyTween(knob, {Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}, 0.2)
		applyTween(switch, {BackgroundColor3 = state and theme.Accent or theme.Placeholder}, 0.2)
		if callback then callback(state) end
	end

	frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then set(not state) end end)
	return set
end

local function makeSlider(text, min, max, default, callback)
	local frame = create("Frame", {Parent = currentSectionContainer, Size = UDim2.new(1, 0, 0, 55), BackgroundColor3 = theme.Section})
	create("UICorner", {Parent = frame, CornerRadius = UDim.new(0, 6)})

	local label = create("TextLabel", {Parent = frame, Size = UDim2.new(1, -25, 0, 25), Position = UDim2.new(0, 12, 0, 5), BackgroundTransparency = 1, Text = text .. ": " .. default, TextColor3 = theme.Text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})

	local sliderBack = create("Frame", {Parent = frame, Size = UDim2.new(1, -24, 0, 4), Position = UDim2.new(0, 12, 0, 40), BackgroundColor3 = theme.Placeholder})
	create("UICorner", {Parent = sliderBack, CornerRadius = UDim.new(1, 0)})

	local fill = create("Frame", {Parent = sliderBack, Size = UDim2.new((default - min) / (max - min), 0, 1, 0), BackgroundColor3 = theme.Accent})
	create("UICorner", {Parent = fill, CornerRadius = UDim.new(1, 0)})

	local knob = create("Frame", {Parent = fill, Size = UDim2.new(0, 12, 0, 12), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = theme.Text})
	create("UICorner", {Parent = knob, CornerRadius = UDim.new(1, 0)})

	local dragging = false
	local function update(input)
		local pos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
		local val = math.floor(min + (max - min) * pos)
		fill.Size = UDim2.new(pos, 0, 1, 0)
		label.Text = text .. ": " .. val
		callback(val)
	end

	knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
	UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
	UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end end)
end

local function makeButton(text, callback)
	local btn = create("TextButton", {Parent = currentSectionContainer, Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = theme.Section, Text = text, TextColor3 = theme.Text, Font = Enum.Font.GothamBold, TextSize = 13})
	create("UICorner", {Parent = btn, CornerRadius = UDim.new(0, 6)})
	create("UIStroke", {Parent = btn, Color = theme.Accent, Thickness = 0.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
	btn.MouseButton1Click:Connect(callback)
end

local function makeField(title, default, callback)
	local frame = create("Frame", {Parent = currentSectionContainer, Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = theme.Section})
	create("UICorner", {Parent = frame, CornerRadius = UDim.new(0, 6)})

	create("TextLabel", {Parent = frame, Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 5), BackgroundTransparency = 1, Text = title, TextColor3 = theme.SubText, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left})

	local box = create("TextBox", {Parent = frame, Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 25), BackgroundColor3 = theme.Placeholder, Text = default or "", TextColor3 = theme.Text, Font = Enum.Font.Gotham, TextSize = 13, ClearTextOnFocus = false})
	create("UICorner", {Parent = box, CornerRadius = UDim.new(0, 4)})

	box.FocusLost:Connect(function() if callback then callback(box.Text) end end)
end
