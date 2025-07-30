-- ✅ No Ragdoll / Anti-éjection avec touche N
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local lp = game.Players.LocalPlayer

local enabled = false
local connection = nil

local function enableNoRagdoll()
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")

    -- Bloquer les états
    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    hum.PlatformStand = false

    -- Réagir si le jeu veut te stun
    connection = hum.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Ragdoll
        or new == Enum.HumanoidStateType.FallingDown
        or new == Enum.HumanoidStateType.Physics then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)

    StarterGui:SetCore("SendNotification", {
        Title = "✅ No Hit activé",
        Text = "Tu ne tomberas plus si on te tape.",
        Duration = 4
    })
end

local function disableNoRagdoll()
    if connection then connection:Disconnect() end

    local char = lp.Character
    if char then
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        end
    end

    StarterGui:SetCore("SendNotification", {
        Title = "❌ No Hit désactivé",
        Text = "Tu peux de nouveau tomber si on te frappe.",
        Duration = 4
    })
end

-- Touche N pour ON/OFF
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.N then
        enabled = not enabled
        if enabled then
            enableNoRagdoll()
        else
            disableNoRagdoll()
        end
    end
end)

-- Message de démarrage
StarterGui:SetCore("SendNotification", {
    Title = "🛡 No Hit prêt",
    Text = "Appuie sur N pour activer ou désactiver.",
    Duration = 5
})
