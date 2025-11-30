local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Settings
local teammateColor = Color3.fromRGB(0, 255, 0) -- green
local enemyColor = Color3.fromRGB(255, 0, 0)    -- red

-- Function to add/update highlight
local function addHighlight(character, color)
    if not character then return end
    if character:FindFirstChild("TeamHighlight") then
        character.TeamHighlight:Destroy()
    end
    local highlight = Instance.new("Highlight")
    highlight.Name = "TeamHighlight"
    highlight.Adornee = character
    highlight.FillColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.2
    highlight.Parent = character
end

-- Highlight all players
local function highlightPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            if player.Team == LocalPlayer.Team then
                addHighlight(player.Character, teammateColor)
            else
                addHighlight(player.Character, enemyColor)
            end
        end
    end
end

-- Create GUI button
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local button = Instance.new("TextButton")
button.Size = UDim2.new(0,150,0,50)
button.Position = UDim2.new(0,20,0,20)
button.Text = "Highlight Players"
button.BackgroundColor3 = Color3.fromRGB(70,70,70)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.Parent = screenGui

-- Button click event
button.MouseButton1Click:Connect(function()
    highlightPlayers()
end)
