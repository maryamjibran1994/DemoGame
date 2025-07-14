local UISystem = {}

-- Wait for GameConfig to be available
local GameConfig = require(script.Parent:WaitForChild("GameConfig", 10))

-- UI Components
local function createFrame(parent, properties)
	local frame = Instance.new("Frame")
	for property, value in pairs(properties) do
		frame[property] = value
	end
	frame.Parent = parent
	return frame
end

local function createTextLabel(parent, properties)
	local label = Instance.new("TextLabel")
	for property, value in pairs(properties) do
		label[property] = value
	end
	label.Parent = parent
	return label
end

local function createTextButton(parent, properties)
	local button = Instance.new("TextButton")
	for property, value in pairs(properties) do
		button[property] = value
	end
	button.Parent = parent
	return button
end

local function createImageButton(parent, properties)
	local button = Instance.new("ImageButton")
	for property, value in pairs(properties) do
		button[property] = value
	end
	button.Parent = parent
	return button
end

local function createScrollingFrame(parent, properties)
	local frame = Instance.new("ScrollingFrame")
	for property, value in pairs(properties) do
		frame[property] = value
	end
	frame.Parent = parent
	return frame
end

-- Create main lobby UI
function UISystem.createLobbyUI()
	print("Creating lobby UI...")
	local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "LobbyUI"
	screenGui.Parent = playerGui
	print("LobbyUI ScreenGui created")
	
	-- Background
	local background = createFrame(screenGui, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = GameConfig.COLORS.BACKGROUND,
		BackgroundTransparency = 0.1
	})
	
	-- Title
	local title = createTextLabel(background, {
		Size = UDim2.new(0, 400, 0, 80),
		Position = UDim2.new(0.5, -200, 0.1, 0),
		BackgroundTransparency = 1,
		Text = "GRAVITY SHIFT",
		TextColor3 = GameConfig.COLORS.PRIMARY,
		TextScaled = true,
		Font = Enum.Font.GothamBold
	})
	
	-- Player info panel
	local playerInfo = createFrame(background, {
		Size = UDim2.new(0, 300, 0, 150),
		Position = UDim2.new(0.05, 0, 0.1, 0),
		BackgroundColor3 = GameConfig.COLORS.SECONDARY,
		BorderSizePixel = 0
	})
	
	local playerName = createTextLabel(playerInfo, {
		Size = UDim2.new(1, 0, 0, 30),
		Position = UDim2.new(0, 0, 0, 10),
		BackgroundTransparency = 1,
		Text = "Player",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.Gotham
	})
	
	local playerLevel = createTextLabel(playerInfo, {
		Size = UDim2.new(1, 0, 0, 25),
		Position = UDim2.new(0, 0, 0, 40),
		BackgroundTransparency = 1,
		Text = "Level: 1",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.Gotham
	})
	
	local playerCoins = createTextLabel(playerInfo, {
		Size = UDim2.new(1, 0, 0, 25),
		Position = UDim2.new(0, 0, 0, 65),
		BackgroundTransparency = 1,
		Text = "Coins: 0",
		TextColor3 = GameConfig.COLORS.ACCENT,
		TextScaled = true,
		Font = Enum.Font.Gotham
	})
	
	local playerRobux = createTextLabel(playerInfo, {
		Size = UDim2.new(1, 0, 0, 25),
		Position = UDim2.new(0, 0, 0, 90),
		BackgroundTransparency = 1,
		Text = "Robux: 0",
		TextColor3 = GameConfig.COLORS.SUCCESS,
		TextScaled = true,
		Font = Enum.Font.Gotham
	})
	
	-- Map selection panel
	local mapPanel = createFrame(background, {
		Size = UDim2.new(0, 600, 0, 400),
		Position = UDim2.new(0.5, -300, 0.5, -200),
		BackgroundColor3 = GameConfig.COLORS.SECONDARY,
		BorderSizePixel = 0
	})
	
	local mapTitle = createTextLabel(mapPanel, {
		Size = UDim2.new(1, 0, 0, 50),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = "Select Map",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold
	})
	
	local mapScroller = createScrollingFrame(mapPanel, {
		Size = UDim2.new(1, -20, 1, -60),
		Position = UDim2.new(0, 10, 0, 50),
		BackgroundTransparency = 1,
		ScrollBarThickness = 8,
		CanvasSize = UDim2.new(0, 0, 0, 0)
	})
	
	-- Buttons panel - moved to avoid overlap
	local buttonPanel = createFrame(background, {
		Size = UDim2.new(0, 400, 0, 200),
		Position = UDim2.new(0.05, 0, 0.7, 0),
		BackgroundTransparency = 1
	})
	
	local playButton = createTextButton(buttonPanel, {
		Size = UDim2.new(1, 0, 0, 50),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = GameConfig.COLORS.SUCCESS,
		Text = "PLAY",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0
	})
	
	print("Play button created:", playButton.Name)
	
	local shopButton = createTextButton(buttonPanel, {
		Size = UDim2.new(1, 0, 0, 50),
		Position = UDim2.new(0, 0, 0, 60),
		BackgroundColor3 = GameConfig.COLORS.ACCENT,
		Text = "SHOP",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0
	})
	
	local settingsButton = createTextButton(buttonPanel, {
		Size = UDim2.new(1, 0, 0, 50),
		Position = UDim2.new(0, 0, 0, 120),
		BackgroundColor3 = GameConfig.COLORS.WARNING,
		Text = "SETTINGS",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0
	})
	
	return {
		screenGui = screenGui,
		background = background,
		playerInfo = playerInfo,
		playerName = playerName,
		playerLevel = playerLevel,
		playerCoins = playerCoins,
		playerRobux = playerRobux,
		mapPanel = mapPanel,
		mapScroller = mapScroller,
		playButton = playButton,
		shopButton = shopButton,
		settingsButton = settingsButton
	}
end

-- Create shop UI
function UISystem.createShopUI()
	local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ShopUI"
	screenGui.Parent = playerGui
	screenGui.Enabled = false
	
	-- Background
	local background = createFrame(screenGui, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.3
	})
	
	-- Shop panel
	local shopPanel = createFrame(background, {
		Size = UDim2.new(0, 800, 0, 600),
		Position = UDim2.new(0.5, -400, 0.5, -300),
		BackgroundColor3 = GameConfig.COLORS.BACKGROUND,
		BorderSizePixel = 0
	})
	
	local shopTitle = createTextLabel(shopPanel, {
		Size = UDim2.new(1, 0, 0, 60),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = GameConfig.COLORS.PRIMARY,
		Text = "SHOP",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0
	})
	
	local closeButton = createTextButton(shopTitle, {
		Size = UDim2.new(0, 50, 1, 0),
		Position = UDim2.new(1, -50, 0, 0),
		BackgroundColor3 = GameConfig.COLORS.DANGER,
		Text = "X",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0
	})
	
	local itemScroller = createScrollingFrame(shopPanel, {
		Size = UDim2.new(1, -20, 1, -80),
		Position = UDim2.new(0, 10, 0, 70),
		BackgroundTransparency = 1,
		ScrollBarThickness = 8,
		CanvasSize = UDim2.new(0, 0, 0, 0)
	})
	
	return {
		screenGui = screenGui,
		background = background,
		shopPanel = shopPanel,
		itemScroller = itemScroller,
		closeButton = closeButton
	}
end

-- Create in-game HUD
function UISystem.createGameHUD()
	local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "GameHUD"
	screenGui.Parent = playerGui
	screenGui.Enabled = false
	
	-- Top bar
	local topBar = createFrame(screenGui, {
		Size = UDim2.new(1, 0, 0, 60),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = GameConfig.COLORS.BACKGROUND,
		BorderSizePixel = 0
	})
	
	local timeLabel = createTextLabel(topBar, {
		Size = UDim2.new(0, 200, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Text = "Time: 00:00",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold
	})
	
	local coinsLabel = createTextLabel(topBar, {
		Size = UDim2.new(0, 200, 1, 0),
		Position = UDim2.new(0.5, -100, 0, 0),
		BackgroundTransparency = 1,
		Text = "Coins: 0",
		TextColor3 = GameConfig.COLORS.ACCENT,
		TextScaled = true,
		Font = Enum.Font.GothamBold
	})
	
	local checkpointLabel = createTextLabel(topBar, {
		Size = UDim2.new(0, 200, 1, 0),
		Position = UDim2.new(1, -210, 0, 0),
		BackgroundTransparency = 1,
		Text = "Checkpoint: 0/0",
		TextColor3 = GameConfig.COLORS.SUCCESS,
		TextScaled = true,
		Font = Enum.Font.GothamBold
	})
	
	-- Gravity indicator
	local gravityIndicator = createFrame(screenGui, {
		Size = UDim2.new(0, 100, 0, 100),
		Position = UDim2.new(1, -110, 0, 70),
		BackgroundColor3 = GameConfig.COLORS.PRIMARY,
		BorderSizePixel = 0
	})
	
	local gravityText = createTextLabel(gravityIndicator, {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = "↓",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold
	})
	
	-- Pause button
	local pauseButton = createTextButton(screenGui, {
		Size = UDim2.new(0, 50, 0, 50),
		Position = UDim2.new(0, 10, 0, 70),
		BackgroundColor3 = GameConfig.COLORS.WARNING,
		Text = "⏸",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0
	})
	
	return {
		screenGui = screenGui,
		topBar = topBar,
		timeLabel = timeLabel,
		coinsLabel = coinsLabel,
		checkpointLabel = checkpointLabel,
		gravityIndicator = gravityIndicator,
		gravityText = gravityText,
		pauseButton = pauseButton
	}
end

-- Create pause menu
function UISystem.createPauseMenu()
	local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "PauseMenu"
	screenGui.Parent = playerGui
	screenGui.Enabled = false
	
	-- Background
	local background = createFrame(screenGui, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.5
	})
	
	-- Menu panel
	local menuPanel = createFrame(background, {
		Size = UDim2.new(0, 400, 0, 300),
		Position = UDim2.new(0.5, -200, 0.5, -150),
		BackgroundColor3 = GameConfig.COLORS.BACKGROUND,
		BorderSizePixel = 0
	})
	
	local menuTitle = createTextLabel(menuPanel, {
		Size = UDim2.new(1, 0, 0, 60),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = GameConfig.COLORS.PRIMARY,
		Text = "PAUSED",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0
	})
	
	local resumeButton = createTextButton(menuPanel, {
		Size = UDim2.new(0.8, 0, 0, 50),
		Position = UDim2.new(0.1, 0, 0.3, 0),
		BackgroundColor3 = GameConfig.COLORS.SUCCESS,
		Text = "RESUME",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0
	})
	
	local restartButton = createTextButton(menuPanel, {
		Size = UDim2.new(0.8, 0, 0, 50),
		Position = UDim2.new(0.1, 0, 0.5, 0),
		BackgroundColor3 = GameConfig.COLORS.WARNING,
		Text = "RESTART",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0
	})
	
	local quitButton = createTextButton(menuPanel, {
		Size = UDim2.new(0.8, 0, 0, 50),
		Position = UDim2.new(0.1, 0, 0.7, 0),
		BackgroundColor3 = GameConfig.COLORS.DANGER,
		Text = "QUIT TO LOBBY",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0
	})
	
	return {
		screenGui = screenGui,
		background = background,
		menuPanel = menuPanel,
		resumeButton = resumeButton,
		restartButton = restartButton,
		quitButton = quitButton
	}
end

-- Create map selection item
function UISystem.createMapItem(parent, mapData, isUnlocked)
	local itemFrame = createFrame(parent, {
		Size = UDim2.new(1, -20, 0, 80),
		Position = UDim2.new(0, 10, 0, 0), -- Position will be set dynamically
		BackgroundColor3 = isUnlocked and GameConfig.COLORS.SECONDARY or Color3.fromRGB(100, 100, 100),
		BorderSizePixel = 0
	})
	
	local mapName = createTextLabel(itemFrame, {
		Size = UDim2.new(0.7, 0, 0.5, 0),
		Position = UDim2.new(0, 10, 0, 5),
		BackgroundTransparency = 1,
		Text = mapData.name,
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	local mapDesc = createTextLabel(itemFrame, {
		Size = UDim2.new(0.7, 0, 0.5, 0),
		Position = UDim2.new(0, 10, 0.5, 0),
		BackgroundTransparency = 1,
		Text = mapData.description,
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	local difficultyLabel = createTextLabel(itemFrame, {
		Size = UDim2.new(0.2, 0, 0.4, 0),
		Position = UDim2.new(0.75, 0, 0.1, 0),
		BackgroundTransparency = 1,
		Text = "★ " .. mapData.difficulty,
		TextColor3 = GameConfig.COLORS.ACCENT,
		TextScaled = true,
		Font = Enum.Font.GothamBold
	})
	
	local selectButton = createTextButton(itemFrame, {
		Size = UDim2.new(0.2, 0, 0.4, 0),
		Position = UDim2.new(0.75, 0, 0.5, 0),
		BackgroundColor3 = isUnlocked and GameConfig.COLORS.SUCCESS or GameConfig.COLORS.DANGER,
		Text = isUnlocked and "PLAY" or "LOCKED",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0
	})
	
	return {
		frame = itemFrame,
		name = mapName,
		description = mapDesc,
		difficulty = difficultyLabel,
		button = selectButton
	}
end

-- Create shop item
function UISystem.createShopItem(parent, itemData)
	local itemFrame = createFrame(parent, {
		Size = UDim2.new(1, -20, 0, 100),
		Position = UDim2.new(0, 10, 0, 0), -- Position will be set dynamically
		BackgroundColor3 = GameConfig.COLORS.SECONDARY,
		BorderSizePixel = 0
	})
	
	local itemName = createTextLabel(itemFrame, {
		Size = UDim2.new(0.6, 0, 0.4, 0),
		Position = UDim2.new(0, 10, 0, 5),
		BackgroundTransparency = 1,
		Text = itemData.name,
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	local itemDesc = createTextLabel(itemFrame, {
		Size = UDim2.new(0.6, 0, 0.4, 0),
		Position = UDim2.new(0, 10, 0.4, 0),
		BackgroundTransparency = 1,
		Text = itemData.description,
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	
	local priceLabel = createTextLabel(itemFrame, {
		Size = UDim2.new(0.3, 0, 0.4, 0),
		Position = UDim2.new(0.65, 0, 0.1, 0),
		BackgroundTransparency = 1,
		Text = itemData.price .. " " .. string.upper(itemData.currency),
		TextColor3 = itemData.currency == "robux" and GameConfig.COLORS.SUCCESS or GameConfig.COLORS.ACCENT,
		TextScaled = true,
		Font = Enum.Font.GothamBold
	})
	
	local buyButton = createTextButton(itemFrame, {
		Size = UDim2.new(0.3, 0, 0.4, 0),
		Position = UDim2.new(0.65, 0, 0.5, 0),
		BackgroundColor3 = GameConfig.COLORS.PRIMARY,
		Text = "BUY",
		TextColor3 = GameConfig.COLORS.TEXT,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0
	})
	
	return {
		frame = itemFrame,
		name = itemName,
		description = itemDesc,
		price = priceLabel,
		button = buyButton
	}
end

return UISystem 