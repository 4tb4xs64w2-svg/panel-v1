-- Hitbox Expander - PANEL CONTROLLED VERSION (NO GUI)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- =========================
-- GLOBAL FLAGS (PANEL)
-- =========================
_G.HitboxEnabled = _G.HitboxEnabled or false
_G.HitboxTeamCheck = _G.HitboxTeamCheck or false
_G.HitboxSize = _G.HitboxSize or 10000000000

-- =========================
-- STORAGE
-- =========================
local originalSizes = {}
local lastUpdate = 0
local UPDATE_INTERVAL = 0.1

-- =========================
-- UTILS
-- =========================
local function IsAlive(char)
    return char
        and char:FindFirstChildOfClass("Humanoid")
        and char.Humanoid.Health > 0
end

local function shouldApply(player)
    if player == LocalPlayer then return false end
    if not player.Character then return false end
    if not IsAlive(player.Character) then return false end
    if _G.HitboxTeamCheck and player.Team == LocalPlayer.Team then
        return false
    end
    return true
end

-- =========================
-- APPLY / RESTORE
-- =========================
local function applyHitbox(player)
    if not shouldApply(player) then return end

    for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") then
            if not originalSizes[part] then
                originalSizes[part] = part.Size
            end
            part.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
            part.Transparency = 1
            part.CanCollide = false
        end
    end
end

local function restoreHitbox(player)
    if not player.Character then return end

    for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") and originalSizes[part] then
            part.Size = originalSizes[part]
            part.Transparency = 0
            part.CanCollide = true
        end
    end
end

-- =========================
-- PLAYER EVENTS
-- =========================
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if _G.HitboxEnabled then
            applyHitbox(player)
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

    for _, player in ipairs(Players:GetPlayers()) do
        if _G.HitboxEnabled then
            applyHitbox(player)
        else
            restoreHitbox(player)
        end
    end
end)

-- =========================
-- INITIAL CLEANUP
-- =========================
for _, player in ipairs(Players:GetPlayers()) do
    restoreHitbox(player)
end

print("Hitbox Expander listo (controlado por panel)")
