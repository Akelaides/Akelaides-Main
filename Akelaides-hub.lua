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
    Acrylic = true,  -- Keep this true for the acrylic effect
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Optional: Adjust the background color and transparency for better visibility
Window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  -- Dark background color
Window.BackgroundTransparency = 0.5  -- Adjust transparency to enhance the acrylic effect

local Tabs = {
    Main = Window:AddTab({ Title = "Home", Icon = "home" }),
    Autofarm = Window:AddTab({ Title = "Autofarm", Icon = "hammer"}),
    Teleportation = Window:AddTab({ Title = "Teleportation", Icon = "map-pin" }),
    Miscellaneous = Window:AddTab({ Title = "Miscellaneous", Icon = "boxes" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local MainTab = Tabs.Main
local AutofarmTab = Tabs.Autofarm
local TeleportTab = Tabs.Teleportation
local MiscTab = Tabs.Miscellaneous
local SettingsTab = Tabs.Settings

-- Anti-AFK Logic
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local antiAFKEnabled = false
local antiAFKConnection

local function startAntiAFK()
    antiAFKConnection = RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            -- Simulate activity without moving the character
            player.Character.Humanoid:Move(Vector3.new(0, 0, 0), true) -- This does not cause movement
            wait(0.1) -- Adjust the wait time as needed
        end
    end)
end

local function stopAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
end

-- Move the Anti-AFK Toggle to the Miscellaneous Tab
local ToggleAntiAFK = MiscTab:AddToggle("Anti-AFK", { Title = "Anti-AFK", Default = false })

ToggleAntiAFK:OnChanged(function(antiAFKState)  -- Renamed variable to antiAFKState
    antiAFKEnabled = antiAFKState
    if antiAFKEnabled then
        startAntiAFK()
    else
        stopAntiAFK()
    end
end)

-- Main Section
MainTab:AddButton({
    Title = "Copy Discord Link",
    Description = "https://discord.gg/DHJzx6gZ",
    Callback = function()
        setclipboard("https://discord.gg/DHJzx6gZ")
        print("Copied To Clipboard!")
        
        Fluent:Notify({
            Title = "Link Copied",
            Content = "The Discord link has been copied to your clipboard.",
            Duration = 4
        })
    end
})

-- Input Field for Autofarm Value
local Input = AutofarmTab:AddInput("AutofarmValue", {
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
local Toggle = AutofarmTab:AddToggle("Autofarm", {Title = "Autofarm", Default = false})

Toggle:OnChanged(function(State)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if State then
        local farmPosition = Vector3.new(-191, 16, -158)
        humanoidRootPart.CFrame = CFrame.new(farmPosition)
    end

    getgenv().farmer = State

    if getgenv().farmer then
        while getgenv().farmer do
            local args = {
                [1] = "ClickStat",
                [2] = getgenv().farmValue or 1
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Client"):InvokeServer(unpack(args))
            task.wait(0.01)
        end
    end
end)

-- Miscellaneous Section for Infinite Yield
MiscTab:AddButton({
    Title = "Load Infinite Yield",
    Description = "Loads Infinite Yield script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

-- Teleport Section
local Section = TeleportTab:AddSection("Islands")

-- Button for Escape Island
TeleportTab:AddButton({
    Title = "Teleport to Escape Island",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        local escapePosition = Vector3.new(-167, 17, -100)
        humanoidRootPart.CFrame = CFrame.new(escapePosition)
        
            
        Fluent:Notify({
            Title = "Teleportation",
            Content = "Teleported to Island",
            Duration = 3
        })

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


        Fluent:Notify({
            Title = "Teleportation",
            Content = "Teleported to Winter",
            Duration = 3
        })
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


        Fluent:Notify({
            Title = "Teleportation",
            Content = "Teleported to Spooky",
            Duration = 3
        })
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

