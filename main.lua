-- GUI Setup
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local hitRemote = ReplicatedStorage:WaitForChild("HitPlayer")

-- Crée la GUI
local ScreenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "CheatGUI"

local frame = Instance.new("Frame", ScreenGui)
frame.Size = UDim2.new(0, 220, 0, 170)
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

-- Anti-Hit logic (régénération santé côté client)
antiHitButton.MouseButton1Click:Connect(function()
    antiHitOn = not antiHitOn
    antiHitButton.Text = "Anti-Hit: " .. (antiHitOn and "ON" or "OFF")
    if antiHitOn then
        print("[Anti-Hit] Activé")
        -- Boucle pour remettre la vie à 100
        spawn(function()
            while antiHitOn do
                wait(0.1)
                if humanoid.Health < 100 then
                    humanoid.Health = 100
                end
            end
        end)
    else
        print("[Anti-Hit] Désactivé")
    end
end)

-- Attack Spam logic (envoie une attaque toutes les secondes)
attackSpamButton.MouseButton1Click:Connect(function()
    attackSpamOn = not attackSpamOn
    attackSpamButton.Text = "Attack Spam: " .. (attackSpamOn and "ON" or "OFF")
    if attackSpamOn then
        print("[Attack Spam] Activé")
        spawn(function()
            while attackSpamOn do
                wait(1)
                local target = nil
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= localPlayer then
                        target = plr
                        break
                    end
                end
                if target then
                    pcall(function()
                        hitRemote:FireServer(target.Name, 30)
                    end)
                end
            end
        end)
    else
        print("[Attack Spam] Désactivé")
    end
end)

-- No Hitbox logic (rend les parties invisibles pour éviter d'être touché côté client)
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

    if noHitboxOn then
        print("[No Hitbox] Activé")
    else
        print("[No Hitbox] Désactivé")
    end
end)
