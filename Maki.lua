local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- UI Root
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
ScreenGui.ResetOnSpawn = false

-- =========================
-- Floating Open Button
-- =========================
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.fromOffset(50,50)
OpenBtn.Position = UDim2.fromScale(0.95,0.05)
OpenBtn.AnchorPoint = Vector2.new(1,0)
OpenBtn.Text = "▶"
OpenBtn.BackgroundColor3 = Color3.fromRGB(60,160,90)
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 18
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0,12)

-- =========================
-- Main UI Frame
-- =========================
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.fromScale(0.9, 0.75)
Main.Position = UDim2.fromScale(0.05, 0.125)
Main.BackgroundColor3 = Color3.fromRGB(22,22,22)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)
Main.Visible = false -- start hidden

-- Close Button
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.fromScale(0.08,0.08)
CloseBtn.Position = UDim2.fromScale(0.92,0)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.BackgroundColor3 = Color3.fromRGB(170,70,70)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,10)

-- =========================
-- Title
-- =========================
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.fromScale(1, 0.08)
Title.Text = "♾ Multi Function Runner"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- =========================
-- Code Input Box
-- =========================
local CodeBox = Instance.new("TextBox", Main)
CodeBox.Size = UDim2.fromScale(0.92, 0.28)
CodeBox.Position = UDim2.fromScale(0.04, 0.1)
CodeBox.MultiLine = true
CodeBox.TextWrapped = true
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.ClearTextOnFocus = false
CodeBox.PlaceholderText = "Paste function / code here..."
CodeBox.Text = ""
CodeBox.Font = Enum.Font.Code
CodeBox.TextSize = 14
CodeBox.TextColor3 = Color3.new(1,1,1)
CodeBox.BackgroundColor3 = Color3.fromRGB(32,32,32)
CodeBox.BorderSizePixel = 0
Instance.new("UICorner", CodeBox).CornerRadius = UDim.new(0,14)

-- Add Button
local AddBtn = Instance.new("TextButton", Main)
AddBtn.Size = UDim2.fromScale(0.92, 0.08)
AddBtn.Position = UDim2.fromScale(0.04, 0.4)
AddBtn.Text = "➕ Add Code"
AddBtn.Font = Enum.Font.GothamBold
AddBtn.TextSize = 16
AddBtn.TextColor3 = Color3.new(1,1,1)
AddBtn.BackgroundColor3 = Color3.fromRGB(70,130,180)
AddBtn.BorderSizePixel = 0
Instance.new("UICorner", AddBtn).CornerRadius = UDim.new(0,14)

-- Scroll List
local List = Instance.new("ScrollingFrame", Main)
List.Size = UDim2.fromScale(0.92, 0.38)
List.Position = UDim2.fromScale(0.04, 0.5)
List.CanvasSize = UDim2.new(0,0,0,0)
List.ScrollBarImageTransparency = 0.4
List.BackgroundTransparency = 1
List.BorderSizePixel = 0

local Layout = Instance.new("UIListLayout", List)
Layout.Padding = UDim.new(0,10)
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	List.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
end)

-- =========================
-- Runner Engine
-- =========================
local runners = {}

local function createRunner(code)
	local runner = {code=code,running=false,thread=nil}
	function runner:start()
		if self.running then return end
		self.running = true
		local func = loadstring(self.code)
		self.thread = task.spawn(function()
			while self.running do
				pcall(func)
				task.wait()
			end
		end)
	end
	function runner:stop() self.running=false end
	return runner
end

local function addCodeUI(codeText)
	local runner = createRunner(codeText)
	table.insert(runners, runner)

	local Item = Instance.new("Frame", List)
	Item.Size = UDim2.new(1, -10, 0, 60)
	Item.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Item.BorderSizePixel = 0
	Instance.new("UICorner", Item).CornerRadius = UDim.new(0,12)

	local Label = Instance.new("TextLabel", Item)
	Label.Size = UDim2.fromScale(0.65, 1)
	Label.Position = UDim2.fromScale(0.03, 0)
	Label.Text = "Stored Code #" .. tostring(#runners)
	Label.BackgroundTransparency = 1
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextColor3 = Color3.new(1,1,1)
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 14

	local Toggle = Instance.new("TextButton", Item)
	Toggle.Size = UDim2.fromScale(0.25, 0.7)
	Toggle.Position = UDim2.fromScale(0.72, 0.15)
	Toggle.Text = "START"
	Toggle.Font = Enum.Font.GothamBold
	Toggle.TextSize = 14
	Toggle.TextColor3 = Color3.new(1,1,1)
	Toggle.BackgroundColor3 = Color3.fromRGB(60,160,90)
	Toggle.BorderSizePixel = 0
	Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,10)

	Toggle.MouseButton1Click:Connect(function()
		if runner.running then
			runner:stop()
			Toggle.Text = "START"
			Toggle.BackgroundColor3 = Color3.fromRGB(60,160,90)
		else
			runner:start()
			Toggle.Text = "STOP"
			Toggle.BackgroundColor3 = Color3.fromRGB(170,70,70)
		end
	end)
end

-- Add Button Logic
AddBtn.MouseButton1Click:Connect(function()
	if CodeBox.Text ~= "" then
		addCodeUI(CodeBox.Text)
		CodeBox.Text = ""
	end
end)

-- =========================
-- Open / Close Buttons
-- =========================
OpenBtn.MouseButton1Click:Connect(function()
	Main.Visible = true
	OpenBtn.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
	Main.Visible = false
	OpenBtn.Visible = true
end)
