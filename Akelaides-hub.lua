local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Akelaides Hub",
    Icon = 0,
    LoadingTitle = "Akelaides",
    LoadingSubtitle = "by C4LV",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = "Big Hub"
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink",
       RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
       Title = "Akelaides Hub",
       Subtitle = "Key System",
       Note = "https://pastebin.com/GtL1EQic",
       FileName = "examplehubkey",
       SaveKey = false,
       GrabKeyFromSite = false,
       Key = {"k0UwY6CJ5qg5ZWS41KB6CV1MRAYloTzR"}
    }
})

local MainTab = Window:CreateTab("Home", nil)
local MainSection = MainTab:CreateSection("Main")

Rayfield:Notify({
    Title = "Script Executed!",
    Content = "By Akelaides",
    Duration = 3.6,
    Image = nil,
})

-- Infinite Yield Button
local Button = MainTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end,
})

-- Walkspeed Slider
local Slider = MainTab:CreateSlider({
    Name = "Walkspeed",
    Range = {0, 200},
    Increment = 1,
    Suffix = "Bananas",
    CurrentValue = 16,
    Flag = "Slider1",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
    end,
})

-- WalkSpeed Input
local Input = MainTab:CreateInput({
    Name = "WalkSpeed",
    CurrentValue = "16",
    PlaceholderText = "Enter Number",
    RemoveTextAfterFocusLost = false,
    Flag = "Input1",
    Callback = function(Text)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Text)
    end,
})

-- Teleportation Buttons
local TeleportTab = Window:CreateTab("Teleportation", nil)
local Section = TeleportTab:CreateSection("Islands")

-- Button for Moosewood
local ButtonMoosewood = TeleportTab:CreateButton({
    Name = "Teleport to Moosewood",
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
local ButtonForsaken = TeleportTab:CreateButton({
    Name = "Teleport to Forsaken",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Define teleportation location for Forsaken
        local forsakenPosition = Vector3.new(-2523, 136, 1591)
        
        -- Teleport the player
        humanoidRootPart.CFrame = CFrame.new(forsakenPosition)
        print("Teleporting to Forsaken")
    end,
})

-- Button for Ancient Isles
local ButtonAncientIsles = TeleportTab:CreateButton({
    Name = "Teleport to Ancient Isles",
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

-- Stop Script Button
local ButtonStop = MainTab:CreateButton({
    Name = "Stop Script",
    Callback = function()
       Rayfield:Destroy()
    end,
})

-- Minimize Button to show FPS and Ping
local minimized = false
local fpsText = nil
local pingText = nil

local MinimizeButton = MainTab:CreateButton({
    Name = "Minimize/Show Stats",
    Callback = function()
        minimized = not minimized
        
        if minimized then
            -- Show FPS and Ping when minimized
            if not fpsText then
                fpsText = MainTab:CreateLabel("FPS: 0")
                pingText = MainTab:CreateLabel("Ping: 0")
            end

            -- Update FPS and Ping
            game:GetService("RunService").Heartbeat:Connect(function()
                if minimized then
                    -- Update FPS
                    local fps = game:GetService("Stats").PerformanceStats.FPS
                    fpsText:SetText("FPS: " .. tostring(fps))

                    -- Update Ping
                    local ping = game:GetService("Stats").Network.ServerStats.Ping
                    pingText:SetText("Ping: " .. tostring(ping) .. " ms")
                end
            end)
        else
            -- Hide stats when not minimized
            if fpsText then
                fpsText:Destroy()
                pingText:Destroy()
            end
        end
    end,
})
