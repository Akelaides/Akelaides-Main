local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
if not Fluent then
    warn("Fluent library failed to load")
else
    print("Fluent library loaded successfully")
end

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Akelaides Hub " .. "",  -- Fixed version if Fluent.Version is unavailable
    SubTitle = "1.2 | By Calvin",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Home", Icon = "home" }),
    Autofarm = Window:AddTab({ Title = "Farming", Icon = "hammer"}),
    Teleportation = Window:AddTab({ Title = "Teleportation", Icon = "map-pin" }),
    Miscellanous = Window:AddTab({ Title = "Misc", Icon = "boxes"}),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })  -- Added the Settings tab
}

local MainTab = Tabs.Main
local TeleportTab = Tabs.Teleportation
local SettingsTab = Tabs.Settings
local AutofarmTab = Tabs.Autofarm
local MiscellanousTab = Tabs.Misc  -- Referencing the Settings tab for later use

-- Main Section
MainTab:AddButton({
    Title = "Copy Discord Link",
    Description = "https://discord.gg/DHJzx6gZ",
    Callback = function()
        setclipboard("https://discord.gg/DHJzx6gZ")
        print("Copied To Clipboard!")
        
        -- Notify the user that the link was copied
        Fluent:Notify({
            Title = "Link Copied",
            Content = "The Discord link has been copied to your clipboard.",
            Duration = 4
        })
    end
})


-- Infinite Yield Button
MiscellanousTab:AddButton({
    Title = "Infinite Yield",
    Description = "Loads Infinite Yield script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

-- Input Field for Autofarm Value
local Input = Tabs.Autofarm:AddInput("AutofarmValue", {
    Title = "Autofarm Value",
    Default = "1",
    Placeholder = "Enter your Value",
    Numeric = false, 
    Finished = false,
    Callback = function(Value)
        print("Input changed: ", Value)
        getgenv().farmValue = tonumber(Value) or 1
    end
})

Input:OnChanged(function()
    print("Input updated:", Input.Value)
end)

-- Toggle for Autofarm
local Toggle = Tabs.Autofarm:AddToggle("Autofarm", {Title = "Autofarm", Default = false})

Toggle:OnChanged(function(State)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Do NOT teleport to the farm position when the script first loads.
    -- Only teleport to the farm position when the toggle is ON
    if State then
        local farmPosition = Vector3.new(-191, 16, -158)
        humanoidRootPart.CFrame = CFrame.new(farmPosition)  -- Move the player to farm position
    end

    getgenv().farmer = State

    if getgenv().farmer then
        while getgenv().farmer do
            local args = {
                [1] = "ClickStat",
                [2] = getgenv().farmValue or 1
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Client"):InvokeServer(unpack(args))
            task.wait(0.01)  -- Adjusted wait for performance
        end
    end
end)

-- Teleport Section
local Section = TeleportTab:AddSection("Islands")

-- Button for Escape Island
TeleportTab:AddButton({
    Title = "Teleport to Escape Island",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Define teleportation location for Escape Island
        local escapePosition = Vector3.new(-167, 17, -100)
        
        -- Teleport the player
        humanoidRootPart.CFrame = CFrame.new(escapePosition)
        print("Teleporting to Escape Island")
    end,
})

-- Button for Winter Island
TeleportTab:AddButton({
    Title = "Teleport to Winter",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Define teleportation location for Winter Island
        local escWinterPosition = Vector3.new(-168, 17, -445)
        
        -- Teleport the player
        humanoidRootPart.CFrame = CFrame.new(escWinterPosition)
        print("Teleporting to Winter Island")
    end,
})

-- Button for Spooky Island
TeleportTab:AddButton({
    Title = "Teleport to Spooky Island",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Define teleportation location for Spooky Island
        local spookyPosition = Vector3.new(-168, 16, -771)
        
        -- Teleport the player
        humanoidRootPart.CFrame = CFrame.new(spookyPosition)
        print("Teleporting to Spooky Island")
    end,
})

TeleportTab:AddParagraph({
    Title = "More Teleports Soon! <3",
    Content = "I'm lazy lol."
})

-- Notify
Fluent:Notify({
    Title = "Akelaides",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

