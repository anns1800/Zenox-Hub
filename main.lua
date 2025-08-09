-- UI simple avec bouton ON/OFF
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0, 200)
ToggleButton.Text = "Brainrot Saver: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 20
ToggleButton.Visible = true

-- Variables
local enabled = false
local targetRemote = nil

-- Détection automatique : on écoute tous les appels de Remote
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    -- Si on n'a pas encore trouvé le Remote, on l'enregistre si son nom ressemble à brainrot
    if not targetRemote and (method == "FireServer" or method == "InvokeServer") then
        local remoteName = tostring(self):lower()
        if remoteName:find("brainrot") or remoteName:find("hit") then
            targetRemote = self
            print("[Brainrot Saver] Remote détecté :", self:GetFullName())
        end
    end

    -- Si activé et que c'est le bon Remote → on bloque
    if enabled and targetRemote and self == targetRemote and (method == "FireServer" or method == "InvokeServer") then
        print("[Brainrot Saver] Coup bloqué.")
        return nil
    end

    return oldNamecall(self, ...)
end)

-- Bouton ON/OFF
ToggleButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        ToggleButton.Text = "Brainrot Saver: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        print("[Brainrot Saver] ACTIVÉ - Les coups seront bloqués.")
    else
        ToggleButton.Text = "Brainrot Saver: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        print("[Brainrot Saver] DÉSACTIVÉ - Les coups ne sont plus bloqués.")
    end
end)
