-- =========================
-- TOGGLE AUTO-UPGRADE SYSTEM (FIXED 10x)
-- 3 → FAST 10x → 4 → FAST 10x
-- MASS CODE REDEEM + UI
-- =========================

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local remote = ReplicatedStorage
    :WaitForChild("RemoteEvent")
    :WaitForChild("ServerRemoteEvent")

-- =========================
-- UI (CENTERED)
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "AutoUpgradeUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.Size = UDim2.fromScale(0.7, 0.18)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 20)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.fromScale(1,1)
label.BackgroundTransparency = 1
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.TextColor3 = Color3.fromRGB(0, 255, 170)
label.Text = "🚀 Script Loading..."

-- =========================
-- MASS CODE REDEEM (ONE TIME)
-- =========================
local codes = {
    "RELEASE1","RELEASE2","RELEASE3","1KLIKE","5KLIKE",
    "NEWFRRUIT1","NEWFRRUIT2","SINP5",
    "Christmas1","Christmas2","Christmas3",
    "UPDATE1","UPDATE2","UPDATE3","update4",
    "FUSE777","BEST999","NEW666","VIP888","GROW888",
    "REDRESS","KGFRUIT","CRYSTAL1","CRYSTAL2",
    "CRYSTAL5000","BOSSFIX"
}

label.Text = "🎁 Redeeming codes..."
for _, code in ipairs(codes) do
    for i = 1, 2 do
        pcall(function()
            remote:FireServer("GetCode", code)
        end)
        task.wait(0.15)
    end
end

-- =========================
-- STATE
-- =========================
local enabled = false

-- =========================
-- TOGGLE BUTTON
-- =========================
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 280, 0, 50)
toggleButton.Position = UDim2.new(0.5, -140, 0.8, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextScaled = true
toggleButton.Text = "AUTO SYSTEM: OFF"
toggleButton.Parent = gui

toggleButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        toggleButton.Text = "AUTO SYSTEM: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        label.Text = "🔁 Loop running (3 → 10x → 4 → 10x)"
    else
        toggleButton.Text = "AUTO SYSTEM: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        label.Text = "🚀 Script paused"
    end
end)

-- =========================
-- FUNCTIONS
-- =========================
local function changeNumber(num)
    pcall(function()
        remote:FireServer("Change_ArrayBool_Item","\230\137\139\231\137\140",num)
    end)
end

local function upgrade10x()
    for i = 1, 10 do
        if not enabled then break end
        pcall(function()
            remote:FireServer(
                "Business",
                "\229\143\152\229\140\150_\229\174\160\231\137\169",
                28
            )
        end)
        task.wait(0.06) -- FAST 10x
    end
end

-- =========================
-- MAIN LOOP
-- =========================
task.spawn(function()
    while true do
        if not enabled then task.wait(0.25) continue end

        -- Step 1: 3
        changeNumber(3)
        task.wait(0.1)
        upgrade10x()

        -- Step 2: 4
        changeNumber(4)
        task.wait(0.1)
        upgrade10x()
    end
end)

print("✅ Script running with 10x upgrades restored")
