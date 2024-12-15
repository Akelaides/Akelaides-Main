local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Akelaides Hub " .. Fluent.version,
    SubTitle = "by Calvin",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when there's no MinimizeKeybind
})

local Tabs = {
    Main = Window:AddTab({ Title = "Home", Icon = "home" }),
    Local = Window:AddTab({ Title = "Player", Icon = "person-standing"}),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Notification example
if Fluent then
    Fluent:Notify({
        Title = "Akelaides Hub",
        Content = "Script loaded successfully!",
        Duration = 5
    })
else
    warn("Failed to initialize Fluent library.")
end

-- Home Tab Paragraph
Tabs.Main:AddParagraph({
    Title = "Made By Calvin With Love",
    Content = "Private Script >.<"
})

-- Infinite Yield Button
Tabs.Local:AddButton({
    Title = "Infinite Yield",
    Description = "Loads Infinite Yield into the game.",
    Callback = function()
        Window:Dialog({
            Title = "Infinite Yield",
            Content = "Are you sure you want to load Infinite Yield?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()
                        print("Infinite Yield loaded successfully.")
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Dialog canceled.")
                    end
                }
            }
        })
    end
})

-- WalkSpeed Slider
local Slider = Tabs.Local:AddSlider("Slider", {
    Title = "WalkSpeed Adjuster",
    Description = "Adjust your player's walking speed.",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        print("WalkSpeed set to:", Value)
    end
})

Slider:OnChanged(function(Value)
    print("Slider changed to:", Value)
end)

-- Dropdown Example
local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
    Title = "Example Dropdown",
    Values = {"Option 1", "Option 2", "Option 3"},
    Multi = false,
    Default = 1
})

Dropdown:OnChanged(function(Value)
    print("Dropdown changed:", Value)
end)

-- SaveManager and InterfaceManager setup
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Load configurations
SaveManager:LoadAutoloadConfig()

Window:SelectTab(1)
