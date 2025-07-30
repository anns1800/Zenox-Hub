-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local hitRemote = ReplicatedStorage:WaitForChild("HitPlayer")

-- GUI setup
local ScreenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "CheatGUI"

local frame = Instance.new("Frame", ScreenGui)
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local function createButton(text, posY)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 50)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = text
    return btn
end

local antiHitButton = createButton("Anti-Hit: OFF", 10)
local attackSpamButton = createButton("Attack Spam: OFF", 70)
local noHitboxButton = createButton("No Hitbox: OFF", 130)

-- Variables de contrôle
local antiHitOn = false
local attackSpamOn = false
local noHitboxOn = false

-- Anti-Hit logic (client-side health regen)
antiHitButton.MouseButton1Click:Connect(function()
    antiHitOn = not antiHitOn
    antiHitButton.Text = "Anti-Hit: " .. (antiHitOn and "ON" or "OFF")

    if antiHitOn then
        spawn(function()
            while antiHitOn do
                wait(0.1)
                if humanoid.Health < 100 then
                    humanoid.Health = 100
                end
            end
        end)
    end
end)

-- Attack spam furtif (téléportation + attaque)
attackSpamButton.MouseButton1Click:Connect(function()
    attackSpamOn = not attackSpamOn
    attackSpamButton.Text = "Attack Spam: " .. (attackSpamOn and "ON" or "OFF")

    if attackSpamOn then
        spawn(function()
            while attackSpamOn do
                wait(1)

                -- Trouver la cible la plus proche (simple)
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

                -- Téléportation furtive proche de la cible
                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -2)
                wait(0.1)

                -- Envoi de l'attaque
                pcall(function()
                    hitRemote:FireServer(target.Name, 30)
                end)

                wait(0.05)

                -- Retour à la position originale
                myRoot.CFrame = originalCFrame
            end
        end)
    end
end)

-- No Hitbox (transparence + no collision)
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
