local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local detectionRadius = 15
local highlightedPlayers = {}
local detecting = false

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NearbyDetectorUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 160, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.Text = "Detector: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextScaled = true
ToggleButton.Parent = ScreenGui

ToggleButton.MouseButton1Click:Connect(function()
    detecting = not detecting
    ToggleButton.Text = detecting and "Detector: ON" or "Detector: OFF"

    if not detecting then
        for _, gui in pairs(highlightedPlayers) do
            gui:Destroy()
        end
        highlightedPlayers = {}
    end
end)

local function highlightPlayer(player)
    if highlightedPlayers[player] then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = player.Character.HumanoidRootPart
    billboard.Size = UDim2.new(0,100,0,40)
    billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.AlwaysOnTop = true

    local text = Instance.new("TextLabel")
    text.Parent = billboard
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.Text = player.Name
    text.TextColor3 = Color3.new(1,0,0)
    text.TextScaled = true
    text.Font = Enum.Font.SourceSansBold

    billboard.Parent = game:GetService("CoreGui")
    highlightedPlayers[player] = billboard
end

local function removeHighlight(player)
    if highlightedPlayers[player] then
        highlightedPlayers[player]:Destroy()
        highlightedPlayers[player] = nil
    end
end

RunService.RenderStepped:Connect(function()
    if not detecting then return end
    if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then return end

    local myPos = LocalPlayer.Character.HumanoidRootPart.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (myPos - player.Character.HumanoidRootPart.Position).Magnitude
            if dist <= detectionRadius then
                highlightPlayer(player)
            else
                removeHighlight(player)
            end
        else
            removeHighlight(player)
        end
    end
end)
