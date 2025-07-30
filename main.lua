-- ✅ NoClip simple sans PlatformStand (évite le bug de "flottement")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local noclip = false

-- Notification de base
game.StarterGui:SetCore("SendNotification", {
    Title = "NoClip Script",
    Text = "Appuie sur N pour activer/désactiver",
    Duration = 5
})

-- Fonction NoClip
RunService.Stepped:Connect(function()
    if noclip and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- Activation via la touche N
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.N then
        noclip = not noclip
        local status = noclip and "activé" or "désactivé"
        game.StarterGui:SetCore("SendNotification", {
            Title = "NoClip",
            Text = "NoClip " .. status,
            Duration = 3
        })
    end
end)
