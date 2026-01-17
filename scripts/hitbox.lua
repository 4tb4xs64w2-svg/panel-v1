-- Hitbox Expander - PANEL CONTROLLED VERSION

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- =========================
-- GLOBAL FLAG (PANEL)
-- =========================
_G.HitboxEnabled = _G.HitboxEnabled or false

-- =========================
-- CONFIG
-- =========================
local HITBOX_SIZE = 5000 -- multiplicador
local UPDATE_INTERVAL = 0.05

local originalSizes = {}
local lastUpdate = 0

-- =========================
-- UTILS
-- =========================
local function IsAlive(char)
    return char
        and char:FindFirstChildOfClass("Humanoid")
        and char.Humanoid.Health > 0
end

local function getParts(character)
    return {
        character:FindFirstChild("Head"),
        character:FindFirstChild("HumanoidRootPart"),
        character:FindFirstChild("Torso"),
        character:FindFirstChild("UpperTorso"),
        character:FindFirstChild("LowerTorso"),
    }
end

-- =========================
-- APPLY / RESTORE HITBOX
-- =========================
local function applyHitbox(character)
    if not character or character == LocalPlayer.Character then return end

    for _, part in pairs(getParts(character)) do
        if part and part:IsA("BasePart") then
            if not originalSizes[part] then
                originalSizes[part] = part.Size
            end
            part.Size = originalSizes[part] * HITBOX_SIZE
            part.CanCollide = false
            part.Transparency = 0.5
        end
    end
end

local function restoreHitbox(character)
    if not character then return end

    for _, part in pairs(getParts(character)) do
        if part and originalSizes[part] then
            part.Size = originalSizes[part]
            part.CanCollide = true
            part.Transparency = 0
        end
    end
end

-- =========================
-- PLAYER EVENTS
-- =========================
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        if _G.HitboxEnabled then
            applyHitbox(character)
        end
    end)
end)

-- =========================
-- MAIN LOOP (OBEDECE PANEL)
-- =========================
RunService.RenderStepped:Connect(function()
    local now = tick()
    if now - lastUpdate < UPDATE_INTERVAL then return end
    lastUpdate = now

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and IsAlive(player.Character) then
            if _G.HitboxEnabled then
                applyHitbox(player.Character)
            else
                restoreHitbox(player.Character)
            end
        end
    end
end)

-- =========================
-- INITIAL CLEANUP
-- =========================
-- por si el script se carga con el botón apagado
for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        restoreHitbox(player.Character)
    end
end

print("Hitbox listo (controlado por panel)")
