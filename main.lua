-- Simple Brainrot Blocker
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "SimpleBrainrotBlocker"

local Button = Instance.new("TextButton")
Button.Parent = ScreenGui
Button.Size = UDim2.new(0, 150, 0, 50)
Button.Position = UDim2.new(0, 20, 0, 200)
Button.Text = "Brainrot Blocker: OFF"
Button.BackgroundColor3 = Color3.new(1, 0, 0)
Button.TextColor3 = Color3.new(1,1,1)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 20

local enabled = false

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if enabled and (method == "FireServer" or method == "InvokeServer") then
        local remoteName = tostring(self):lower()
        local argsStr = ""
        for _,v in ipairs(args) do
            argsStr = argsStr .. tostring(v):lower() .. " "
        end
        if remoteName:find("brainrot") or remoteName:find("hit") or argsStr:find("brainrot") or argsStr:find("remove") then
            print("[Brainrot Blocker] Blocked:", remoteName, argsStr)
            return nil
        end
    end
    return oldNamecall(self, ...)
end)

Button.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        Button.Text = "Brainrot Blocker: ON"
        Button.BackgroundColor3 = Color3.new(0, 1, 0)
        print("[Brainrot Blocker] Activated")
    else
        Button.Text = "Brainrot Blocker: OFF"
        Button.BackgroundColor3 = Color3.new(1, 0, 0)
        print("[Brainrot Blocker] Deactivated")
    end
end)
