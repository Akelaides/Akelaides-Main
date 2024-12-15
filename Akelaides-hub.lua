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

local Options = Fluent.Options

-- Fishing Tab
local FishingTab = Window:CreateTab("Main")

local loopEnabled = false
local function resizeButtonLoop()
    while loopEnabled do
        local buttonPath = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            and game.Players.LocalPlayer.PlayerGui:FindFirstChild("shakeui")
            and game.Players.LocalPlayer.PlayerGui.shakeui:FindFirstChild("safezone")
            and game.Players.LocalPlayer.PlayerGui.shakeui.safezone:FindFirstChild("button")

        if buttonPath then
            buttonPath.Size = UDim2.new(0, 2000, 0, 2000)
            buttonPath.BackgroundTransparency = 1
        else
            print("did not find a button in the path!?!?")
        end
        wait(0.01)
    end
end

FishingTab:CreateToggle({
    Name = "Change Shake Size",
    CurrentValue = false,
    Flag = "ToggleResize",
    Callback = function(Value)
        loopEnabled = Value
        if loopEnabled then
            resizeButtonLoop()
        end
    end,
})

FishingTab:CreateButton({
    Name = "Perfect Cast",
    Callback = function()
        local args = {
            [1] = 100,
            [2] = 2
        }
        local rod = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Flimsy Rod")
        if rod then
            rod.events.cast:FireServer(unpack(args))
        else
            warn("Flimsy Rod not found in character.")
        end
    end
})

FishingTab:CreateButton({
    Name = "Perfect Reel",
    Callback = function()
        local args = {
            [1] = 100,
            [2] = true
        }
        local reelfinished = game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("reelfinished")
        reelfinished:FireServer(unpack(args))
    end
})

local clickingEnabled = false

local function startClicking()
    while clickingEnabled do
        local button = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TargetButton")
        if button and button:IsA("TextButton") then
            button.MouseButton1Click:Fire()
        end
        wait(0.1)
    end
end

FishingTab:CreateToggle({
    Name = "Auto GUI Click",
    CurrentValue = false,
    Flag = "AutoClickToggle",
    Callback = function(Value)
        clickingEnabled = Value
        if clickingEnabled then
            startClicking()
        end
    end,
})

local farmEnabled = false

local function startAutoFarm()
    while farmEnabled do
        local rod = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Flimsy Rod")
        if rod then
            local castArgs = { [1] = 100, [2] = 2 }
            rod.events.cast:FireServer(unpack(castArgs))
        else
            warn("Flimsy Rod not equipped.")
            break
        end

        local shakeGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("shakeui")
        if shakeGui then
            repeat wait(0.1) until not shakeGui or not shakeGui:FindFirstChild("safezone") or not shakeGui.safezone:FindFirstChild("button") or not shakeGui.safezone.button.Visible
        end

        local reelGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("reel")
        if reelGui then
            wait(1)
            while reelGui and farmEnabled do
                local reelArgs = { [1] = 100, [2] = true }
                local reelfinished = game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("reelfinished")
                reelfinished:FireServer(unpack(reelArgs))
                wait(0.1)
                reelGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("reel")
            end
        end
        wait(1)
    end
end

FishingTab:CreateToggle({
    Name = "Enable Auto-Farm",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(Value)
        farmEnabled = Value
        if farmEnabled then
            startAutoFarm()
        end
    end,
})

-- Auto Cast Mode Dropdown
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
