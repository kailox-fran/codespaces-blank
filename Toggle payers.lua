-- =========================
-- MOBILE AUTO-UPGRADE 3→7 + SAFE CODE REDEMPTION
-- 10x upgrade per number, 0.4s delay
-- Toggle UI for mobile (DRAGGABLE)
-- =========================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local remote = ReplicatedStorage:WaitForChild("RemoteEvent"):WaitForChild("ServerRemoteEvent")

-- =========================
-- UI (TOGGLE & DRAGGABLE)
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "AutoUpgradeUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 100)
frame.Position = UDim2.new(0.5, -160, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5,0)
frame.Parent = gui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,1,0)
label.BackgroundTransparency = 1
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.TextColor3 = Color3.fromRGB(255,0,0)
label.Text = "AUTO SYSTEM: OFF"
label.Parent = frame

-- =========================
-- TOGGLE STATE
-- =========================
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
-- DRAG FUNCTIONALITY
-- =========================
local dragging = false
local dragStart = nil
local startPos = nil

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.Touch then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
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
		task.wait(0.44)
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
			task.wait(0.37)
		end
	end
end)

-- =========================
-- SAFE CODE REDEMPTION
-- =========================
local codes = {
	"RELEASE1","RELEASE2","RELEASE3","1KLIKE","5KLIKE",
	"NEWFRRUIT1","NEWFRRUIT2","SINP5",
	"Christmas1","Christmas2","Christmas3",
	"UPDATE1","UPDATE3","update4",
	"FUSE777","BEST999","NEW666","VIP888","GROW888",
	"REDRESS","KGFRUIT","CRYSTAL1","CRYSTAL2",
	"CRYSTAL5000","BOSSFIX"
}

local function safeRedeem(code)
	for i = 1,3 do
		pcall(function()
			remote:FireServer("GetCode", code)
		end)
		task.wait(0.4)
	end
end

task.spawn(function()
	for _, code in ipairs(codes) do
		safeRedeem(code)
	end
	print("✅ All codes attempted!")
end)

print("✅ Auto-upgrade + code redemption active!")
