# UI Library

## Usage
```lua
local Library = loadstring(game:HttpGet("SOURCE_URL_HERE"))() -- https://raw.githubusercontent.com/Majora144/SimpleUi/refs/heads/main/Library.lua
local Window = Library:CreateWindow({ Title, Keybind }) -- string, Enum.KeyCode
local Tab = Window:CreateTab(Name) -- string
```

## Components
```
CreateButton({ Name, Callback }) -- string, function()
CreateToggle({ Name, Flag, Default, Callback }) -- string, string, bool, function()
CreateSlider({ Name, Flag, Min, Max, Default, Step, Callback }) -- string, string, int, int, int, step, function()
CreateInput({ Name, Flag, Placeholder, Default, Callback }) -- string, string, string, string, function()
CreateDropdown({ Name, Flag, Options, Default, Callback }) -- string, string, table, string, function()
CreateMultiDropdown({ Name, Flag, Options, Default, Callback }) -- string, string, table, table, function()
CreateKeybind({ Name, Flag, Default, Callback }) -- string, string, Enum.KeyCode, function()
CreateColorPicker({ Name, Flag, Default, Callback }) -- string, string, Color3.fromRGB, function()
```

## Flags
```lua
Library.Flags.FlagName -- returns value of component
```

## Set Value
```lua
component:Set(value) -- value depending on component
```

## Notification
```lua
Library:Notify({ Title, Text, Duration, Anchor }) -- string, string, int, TopRight/TopLeft/BottomRight/BottomLeft
```

## Watermark
```lua
Library:CreateWatermark({ Text, Anchor }) -- string, TopRight/TopLeft/BottomRight/BottomLeft
```
