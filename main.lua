local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local mini = false

local function setMini(state)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if state then
        if humanoid:FindFirstChild("BodyHeightScale") then
            humanoid.BodyHeightScale.Value = 0.3
        end
        if humanoid:FindFirstChild("BodyWidthScale") then
            humanoid.BodyWidthScale.Value = 0.3
        end
        if humanoid:FindFirstChild("BodyDepthScale") then
            humanoid.BodyDepthScale.Value = 0.3
        end
        if humanoid:FindFirstChild("BodyProportionScale") then
            humanoid.BodyProportionScale.Value = 0.3
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = "Mini-taille activée",
            Text = "Tu es maintenant plus petit !",
            Duration = 3
        })
    else
        if humanoid:FindFirstChild("BodyHeightScale") then
            humanoid.BodyHeightScale.Value = 1
        end
        if humanoid:FindFirstChild("BodyWidthScale") then
            humanoid.BodyWidthScale.Value = 1
        end
        if humanoid:FindFirstChild("BodyDepthScale") then
            humanoid.BodyDepthScale.Value = 1
        end
        if humanoid:FindFirstChild("BodyProportionScale") then
            humanoid.BodyProportionScale.Value = 1
        end
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

game.StarterGui:SetCore("SendNotification", {
    Title = "Mini-taille",
    Text = "Appuie sur M pour activer/désactiver la mini-taille",
    Duration = 5
})
