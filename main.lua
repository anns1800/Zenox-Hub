-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer

-- Attend que le personnage soit chargé
local function waitForCharacter()
    if localPlayer.Character and localPlayer.Character.Parent then
        return localPlayer.Character
    end
    return localPlayer.CharacterAdded:Wait()
end

local character = waitForCharacter()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Récupère l'événement Remote
local hitRemote = ReplicatedStorage:WaitForChild("HitPlayer")

-- GUI setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CheatGUI"
ScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 190)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = ScreenGui

local function createButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 50)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = text
    btn.Parent = frame
    return btn
end

local antiHitButton = createButton("Anti-Hit: OFF", 10)
local attackSpamButton = createButton("Attack Spam: OFF", 70)
local noHitboxButton = createButton("No Hitbox: OFF", 130)

-- Variables de contrôle
local antiHitOn = false
local attackSpamOn = false
local noHitboxOn = false

-- Anti-Hit logic
antiHitButton.MouseButton1Click:Connect(function()
    antiHitOn = not antiHitOn
    antiHitButton.Text = "Anti-Hit: " .. (antiHitOn and "ON" or "OFF")

    if antiHitOn then
        spawn(function()
            while antiHitOn do
                wait(0.1)
                if humanoid and humanoid.Health < 100 then
                    humanoid.Health = 100
                end
            end
        end)
    end
end)

-- Attack Spam logic (téléport furtif + attaque)
attackSpamButton.MouseButton1Click:Connect(function()
    attackSpamOn = not attackSpamOn
    attackSpamButton.Text = "Attack Spam: " .. (attackSpamOn and "ON" or "OFF")

    if attackSpamOn then
        spawn(function()
            while attackSpamOn do
                wait(1)

                -- Trouve cible autre joueur avec personnage
                local target = nil
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        target = plr
                        break
                    end
                end
                if not target then continue end

                local myRoot = rootPart
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                if not myRoot or not targetRoot then continue end

                local originalCFrame = myRoot.CFrame

                -- Téléportation furtive proche cible
                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -2)
                wait(0.1)

                -- Envoie attaque
                pcall(function()
                    hitRemote:FireServer(target.Name, 30)
                end)

                wait(0.05)

                -- Retour position d'origine
                myRoot.CFrame = originalCFrame
            end
        end)
    end
end)

-- No Hitbox logic
noHitboxButton.MouseButton1Click:Connect(function()
    noHitboxOn = not noHitboxOn
    noHitboxButton.Text = "No Hitbox: " .. (noHitboxOn and "ON" or "OFF")

    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if noHitboxOn then
                part.Transparency = 1
                part.CanCollide = false
            else
                part.Transparency = 0
                part.CanCollide = true
            end
        end
    end
end)
