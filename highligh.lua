-- LocalScript (put this in StarterPlayerScripts)
local Players = game:GetService("Players")

-- Function to add highlight to a character
local function addHighlight(character)
    if character:FindFirstChild("Highlight") then return end -- prevent duplicates

    local highlight = Instance.new("Highlight")
    highlight.Name = "Highlight"
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(0, 255, 0) -- glow color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- outline color
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- see-through walls
    highlight.Parent = character
end

-- Function to track a player
local function trackPlayer(player)
    -- Apply when character exists
    if player.Character then
        addHighlight(player.Character)
    end
    -- Reapply every time character respawns
    player.CharacterAdded:Connect(addHighlight)
end

-- Apply to all existing players
for _, player in pairs(Players:GetPlayers()) do
    trackPlayer(player)
end

-- Apply to new players who join
Players.PlayerAdded:Connect(trackPlayer)
