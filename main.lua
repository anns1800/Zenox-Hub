-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Joueur
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local noclip = false

-- ✅ Notification
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Noclip Script",
        Text = "Appuie sur N pour ON/OFF",
        Duration = 5
    })
end)

-- ✅ Plateforme invisible sous le joueur
local platform = Instance.new("Part")
platform.Anchored = true
platform.Size = Vector3.new(6, 1, 6)
platform.Position = Vector3.new(0, -5000, 0) -- cachée au début
platform.Transparency = 1
platform.CanCollide = true
platform.Name = "NoclipPlatform"
platform.Parent = workspace

-- ✅ Objet visible dans le jeu
local cube = Instance.new("Part")
cube.Anchored = true
cube.Size = Vector3.new(4, 4, 4)
cube.Position = Vector3.new(0, 10, 0)
cube.BrickColor = BrickColor.new("Bright red")
cube.Material = Enum.Material.Neon
cube.Name = "VisibleCube"
cube.Parent = workspace

-- ✅ Fonction principale NoClip
RunService.Stepped:Connect(function()
    char = player.Character
    if noclip and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(11) -- PlatformStand
        end
        -- Plateforme suit le joueur
        if char:FindFirstChild("HumanoidRootPart") then
            platform.Position = char.HumanoidRootPart.Position - Vector3.new(0, 3, 0)
        end
    end
end)

-- ✅ Activation touche N
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.N then
        noclip = not noclip
        local status = noclip and "activé" or "désactivé"
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "NoClip",
                Text = "NoClip " .. status,
                Duration = 3
            })
        end)
    end

    -- ✅ Touche T = téléportation (exemple)
    if input.KeyCode == Enum.KeyCode.T then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        end
    end
end)

-- ✅ Maintien du noclip après respawn
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    wait(1)
    if noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
