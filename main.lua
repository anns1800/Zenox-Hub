local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local cheats = {
    "Super vitesse", "Saut infini", "Téléportation", "Mode invisible", "Gravité réduite"
}

ScreenGui.Name = "CheatMenuDemo"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Size = UDim2.new(0, 300, 0, #cheats * 50 + 60)
Frame.Position = UDim2.new(0.5, -150, 0.5, -(#cheats * 25))
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Parent = ScreenGui

title.Text = "CHEAT MODES (démo éducative)"
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(60,60,60)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.Fantasy
title.TextSize = 20
title.Parent = Frame

for i, cheat in pairs(cheats) do
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0.9,0,0,40)
    toggle.Position = UDim2.new(0.05,0,0,(i-1)*50 + 50)
    toggle.BackgroundColor3 = Color3.fromRGB(80,80,80)
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Font = Enum.Font.SourceSansBold
    toggle.TextSize = 18
    toggle.Text = cheat.." [OFF]"
    toggle.Parent = Frame
    
    toggle.MouseButton1Click:Connect(function()
        if toggle.Text:find("OFF") then
            toggle.Text = cheat.." [ON]"
            toggle.BackgroundColor3 = Color3.fromRGB(0,180,0)
        else
            toggle.Text = cheat.." [OFF]"
            toggle.BackgroundColor3 = Color3.fromRGB(80,80,80)
        end
    end)
end
