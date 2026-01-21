-- =========================
-- SERVICES
-- =========================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local remote = ReplicatedStorage
    :WaitForChild("RemoteEvent")
    :WaitForChild("ServerRemoteEvent")

-- =========================
-- =========================
-- UI (CENTERED & MOBILE SAFE)
-- =========================
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "StatusUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.fromScale(0.5, 0.5) -- CENTER
frame.Size = UDim2.fromScale(0.7, 0.18)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.05

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 20)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 255, 170)

local label = Instance.new("TextLabel")
label.Parent = frame
label.Size = UDim2.fromScale(1, 1)
label.BackgroundTransparency = 1
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.TextColor3 = Color3.fromRGB(0, 255, 170)
label.Text = "🚀 SCRIPT LOADING..."

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
    pcall(function()
        remote:FireServer("GetCode", code)
    end)
    task.wait(0.15)
end

-- =========================
-- FUNCTIONS
-- =========================
local function fireNumber(num)
    local args = {
        "Change_ArrayBool_Item",
        "\230\137\139\231\137\140",
        num
    }
    pcall(function()
        remote:FireServer(unpack(args))
    end)
end

local function fast10x()
    for i = 1, 10 do
        fireNumber(10)
        task.wait(0.03) -- FAST 10x
    end
end

-- =========================
-- MAIN LOOP (ENDLESS)
-- 3 → 10x → 4 → 10x
-- =========================
label.Text = "🔁 Loop running (3 ➜ 10x ➜ 4 ➜ 10x)"

task.spawn(function()
    while true do
        fireNumber(3)
        task.wait(0.1)
        fast10x()

        fireNumber(4)
        task.wait(0.1)
        fast10x()

        task.wait(0.2)
    end
end)

print("✅ Script fully running")
