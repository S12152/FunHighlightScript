local Players = game:GetService("Players")

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

local function trackPlayer(player)

    if player.Character then
        addHighlight(player.Character)
    end

    player.CharacterAdded:Connect(addHighlight)
end

for _, player in pairs(Players:GetPlayers()) do
    trackPlayer(player)
end

Players.PlayerAdded:Connect(trackPlayer)
