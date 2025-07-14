-- Simple test script to debug the game
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("=== GRAVITY SHIFT DEBUG TEST ===")

-- Test 1: Check if player exists
local player = Players.LocalPlayer
if player then
	print("✓ Player found:", player.Name)
else
	print("✗ No player found")
	return
end

-- Test 2: Check if ReplicatedStorage exists
if ReplicatedStorage then
	print("✓ ReplicatedStorage found")
else
	print("✗ ReplicatedStorage not found")
	return
end

-- Test 3: Check if Shared folder exists
local Shared = ReplicatedStorage:FindFirstChild("Shared")
if Shared then
	print("✓ Shared folder found")
else
	print("✗ Shared folder not found")
end

-- Test 4: Check if RemoteEvents folder exists
local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
if RemoteEvents then
	print("✓ RemoteEvents folder found")
	
	-- Check individual remote events
	local events = {"RequestPlayerData", "UpdatePlayerData", "StartGame", "EndGame", "PurchaseItem", "CollectCoin", "UpdateGravity"}
	for _, eventName in ipairs(events) do
		local event = RemoteEvents:FindFirstChild(eventName)
		if event then
			print("  ✓ " .. eventName .. " found")
		else
			print("  ✗ " .. eventName .. " not found")
		end
	end
else
	print("✗ RemoteEvents folder not found")
end

-- Test 5: Check if PlayerScripts exists
local PlayerScripts = player:FindFirstChild("PlayerScripts")
if PlayerScripts then
	print("✓ PlayerScripts found")
	
	-- Check if Client folder exists
	local Client = PlayerScripts:FindFirstChild("Client")
	if Client then
		print("  ✓ Client folder found")
		
		-- Check if GameController exists
		local GameController = Client:FindFirstChild("GameController")
		if GameController then
			print("    ✓ GameController found")
		else
			print("    ✗ GameController not found")
		end
	else
		print("  ✗ Client folder not found")
	end
else
	print("✗ PlayerScripts not found")
end

-- Test 6: Check if PlayerGui exists
local PlayerGui = player:FindFirstChild("PlayerGui")
if PlayerGui then
	print("✓ PlayerGui found")
	
	-- Check if LobbyUI exists
	local LobbyUI = PlayerGui:FindFirstChild("LobbyUI")
	if LobbyUI then
		print("  ✓ LobbyUI found")
		
		-- Check if play button exists
		local playButton = LobbyUI:FindFirstChild("playButton", true)
		if playButton then
			print("    ✓ Play button found")
		else
			print("    ✗ Play button not found")
		end
	else
		print("  ✗ LobbyUI not found")
	end
else
	print("✗ PlayerGui not found")
end

print("=== DEBUG TEST COMPLETE ===") 