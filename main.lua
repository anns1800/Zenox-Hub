local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 170)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0

local GodButton = Instance.new("TextButton", Frame)
GodButton.Size = UDim2.new(0, 230, 0, 40)
GodButton.Position = UDim2.new(0, 10, 0, 10)
GodButton.Text = "🛡 God Mode"
GodButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
GodButton.TextColor3 = Color3.new(1, 1, 1)
GodButton.Font = Enum.Font.SourceSansBold
GodButton.TextSize = 20

GodButton.MouseButton1Click:Connect(function()
    local h = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if h then
        h.Health = math.huge
        h:GetPropertyChangedSignal("Health"):Connect(function()
            h.Health = math.huge
        end)
    end
end)

-- Nouveau bouton : Speed
local SpeedButton = Instance.new("TextButton", Frame)
SpeedButton.Size = UDim2.new(0, 230, 0, 40)
SpeedButton.Position = UDim2.new(0, 10, 0, 60)
SpeedButton.Text = "⚡ Speed x3"
SpeedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedButton.TextColor3 = Color3.new(1, 1, 1)
SpeedButton.Font = Enum.Font.SourceSansBold
SpeedButton.TextSize = 20

SpeedButton.MouseButton1Click:Connect(function()
    local h = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if h then
        h.WalkSpeed = 48 -- vitesse normale = 16
    end
end)
