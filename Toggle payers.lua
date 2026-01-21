-- =========================
-- AUTO-UPGRADE SYSTEM (DRAGGABLE + FAST 10x + 3/4 SWITCH 50% FASTER)
-- =========================

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local remote = ReplicatedStorage
    :WaitForChild("RemoteEvent")
    :WaitForChild("ServerRemoteEvent")

-- =========================
-- UI (DRAGGABLE)
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "AutoUpgradeUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.Size = UDim2.fromScale(0.45, 0.12)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 18)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.fromScale(1,1)
label.BackgroundTransparency = 1
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.TextColor3 = Color3.fromRGB(0, 255, 170)
label.Text = "AUTO SYSTEM: OFF"

-- =========================
-- DRAG FUNCTION
-- =========================
local dragging = false
local dragInput, mousePos, framePos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X,
                                   framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
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
-- STATE
-- =========================
local enabled = false

-- =========================
-- TOGGLE
-- =========================
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        enabled = not enabled
        if enabled then
            label.Text = "AUTO SYSTEM: ON"
            label.TextColor3 = Color3.fromRGB(0, 255, 170)
        else
            label.Text = "AUTO SYSTEM: OFF"
            label.TextColor3 = Color3.fromRGB(255, 0, 0)
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
        task.wait(0.06) -- fast 10x
    end
end

-- =========================
-- MAIN LOOP (3 → 10x → 4 → 10x)
-- 50% faster switching between 3 and 4
-- =========================
task.spawn(function()
    while true do
        if not enabled then task.wait(0.25) continue end

        changeNumber(3)
        task.wait(0.05) -- SWITCH SPEED: HALF the previous wait
        upgrade10x()

        changeNumber(4)
        task.wait(0.05) -- SWITCH SPEED: HALF the previous wait
        upgrade10x()
    end
end)

print("✅ Script running with 50% faster 3/4 switching")
