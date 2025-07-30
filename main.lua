
-- Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local noclip = false

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Noclip Script",
    Text = "Appuie sur N pour ON/OFF. Spoof & Remote activé.",
    Duration = 5
})

-- Fonction principale NoClip
RunService.Stepped:Connect(function()
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
    end
end)

-- Activation touche N
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
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

-- [🛠 Spoofing / RemoteEvent Simulation - éducatif uniquement]

-- Tentative de spoof : fausse position envoyée au serveur (ne fonctionne que dans jeux non sécurisés)
local spoof_enabled = true
local spoof_interval = 1 -- en secondes

task.spawn(function()
    while spoof_enabled do
        task.wait(spoof_interval)
        if noclip and char and char:FindFirstChild("HumanoidRootPart") then
            local spoof_pos = char.HumanoidRootPart.Position + Vector3.new(0, 0.01, 0)
            -- Simulation de spoof : déplacer légèrement pour forcer une update "légale"
            char.HumanoidRootPart.CFrame = CFrame.new(spoof_pos)
        end
    end
end)

-- Recherche et "écoute" des RemoteEvents (lecture seule, pour debug - pas d’envoi)
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") and v.Name:lower():match("position") then
        print("🔍 RemoteEvent détecté :", v:GetFullName())
        -- Option : hook le RemoteEvent si ton exploit le permet
    end
end
