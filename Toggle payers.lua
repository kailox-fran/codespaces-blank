-- =========================
-- FINAL TOGGLE AUTO SYSTEM
-- FAST 3 → 10x → 4 → 10x
-- + MASS CODE REDEEM
-- =========================

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local remote = ReplicatedStorage
    :WaitForChild("RemoteEvent")
    :WaitForChild("ServerRemoteEvent")

-- UI PARENT (FIXED)
local uiParent
if gethui then
    uiParent = gethui()
else
    uiParent = LocalPlayer:WaitForChild("PlayerGui")
end

-- SETTINGS
local activatedSoundId = "rbxassetid://17503781665"

-- =========================
-- UI
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "AutoUpgradeUI"
gui.ResetOnSpawn = false
gui.Parent = uiParent

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 280, 0, 50)
toggleButton.Position = UDim2.new(0.5, -140, 0, 40)
toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.Text = "AUTO SYSTEM: OFF"
toggleButton.Parent = gui

print("✅ UI Loaded")

-- =========================
-- STATE
-- =========================
local enabled = false
local codesRedeemed = false

-- =========================
-- MASS CODES
-- =========================
local codes = {
    "RELEASE1","RELEASE2","RELEASE3","1KLIKE","5KLIKE",
    "NEWFRRUIT1","NEWFRRUIT2","SINP5",
    "Christmas1","Christmas2","Christmas3",
    "UPDATE1","UPDATE2","UPDATE3","update4",
    "FUSE777","BEST999","NEW666","VIP888","GROW888",
    "REDRESS","KGFRUIT",
    "CRYSTAL1","CRYSTAL2","CRYSTAL5000","BOSSFIX"
}

-- =========================
-- TOGGLE BUTTON
-- =========================
toggleButton.MouseButton1Click:Connect(function()
    enabled = not enabled

    if enabled then
        toggleButton.Text = "AUTO SYSTEM: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

        -- Sound
        local s = Instance.new("Sound")
        s.SoundId = activatedSoundId
        s.Volume = 1
        s.Parent = uiParent
        s:Play()

        -- Redeem codes ONCE
        if not codesRedeemed then
            codesRedeemed = true
            task.spawn(function()
                for _, code in ipairs(codes) do
                    for i = 1, 2 do
                        pcall(function()
                            remote:FireServer("GetCode", code)
                        end)
                        task.wait(0.15)
                    end
                end
                print("✅ All codes attempted")
            end)
        end
    else
        toggleButton.Text = "AUTO SYSTEM: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    end
end)

-- =========================
-- FAST LOOP
-- 3 → FAST 10x → 4 → FAST 10x
-- =========================
task.spawn(function()
    while task.wait(0.25) do
        if not enabled then continue end

        -- Change 3
        pcall(function()
            remote:FireServer("Change_ArrayBool_Item", "\230\137\139\231\137\140", 3)
        end)

        -- FAST 10x
        for i = 1, 10 do
            if not enabled then break end
            pcall(function()
                remote:FireServer(
                    "Business",
                    "\229\143\152\229\140\150_\229\174\160\231\137\169",
                    28
                )
            end)
            task.wait(0.06)
        end

        -- Change 4
        pcall(function()
            remote:FireServer("Change_ArrayBool_Item", "\230\137\139\231\137\140", 4)
        end)

        -- FAST 10x
        for i = 1, 10 do
            if not enabled then break end
            pcall(function()
                remote:FireServer(
                    "Business",
                    "\229\143\152\229\140\150_\229\174\160\231\137\169",
                    28
                )
            end)
            task.wait(0.06)
        end
    end
end)
