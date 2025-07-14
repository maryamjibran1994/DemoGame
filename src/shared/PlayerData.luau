local PlayerData = {}

-- Default player data structure
function PlayerData.new()
	return {
		coins = 0,
		robux = 0,
		level = 1,
		experience = 0,
		experienceToNext = 100,
		mapsCompleted = {},
		bestTimes = {},
		powerups = {},
		cosmetics = {},
		settings = {
			soundEnabled = true,
			musicEnabled = true,
			particleEffects = true
		},
		statistics = {
			totalPlayTime = 0,
			coinsCollected = 0,
			gravityShifts = 0,
			mapsPlayed = 0,
			deaths = 0
		}
	}
end

-- Calculate level from experience
function PlayerData.calculateLevel(experience)
	local level = 1
	local expNeeded = 100
	
	while experience >= expNeeded do
		experience = experience - expNeeded
		level = level + 1
		expNeeded = expNeeded * 1.2 -- 20% increase per level
	end
	
	return level, experience, expNeeded
end

-- Add experience and return level up info
function PlayerData.addExperience(playerData, amount)
	playerData.experience = playerData.experience + amount
	local newLevel, remainingExp, expNeeded = PlayerData.calculateLevel(playerData.experience)
	
	local leveledUp = newLevel > playerData.level
	if leveledUp then
		playerData.level = newLevel
		playerData.experience = remainingExp
		playerData.experienceToNext = expNeeded
	end
	
	return leveledUp, newLevel
end

-- Check if map is unlocked
function PlayerData.isMapUnlocked(playerData, mapIndex)
	if mapIndex == 1 then return true end -- Tutorial is always unlocked
	
	local requiredLevel = mapIndex * 2 -- Each map requires level 2, 4, 6, 8, 10
	return playerData.level >= requiredLevel
end

-- Get player's best time for a map
function PlayerData.getBestTime(playerData, mapName)
	return playerData.bestTimes[mapName] or math.huge
end

-- Update best time if better
function PlayerData.updateBestTime(playerData, mapName, time)
	local currentBest = PlayerData.getBestTime(playerData, mapName)
	if time < currentBest then
		playerData.bestTimes[mapName] = time
		return true -- New record
	end
	return false
end

-- Add coins with level up bonus
function PlayerData.addCoins(playerData, amount)
	local bonus = math.floor(playerData.level * 0.1 * amount) -- 10% bonus per level
	local total = amount + bonus
	playerData.coins = playerData.coins + total
	playerData.statistics.coinsCollected = playerData.statistics.coinsCollected + total
	return total, bonus
end

-- Check if player can afford item
function PlayerData.canAfford(playerData, price, currency)
	if currency == "coins" then
		return playerData.coins >= price
	elseif currency == "robux" then
		return playerData.robux >= price
	end
	return false
end

-- Purchase item
function PlayerData.purchaseItem(playerData, price, currency)
	if not PlayerData.canAfford(playerData, price, currency) then
		return false
	end
	
	if currency == "coins" then
		playerData.coins = playerData.coins - price
	elseif currency == "robux" then
		playerData.robux = playerData.robux - price
	end
	
	return true
end

-- Get player's powerup level
function PlayerData.getPowerupLevel(playerData, powerupId)
	return playerData.powerups[powerupId] or 0
end

-- Upgrade powerup
function PlayerData.upgradePowerup(playerData, powerupId)
	playerData.powerups[powerupId] = PlayerData.getPowerupLevel(playerData, powerupId) + 1
end

-- Get total play time in formatted string
function PlayerData.getFormattedPlayTime(playerData)
	local totalSeconds = playerData.statistics.totalPlayTime
	local hours = math.floor(totalSeconds / 3600)
	local minutes = math.floor((totalSeconds % 3600) / 60)
	local seconds = totalSeconds % 60
	
	if hours > 0 then
		return string.format("%dh %dm %ds", hours, minutes, seconds)
	elseif minutes > 0 then
		return string.format("%dm %ds", minutes, seconds)
	else
		return string.format("%ds", seconds)
	end
end

return PlayerData 