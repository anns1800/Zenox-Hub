-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- GUI Setup
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "AntiHitboxGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local function createButton(text, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 45)
	btn.Position = UDim2.new(0, 0, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 20
	btn.Text = text .. ": OFF"
	btn.Parent = frame
	return btn
end

local btnNoHitbox = createButton("No-Hitbox", 0)
local btnAutoDodge = createButton("Auto-Dodge", 50)
local btnBlockDamage = createButton("Block Damage", 100)

local noHitOn = false
local dodgeOn = false
local blockHitOn = false

local originalParts = {}

-- Fonction No-Hitbox améliorée
local function setNoHitbox(state)
	if state then
		-- Réduire et rendre invisible TOUTES les parties et désactiver collisions
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				if not originalParts[part] then
					originalParts[part] = {
						Size = part.Size,
						Transparency = part.Transparency,
						CanCollide = part.CanCollide,
						Anchored = part.Anchored
					}
				end
				part.Size = Vector3.new(0.05, 0.05, 0.05)
				part.Transparency = 1
				part.CanCollide = false
				part.Anchored = false
			end
		end
		-- Pour rootpart aussi, qui est la hitbox principale
		root.Size = Vector3.new(0.1, 0.1, 0.1)
		root.Transparency = 1
		root.CanCollide = false
	else
		-- Remettre les parties dans leur état original
		for part, props in pairs(originalParts) do
			if part and part.Parent then
				part.Size = props.Size
				part.Transparency = props.Transparency
				part.CanCollide = props.CanCollide
				part.Anchored = props.Anchored
			end
		end
		originalParts = {}
	end
end

btnNoHitbox.MouseButton1Click:Connect(function()
	noHitOn = not noHitOn
	btnNoHitbox.Text = "No-Hitbox: " .. (noHitOn and "ON" or "OFF")
	setNoHitbox(noHitOn)
end)

btnAutoDodge.MouseButton1Click:Connect(function()
	dodgeOn = not dodgeOn
	btnAutoDodge.Text = "Auto-Dodge: " .. (dodgeOn and "ON" or "OFF")
end)

btnBlockDamage.MouseButton1Click:Connect(function()
	blockHitOn = not blockHitOn
	btnBlockDamage.Text = "Block Damage: " .. (blockHitOn and "ON" or "OFF")
end)

-- Boucle de protection
RunService.RenderStepped:Connect(function()
	if dodgeOn and root then
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Velocity.Magnitude > 60 then
				if (obj.Position - root.Position).Magnitude < 6 then
					root.CFrame = root.CFrame + Vector3.new(5, 0, 0)
				end
			end
		end
	end
	
	if blockHitOn and hum and hum.Health < 100 then
		hum.Health = 100
	end
end)
