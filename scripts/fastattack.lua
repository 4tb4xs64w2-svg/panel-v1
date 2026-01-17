-- Fast Attack - GitHub Ready

if getgenv().rz_FastAttackLoaded then
    return
end
getgenv().rz_FastAttackLoaded = true

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
if not Player then return end
if not Player.Character then
    Player.CharacterAdded:Wait()
end

local function SafeWaitForChild(parent, name, timeout)
    timeout = timeout or 10
    local ok, res = pcall(function()
        return parent:WaitForChild(name, timeout)
    end)
    if ok then return res end
end

local Remotes = SafeWaitForChild(ReplicatedStorage, "Remotes")
local Modules = SafeWaitForChild(ReplicatedStorage, "Modules")
local Net = Modules and SafeWaitForChild(Modules, "Net")
if not Net then return end

local RegisterAttack =
    SafeWaitForChild(Net, "RE/RegisterAttack") or
    SafeWaitForChild(Net, "RegisterAttack")

local RegisterHit =
    SafeWaitForChild(Net, "RE/RegisterHit") or
    SafeWaitForChild(Net, "RegisterHit")

if not RegisterAttack or not RegisterHit then
    warn("FastAttack: remotes no encontrados")
    return
end

local Enemies = workspace:FindFirstChild("Enemies")
local Characters = workspace:FindFirstChild("Characters")

local Settings = {
    AutoClick = true,
    ClickDelay = 0.08,
}

local FastAttack = {
    Distance = 100000,
    attackMobs = true,
    attackPlayers = false,
}

local function IsAlive(char)
    return char
        and char:FindFirstChild("Humanoid")
        and char.Humanoid.Health > 0
end

local function Process(folder, list)
    if not folder then return end
    for _, m in pairs(folder:GetChildren()) do
        if m:IsA("Model") and IsAlive(m) then
            local part = m:FindFirstChild("Head")
                or m:FindFirstChild("HumanoidRootPart")
                or m:FindFirstChild("Torso")

            if part and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (Player.Character.HumanoidRootPart.Position - part.Position).Magnitude
                if dist < FastAttack.Distance then
                    table.insert(list, { m, part })
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not Settings.AutoClick then return end
    if not IsAlive(Player.Character) then return end

    local tool = Player.Character:FindFirstChildOfClass("Tool")
    if not tool or tool.ToolTip == "Gun" then return end

    local targets = {}
    Process(Enemies, targets)
    Process(Characters, targets)

    if #targets > 0 then
        pcall(function()
            RegisterAttack:FireServer(Settings.ClickDelay)
            RegisterHit:FireServer(targets[1][2], targets)
        end)
    end
end)

print("Fast Attack cargado correctamente")
