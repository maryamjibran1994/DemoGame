local GameController = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Wait for shared modules to be available
local Shared = ReplicatedStorage:WaitForChild("Shared", 10)
if not Shared then
	warn("Shared folder not found in ReplicatedStorage")
	return GameController
end

local GameConfig = nil
local PlayerData = nil
local UISystem = nil

-- Load shared modules with error handling
local success1, result1 = pcall(require, Shared:WaitForChild("GameConfig", 10))
if success1 then
	GameConfig = result1
else
	warn("Failed to load GameConfig:", result1)
	return GameController
end

local success2, result2 = pcall(require, Shared:WaitForChild("PlayerData", 10))
if success2 then
	PlayerData = result2
else
	warn("Failed to load PlayerData:", result2)
	return GameController
end

local success3, result3 = pcall(require, Shared:WaitForChild("UISystem", 10))
if success3 then
	UISystem = result3
else
	warn("Failed to load UISystem:", result3)
	return GameController
end

local player = Players.LocalPlayer
local character = nil
local humanoid = nil
local rootPart = nil

-- Function to setup character references
local function setupCharacterReferences()
	character = player.Character or player.CharacterAdded:Wait()
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")
end

-- Game state (define early to prevent nil access)
local gameState = {
	isInGame = false,
	currentMap = nil,
	gameId = nil,
	startTime = 0,
	coinsCollected = 0,
	checkpointsReached = 0,
	gravityShifts = 0,
	currentGravity = Vector3.new(0, -196.2, 0), -- Default gravity, will be updated after GameConfig loads
	lastGravityChange = 0,
	canChangeGravity = true,
	activePowerups = {},
	gameObjects = {
		platforms = {},
		coins = {},
		checkpoints = {},
		obstacles = {}
	}
}

-- Update gravity with loaded config
if GameConfig then
	gameState.currentGravity = Vector3.new(0, -GameConfig.GRAVITY_SPEED, 0)
end

-- Remote events
print("Setting up remote events...")
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents", 10)
if not RemoteEvents then
	warn("RemoteEvents folder not found in ReplicatedStorage")
	return GameController
end
print("RemoteEvents folder found")

local RequestPlayerData = RemoteEvents:WaitForChild("RequestPlayerData", 10)
local UpdatePlayerData = RemoteEvents:WaitForChild("UpdatePlayerData", 10)
local StartGame = RemoteEvents:WaitForChild("StartGame", 10)
local EndGame = RemoteEvents:WaitForChild("EndGame", 10)
local PurchaseItem = RemoteEvents:WaitForChild("PurchaseItem", 10)
local CollectCoin = RemoteEvents:WaitForChild("CollectCoin", 10)
local UpdateGravity = RemoteEvents:WaitForChild("UpdateGravity", 10)

-- Check if all remote events loaded successfully
if not (RequestPlayerData and UpdatePlayerData and StartGame and EndGame and PurchaseItem and CollectCoin and UpdateGravity) then
	warn("Failed to load all remote events")
	print("RequestPlayerData:", RequestPlayerData ~= nil)
	print("UpdatePlayerData:", UpdatePlayerData ~= nil)
	print("StartGame:", StartGame ~= nil)
	print("EndGame:", EndGame ~= nil)
	print("PurchaseItem:", PurchaseItem ~= nil)
	print("CollectCoin:", CollectCoin ~= nil)
	print("UpdateGravity:", UpdateGravity ~= nil)
	return GameController
end
print("All remote events loaded successfully")



-- UI references
local lobbyUI = nil
local shopUI = nil
local gameHUD = nil
local pauseMenu = nil

-- Initialize game
function GameController.init()
	print("Initializing GameController...")
	
	-- Setup character references first
	setupCharacterReferences()
	
	-- Create UI
	print("Creating UI...")
	lobbyUI = UISystem.createLobbyUI()
	shopUI = UISystem.createShopUI()
	gameHUD = UISystem.createGameHUD()
	pauseMenu = UISystem.createPauseMenu()
	
	-- Request initial player data
	print("Requesting player data...")
	RequestPlayerData:FireServer()
	
	-- Setup UI connections
	print("Setting up UI connections...")
	setupUIConnections()
	
	-- Setup input handling
	print("Setting up input handling...")
	setupInputHandling()
	
	-- Setup remote event connections
	print("Setting up remote connections...")
	setupRemoteConnections()
	
	-- Show lobby
	print("Showing lobby...")
	showLobby()
	
	-- Add a simple test button to see if UI is working
	local testButton = Instance.new("TextButton")
	testButton.Size = UDim2.new(0, 200, 0, 50)
	testButton.Position = UDim2.new(0.5, -100, 0.9, 0)
	testButton.Text = "TEST BUTTON"
	testButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	testButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	testButton.Font = Enum.Font.GothamBold
	testButton.TextScaled = true
	testButton.Parent = lobbyUI.screenGui
	
	testButton.MouseButton1Click:Connect(function()
		print("TEST BUTTON CLICKED!")
		-- Try to start the game directly
		StartGame:FireServer(1)
	end)
	
	print("GameController initialization complete!")
end

-- Setup UI connections
function setupUIConnections()
	-- Lobby UI
	lobbyUI.shopButton.MouseButton1Click:Connect(function()
		showShop()
	end)
	
	lobbyUI.settingsButton.MouseButton1Click:Connect(function()
		-- TODO: Implement settings
		print("Settings not implemented yet")
	end)
	
	-- Connect the main PLAY button to start the first available map
	print("Setting up play button connection...")
	if lobbyUI and lobbyUI.playButton then
		print("Play button found, connecting click event...")
		
		-- Add a simple test to see if the button is working
		lobbyUI.playButton.MouseButton1Click:Connect(function()
			print("Play button clicked!")
			print("Button position:", lobbyUI.playButton.Position)
			print("Button size:", lobbyUI.playButton.Size)
			print("Button visible:", lobbyUI.playButton.Visible)
			print("Button enabled:", lobbyUI.playButton.Enabled)
			
			-- Find the first unlocked map
			for i, mapData in ipairs(GameConfig.MAPS) do
				if mapData.unlocked then
					print("Starting map:", i, mapData.name)
					StartGame:FireServer(i)
					break
				end
			end
		end)
		
		-- Also add a simple test with a different event
		lobbyUI.playButton.Activated:Connect(function()
			print("Play button activated!")
		end)
		
		print("Play button connection established")
	else
		warn("Play button not found in lobbyUI")
		if lobbyUI then
			print("Available lobbyUI properties:")
			for key, value in pairs(lobbyUI) do
				print("  " .. key .. ":", value)
			end
		end
	end
	
	-- Shop UI
	shopUI.closeButton.MouseButton1Click:Connect(function()
		hideShop()
	end)
	
	-- Game HUD
	gameHUD.pauseButton.MouseButton1Click:Connect(function()
		showPauseMenu()
	end)
	
	-- Pause Menu
	pauseMenu.resumeButton.MouseButton1Click:Connect(function()
		hidePauseMenu()
	end)
	
	pauseMenu.restartButton.MouseButton1Click:Connect(function()
		restartGame()
	end)
	
	pauseMenu.quitButton.MouseButton1Click:Connect(function()
		quitToLobby()
	end)
end

-- Setup input handling
function setupInputHandling()
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		
		if gameState.isInGame then
			if input.KeyCode == Enum.KeyCode.Space then
				changeGravity()
			elseif input.KeyCode == Enum.KeyCode.R then
				restartGame()
			elseif input.KeyCode == Enum.KeyCode.Escape then
				showPauseMenu()
			end
		end
	end)
end

-- Setup remote event connections
function setupRemoteConnections()
	UpdatePlayerData.OnClientEvent:Connect(function(playerData)
		updatePlayerUI(playerData)
	end)
	
	StartGame.OnClientEvent:Connect(function(mapData, gameId)
		startGame(mapData, gameId)
	end)
	
	EndGame.OnClientEvent:Connect(function(results)
		endGame(results)
	end)
end

-- Show lobby
function showLobby()
	print("showLobby() called")
	gameState.isInGame = false
	
	-- Hide other UI
	shopUI.screenGui.Enabled = false
	gameHUD.screenGui.Enabled = false
	pauseMenu.screenGui.Enabled = false
	
	-- Show lobby
	lobbyUI.screenGui.Enabled = true
	print("Lobby UI enabled:", lobbyUI.screenGui.Enabled)
	
	-- Populate map selection
	populateMapSelection()
	
	-- Reset character
	resetCharacter()
	print("showLobby() completed")
end

-- Show shop
function showShop()
	shopUI.screenGui.Enabled = true
	populateShop()
end

-- Hide shop
function hideShop()
	shopUI.screenGui.Enabled = false
end

-- Show pause menu
function showPauseMenu()
	pauseMenu.screenGui.Enabled = true
	RunService:SetRobloxGuiFocused(false)
end

-- Hide pause menu
function hidePauseMenu()
	pauseMenu.screenGui.Enabled = false
	RunService:SetRobloxGuiFocused(true)
end

-- Populate map selection
function populateMapSelection()
	print("populateMapSelection() called")
	
	-- Clear existing items
	for _, child in ipairs(lobbyUI.mapScroller:GetChildren()) do
		child:Destroy()
	end
	
	print("Creating", #GameConfig.MAPS, "map items")
	
	-- Add map items
	for i, mapData in ipairs(GameConfig.MAPS) do
		print("Creating map item", i, ":", mapData.name)
		local mapItem = UISystem.createMapItem(lobbyUI.mapScroller, mapData, mapData.unlocked)
		
		-- Set proper position for the map item
		mapItem.frame.Position = UDim2.new(0, 0, 0, (i - 1) * 90)
		
		mapItem.button.MouseButton1Click:Connect(function()
			print("Map button clicked:", mapData.name)
			if mapData.unlocked then
				StartGame:FireServer(i)
			end
		end)
		
		-- Update canvas size
		lobbyUI.mapScroller.CanvasSize = UDim2.new(0, 0, 0, #GameConfig.MAPS * 90)
	end
	
	print("populateMapSelection() completed")
end

-- Populate shop
function populateShop()
	-- Clear existing items
	for _, child in ipairs(shopUI.itemScroller:GetChildren()) do
		child:Destroy()
	end
	
	-- Add shop items
	for i, itemData in ipairs(GameConfig.SHOP_ITEMS) do
		local shopItem = UISystem.createShopItem(shopUI.itemScroller, itemData)
		
		-- Set proper position for the shop item
		shopItem.frame.Position = UDim2.new(0, 0, 0, (i - 1) * 110)
		
		shopItem.button.MouseButton1Click:Connect(function()
			PurchaseItem:FireServer(itemData.id)
		end)
		
		-- Update canvas size
		shopUI.itemScroller.CanvasSize = UDim2.new(0, 0, 0, #GameConfig.SHOP_ITEMS * 110)
	end
end

-- Update player UI
function updatePlayerUI(playerData)
	if not playerData then return end
	
	lobbyUI.playerName.Text = playerData.name or "Player"
	lobbyUI.playerLevel.Text = "Level: " .. playerData.level
	lobbyUI.playerCoins.Text = "Coins: " .. playerData.coins
	lobbyUI.playerRobux.Text = "Robux: " .. playerData.robux
	
	-- Update map unlock status
	for i, mapData in ipairs(GameConfig.MAPS) do
		mapData.unlocked = PlayerData.isMapUnlocked(playerData, i)
	end
end

-- Start game
function startGame(mapIndex, gameId)
	-- Get the actual map data from the index
	local mapData = GameConfig.MAPS[mapIndex]
	if not mapData then
		warn("Invalid map index:", mapIndex)
		return
	end
	
	gameState.isInGame = true
	gameState.currentMap = mapData
	gameState.gameId = gameId
	gameState.startTime = tick()
	gameState.coinsCollected = 0
	gameState.checkpointsReached = 0
	gameState.gravityShifts = 0
	
	-- Hide lobby and show game HUD
	lobbyUI.screenGui.Enabled = false
	gameHUD.screenGui.Enabled = true
	
	-- Build map
	buildMap(mapData)
	
	-- Setup character
	setupCharacter()
	
	-- Start game loop
	startGameLoop()
end

-- Build map
function buildMap(mapData)
	-- Clear existing objects
	clearGameObjects()
	
	-- Create platforms
	for i, platformData in ipairs(mapData.platforms) do
		local platform = Instance.new("Part")
		platform.Name = "Platform_" .. i
		platform.Position = platformData.position
		platform.Size = platformData.size
		platform.Color = platformData.color
		platform.Anchored = true
		platform.CanCollide = true
		platform.Material = Enum.Material.Plastic
		platform.Parent = Workspace
		
		table.insert(gameState.gameObjects.platforms, platform)
		
		-- Add platform behavior
		if platformData.type == "moving" and platformData.speed then
			setupMovingPlatform(platform, platformData.speed)
		elseif platformData.type == "breakable" then
			setupBreakablePlatform(platform)
		elseif platformData.type == "bounce" then
			setupBouncePlatform(platform, platformData.bouncePower or 50)
		end
	end
	
	-- Create coins
	for i, coinData in ipairs(mapData.coins) do
		local coin = Instance.new("Part")
		coin.Name = "Coin_" .. i
		coin.Position = coinData.position
		coin.Size = Vector3.new(2, 2, 2)
		coin.Color = Color3.fromRGB(255, 215, 0) -- Gold
		coin.Anchored = true
		coin.CanCollide = false
		coin.Shape = Enum.PartType.Ball
		coin.Material = Enum.Material.Neon
		coin.Parent = Workspace
		
		-- Add spinning animation
		local bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
		bodyGyro.D = 0
		bodyGyro.P = 0
		bodyGyro.CFrame = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		bodyGyro.Parent = coin
		
		-- Add collection detection
		local touchInterest = Instance.new("TouchTransmitter")
		touchInterest.Parent = coin
		
		coin.Touched:Connect(function(hit)
			if character and hit.Parent == character then
				collectCoin(coin, i)
			end
		end)
		
		coinData.id = i
		table.insert(gameState.gameObjects.coins, coin)
	end
	
	-- Create checkpoints
	for i, checkpointData in ipairs(mapData.checkpoints) do
		local checkpoint = Instance.new("Part")
		checkpoint.Name = "Checkpoint_" .. i
		checkpoint.Position = checkpointData.position
		checkpoint.Size = Vector3.new(4, 8, 4)
		checkpoint.Color = Color3.fromRGB(46, 204, 113) -- Green
		checkpoint.Anchored = true
		checkpoint.CanCollide = false
		checkpoint.Transparency = 0.5
		checkpoint.Material = Enum.Material.Neon
		checkpoint.Parent = Workspace
		
		-- Add checkpoint detection
		checkpoint.Touched:Connect(function(hit)
			if character and hit.Parent == character then
				reachCheckpoint(i)
			end
		end)
		
		table.insert(gameState.gameObjects.checkpoints, checkpoint)
	end
	
	-- Create obstacles
	for i, obstacleData in ipairs(mapData.obstacles) do
		local obstacle = Instance.new("Part")
		obstacle.Name = "Obstacle_" .. i
		obstacle.Position = obstacleData.position
		obstacle.Size = obstacleData.size
		obstacle.Color = obstacleData.color
		obstacle.Anchored = true
		obstacle.CanCollide = true
		obstacle.Material = Enum.Material.Neon
		obstacle.Parent = Workspace
		
		table.insert(gameState.gameObjects.obstacles, obstacle)
	end
	
	-- Create finish point
	local finish = Instance.new("Part")
	finish.Name = "Finish"
	finish.Position = mapData.finishPoint
	finish.Size = Vector3.new(10, 2, 10)
	finish.Color = Color3.fromRGB(155, 89, 182) -- Purple
	finish.Anchored = true
	finish.CanCollide = true
	finish.Material = Enum.Material.Neon
	finish.Parent = Workspace
	
	finish.Touched:Connect(function(hit)
		if character and hit.Parent == character then
			completeGame()
		end
	end)
end

-- Clear game objects
function clearGameObjects()
	for _, objects in pairs(gameState.gameObjects) do
		for _, obj in ipairs(objects) do
			if obj and obj.Parent then
				obj:Destroy()
			end
		end
		objects = {}
	end
end

-- Setup character
function setupCharacter()
	if not character or not humanoid or not rootPart then
		setupCharacterReferences()
	end
	
	if character and humanoid and rootPart then
		-- Reset character position
		character:PivotTo(CFrame.new(gameState.currentMap.spawnPoint))
		
		-- Reset humanoid properties
		humanoid.WalkSpeed = GameConfig.PLAYER_WALK_SPEED
		humanoid.JumpPower = GameConfig.PLAYER_JUMP_POWER
		humanoid.MaxSlopeAngle = GameConfig.PLAYER_MAX_SLOPE_ANGLE
		
		-- Reset gravity
		gameState.currentGravity = Vector3.new(0, -GameConfig.GRAVITY_SPEED, 0)
		gameState.canChangeGravity = true
		gameState.lastGravityChange = 0
		
		-- Update gravity indicator
		updateGravityIndicator()
	end
end

-- Change gravity
function changeGravity()
	if not gameState.canChangeGravity then return end
	
	local currentTime = tick()
	if currentTime - gameState.lastGravityChange < GameConfig.GRAVITY_CHANGE_COOLDOWN then
		return
	end
	
	-- Cycle through gravity directions
	local gravityDirections = {
		Vector3.new(0, -GameConfig.GRAVITY_SPEED, 0),  -- Down
		Vector3.new(0, GameConfig.GRAVITY_SPEED, 0),   -- Up
		Vector3.new(-GameConfig.GRAVITY_SPEED, 0, 0),  -- Left
		Vector3.new(GameConfig.GRAVITY_SPEED, 0, 0),   -- Right
		Vector3.new(0, 0, -GameConfig.GRAVITY_SPEED),  -- Forward
		Vector3.new(0, 0, GameConfig.GRAVITY_SPEED)    -- Back
	}
	
	local currentIndex = 1
	for i, direction in ipairs(gravityDirections) do
		if direction == gameState.currentGravity then
			currentIndex = i
			break
		end
	end
	
	local nextIndex = (currentIndex % #gravityDirections) + 1
	gameState.currentGravity = gravityDirections[nextIndex]
	
	-- Update physics
	Workspace.Gravity = gameState.currentGravity.Y
	
	-- Update character orientation
	if rootPart then
		local lookDirection = gameState.currentGravity.Unit
		rootPart.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + lookDirection)
	end
	
	-- Update UI
	updateGravityIndicator()
	
	-- Update server
	UpdateGravity:FireServer(gameState.gameId)
	
	-- Update cooldown
	gameState.lastGravityChange = currentTime
	gameState.gravityShifts = gameState.gravityShifts + 1
end

-- Update gravity indicator
function updateGravityIndicator()
	local gravityText = gameState.currentGravity
	local symbol = "↓"
	
	if gravityText.Y > 0 then
		symbol = "↑"
	elseif gravityText.X < 0 then
		symbol = "←"
	elseif gravityText.X > 0 then
		symbol = "→"
	elseif gravityText.Z < 0 then
		symbol = "↗"
	elseif gravityText.Z > 0 then
		symbol = "↙"
	end
	
	gameHUD.gravityText.Text = symbol
end

-- Collect coin
function collectCoin(coin, coinId)
	if not coin or not coin.Parent then return end
	
	-- Remove coin
	coin:Destroy()
	
	-- Update state
	gameState.coinsCollected = gameState.coinsCollected + 10
	
	-- Update UI
	gameHUD.coinsLabel.Text = "Coins: " .. gameState.coinsCollected
	
	-- Notify server
	CollectCoin:FireServer(gameState.gameId, coinId)
	
	-- Play collection effect
	playCoinEffect(coin.Position)
end

-- Reach checkpoint
function reachCheckpoint(checkpointIndex)
	if checkpointIndex > gameState.checkpointsReached then
		gameState.checkpointsReached = checkpointIndex
		gameHUD.checkpointLabel.Text = "Checkpoint: " .. gameState.checkpointsReached .. "/" .. #gameState.currentMap.checkpoints
		
		-- Play checkpoint effect
		playCheckpointEffect()
	end
end

-- Complete game
function completeGame()
	local completionTime = tick() - gameState.startTime
	
	local completionData = {
		time = completionTime,
		coins = gameState.coinsCollected,
		gravityShifts = gameState.gravityShifts
	}
	
	EndGame:FireServer(gameState.gameId, completionData)
end

-- End game
function endGame(results)
	gameState.isInGame = false
	
	-- Hide game HUD
	gameHUD.screenGui.Enabled = false
	
	-- Show results (TODO: Create results UI)
	print("Game completed!")
	print("Time: " .. string.format("%.2f", results.completionTime) .. "s")
	print("Coins: " .. results.coinsEarned)
	print("Total Reward: " .. results.totalReward)
	
	if results.leveledUp then
		print("Level Up! New level: " .. results.newLevel)
	end
	
	if results.newRecord then
		print("New Record!")
	end
	
	-- Return to lobby after delay
	wait(3)
	showLobby()
end

-- Restart game
function restartGame()
	if gameState.isInGame then
		StartGame:FireServer(1) -- Restart current map
	end
end

-- Quit to lobby
function quitToLobby()
	gameState.isInGame = false
	clearGameObjects()
	showLobby()
end

-- Start game loop
function startGameLoop()
	spawn(function()
		while gameState.isInGame do
			-- Update time display
			local currentTime = tick() - gameState.startTime
			local minutes = math.floor(currentTime / 60)
			local seconds = math.floor(currentTime % 60)
			gameHUD.timeLabel.Text = string.format("Time: %02d:%02d", minutes, seconds)
			
			wait(0.1)
		end
	end)
end

-- Platform behaviors
function setupMovingPlatform(platform, speed)
	spawn(function()
		local startPos = platform.Position
		local direction = 1
		
		while platform and platform.Parent do
			local newPos = startPos + Vector3.new(0, math.sin(tick() * speed.Y) * 10, 0)
			platform.Position = newPos
			wait(0.01)
		end
	end)
end

function setupBreakablePlatform(platform)
	platform.Touched:Connect(function(hit)
		if character and hit.Parent == character then
			wait(0.5)
			platform:Destroy()
		end
	end)
end

function setupBouncePlatform(platform, bouncePower)
	platform.Touched:Connect(function(hit)
		if character and hit.Parent == character and humanoid then
			humanoid.JumpPower = bouncePower
			wait(0.1)
			humanoid.JumpPower = GameConfig.PLAYER_JUMP_POWER
		end
	end)
end

-- Effects
function playCoinEffect(position)
	-- TODO: Add particle effects
end

function playCheckpointEffect()
	-- TODO: Add checkpoint effects
end

-- Reset character
function resetCharacter()
	if character and character.Parent then
		character:PivotTo(CFrame.new(0, 10, 0))
	end
end

-- Update character references when character respawns
player.CharacterAdded:Connect(function(newCharacter)
	setupCharacterReferences()
end)

return GameController 