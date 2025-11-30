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

-- Highlight all enemy players
local function highlightEnemies()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Team ~= LocalPlayer.Team then
            addHighlight(player.Character)
        end
    end
end

-- Button GUI
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

-- Click event
button.MouseButton1Click:Connect(highlightEnemies)
