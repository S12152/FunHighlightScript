local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Enemy highlight color
local enemyColor = Color3.fromRGB(255, 0, 0) -- red

-- Function to highlight a character
local function addHighlight(character)
    if not character then return end
    if character:FindFirstChild("EnemyHighlight") then
        character.EnemyHighlight:Destroy()
    end
    local highlight = Instance.new("Highlight")
    highlight.Name = "EnemyHighlight"
    highlight.Adornee = character
    highlight.FillColor = enemyColor
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.2
    highlight.Parent = character
end

-- Highlight enemies
local function highlightEnemies()
    local hasTeams = false
    -- Check if any player has a team
    for _, player in pairs(Players:GetPlayers()) do
        if player.Team ~= nil then
            hasTeams = true
            break
        end
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player ~= LocalPlayer then
            if hasTeams then
                if player.Team ~= LocalPlayer.Team then
                    addHighlight(player.Character) -- Only enemies
                end
            else
                addHighlight(player.Character) -- Everyone else if no teams
            end
        end
    end
end

-- GUI button
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local button = Instance.new("TextButton")
button.Size = UDim2.new(0,150,0,50)
button.Position = UDim2.new(0,20,0,20)
button.Text = "Highlight Enemies"
button.BackgroundColor3 = Color3.fromRGB(70,70,70)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.Parent = screenGui

-- Click to highlight
button.MouseButton1Click:Connect(highlightEnemies)
