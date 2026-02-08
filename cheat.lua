local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

getgenv().Cheats = {
    GodMode = true, InfiniteJump = false, SpeedHack = 50, NoClip = false,
    ESP = true, FullBright = true, AutoSteal = false, KillAura = false
}

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if method == "FireServer" and tostring(self) == "MainEvent" then return end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

local function GodMode()
    Humanoid.MaxHealth = math.huge
    Humanoid.Health = math.huge
    Humanoid.HealthChanged:Connect(function(health)
        if health < Humanoid.MaxHealth then Humanoid.Health = Humanoid.MaxHealth end
    end)
    LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid").MaxHealth = math.huge
        char:WaitForChild("Humanoid").Health = math.huge
    end)
end

local function SpeedHack() Humanoid.WalkSpeed = getgenv().Cheats.SpeedHack end
local function NoClip()
    for _, part in pairs(Character:GetChildren()) do
        if part:IsA("BasePart") and part.CanCollide then part.CanCollide = not getgenv().Cheats.NoClip end
    end
end

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

local function AutoSteal()
    spawn(function()
        while getgenv().Cheats.AutoSteal do
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj.Name:lower():find("brain") or obj.Name:lower():find("item") then
                    RootPart.CFrame = obj.CFrame * CFrame.new(0, 5, 0)
                    wait(0.1)
                    pcall(function() ReplicatedStorage.Remotes:FindFirstChild("PickupEvent"):FireServer(obj) end)
                end
            end
            wait(0.01)
        end
    end)
end

local function KillAura()
    spawn(function()
        while getgenv().Cheats.KillAura do
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (RootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance < 15 then
                        pcall(function() ReplicatedStorage.Remotes:FindFirstChild("DamageEvent"):FireServer(player.Character.Humanoid) end)
                    end
                end
            end
            wait(0.1)
        end
    end)
end

local function FullBright()
    game.Lighting.Brightness = 3
    game.Lighting.ClockTime = 14
    game.Lighting.FogEnd = 100000
    game.Lighting.GlobalShadows = false
end

UserInputService.JumpRequest:Connect(function()
    if getgenv().Cheats.InfiniteJump then RootPart.Velocity = Vector3.new(0, 50, 0) end
end)

RunService.Heartbeat:Connect(function()
    GodMode()
    SpeedHack()
    NoClip()
    if getgenv().Cheats.ESP then ESP() end
end)

RunService.Stepped:Connect(NoClip)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Steal A Brainrot", "DarkTheme")

local MainTab = Window:NewTab("Main")
local PlayerSection = MainTab:NewSection("Player")
local CombatSection = MainTab:NewSection("Combat")
local VisualSection = MainTab:NewSection("Visuals")
local MiscSection = MainTab:NewSection("Misc")

PlayerSection:NewSlider("Speed", "Speed", 500, 16, function(s) getgenv().Cheats.SpeedHack = s end)
PlayerSection:NewToggle("NoClip", "NoClip", function(state) getgenv().Cheats.NoClip = state end)
PlayerSection:NewToggle("Infinite Jump", "Infinite Jump", function(state) getgenv().Cheats.InfiniteJump = state end)

CombatSection:NewToggle("God Mode", "God Mode", function(state) getgenv().Cheats.GodMode = state end)
CombatSection:NewToggle("Kill Aura", "Kill Aura", function(state) getgenv().Cheats.KillAura = state end)

VisualSection:NewToggle("ESP", "ESP Players", function(state) getgenv().Cheats.ESP = state end)
VisualSection:NewToggle("FullBright", "FullBright", function(state)
    getgenv().Cheats.FullBright = state
    if state then FullBright() end
end)

MiscSection:NewToggle("Auto Steal", "Auto Steal Brains", function(state)
    getgenv().Cheats.AutoSteal = state
    if state then AutoSteal() end
end)

MiscSection:NewButton("TP Nearest Player", "Teleport", function()
    local closest, dist = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local d = (RootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then closest = player dist = d end
        end
    end
    if closest then RootPart.CFrame = closest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0) end
end)

getgenv().ToggleKeybind = Enum.KeyCode.Insert

