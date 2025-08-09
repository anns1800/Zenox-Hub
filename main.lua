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

-- Détection automatique du Remote qui retire le brainrot
print("[Brainrot Saver] Recherche du Remote...")
local SimpleSpy = loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))()

-- Quand un Remote est déclenché, on vérifie s'il retire le brainrot
SimpleSpy.OnRemote(function(remote, args)
    if not targetRemote then
        -- Ici tu mets une condition pour reconnaître le Remote de brainrot
        -- Par exemple, si args contient une info unique du brainrot
        if tostring(remote):lower():find("brainrot") or tostring(remote):lower():find("hit") then
            targetRemote = remote
            print("[Brainrot Saver] Remote trouvé :", remote:GetFullName())
        end
    end
end)

-- Hook du Remote
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if enabled and self == targetRemote and method == "FireServer" then
        print("[Brainrot Saver] Coup reçu bloqué.")
        return nil
    end
    return oldNamecall(self, ...)
end)

-- Bouton pour activer/désactiver
ToggleButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        ToggleButton.Text = "Brainrot Saver: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        ToggleButton.Text = "Brainrot Saver: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
