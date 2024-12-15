local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Akelaides Hub " .. Fluent.Version,
    SubTitle = "by calvin",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Home", Icon = "home" }),
    Autofarm = Window:AddTab({ Title = "Autofarm", Icon = "hammer"}),
    Teleportation = Window:AddTab({ Title = "Teleportation", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

local TeleportDropdown = Tabs.Teleportation:AddDropdown("TeleportationDropdown", {
    Title = "Select Island to Teleport",
    Description = "Teleport to an island.",
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

-- Auto-cast mode dropdown
local AutoCastModeDropdown = Tabs.Autofarm:AddDropdown("AutoCastModeDropdown", {
    Title = "Select Auto Cast Mode",
    Description = "Choose the AutoCast mode.",
    Values = {
        "Legit",
        "Rage"
    },
    Multi = false,
    Default = 1
})

-- Auto-cast toggle
local autoCast = false
local autoCastDelay = 0.1
local autoCastMode = "Legit"  -- Default mode

AutoCastModeDropdown:OnChanged(function(Value)
    autoCastMode = Value
    print("Auto Cast Mode set to:", autoCastMode)
end)

local autoCastToggle = Tabs.Autofarm:AddToggle("AutoCast", { Title = "Auto Cast", Default = false })
autoCastToggle:OnChanged(function()
    autoCast = autoCastToggle.Value
    print("Auto Cast:", autoCast)
end)

-- Auto-reel toggle
local autoReel = false
local autoReelDelay = 0.1

local autoReelToggle = Tabs.Autofarm:AddToggle("AutoReel", { Title = "Auto Reel", Default = false })
autoReelToggle:OnChanged(function()
    autoReel = autoReelToggle.Value
    print("Auto Reel:", autoReel)
end)

-- Auto-shake toggle
local autoShake = false
local autoShakeDelay = 0.1  -- Time between shakes
local autoShakeMethod = "KeyCodeEvent"  -- Can be "ClickEvent" or "KeyCodeEvent"
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local PlayerGUI = game.Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

local autoShakeToggle = Tabs.Autofarm:AddToggle("AutoShake", {Title = "Auto Shake", Default = false})
autoShakeToggle:OnChanged(function()
    autoShake = autoShakeToggle.Value
    print("Auto Shake:", autoShake)
end)

-- Auto-Reel and Auto-Shake connection
local autoreelAndShakeConnection = PlayerGUI.ChildAdded:Connect(function(GUI)
    if GUI:IsA("ScreenGui") and GUI.Name == "shakeui" then
        if GUI:FindFirstChild("safezone") ~= nil then
            GUI.safezone.ChildAdded:Connect(function(child)
                if child:IsA("ImageButton") and child.Name == "button" then
                    if autoShake == true then
                        task.wait(autoShakeDelay)
                        if child.Visible == true then
                            if autoShakeMethod == "ClickEvent" then
                                local pos = child.AbsolutePosition
                                local size = child.AbsoluteSize
                                VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, true, LocalPlayer, 0)
                                VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, false, LocalPlayer, 0)
                            elseif autoShakeMethod == "KeyCodeEvent" then
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                            end
                        end
                    end
                end
            end)
        end
    end

    if GUI:IsA("ScreenGui") and GUI.Name == "reel" then
        if autoReel and ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished") ~= nil then
            repeat task.wait(autoReelDelay) ReplicatedStorage.events.reelfinished:FireServer(100, false) until GUI == nil
        end
    end
end)

-- Auto-Cast connection
local autoCastConnection = LocalCharacter.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and child:FindFirstChild("events"):WaitForChild("cast") ~= nil and autoCast then
        task.wait(autoCastDelay)
        if autoCastMode == "Legit" then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, LocalPlayer, 0)
            HumanoidRootPart.ChildAdded:Connect(function()
                if HumanoidRootPart:FindFirstChild("power") ~= nil and HumanoidRootPart.power.powerbar.bar ~= nil then
                    HumanoidRootPart.power.powerbar.bar.Changed:Connect(function(property)
                        if property == "Size" then
                            if HumanoidRootPart.power.powerbar.bar.Size == UDim2.new(1, 0, 1, 0) then
                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, LocalPlayer, 0)
                            end
                        end
                    end)
                end
            end)
        elseif autoCastMode == "Rage" then
            child.events.cast:FireServer(100)
        end
    end
end)

-- Auto-Cast connection for when GUI is removed
local autoCastConnection2 = PlayerGUI.ChildRemoved:Connect(function(GUI)
    local Tool = LocalCharacter:FindFirstChildOfClass("Tool")
    if GUI.Name == "reel" and autoCast == true and Tool ~= nil and Tool:FindFirstChild("events"):WaitForChild("cast") ~= nil then
        task.wait(autoCastDelay)
        if autoCastMode == "Legit" then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, LocalPlayer, 0)
            HumanoidRootPart.ChildAdded:Connect(function()
                if HumanoidRootPart:FindFirstChild("power") ~= nil and HumanoidRootPart.power.powerbar.bar ~= nil then
                    HumanoidRootPart.power.powerbar.bar.Changed:Connect(function(property)
                        if property == "Size" then
                            if HumanoidRootPart.power.powerbar.bar.Size == UDim2.new(1, 0, 1, 0) then
                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, LocalPlayer, 0)
                            end
                        end
                    end)
                end
            end)
        elseif autoCastMode == "Rage" then
            Tool.events.cast:FireServer(100)
        end
    end
end)

-- WalkSpeed Input
local WalkSpeedInput = Tabs.Settings:AddInput("WalkSpeed", {
    Title = "Walkspeed",
    Description = "Change your walkspeed.",
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

Fluent:Notify({
    Title = "Akelaides",
    Content = "The script has been loaded.",
    Duration = 8
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
    Title = "Akelaides",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
