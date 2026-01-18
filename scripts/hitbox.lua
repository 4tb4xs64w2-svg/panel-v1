-- HITBOX REAL MÁS GRANDE POSIBLE 2025 (30 partes = ~8000+ studs reales)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local hitboxSize = 2048  -- ← Esto es lo máximo que Roblox permite de verdad
local extras = 30        -- ← 30 partes extra = supera cualquier "5000" falso
local teamCheck = false
local visible = false

local function addExtras(model)
    if model:FindFirstChild("InfiniteParts") then return end
    local folder = Instance.new("Folder", model)
    folder.Name = "InfiniteParts"
    for i = 1, extras do
        local p = Instance.new("Part", folder)
        p.Name = "InfPart"..i
        p.Size = Vector3.new(2048,2048,2048)
        p.Transparency = 1
        p.CanCollide = false
        p.Anchored = false
        p.CFrame = model.HumanoidRootPart.CFrame * CFrame.new(
            math.random(-3000,3000), math.random(-3000,3000), math.random(-3000,3000)
        )
        local weld = Instance.new("WeldConstraint", p)
        weld.Part0 = model.HumanoidRootPart
        weld.Part1 = p
    end
end

local function expand(model, enemy)
    if not model:FindFirstChildOfClass("Humanoid") or model:FindFirstChildOfClass("Humanoid").Health <= 0 then return end
    if not model:FindFirstChild("HumanoidRootPart") then return end
    
    for _, v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Size = Vector3.new(2048,2048,2048)
            v.Transparency = visible and 0.7 or 1
            v.CanCollide = false
        end
    end
    addExtras(model)  -- ← ESTO ES LO QUE REALMENTE SUPERA los 2048
end

local function loop()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and (not teamCheck or plr.Team ~= LocalPlayer.Team) then
            expand(plr.Character, true)
        end
    end
    for _, folder in pairs({"Enemies","Boss","Raid","SeaBeast","SeaEvents"}) do
        local f = workspace:FindFirstChild(folder)
        if f then
            for _, v in pairs(f:GetChildren()) do
                if v:IsA("Model") then expand(v, true) end
            end
        end
    end
end

RunService.Heartbeat:Connect(loop)
