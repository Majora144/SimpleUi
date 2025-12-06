local Library = {}
Library.Flags = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local CoreGui = gethui and gethui() or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")

local Colors = {
	Background = Color3.fromRGB(18, 18, 22),
	TitleBar = Color3.fromRGB(25, 25, 32),
	Container = Color3.fromRGB(22, 22, 28),
	Element = Color3.fromRGB(32, 32, 40),
	ElementHover = Color3.fromRGB(42, 42, 52),
	Input = Color3.fromRGB(38, 38, 48),
	InputHover = Color3.fromRGB(48, 48, 60),
	SliderBar = Color3.fromRGB(48, 48, 58),
	SwitchOff = Color3.fromRGB(48, 48, 58),
	List = Color3.fromRGB(35, 35, 44),
	Option = Color3.fromRGB(42, 42, 52),
	Accent = Color3.fromRGB(88, 101, 242),
	Text = Color3.fromRGB(255, 255, 255),
	TextDark = Color3.fromRGB(180, 180, 190),
	TextDarker = Color3.fromRGB(150, 150, 160),
}

local Config = {
	WindowSize = UDim2.new(0, 350, 0, 420),
	AnimSpeed = 0.15,
	Font = Enum.Font.GothamMedium,
	FontBold = Enum.Font.GothamBold,
}

local function tween(obj, time, props)
	TweenService
		:Create(obj, TweenInfo.new(time or Config.AnimSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
		:Play()
end

local function corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 6)
	c.Parent = parent
	return c
end

local function stroke(parent, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or Colors.Accent
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0.5
	s.Parent = parent
	return s
end

local function padding(parent, t, b, l, r)
	local p = Instance.new("UIPadding")
	p.PaddingTop = UDim.new(0, t or 10)
	p.PaddingBottom = UDim.new(0, b or 10)
	p.PaddingLeft = UDim.new(0, l or 10)
	p.PaddingRight = UDim.new(0, r or 10)
	p.Parent = parent
	return p
end

local function listLayout(parent, dir, pad)
	local l = Instance.new("UIListLayout")
	l.SortOrder = Enum.SortOrder.LayoutOrder
	l.FillDirection = dir or Enum.FillDirection.Vertical
	l.Padding = UDim.new(0, pad or 8)
	l.Parent = parent
	return l
end

function Library:CreateWindow(config)
	local Window = {}
	local connections = {}

	if CoreGui:FindFirstChild("UILibrary") then
		CoreGui:FindFirstChild("UILibrary"):Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "UILibrary"
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false

	local MainWindow = Instance.new("Frame")
	MainWindow.Name = "MainWindow"
	MainWindow.Parent = ScreenGui
	MainWindow.BackgroundColor3 = Colors.Background
	MainWindow.BorderSizePixel = 0
	MainWindow.ClipsDescendants = true
	MainWindow.Position = UDim2.new(0.5, -175, 0.5, -210)
	MainWindow.Size = UDim2.new(0, 350, 0, 0)
	MainWindow.BackgroundTransparency = 1
	corner(MainWindow, 10)

	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Parent = MainWindow
	TitleBar.BackgroundColor3 = Colors.TitleBar
	TitleBar.BorderSizePixel = 0
	TitleBar.Size = UDim2.new(1, 0, 0, 36)
	TitleBar.ClipsDescendants = true
	corner(TitleBar, 10)

	local TitleCornerCover = Instance.new("Frame")
	TitleCornerCover.Parent = TitleBar
	TitleCornerCover.BackgroundColor3 = Colors.TitleBar
	TitleCornerCover.BorderSizePixel = 0
	TitleCornerCover.Position = UDim2.new(0, 0, 1, -10)
	TitleCornerCover.Size = UDim2.new(1, 0, 0, 10)

	local Title = Instance.new("TextLabel")
	Title.Parent = TitleBar
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.Size = UDim2.new(1, -30, 1, 0)
	Title.Font = Config.FontBold
	Title.Text = config.Title or "Window"
	Title.TextColor3 = Colors.Text
	Title.TextSize = 16
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local TabHolder = Instance.new("Frame")
	TabHolder.Parent = MainWindow
	TabHolder.BackgroundTransparency = 1
	TabHolder.Position = UDim2.new(0, 10, 0, 44)
	TabHolder.Size = UDim2.new(1, -20, 0, 32)
	listLayout(TabHolder, Enum.FillDirection.Horizontal, 6)

	local Container = Instance.new("Frame")
	Container.Parent = MainWindow
	Container.BackgroundColor3 = Colors.Container
	Container.BorderSizePixel = 0
	Container.ClipsDescendants = true
	Container.Position = UDim2.new(0, 10, 0, 82)
	Container.Size = UDim2.new(1, -20, 1, -90)
	corner(Container)
	padding(Container)

	local toggleKey = config.Keybind or Enum.KeyCode.RightShift
	table.insert(
		connections,
		UserInputService.InputBegan:Connect(function(input, processed)
			if processed then
				return
			end
			if input.KeyCode == toggleKey then
				ScreenGui.Enabled = not ScreenGui.Enabled
			end
		end)
	)

	local dragging, dragStart, startPos

	table.insert(
		connections,
		TitleBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = input.Position
				startPos = MainWindow.Position
			end
		end)
	)

	table.insert(
		connections,
		TitleBar.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)
	)

	table.insert(
		connections,
		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = input.Position - dragStart
				MainWindow.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end
		end)
	)

	Window.ScreenGui = ScreenGui
	Window.MainWindow = MainWindow
	Window.TabHolder = TabHolder
	Window.Container = Container
	Window.Tabs = {}

	function Window:CreateTab(name)
		local Tab = {}

		local TabButton = Instance.new("TextButton")
		TabButton.Name = name
		TabButton.Parent = TabHolder
		TabButton.BackgroundColor3 = Colors.Element
		TabButton.BorderSizePixel = 0
		TabButton.AutoButtonColor = false
		TabButton.Font = Config.Font
		TabButton.Text = name
		TabButton.TextColor3 = Colors.TextDark
		TabButton.TextSize = 13
		corner(TabButton)

		local tabChildren = TabHolder:GetChildren()
		local tabCount = 0
		for _, c in tabChildren do
		    if c:IsA("TextButton") then tabCount = tabCount + 1 end
		end
		for _, c in tabChildren do
		    if c:IsA("TextButton") then
		        c.Size = UDim2.new(1 / tabCount, 0, 1, 0)
		    end
		end
			
		TabButton.MouseEnter:Connect(function()
			if not Tab.Active then
				tween(TabButton, nil, { BackgroundColor3 = Colors.ElementHover })
			end
		end)

		TabButton.MouseLeave:Connect(function()
			if not Tab.Active then
				tween(TabButton, nil, { BackgroundColor3 = Colors.Element })
			end
		end)

		local Page = Instance.new("ScrollingFrame")
		Page.Name = name .. "Page"
		Page.Parent = Container
		Page.Active = true
		Page.BackgroundTransparency = 1
		Page.BorderSizePixel = 0
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		Page.ScrollBarThickness = 0
		Page.ScrollingDirection = Enum.ScrollingDirection.Y
		Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		Page.Visible = false
		listLayout(Page)

		if #Window.Tabs == 0 then
			Page.Visible = true
			TabButton.BackgroundColor3 = Colors.Accent
			TabButton.TextColor3 = Colors.Text
		end

		TabButton.MouseButton1Click:Connect(function()
			for _, tab in pairs(Window.Tabs) do
				tab.Page.Visible = false
				tab.Active = false
				tween(tab.Button, nil, { BackgroundColor3 = Colors.Element, TextColor3 = Colors.TextDark })
			end
			Page.Visible = true
			Tab.Active = true
			tween(TabButton, nil, { BackgroundColor3 = Colors.Accent, TextColor3 = Colors.Text })
		end)

		Tab.Button = TabButton
		Tab.Page = Page
		Tab.LayoutOrder = 0
		Tab.Active = (#Window.Tabs == 0)

		table.insert(Window.Tabs, Tab)

		function Tab:CreateButton(cfg)
			Tab.LayoutOrder = Tab.LayoutOrder + 1

			local Button = Instance.new("TextButton")
			Button.Name = cfg.Name or "Button"
			Button.Parent = Page
			Button.BackgroundColor3 = Colors.Element
			Button.BorderSizePixel = 0
			Button.Size = UDim2.new(1, 0, 0, 36)
			Button.AutoButtonColor = false
			Button.Font = Config.Font
			Button.Text = cfg.Name or "Button"
			Button.TextColor3 = Colors.Text
			Button.TextSize = 14
			Button.LayoutOrder = Tab.LayoutOrder
			corner(Button)

			Button.MouseEnter:Connect(function()
				tween(Button, nil, { BackgroundColor3 = Colors.ElementHover })
			end)

			Button.MouseLeave:Connect(function()
				tween(Button, nil, { BackgroundColor3 = Colors.Element })
			end)

			Button.MouseButton1Click:Connect(function()
				tween(Button, 0.1, { BackgroundColor3 = Colors.Accent })
				task.spawn(function()
					task.wait(0.1)
					tween(Button, 0.1, { BackgroundColor3 = Colors.ElementHover })
				end)
				if cfg.Callback then
					cfg.Callback()
				end
			end)

			return Button
		end

		function Tab:CreateToggle(cfg)
			Tab.LayoutOrder = Tab.LayoutOrder + 1

			local enabled = cfg.Default or false
			local toggling = false

			local Toggle = Instance.new("Frame")
			Toggle.Name = cfg.Name or "Toggle"
			Toggle.Parent = Page
			Toggle.BackgroundColor3 = Colors.Element
			Toggle.BorderSizePixel = 0
			Toggle.Size = UDim2.new(1, 0, 0, 38)
			Toggle.LayoutOrder = Tab.LayoutOrder
			corner(Toggle)

			local Label = Instance.new("TextLabel")
			Label.Parent = Toggle
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.Size = UDim2.new(0.7, 0, 1, 0)
			Label.Font = Config.Font
			Label.Text = cfg.Name or "Toggle"
			Label.TextColor3 = Colors.Text
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left

			local Switch = Instance.new("TextButton")
			Switch.Parent = Toggle
			Switch.BackgroundColor3 = enabled and Colors.Accent or Colors.SwitchOff
			Switch.BorderSizePixel = 0
			Switch.Position = UDim2.new(1, -54, 0.5, -11)
			Switch.Size = UDim2.new(0, 44, 0, 22)
			Switch.AutoButtonColor = false
			Switch.Text = ""
			corner(Switch, 11)

			local Circle = Instance.new("Frame")
			Circle.Parent = Switch
			Circle.BackgroundColor3 = Colors.Text
			Circle.BorderSizePixel = 0
			Circle.AnchorPoint = Vector2.new(0, 0.5)
			Circle.Position = enabled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 4, 0.5, 0)
			Circle.Size = UDim2.new(0, 14, 0, 14)
			corner(Circle, 7)

			if cfg.Flag then
				Library.Flags[cfg.Flag] = enabled
			end

			local function doToggle()
				if toggling then
					return
				end
				toggling = true
				enabled = not enabled
				if cfg.Flag then
					Library.Flags[cfg.Flag] = enabled
				end
				tween(Switch, 0.25, { BackgroundColor3 = enabled and Colors.Accent or Colors.SwitchOff })
				tween(Circle, 0.25, { Position = enabled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 4, 0.5, 0) })
				if cfg.Callback then
					cfg.Callback(enabled)
				end
				task.wait(0.25)
				toggling = false
			end

			Switch.MouseButton1Click:Connect(doToggle)

			local ToggleObject = { Frame = Toggle }
			function ToggleObject:Set(value)
				if enabled ~= value then
					doToggle()
				end
			end
			return ToggleObject
		end

		function Tab:CreateSlider(cfg)
			Tab.LayoutOrder = Tab.LayoutOrder + 1

			local min = cfg.Min or 0
			local max = cfg.Max or 100
			local default = cfg.Default or min
			local step = cfg.Step or 1
			local value = default
			local dragging = false

			local function formatValue(v)
				if step < 1 then
					return string.format("%." .. math.ceil(-math.log10(step)) .. "f", v)
				end
				return tostring(v)
			end

			local Slider = Instance.new("Frame")
			Slider.Name = cfg.Name or "Slider"
			Slider.Parent = Page
			Slider.BackgroundColor3 = Colors.Element
			Slider.BorderSizePixel = 0
			Slider.Size = UDim2.new(1, 0, 0, 55)
			Slider.LayoutOrder = Tab.LayoutOrder
			corner(Slider)

			local Label = Instance.new("TextLabel")
			Label.Parent = Slider
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 12, 0, 5)
			Label.Size = UDim2.new(0.5, 0, 0, 20)
			Label.Font = Config.Font
			Label.Text = cfg.Name or "Slider"
			Label.TextColor3 = Colors.Text
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left

			local Value = Instance.new("TextLabel")
			Value.Parent = Slider
			Value.BackgroundTransparency = 1
			Value.Position = UDim2.new(1, -52, 0, 3)
			Value.Size = UDim2.new(0, 40, 0, 20)
			Value.Font = Config.Font
			Value.Text = formatValue(default)
			Value.TextColor3 = Colors.Text
			Value.TextSize = 14
			Value.TextXAlignment = Enum.TextXAlignment.Right

			local Min = Instance.new("TextLabel")
			Min.Parent = Slider
			Min.BackgroundTransparency = 1
			Min.Position = UDim2.new(0, 12, 0, 28)
			Min.Size = UDim2.new(0, 20, 0, 14)
			Min.Font = Config.Font
			Min.Text = tostring(min)
			Min.TextColor3 = Colors.TextDarker
			Min.TextSize = 12
			Min.TextXAlignment = Enum.TextXAlignment.Left

			local Max = Instance.new("TextLabel")
			Max.Parent = Slider
			Max.BackgroundTransparency = 1
			Max.Position = UDim2.new(1, -42, 0, 28)
			Max.Size = UDim2.new(0, 30, 0, 14)
			Max.Font = Config.Font
			Max.Text = tostring(max)
			Max.TextColor3 = Colors.TextDarker
			Max.TextSize = 12
			Max.TextXAlignment = Enum.TextXAlignment.Right

			local SliderBar = Instance.new("Frame")
			SliderBar.Parent = Slider
			SliderBar.BackgroundColor3 = Colors.SliderBar
			SliderBar.BorderSizePixel = 0
			SliderBar.Position = UDim2.new(0, 12, 0, 42)
			SliderBar.Size = UDim2.new(1, -24, 0, 6)
			corner(SliderBar, 3)

			local Fill = Instance.new("Frame")
			Fill.Parent = SliderBar
			Fill.BackgroundColor3 = Colors.Accent
			Fill.BorderSizePixel = 0
			Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			corner(Fill, 3)

			local Knob = Instance.new("Frame")
			Knob.Parent = SliderBar
			Knob.AnchorPoint = Vector2.new(0.5, 0.5)
			Knob.BackgroundColor3 = Colors.Text
			Knob.BorderSizePixel = 0
			Knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
			Knob.Size = UDim2.new(0, 16, 0, 16)
			Knob.BackgroundTransparency = 1
			corner(Knob, 8)

			local ValuePopup = Instance.new("TextLabel")
			ValuePopup.Parent = Knob
			ValuePopup.AnchorPoint = Vector2.new(0.5, 1)
			ValuePopup.BackgroundColor3 = Colors.Container
			ValuePopup.BorderSizePixel = 0
			ValuePopup.Position = UDim2.new(0.5, 0, 0, -5)
			ValuePopup.Size = UDim2.new(0, 30, 0, 20)
			ValuePopup.Visible = false
			ValuePopup.Font = Config.Font
			ValuePopup.Text = formatValue(default)
			ValuePopup.TextColor3 = Colors.Text
			ValuePopup.TextSize = 12
			corner(ValuePopup, 4)

			if cfg.Flag then
				Library.Flags[cfg.Flag] = value
			end

			local function update(input)
				local percent =
					math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
				value = min + (max - min) * percent
				value = math.floor(value / step + 0.5) * step
				value = math.clamp(value, min, max)
				if step < 1 then
					value = tonumber(string.format("%." .. math.ceil(-math.log10(step)) .. "f", value))
				end
				Knob.Position = UDim2.new(percent, 0, 0.5, 0)
				Fill.Size = UDim2.new(percent, 0, 1, 0)
				Value.Text = formatValue(value)
				ValuePopup.Text = formatValue(value)
				if cfg.Flag then
					Library.Flags[cfg.Flag] = value
				end
				if cfg.Callback then
					cfg.Callback(value)
				end
			end

			SliderBar.MouseEnter:Connect(function()
				tween(Knob, nil, { BackgroundTransparency = 0 })
			end)

			SliderBar.MouseLeave:Connect(function()
				if not dragging then
					tween(Knob, nil, { BackgroundTransparency = 1 })
				end
			end)

			SliderBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					ValuePopup.Visible = true
					update(input)
				end
			end)

			table.insert(
				connections,
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
						dragging = false
						ValuePopup.Visible = false
						tween(Knob, nil, { BackgroundTransparency = 1 })
					end
				end)
			)

			table.insert(
				connections,
				UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						update(input)
					end
				end)
			)

			local SliderObject = { Frame = Slider }
			function SliderObject:Set(newValue)
				newValue = math.clamp(newValue, min, max)
				newValue = math.floor(newValue / step + 0.5) * step
				if step < 1 then
					newValue = tonumber(string.format("%." .. math.ceil(-math.log10(step)) .. "f", newValue))
				end
				value = newValue
				local percent = (value - min) / (max - min)
				Knob.Position = UDim2.new(percent, 0, 0.5, 0)
				Fill.Size = UDim2.new(percent, 0, 1, 0)
				Value.Text = formatValue(value)
				ValuePopup.Text = formatValue(value)
				if cfg.Flag then
					Library.Flags[cfg.Flag] = value
				end
				if cfg.Callback then
					cfg.Callback(value)
				end
			end
			return SliderObject
		end

		function Tab:CreateInput(cfg)
			Tab.LayoutOrder = Tab.LayoutOrder + 1

			local Input = Instance.new("Frame")
			Input.Name = cfg.Name or "Input"
			Input.Parent = Page
			Input.BackgroundColor3 = Colors.Element
			Input.BorderSizePixel = 0
			Input.Size = UDim2.new(1, 0, 0, 38)
			Input.LayoutOrder = Tab.LayoutOrder
			corner(Input)

			local Label = Instance.new("TextLabel")
			Label.Parent = Input
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.Size = UDim2.new(0.5, 0, 1, 0)
			Label.Font = Config.Font
			Label.Text = cfg.Name or "Input"
			Label.TextColor3 = Colors.Text
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left

			local TextBox = Instance.new("TextBox")
			TextBox.Parent = Input
			TextBox.AnchorPoint = Vector2.new(0, 0.5)
			TextBox.BackgroundColor3 = Colors.Input
			TextBox.BorderSizePixel = 0
			TextBox.Position = UDim2.new(0.55, 0, 0.5, 0)
			TextBox.Size = UDim2.new(0.45, -12, 0, 26)
			TextBox.ClearTextOnFocus = false
			TextBox.Font = Config.Font
			TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
			TextBox.PlaceholderText = cfg.Placeholder or "Enter text..."
			TextBox.Text = cfg.Default or ""
			TextBox.TextColor3 = Colors.Text
			TextBox.TextSize = 14
			corner(TextBox, 4)

			if cfg.Flag then
				Library.Flags[cfg.Flag] = cfg.Default or ""
			end

			TextBox.Focused:Connect(function()
				tween(TextBox, nil, { BackgroundColor3 = Colors.InputHover })
			end)

			TextBox.FocusLost:Connect(function()
				tween(TextBox, nil, { BackgroundColor3 = Colors.Input })
				if cfg.Flag then
					Library.Flags[cfg.Flag] = TextBox.Text
				end
				if cfg.Callback then
					cfg.Callback(TextBox.Text)
				end
			end)

			local InputObject = { Frame = Input }
			function InputObject:Set(text)
				TextBox.Text = text
				if cfg.Flag then
					Library.Flags[cfg.Flag] = text
				end
				if cfg.Callback then
					cfg.Callback(text)
				end
			end
			return InputObject
		end

		function Tab:CreateDropdown(cfg)
			Tab.LayoutOrder = Tab.LayoutOrder + 1

			local options = cfg.Options or {}
			local selected = cfg.Default or options[1] or ""
			local open = false

			local Dropdown = Instance.new("Frame")
			Dropdown.Name = cfg.Name or "Dropdown"
			Dropdown.Parent = Page
			Dropdown.BackgroundColor3 = Colors.Element
			Dropdown.BorderSizePixel = 0
			Dropdown.Size = UDim2.new(1, 0, 0, 38)
			Dropdown.ClipsDescendants = true
			Dropdown.LayoutOrder = Tab.LayoutOrder
			corner(Dropdown)

			local Label = Instance.new("TextLabel")
			Label.Parent = Dropdown
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.Size = UDim2.new(0.5, 0, 0, 38)
			Label.Font = Config.Font
			Label.Text = cfg.Name or "Dropdown"
			Label.TextColor3 = Colors.Text
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left

			local Selected = Instance.new("TextButton")
			Selected.Parent = Dropdown
			Selected.AnchorPoint = Vector2.new(0, 0.5)
			Selected.BackgroundColor3 = Colors.Input
			Selected.BorderSizePixel = 0
			Selected.Position = UDim2.new(0.55, 0, 0, 19)
			Selected.Size = UDim2.new(0.45, -12, 0, 26)
			Selected.AutoButtonColor = false
			Selected.Font = Config.Font
			Selected.Text = selected .. " ▼"
			Selected.TextColor3 = Colors.TextDark
			Selected.TextSize = 12
			corner(Selected, 4)

			local List = Instance.new("Frame")
			List.Parent = Dropdown
			List.BackgroundColor3 = Colors.List
			List.BorderSizePixel = 0
			List.Position = UDim2.new(0.55, 0, 0, 45)
			List.Size = UDim2.new(0.45, -12, 0, #options * 28 + 8)
			corner(List, 4)
			padding(List, 4, 4, 0, 0)
			listLayout(List, Enum.FillDirection.Vertical, 2)

			if cfg.Flag then
				Library.Flags[cfg.Flag] = selected
			end

			for i, option in ipairs(options) do
				local Option = Instance.new("TextButton")
				Option.Name = option
				Option.Parent = List
				Option.BackgroundColor3 = Colors.Option
				Option.BackgroundTransparency = 1
				Option.BorderSizePixel = 0
				Option.Size = UDim2.new(1, 0, 0, 26)
				Option.AutoButtonColor = false
				Option.Font = Config.Font
				Option.Text = option
				Option.TextColor3 = Colors.TextDark
				Option.TextSize = 12
				Option.LayoutOrder = i
				corner(Option, 4)

				Option.MouseEnter:Connect(function()
					tween(Option, nil, { BackgroundTransparency = 0 })
				end)

				Option.MouseLeave:Connect(function()
					tween(Option, nil, { BackgroundTransparency = 1 })
				end)

				Option.MouseButton1Click:Connect(function()
					selected = option
					Selected.Text = selected .. " ▼"
					if cfg.Flag then
						Library.Flags[cfg.Flag] = selected
					end
					if cfg.Callback then
						cfg.Callback(selected)
					end
					open = false
					tween(Dropdown, 0.2, { Size = UDim2.new(1, 0, 0, 38) })
				end)
			end

			Selected.MouseButton1Click:Connect(function()
				open = not open
				local targetSize = open and UDim2.new(1, 0, 0, 38 + #options * 28 + 16) or UDim2.new(1, 0, 0, 38)
				tween(Dropdown, 0.2, { Size = targetSize })
			end)

			Selected.MouseEnter:Connect(function()
				tween(Selected, nil, { BackgroundColor3 = Colors.InputHover })
			end)

			Selected.MouseLeave:Connect(function()
				tween(Selected, nil, { BackgroundColor3 = Colors.Input })
			end)

			local DropdownObject = { Frame = Dropdown }
			function DropdownObject:Set(option)
				if table.find(options, option) then
					selected = option
					Selected.Text = selected .. " ▼"
					if cfg.Flag then
						Library.Flags[cfg.Flag] = selected
					end
					if cfg.Callback then
						cfg.Callback(selected)
					end
				end
			end
			return DropdownObject
		end

		function Tab:CreateMultiDropdown(cfg)
			Tab.LayoutOrder = Tab.LayoutOrder + 1

			local options = cfg.Options or {}
			local selected = cfg.Default or {}
			local open = false

			local function getDisplayText()
				if #selected == 0 then
					return "None ▼"
				elseif #selected == 1 then
					return selected[1] .. " ▼"
				else
					return #selected .. " selected ▼"
				end
			end

			local function isSelected(option)
				for _, v in ipairs(selected) do
					if v == option then
						return true
					end
				end
				return false
			end

			local Dropdown = Instance.new("Frame")
			Dropdown.Name = cfg.Name or "MultiDropdown"
			Dropdown.Parent = Page
			Dropdown.BackgroundColor3 = Colors.Element
			Dropdown.BorderSizePixel = 0
			Dropdown.Size = UDim2.new(1, 0, 0, 38)
			Dropdown.ClipsDescendants = true
			Dropdown.LayoutOrder = Tab.LayoutOrder
			corner(Dropdown)

			local Label = Instance.new("TextLabel")
			Label.Parent = Dropdown
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.Size = UDim2.new(0.5, 0, 0, 38)
			Label.Font = Config.Font
			Label.Text = cfg.Name or "MultiDropdown"
			Label.TextColor3 = Colors.Text
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left

			local Selected = Instance.new("TextButton")
			Selected.Parent = Dropdown
			Selected.AnchorPoint = Vector2.new(0, 0.5)
			Selected.BackgroundColor3 = Colors.Input
			Selected.BorderSizePixel = 0
			Selected.Position = UDim2.new(0.55, 0, 0, 19)
			Selected.Size = UDim2.new(0.45, -12, 0, 26)
			Selected.AutoButtonColor = false
			Selected.Font = Config.Font
			Selected.Text = getDisplayText()
			Selected.TextColor3 = Colors.TextDark
			Selected.TextSize = 12
			corner(Selected, 4)

			local List = Instance.new("Frame")
			List.Parent = Dropdown
			List.BackgroundColor3 = Colors.List
			List.BorderSizePixel = 0
			List.Position = UDim2.new(0.55, 0, 0, 45)
			List.Size = UDim2.new(0.45, -12, 0, #options * 28 + 8)
			corner(List, 4)
			padding(List, 4, 4, 0, 0)
			listLayout(List, Enum.FillDirection.Vertical, 2)

			if cfg.Flag then
				Library.Flags[cfg.Flag] = selected
			end

			local function toggleOption(option)
				if isSelected(option) then
					for i, v in ipairs(selected) do
						if v == option then
							table.remove(selected, i)
							break
						end
					end
				else
					table.insert(selected, option)
				end
				Selected.Text = getDisplayText()
				if cfg.Flag then
					Library.Flags[cfg.Flag] = selected
				end
				if cfg.Callback then
					cfg.Callback(selected)
				end
			end

			for i, option in ipairs(options) do
				local Option = Instance.new("TextButton")
				Option.Name = option
				Option.Parent = List
				Option.BackgroundColor3 = Colors.Option
				Option.BackgroundTransparency = isSelected(option) and 0 or 1
				Option.BorderSizePixel = 0
				Option.Size = UDim2.new(1, 0, 0, 26)
				Option.AutoButtonColor = false
				Option.Font = Config.Font
				Option.Text = option
				Option.TextColor3 = isSelected(option) and Colors.Text or Colors.TextDark
				Option.TextSize = 12
				Option.LayoutOrder = i
				corner(Option, 4)

				Option.MouseEnter:Connect(function()
					if not isSelected(option) then
						tween(Option, nil, { BackgroundTransparency = 0.5 })
					end
				end)

				Option.MouseLeave:Connect(function()
					if not isSelected(option) then
						tween(Option, nil, { BackgroundTransparency = 1 })
					end
				end)

				Option.MouseButton1Click:Connect(function()
					toggleOption(option)
					if isSelected(option) then
						tween(Option, nil, { BackgroundTransparency = 0, TextColor3 = Colors.Text })
					else
						tween(Option, nil, { BackgroundTransparency = 1, TextColor3 = Colors.TextDark })
					end
				end)
			end

			Selected.MouseButton1Click:Connect(function()
				open = not open
				local targetSize = open and UDim2.new(1, 0, 0, 38 + #options * 28 + 16) or UDim2.new(1, 0, 0, 38)
				tween(Dropdown, 0.2, { Size = targetSize })
			end)

			Selected.MouseEnter:Connect(function()
				tween(Selected, nil, { BackgroundColor3 = Colors.InputHover })
			end)

			Selected.MouseLeave:Connect(function()
				tween(Selected, nil, { BackgroundColor3 = Colors.Input })
			end)

			local DropdownObject = { Frame = Dropdown }
			function DropdownObject:Set(newSelected)
				selected = newSelected
				Selected.Text = getDisplayText()
				for _, child in ipairs(List:GetChildren()) do
					if child:IsA("TextButton") then
						if isSelected(child.Name) then
							child.BackgroundTransparency = 0
							child.TextColor3 = Colors.Text
						else
							child.BackgroundTransparency = 1
							child.TextColor3 = Colors.TextDark
						end
					end
				end
				if cfg.Flag then
					Library.Flags[cfg.Flag] = selected
				end
				if cfg.Callback then
					cfg.Callback(selected)
				end
			end
			return DropdownObject
		end

		function Tab:CreateKeybind(cfg)
			Tab.LayoutOrder = Tab.LayoutOrder + 1

			local key = cfg.Default or Enum.KeyCode.E
			local listening = false

			local Keybind = Instance.new("Frame")
			Keybind.Name = cfg.Name or "Keybind"
			Keybind.Parent = Page
			Keybind.BackgroundColor3 = Colors.Element
			Keybind.BorderSizePixel = 0
			Keybind.Size = UDim2.new(1, 0, 0, 38)
			Keybind.LayoutOrder = Tab.LayoutOrder
			corner(Keybind)

			local Label = Instance.new("TextLabel")
			Label.Parent = Keybind
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.Size = UDim2.new(0.6, 0, 1, 0)
			Label.Font = Config.Font
			Label.Text = cfg.Name or "Keybind"
			Label.TextColor3 = Colors.Text
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left

			local Key = Instance.new("TextButton")
			Key.Parent = Keybind
			Key.AnchorPoint = Vector2.new(0, 0.5)
			Key.BackgroundColor3 = Colors.Input
			Key.BorderSizePixel = 0
			Key.Position = UDim2.new(1, -62, 0.5, 0)
			Key.Size = UDim2.new(0, 50, 0, 26)
			Key.AutoButtonColor = false
			Key.Font = Config.Font
			Key.Text = key.Name
			Key.TextColor3 = Colors.TextDark
			Key.TextSize = 14
			corner(Key, 4)

			if cfg.Flag then
				Library.Flags[cfg.Flag] = key
			end

			Key.MouseButton1Click:Connect(function()
				if listening then
					return
				end
				listening = true
				Key.Text = "..."
				tween(Key, nil, { BackgroundColor3 = Colors.Accent })
			end)

			table.insert(
				connections,
				UserInputService.InputBegan:Connect(function(input, processed)
					if listening then
						if input.UserInputType == Enum.UserInputType.Keyboard then
							key = input.KeyCode
							Key.Text = key.Name
							if cfg.Flag then
								Library.Flags[cfg.Flag] = key
							end
							listening = false
							tween(Key, nil, { BackgroundColor3 = Colors.Input })
						end
					else
						if not processed and input.KeyCode == key then
							if cfg.Callback then
								cfg.Callback()
							end
						end
					end
				end)
			)

			Key.MouseEnter:Connect(function()
				if not listening then
					tween(Key, nil, { BackgroundColor3 = Colors.InputHover })
				end
			end)

			Key.MouseLeave:Connect(function()
				if not listening then
					tween(Key, nil, { BackgroundColor3 = Colors.Input })
				end
			end)

			local KeybindObject = { Frame = Keybind }
			function KeybindObject:Set(newKey)
				key = newKey
				Key.Text = key.Name
				if cfg.Flag then
					Library.Flags[cfg.Flag] = key
				end
			end
			return KeybindObject
		end

		function Tab:CreateColorPicker(cfg)
			Tab.LayoutOrder = Tab.LayoutOrder + 1

			local color = cfg.Default or Color3.fromRGB(255, 0, 0)
			local hue, sat, val = Color3.toHSV(color)
			local open = false
			local draggingGradient = false
			local draggingHue = false

			local ColorPicker = Instance.new("Frame")
			ColorPicker.Name = cfg.Name or "ColorPicker"
			ColorPicker.Parent = Page
			ColorPicker.BackgroundColor3 = Colors.Element
			ColorPicker.BorderSizePixel = 0
			ColorPicker.Size = UDim2.new(1, 0, 0, 38)
			ColorPicker.ClipsDescendants = true
			ColorPicker.LayoutOrder = Tab.LayoutOrder
			corner(ColorPicker)

			local Label = Instance.new("TextLabel")
			Label.Parent = ColorPicker
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.Size = UDim2.new(0.5, 0, 0, 38)
			Label.Font = Config.Font
			Label.Text = cfg.Name or "Color"
			Label.TextColor3 = Colors.Text
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left

			local Preview = Instance.new("TextButton")
			Preview.Parent = ColorPicker
			Preview.BackgroundColor3 = color
			Preview.BorderSizePixel = 0
			Preview.Position = UDim2.new(1, -38, 0, 6)
			Preview.Size = UDim2.new(0, 26, 0, 26)
			Preview.AutoButtonColor = false
			Preview.Text = ""
			corner(Preview)

			local Gradient = Instance.new("TextButton")
			Gradient.Parent = ColorPicker
			Gradient.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
			Gradient.BorderSizePixel = 0
			Gradient.Position = UDim2.new(0, 12, 0, 45)
			Gradient.Size = UDim2.new(1, -24, 0, 65)
			Gradient.AutoButtonColor = false
			Gradient.Text = ""
			corner(Gradient, 4)

			local SaturationOverlay = Instance.new("Frame")
			SaturationOverlay.Parent = Gradient
			SaturationOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SaturationOverlay.BorderSizePixel = 0
			SaturationOverlay.Size = UDim2.new(1, 0, 1, 0)
			corner(SaturationOverlay, 4)

			local SaturationGradient = Instance.new("UIGradient")
			SaturationGradient.Transparency =
				NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
			SaturationGradient.Parent = SaturationOverlay

			local ValueOverlay = Instance.new("Frame")
			ValueOverlay.Parent = Gradient
			ValueOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			ValueOverlay.BorderSizePixel = 0
			ValueOverlay.Size = UDim2.new(1, 0, 1, 0)
			ValueOverlay.ZIndex = 2
			corner(ValueOverlay, 4)

			local ValueGradient = Instance.new("UIGradient")
			ValueGradient.Rotation = 90
			ValueGradient.Transparency =
				NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })
			ValueGradient.Parent = ValueOverlay

			local Cursor = Instance.new("Frame")
			Cursor.Parent = Gradient
			Cursor.AnchorPoint = Vector2.new(0.5, 0.5)
			Cursor.BackgroundColor3 = Colors.Text
			Cursor.BorderSizePixel = 0
			Cursor.Position = UDim2.new(sat, 0, 1 - val, 0)
			Cursor.Size = UDim2.new(0, 12, 0, 12)
			Cursor.ZIndex = 3
			corner(Cursor, 6)
			stroke(Cursor, Color3.fromRGB(0, 0, 0), 1, 0)

			local HueSlider = Instance.new("Frame")
			HueSlider.Parent = ColorPicker
			HueSlider.BackgroundColor3 = Colors.Text
			HueSlider.BorderSizePixel = 0
			HueSlider.Position = UDim2.new(0, 12, 0, 116)
			HueSlider.Size = UDim2.new(1, -24, 0, 14)
			corner(HueSlider, 4)

			local HueGradient = Instance.new("UIGradient")
			HueGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
				ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
				ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
				ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
				ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
			})
			HueGradient.Parent = HueSlider

			local HueCursor = Instance.new("Frame")
			HueCursor.Parent = HueSlider
			HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
			HueCursor.BackgroundColor3 = Colors.Text
			HueCursor.BorderSizePixel = 0
			HueCursor.Position = UDim2.new(hue, 0, 0.5, 0)
			HueCursor.Size = UDim2.new(0, 6, 0, 18)
			corner(HueCursor, 2)
			stroke(HueCursor, Color3.fromRGB(0, 0, 0), 1, 0)

			if cfg.Flag then
				Library.Flags[cfg.Flag] = color
			end

			local function updateColor(fireCallback)
				color = Color3.fromHSV(hue, sat, val)
				Preview.BackgroundColor3 = color
				Gradient.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
				if cfg.Flag then
					Library.Flags[cfg.Flag] = color
				end
				if fireCallback and cfg.Callback then
					cfg.Callback(color)
				end
			end

			Gradient.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					draggingGradient = true
				end
			end)

			HueSlider.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					draggingHue = true
					local x =
						math.clamp((input.Position.X - HueSlider.AbsolutePosition.X) / HueSlider.AbsoluteSize.X, 0, 1)
					hue = x
					HueCursor.Position = UDim2.new(x, 0, 0.5, 0)
					updateColor(false)
				end
			end)

			table.insert(
				connections,
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if draggingGradient or draggingHue then
							updateColor(true)
						end
						draggingGradient = false
						draggingHue = false
					end
				end)
			)

			table.insert(
				connections,
				UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement then
						if draggingGradient then
							local x = math.clamp(
								(input.Position.X - Gradient.AbsolutePosition.X) / Gradient.AbsoluteSize.X,
								0,
								1
							)
							local y = math.clamp(
								(input.Position.Y - Gradient.AbsolutePosition.Y) / Gradient.AbsoluteSize.Y,
								0,
								1
							)
							sat = x
							val = 1 - y
							Cursor.Position = UDim2.new(x, 0, y, 0)
							updateColor(false)
						end
						if draggingHue then
							local x = math.clamp(
								(input.Position.X - HueSlider.AbsolutePosition.X) / HueSlider.AbsoluteSize.X,
								0,
								1
							)
							hue = x
							HueCursor.Position = UDim2.new(x, 0, 0.5, 0)
							updateColor(false)
						end
					end
				end)
			)

			Preview.MouseButton1Click:Connect(function()
				open = not open
				local targetSize = open and UDim2.new(1, 0, 0, 140) or UDim2.new(1, 0, 0, 38)
				tween(ColorPicker, 0.2, { Size = targetSize })
			end)

			local ColorPickerObject = { Frame = ColorPicker }
			function ColorPickerObject:Set(newColor)
				hue, sat, val = Color3.toHSV(newColor)
				color = newColor
				Preview.BackgroundColor3 = color
				Gradient.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
				Cursor.Position = UDim2.new(sat, 0, 1 - val, 0)
				HueCursor.Position = UDim2.new(hue, 0, 0.5, 0)
				if cfg.Flag then
					Library.Flags[cfg.Flag] = color
				end
				if cfg.Callback then
					cfg.Callback(color)
				end
			end
			return ColorPickerObject
		end

		return Tab
	end

	task.spawn(function()
		tween(MainWindow, 0.3, { Size = Config.WindowSize, BackgroundTransparency = 0 })
	end)

	function Window:Destroy()
		tween(MainWindow, 0.25, { Size = UDim2.new(0, 350, 0, 0), BackgroundTransparency = 1 })
		task.wait(0.25)
		for _, conn in ipairs(connections) do
			conn:Disconnect()
		end
		ScreenGui:Destroy()
	end

	return Window
end

function Library:Notify(cfg)
	local title = cfg.Title or "Notification"
	local text = cfg.Text or ""
	local duration = cfg.Duration or 3
	local anchor = cfg.Anchor or "TopRight"

	local screenGui = CoreGui:FindFirstChild("UILibrary")
	if not screenGui then
		return
	end

	local holderName = "NotificationHolder_" .. anchor
	local notifHolder = screenGui:FindFirstChild(holderName)

	if not notifHolder then
		notifHolder = Instance.new("Frame")
		notifHolder.Name = holderName
		notifHolder.Parent = screenGui
		notifHolder.BackgroundTransparency = 1
		notifHolder.Size = UDim2.new(0, 300, 1, -20)

		local layout = listLayout(notifHolder)

		if anchor == "TopRight" then
			notifHolder.Position = UDim2.new(1, -310, 0, 10)
			layout.VerticalAlignment = Enum.VerticalAlignment.Top
		elseif anchor == "TopLeft" then
			notifHolder.Position = UDim2.new(0, 10, 0, 10)
			layout.VerticalAlignment = Enum.VerticalAlignment.Top
		elseif anchor == "BottomRight" then
			notifHolder.Position = UDim2.new(1, -310, 0, 10)
			layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		elseif anchor == "BottomLeft" then
			notifHolder.Position = UDim2.new(0, 10, 0, 10)
			layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		end
	end

	local isRight = anchor == "TopRight" or anchor == "BottomRight"
	local startPos = isRight and UDim2.new(1, 50, 0, 0) or UDim2.new(0, -350, 0, 0)
	local endPos = UDim2.new(0, 0, 0, 0)

	local notification = Instance.new("Frame")
	notification.Parent = notifHolder
	notification.BackgroundColor3 = Colors.Container
	notification.BorderSizePixel = 0
	notification.Size = UDim2.new(1, 0, 0, 0)
	notification.Position = startPos
	notification.ClipsDescendants = true
	notification.BackgroundTransparency = 1
	corner(notification, 8)
	stroke(notification)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Parent = notification
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0, 12, 0, 8)
	titleLabel.Size = UDim2.new(1, -24, 0, 20)
	titleLabel.Font = Config.FontBold
	titleLabel.Text = title
	titleLabel.TextColor3 = Colors.Text
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTransparency = 1

	local textLabel = Instance.new("TextLabel")
	textLabel.Parent = notification
	textLabel.BackgroundTransparency = 1
	textLabel.Position = UDim2.new(0, 12, 0, 28)
	textLabel.Size = UDim2.new(1, -24, 0, 24)
	textLabel.Font = Config.Font
	textLabel.Text = text
	textLabel.TextColor3 = Colors.TextDark
	textLabel.TextSize = 12
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextWrapped = true
	textLabel.TextTransparency = 1

	tween(notification, 0.4, { Size = UDim2.new(1, 0, 0, 60), Position = endPos, BackgroundTransparency = 0 })
	tween(titleLabel, 0.4, { TextTransparency = 0 })
	tween(textLabel, 0.4, { TextTransparency = 0 })

	task.spawn(function()
		task.wait(duration)
		tween(notification, 0.4, { Size = UDim2.new(1, 0, 0, 0), Position = startPos, BackgroundTransparency = 1 })
		tween(titleLabel, 0.4, { TextTransparency = 1 })
		tween(textLabel, 0.4, { TextTransparency = 1 })
		task.wait(0.4)
		notification:Destroy()
	end)
end

function Library:CreateWatermark(cfg)
	local text = cfg.Text or "Watermark"
	local anchor = cfg.Anchor or "TopLeft"

	local screenGui = CoreGui:FindFirstChild("UILibrary")
	if not screenGui then
		return
	end

	if screenGui:FindFirstChild("Watermark") then
		screenGui:FindFirstChild("Watermark"):Destroy()
	end

	local Watermark = Instance.new("Frame")
	Watermark.Name = "Watermark"
	Watermark.Parent = screenGui
	Watermark.BackgroundColor3 = Colors.Container
	Watermark.BorderSizePixel = 0
	Watermark.Size = UDim2.new(0, 0, 0, 28)
	Watermark.AutomaticSize = Enum.AutomaticSize.X
	corner(Watermark)
	stroke(Watermark)
	padding(Watermark, 0, 0, 10, 10)

	if anchor == "TopLeft" then
		Watermark.Position = UDim2.new(0, 10, 0, 10)
	elseif anchor == "TopRight" then
		Watermark.Position = UDim2.new(1, -10, 0, 10)
		Watermark.AnchorPoint = Vector2.new(1, 0)
	elseif anchor == "BottomLeft" then
		Watermark.Position = UDim2.new(0, 10, 1, -38)
	elseif anchor == "BottomRight" then
		Watermark.Position = UDim2.new(1, -10, 1, -38)
		Watermark.AnchorPoint = Vector2.new(1, 0)
	end

	local WatermarkText = Instance.new("TextLabel")
	WatermarkText.Parent = Watermark
	WatermarkText.BackgroundTransparency = 1
	WatermarkText.Size = UDim2.new(0, 0, 1, 0)
	WatermarkText.Font = Config.FontBold
	WatermarkText.Text = text
	WatermarkText.TextColor3 = Colors.Text
	WatermarkText.TextSize = 12
	WatermarkText.AutomaticSize = Enum.AutomaticSize.X

	local WatermarkObject = { Frame = Watermark, TextLabel = WatermarkText }
	function WatermarkObject:Set(newText)
		WatermarkText.Text = newText
	end
	function WatermarkObject:Destroy()
		Watermark:Destroy()
	end
	return WatermarkObject
end

function Library:CreateTooltip(element, text)
	if element.Frame then
		element = element.Frame
	end

	local screenGui = CoreGui:FindFirstChild("UILibrary")
	if not screenGui then
		return
	end

	local tooltip = Instance.new("Frame")
	tooltip.Parent = screenGui
	tooltip.BackgroundColor3 = Colors.Background
	tooltip.BorderSizePixel = 0
	tooltip.Size = UDim2.new(0, 0, 0, 0)
	tooltip.Visible = false
	tooltip.ZIndex = 100
	corner(tooltip)
	stroke(tooltip, Color3.fromRGB(60, 60, 70), 1, 0)

	local tooltipText = Instance.new("TextLabel")
	tooltipText.Parent = tooltip
	tooltipText.BackgroundTransparency = 1
	tooltipText.Position = UDim2.new(0, 8, 0, 6)
	tooltipText.Size = UDim2.new(1, -16, 1, -12)
	tooltipText.Font = Config.Font
	tooltipText.Text = text
	tooltipText.TextColor3 = Color3.fromRGB(200, 200, 210)
	tooltipText.TextSize = 12
	tooltipText.TextXAlignment = Enum.TextXAlignment.Left
	tooltipText.TextWrapped = true
	tooltipText.ZIndex = 101

	local showing = false
	local hoverThread = nil

	element.MouseEnter:Connect(function()
		hoverThread = task.spawn(function()
			showing = true
			local textSize = TextService:GetTextSize(text, 12, Config.Font, Vector2.new(200, 1000))
			local width = math.clamp(textSize.X + 16, 80, 220)
			local height = textSize.Y + 12
			tooltip.Size = UDim2.new(0, width, 0, height)
			tooltip.Visible = true
			tooltip.BackgroundTransparency = 1
			tooltipText.TextTransparency = 1
			tween(tooltip, nil, { BackgroundTransparency = 0 })
			tween(tooltipText, nil, { TextTransparency = 0 })
		end)
	end)

	element.MouseLeave:Connect(function()
		if hoverThread then
			task.cancel(hoverThread)
			hoverThread = nil
		end
		if showing then
			showing = false
			tween(tooltip, 0.1, { BackgroundTransparency = 1 })
			tween(tooltipText, 0.1, { TextTransparency = 1 })
			task.delay(0.1, function()
				tooltip.Visible = false
			end)
		end
	end)

	element.MouseMoved:Connect(function(x, y)
		if showing then
			tooltip.Position = UDim2.new(0, x + 15, 0, y + 15)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if showing or hoverThread then
				tooltip.Position = UDim2.new(0, input.Position.X + 15, 0, input.Position.Y + 15)
			end
		end
	end)
end

return Library
