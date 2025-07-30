-- ✅ NoClip ultra discret — micro-poussée au lieu de téléportation
-- Activation par touche N — Pas de mort instantanée

local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local noclip = false
local pushing = false
local speed = 2

-- Fonction safe de déplacement
local function safePush()
	if pushing then return end
	pushing = true

	while noclip do
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local root = char:FindFirstChild("HumanoidRootPart")
			local cam = workspace.CurrentCamera
			local move = Vector3.new()

			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				move += cam.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				move -= cam.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				move -= cam.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				move += cam.CFrame.RightVector
			end

			if move.Magnitude > 0 then
				local pos = root.Position + (move.Unit * speed * 0.1)
				root.Velocity = Vector3.new(0, 0, 0) -- empêche les bugs de vol
				root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				root:ApplyImpulse(move.Unit * 0.1)
			end
		end
		wait(0.02)
	end

	pushing = false
end

-- Activation touche N
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.N then
		noclip = not noclip
		if noclip then
			pcall(function()
				game.StarterGui:SetCore("SendNotification", {
					Title = "NoClip Safe",
					Text = "✅ Activé",
					Duration = 3
				})
			end)
			safePush()
		else
			pcall(function()
				game.StarterGui:SetCore("SendNotification", {
					Title = "NoClip Safe",
					Text = "❌ Désactivé",
					Duration = 3
				})
			end)
		end
	end
end)
