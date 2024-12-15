local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Akelaides Hub" .. Fluent.Version,
    SubTitle = "Staff",  -- Changed to "by calvin"
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Teleportation = Window:AddTab({ Title = "Teleportation", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

--Locals

local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character
local humanoidRootPart = LocalCharacter:FindFirstChild("HumanoidRootPart")
local PlayerGUI = LocalPlayer:FindFirstChild("PlayerGui")

-- Variables

local autoShake = false
local autoShakeDelay = 0.1
local autoShakeMethod = "KeyCodeEvent"
local autoShakeClickOffsetX = 0
local autoShakeClickOffsetY = 0
local autoReel = false
local autoReelDelay = 2
local autoCast = false
local autoCastMode = "Legit"
local autoCastDelay = 2
local zoneCast = false
local Zone = "Brine Pool"
local Noclip = false
local AntiDrown = false
local Target
local FreezeChar = false

local Options = Fluent.Options

-- Teleportation Dropdown
local TeleportDropdown = Tabs.Teleportation:AddDropdown("TeleportationDropdown", {
    Title = "Select Island to Teleport",
    Values = {
        "Moosewood",
        "Forsaken",
        "Ancient Isle"
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
        local ancientIslesPosition = Vector3.new(6059, 195, 284)
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

local Toggle = Tabs.Main:AddToggle("AutoReel", {Title = "Auto Reel", Default = false })

    AutoReel:OnChanged(function()
        autoreelandshakeConnection = PlayerGui.ChildAdded:Connect(function(GUI)
            if GUI:IsA("ScreenGui") and GUI.Name == "shakeui" then
                GUI.safezone.ChildAdded:Connect(function(child)
                    if child:isA("ImageButton") and child.name == "button" then
                        if autoShake == true then
                            task.wait(autoShakeDelay)
                            if child.visible == true then
                                if autoShakeMethod == "ClickEvent" then
                                    local pos = child.AbsolutePosition
                                    local size = child.AbsoluteSize
                                    VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2,0, true, LocalPlayer, 0)
                                    VirtualInputManager:SeondMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, false, LocalPlayer, 0)
                                --[[elseif autoShakeMethod == "firesignal" then
                                    firesignal(child.MouseButton1Click)]]
                                elseif autoShakeMethod == "KeyCodeEvent" then
                                    while WaitForSomeone(RenderStepped) do
                                        if autoShake and GUI.safezone:FindFirstChild(child.Name) ~= nil then
                                            task.wait()
                                            pcall(function()
                                                GuiService.SelectedObject = child
                                                if GuiService.SelectedObject = child then
                                                    VirtualInputManager:SendKeyEvent(true, Enum.Keycode.Return, false, game)
                                                    VirtualInputManager:SendKeyEvent(false, Enum.Keycode.Return, false, game)
                                                end
                                        end)
                                    else
                                        GuiService.SelectedObject = nil
                                        break
                                    end
                                end
                        end
                    end
            end
    end)
    if Gui:IsA("ScreenGui") and GUI.Name == "reel" then
        if autoReel and ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished") ~= nil then
            repeat task.wait(autoReelDelay) ReplicatedStorage.events.reelfinished:FireServer(100, false) until GUI == nil
        end
    end

    autoCastConnection == LocalCharacter.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and child:FindFirstChild("events"):WaitForChild("cast") ~= nil and autoCast then
            task.wait(autoCastDelay)
            if autoCastMode == "Legit" then
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, LocalPlayer, 0)
                HumanoidRootPart.ChildAdded:Connect(function()
                    if humanoidRootPart:FindFirstChild("power") ~= nil and HumanoidRootPart.power.powerbar.bar ~= nil then
                        humanoidRootPart.power.powerbar.bar.Changed:Connect(function(property)
                            if property == "Size" then
                                if humanoidRootPart =.power.powerbar.bar.size == UDim2.new(1, 0, 1, 0) then
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

    autoCastConnection2 = PlayerGUI.ChildRemoved:Connect(function(GUI)
        local Tool = LocalCharacter:FindFirstChildOfClass("Tool")
        if GUI.Name == "reel" and autoCast == true and Tool ~= nil and Tool:FindFirstChild("events"): WaitForChild("cast") ~= nil then
            task.wait(autoCastDelay)
            if autoCastMode == "Legit" hten
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, LocalPlayer, 0)
        end
    end)
    Options.MyToggle:SetValue(false)

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
    Title = "Akelaides",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
