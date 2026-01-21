-- =========================
-- TOGGLE AUTO-UPGRADE SYSTEM
-- FAST 10x VERSION
-- =========================

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local remote = ReplicatedStorage
    :WaitForChild("RemoteEvent")
    :WaitForChild("ServerRemoteEvent")

-- SETTINGS
local activatedSoundId = "rbxassetid://17503781665"

-- =========================
-- UI
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "AutoUpgradeUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 280, 0, 50)
toggleButton.Position = UDim2.new(0.5, -140, 0, 20)
toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.Text = "AUTO UPGRADE: OFF"
toggleButton.Parent = gui

-- =========================
-- STATE
-- =========================
local autoUpgradeEnabled = false
local setupDone = false
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
-- TOGGLE
-- =========================
toggleButton.MouseButton1Click:Connect(function()
    autoUpgradeEnabled = not autoUpgradeEnabled

    if autoUpgradeEnabled then
        toggleButton.Text = "AUTO UPGRADE: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

        -- sound
        local s = Instance.new("Sound", game:GetService("CoreGui"))
        s.SoundId = activatedSoundId
        s.Volume = 1
        s:Play()

        -- one-time setup
        if not setupDone then
            setupDone = true

            local pid = LocalPlayer.UserId
            local setup = {
                {"Business","\230\148\190\231\189\174_\229\174\160\231\137\169",28},
                {"Business","\230\148\190\231\189\174_\229\174\160\231\137\169",pid},
                {"Business","\231\164\188\231\137\169\232\181\160\233\128\129_\231\161\174\229\174\154",pid},
            }

            for _,v in ipairs(setup) do
                pcall(function() remote:FireServer(unpack(v)) end)
                task.wait(0.2)
            end
        end

        -- redeem codes ONCE
        if not codesRedeemed then
            codesRedeemed = true
            for _,code in ipairs(codes) do
                for i = 1, 2 do
                    pcall(function()
                        remote:FireServer("GetCode", code)
                    end)
                    task.wait(0.15)
                end
            end
        end
    else
        toggleButton.Text = "AUTO UPGRADE: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    end
end)

-- =========================
-- FAST LOOP: 3 → FAST 10x → 4 → FAST 10x
-- =========================
task.spawn(function()
    while task.wait(0.3) do
        if not autoUpgradeEnabled then continue end

        -- 3
        pcall(function()
            remote:FireServer("Change_ArrayBool_Item","\230\137\139\231\137\140",3)
        end)
        task.wait(0.15)

        -- FAST 10x
        for i = 1, 10 do
            if not autoUpgradeEnabled then break end
            pcall(function()
                remote:FireServer(
                    "Business",
                    "\229\143\152\229\140\150_\229\174\160\231\137\169",
                    28
                )
            end)
            task.wait(0.08) -- 🔥 FAST
        end

        -- 4
        pcall(function()
            remote:FireServer("Change_ArrayBool_Item","\230\137\139\231\137\140",4)
        end)
        task.wait(0.15)

        -- FAST 10x
        for i = 1, 10 do
            if not autoUpgradeEnabled then break end
            pcall(function()
                remote:FireServer(
                    "Business",
                    "\229\143\152\229\140\150_\229\174\160\231\137\169",
                    28
                )
            end)
            task.wait(0.08) -- 🔥 FAST
        end
    end
end)
