-- Simple test script to run directly in Roblox Studio
-- Copy this into a LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("=== SIMPLE TEST STARTING ===")

-- Wait for player
local player = Players.LocalPlayer
if not player then
    print("No player found")
    return
end

print("Player found:", player.Name)

-- Wait for PlayerGui
local playerGui = player:WaitForChild("PlayerGui")
print("PlayerGui found")

-- Create a simple test UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleTestUI"
screenGui.Parent = playerGui

-- Create a test button
local testButton = Instance.new("TextButton")
testButton.Size = UDim2.new(0, 200, 0, 50)
testButton.Position = UDim2.new(0.5, -100, 0.5, -25)
testButton.Text = "SIMPLE TEST BUTTON"
testButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
testButton.TextColor3 = Color3.fromRGB(255, 255, 255)
testButton.Font = Enum.Font.GothamBold
testButton.TextScaled = true
testButton.Parent = screenGui

print("Test button created")

-- Connect the button
testButton.MouseButton1Click:Connect(function()
    print("=== TEST BUTTON CLICKED! ===")
    
    -- Test if we can access ReplicatedStorage
    if ReplicatedStorage then
        print("✓ ReplicatedStorage accessible")
        
        -- Test if RemoteEvents exist
        local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
        if remoteEvents then
            print("✓ RemoteEvents folder found")
            
            -- Test if StartGame exists
            local startGame = remoteEvents:FindFirstChild("StartGame")
            if startGame then
                print("✓ StartGame remote event found")
                print("Attempting to fire StartGame...")
                startGame:FireServer(1)
                print("StartGame fired!")
            else
                print("✗ StartGame remote event not found")
            end
        else
            print("✗ RemoteEvents folder not found")
        end
    else
        print("✗ ReplicatedStorage not accessible")
    end
end)

print("=== SIMPLE TEST READY ===")
print("Click the red button to test!") 