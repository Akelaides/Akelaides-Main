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
    Description = "Use this slider to adjust the hitbox size for attacks", 
    Default = 2.0, 
    Min = 1.0, 
    Max = 15.0, 
    Rounding = 1 
})

local Toggle = Tabs.Main:AddToggle("HitboxToggle", {
    Title = "Enable Hitbox Expansion",
    Default = false
})

local hitboxParts = {} -- Table to store visual hitbox parts

-- Function to create or update the hitbox on HumanoidRootPart
local function updateHitboxes(expanded, size)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart

            if expanded then
                -- Create a grey transparent box if it doesn't exist
                if not hitboxParts[player] then
                    local hitbox = Instance.new("Part")
                    hitbox.Size = Vector3.new(size, size, size)
                    hitbox.Transparency = 0.5 -- Semi-transparent
                    hitbox.BrickColor = BrickColor.Gray() -- Grey color
                    hitbox.Anchored = true
                    hitbox.CanCollide = false
                    hitbox.Name = "Hitbox"
                    hitbox.Parent = humanoidRootPart -- Attach the hitbox as a child of HumanoidRootPart
                    hitboxParts[player] = hitbox
                end

                -- Update the hitbox size and position
                local hitbox = hitboxParts[player]
                hitbox.Size = Vector3.new(size, size, size)
                hitbox.CFrame = humanoidRootPart.CFrame
            else
                -- Remove the hitbox if it exists
                if hitboxParts[player] then
                    hitboxParts[player]:Destroy()
                    hitboxParts[player] = nil
                end
            end
        end
    end

    Fluent:Notify({
        Title = expanded and "Hitboxes Expanded" or "Hitboxes Hidden",
        Content = expanded and ("Hitboxes expanded to size " .. size .. ".") or "Hitboxes have been hidden.",
        Duration = 5
    })
end

-- Connect slider to hitbox updates
HitboxSlider:OnChanged(function(size)
    if Toggle.Value then
        updateHitboxes(true, size)
    end
end)

-- Connect toggle to enable or disable hitbox expansion
Toggle:OnChanged(function(expanded)
    local size = HitboxSlider.Value
    updateHitboxes(expanded, size)
end)

-- Cleanup on player removal
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if hitboxParts[player] then
        hitboxParts[player]:Destroy()
        hitboxParts[player] = nil
    end
end)




    
    

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