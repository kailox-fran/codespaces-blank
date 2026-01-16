-- Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local PlaceId = game.PlaceId
local JobIdBlacklist = {}
local autoHop = false
local currentServerId = game.JobId

-- ===== Functions =====
local function getServers(cursor)
    local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    if cursor then url = url.."&cursor="..cursor end

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        return HttpService:JSONDecode(response)
    else
        warn("Failed to fetch servers")
        return nil
    end
end

local function serverHop()
    if not autoHop then return end

    local data = getServers()
    if not data then return end

    for _, server in pairs(data.data) do
        if server.playing < server.maxPlayers and not JobIdBlacklist[server.id] then
            JobIdBlacklist[server.id] = true
            StatusLabel.Text = "Teleporting to server..."
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            TeleportService:TeleportToPlaceInstance(PlaceId, server.id, player)
            return
        end
    end

    StatusLabel.Text = "No server found, try again manually"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
end

-- ===== UI Setup =====
local gui = Instance.new("ScreenGui")
gui.Name = "ServerHopUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- Draggable Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 160)
frame.Position = UDim2.new(0.5, -120, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- UI Corner for rounding
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

-- Auto Hop Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 220, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
toggleButton.TextColor3 = Color3.fromRGB(255,255,255)
toggleButton.Text = "Auto Hop: OFF"
toggleButton.Parent = frame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Rejoin Button
local rejoinButton = Instance.new("TextButton")
rejoinButton.Size = UDim2.new(0, 220, 0, 40)
rejoinButton.Position = UDim2.new(0, 10, 0, 60)
rejoinButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
rejoinButton.TextColor3 = Color3.fromRGB(255,255,255)
rejoinButton.Text = "Rejoin Current Server"
rejoinButton.Parent = frame

local rejoinCorner = Instance.new("UICorner")
rejoinCorner.CornerRadius = UDim.new(0, 8)
rejoinCorner.Parent = rejoinButton

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 220, 0, 30)
StatusLabel.Position = UDim2.new(0, 10, 0, 115)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(200,200,200)
StatusLabel.Text = "Status: Idle"
StatusLabel.TextScaled = true
StatusLabel.Parent = frame

-- ===== Button Logic =====
toggleButton.MouseEnter:Connect(function()
    toggleButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
end)
toggleButton.MouseLeave:Connect(function()
    toggleButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
end)

rejoinButton.MouseEnter:Connect(function()
    rejoinButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
end)
rejoinButton.MouseLeave:Connect(function()
    rejoinButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
end)

toggleButton.MouseButton1Click:Connect(function()
    autoHop = not autoHop
    if autoHop then
        toggleButton.Text = "Auto Hop: ON"
        StatusLabel.Text = "Status: Running..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        serverHop()
    else
        toggleButton.Text = "Auto Hop: OFF"
        StatusLabel.Text = "Status: Idle"
        StatusLabel.TextColor3 = Color3.fromRGB(255,0,0)
    end
end)

rejoinButton.MouseButton1Click:Connect(function()
    StatusLabel.Text = "Rejoining current server..."
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    TeleportService:TeleportToPlaceInstance(PlaceId, currentServerId, player)
end)
