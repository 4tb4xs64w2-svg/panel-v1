-- HITBOX SCRIPT 100K
-- Archivo: hitbox.lua

_G.HitboxEnabled = true
_G.HitboxSize = 100000 -- 100K REAL

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

while _G.HitboxEnabled do
    task.wait(0.25)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                pcall(function()
                    hrp.Size = Vector3.new(
                        _G.HitboxSize,
                        _G.HitboxSize,
                        _G.HitboxSize
                    )
                    hrp.Transparency = 1
                    hrp.CanCollide = false
                    hrp.Material = Enum.Material.Neon
                end)
            end
        end
    end
end
