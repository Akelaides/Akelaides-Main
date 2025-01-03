if game.PlaceId == 10822399154 then
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
        SubTitle = "Revengers Online| By Calvin",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,  -- Keep this true for the acrylic effect
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    -- Optional: Adjust the background color and transparency for better visibility
    Window.BackgroundColor3 = Color3.fromRGB(35, 35, 35)  -- Dark background color
    Window.BackgroundTransparency = 0.5  -- Adjust transparency to enhance the acrylic effect

    Window.AccentColor = Color3.fromRGB(255, 87, 51)

    local Tabs = {
        Main = Window:AddTab({ Title = "Home", Icon = "home", TabColor = Color3.fromRGB(255, 87, 51) }),
        Player = Window:AddTab({ Title = "Player", Icon = "bot", TabColor = Color3.fromRGB(255, 87, 51) }),
        Teleportation = Window:AddTab({ Title = "Teleportation", Icon = "compass", TabColor = Color3.fromRGB(255,87, 51) }),
        Miscellaneous = Window:AddTab({ Title = "Miscellaneous", Icon = "boxes", TabColor = Color3.fromRGB(255, 87, 51) }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings", TabColor = Color3.fromRGB(255, 87, 51) })
    }

    local MainTab = Tabs.Main
    local PlayerTab = Tabs.Player
    local TeleportTab = Tabs.Teleportation
    local MiscTab = Tabs.Miscellaneous
    local SettingsTab = Tabs.Settings

    local section = MainTab:AddSection("Introduction")
    
    Tabs.Main:AddParagraph({
        Title = "Welcome To Akelaides!",
        Content = "Selamat Datang di Akelaides, Revengers Online. Karena ini \nmasih beta dan in progress, maaf kalo ada beberapa \nfitur yang tidak jalan baik. \n Jika ada bug atau error, silahkan dihubungi kepada discord kita."
    })
    local section = MainTab:AddSection("Others")
    Tabs.Main:AddParagraph({
        Title = "lem is gay",
        Content = "lem is gay \nlem is gay \nlem is gay \nlem is gay \nlem is gay \nlem is gay \nlem is gay \nlem is gay \nlem is gay \nlem is gay \nlem is gay \nlem is gay \nlem is gay..."
    })

    local section = TeleportTab:AddSection("Teleport To Players")

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    

    -- Function to get the list of players' names
    local function getPlayerNames()
        local playerNames = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then -- Exclude the local player from the list
                table.insert(playerNames, player.Name)
            end
        end
        return playerNames
    end
    
    -- Create Dropdown
    local Dropdown = Tabs.Teleportation:AddDropdown("Dropdown", {
        Title = "Player List",
        Values = getPlayerNames(),
        Multi = false,
        Default = 1,
    })
    
    -- Function to refresh dropdown values
    local function refreshDropdown()
        Dropdown.Values = getPlayerNames()
        if #Dropdown.Values > 0 then
            Dropdown:SetValue(Dropdown.Values[1]) -- Set default to the first player if the list is not empty
        else
            Dropdown:SetValue(nil) -- Clear selection if no players are available
        end
    end
    
    -- Update Dropdown when players join or leave
    Players.PlayerAdded:Connect(function()
        refreshDropdown()
    end)
    
    Players.PlayerRemoving:Connect(function()
        refreshDropdown()
    end)
    
    -- Add Teleport Button
    Tabs.Teleportation:AddButton({
        Title = "Teleport to Player",
        Description = "Teleports you to the selected player.",
        Callback = function()
            local selectedPlayerName = Dropdown.Value -- Get the currently selected player
            if selectedPlayerName then
                local selectedPlayer = Players:FindFirstChild(selectedPlayerName)
                if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    -- Teleport the local player to the selected player's position
                    local targetPosition = selectedPlayer.Character.HumanoidRootPart.Position
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                        Fluent:Notify({
                            Title = "Teleport Success",
                            Content = "You have been teleported to " .. selectedPlayerName .. ".",
                            Duration = 5,
                        })
                    else
                        Fluent:Notify({
                            Title = "Teleport Failed",
                            Content = "Your character is missing its HumanoidRootPart.",
                            Duration = 5,
                        })
                    end
                else
                    Fluent:Notify({
                        Title = "Teleport Failed",
                        Content = "Selected player's character is not valid for teleportation.",
                        Duration = 5,
                    })
                end
            else
                Fluent:Notify({
                    Title = "Teleport Failed",
                    Content = "No player selected!",
                    Duration = 5,
                })
            end
        end,
    })
    

    
    Tabs.Miscellaneous:AddButton({
        Title = "Infinite Yield",
        Description = "Loads Infinite Yield",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end
    })

    -- Slider to adjust the hitbox size
-- Slider to adjust the hitbox size
-- Slider to adjust the hitbox size
local HitboxSlider = Tabs.Main:AddSlider("HitboxSlider", { 
    Title = "Adjust Hitbox Size", 
    Description = "Use this slider to adjust the hitbox size", 
    Default = 2.0, 
    Min = 0.0, 
    Max = 15.5, 
    Rounding = 1 
})

-- Function to update hitboxes based on the expanded state and size
local function updateHitboxes(expanded, size)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character

            -- Adjust the size of the hitbox (expand it or reset it)
            if expanded then
                -- Expand hitbox size based on slider value
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("Part") then
                        part.Size = part.Size * size -- Apply the slider value to adjust size
                        part.Transparency = 0.5
                        part.CanCollide = true  -- Ensure CanCollide is true to prevent phasing
                    end
                end
            else
                -- Reset to default size
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("Part") then
                        part.Size = Vector3.new(2, 2, 1) -- Default size (adjust if different)
                        part.Transparency = 0
                        part.CanCollide = true  -- Keep CanCollide as true for default hitbox
                    end
                end
            end
        end
    end

    Fluent:Notify({
        Title = expanded and "Hitboxes Expanded" or "Hitboxes Reset",
        Content = expanded and "Player hitboxes have been expanded." or "Player hitboxes have been reset to default.",
        Duration = 5
    })
end

-- Toggle for expanding hitboxes
local Toggle = Tabs.Main:AddToggle("HitboxToggle", {
    Title = "Expand Hitboxes",
    Default = false
})

-- Adjust hitbox size when the toggle state changes
Toggle:OnChanged(function(state)
    local size = HitboxSlider.Value  -- Get the current slider value
    updateHitboxes(state, size)  -- Pass the toggle state (expanded or not) and the slider size
end)

-- Adjust hitbox size when the slider value changes
HitboxSlider.OnChanged = function(value)
    local expanded = Toggle:GetState()  -- Get the current state of the toggle (whether it's expanded or not)
    updateHitboxes(expanded, value)    -- Update hitboxes with the current toggle state and slider value
end



    
    

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