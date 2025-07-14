local GameConfig = {}

-- Game Settings
GameConfig.GRAVITY_SPEED = 196.2 -- Roblox default gravity
GameConfig.GRAVITY_CHANGE_COOLDOWN = 0.5 -- Seconds between gravity changes
GameConfig.COIN_VALUE = 10 -- Points per coin
GameConfig.COIN_SPAWN_RATE = 3 -- Seconds between coin spawns
GameConfig.MAX_COINS_PER_MAP = 50

-- Player Settings
GameConfig.PLAYER_SPEED = 16
GameConfig.PLAYER_JUMP_POWER = 50
GameConfig.PLAYER_WALK_SPEED = 16
GameConfig.PLAYER_MAX_SLOPE_ANGLE = 89

-- UI Colors
GameConfig.COLORS = {
	PRIMARY = Color3.fromRGB(52, 152, 219),
	SECONDARY = Color3.fromRGB(41, 128, 185),
	ACCENT = Color3.fromRGB(230, 126, 34),
	SUCCESS = Color3.fromRGB(46, 204, 113),
	WARNING = Color3.fromRGB(241, 196, 15),
	DANGER = Color3.fromRGB(231, 76, 60),
	BACKGROUND = Color3.fromRGB(44, 62, 80),
	TEXT = Color3.fromRGB(236, 240, 241)
}

-- Maps Configuration
GameConfig.MAPS = {
	{
		name = "Tutorial",
		description = "Learn the basics of gravity shifting",
		difficulty = 1,
		unlocked = true,
		thumbnail = "rbxassetid://0",
		checkpoints = 3,
		coins = 15,
		spawnPoint = Vector3.new(0, 10, 0),
		finishPoint = Vector3.new(0, 10, 100),
		platforms = {
			{
				position = Vector3.new(0, 5, 20),
				size = Vector3.new(20, 2, 20),
				color = Color3.fromRGB(52, 152, 219),
				type = "normal"
			},
			{
				position = Vector3.new(0, 15, 40),
				size = Vector3.new(15, 2, 15),
				color = Color3.fromRGB(46, 204, 113),
				type = "normal"
			},
			{
				position = Vector3.new(0, 25, 60),
				size = Vector3.new(12, 2, 12),
				color = Color3.fromRGB(230, 126, 34),
				type = "normal"
			},
			{
				position = Vector3.new(0, 35, 80),
				size = Vector3.new(10, 2, 10),
				color = Color3.fromRGB(155, 89, 182),
				type = "normal"
			}
		},
		coins = {
			{position = Vector3.new(0, 8, 20)},
			{position = Vector3.new(0, 18, 40)},
			{position = Vector3.new(0, 28, 60)},
			{position = Vector3.new(0, 38, 80)}
		},
		checkpoints = {
			{position = Vector3.new(0, 8, 20)},
			{position = Vector3.new(0, 18, 40)},
			{position = Vector3.new(0, 28, 60)}
		},
		obstacles = {}
	},
	{
		name = "Sky High",
		description = "Navigate through floating platforms",
		difficulty = 2,
		unlocked = false,
		thumbnail = "rbxassetid://0",
		checkpoints = 5,
		coins = 25,
		spawnPoint = Vector3.new(0, 10, 0),
		finishPoint = Vector3.new(0, 50, 150),
		platforms = {
			{
				position = Vector3.new(0, 20, 30),
				size = Vector3.new(15, 2, 15),
				color = Color3.fromRGB(52, 152, 219),
				type = "moving",
				speed = Vector3.new(0, 1, 0)
			},
			{
				position = Vector3.new(30, 35, 60),
				size = Vector3.new(12, 2, 12),
				color = Color3.fromRGB(46, 204, 113),
				type = "normal"
			},
			{
				position = Vector3.new(-30, 50, 90),
				size = Vector3.new(10, 2, 10),
				color = Color3.fromRGB(230, 126, 34),
				type = "normal"
			},
			{
				position = Vector3.new(0, 65, 120),
				size = Vector3.new(8, 2, 8),
				color = Color3.fromRGB(155, 89, 182),
				type = "normal"
			}
		},
		coins = {
			{position = Vector3.new(0, 23, 30)},
			{position = Vector3.new(30, 38, 60)},
			{position = Vector3.new(-30, 53, 90)},
			{position = Vector3.new(0, 68, 120)}
		},
		checkpoints = {
			{position = Vector3.new(0, 23, 30)},
			{position = Vector3.new(30, 38, 60)},
			{position = Vector3.new(-30, 53, 90)},
			{position = Vector3.new(0, 68, 120)}
		},
		obstacles = {
			{
				position = Vector3.new(15, 25, 45),
				size = Vector3.new(5, 10, 5),
				color = Color3.fromRGB(231, 76, 60)
			}
		}
	},
	{
		name = "Maze Runner",
		description = "Complex maze with gravity puzzles",
		difficulty = 3,
		unlocked = false,
		thumbnail = "rbxassetid://0",
		checkpoints = 8,
		coins = 40,
		spawnPoint = Vector3.new(0, 10, 0),
		finishPoint = Vector3.new(0, 10, 200),
		platforms = {
			{
				position = Vector3.new(0, 5, 20),
				size = Vector3.new(20, 2, 20),
				color = Color3.fromRGB(52, 152, 219),
				type = "normal"
			},
			{
				position = Vector3.new(25, 5, 45),
				size = Vector3.new(15, 2, 15),
				color = Color3.fromRGB(46, 204, 113),
				type = "normal"
			},
			{
				position = Vector3.new(-25, 5, 70),
				size = Vector3.new(15, 2, 15),
				color = Color3.fromRGB(230, 126, 34),
				type = "normal"
			},
			{
				position = Vector3.new(0, 5, 95),
				size = Vector3.new(20, 2, 20),
				color = Color3.fromRGB(155, 89, 182),
				type = "normal"
			}
		},
		coins = {
			{position = Vector3.new(0, 8, 20)},
			{position = Vector3.new(25, 8, 45)},
			{position = Vector3.new(-25, 8, 70)},
			{position = Vector3.new(0, 8, 95)}
		},
		checkpoints = {
			{position = Vector3.new(0, 8, 20)},
			{position = Vector3.new(25, 8, 45)},
			{position = Vector3.new(-25, 8, 70)},
			{position = Vector3.new(0, 8, 95)}
		},
		obstacles = {
			{
				position = Vector3.new(10, 5, 35),
				size = Vector3.new(3, 8, 3),
				color = Color3.fromRGB(231, 76, 60)
			},
			{
				position = Vector3.new(-10, 5, 35),
				size = Vector3.new(3, 8, 3),
				color = Color3.fromRGB(231, 76, 60)
			}
		}
	},
	{
		name = "Speed Demon",
		description = "Fast-paced gravity challenges",
		difficulty = 4,
		unlocked = false,
		thumbnail = "rbxassetid://0",
		checkpoints = 10,
		coins = 50,
		spawnPoint = Vector3.new(0, 10, 0),
		finishPoint = Vector3.new(0, 10, 300),
		platforms = {
			{
				position = Vector3.new(0, 5, 25),
				size = Vector3.new(18, 2, 18),
				color = Color3.fromRGB(52, 152, 219),
				type = "normal"
			},
			{
				position = Vector3.new(0, 15, 50),
				size = Vector3.new(15, 2, 15),
				color = Color3.fromRGB(46, 204, 113),
				type = "bounce",
				bouncePower = 80
			},
			{
				position = Vector3.new(0, 25, 75),
				size = Vector3.new(12, 2, 12),
				color = Color3.fromRGB(230, 126, 34),
				type = "breakable"
			},
			{
				position = Vector3.new(0, 35, 100),
				size = Vector3.new(10, 2, 10),
				color = Color3.fromRGB(155, 89, 182),
				type = "normal"
			}
		},
		coins = {
			{position = Vector3.new(0, 8, 25)},
			{position = Vector3.new(0, 18, 50)},
			{position = Vector3.new(0, 28, 75)},
			{position = Vector3.new(0, 38, 100)}
		},
		checkpoints = {
			{position = Vector3.new(0, 8, 25)},
			{position = Vector3.new(0, 18, 50)},
			{position = Vector3.new(0, 28, 75)},
			{position = Vector3.new(0, 38, 100)}
		},
		obstacles = {
			{
				position = Vector3.new(0, 10, 40),
				size = Vector3.new(5, 5, 5),
				color = Color3.fromRGB(231, 76, 60)
			}
		}
	},
	{
		name = "Master's Challenge",
		description = "Ultimate gravity mastery test",
		difficulty = 5,
		unlocked = false,
		thumbnail = "rbxassetid://0",
		checkpoints = 15,
		coins = 100,
		spawnPoint = Vector3.new(0, 10, 0),
		finishPoint = Vector3.new(0, 10, 500),
		platforms = {
			{
				position = Vector3.new(0, 5, 30),
				size = Vector3.new(20, 2, 20),
				color = Color3.fromRGB(52, 152, 219),
				type = "normal"
			},
			{
				position = Vector3.new(0, 20, 60),
				size = Vector3.new(15, 2, 15),
				color = Color3.fromRGB(46, 204, 113),
				type = "moving",
				speed = Vector3.new(0, 2, 0)
			},
			{
				position = Vector3.new(0, 40, 90),
				size = Vector3.new(12, 2, 12),
				color = Color3.fromRGB(230, 126, 34),
				type = "breakable"
			},
			{
				position = Vector3.new(0, 60, 120),
				size = Vector3.new(10, 2, 10),
				color = Color3.fromRGB(155, 89, 182),
				type = "bounce",
				bouncePower = 100
			}
		},
		coins = {
			{position = Vector3.new(0, 8, 30)},
			{position = Vector3.new(0, 23, 60)},
			{position = Vector3.new(0, 43, 90)},
			{position = Vector3.new(0, 63, 120)}
		},
		checkpoints = {
			{position = Vector3.new(0, 8, 30)},
			{position = Vector3.new(0, 23, 60)},
			{position = Vector3.new(0, 43, 90)},
			{position = Vector3.new(0, 63, 120)}
		},
		obstacles = {
			{
				position = Vector3.new(0, 15, 45),
				size = Vector3.new(8, 8, 8),
				color = Color3.fromRGB(231, 76, 60)
			},
			{
				position = Vector3.new(0, 35, 75),
				size = Vector3.new(6, 6, 6),
				color = Color3.fromRGB(241, 196, 15)
			}
		}
	}
}

-- Shop Items
GameConfig.SHOP_ITEMS = {
	{
		id = "speed_boost",
		name = "Speed Boost",
		description = "Increase movement speed by 25%",
		price = 100,
		currency = "coins",
		type = "powerup"
	},
	{
		id = "jump_boost",
		name = "Jump Boost", 
		description = "Increase jump power by 30%",
		price = 150,
		currency = "coins",
		type = "powerup"
	},
	{
		id = "gravity_master",
		name = "Gravity Master",
		description = "Reduce gravity change cooldown",
		price = 200,
		currency = "coins",
		type = "powerup"
	},
	{
		id = "coin_magnet",
		name = "Coin Magnet",
		description = "Automatically collect nearby coins",
		price = 300,
		currency = "coins",
		type = "powerup"
	},
	{
		id = "premium_skin",
		name = "Neon Character",
		description = "Exclusive neon character skin",
		price = 50,
		currency = "robux",
		type = "cosmetic"
	},
	{
		id = "vip_pass",
		name = "VIP Pass",
		description = "Access to exclusive maps and features",
		price = 100,
		currency = "robux",
		type = "cosmetic"
	}
}

-- Power-up Effects
GameConfig.POWERUP_EFFECTS = {
	speed_boost = {
		duration = 30,
		speed_multiplier = 1.25
	},
	jump_boost = {
		duration = 30,
		jump_multiplier = 1.3
	},
	gravity_master = {
		duration = 60,
		cooldown_reduction = 0.3
	},
	coin_magnet = {
		duration = 45,
		range = 20
	}
}

return GameConfig 