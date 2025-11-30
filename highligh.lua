-- Highlight All Players Script
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Function to create a highlight above a player
local function highlightPlayer(player)
    if player == LocalPlayer then return end -- Skip local player

    local character = player.Character
    if character and character:FindFirstChild("Head") then
        -- Remove existing highlight if exists
        if character:FindFirstChild("PlayerHighlight") then
            character.PlayerHighlight:Destroy()
        end

        -- Create BillboardGui
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "PlayerHighlight"
        billboard.Adornee = character.Head
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true

        -- Create TextLabel
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 0, 0) -- Red color
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        label.Text = player.Name
        label.Parent = billboard

        billboard.Parent = character
    end
end

-- Highlight existing players
for _, player in pairs(Players:GetPlayers()) do
    highlightPlayer(player)
end

-- Highlight new players when they join
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        highlightPlayer(player)
    end)
end)

-- Update highlights when character respawns
Players.PlayerRemoving:Connect(function(player)
    if player.Character and player.Character:FindFirstChild("PlayerHighlight") then
        player.Character.PlayerHighlight:Destroy()
    end
end)
