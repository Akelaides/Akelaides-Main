local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by calvin",  -- Changed to "by calvin"
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Teleportation = Window:AddTab({ Title = "Teleportation", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Teleportation Dropdown
local TeleportDropdown = Tabs.Teleportation:AddDropdown("TeleportationDropdown", {
    Title = "Select Island to Teleport",
    Values = {
        "Moosewood",
        "Forsaken",
        "Ancient Isles"
    },
    Multi = false,
    Default = 1
})

-- Teleportation logic based on dropdown selection
TeleportDropdown:OnChanged(function(Value)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    if Value == "Moosewood" then
        local moosewoodPosition = Vector3.new(400, 135, 250)
        humanoidRootPart.CFrame = CFrame.new(moosewoodPosition)
        print("Teleporting to Moosewood")
    elseif Value == "Forsaken" then
        local forsakenPosition = Vector3.new(-2497, 137, 1627)
        humanoidRootPart.CFrame = CFrame.new(forsakenPosition)
        print("Teleporting to Forsaken")
    elseif Value == "Ancient Isles" then
        local ancientIslesPosition = Vector3.new(6000, 200, 300)
        humanoidRootPart.CFrame = CFrame.new(ancientIslesPosition)
        print("Teleporting to Ancient Isles")
    end
end)

-- WalkSpeed Input
local WalkSpeedInput = Tabs.Settings:AddInput("WalkSpeed", {
    Title = "Walkspeed",
    Default = "16",
    Placeholder = "Enter walkspeed",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local walkSpeedValue = tonumber(Value)
        if walkSpeedValue then
            game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = walkSpeedValue
            print("Walkspeed set to: " .. walkSpeedValue)
        else
            print("Invalid walkspeed value!")
        end
    end
})

-- Example Button
Tabs.Main:AddButton({
    Title = "Test Button",
    Description = "A test button to trigger actions",
    Callback = function()
        print("Test button clicked!")
    end
})

-- Additional Example Inputs and Features
local Keybind = Tabs.Main:AddKeybind("Keybind", {
    Title = "KeyBind",
    Mode = "Toggle",
    Default = "LeftControl",
    Callback = function(Value)
        print("Keybind clicked:", Value)
    end
})

-- Set up SaveManager and InterfaceManager
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

SaveManager:LoadAutoloadConfig()
