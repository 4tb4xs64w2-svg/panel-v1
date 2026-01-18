-- ============================================================================
-- BLOX FRUITS ESP (Nombre + Nivel + %Vida + Distancia)
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
    return math.floor(studs * 0.28 + 0.5)
end

local function formatNumber(num)
    if num >= 1000 then
        return string.format("%.1fk", num / 1000)
    end
    return tostring(num)
end

local function getHealthPercent(hum)
    if not hum then return 0 end
    return math.floor((hum.Health / hum.MaxHealth) * 100 + 0.5)
end

local function getHealthColor(percent)
    if percent > 70 then return Color3.fromRGB(0, 255, 100)  -- Verde
    elseif percent > 30 then return Color3.fromRGB(255, 200, 60)  -- Amarillo
    else return Color3.fromRGB(255, 60, 60)  -- Rojo
    end
end

local function removeESP(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end

local function createESP(player)
    if player == LocalPlayer or ESPObjects[player] then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BF_ESP"
    billboard.Size = UDim2.new(0, 280, 0, 80)  -- Más grande para 4 líneas
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.ResetOnSpawn = false
    billboard.LightInfluence = 0

    local label = Instance.new("TextLabel")
    label.Name = "InfoLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.Parent = billboard

    ESPObjects[player] = billboard
end

-- ============================================================================
-- MAIN LOOP
-- ============================================================================
RunService.RenderStepped:Connect(function()
    if not _G.ESPEnabled then
        for player, _ in pairs(ESPObjects) do
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

        local head = character:FindFirstChild("Head")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not (head or hrp) then
            removeESP(player)
            continue
        end

        local targetPart = head or hrp  -- Prefer Head para mejor posición

        if not ESPObjects[player] then
            createESP(player)
        end

        local billboard = ESPObjects[player]
        billboard.Parent = targetPart
        billboard.Adornee = targetPart

        -- Distancia
        local distanceStuds = (Camera.CFrame.Position - targetPart.Position).Magnitude
        local distanceMeters = studsToMeters(distanceStuds)

        -- Nivel (Blox Fruits leaderstats)
        local leaderstats = player:FindFirstChild("leaderstats")
        local level = leaderstats and leaderstats:FindFirstChild("Level")
        local levelText = level and "Lv." .. formatNumber(level.Value) or ""

        -- Vida %
        local healthPercent = getHealthPercent(humanoid)
        local healthStatus = (healthPercent > 0) and (healthPercent .. "% HP") or "DEAD"
        local color = getHealthColor(healthPercent)

        -- Texto final (4 líneas max)
        local displayText = player.Name .. "\n" ..
                           levelText .. "\n" ..
                           healthStatus .. "\n" ..
                           distanceMeters .. "m"

        billboard.InfoLabel.TextColor3 = color
        billboard.InfoLabel.Text = displayText
    end
end)

-- ============================================================================
-- CLEANUP
-- ============================================================================
Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

_G.ESPEnabled = true  -- ¡Activado por defecto!
print("✅ ESP BLOX FRUITS cargado (Nombre + Nivel + %Vida + Distancia)")
print("💡 Activar/Desactivar: _G.ESPEnabled = true/false")
