-- ✅ NoClip discret (Spoofing lent) avec activation par touche N
-- Déplacement doux en W A S D, évite les détections serveur

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local noclip = false
local speed = 2 -- ajuste la vitesse (1 à 3 recommandé)

-- Attente du personnage + camera
local function getCharacter()
	local char = player.Character or player.CharacterAdded:Wait()
	local root = char:WaitForChild("HumanoidRootPart")
	return char, root
end

-- Notification
pcall(function()
	game.StarterGui:SetCore("SendNotification", {
		Title = "NoClip discret",
		Text = "Appuie sur N pour ON/OFF",
		Duration = 5
	})
end)

-- Mouvement discret basé sur les touches
RunService.RenderStepped:Connect(function(delta)
	if not noclip then return end

	local char, root = getCharacter()
	if not char or not root then return end

	local cam = workspace.CurrentCamera
	local direction = Vector3.new()

	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
		direction += cam.CFrame.LookVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		direction -= cam.CFrame.LookVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then
		direction -= cam.CFrame.RightVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then
		direction += cam.CFrame.RightVector
	end

	if direction.Magnitude > 0 then
		direction = direction.Unit * speed * delta
		root.CFrame = root.CFrame + direction
	end
end)

-- Activation touche N
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.N then
		noclip = not noclip
		local status = noclip and "✅ NoClip Activé" or "❌ NoClip Désactivé"
		pcall(function()
			game.StarterGui:SetCore("SendNotification", {
				Title = "NoClip discret",
				Text = status,
				Duration = 3
			})
		end)
	end
end)
