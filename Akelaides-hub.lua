local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Akelaides Hub " .. Fluent.Version,
    SubTitle = "by Calvin",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Teleportation = Window:AddTab({ Title = "Teleportation", Icon = "map-pin" })
}

local MainTab = Tabs.Main
local TeleportTab = Tabs.Teleportation

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
