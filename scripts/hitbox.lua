-- ============================================================================
-- HITBOX EXPANDER (NO GUI - PANEL CONTROLLED)
-- ============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- CONFIG
local HITBOX_SIZE = 100000
local originalSizes = {}
local updateInterval = 0.05
local lastUpdate = 0

-- Ensure global flag exists
_G.HitboxEnabled = _G.HitboxEnabled or false

-- Expand / Restore hitbox
local function processCharacter(character)
    if not character or character == LocalPlayer.Character then return end

    local parts = {
        character:FindFirstChild("Head"),
        character:FindFirstChild("HumanoidRootPart"),
        character:FindFirstChild("UpperTorso"),
        character:FindFirstChild("LowerTorso"),
        character:FindFirstChild("Torso")
    }

    for _, part in ipairs(parts) do
        if part and part:IsA("BasePart") then
            if _G.HitboxEnabled then
                if not originalSizes[part] then
                    originalSizes[part] = part.Size
                end
                part.Size = Vector3.new(HITBOX_SIZE, HITBOX_SIZE, HITBOX_SIZE)
                part.CanCollide = false
                part.Transparency = 0.5
            else
                if originalSizes[part] then
                    part.Size = originalSizes[part]
                    part.Transparency = 0
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Players join
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        if _G.HitboxEnabled then
            processCharacter(character)
        end
    end)
end)

-- Main loop (throttled)
RunService.RenderStepped:Connect(function()
    local now = tick()
    if now - lastUpdate < updateInterval then return end
    lastUpdate = now

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                processCharacter(player.Character)
            end
        end
    end
end)

-- Initial pass
for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        task.spawn(function()
            task.wait(0.5)
            processCharacter(player.Character)
        end)
    end
end
