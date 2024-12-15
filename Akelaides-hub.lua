local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Akelaides Hub " .. Fluent.Version,
    SubTitle = "by calvin",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark", "Amethyst", "Aqua",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Home", Icon = "home" }),
    Autofarm = Window:AddTab({ Title = "Autofarm", Icon = "hammer" }),
    Teleportation = Window:AddTab({ Title = "Teleportation", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Teleportation Dropdown
local TeleportDropdown = Tabs.Teleportation:AddDropdown("TeleportationDropdown", {
    Title = "Select Island to Teleport",
    Description = "Teleport to an island.",
    Values = { "Moosewood", "Forsaken", "Ancient Isles" },
    Multi = false,
    Default = 1
})

-- Handle teleportation
TeleportDropdown:OnChanged(function(Value)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local positions = {
        Moosewood = Vector3.new(400, 135, 250),
        Forsaken = Vector3.new(-2497, 137, 1627),
        ["Ancient Isles"] = Vector3.new(6000, 200, 300)
    }

    if positions[Value] then
        humanoidRootPart.CFrame = CFrame.new(positions[Value])
        print("Teleporting to " .. Value)
    end
end)

-- Auto-cast mode dropdown
local AutoCastModeDropdown = Tabs.Autofarm:AddDropdown("AutoCastModeDropdown", {
    Title = "Select Auto Cast Mode",
    Description = "Choose the AutoCast mode.",
    Values = { "Legit", "Rage" },
    Multi = false,
    Default = 1
})

local autoCast = false
local autoCastDelay = 0.1
local autoCastMode = "Legit"  -- Default mode

AutoCastModeDropdown:OnChanged(function(Value)
    autoCastMode = Value
    print("Auto Cast Mode set to:", autoCastMode)
end)

-- Auto-cast toggle
local autoCastToggle = Tabs.Autofarm:AddToggle("AutoCast", { Title = "Auto Cast", Default = false })
autoCastToggle:OnChanged(function(Value)
    autoCast = Value
    print("Auto Cast:", autoCast)
end)

-- Auto-reel toggle
local autoReel = false
local autoReelDelay = 0.1
local autoReelToggle = Tabs.Autofarm:AddToggle("AutoReel", { Title = "Auto Reel", Default = false })
autoReelToggle:OnChanged(function(Value)
    autoReel = Value
    print("Auto Reel:", autoReel)
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

-- Auto-Reel and Auto-Shake connection
local PlayerGUI = game.Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

PlayerGUI.ChildAdded:Connect(function(GUI)
    if GUI:IsA("ScreenGui") and GUI.Name == "shakeui" then
        if GUI:FindFirstChild("safezone") then
            GUI.safezone.ChildAdded:Connect(function(child)
                if child:IsA("ImageButton") and child.Name == "button" and autoCast then
                    if child.Visible then
                        if autoCastMode == "Legit" then
                            local pos = child.AbsolutePosition
                            local size = child.AbsoluteSize
                            VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, true, game.Players.LocalPlayer, 0)
                            VirtualInputManager:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, false, game.Players.LocalPlayer, 0)
                        elseif autoCastMode == "Rage" then
                            local rod = game.Players.LocalPlayer.Character:FindFirstChild("Flimsy Rod")
                            if rod then
                                rod.events.cast:FireServer(100)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Connect to SaveManager and InterfaceManager
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
