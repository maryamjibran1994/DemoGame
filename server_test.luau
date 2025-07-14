-- Simple server test script
-- Copy this into a Script in ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

print("=== SERVER TEST STARTING ===")

-- Create remote events
local remoteEvents = Instance.new("Folder")
remoteEvents.Name = "RemoteEvents"
remoteEvents.Parent = ReplicatedStorage

local startGame = Instance.new("RemoteEvent")
startGame.Name = "StartGame"
startGame.Parent = remoteEvents

print("Remote events created")

-- Handle StartGame requests
startGame.OnServerEvent:Connect(function(player, mapIndex)
    print("=== SERVER RECEIVED STARTGAME ===")
    print("Player:", player.Name)
    print("Map Index:", mapIndex)
    print("Player UserId:", player.UserId)
    
    -- Send a simple response back
    startGame:FireClient(player, "Game started!", "test_game_id")
    print("Response sent to client")
end)

print("=== SERVER TEST READY ===")
print("Waiting for client requests...") 