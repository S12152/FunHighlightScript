-- Team & Rig Highlight System
-- Safe for your own Roblox game
-- Author: You :)

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local Workspace = game:GetService("Workspace")

local function addHighlight(model, color)
    if not model then return end

    -- Remove old highlight
    local old = model:FindFirstChild("TeamHighlight")
    if old then old:Destroy() end

    local highlight = Instance.new("Highlight")
    highlight.Name = "TeamHighlight"
    highlight.Adornee = model
    highlight.FillColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.2
    highlight.Parent = model
end

local function highlightPlayer(target, reference)
    local char = target.Character
    if not char then return end

    if target.Team == reference.Team then
        addHighlight(char, Color3.fromRGB(0, 255, 0)) -- Green for team
    else
        addHighlight(char, Color3.fromRGB(255, 0, 0)) -- Red for enemy
    end
end

local function highlightAllPlayers(referencePlayer)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            highlightPlayer(plr, referencePlayer)
        end

        plr.CharacterAdded:Connect(function()
            highlightPlayer(plr, referencePlayer)
        end)
    end
end

local function highlightNPCs()
    for _, child in pairs(Workspace:GetChildren()) do
        if child:IsA("Model")
        and child:FindFirstChild("Humanoid")
        and not Players:FindFirstChild(child.Name) then
            addHighlight(child, Color3.fromRGB(255, 0, 0)) -- NPC = enemy
        end
    end
end

Workspace.ChildAdded:Connect(function(child)
    if child:IsA("Model")
    and child:FindFirstChild("Humanoid")
    and not Players:FindFirstChild(child.Name) then
        addHighlight(child, Color3.fromRGB(255, 0, 0))
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        highlightAllPlayers(player)
    end)
end)

for _, plr in pairs(Players:GetPlayers()) do
    highlightAllPlayers(plr)
end

highlightNPCs()
