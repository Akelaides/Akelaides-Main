if not game:FindFirstChild("Window") then

    if game.PlaceId == 14330243992 then

        local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
        
        if not Fluent then
            Fluent:Notify({
                Title = "Akelaides",
                Content = "Akelaides failed to load..",
                Duration = 3
            })
            return
        else
            Fluent:Notify({
                Title = "Akelaides",
                Content = "Akelaides Loaded Successfully!",
                Duration = 3
            })
        end

        local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
        local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

        local Window = Fluent:CreateWindow({
            Title = "Akelaides Hub",
            SubTitle = "Power Slap Simulator | By Calvin",
            TabWidth = 160,
            Size = UDim2.fromOffset(580, 460),
            Acrylic = true,
            Theme = "Dark",
            MinimizeKey = Enum.KeyCode.LeftControl
        })

        local Tabs = {
            Main = Window:AddTab({ Title = "Home", Icon = "home" }),
            Autofarm = Window:AddTab({ Title = "Automatic", Icon = "plane" }),
            Teleportation = Window:AddTab({ Title = "Teleportation", Icon = "compass" }),
            Miscellaneous = Window:AddTab({ Title = "Miscellaneous", Icon = "boxes" }),
            Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
        }

        local MainTab = Tabs.Main
        local AutofarmTab = Tabs.Autofarm
        local TeleportTab = Tabs.Teleportation
        local MiscTab = Tabs.Miscellaneous
        local SettingsTab = Tabs.Settings

        -- **Anti-AFK Logic**
        local RunService = game:GetService("RunService")
        local player = game.Players.LocalPlayer
        local antiAFKEnabled = false
        local antiAFKConnection

        local function startAntiAFK()
            antiAFKConnection = RunService.RenderStepped:Connect(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid:Move(Vector3.new(0, 0, 0), true)
                    wait(0.1)
                end
            end)
        end

        local function stopAntiAFK()
            if antiAFKConnection then
                antiAFKConnection:Disconnect()
                antiAFKConnection = nil
            end
        end

        local ToggleAntiAFK = MiscTab:AddToggle("Anti-AFK", { Title = "Enable Anti-AFK", Default = false })

        ToggleAntiAFK:OnChanged(function(antiAFKState)
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

        -- **Autofarm Toggle**
        local Toggle = AutofarmTab:AddToggle("Autofarm", { Title = "Autofarm", Default = false })
        local farmerRunning = false

        Toggle:OnChanged(function(State)
            getgenv().farmer = State

            if getgenv().farmer and not farmerRunning then
                farmerRunning = true
                while getgenv().farmer do
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Client"):InvokeServer("ClickStat", 1)
                    task.wait(0.01)
                end
                farmerRunning = false
            end
        end)

        -- **Teleports**
        TeleportTab:AddButton({
            Title = "Teleport to Escape Island",
            Callback = function()
                local escapePosition = Vector3.new(-167, 17, -100)
                local humanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
                humanoidRootPart.CFrame = CFrame.new(escapePosition)
                Fluent:Notify({ Title = "Teleportation", Content = "Teleported to Escape Island.", Duration = 3 })
            end
        })

        -- Example: Slider
        SettingsTab:AddSlider({
            Title = "Background Transparency",
            Description = "Changes UI's Background Transparency.",
            Default = 50,
            Min = 0,
            Max = 100,
            Callback = function(value)
                Window.BackgroundTransparency = value / 100
                Fluent:Notify({
                    Title = "Akelaides",
                    Content = "Background Transparency set to: " .. tostring(value) .. "%",
                    Duration = 3
                })
            end
        })

        -- **Finalize**
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
end
