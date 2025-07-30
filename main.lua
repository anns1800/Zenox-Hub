-- ⚙️ Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- 🖥️ GUI
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "AntiTools"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 180)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local function createButton(name, y)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Position = UDim2.new(0, 0, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = name .. ": OFF"
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 20
	return btn
end

-- 🔘 Boutons et états
local noHitOn = false
local dodgeOn = false
local blockHitOn = false

local btn1 = createButton("No-Hitbox", 0)
local btn2 = createButton("Auto-Dodge", 50)
local btn3 = createButton("Block Damage", 100)

-- 🧱 No-Hitbox
local originalParts = {}

local function setNoHitbox(state)
	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			if state then
				originalParts[part] = {Size = part.Size, Transparency = part.Transparency}
				part.Size = Vector3.new(0.1, 0.1, 0.1)
				part.Transparency = 1
				part.CanCollide = false
			elseif originalParts[part] then
				part.Size = originalParts[part].Size
				part.Transparency = originalParts[part].Transparency
				part.CanCollide = true
			end
		end
	end
end

btn1.MouseButton1Click:Connect(function()
	noHitOn = not noHitOn
	btn1.Text = "No-Hitbox: " .. (noHitOn and "ON" or "OFF")
	setNoHitbox(noHitOn)
end)

-- 🌀 Auto-Dodge
btn2.MouseButton1Click:Connect(function()
	dodgeOn = not dodgeOn
	btn2.Text = "Auto-Dodge: " .. (dodgeOn and "ON" or "OFF")
end)

-- ❤️ Block Damage (client-side)
btn3.MouseButton1Click:Connect(function()
	blockHitOn = not blockHitOn
	btn3.Text = "Block Damage: " .. (blockHitOn and "ON" or "OFF")
end)

-- 🔁 Boucle de protection
RunService.RenderStepped:Connect(function()
	if dodgeOn and root then
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("Part") and obj.Velocity.Magnitude > 60 then
				if (obj.Position - root.Position).Magnitude < 6 then
					root.CFrame = root.CFrame + Vector3.new(5, 0, 0)
				end
			end
		end
	end

	if blockHitOn and hum and hum.Health < 100 then
		hum.Health = 100 -- client-side only
	end
end
