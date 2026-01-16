-------------------------------------------------
-- ONE-TIME PLAYER DETECTION → PERMANENT ACTION
-------------------------------------------------
local activated = false
local delayRunning = false

RunService.RenderStepped:Connect(function()
    -- Stop detection forever once activated
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

    -- Start delay ONCE
    if playerNearby and not delayRunning then
        delayRunning = true
        warn("Player detected → waiting 5 seconds...")

        task.delay(5, function()
            if activated then return end
            if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
                delayRunning = false
                return
            end

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
                warn("Activated → Auto Upgrade will now run endlessly")
            else
                warn("Player left before 5 seconds → cancelled")
                delayRunning = false
            end
        end)
    end
end)
