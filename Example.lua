local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Majora144/SimpleUi/refs/heads/main/Library.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Library:CreateWindow({
    Title = "Example Script",
    Keybind = Enum.KeyCode.RightShift
})

local MainTab = Window:CreateTab("Main")
local PlayerTab = Window:CreateTab("Player")
local SettingsTab = Window:CreateTab("Settings")

MainTab:CreateButton({
    Name = "Button Example",
    Callback = function()
        print("Button clicked!")
    end
})

MainTab:CreateToggle({
    Name = "Toggle Example",
    Flag = "Toggle1",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

MainTab:CreateSlider({
    Name = "Slider Example",
    Flag = "Slider1",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Slider:", value)
    end
})

MainTab:CreateSlider({
    Name = "Decimal Slider",
    Flag = "Slider2",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Step = 0.1,
    Callback = function(value)
        print("Decimal:", value)
    end
})

MainTab:CreateInput({
    Name = "Input Example",
    Flag = "Input1",
    Placeholder = "Type here...",
    Default = "",
    Callback = function(text)
        print("Input:", text)
    end
})

MainTab:CreateDropdown({
    Name = "Dropdown Example",
    Flag = "Dropdown1",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(selected)
        print("Dropdown:", selected)
    end
})

MainTab:CreateMultiDropdown({
    Name = "Multi Dropdown",
    Flag = "MultiDropdown1",
    Options = {"Item A", "Item B", "Item C"},
    Default = {},
    Callback = function(selected)
        print("Selected:", table.concat(selected, ", "))
    end
})

MainTab:CreateKeybind({
    Name = "Keybind Example",
    Flag = "Keybind1",
    Default = Enum.KeyCode.E,
    Callback = function()
        print("Keybind pressed!")
    end
})

MainTab:CreateColorPicker({
    Name = "Color Example",
    Flag = "Color1",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Color:", color)
    end
})

PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Flag = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Jump Power",
    Flag = "JumpPower",
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    Flag = "InfiniteJump",
    Default = false,
    Callback = function(value)
        print("Infinite Jump:", value)
    end
})

PlayerTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 0
        end
    end
})

PlayerTab:CreateButton({
    Name = "Teleport to Origin",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        end
    end
})

SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Window:Destroy()
    end
})

Library:CreateWatermark({
    Text = "Example Script",
    Anchor = "TopLeft"
})

Library:Notify({
    Title = "Loaded",
    Text = "Script loaded successfully!",
    Duration = 3,
    Anchor = "TopRight"
})
