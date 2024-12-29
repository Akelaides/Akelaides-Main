if game.PlaceId == 14330243992 then
    local FluentSuccess, Fluent = pcall(function()
        return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)

    if FluentSuccess and Fluent then
        Fluent:Notify({
            Title = "Akelaides",
            Content = "Akelaides Loaded Successfully!",
            Duration = 3
        })
    else
        if Fluent then
            Fluent:Notify({
                Title = "Akelaides",
                Content = "Akelaides failed to load.",
                Duration = 3
            })
        else
            warn("Fluent could not be loaded.")
        end
        return -- Exit the script since Fluent failed to load
    end

    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

    local Window = Fluent:CreateWindow({
        Title = "Akelaides Hub " .. "",  -- Fixed version if Fluent.Version is unavailable
        SubTitle = "Power Slap Simulator | By Calvin",
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
        Autofarm = Window:AddTab({ Title = "Automatic", Icon = "bot"}),
        Teleportation = Window:AddTab({ Title = "Teleportation", Icon = "compass" }),
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
    local initialized = false -- New variable to track initialization

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
    local ToggleAntiAFK = MiscTab:AddToggle("Anti-AFK", { Title = "Enable Anti-AFK", Default = false })

    ToggleAntiAFK:OnChanged(function(antiAFKState)
        -- Prevent unnecessary notifications on initialization
        if not initialized then
            initialized = true
            return
        end

        antiAFKEnabled = antiAFKState
        if antiAFKEnabled then
            startAntiAFK()
            Fluent:Notify({
                Title = "Anti-AFK Enabled",
                Content = "You will no longer be marked as AFK.",
                Duration = 4
            })
        else
            stopAntiAFK()
            Fluent:Notify({
                Title = "Anti-AFK Disabled",
                Content = "You are now allowed to be AFK.",
                Duration = 4
            })
        end
    end)

    -- Main Section

    local section = MainTab:AddSection("Introduction")

    MainTab:AddParagraph({
        Title = "Akelaides",
        Content = "Thank you for using akelaides, as of now We are still in BETA and hope \nto expand our community to other games! We apologize for \nAny features that are experiencing errors. "
    })

    local section = MainTab:AddSection("Our Discord")
    MainTab:AddButton({
        Title = "Join Akelaides Discord",
        Description = " Click To Copy https://discord.gg/SE8fDd6YcC",
        Callback = function()
            setclipboard("https://discord.gg/SE8fDd6YcC")
            
            Fluent:Notify({
                Title = "Link Copied",
                Content = "The Discord link has been copied to your clipboard.",
                Duration = 4
            })
        end
    })

    local sections = AutofarmTab:AddSection("Auto Farm")
    local Input = AutofarmTab:AddInput("AutofarmValue", {
        Title = "Autofarm Click Value",
        Description = "Change How many Slaps per Click",
        Default = "1",
        Placeholder = "Enter your Value",
        Numeric = false, 
        Finished = false,
        Callback = function(Value)
            getgenv().farmValue = tonumber(Value) or 1
            Fluent:Notify({
                Title = "Autofarm Value Changed",
                Content = "Autofarm value set to: " .. tostring(getgenv().farmValue),
                Duration = 4
            })
        end
    })

    -- Toggle for Autofarm
    if getgenv().farmer == nil then
        getgenv().farmer = false -- Initialize only if it doesn't exist
    end

    local Toggle = AutofarmTab:AddToggle("Autofarm", {Title = "Autofarm", Default = getgenv().farmer})

    Toggle:OnChanged(function(State)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        -- Check if the state has actually changed to avoid redundant notifications
        if getgenv().farmer ~= State then
            getgenv().farmer = State

            if State then
                Fluent:Notify({
                    Title = "Autofarm Enabled",
                    Content = "Autofarm has been activated.",
                    Duration = 4
                })
            else
                Fluent:Notify({
                    Title = "Autofarm Disabled",
                    Content = "Autofarm has been deactivated.",
                    Duration = 4
                })
            end
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

    local sections = AutofarmTab:AddSection("Automatic")
    local Toggle = Tabs.Autofarm:AddToggle("AutoRebirth", {Title = "Auto Rebirth", Default = false})

    local isFirstRun = true  -- Variable to check if it's the first time the script is loading

Toggle:OnChanged(function(state)
    getgenv().rebirth = state

    -- Prevent notifying during the initial loading phase
    if isFirstRun then
        isFirstRun = false  -- Set to false after the first run
        return  -- Exit the function early, so no notification is sent
    end

    if getgenv().rebirth then
        while getgenv().rebirth do
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Rebirth"):FireServer()
            wait(0.1)

            if getgenv().rebirth ~= state then
                getgenv().rebirth = state
            end
        end
    end

    -- Notify only after the toggle state has changed
    if state then
        Fluent:Notify({
            Title = "Auto Rebirth",
            Content = "Auto Rebirth Enabled.",
            Duration = 4
        })
    else 
        Fluent:Notify({
            Title = "Auto Rebirth",
            Content = "Auto Rebirth Disabled.",
            Duration = 4
        })
    end
end)

-- Existing code...

local VirtualInputManager = game:GetService("VirtualInputManager") -- For simulating input
local holdAndClickToggle = AutofarmTab:AddToggle("Hold E and Spam Click", {Title = "Auto Battle", Default = false})

local spamClicking = false
local spamInterval = 0.1 -- Time between clicks (adjust as needed)

-- Function to simulate holding "E" for 2 seconds
local function holdEKey()
    -- Simulate pressing "E"
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    wait(2)  -- Hold for 2 seconds
    -- Simulate releasing "E"
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- Function to simulate spam clicking for 5 seconds
local function startSpamClick()
    local endTime = tick() + 5  -- Set the end time for 5 seconds from now
    while tick() < endTime do
        -- Simulate mouse click
        VirtualInputManager:SendMouseButtonEvent(500, 300, 0, true, nil, 0) -- Mouse Down
        VirtualInputManager:SendMouseButtonEvent(500, 300, 0, false, nil, 0) -- Mouse Up
        wait(spamInterval) -- Wait before the next click
    end
end

-- Function to check for the presence of the "E" prompt (customize to suit your game's UI)
local function isPromptVisible()
    -- You may need to replace this with actual logic for detecting the "E" prompt in your game
    -- For example, checking for a UI element or screen overlay that shows the "E" prompt
    local promptUI = game.Players.LocalPlayer.PlayerGui:FindFirstChild("PromptE")
    return promptUI and promptUI.Visible
end

-- Main loop to repeat the action when the "E" prompt is visible
local function repeatAction()
    while holdAndClickToggle:Get() do
        if isPromptVisible() then
            holdEKey()  -- Hold the "E" key for 2 seconds
            startSpamClick()  -- Start spam clicking for 5 seconds
            Fluent:Notify({
                Title = "Action Complete",
                Content = "Held 'E' for 2 seconds and spam clicked for 5 seconds.",
                Duration = 4
            })
            wait(1)  -- Wait a little before checking again (to prevent too rapid repeat)
        end
        wait(0.1)  -- Check every 0.1 seconds if the prompt is visible
    end
end

holdAndClickToggle:OnChanged(function(state)
    if state then
        -- Start the repeat loop when the toggle is enabled
        repeatAction()
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

    TeleportTab:AddButton({
        Title = "Teleport To Anime Island",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            local animePosition = Vector3.new(-168, 17, -1071)

            humanoidRootPart.CFrame = CFrame.new(animePosition)

            Fluent:Notify({
                Title = "Teleportation",
                Content = "Teleported To Anime!",
                Duration = 3
            })
        end,
    })

    TeleportTab:AddButton({
        Title = "Teleport to Desert Island",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            local desertPosition = Vector3.new(-167, 15, -1383)
            
            humanoidRootPart.CFrame = CFrame.new(desertPosition)
            Fluent:Notify({
                Title = "Teleportation",
                Content = "Teleported To Desert!",
                Duration = 3
            })
        end,
    })

    TeleportTab:AddButton({
        Title = "Teleport To Underworld",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            local underworldPosition = Vector3.new(-167, 15, -1719)

            humanoidRootPart.CFrame = CFrame.new(underworldPosition)
            Fluent:Notify({
                Title = "Teleportation",
                Content = "Teleported To Underworld",
                Duration = 3
            })
        end,
    })

    TeleportTab:AddButton({
        Title = "Teleport To Luck",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            local LuckPosition = Vector3.new(-168, 15, -2041)

            humanoidRootPart.CFrame = CFrame.new(LuckPosition)
            Fluent:Notify({
                Title = "Teleportation",
                Content = "Teleported To Luck Island",
                Duration = 3
            })
        end,   
    })

    TeleportTab:AddButton({
        Title = "Teleport to Ice Island",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            local IcePosition = Vector3.new(-169, 17, -2356)

            humanoidRootPart.CFrame = CFrame.new(IcePosition)
            Fluent:Notify({
                Title = "Teleportation",
                Content = "Teleported To Ice Island",
                Duration = 3
            })
        end,
    })

    TeleportTab:AddButton({
        Title = "Teleport to Volcano Island",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            local volcanoPosition = Vector3.new(-168, 15, -2685)

            humanoidRootPart.CFrame = CFrame.new(volcanoPosition)
            Fluent:Notify({
                Title = "Teleportation",
                Content = "Teleported to Volcano",
                Duration = 3
            })
        end
    })

    TeleportTab:AddButton({
        Title = "Teleport to Mars Island",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            local marsPosition = Vector3.new(-169, 16, -3052)

            humanoidRootPart.CFrame = CFrame.new(marsPosition)
            Fluent:Notify({
                Title = "Teleportation",
                Content = "Teleported to Mars",
                Duration = 3
            })
        end
    })

    TeleportTab:AddButton({
        Title = "Teleport to Robot Island",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            local robotPosition = Vector3.new(-180, 16, -3419)

            humanoidRootPart.CFrame = CFrame.new(robotPosition)
            Fluent:Notify({
                Title = "Teleportation",
                Content = "Teleported to Robot Island",
                Duration = 3
            })
        end
    })

    TeleportTab:AddButton({
        Title = "Teleport to Pyramid Island",
        Description = "The Last Island",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            local pyramidPosition = Vector3.new(-179, 14, -3797)

            humanoidRootPart.CFrame = CFrame.new(pyramidPosition)
            Fluent:Notify({
                Title = "Teleportation",
                Content = "Teleported to Pyramid Island",
                Duration = 3
            })
        end
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

end
