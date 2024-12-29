local VirtualInputManager = game:GetService("VirtualInputManager") -- For simulating input
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

-- Load Fluent
local FluentSuccess, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not FluentSuccess or not Fluent then
    warn("Fluent could not be loaded.")
    return
end

Fluent:Notify({
    Title = "Akelaides",
    Content = "Akelaides Loaded Successfully!",
    Duration = 3
})

-- Create Window
local Window = Fluent:CreateWindow({
    Title = "Akelaides Hub",
    SubTitle = "Power Slap Simulator | By Calvin",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Home", Icon = "home" }),
    Autofarm = Window:AddTab({ Title = "Automatic", Icon = "bot" }),
    Teleportation = Window:AddTab({ Title = "Teleportation", Icon = "compass" }),
    Miscellaneous = Window:AddTab({ Title = "Miscellaneous", Icon = "boxes" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Anti-AFK Logic
local antiAFKEnabled = false
local antiAFKConnection

local function startAntiAFK()
    antiAFKConnection = RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:Move(Vector3.new(0, 0, 0), true)
        end
    end)
end

local function stopAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
end

-- Anti-AFK Toggle
local ToggleAntiAFK = Tabs.Miscellaneous:AddToggle("Anti-AFK", { Title = "Enable Anti-AFK", Default = false })
ToggleAntiAFK:OnChanged(function(state)
    antiAFKEnabled = state
    if state then
        startAntiAFK()
        Fluent:Notify({ Title = "Anti-AFK Enabled", Content = "You will no longer be marked as AFK.", Duration = 4 })
    else
        stopAntiAFK()
        Fluent:Notify({ Title = "Anti-AFK Disabled", Content = "You are now allowed to be AFK.", Duration = 4 })
    end
end)

-- Teleport Function
local function teleportTo(position, title)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = CFrame.new(position)
    Fluent:Notify({ Title = "Teleportation", Content = "Teleported to " .. title, Duration = 3 })
end

-- Teleport Buttons
local teleportLocations = {
    { title = "Escape Island", position = Vector3.new(-167, 17, -100) },
    { title = "Winter", position = Vector3.new(-168, 17, -445) },
    { title = "Spooky Island", position = Vector3.new(-168, 16, -771)    },
    { title = "Anime Island", position = Vector3.new(-168, 17, -1071) },
    { title = "Desert Island", position = Vector3.new(-167, 15, -1383) },
    { title = "Underworld", position = Vector3.new(-167, 15, -1719) },
    { title = "Luck Island", position = Vector3.new(-168, 15, -2041) },
    { title = "Ice Island", position = Vector3.new(-169, 17, -2356) },
    { title = "Volcano Island", position = Vector3.new(-168, 15, -2685) },
    { title = "Mars Island", position = Vector3.new(-169, 16, -3052) },
    { title = "Robot Island", position = Vector3.new(-180, 16, -3419) },
    { title = "Pyramid Island", position = Vector3.new(-179, 14, -3797)}
}

-- Create teleport buttons
for _, location in ipairs(teleportLocations) do
    Tabs.Teleportation:AddButton({
        Title = "Teleport to " .. location.title,
        Callback = function()
            teleportTo(location.position, location.title)
        end
    })
end

-- Notify that the script has been loaded
Fluent:Notify({
    Title = "Akelaides",
    Content = "The script has been loaded.",
    Duration = 8
})

-- SaveManager and InterfaceManager setup
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Autofarm Section
local AutofarmTab = Tabs.Autofarm
local farmValue = 1

-- Input for Autofarm Value
AutofarmTab:AddInput("AutofarmValue", {
    Title = "Autofarm Click Value",
    Description = "Change How many Slaps per Click",
    Default = "1",
    Placeholder = "Enter your Value",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        farmValue = tonumber(Value) or 1
        Fluent:Notify({
            Title = "Autofarm Value Changed",
            Content = "Autofarm value set to: " .. tostring(farmValue),
            Duration = 4
        })
    end
})

-- Toggle for Autofarm
local ToggleAutofarm = AutofarmTab:AddToggle("Autofarm", { Title = "Autofarm", Default = false })
ToggleAutofarm:OnChanged(function(state)
    if state then
        Fluent:Notify({
            Title = "Autofarm Enabled",
            Content = "Autofarm has been activated.",
            Duration = 4
        })
        while ToggleAutofarm:Get() do
            local args = {
                [1] = "ClickStat",
                [2] = farmValue
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Client"):InvokeServer(unpack(args))
            task.wait(0.01)
        end
    else
        Fluent:Notify({
            Title = "Autofarm Disabled",
            Content = "Autofarm has been deactivated.",
            Duration = 4
        })
    end
end)

-- Auto Rebirth Section
local ToggleAutoRebirth = AutofarmTab:AddToggle("AutoRebirth", { Title = "Auto Rebirth", Default = false })
ToggleAutoRebirth:OnChanged(function(state)
    if state then
        Fluent:Notify({
            Title = "Auto Rebirth Enabled",
            Content = "Auto Rebirth has been activated.",
            Duration = 4
        })
        while ToggleAutoRebirth:Get() do
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Rebirth"):FireServer()
            task.wait(0.1)
        end
    else
        Fluent:Notify({
            Title = "Auto Rebirth Disabled",
            Content = "Auto Rebirth has been deactivated.",
            Duration = 4
        })
    end
end)

-- Hold E and Spam Click Section
local holdAndClickToggle = AutofarmTab:AddToggle("Hold E and Spam Click", { Title = "Hold E for 2 seconds and Spam Click for 5", Default = false })

local spamInterval = 0.1 -- Time between clicks (adjust as needed)
local isRunning = false -- Flag to prevent overlapping actions

-- Function to simulate holding "E" for 2 seconds
local function holdEKey()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(2)  -- Hold for 2 seconds
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- Function to simulate spam clicking for 5 seconds
local function startSpamClick()
    local endTime = tick() + 5  -- Set the end time for 5 seconds from now
    while tick() < endTime do
        local mouseX, mouseY = player:GetMouse().X, player:GetMouse().Y
        VirtualInputManager:SendMouseButtonEvent(mouseX, mouseY, 0, true, nil, 0) -- Mouse Down
        VirtualInputManager:SendMouseButtonEvent(mouseX, mouseY, 0, false, nil, 0) -- Mouse Up
        task.wait(spamInterval) -- Wait before the next click
    end
end

holdAndClickToggle:OnChanged(function(state)
    if state and not isRunning then
        isRunning = true -- Set the flag to indicate the action is running
        while holdAndClickToggle:Get() do
            holdEKey()  -- Hold the "E" key for 2 seconds
            startSpamClick()  -- Start spam clicking for 5 seconds

            Fluent:Notify({
                Title = "Action Complete",
                Content = "Held 'E' for 2 seconds and spam clicked for 5 seconds.",
                Duration = 4
            })
            
            task.wait(1) -- Wait for 1 second before repeating the process
        end
        isRunning = false -- Reset the flag when done
    elseif not state then
        isRunning = false -- Reset the flag if the toggle is turned off
    end
end)

-- Miscellaneous Section for Infinite Yield
Tabs.Miscellaneous:AddButton({
    Title = "Load Infinite Yield",
    Description = "Loads Infinite Yield script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() 
    end
})

-- Final Notification
Fluent:Notify({
    Title = "Akelaides",
    Content = "The script has been fully loaded and is ready to use.",
    Duration = 8
})

-- SaveManager and InterfaceManager setup
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Select the first tab by default
Window:SelectTab(1)
