if game.PlaceId == 16389395869 then
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
        SubTitle = "a Dusty Trip | By Calvin",
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
        Teleportation = Window:AddTab({ Title = "Teleportation", Icon = "compass" }),
        Miscellaneous = Window:AddTab({ Title = "Miscellaneous", Icon = "boxes" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }

    local MainTab = Tabs.Main
    local TeleportTab = Tabs.Teleportation
    local MiscTab = Tabs.Miscellaneous
    local SettingsTab = Tabs.Settings

    local sections = TeleportTab:AddSection("Plains")

    TeleportTab.AddButton({
        Title = "Teleport To 10k Meters",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            local FarPosition = Vector3.new(-18, 129, -52386)

            humanoidRootPart.CFrame = CFrame.new(FarPosition)
        end)
    })

end