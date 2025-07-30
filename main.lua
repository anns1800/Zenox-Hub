-- Touche "N" pour activer / désactiver
-- Marche dans les jeux moyennement protégés

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local noclip = false
local speed = 2 -- plus bas = plus discret (1 à 3 recommandé)

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Spoofed NoClip",
    Text = "Appuie sur N pour ON/OFF - mode discret activé",
    Duration = 5
})

-- Micro-déplacement intelligent
RunService.RenderStepped:Connect(function()
    if noclip and char and root then
        local direction = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction += workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction -= workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction -= workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction += workspace.CurrentCamera.CFrame.RightVector
        end
        if direction.Magnitude > 0 then
            direction = direction.Unit * speed * RunService.RenderStepped:Wait()
            local newPos = root.CFrame.Position + direction
            root.CFrame = CFrame.new(newPos)
        end
    end
end)

-- Activation / Désactivation touche N
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.N then
        noclip = not noclip
        local msg = noclip and "✅ NoClip (discret) activé" or "❌ NoClip désactivé"
        game.StarterGui:SetCore("SendNotification", {
            Title = "Spoofed NoClip",
            Text = msg,
            Duration = 3
        })
    end
end)
