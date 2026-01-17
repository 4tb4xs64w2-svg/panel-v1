-- ============================================================================
-- PLAYER ESP (NAME + DISTANCE IN METERS)
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
    return math.floor(studs * 0.28)
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
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 255, 170)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextScaled = true
    label.Parent = billboard

    ESPObjects[player] = billboard
end

-- ============================================================================
-- MAIN LOOP
-- ============================================================================

RunService.RenderStepped:Connect(function()
    if not _G.ESPEnabled then
        for player in pairs(ESPObjects) do
            removeESP(player)
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")

            if hrp and hum and hum.Health > 0 then
                if not ESPObjects[player] then
                    createESP(player)
                end

                local billboard = ESPObjects[player]
                billboard.Parent = hrp

                local distanceStuds = (Camera.CFrame.Position - hrp.Position).Magnitude
                local distanceMeters = studsToMeters(distanceStuds)

                billboard.TextLabel.Text =
                    player.Name .. " [" .. distanceMeters .. " m]"
            else
                removeESP(player)
            end
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

print("✅ ESP Players cargado (Nombre + Distancia)")
