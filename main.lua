-- GUI setup
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", ScreenGui)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local antiHitButton = Instance.new("TextButton", frame)
antiHitButton.Size = UDim2.new(1, 0, 0, 50)
antiHitButton.Position = UDim2.new(0, 0, 0, 0)
antiHitButton.Text = "Anti-Hit: OFF"
antiHitButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
antiHitButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local attackSpamButton = Instance.new("TextButton", frame)
attackSpamButton.Size = UDim2.new(1, 0, 0, 50)
attackSpamButton.Position = UDim2.new(0, 0, 0, 60)
attackSpamButton.Text = "Attack Spam: OFF"
attackSpamButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
attackSpamButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Logic
local antiHitOn = false
local attackSpamOn = false
local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")

-- Anti-hit logic (fake client-side health restore)
antiHitButton.MouseButton1Click:Connect(function()
    antiHitOn = not antiHitOn
    antiHitButton.Text = "Anti-Hit: " .. (antiHitOn and "ON" or "OFF")

    if antiHitOn then
        print("[Anti-Hit] Activated")
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if antiHitOn and humanoid.Health < 100 then
                humanoid.Health = 100
            end
        end)
    else
        print("[Anti-Hit] Deactivated")
    end
end)

-- Attack spam logic
attackSpamButton.MouseButton1Click:Connect(function()
    attackSpamOn = not attackSpamOn
    attackSpamButton.Text = "Attack Spam: " .. (attackSpamOn and "ON" or "OFF")

    if attackSpamOn then
        print("[Attack Spam] Activated")
        spawn(function()
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("HitPlayer")
            while attackSpamOn and remote do
                wait(1)
                pcall(function()
                    remote:FireServer("JoueurCible", 9999)
                end)
            end
        end)
    else
        print("[Attack Spam] Deactivated")
    end
end)
