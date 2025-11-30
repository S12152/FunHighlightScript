local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Teams = game:GetService("Teams")

local highlightEnabled = true
local npcHighlightEnabled = true
local teammateColor = Color3.fromRGB(0, 255, 0)
local enemyColor = Color3.fromRGB(255, 0, 0)

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

-- Update highlights
local function updateHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player ~= LocalPlayer and highlightEnabled then
            if player.Team == LocalPlayer.Team then
                addHighlight(player.Character, teammateColor)
            else
                addHighlight(player.Character, enemyColor)
            end
        elseif player.Character then
            -- Remove highlights if disabled
            if player.Character:FindFirstChild("TeamHighlight") then
                player.Character.TeamHighlight:Destroy()
            end
        end
    end

    -- NPCs
    if npcHighlightEnabled then
        for _, rig in pairs(Workspace:GetChildren()) do
            if rig:IsA("Model") and rig:FindFirstChild("Humanoid") and not Players:FindFirstChild(rig.Name) then
                addHighlight(rig, enemyColor)
            end
        end
    end
end

-- GUI
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "HighlightMenu"

local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0,150,0,50)
toggleButton.Position = UDim2.new(0,10,0,10)
toggleButton.Text = "Toggle Highlights"

toggleButton.MouseButton1Click:Connect(function()
    highlightEnabled = not highlightEnabled
    updateHighlights()
end)

local toggleNPCButton = Instance.new("TextButton", screenGui)
toggleNPCButton.Size = UDim2.new(0,150,0,50)
toggleNPCButton.Position = UDim2.new(0,10,0,70)
toggleNPCButton.Text = "Toggle NPCs"

toggleNPCButton.MouseButton1Click:Connect(function()
    npcHighlightEnabled = not npcHighlightEnabled
    updateHighlights()
end)

-- Initial highlight
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(updateHighlights)
end)

Workspace.ChildAdded:Connect(updateHighlights)

updateHighlights()
