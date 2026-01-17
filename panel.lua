--// SIMPLE MASTER HUB (FUNCIONAL)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- FLAGS
_G.FastAttackEnabled = false
_G.HitboxEnabled = false
_G.ESPEnabled = false

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MasterHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.fromOffset(300, 180)
Main.Position = UDim2.fromScale(0.4, 0.35)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- TopBar
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
TopBar.Active = true

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 Master Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(0,255,170)

-- Button
local Button = Instance.new("TextButton", Main)
Button.Position = UDim2.fromOffset(40, 70)
Button.Size = UDim2.fromOffset(220, 60)
Button.Text = "ENABLE ALL"
Button.Font = Enum.Font.GothamBold
Button.TextSize = 18
Button.TextColor3 = Color3.new(1,1,1)
Button.BackgroundColor3 = Color3.fromRGB(30,30,30)
Button.BorderSizePixel = 0
Instance.new("UICorner", Button).CornerRadius = UDim.new(0,10)

-- DRAG
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = i.Position
        startPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- STATE
local enabled = false
local loaded = false

Button.MouseButton1Click:Connect(function()
    enabled = not enabled

    _G.FastAttackEnabled = enabled
    _G.HitboxEnabled = enabled
    _G.ESPEnabled = enabled

    if enabled and not loaded then
        loaded = true

        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/4tb4xs64w2-svg/panel-v1/refs/heads/main/scripts/fastattack.lua"
        ))()

        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/4tb4xs64w2-svg/panel-v1/refs/heads/main/scripts/hitbox.lua"
        ))()

        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/4tb4xs64w2-svg/panel-v1/refs/heads/main/scripts/ESPPlayer.lua"
        ))()
    end

    Button.Text = enabled and "DISABLE ALL" or "ENABLE ALL"
    Button.BackgroundColor3 = enabled and Color3.fromRGB(0,170,120) or Color3.fromRGB(30,30,30)
end)
