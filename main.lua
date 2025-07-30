local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local noclip = false

-- Fonction pour activer ou désactiver les collisions
local function setNoclipState(state)
    local char = player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

-- Boucle continue
RunService.Stepped:Connect(function()
    if noclip and player.Character then
        setNoclipState(true)
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(11)
        end
    end
end)

-- Activation avec la touche N
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.N then
        noclip = not noclip
        setNoclipState(noclip)
        print("Noclip :", noclip and "ON" or "OFF")
    end
end)

-- Mise à jour du personnage si respawn
player.CharacterAdded:Connect(function(char)
    character = char
    if noclip then
        wait(1)
        setNoclipState(true)
    end
end)
