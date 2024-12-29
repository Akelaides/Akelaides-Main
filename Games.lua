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
        warn("Fluent could not be loaded.")
        return
    end

    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

    local Window = Fluent:CreateWindow({
        Title = "Akelaides Hub",
        SubTitle = "Revengers Online | By Calvin",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    Window.AccentColor = Color3.fromRGB(255, 87, 51)

    local Tabs = {
        Main = Window:AddTab({ Title = "Home", Icon = "home" }),
        Player = Window:AddTab({ Title = "Player", Icon = "bot" }),
        Teleportation = Window:AddTab({ Title = "Teleportation", Icon = "compass" }),
        Miscellaneous = Window:AddTab({ Title = "Miscellaneous", Icon = "boxes" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }

    Tabs.Main:AddParagraph({
        Title = "Welcome To Akelaides!",
        Content = "Selamat Datang di Akelaides, Revengers Online. Karena ini \nmasih beta dan in progress, maaf kalo ada beberapa \nfitur yang tidak jalan baik. \nJika ada bug atau error, silahkan dihubungi kepada discord kita."
    })

    -- FPS Optimization Toggle
    local fpsBoostEnabled = false

    local function enableFPSBoost()
        local Lighting = game:GetService("Lighting")
        local Workspace = game:GetService("Workspace")

        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1
        Workspace.Terrain.WaterWaveSize = 0
        Workspace.Terrain.WaterWaveSpeed = 0
        Workspace.Terrain.WaterTransparency = 1
        Workspace.Terrain.WaterReflectance = 0

        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.CastShadow = false
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj:Destroy()
            end
        end
    end

    local function disableFPSBoost()
        local Lighting = game:GetService("Lighting")
        local Workspace = game:GetService("Workspace")

        Lighting.GlobalShadows = true
        Lighting.FogEnd = 1000
        Lighting.Brightness = 2
        Workspace.Terrain.WaterWaveSize = 0.5
        Workspace.Terrain.WaterWaveSpeed = 10
        Workspace.Terrain.WaterTransparency = 0.5
        Workspace.Terrain.WaterReflectance = 0.5
    end

    Tabs.Main:AddToggle({
        Title = "FPS Optimizer",
        Description = "Toggle FPS optimization settings.",
        Default = false,
        Callback = function(state)
            fpsBoostEnabled = state
            if state then
                enableFPSBoost()
                Fluent:Notify({
                    Title = "FPS Boost Enabled",
                    Content = "Game settings optimized for better performance.",
                    Duration = 5
                })
            else
                disableFPSBoost()
                Fluent:Notify({
                    Title = "FPS Boost Disabled",
                    Content = "Game settings reset to default.",
                    Duration = 5
                })
            end
        end
    })

    -- Teleportation Section
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local function getPlayerNames()
        local playerNames = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(playerNames, player.Name)
            end
        end
        return playerNames
    end

    local Dropdown = Tabs.Teleportation:AddDropdown("Dropdown", {
        Title = "Select Player",
        Values = getPlayerNames(),
        Multi = false,
        Default = nil
    })

    local function refreshDropdown()
        Dropdown:SetValues(getPlayerNames())
    end

    Players.PlayerAdded:Connect(refreshDropdown)
    Players.PlayerRemoving:Connect(refreshDropdown)

    Tabs.Teleportation:AddButton({
        Title = "Teleport to Player",
        Callback = function()
            local selectedPlayerName = Dropdown.Value
            if selectedPlayerName then
                local selectedPlayer = Players:FindFirstChild(selectedPlayerName)
                if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame
                    Fluent:Notify({
                        Title = "Teleport Success",
                        Content = "Teleported to " .. selectedPlayerName,
                        Duration = 5
                    })
                else
                    Fluent:Notify({
                        Title = "Teleport Failed",
                        Content = "Selected player not valid.",
                        Duration = 5
                    })
                end
            else
                Fluent:Notify({
                    Title = "Teleport Failed",
                    Content = "No player selected!",
                    Duration = 5
                })
            end
        end
    })

    -- Miscellaneous Section
    Tabs.Miscellaneous:AddButton({
        Title = "Refresh Script",
        Callback = function()
            Fluent:Notify({
                Title = "Refreshing Script",
                Content = "Reloading the latest version...",
                Duration = 3
            })

            for _, obj in ipairs(game:GetService("CoreGui"):GetChildren()) do
                if obj.Name == "AkelaidesUI" then
                    obj:Destroy()
                end
            end

            local success, err = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Akelaides/Akelaides-Main/main/Games.lua"))()
            end)

            if success then
                Fluent:Notify({
                    Title = "Script Reloaded",
                    Content = "Successfully loaded.",
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "Failed to reload script: " .. err,
                    Duration = 5
                })
            end
        end
    })

    Tabs.Miscellaneous:AddButton({
        Title = "Load Infinite Yield",
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
