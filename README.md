# UI Library

## Usage
```lua
local Library = loadstring(game:HttpGet("URL_HERE"))()
local Window = Library:CreateWindow({ Title, Keybind })
local Tab = Window:CreateTab(Name)
```

## Components
```
CreateButton({ Name, Callback })
CreateToggle({ Name, Flag, Default, Callback })
CreateSlider({ Name, Flag, Min, Max, Default, Step, Callback })
CreateInput({ Name, Flag, Placeholder, Default, Callback })
CreateDropdown({ Name, Flag, Options, Default, Callback })
CreateMultiDropdown({ Name, Flag, Options, Default, Callback })
CreateKeybind({ Name, Flag, Default, Callback })
CreateColorPicker({ Name, Flag, Default, Callback })
```

## Flags
```lua
Library.Flags.FlagName
```

## Set Value
```lua
component:Set(value)
```

## Notification
```lua
Library:Notify({ Title, Text, Duration, Anchor })
```

## Watermark
```lua
Library:CreateWatermark({ Text, Anchor })
```
