local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for the Shared folder to be created by Rojo
local Shared = ReplicatedStorage:WaitForChild("Shared", 10)
if not Shared then
	warn("Shared folder not found in ReplicatedStorage")
	return
end

-- Wait for GameController to be available in the Client folder
local player = Players.LocalPlayer
print("Local player found:", player.Name)

local PlayerScripts = player:WaitForChild("PlayerScripts", 10)
if not PlayerScripts then
	warn("PlayerScripts not found")
	return
end
print("PlayerScripts found")

local ClientFolder = PlayerScripts:WaitForChild("Client", 10)
if not ClientFolder then
	warn("Client folder not found in PlayerScripts")
	return
end
print("Client folder found")

local GameControllerModule = ClientFolder:WaitForChild("GameController", 10)
if not GameControllerModule then
	warn("GameController module not found in Client folder")
	return
end
print("GameController module found")

local GameController = require(GameControllerModule)

-- Check if GameController loaded successfully
if not GameController then
	warn("Failed to load GameController")
	return
end
print("GameController loaded successfully")

-- Wait for character to load
local character = player.Character or player.CharacterAdded:Wait()

-- Initialize game when character is ready
character:WaitForChild("Humanoid")
character:WaitForChild("HumanoidRootPart")

-- Initialize the game
local success, err = pcall(GameController.init)
if not success then
	warn("Failed to initialize GameController:", err)
	return
end

-- Handle character respawning
player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	character:WaitForChild("Humanoid")
	character:WaitForChild("HumanoidRootPart")
	
	-- Re-initialize game controller for new character
	local success, err = pcall(GameController.init)
	if not success then
		warn("Failed to re-initialize GameController:", err)
	end
end)

print("Gravity Shift - Client initialized!")