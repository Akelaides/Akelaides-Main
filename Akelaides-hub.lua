local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark", -- Default theme
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    Teleportation = Window:AddTab({ Title = "Teleportation", Icon = "map-pin" })
}

local MainTab = Tabs.Main
local SettingsTab = Tabs.Settings
local TeleportTab = Tabs.Teleportation

-- Dropdown to change the UI color theme
local ColorDropdown = SettingsTab:AddDropdown("ColorTheme", {
    Title = "Change UI Color",
    Values = {"Dark", "Light", "Purple", "Red", "Green"}, -- Replaced Blue with Purple
    Default = "Dark", -- Default theme color
})

ColorDropdown:OnChanged(function(selectedColor)
    -- Change the UI theme based on the selection
    if selectedColor == "Dark" then
        Window:SetTheme("Dark")
    elseif selectedColor == "Light" then
        Window:SetTheme("Light")
    elseif selectedColor == "Purple" then
        Window:SetTheme("Purple") -- Set to purple
        -- Adding a dark purple gradient effect
        Window:SetBackgroundColor(Color3.fromRGB(50, 0, 50))  -- A darker purple background
        Window:SetGradientColor(Color3.fromRGB(102, 0, 102), Color3.fromRGB(50, 0, 50))  -- Gradient from purple to dark purple
    elseif selectedColor == "Red" then
        Window:SetTheme("Red")
    elseif selectedColor == "Green" then
        Window:SetTheme("Green")
    end
    print("UI theme changed to:", selectedColor)
end)

-- Main Section
MainTab:AddButton({
    Title = "Example Button",
    Description = "Just a placeholder",
    Callback = function()
        print("Button clicked!")
    end
})

-- Infinite Yield Button
MainTab:AddButton({
    Title = "Infinite Yield",
    Description = "Loads Infinite Yield script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

-- Teleport Section
local Section = TeleportTab:AddSection("Islands")

-- Button for Moosewood
TeleportTab:AddButton({
    Title = "Teleport to Moosewood",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Define teleportation location for Moosewood
        local moosewoodPosition = Vector3.new(400, 135, 250)
        
        -- Teleport the player
        humanoidRootPart.CFrame = CFrame.new(moosewoodPosition)
        print("Teleporting to Moosewood")
    end,
})

-- Button for Forsaken
TeleportTab:AddButton({
    Title = "Teleport to Forsaken",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Define teleportation location for Forsaken
        local forsakenPosition = Vector3.new(-2497, 137, 1627)
        
        -- Teleport the player
        humanoidRootPart.CFrame = CFrame.new(forsakenPosition)
        print("Teleporting to Forsaken")
    end,
})

-- Button for Ancient Isles
TeleportTab:AddButton({
    Title = "Teleport to Ancient Isles",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Define teleportation location for Ancient Isles
        local ancientIslesPosition = Vector3.new(6000, 200, 300)
        
        -- Teleport the player
        humanoidRootPart.CFrame = CFrame.new(ancientIslesPosition)
        print("Teleporting to Ancient Isles")
    end,
})

-- Notify
Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- Set up the save and interface managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})
