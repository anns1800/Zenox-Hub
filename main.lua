local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "StylishCheatDemo"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 380)
frame.Position = UDim2.new(0.5, -175, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "⚙️ Cheat Modes [Démo Visuelle]"
title.Font = Enum.Font.FredokaOne
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1

local cheats = {
    {name = "Téléportation éclair", color = Color3.fromRGB(0, 200, 255)},
    {name = "Saut céleste", color = Color3.fromRGB(180, 0, 255)},
    {name = "Vitesse supersonique", color = Color3.fromRGB(255, 80, 0)},
    {name = "Vision thermique", color = Color3.fromRGB(255, 255, 0)},
    {name = "Mode furtif", color = Color3.fromRGB(120, 120, 120)}
}

for i, cheat in ipairs(cheats) do
    local container = Instance.new("Frame", frame)
    container.Size = UDim2.new(0.9, 0, 0, 50)
    container.Position = UDim2.new(0.05, 0, 0, i * 55)
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    container.BorderSizePixel = 0

    local button = Instance.new("TextButton", container)
    button.Size = UDim2.new(0.7, 0, 1, 0)
    button.Position = UDim2.new(0.05, 0, 0, 0)
    button.Text = cheat.name .. " [OFF]"
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = cheat.color
    button.BackgroundTransparency = 0.4

    local indicator = Instance.new("Frame", container)
    indicator.Size = UDim2.new(0.2, 0, 0.7, 0)
    indicator.Position = UDim2.new(0.75, 0, 0.15, 0)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    indicator.BorderSizePixel = 0

    local corner = Instance.new("UICorner", indicator)
    corner.CornerRadius = UDim.new(0, 8)

    button.MouseButton1Click:Connect(function()
        local isActive = button.Text:find("ON")
        if isActive then
            button.Text = cheat.name .. " [OFF]"
            indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        else
            button.Text = cheat.name .. " [ON]"
            indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        end
    end)
