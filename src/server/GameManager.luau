local GameManager = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

-- Wait for shared modules to be available
local Shared = ReplicatedStorage:WaitForChild("Shared", 10)
if not Shared then
	warn("Shared folder not found in ReplicatedStorage")
	return GameManager
end

local GameConfig = require(Shared:WaitForChild("GameConfig", 10))
local PlayerData = require(Shared:WaitForChild("PlayerData", 10))

-- Remote events
print("Creating remote events...")
local RemoteEvents = Instance.new("Folder")
RemoteEvents.Name = "RemoteEvents"
RemoteEvents.Parent = ReplicatedStorage
print("RemoteEvents folder created")

local RequestPlayerData = Instance.new("RemoteEvent")
RequestPlayerData.Name = "RequestPlayerData"
RequestPlayerData.Parent = RemoteEvents

local UpdatePlayerData = Instance.new("RemoteEvent")
UpdatePlayerData.Name = "UpdatePlayerData"
UpdatePlayerData.Parent = RemoteEvents

local StartGame = Instance.new("RemoteEvent")
StartGame.Name = "StartGame"
StartGame.Parent = RemoteEvents

local EndGame = Instance.new("RemoteEvent")
EndGame.Name = "EndGame"
EndGame.Parent = RemoteEvents

local PurchaseItem = Instance.new("RemoteEvent")
PurchaseItem.Name = "PurchaseItem"
PurchaseItem.Parent = RemoteEvents

local CollectCoin = Instance.new("RemoteEvent")
CollectCoin.Name = "CollectCoin"
CollectCoin.Parent = RemoteEvents

local UpdateGravity = Instance.new("RemoteEvent")
UpdateGravity.Name = "UpdateGravity"
UpdateGravity.Parent = RemoteEvents

print("All remote events created successfully")

-- Player data storage
local playerDataStore = DataStoreService:GetDataStore("GravityShiftPlayerData")
local playerData = {}

-- Game state
local gameState = {
	activeGames = {},
	playerSessions = {}
}

-- Initialize player data
local function initializePlayer(player)
	local userId = player.UserId
	local success, data = pcall(function()
		return playerDataStore:GetAsync(userId)
	end)
	
	if success and data then
		playerData[userId] = data
	else
		playerData[userId] = PlayerData.new()
	end
	
	-- Update player name
	playerData[userId].name = player.Name
	
	-- Send initial data to client
	UpdatePlayerData:FireClient(player, playerData[userId])
end

-- Save player data
local function savePlayerData(player)
	local userId = player.UserId
	if playerData[userId] then
		local success, err = pcall(function()
			playerDataStore:SetAsync(userId, playerData[userId])
		end)
		
		if not success then
			warn("Failed to save data for player " .. player.Name .. ": " .. tostring(err))
		end
	end
end

-- Handle player joining
Players.PlayerAdded:Connect(function(player)
	initializePlayer(player)
end)

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
	savePlayerData(player)
	
	-- Clean up game session
	if gameState.playerSessions[player.UserId] then
		local session = gameState.playerSessions[player.UserId]
		if session.activeGame then
			gameState.activeGames[session.activeGame] = nil
		end
		gameState.playerSessions[player.UserId] = nil
	end
	
	-- Remove from player data
	playerData[player.UserId] = nil
end)

-- Handle player data requests
RequestPlayerData.OnServerEvent:Connect(function(player)
	UpdatePlayerData:FireClient(player, playerData[player.UserId])
end)

-- Handle game start requests
StartGame.OnServerEvent:Connect(function(player, mapIndex)
	print("Player", player.Name, "requested to start map", mapIndex)
	
	local userId = player.UserId
	local playerDataInstance = playerData[userId]
	
	if not playerDataInstance then
		print("No player data found for", player.Name)
		return
	end
	
	-- Check if map is unlocked
	if not PlayerData.isMapUnlocked(playerDataInstance, mapIndex) then
		print("Map", mapIndex, "is not unlocked for", player.Name)
		return
	end
	
	-- Get map data
	local mapData = GameConfig.MAPS[mapIndex]
	if not mapData then
		print("Invalid map index:", mapIndex)
		return
	end
	
	print("Starting game for", player.Name, "on map:", mapData.name)
	
	-- Create game session
	local gameId = userId .. "_" .. tick()
	local gameSession = {
		id = gameId,
		player = player,
		mapData = mapData,
		startTime = tick(),
		coinsCollected = 0,
		checkpointsReached = 0,
		gravityShifts = 0,
		isActive = true
	}
	
	gameState.activeGames[gameId] = gameSession
	gameState.playerSessions[userId] = {
		activeGame = gameId,
		playerData = playerDataInstance
	}
	
	-- Update statistics
	playerDataInstance.statistics.mapsPlayed = playerDataInstance.statistics.mapsPlayed + 1
	
	-- Send game data to client
	StartGame:FireClient(player, mapIndex, gameId)
	print("Game started for", player.Name, "with game ID:", gameId)
end)

-- Handle game end
EndGame.OnServerEvent:Connect(function(player, gameId, completionData)
	local userId = player.UserId
	local gameSession = gameState.activeGames[gameId]
	local playerDataInstance = playerData[userId]
	
	if not gameSession or not playerDataInstance then
		return
	end
	
	-- Calculate rewards
	local timeBonus = math.max(0, 100 - completionData.time) * 10
	local coinBonus = completionData.coins * GameConfig.COIN_VALUE
	local totalReward = timeBonus + coinBonus
	
	-- Add coins and experience
	local coinsEarned, levelBonus = PlayerData.addCoins(playerDataInstance, totalReward)
	local leveledUp, newLevel = PlayerData.addExperience(playerDataInstance, completionData.time * 10)
	
	-- Update best time if better
	local newRecord = PlayerData.updateBestTime(playerDataInstance, gameSession.mapData.name, completionData.time)
	
	-- Update statistics
	playerDataInstance.statistics.totalPlayTime = playerDataInstance.statistics.totalPlayTime + completionData.time
	playerDataInstance.statistics.coinsCollected = playerDataInstance.statistics.coinsCollected + completionData.coins
	playerDataInstance.statistics.gravityShifts = playerDataInstance.statistics.gravityShifts + completionData.gravityShifts
	
	-- Mark map as completed
	playerDataInstance.mapsCompleted[gameSession.mapData.name] = true
	
	-- Clean up game session
	gameState.activeGames[gameId] = nil
	gameState.playerSessions[userId].activeGame = nil
	
	-- Send results to client
	EndGame:FireClient(player, {
		coinsEarned = coinsEarned,
		levelBonus = levelBonus,
		timeBonus = timeBonus,
		coinBonus = coinBonus,
		totalReward = totalReward,
		leveledUp = leveledUp,
		newLevel = newLevel,
		newRecord = newRecord,
		completionTime = completionData.time
	})
	
	-- Update client with new data
	UpdatePlayerData:FireClient(player, playerDataInstance)
end)

-- Handle coin collection
CollectCoin.OnServerEvent:Connect(function(player, gameId, coinId)
	local userId = player.UserId
	local gameSession = gameState.activeGames[gameId]
	
	if not gameSession or not gameSession.isActive then
		return
	end
	
	-- Find and remove coin
	for i, coin in ipairs(gameSession.mapData.coins) do
		if coin.id == coinId and not coin.collected then
			coin.collected = true
			gameSession.coinsCollected = gameSession.coinsCollected + coin.value
			break
		end
	end
end)

-- Handle gravity updates
UpdateGravity.OnServerEvent:Connect(function(player, gameId)
	local userId = player.UserId
	local gameSession = gameState.activeGames[gameId]
	
	if not gameSession or not gameSession.isActive then
		return
	end
	
	gameSession.gravityShifts = gameSession.gravityShifts + 1
end)

-- Handle item purchases
PurchaseItem.OnServerEvent:Connect(function(player, itemId)
	local userId = player.UserId
	local playerDataInstance = playerData[userId]
	
	if not playerDataInstance then
		return
	end
	
	-- Find item in shop
	local item = nil
	for _, shopItem in ipairs(GameConfig.SHOP_ITEMS) do
		if shopItem.id == itemId then
			item = shopItem
			break
		end
	end
	
	if not item then
		return
	end
	
	-- Check if player can afford
	if not PlayerData.canAfford(playerDataInstance, item.price, item.currency) then
		return
	end
	
	-- Process purchase
	if PlayerData.purchaseItem(playerDataInstance, item.price, item.currency) then
		-- Apply item effects
		if item.type == "powerup" then
			PlayerData.upgradePowerup(playerDataInstance, itemId)
		elseif item.type == "cosmetic" then
			playerDataInstance.cosmetics[itemId] = true
		end
		
		-- Update client
		UpdatePlayerData:FireClient(player, playerDataInstance)
	end
end)

-- Auto-save player data periodically
spawn(function()
	while true do
		wait(60) -- Save every minute
		for _, player in ipairs(Players:GetPlayers()) do
			savePlayerData(player)
		end
	end
end)

-- Get player data (for other scripts)
function GameManager.getPlayerData(player)
	return playerData[player.UserId]
end

-- Get active game session
function GameManager.getActiveGame(player)
	local userId = player.UserId
	local session = gameState.playerSessions[userId]
	if session and session.activeGame then
		return gameState.activeGames[session.activeGame]
	end
	return nil
end

return GameManager 