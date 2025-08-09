-- Brainrot Saver : debug + blocage amélioré
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Parent pour la GUI (PlayerGui si possible, sinon CoreGui)
local guiParent
if player and player:FindFirstChild("PlayerGui") then
    guiParent = player:WaitForChild("PlayerGui")
else
    guiParent = game:GetService("CoreGui")
end

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotSaverGUI"
ScreenGui.Parent = guiParent

local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0, 520, 0, 360)
mainFrame.Position = UDim2.new(0, 20, 0, 80)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
mainFrame.BorderSizePixel = 0

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -10, 0, 30)
title.Position = UDim2.new(0, 5, 0, 5)
title.Text = "Brainrot Saver — Debug"
title.TextSize = 18
title.Font = Enum.Font.SourceSansBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1

local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(0, 140, 0, 28)
toggleBtn.Position = UDim2.new(0, 10, 0, 40)
toggleBtn.Text = "OFF"
toggleBtn.TextSize = 16
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)

local setLastBtn = Instance.new("TextButton", mainFrame)
setLastBtn.Size = UDim2.new(0, 160, 0, 28)
setLastBtn.Position = UDim2.new(0, 160, 0, 40)
setLastBtn.Text = "Set Last As Target"
setLastBtn.TextSize = 14
setLastBtn.Font = Enum.Font.SourceSans
setLastBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
setLastBtn.TextColor3 = Color3.fromRGB(255,255,255)

local clearBtn = Instance.new("TextButton", mainFrame)
clearBtn.Size = UDim2.new(0, 80, 0, 28)
clearBtn.Position = UDim2.new(0, 330, 0, 40)
clearBtn.Text = "Clear"
clearBtn.TextSize = 14
clearBtn.Font = Enum.Font.SourceSans
clearBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
clearBtn.TextColor3 = Color3.fromRGB(255,255,255)

local autoDetectBtn = Instance.new("TextButton", mainFrame)
autoDetectBtn.Size = UDim2.new(0, 120, 0, 28)
autoDetectBtn.Position = UDim2.new(0, 420, 0, 40)
autoDetectBtn.Text = "AutoDetect: ON"
autoDetectBtn.TextSize = 13
autoDetectBtn.Font = Enum.Font.SourceSans
autoDetectBtn.BackgroundColor3 = Color3.fromRGB(50,100,50)
autoDetectBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- Scrolling log
local logFrame = Instance.new("ScrollingFrame", mainFrame)
logFrame.Size = UDim2.new(1, -10, 0, 270)
logFrame.Position = UDim2.new(0, 5, 0, 75)
logFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
logFrame.ScrollBarThickness = 6
logFrame.BackgroundTransparency = 1

local uiLayout = Instance.new("UIListLayout", logFrame)
uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiLayout.Padding = UDim.new(0, 4)

-- Variables
local enabled = false
local targetRemote = nil
local lastRemote = nil
local autoDetect = true
local logCount = 0

local function addLog(txt)
    logCount = logCount + 1
    local label = Instance.new("TextLabel", logFrame)
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 0.5
    label.BackgroundColor3 = Color3.fromRGB(40,40,40)
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = ("[%d] %s"):format(logCount, txt)
    logFrame.CanvasSize = UDim2.new(0, 0, 0, 24 * logCount)
    print(label.Text)
end

-- Toggle handlers
toggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
        addLog("[SYSTEM] Blocking ACTIVATED")
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
        addLog("[SYSTEM] Blocking DEACTIVATED")
    end
end)

setLastBtn.MouseButton1Click:Connect(function()
    if lastRemote then
        targetRemote = lastRemote
        addLog("[SYSTEM] Target set to: "..tostring(targetRemote))
    else
        addLog("[SYSTEM] Aucun remote détecté encore.")
    end
end)

clearBtn.MouseButton1Click:Connect(function()
    targetRemote = nil
    addLog("[SYSTEM] Target cleared")
end)

autoDetectBtn.MouseButton1Click:Connect(function()
    autoDetect = not autoDetect
    autoDetectBtn.Text = "AutoDetect: "..(autoDetect and "ON" or "OFF")
    autoDetectBtn.BackgroundColor3 = autoDetect and Color3.fromRGB(50,100,50) or Color3.fromRGB(100,50,50)
end)

-- Hook pour logger et bloquer
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- stringify args (safe)
    local ok, argStr = pcall(function()
        local t = {}
        for i,v in ipairs(args) do
            table.insert(t, tostring(v))
        end
        return table.concat(t, ", ")
    end)
    if not ok then argStr = "<could not tostring args>" end

    local entry = tostring(self).." | "..method.." | "..argStr
    addLog(entry)
    lastRemote = self

    -- auto-detect keywords
    if autoDetect and not targetRemote then
        local lowerName = tostring(self):lower()
        local lowerArgs = argStr:lower()
        local keywords = {"brainrot","brain rot","remove","removestatus","debuff","status","cure","hit","hurt","damage","clear","apply","remove_buff","remove_debuff"}
        for _,kw in ipairs(keywords) do
            if lowerName:find(kw) or lowerArgs:find(kw) then
                targetRemote = self
                addLog("[AutoDetect] Target auto-set to: "..tostring(self))
                break
            end
        end
    end

    -- if enabled and this is target -> block
    if enabled and targetRemote and self == targetRemote and (method == "FireServer" or method == "InvokeServer") then
        addLog("[BLOCKED] "..tostring(self).." via "..method)
        return nil
    end

    return oldNamecall(self, ...)
end)

addLog("[SYSTEM] Script lancé. Attends qu'un remote apparaisse dans le log, puis click 'Set Last As Target' et mets ON.")
