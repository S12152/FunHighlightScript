-- LocalScript (put in StarterPlayerScripts)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPGui"
screenGui.Parent = CoreGui

-- Create a toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Toggle ESP"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = screenGui

local espEnabled = false

-- Function to add highlight to a character
local function addHighlight(character)
    if character:FindFirstChild("Highlight") then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "Highlight"
    highlight.Adornee = character
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
end

-- Remove highlight
local function removeHighlight(character)
    if character:FindFirstChild("Highlight") then
        character.Highlight:Destroy()
    end
end

-- Apply or remove ESP for all players
local function updateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            if espEnabled then
                addHighlight(plr.Character)
            else
                removeHighlight(plr.Character)
            end
            -- Track respawns
            plr.CharacterAdded:Connect(function(char)
                if espEnabled then
                    addHighlight(char)
                end
            end)
        end
    end
end

-- Button toggle
toggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    updateESP()
end)

-- Initialize for current players
updateESP()
