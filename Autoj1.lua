-- AutoServerHop LocalScript (Live Servers)
-- Place this in a LocalScript or run via loadstring

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local PlaceId = game.PlaceId
local currentServerId = game.JobId
local autoHop = false
local JobIdBlacklist = {}

-- ====== UI ======
local gui = Instance.new("ScreenGui")
gui.Name = "ServerHopUI"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 160)
frame.Position = UDim2.new(0.5, -120, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = frame

-- Auto Hop Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 220, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
toggleButton.TextColor3 = Color3.fromRGB(255,255,255)
toggleButton.Text = "Auto Hop: OFF"
toggleButton.Parent = frame
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0,8)
toggleCorner.Parent = toggleButton

-- Rejoin Button
local rejoinButton = Instance.new("TextButton")
rejoinButton.Size = UDim2.new(0,220,0,40)
rejoinButton.Position = UDim2.new(0,10,0,60)
rejoinButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
rejoinButton.TextColor3 = Color3.fromRGB(255,255,255)
rejoinButton.Text = "Rejoin Current Server"
rejoinButton.Parent = frame
local rejoinCorner = Instance.new("UICorner")
rejoinCorner.CornerRadius = UDim.new(0,8)
rejoinCorner.Parent = rejoinButton

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0,220,0,30)
statusLabel.Position = UDim2.new(0,10,0,115)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200,200,200)
statusLabel.Text = "Status: Idle"
statusLabel.TextScaled = true
statusLabel.Parent = frame

-- ====== Server Hop Functions ======
local function getServers()
    local servers = {}
    local success, response = pcall(function()
        return HttpService:GetAsync("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    end)
    if success then
        local data = HttpService:JSONDecode(response)
        if data and data.data then
            for _, server in pairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= currentServerId and not table.find(JobIdBlacklist, server.id) then
                    table.insert(servers, server.id)
                end
            end
        end
    else
        warn("Failed to fetch servers")
    end
    return servers
end

local function hopServer()
    statusLabel.Text = "Finding a new server..."
    statusLabel.TextColor3 = Color3.fromRGB(255,255,0)

    local servers = getServers()
    if #servers == 0 then
        statusLabel.Text = "No available servers!"
        statusLabel.TextColor3 = Color3.fromRGB(255,0,0)
        return
    end

    local nextServer = servers[math.random(1, #servers)]
    table.insert(JobIdBlacklist, currentServerId)
    statusLabel.Text = "Teleporting..."
    statusLabel.TextColor3 = Color3.fromRGB(0,255,0)
    TeleportService:TeleportToPlaceInstance(PlaceId, nextServer, player)
end

-- ====== Button Logic ======
toggleButton.MouseButton1Click:Connect(function()
    autoHop = not autoHop
    if autoHop then
        toggleButton.Text = "Auto Hop: ON"
        statusLabel.Text = "Status: Running..."
        statusLabel.TextColor3 = Color3.fromRGB(0,255,0)
        spawn(function()
            while autoHop do
                hopServer()
                local timer = 0
                while timer < 60 and autoHop do
                    wait(1)
                    timer = timer + 1
                    statusLabel.Text = "Next hop in "..(60-timer).."s"
                end
            end
        end)
    else
        toggleButton.Text = "Auto Hop: OFF"
        statusLabel.Text = "Status: Idle"
        statusLabel.TextColor3 = Color3.fromRGB(255,0,0)
    end
end)

rejoinButton.MouseButton1Click:Connect(function()
    statusLabel.Text = "Rejoining current server..."
    statusLabel.TextColor3 = Color3.fromRGB(0,255,0)
    TeleportService:TeleportToPlaceInstance(PlaceId, currentServerId, player)
end)
