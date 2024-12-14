local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Akelaides Hub",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Akelaides",
    LoadingSubtitle = "by C4LV",
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "Big Hub"
    },
    Discord = {
       Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
    KeySystem = true, -- Set this to true to use our key system
    KeySettings = {
       Title = "Akelaides Hub",
       Subtitle = "Key System",
       Note = "https://pastebin.com/GtL1EQic", -- Use this to tell the user how to get a key
       FileName = "examplehubkey", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"https://pastebin.com/raw/GtL1EQic"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
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
    Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
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

-- Teleportation Dropdown
local TeleportTab = Window:CreateTab("Teleportation", nil)
local Section = TeleportTab:CreateSection("Islands")
local Dropdown = TeleportTab:CreateDropdown({
    Name = "Teleport Island",
    Options = {"Moosewood", "Forsaken", "Ancient Isles"},
    CurrentOption = {"Moosewood"},
    MultipleOptions = false,
    Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Options)
        if Options == "Moosewood" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(400, 135, 250)  -- Example coordinates for Moosewood
        elseif Options == "Forsaken" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2750, 130, 1450)  -- Example coordinates for Forsaken
        elseif Options == "Ancient Isles" then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(6000, 200, 300)  -- Example coordinates for Ancient Isles
        end
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
                    fpsText:SetText("FPS: " .. tostring(game:GetService("Stats").PerformanceStats.FPS))
                    pingText:SetText("Ping: " .. tostring(game:GetService("Stats").PerformanceStats.Ping))
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
