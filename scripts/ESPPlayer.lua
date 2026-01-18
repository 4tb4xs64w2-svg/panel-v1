-- ============================================================================
-- PLAYER ESP (NAME + DISTANCE + HEALTH)
-- Controlled by _G.ESPEnabled
-- ============================================================================
if _G.ESPRunning then return end
_G.ESPRunning = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESPObjects = {}

-- ============================================================================
-- UTILS
-- ============================================================================
local function studsToMeters(studs)
    return math.floor(studs * 0.28 + 0.5)  -- redondeo más natural
end

local function getHealthColor(health, maxHealth)
    local percent = health / maxHealth
    if percent > 0.7 then
        return Color3.fromRGB(0, 255, 100)     -- verde
    elseif percent > 0.35 then
        return Color3.fromRGB(255, 200, 60)    -- amarillo/naranja
    else
        return Color3.fromRGB(255, 60, 60)     -- rojo
    end
end

local function removeESP(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end

local function createESP(player)
    if player == LocalPlayer then return end
    if ESPObjects[player] then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(0, 220, 0, 60)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    billboard.ResetOnSpawn = false

    local label = Instance.new("TextLabel")
    label.Name = "InfoLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 255, 170)
    label.TextStrokeTransparency = 0.4
    label.TextStrokeColor3 = Color3.new(0,0,0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Parent = billboard

    ESPObjects[player] = billboard
end

-- ============================================================================
-- MAIN LOOP
-- ============================================================================
RunService.RenderStepped:Connect(function()
    if not _G.ESPEnabled then
        for player,_ in pairs(ESPObjects) do
            removeESP(player)
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        local character = player.Character
        if not character then
            removeESP(player)
            continue
        end

        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if hrp and humanoid and humanoid.Health > 0 then
            if not ESPObjects[player] then
                createESP(player)
            end

            local billboard = ESPObjects[player]
            billboard.Parent = hrp

            local distanceStuds = (Camera.CFrame.Position - hrp.Position).Magnitude
            local distanceMeters = studsToMeters(distanceStuds)

            local health = math.floor(humanoid.Health + 0.5)
            local maxHealth = math.floor(humanoid.MaxHealth + 0.5)
            local healthText = health .. " / " .. maxHealth

            -- Color según vida
            local color = getHealthColor(humanoid.Health, humanoid.MaxHealth)

            billboard.InfoLabel.TextColor3 = color
            billboard.InfoLabel.Text =
                player.Name .. "\n" ..
                healthText .. " HP" .. "\n" ..
                distanceMeters .. " m"
        else
            removeESP(player)
        end
    end
end)

-- ============================================================================
-- CLEANUP
-- ============================================================================
Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Para detenerlo manualmente si quieres (opcional)
-- _G.ESPRunning = false

print("✅ ESP Players cargado (Nombre + Vida + Distancia)")
