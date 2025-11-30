local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local enemyColor = Color3.fromRGB(255, 0, 0) -- red for enemies/NPCs
local highlightName = "EnemyHighlight"

-- Function to add/update highlight
local function addHighlight(model)
    if not model then return end
    if model:FindFirstChild(highlightName) then
        model[highlightName]:Destroy()
    end
    local highlight = Instance.new("Highlight")
    highlight.Name = highlightName
    highlight.Adornee = model
    highlight.FillColor = enemyColor
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.2
    highlight.Parent = model
end

-- Main highlight function
local function highlightEnemiesAndNPCs()
    local hasTeams = false
    -- Check if any player has a team
    for _, player in pairs(Players:GetPlayers()) do
        if player.Team ~= nil then
            hasTeams = true
            break
        end
    end

    -- Highlight players
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            if hasTeams then
                if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
                    addHighlight(player.Character)
                end
            else
                if player ~= LocalPlayer then
                    addHighlight(player.Character)
                end
            end
        end
    end

    -- Highlight NPCs / rigs in workspace
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:FindFirstChild(obj.Name) then
            addHighlight(obj)
        end
    end
end

-- GUI button
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local button = Instance.new("TextButton")
button.Size = UDim2.new(0,150,0,50)
button.Position = UDim2.new(0,20,0,20)
button.Text = "Highlight Enemies/NPCs"
button.BackgroundColor3 = Color3.fromRGB(70,70,70)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.Parent = screenGui

-- Click to highlight
button.MouseButton1Click:Connect(highlightEnemiesAndNPCs)

-- Automatically highlight on new players or NPCs
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(highlightEnemiesAndNPCs)
end)

Workspace.ChildAdded:Connect(highlightEnemiesAndNPCs)
