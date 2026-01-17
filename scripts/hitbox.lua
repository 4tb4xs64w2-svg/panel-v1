-- ============================================================================
-- OPTIMIZED SCRIPT LOADER - ORIGINAL STYLE
-- ============================================================================
-- Made by TrashScripterF (Optimized Version)
-- Other Scripters: mrnickson, Sky, and StayBlue
-- ============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ============================================================================
-- SCRIPTS DATABASE (COMPRESSED)
-- ============================================================================
local scripts = {
    ["2686500207"]="ABizarreDayBanknoteTP.lua",["3224790922"]="AOTInfBladeAndGas.lua",["3582153031"]="AOTInfBladeAndGas.lua",
    ["2394658527"]="BloxnoHero2AutoFarm.lua",["536102540"]="DBZFinalStandAutoFarm",["3221241066"]="DeadzoneESP.lua",
    ["4477226641"]="DemonJourneyAutofarm.lua",["566399244"]="ElementalBattlegroundsInfStam.lua",
    ["2569625809"]="ElementalBattlegroundsInfStam.lua",["3095204897"]={"IsleESP.lua","IsleHunterHitbox.lua"},
    ["745844303"]="JojoBizarreWorldPunchSpam.lua",["4760622859"]="KurokoBasukeHitboxExpander.lua",
    ["4694533755"]="LeeLineageArtifactTP.lua",["1525936952"]="LostESP.lua",["4296632651"]="MyHeroLegendaryAutofarm.lua",
    ["3127808194"]="OnePieceAwakeningGUI.lua",["2098516465"]="RHS2ItemGrabber.lua",["3198259055"]="SoulShattersInfStam.lua",
    ["261290060"]="TerminalRailwaysTeles.lua",["133815151"]="TheFinalStandAutofarm.lua",["1103751037"]="TheFinalStandAutofarm.lua",
    ["2899434514"]="TheFinalStandAutofarm.lua",["328028363"]="TypicalColors2Backstab.lua",["198817751"]="VampireHunters2ESP.lua",
    ["2809202155"]="YourBizzareAdventureItemESP.lua",["3759927663"]="ZombieStrikeGunMods.lua",["3803533582"]="ZombieStrikeGunMods.lua",
    ["2622527242"]="rBreachSCPGUI.lua",["4340636621"]="MilitaryMadnessGUI.lua",["3340155139"]="MilitaryMadnessGUI.lua",
    ["3144140570"]="HoopVerseAimbot.lua",["3073974886"]="HoopVerseAimbot.lua",["797772998"]="LundenwicInfMoney.lua",
    ["287999508"]="TankerySpeed.lua",["761903717"]="TankerySpeed.lua",["4488998649"]="TankerySpeed.lua",
    ["3025990139"]="UnboxingSimAutofarm.lua",["29812337"]="FramedFaceList.lua",["445265003"]="SCPNineTailedFoxESP.lua",
    ["3722931411"]="SouthLondonAutograb.lua",["301549746"]="CBROTriggerBot.lua",["510411669"]="FantasticFrontierFogBypass.lua",
    ["142823291"]="MM2Coins.lua",["1345139196"]="TreasureHuntSimAutofarm.lua",["2821311961"]="LandOfKings2AFKBypass.lua",
    ["3734765037"]="SchoolSimulatorFarm.lua",["598947721"]="HCBBHittingAssist.lua",
    ["1284995092"]="HxHWorldsInfStam.lua",["1271540988"]="HxHWorldsInfStam.lua",["2985324747"]="HxHWorldsInfStam.lua",
    ["1377051471"]="HxHWorldsInfStam.lua",["1267706319"]="HxHWorldsInfStam.lua",["2666628845"]="HxHWorldsInfStam.lua",
    ["1659370517"]="HxHWorldsInfStam.lua",["1658595723"]="HxHWorldsInfStam.lua",["2822139147"]="HxHWorldsInfStam.lua",
    ["2914207477"]="HxHWorldsInfStam.lua",["4683548487"]="HxHWorldsInfStam.lua",["1331553051"]="HxHWorldsInfStam.lua",
    ["2723224683"]="HxHWorldsInfStam.lua",["3017625278"]="HxHWorldsInfStam.lua",["1663316935"]="HxHWorldsInfStam.lua",
    ["2690587765"]="HxHWorldsInfStam.lua",["1759719157"]="HxHWorldsInfStam.lua",["1754083847"]="HxHWorldsInfStam.lua",
    ["2685347741"]="GhostSimulatorAutofarm.lua",["4383090972"]="GhostSimulatorAutofarm.lua",
    ["4383092793"]="GhostSimulatorAutofarm.lua",["3083470782"]="GhostSimulatorAutofarm.lua",
    ["3113119566"]="GhostSimulatorAutofarm.lua",["4078021957"]="GhostSimulatorAutofarm.lua",
    ["4078003854"]="GhostSimulatorAutofarm.lua",["4507873123"]="GhostSimulatorAutofarm.lua",
    ["4507873031"]="GhostSimulatorAutofarm.lua",["3307329238"]="GhostSimulatorAutofarm.lua",
    ["885450884"]={"BorderRolePlayGunMods.lua","BorderRolePlaySilentAim.lua"},
    ["3840352284"]="VolleyballInfStam.lua",["2653064683"]="WordBombWordFinder.lua",
    UniBypass="BasicWSandJPBypass.lua",Hitbox="HitboxExpander.lua",R2S="R2S.lua",AntiAFK="AntiAFK.lua"
}

local checkGame = true

-- ============================================================================
-- HITBOX CONFIGURATION
-- ============================================================================
local hitboxEnabled = false
local hitboxExpansion = 1000000
local originalSizes = {}

-- Cache para optimización
local playerCache = {}
local lastUpdate = 0
local updateInterval = 0.05 -- Actualizar cada 0.05 segundos en vez de cada frame

-- ============================================================================
-- LOAD FUNCTION (OPTIMIZED)
-- ============================================================================
function load(name)
    local scriptData = scripts[name]
    if not scriptData then return end
    
    pcall(function()
        if type(scriptData) == "string" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/BadScripter/Scripts/master/"..scriptData,true))()
        else
            for _, v in pairs(scriptData) do
                loadstring(game:HttpGet("https://raw.githubusercontent.com/BadScripter/Scripts/master/"..v,true))()
            end
        end
    end)
end

-- ============================================================================
-- GUI CREATION (SAME AS ORIGINAL)
-- ============================================================================
local function createGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ScriptGUI"
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 100)
    frame.Position = UDim2.new(0.1, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.Parent = gui

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.8, 0, 0.3, 0)
    toggleButton.Position = UDim2.new(0.1, 0, 0.1, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.Text = "Hitbox: OFF"
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextScaled = true
    toggleButton.Parent = frame

    local function updateButtonText()
        toggleButton.Text = hitboxEnabled and "Hitbox: ON" or "Hitbox: OFF"
    end

    toggleButton.MouseButton1Click:Connect(function()
        hitboxEnabled = not hitboxEnabled
        updateButtonText()
        
        -- Actualizar hitboxes inmediatamente
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                expandEnemyHitbox(player.Character)
            end
        end
    end)

    updateButtonText()
end

-- ============================================================================
-- HITBOX EXPANSION (OPTIMIZED)
-- ============================================================================
local function expandEnemyHitbox(character)
    if not character or character == LocalPlayer.Character then return end

    -- Optimización: Solo procesar partes importantes
    local partsToProcess = {
        character:FindFirstChild("Head"),
        character:FindFirstChild("Torso"),
        character:FindFirstChild("HumanoidRootPart"),
        character:FindFirstChild("UpperTorso"),
        character:FindFirstChild("LowerTorso")
    }

    for _, part in pairs(partsToProcess) do
        if part and part:IsA("BasePart") then
            if hitboxEnabled then
                -- Expandir hitbox
                if not originalSizes[part] then
                    originalSizes[part] = part.Size
                end
                part.Size = originalSizes[part] * hitboxExpansion
                part.CanCollide = false
                part.Transparency = 0.5
            else
                -- Restaurar tamaño original
                if originalSizes[part] then
                    part.Size = originalSizes[part]
                    part.CanCollide = true
                    part.Transparency = 0
                end
            end
        end
    end
end

-- ============================================================================
-- EVENTS (OPTIMIZED)
-- ============================================================================
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5) -- Esperar a que cargue completamente
        if hitboxEnabled then
            expandEnemyHitbox(character)
        end
    end)
end)

-- Loop optimizado con throttling
RunService.RenderStepped:Connect(function()
    local currentTime = tick()
    if currentTime - lastUpdate < updateInterval then return end
    lastUpdate = currentTime
    
    if not hitboxEnabled then return end
    
    -- Procesar solo jugadores activos
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            -- Solo procesar si está vivo
            if humanoid and humanoid.Health > 0 then
                expandEnemyHitbox(character)
            end
        end
    end
end)

-- ============================================================================
-- INITIALIZATION
-- ============================================================================
-- Procesar jugadores existentes
for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        task.spawn(function()
            task.wait(0.5)
            if hitboxEnabled then
                expandEnemyHitbox(player.Character)
            end
        end)
    end
end

-- Cargar script del juego si existe
if scripts[tostring(game.PlaceId)] and checkGame then
    load(tostring(game.PlaceId))
end

-- Crear GUI
createGUI()
