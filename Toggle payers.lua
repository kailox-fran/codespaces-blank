-- =========================
-- MOBILE AUTO-UPGRADE 3→7
-- 10x upgrade per number
-- 0.4s delay between upgrades
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

-- Toggle ON/OFF
local enabled = false
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		enabled = not enabled
		if enabled then
			label.Text = "AUTO SYSTEM: ON"
			label.TextColor3 = Color3.fromRGB(0,255,170)
		else
			label.Text = "AUTO SYSTEM: OFF"
			label.TextColor3 = Color3.fromRGB(255,0,0)
		end
	end
end)

-- =========================
-- FUNCTIONS
-- =========================
local function upgrade10x()
	for i = 1,10 do
		if not enabled then break end
		local args = {
			"Business",
			"\229\143\152\229\140\150_\229\174\160\231\137\169",
			28
		}
		pcall(function()
			remote:FireServer(unpack(args))
		end)
		task.wait(0.3)
	end
end

local function changeNumber(num)
	pcall(function()
		remote:FireServer("Change_ArrayBool_Item","\230\137\139\231\137\140",num)
	end)
end

-- =========================
-- MAIN LOOP: 3 → 4 → 5 → 6 → 7
-- =========================
local numbers = {3,4,5,6,7}

task.spawn(function()
	while true do
		if enabled then
			for _, num in ipairs(numbers) do
				if not enabled then break end
				changeNumber(num)
				upgrade10x()
			end
		else
			task.wait(0.25)
		end
	end
end)

print("✅ Auto-upgrade 3→7 active with 10x upgrades per number")
