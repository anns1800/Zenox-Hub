-- ✅ Anti-Ragdoll avec GUI ON/OFF – Spécial Steal a Brainrot
local lp = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local starterGui = game:GetService("StarterGui")

-- GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local button = Instance.new("TextButton", ScreenGui)

ScreenGui.Name = "NoRagdollGUI"
button.Name = "ToggleButton"
button.Size = UDim2.new(0, 160, 0, 50)
button.Position = UDim2.new(0, 20, 0, 200)
button.Text = "🛡 No Ragdoll: OFF"
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.BorderSizePixel = 0

-- Script
local enabled = false
local connection = nil

local function enableAntiRagdoll()
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")

    -- Bloquer les états de chute
    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    hum.PlatformStand = false

    -- Réagir si le jeu essaie de changer ton état
    connection = hum.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Ragdoll or new == Enum.HumanoidStateType.FallingDown or new == Enum.HumanoidStateType.Physics then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function disableAntiRagdoll()
    if connection then
        connection:Disconnect()
        connection = nil
    end

    local char = lp.Character
    if char then
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        end
    end
end

button.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        enableAntiRagdoll()
        button.Text = "🛡 No Ragdoll: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        starterGui:SetCore("SendNotification", {
            Title = "Protection activée",
            Text = "Tu ne peux plus être éjecté.",
            Duration = 3
        })
    else
        disableAntiRagdoll()
        button.Text = "🛡 No Ragdoll: OFF"
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        starterGui:SetCore("SendNotification", {
            Title = "Protection désactivée",
            Text = "Tu peux à nouveau être frappé normalement.",
            Duration = 3
        })
    end
end)
