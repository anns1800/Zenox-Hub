local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local noclipActive = false

-- Fonction pour activer/désactiver noclip
local function setNoclip(state)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
    noclipActive = state
end

-- Créer un ScreenGui avec un bouton
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "NoclipGui"

local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 20, 0, 20)
button.Text = "Activer Noclip"
button.BackgroundColor3 = Color3.new(0, 0.5, 1)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.SourceSansBold
button.TextScaled = true

button.MouseButton1Click:Connect(function()
    if noclipActive then
        setNoclip(false)
        button.Text = "Activer Noclip"
        button.BackgroundColor3 = Color3.new(0, 0.5, 1)
    else
        setNoclip(true)
        button.Text = "Désactiver Noclip"
        button.BackgroundColor3 = Color3.new(1, 0, 0)
    end
end)

-- Met à jour le personnage (ex: après respawn)
player.CharacterAdded:Connect(function(char)
    character = char
    if noclipActive then
        setNoclip(true)
    end
end)
