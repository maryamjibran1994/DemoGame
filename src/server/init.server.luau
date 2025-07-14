-- Wait for ReplicatedStorage to be available
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Wait for the Shared folder to be created by Rojo
local Shared = ReplicatedStorage:WaitForChild("Shared", 10)
if not Shared then
	warn("Shared folder not found in ReplicatedStorage")
	return
end

-- Test all shared modules first
local success = true
local errors = {}

-- Test GameConfig
local success1, result1 = pcall(require, Shared:WaitForChild("GameConfig", 10))
if not success1 then
	table.insert(errors, "GameConfig: " .. tostring(result1))
	success = false
end

-- Test PlayerData
local success2, result2 = pcall(require, Shared:WaitForChild("PlayerData", 10))
if not success2 then
	table.insert(errors, "PlayerData: " .. tostring(result2))
	success = false
end

-- Test UISystem
local success3, result3 = pcall(require, Shared:WaitForChild("UISystem", 10))
if not success3 then
	table.insert(errors, "UISystem: " .. tostring(result3))
	success = false
end

if not success then
	warn("Failed to load some modules:")
	for _, error in ipairs(errors) do
		warn("  " .. error)
	end
	return
end

-- Wait for GameManager to be available in the Server folder
local ServerFolder = ServerScriptService:WaitForChild("Server", 10)
if not ServerFolder then
	warn("Server folder not found in ServerScriptService")
	return
end

local GameManager = require(ServerFolder:WaitForChild("GameManager", 10))

-- Initialize the game manager
-- This will set up all the remote events and handle player connections

print("Gravity Shift - Server initialized!")

-- Set up workspace properties
local workspace = game:GetService("Workspace")
workspace.Gravity = 196.2 -- Default Roblox gravity

-- Set up lighting for better visual experience
local lighting = game:GetService("Lighting")
lighting.Ambient = Color3.fromRGB(100, 100, 100)
lighting.Brightness = 2
lighting.Outlines = false

print("Gravity Shift - Server setup complete!")