--// Skibidi Hub UI
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

--// Variables de control
_G.FastAttackEnabled = false
_G.HitboxEnabled = false
_G.ESPEnabled = false

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SkibidiHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

--// Main Frame
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Position = UDim2.fromScale(0.35, 0.3)
Main.Size = UDim2.fromOffset(360, 260)
Main.BorderSizePixel = 0
Main.Active = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

--// Top Bar (DRAG)
local TopBar = Instance.new("Frame")
TopBar.Parent = Main
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1

--// Title
local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 Skibidi Hub"
Title.TextColor3 = Color3.fromRGB(0, 255, 170)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Left

--// Minimize Button
local Minimize = Instance.new("TextButton")
Minimize.Parent = TopBar
Minimize.Size = UDim2.fromOffset(30, 30)
Minimize.Position = UDim2.new(1, -35, 0, 7)
Minimize.Text = "-"
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 20
Minimize.TextColor3 = Color3.new(1,1,1)
Minimize.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Minimize.BorderSizePixel = 0
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(1, 0)

--// Line
local Line = Instance.new("Frame")
Line.Parent = Main
Line.Position = UDim2.fromOffset(20, 45)
Line.Size = UDim2.new(1, -40, 0, 2)
Line.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
Line.BorderSizePixel = 0

--// Content holder
local Content = Instance.new("Frame")
Content.Parent = Main
Content.Position = UDim2.fromOffset(0, 55)
Content.Size = UDim2.new(1, 0, 1, -55)
Content.BackgroundTransparency = 1

--// Button creator
local function CreateButton(text, yPos, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = Content
    Button.Position = UDim2.fromOffset(30, yPos)
    Button.Size = UDim2.fromOffset(300, 45)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.Text = text .. " : OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 16
    Button.AutoButtonColor = false
    Button.BorderSizePixel = 0

    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

    Button.MouseButton1Click:Connect(function()
        local state = callback()
        Button.Text = text .. (state and " : ON" or " : OFF")
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 170, 120) or Color3.fromRGB(30, 30, 30)
    end)
end

--// Buttons
CreateButton("Fast Attack", 20, function()
    _G.FastAttackEnabled = not _G.FastAttackEnabled
        if _G.FastAttackEnabled then
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/4tb4xs64w2-svg/panel-v1/refs/heads/main/scripts/fastattack.lua"
        ))()
    end
    print("Fast Attack:", _G.FastAttackEnabled)
    return _G.FastAttackEnabled
end)

CreateButton("Hitbox", 80, function()
    _G.HitboxEnabled = not _G.HitboxEnabled
        if _G.HitboxEnabled then
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/4tb4xs64w2-svg/panel-v1/refs/heads/main/scripts/hitbox.lua"
    ))()
end
        
    print("Hitbox:", _G.HitboxEnabled)
    return _G.HitboxEnabled
end)

CreateButton("ESP Player", 140, function()
    _G.ESPEnabled = not _G.ESPEnabled
        if _G.ESPEnabled then
    loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/4tb4xs64w2-svg/panel-v1/refs/heads/main/scripts/ESPPlayer.lua"
    ))()
end

    print("ESP Player:", _G.ESPEnabled)
    return _G.ESPEnabled
end)

--// DRAG SYSTEM (REAL)
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

--// Minimize
local minimized = false
Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized
    Line.Visible = not minimized
    Main.Size = minimized and UDim2.fromOffset(360, 45) or UDim2.fromOffset(360, 260)
end)
