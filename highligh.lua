local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Teams = game:GetService("Teams")
local TweenService = game:GetService("TweenService")

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
            if player.Character:FindFirstChild("TeamHighlight") then
                player.Character.TeamHighlight:Destroy()
            end
        end
    end

    if npcHighlightEnabled then
        for _, rig in pairs(Workspace:GetChildren()) do
            if rig:IsA("Model") and rig:FindFirstChild("Humanoid") and not Players:FindFirstChild(rig.Name) then
                addHighlight(rig, enemyColor)
            end
        end
    end
end

-- Smooth GUI
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "HighlightMenu"

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 0, 0, 0) -- Start hidden
menuFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center
menuFrame.AnchorPoint = Vector2.new(0.5, 0.5)
menuFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
menuFrame.BorderSizePixel = 0
menuFrame.Parent = screenGui
menuFrame.ClipsDescendants = true
menuFrame.Rounded = 12

-- Tween menu open
local function openMenu()
    local tween = TweenService:Create(menuFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 250, 0, 200)})
    tween:Play()
end

-- Tween menu close
local function closeMenu()
    local tween = TweenService:Create(menuFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)})
    tween:Play()
end

-- Buttons
local function createButton(text, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = position
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.AutoButtonColor = true
    btn.Parent = menuFrame
    btn.MouseButton1Click:Connect(callback)
end

-- Example buttons
createButton("Toggle Highlights", UDim2.new(0, 25, 0, 20), function()
    highlightEnabled = not highlightEnabled
    updateHighlights()
end)

createButton("Toggle NPCs", UDim2.new(0, 25, 0, 70), function()
    npcHighlightEnabled = not npcHighlightEnabled
    updateHighlights()
end)

createButton("Close Menu", UDim2.new(0, 25, 0, 120), closeMenu)

-- Open menu when pressing H
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.H then
        openMenu()
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(updateHighlights)
end)

Workspace.ChildAdded:Connect(updateHighlights)

updateHighlights()
