local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "BrainrotBlockerGui"

local Button = Instance.new("TextButton")
Button.Parent = ScreenGui
Button.Size = UDim2.new(0, 180, 0, 50)
Button.Position = UDim2.new(0, 20, 0, 200)
Button.BackgroundColor3 = Color3.new(1, 0, 0)
Button.TextColor3 = Color3.new(1,1,1)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 20
Button.Text = "Brainrot Blocker : OFF"

local enabled = false

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if enabled and (method == "FireServer" or method == "InvokeServer") then
        local remoteName = tostring(self):lower()
        if remoteName:find("brainrot") or remoteName:find("hit") then
            print("[BrainrotBlocker] Bloqué : ", remoteName)
            return nil
        end
    end
    return oldNamecall(self, ...)
end)

Button.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        Button.BackgroundColor3 = Color3.new(0, 1, 0)
        Button.Text = "Brainrot Blocker : ON"
        print("[BrainrotBlocker] Activé")
    else
        Button.BackgroundColor3 = Color3.new(1, 0, 0)
        Button.Text = "Brainrot Blocker : OFF"
        print("[BrainrotBlocker] Désactivé")
    end
end)
