-- ✅ SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- ✅ GUI
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "AntiToolsGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 200)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

-- ✅ Fonction pour créer un bouton
local function createButton(label, posY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Position = UDim2.new(0, 0, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 20
	btn.Text = label .. ": OFF"
	btn.Parent = frame
	return btn
end

-- ✅ Variables d'état
local noHitOn = false
local dodgeOn = false
local blockHitOn = false
local originalParts = {}

-- ✅ Création des boutons
local noHitButton = createButton("No-Hitbox", 0)
local dodgeButton = createButton("Auto-Dodge", 50)
local blockButton = createButton("Block Damage", 100)

-- ✅ FONCTION No-Hitbox (réduction des parties du corps sauf le root)
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

-- ✅ Lien bouton No-Hitbox
noHitButton.MouseButton1Click:Connect(function()
	noHitOn = not noHitOn
	noHitButton.Text = "No-Hitbox: " .. (noHitOn and "ON" or "OFF")
	setNoHitbox(noHitOn)
end)

-- ✅ Lien bouton Auto-Dodge
dodgeButton.MouseButton1Click:Connect(function()
	dodgeOn = not dodgeOn
	dodgeButton.Text = "Auto-Dodge: " .. (dodgeOn and "ON" or "OFF")
end)

-- ✅ Lien bouton Block Damage
blockButton.MouseButton1Click:Connect(function()
	blockHitOn = not blockHitOn
	blockButton.Text = "Block Damage: " .. (blockHitOn and "ON" or "OFF")
end)

-- ✅ BOUCLE de protection active
RunService.RenderStepped:Connect(function()
	-- Auto-Dodge → esquive si un projectile s'approche
	if dodgeOn and root then
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("Part") and obj.Velocity.Magnitude > 60 then
				if (obj.Position - root.Position).Magnitude < 6 then
					root.CFrame = root.CFrame + Vector3.new(5, 0, 0)
				end
			end
		end
	end

	-- Block Damage → remet la vie à 100 (client-side)
	if blockHitOn and hum and hum.Health < 100 then
		hum.Health = 100
	end
end)
