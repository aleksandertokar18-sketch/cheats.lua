-- Steal A Brainrot Ultimate Cheats v1.0 (Anti-Detect)
-- Autor: ExpertDev | Stealth Mode ON

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Anti-Detect (Obfuscation + Hook)
getgenv()._G.AntiDetect = true
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" and tostring(self) == "MainEvent" then
        return -- Block suspicious remotes
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- Core Features
getgenv().Cheats = {
    GodMode = true,
    InfiniteJump = false,
    SpeedHack = 50,
    NoClip = false,
    ESP = true,
    FullBright = true,
    AutoSteal = false,
    TeleportToPlayers = false,
    KillAura = false
}

-- God Mode + Never Die (Anti Knife/Gun/Death)
local function GodMode()
    Humanoid.MaxHealth = math.huge
    Humanoid.Health = math.huge
    
    -- Block all damage types
    Humanoid.HealthChanged:Connect(function(health)
        if health < Humanoid.MaxHealth then
            Humanoid.Health = Humanoid.MaxHealth
        end
    end)
    
    -- No respawn
    LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid").MaxHealth = math.huge
        char:WaitForChild("Humanoid").Health = math.huge
    end)
end

-- Speed Hack
local function SpeedHack()
    local speed = getgenv().Cheats.SpeedHack
    Humanoid.WalkSpeed = speed
end

-- NoClip
local function NoClip()
    local noclip = getgenv().Cheats.NoClip
    for _, part in pairs(Character:GetChildren()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = not noclip
        end
    end
end

-- ESP (Widzisz wszystkich graczy + items)
local function ESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local highlight = player.Character.Head:FindFirstChild("ESPHighlight")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.Parent = player.Character
            end
        end
    end
end

-- Auto Steal Brains (Główny exploit gry)
local function AutoSteal()
    spawn(function()
        while getgenv().Cheats.AutoSteal do
            -- Szukaj brainrot items w workspace
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj.Name:lower():find("brain") or obj.Name:lower():find("item") then
                    -- Teleport do itemu
                    RootPart.CFrame = obj.CFrame * CFrame.new(0, 5, 0)
                    wait(0.1)
                    -- Symuluj pickup (fire remote)
                    pcall(function()
                        ReplicatedStorage.Remotes:FindFirstChild("PickupEvent"):FireServer(obj)
                    end)
                end
            end
            wait(0.01)
        end
    end)
end

-- Kill Aura (Zabijaj blisko graczy)
local function KillAura()
    spawn(function()
        while getgenv().Cheats.KillAura do
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (RootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance < 15 then
                        -- Zabij gracza (symuluj damage)
                        pcall(function()
                            ReplicatedStorage.Remotes:FindFirstChild("DamageEvent"):FireServer(player.Character.Humanoid)
                        end)
                    end
                end
            end
            wait(0.1)
        end
    end)
end

-- FullBright
local function FullBright()
    game.Lighting.Brightness = 3
    game.Lighting.ClockTime = 14
    game.Lighting.FogEnd = 100000
    game.Lighting.GlobalShadows = false
end

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if getgenv().Cheats.InfiniteJump then
        RootPart.Velocity = Vector3.new(0, 50, 0)
    end
end)

-- Main Loop
RunService.Heartbeat:Connect(function()
    GodMode()
    SpeedHack()
    NoClip()
    if getgenv().Cheats.ESP then ESP() end
end)

RunService.Stepped:Connect(NoClip)

-- GUI (Insert = Toggle)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Steal A Brainrot Cheats", "DarkTheme")

local MainTab = Window:NewTab("Main Cheats")
local PlayerSection = MainTab:NewSection("Player")
local CombatSection = MainTab:NewSection("Combat")
local VisualSection = MainTab:NewSection("Visuals")
local MiscSection = MainTab:NewSection("Misc")

-- Player
PlayerSection:NewSlider("Speed", "Zmień prędkość", 500, 16, function(s)
    getgenv().Cheats.SpeedHack = s
end)

PlayerSection:NewToggle("NoClip", "Przechodź przez ściany", function(state)
    getgenv().Cheats.NoClip = state
end)

PlayerSection:NewToggle("Infinite Jump", "Nieskończone skoki", function(state)
    getgenv().Cheats.InfiniteJump = state
end)

-- Combat
CombatSection:NewToggle("God Mode", "Nieśmiertelność (Zawsze ON)", function(state)
    getgenv().Cheats.GodMode = state
end)

CombatSection:NewToggle("Kill Aura", "Automatycznie zabijaj graczy", function(state)
    getgenv().Cheats.KillAura = state
end)

-- Visuals
VisualSection:NewToggle("ESP Players", "Podświetl graczy", function(state)
    getgenv().Cheats.ESP = state
end)

VisualSection:NewToggle("FullBright", "Jasne oświetlenie", function(state)
    getgenv().Cheats.FullBright = state
    if state then FullBright() end
end)

-- Misc (Auto Farm)
MiscSection:NewToggle("Auto Steal Brains", "Automatycznie zbieraj przedmioty", function(state)
    getgenv().Cheats.AutoSteal = state
    if state then AutoSteal() end
end)

MiscSection:NewButton("Teleport do najbliższego gracza", "TP do gracza", function()
    local closest, dist = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local d = (RootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                closest = player
                dist = d
            end
        end
    end
    if closest then
        RootPart.CFrame = closest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
    end
end)

print("🧠 Steal A Brainrot Cheats LOADED! | Insert = GUI")
