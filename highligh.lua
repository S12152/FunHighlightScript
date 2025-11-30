local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local enemyColor = Color3.fromRGB(255,0,0)
local highlightName = "EnemyHighlight"

-- Add or update highlight on a model
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
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.OutlineTransparency = 0.2
    highlight.Parent = model
end

-- Highlight all relevant targets
local function highlightTargets()
    local hasTeams = false
    for _, p in pairs(Players:GetPlayers()) do
        if p.Team ~= nil then
            hasTeams = true
            break
        end
    end

    -- Highlight players
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p ~= LocalPlayer then
            if hasTeams then
                if p.Team ~= LocalPlayer.Team then
                    addHighlight(p.Character)
                end
            else
                addHighlight(p.Character)
            end
        end
    end

    -- Highlight NPCs / rigs
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

button.MouseButton1Click:Connect(highlightTargets)

-- Update when new players spawn
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(highlightTargets)
end)

Workspace.ChildAdded:Connect(highlightTargets)
