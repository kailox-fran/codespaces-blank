-- =========================
-- COMBINED DETECTION + AUTO-UPGRADE + SOUND
-- =========================

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- SETTINGS
local detectionRadius = 15       -- Radius to detect players
local delayBeforeTrigger = 5     -- Seconds to wait after detection
local activatedSoundId = "rbxassetid://17503781665" -- Sound that says "Activated"

-- =========================
-- STATUS UI (DEBUG/FEEDBACK)
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "StatusUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 320, 0, 50)
label.Position = UDim2.new(0.5, -160, 0, 20)
label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
label.TextColor3 = Color3.new(1, 1, 1)
label.Font = Enum.Font.SourceSansBold
label.TextScaled = true
label.Text = "Waiting for nearby player..."
label.Parent = gui

-- =========================
-- AUTO-UPGRADE SYSTEM
-- =========================
local autoUpgradeEnabled = false
local kgfruitRedeemed = false

local function setAutoUpgrade(state)
    autoUpgradeEnabled = state
end

-- AUTO-UPGRADE LOOP
task.spawn(function()
    while task.wait(1) do
        if not autoUpgradeEnabled then continue end

        local playerId = LocalPlayer.UserId

        local sequence = {
            {"Business", "\230\148\190\231\189\174_\229\174\160\231\137\169", 28},
            {"Business", "\230\148\190\231\189\174_\229\174\160\231\137\169", playerId},
            {"Business", "\231\164\188\231\137\169\232\181\160\233\128\129_\231\161\174\229\174\154", playerId},
            {"Change_ArrayBool_Item", "\230\137\139\231\137\140", 3}
        }

        for _, args in ipairs(sequence) do
            pcall(function()
                ReplicatedStorage.RemoteEvent.ServerRemoteEvent:FireServer(unpack(args))
            end)
            task.wait(0.5)
        end

        if not kgfruitRedeemed then
            for i = 1, 3 do
                pcall(function()
                    ReplicatedStorage.RemoteEvent.ServerRemoteEvent:FireServer("GetCode", "KGFRUIT")
                end)
                task.wait(0.5)
            end
            kgfruitRedeemed = true
        end

        for i = 1, 10 do
            pcall(function()
                ReplicatedStorage.RemoteEvent.ServerRemoteEvent:FireServer(
                    "Business",
                    "\229\143\152\229\140\150_\229\174\160\231\137\169",
                    28
                )
            end)
            task.wait(0.3)
        end
    end
end)

-- =========================
-- ONE-TIME PLAYER DETECTION → TRIGGER AUTO-UPGRADE + SOUND
-- =========================
local activated = false
local delayRunning = false

RunService.RenderStepped:Connect(function()
    if activated then return end

    if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
        return
    end

    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    local playerNearby = false

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer
            and player.Character
            and player.Character:FindFirstChild("HumanoidRootPart") then

            if (myPos - player.Character.HumanoidRootPart.Position).Magnitude <= detectionRadius then
                playerNearby = true
                break
            end
        end
    end

    if playerNearby and not delayRunning then
        delayRunning = true
        label.Text = "Player detected — waiting 5 seconds..."

        task.delay(delayBeforeTrigger, function()
            if activated then return end
            if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
                delayRunning = false
                label.Text = "Waiting for nearby player..."
                return
            end

            -- Recheck if still nearby
            local stillNearby = false
            local pos = LocalPlayer.Character.HumanoidRootPart.Position

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer
                    and player.Character
                    and player.Character:FindFirstChild("HumanoidRootPart") then

                    if (pos - player.Character.HumanoidRootPart.Position).Magnitude <= detectionRadius then
                        stillNearby = true
                        break
                    end
                end
            end

            if stillNearby then
                activated = true
                setAutoUpgrade(true)
                label.Text = "Activated ✓ Auto-upgrade running"
                warn("Auto-upgrade triggered — loops forever")

                -- Play "Activated" sound
                local sound = Instance.new("Sound")
                sound.SoundId = activatedSoundId
                sound.Volume = 1
                sound.Parent = game:GetService("CoreGui")
                sound:Play()
            else
                delayRunning = false
                label.Text = "Player left — waiting again..."
            end
        end)
    end
end)
