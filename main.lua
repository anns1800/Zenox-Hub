local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Création de la GUI dans PlayerGui (plus sûr)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomGui"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 170)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0

-- Bouton God Mode
local GodButton = Instance.new("TextButton", Frame)
GodButton.Size = UDim2.new(0, 230, 0, 40)
GodButton.Position = UDim2.new(0, 10, 0, 10)
GodButton.Text = "🛡 God Mode"
GodButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
GodButton.TextColor3 = Color3.new(1, 1, 1)
GodButton.Font = Enum.Font.SourceSansBold
GodButton.TextSize = 20

-- Bouton Speed x3
local SpeedButton = Instance.new("TextButton", Frame)
SpeedButton.Size = UDim2.new(0, 230, 0, 40)
SpeedButton.Position = UDim2.new(0, 10, 0, 60)
SpeedButton.Text = "⚡ Speed x3"
SpeedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedButton.TextColor3 = Color3.new(1, 1, 1)
SpeedButton.Font = Enum.Font.SourceSansBold
SpeedButton.TextSize = 20

-- Variables d'état
local godModeActive = false
local speedActive = false
local humanoidConnection

local function getHumanoid()
    if player.Character then
        return player.Character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

local function enableGodMode()
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.Health = math.huge
        if humanoidConnection then humanoidConnection:Disconnect() end
        humanoidConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health < math.huge then
                humanoid.Health = math.huge
            end
        end)
    end
end

local function disableGodMode()
    if humanoidConnection then
        humanoidConnection:Disconnect()
        humanoidConnection = nil
    end
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.Health = humanoid.MaxHealth -- Remet la vie normale
    end
end

local function enableSpeed()
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = 48 -- 3x la vitesse normale (16)
    end
end

local function disableSpeed()
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = 16 -- vitesse normale
    end
end

-- Gestion du clic God Mode
GodButton.MouseButton1Click:Connect(function()
    godModeActive = not godModeActive
    if godModeActive then
        enableGodMode()
        GodButton.Text = "🛡 God Mode (ON)"
    else
        disableGodMode()
        GodButton.Text = "🛡 God Mode"
    end
end)

-- Gestion du clic Speed x3
SpeedButton.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    if speedActive then
        enableSpeed()
        SpeedButton.Text = "⚡ Speed x3 (ON)"
    else
        disableSpeed()
        SpeedButton.Text = "⚡ Speed x3"
    end
end)

-- Quand le personnage respawn
player.CharacterAdded:Connect(function()
    wait(1) -- Attendre que le personnage soit chargé
    if godModeActive then
        enableGodMode()
    end
    if speedActive then
        enableSpeed()
    end
end)
