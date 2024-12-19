-- Services
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

-- Create a DataStore
local playerDataStore = DataStoreService:GetDataStore("PlayerDataStore")

-- Default cash amount
local DEFAULT_CASH = 500000

-- Function to load player data
local function loadPlayerData(player)
    local success, data = pcall(function()
        return playerDataStore:GetAsync(player.UserId)
    end)

    if success then
        if data then
            -- If data exists, apply it to the player
            print("Loaded data for player: " .. player.Name)
            player.Cash.Value = data.Cash or DEFAULT_CASH
        else
            -- If no data exists, initialize cash to DEFAULT_CASH
            print("No data found for player: " .. player.Name .. ". Setting cash to default.")
            player.Cash.Value = DEFAULT_CASH
        end
    else
        warn("Failed to load data for player: " .. player.Name .. " - " .. tostring(data))
    end
end

-- Function to save player data
local function savePlayerData(player)
    local data = {
        Cash = player.Cash.Value or 0,
    }

    local success, errorMessage = pcall(function()
        playerDataStore:SetAsync(player.UserId, data)
    end)

    if success then
        print("Saved data for player: " .. player.Name)
    else
        warn("Failed to save data for player: " .. player.Name .. " - " .. errorMessage)
    end
end

-- Function to give cash every second
local function giveCash(player)
    while player and player.Parent do
        player.Cash.Value = player.Cash.Value + 5
        wait(1) -- Wait for 1 second
    end
end

-- Player added event
Players.PlayerAdded:Connect(function(player)
    -- Create a NumberValue for Cash
    local cashValue = Instance.new("NumberValue")
    cashValue.Name = "Cash"
    cashValue.Parent = player

    loadPlayerData(player)

    -- Start giving cash every second
    giveCash(player)
end)

-- Player removing event
Players.PlayerRemoving:Connect(function(player)
    savePlayerData(player)
end)