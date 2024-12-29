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
    
    -- Variables to store the toggle state
local fpsBoostEnabled = false

-- Function to apply FPS optimization
local function enableFPSBoost()
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")

    -- Ignore Other Characters
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            player.Character:Destroy()
        end
    end

    -- Optimize Lighting
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
    for _, effect in ipairs(Lighting:GetDescendants()) do
        if effect:IsA("PostEffect") then
            effect:Destroy()
        end
    end

    -- Lower Rendering and Quality
    Workspace.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled
    for _, instance in ipairs(Workspace:GetDescendants()) do
        if instance:IsA("BasePart") then
            instance.Material = Enum.Material.SmoothPlastic
            instance.CastShadow = false
        elseif instance:IsA("ParticleEmitter") or instance:IsA("Trail") then
            instance:Destroy()
        elseif instance:IsA("MeshPart") then
            instance.RenderFidelity = Enum.RenderFidelity.Performance
        end
    end

    -- Remove Clothes and Accessories
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            for _, obj in ipairs(player.Character:GetDescendants()) do
                if obj:IsA("Clothing") or obj:IsA("Accessory") then
                    obj:Destroy()
                end
            end
        end
    end

    -- Optimize Water Graphics
    Workspace.Terrain.WaterWaveSize = 0
    Workspace.Terrain.WaterWaveSpeed = 0
    Workspace.Terrain.WaterTransparency = 1
    Workspace.Terrain.WaterReflectance = 0
end

-- Function to reset FPS settings
local function disableFPSBoost()
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")

    -- Reset Lighting
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 1000
    Lighting.Brightness = 2

    -- Reset Water Graphics
    Workspace.Terrain.WaterWaveSize = 0.5
    Workspace.Terrain.WaterWaveSpeed = 10
    Workspace.Terrain.WaterTransparency = 0.5
    Workspace.Terrain.WaterReflectance = 0.5
end

-- Add Toggle to UI
Tabs.Main:AddToggle({
    Title = "FPS Optimizer",
    Description = "Toggle FPS optimization settings.",
    Default = false, -- Default state is off
    Callback = function(state)
        fpsBoostEnabled = state -- Update the toggle state

        if fpsBoostEnabled then
            enableFPSBoost()
            Fluent:Notify({
                Title = "FPS Boost Enabled",
                Content = "Game settings optimized for better performance.",
                Duration = 5,
            })
        else
            disableFPSBoost()
            Fluent:Notify({
                Title = "FPS Boost Disabled",
                Content = "Game settings reset to default.",
                Duration = 5,
            })
        end
    end,
})


    local section = TeleportTab:AddSection("Teleport To Players")

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    -- Function to get the list of players' names
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
        Title = "Select Player",
        Values = getPlayerNames(),
        Multi = false,
        Default = 1,
    })
    
    -- Function to refresh dropdown values
    local function refreshDropdown()
        local updatedValues = getPlayerNames()
        Dropdown:SetValues(updatedValues) -- Update the dropdown's values dynamically
        if #updatedValues > 0 then
            Dropdown:SetValue(updatedValues[1]) -- Set default to the first player if the list is not empty
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
    
    -- Create Teleport Button
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
    
    MiscTab:AddButton({
        Title = "Refresh Script",
        Description = "Reloads the latest version of the script.",
        Callback = function()
            -- Notify the user about the reload process
            Fluent:Notify({
                Title = "Refreshing Script",
                Content = "Reloading the latest version...",
                Duration = 3,
            })
    
            -- Destroy the current UI
            for _, obj in ipairs(game:GetService("CoreGui"):GetChildren()) do
                if obj.Name == "AkelaidesUI" then -- Replace "AkelaidesUI" with your UI's actual name
                    obj:Destroy()
                end
            end
    
            -- Load the latest version of the script
            local success, errorMessage = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Akelaides/Akelaides-Main/main/Games.lua"))()
            end)
    
            -- Notify user of success or failure
            if success then
                Fluent:Notify({
                    Title = "Script Reloaded",
                    Content = "The latest version has been successfully loaded.",
                    Duration = 5,
                })
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "Failed to reload the script: " .. errorMessage,
                    Duration = 5,
                })
            end
        end,
    })
    

    MiscTab:AddButton({
        Title = "Load Infinite Yield",
        Description = "Loads Infinite Yield script",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() 
        end
    })

     
    

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