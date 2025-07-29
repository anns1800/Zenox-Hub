local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Création de la GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModGui"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 270, 0, 150)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0

-- Fonction création bouton pour éviter répétition
local function createButton(parent, posY, text)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 250, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.Text = text
    return btn
end

-- Variables d'état
local godModeActive = false
local speedActive = false
local antiHitActive = false

-- God Mode
local GodButton = createButton(Frame, 10, "🛡 God Mode OFF")

local function enableGodMode()
    godModeActive = true
    GodButton.Text = "🛡 God Mode ON"
    spawn(function()
        while godModeActive do
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
            end
            wait(0.1)
        end
    end)
end

local function disableGodMode()
    godModeActive = false
    GodButton.Text = "🛡 God Mode OFF"
end

GodButton.MouseButton1Click:Connect(function()
    if godModeActive then
        disableGodMode()
    else
        enableGodMode()
    end
end)

-- Speed x3
local SpeedButton = createButton(Frame, 60, "⚡ Speed x3 OFF")

local function enableSpeed()
    speedActive = true
    SpeedButton.Text = "⚡ Speed x3 ON"
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 48 -- vitesse normale = 16
    end
end

local function disableSpeed()
    speedActive = false
    SpeedButton.Text = "⚡ Speed x3 OFF"
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
    end
end

SpeedButton.MouseButton1Click:Connect(function()
    if speedActive then
        disableSpeed()
    else
        enableSpeed()
    end
end)

-- Anti-Hit (désactive collisions)
local AntiHitButton = createButton(Frame, 110, "🚫 Anti-Hit OFF")

local function setNoCollide(character)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function setCollide(character)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

local function enableAntiHit()
    antiHitActive = true
    AntiHitButton.Text = "🚫 Anti-Hit ON"
    if player.Character then
        setNoCollide(player.Character)
    end
end

local function disableAntiHit()
    antiHitActive = false
    AntiHitButton.Text = "🚫 Anti-Hit OFF"
    if player.Character then
        setCollide(player.Character)
    end
end

AntiHitButton.MouseButton1Click:Connect(function()
    if antiHitActive then
        disableAntiHit()
    else
        enableAntiHit()
    end
end)

-- Gérer respawn pour garder états
player.CharacterAdded:Connect(function()
    wait(1)
    if godModeActive then
        enableGodMode()
    end
    if speedActive then
        enableSpeed()
    end
    if antiHitActive then
        enableAntiHit()
    end
end)
