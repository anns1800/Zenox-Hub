-- ✅ Anti-éjection / No Ragdoll – spécial Steal a Brainrot

local lp = game:GetService("Players").LocalPlayer

-- Fonction qui supprime les contraintes responsables des réactions physiques
local function removePhysicsStuff()
    local char = lp.Character or lp.CharacterAdded:Wait()

    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BallSocketConstraint") or v:IsA("AlignPosition") or v:IsA("AlignOrientation") or v:IsA("HingeConstraint") then
            v:Destroy()
        end
    end

    -- Désactive les collisions avec le décor et les autres joueurs
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
            part.CustomPhysicalProperties = PhysicalProperties.new(1000, 0, 0) -- super lourd, pas de rebond
        end
    end

    -- Empêche les animations de tomber
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    end
end

-- Appliquer en boucle pour contrer les réinjections du jeu
while true do
    pcall(removePhysicsStuff)
    wait(1.5)
