local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Akelaides Hub " .. Fluent.Version,
    SubTitle = "by Calvin",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Amethyst",
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
    Title = "Copy Discord Link",
    Description = "https://discord.gg/DHJzx6gZ",
    Callback = function()
        setclipboard("https://discord.gg/DHJzx6gZ")
        print("Copied To Clipboard!")
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

-- Input Field for Autofarm Value
local Input = Tabs.Main:AddInput("AutofarmValue", {
    Title = "Autofarm Value",
    Default = "Default",
    Placeholder = "Enter your Value",
    Numeric = false, -- Only allows numbers
    Finished = false, -- Only calls callback when you press enter
    Callback = function(Value)
        print("Input changed: ", Value)
        getgenv().farmValue = tonumber(Value) or 1 -- Ensure the value is numeric
    end
})

Input:OnChanged(function()
    print("Input updated:", Input.Value)
end)

-- Toggle for Autofarm
local Toggle = Tabs.Main:AddToggle("Autofarm", {Title = "Autofarm", Default = false})

Toggle:OnChanged(function(State)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Position to teleport the player for farming
    local farmPosition = Vector3.new(-191, 16, -158)
    humanoidRootPart.CFrame = CFrame.new(farmPosition)

    getgenv().farmer = State -- Enable/Disable farmer based on the toggle state

    if getgenv().farmer then
        while getgenv().farmer do
            local args = {
                [1] = "ClickStat",
                [2] = getgenv().farmValue or 1 -- Use the input value, defaulting to 1 if nil
            }
            
            -- Perform the farming operation
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Client"):InvokeServer(unpack(args))
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Client"):InvokeServer(unpack(args)) -- Extra click for speed

            task.wait() -- Use task.wait for better performance
        end
    end
end)


getgenv().farmer = true

while farmer == true do
    local args = {
        [1] = "Moon",
        [2] = "Single"
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("EggOpened"):InvokeServer(unpack(args))
    task.wait()
end    


-- Teleport Section
local Section = TeleportTab:AddSection("Islands")

-- Button for Moosewood
TeleportTab:AddButton({
    Title = "Teleport to Escape Island",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Define teleportation location for Moosewood
        local escapePosition = Vector3.new(-167, 13, -444)
        
        -- Teleport the player
        humanoidRootPart.CFrame = CFrame.new(escapePosition)
        print("Teleporting to Island")
    end,
})

-- Button for Forsaken
TeleportTab:AddButton({
    Title = "Teleport to Winter",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Define teleportation location for Forsaken
        local escWinterPosition = Vector3.new(-168, 16, -770)
        
        -- Teleport the player
        humanoidRootPart.CFrame = CFrame.new(escWinterPosition)
        print("Teleporting to Escape Winter")
    end,
})

-- Button for Ancient Isles
TeleportTab:AddButton({
    Title = "Teleport to Spooky",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Define teleportation location for Ancient Isles
        local spookyPosition = Vector3.new(-167, 21, -768)
        
        -- Teleport the player
        humanoidRootPart.CFrame = CFrame.new(spookyPosition)
        print("Teleporting to Spooky")
    end,
})

TeleportTab:AddParagraph({
    Title = "More Teleports Soon ! <3"
    Content = "I'm lazy lol."
})

-- Notify
Fluent:Notify({
    Title = "Akelaides",
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
