local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local mini = false

local function setMini(state)
    if state then
        humanoid.BodyHeightScale.Value = 0.3
        humanoid.BodyWidthScale.Value = 0.3
        humanoid.BodyDepthScale.Value = 0.3
        humanoid.BodyProportionScale.Value = 0.3
        game.StarterGui:SetCore("SendNotification", {
            Title = "Mini-taille activée",
            Text = "Tu es maintenant plus petit !",
            Duration = 3
        })
    else
        humanoid.BodyHeightScale.Value = 1
        humanoid.BodyWidthScale.Value = 1
        humanoid.BodyDepthScale.Value = 1
        humanoid.BodyProportionScale.Value = 1
        game.StarterGui:SetCore("SendNotification", {
            Title = "Taille normale",
            Text = "Retour à la taille normale.",
            Duration = 3
        })
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then -- Touche M pour toggle
        mini = not mini
        setMini(mini)
    end
end)

-- Message initial
game.StarterGui:SetCore("SendNotification", {
    Title = "Mini-taille",
    Text = "Appuie sur M pour activer/désactiver la mini-taille",
    Duration = 5
})
