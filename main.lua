local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local brainrotFolder = workspace:WaitForChild("Brainrots")
local remoteName = "CollectBrainrot" -- Modifie si besoin
local collectRemote = ReplicatedStorage:FindFirstChild(remoteName)

if not collectRemote then
    warn("RemoteEvent '"..remoteName.."' non trouvé dans ReplicatedStorage")
    return
end

local enabled = false

print("Tape 'toggle()' pour activer/désactiver le ramassage automatique.")

function toggle()
    enabled = not enabled
    print("Ramassage automatique: "..(enabled and "Activé" or "Désactivé"))
end

RunService.Heartbeat:Connect(function()
    if enabled then
        for _, br in pairs(brainrotFolder:GetChildren()) do
            if br:IsA("BasePart") then
                collectRemote:FireServer(br)
            end
        end
    end
end)
