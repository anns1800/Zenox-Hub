-- ✅ Anti-Ragdoll avec bouton ON/OFF – version Delta (PlayerGui)
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NoRagdollGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 50)
button.Position = UDim2.new(0, 20, 0, 200)
button.Text = "🛡 No Ragdoll: OFF"
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Parent = gui

local enabled = false
local connection = nil

local function enableNoRagdoll()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")

    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    hum.PlatformStand = false

    connection = hum.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Ragdoll
        or new == Enum.HumanoidStateType.FallingDown
        or new == Enum.HumanoidStateType.Physics then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function disableNoRagdoll()
    if connection then
        connection:Disconnect()
        connection = nil
    end

    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
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
        enableNoRagdoll()
        button.Text = "🛡 No Ragdoll: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        disableNoRagdoll()
        button.Text = "🛡 No Ragdoll: OFF"
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)
