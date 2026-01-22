-- =========================
-- 📦 MOBILE AUTO-UPGRADE + CODES
-- 3 → 4 → 5 → 6 → 7
-- 25 upgrades per number
-- Toggle-enabled
-- =========================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local remote = ReplicatedStorage:WaitForChild("RemoteEvent"):WaitForChild("ServerRemoteEvent")

-- =========================
-- UI (TOGGLE)
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "AutoUpgradeUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 80)
frame.Position = UDim2.new(0.5, -160, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5,0)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1,0,1,0)
label.BackgroundTransparency = 1
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.TextColor3 = Color3.fromRGB(255,0,0)
label.Text = "AUTO SYSTEM: OFF"

frame.Parent = gui

-- =========================
-- MASS CODE REDEEM
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

local function safeRedeem(code)
    for i = 1,3 do
        pcall(function()
            remote:FireServer("GetCode", code)
        end)
        task.wait(0.15)
    end
end

task.spawn(function()
    for _, code in ipairs(codes) do
        safeRedeem(code)
    end
    print("✅ All codes attempted")
end)

-- =========================
-- TOGGLE STATE
-- =========================
local enabled = false
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        enabled = not enabled
        label.Text = enabled and "AUTO SYSTEM: ON" or "AUTO SYSTEM: OFF"
        label.TextColor3 = enabled and Color3.fromRGB(0,255,170) or Color3.fromRGB(255,0,0)
    end
end)

-- =========================
-- UPGRADE FUNCTIONS
-- =========================
local numbers = {3,4,5,6,7}

local function changeNumber(num)
    local args = {"Change_ArrayBool_Item","\230\137\139\231\137\140",num}
    pcall(function()
        remote:FireServer(unpack(args))
    end)
end

local function upgrade25x()
    for i = 1,25 do
        if not enabled then break end
        pcall(function()
            remote:FireServer("Business","\229\143\152\229\140\150_\229\174\160\231\137\169",28)
        end)
        task.wait(0.1)
    end
end

-- =========================
-- MAIN LOOP
-- =========================
task.spawn(function()
    while true do
        if enabled then
            for _, num in ipairs(numbers) do
                if not enabled then break end
                changeNumber(num)
                upgrade25x()
                task.wait(0.6) -- switch to next number
            end
        else
            task.wait(0.25)
        end
    end
end)

print("✅ Mobile auto-upgrade script running with 25x upgrades per number")
