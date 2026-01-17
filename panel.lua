--// SIMPLE MASTER HUB + MINIMIZE

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
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.fromOffset(10, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 Master Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(0,255,170)
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
local Minimize = Instance.new("TextButton", TopBar)
Minimize.Size = UDim2.fromOffset(30, 30)
Minimize.Position = UDim2.new(1, -35, 0, 5)
Minimize.Text = "-"
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 22
Minimize.TextColor3 = Color3.new(1,1,1)
Minimize.BackgroundColor3 = Color3.fromRGB(35,35,35)
Minimize.BorderSizePixel = 0
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(1,0)

-- Content
local Content = Instance.new("Frame", Main)
Content.Position = UDim2.fromOffset(0, 40)
Content.Size = UDim2.new(1, 0, 1, -40)
Content.BackgroundTransparency = 1

-- Button
local Button = Instance.new("TextButton", Content)
Button.Position = UDim2.fromOffset(40, 40)
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

-- ENABLE / DISABLE
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

-- MINIMIZE
local minimized = false
Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized
    Main.Size = minimized and UDim2.fromOffset(300, 40) or UDim2.fromOffset(300, 180)
end)
