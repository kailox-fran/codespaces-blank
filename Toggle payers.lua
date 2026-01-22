-- =========================
-- 📦 MOBILE-FRIENDLY AUTO-UPGRADE SYSTEM
-- 3 → 4 → 5 → 6 → 7
-- 2x upgrades per number
-- 0.4s switching delay
-- Clickable toggle UI (mobile-friendly)
-- =========================

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local remote = ReplicatedStorage:WaitForChild("RemoteEvent"):WaitForChild("ServerRemoteEvent")

-- =========================
-- UI SETUP
-- =========================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "AutoUpgradeUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 360, 0, 120)
frame.Position = UDim2.new(0.5, -180, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.ClipsDescendants = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "📦 Auto Upgrade"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,255,255)

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0.9,0,0,50)
toggleBtn.Position = UDim2.new(0.05,0,0.5,0)
toggleBtn.Text = "Auto Upgrade: OFF"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextScaled = true
toggleBtn.TextColor3 = Color3.fromRGB(255,0,0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,100)

-- =========================
-- STATE
-- =========================
local enabled = false
local kgfruitRedeemed = false

toggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    toggleBtn.Text = enabled and "Auto Upgrade: ON" or "Auto Upgrade: OFF"
    toggleBtn.TextColor3 = enabled and Color3.fromRGB(0,255,170) or Color3.fromRGB(255,0,0)
end)

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

task.spawn(function()
    for _, code in ipairs(codes) do
        for i = 1, 2 do
            pcall(function()
                remote:FireServer("GetCode", code)
            end)
            task.wait(0.15)
        end
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

local function upgrade2x()
    for i = 1, 2 do
        if not enabled then break end
        pcall(function()
            remote:FireServer("Business","\229\143\152\229\140\150_\229\174\160\231\137\169",28)
        end)
        task.wait(0.06)
    end
end

-- =========================
-- MAIN LOOP
-- =========================
local numbers = {3,4,5,6,7}

task.spawn(function()
    while true do
        if enabled then
            for _, num in ipairs(numbers) do
                if not enabled then break end
                changeNumber(num)
                task.wait(0.4)
                upgrade2x()
            end
        else
            task.wait(0.25)
        end
    end
end)

print("✅ Mobile-friendly auto-upgrade running: 3→7 with 2x upgrades")
