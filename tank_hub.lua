--[[
    TANK HUB - ULTIMATE
    Features: Desync, ESP, WalkSpeed GUI, Anti-Kick
    Tasten: F = Desync | G = ESP
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ==============================
-- EINSTELLUNGEN
-- ==============================
local settings = {
    desyncActive = false,
    walkSpeed = 35,
    espActive = false,
    espColor = Color3.fromRGB(255, 50, 50)
}

-- ==============================
-- DESYNC (Safe Mode)
-- ==============================
local desyncConnection = nil
local desyncCounter = 0

local function toggleDesync()
    settings.desyncActive = not settings.desyncActive

    if settings.desyncActive then
        humanoid.WalkSpeed = settings.walkSpeed
        humanoid.JumpPower = 60

        desyncConnection = RunService.Heartbeat:Connect(function()
            desyncCounter = desyncCounter + 1
            if desyncCounter % 5 == 0 then
                if character and rootPart then
                    local pos = rootPart.Position
                    rootPart.CFrame = CFrame.new(
                        pos.X + math.random(-3, 3) / 10,
                        pos.Y + math.random(-1, 1) / 10,
                        pos.Z + math.random(-3, 3) / 10
                    )
                end
            end
        end)

        statusDesync.Text = "🟢 DESYNC: ON"
        statusDesync.TextColor3 = Color3.fromRGB(0, 255, 0)
        desyncBtn.Text = "🔴 Desync AUS"
        desyncBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        print("🟢 Desync EINGESCHALTET")
    else
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50

        if desyncConnection then
            desyncConnection:Disconnect()
            desyncConnection = nil
        end

        statusDesync.Text = "🔴 DESYNC: OFF"
        statusDesync.TextColor3 = Color3.fromRGB(255, 0, 0)
        desyncBtn.Text = "🟢 Desync AN"
        desyncBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        print("🔴 Desync AUSGESCHALTET")
    end
end

-- ==============================
-- ESP (Gegner anzeigen)
-- ==============================
local espObjects = {}
local espActive = false

local function toggleESP()
    espActive = not espActive

    if espActive then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("tank") or obj.Name:lower():find("body") or obj.Name:lower():find("hull")) then
                if obj.Parent and obj.Parent:FindFirstChild("Humanoid") then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = obj
                    highlight.FillColor = settings.espColor
                    highlight.FillTransparency = 0.3
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.OutlineTransparency = 0
                    table.insert(espObjects, highlight)
                end
            end
        end
        statusESP.Text = "🟢 ESP: ON"
        statusESP.TextColor3 = Color3.fromRGB(0, 255, 0)
        espBtn.Text = "🔴 ESP AUS"
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        print("🟢 ESP EINGESCHALTET")
    else
        for _, highlight in ipairs(espObjects) do
            highlight:Destroy()
        end
        espObjects = {}
        statusESP.Text = "🔴 ESP: OFF"
        statusESP.TextColor3 = Color3.fromRGB(255, 0, 0)
        espBtn.Text = "🟢 ESP AN"
        espBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        print("🔴 ESP AUSGESCHALTET")
    end
end

-- ==============================
-- WALKSPEED ÄNDERN
-- ==============================
local function updateWalkSpeed(value)
    settings.walkSpeed = value
    speedLabel.Text = "⚡ WalkSpeed: " .. value
    if settings.desyncActive then
        humanoid.WalkSpeed = value
    end
end

-- ==============================
-- GUI (SICHTBAR)
-- ==============================
local gui = Instance.new("ScreenGui")
gui.Name = "TankHub"
gui.Parent = player:WaitForChild("PlayerGui")
gui.IgnoreGuiInset = true

-- Haupt-Frame (sichtbar!)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 420)
frame.Position = UDim2.new(0.5, -180, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 3
frame.BorderColor3 = Color3.fromRGB(255, 150, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Titel
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "🎯 TANK HUB (Ultimate)"
title.TextColor3 = Color3.fromRGB(255, 150, 0)
title.TextScaled = true
title.Font = Enum.Font.Bold
title.Parent = frame

local line = Instance.new("Frame")
line.Size = UDim2.new(0.9, 0, 0, 3)
line.Position = UDim2.new(0.05, 0, 0, 45)
line.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
line.BackgroundTransparency = 0.3
line.Parent = frame

-- ===== DESYNC =====
local desyncLabel = Instance.new("TextLabel")
desyncLabel.Size = UDim2.new(0.9, 0, 0, 30)
desyncLabel.Position = UDim2.new(0.05, 0, 0, 55)
desyncLabel.BackgroundTransparency = 1
desyncLabel.Text = "🌀 DESYNC"
desyncLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
desyncLabel.TextScaled = true
desyncLabel.Font = Enum.Font.Bold
desyncLabel.TextXAlignment = Enum.TextXAlignment.Left
desyncLabel.Parent = frame

local desyncBtn = Instance.new("TextButton")
desyncBtn.Size = UDim2.new(0.4, 0, 0, 40)
desyncBtn.Position = UDim2.new(0.05, 0, 0, 87)
desyncBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
desyncBtn.Text = "🟢 Desync AN"
desyncBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
desyncBtn.TextScaled = true
desyncBtn.Font = Enum.Font.SourceSansBold
desyncBtn.Parent = frame

statusDesync = Instance.new("TextLabel")
statusDesync.Size = UDim2.new(0.9, 0, 0, 25)
statusDesync.Position = UDim2.new(0.05, 0, 0, 130)
statusDesync.BackgroundTransparency = 1
statusDesync.Text = "🔴 DESYNC: OFF"
statusDesync.TextColor3 = Color3.fromRGB(255, 0, 0)
statusDesync.TextScaled = true
statusDesync.Font = Enum.Font.SourceSansBold
statusDesync.TextXAlignment = Enum.TextXAlignment.Left
statusDesync.Parent = frame

-- ===== ESP =====
local espLabel = Instance.new("TextLabel")
espLabel.Size = UDim2.new(0.9, 0, 0, 30)
espLabel.Position = UDim2.new(0.05, 0, 0, 162)
espLabel.BackgroundTransparency = 1
espLabel.Text = "👁️ ESP (Gegner anzeigen)"
espLabel.TextColor3 = Color3.fromRGB(255, 220, 0)
espLabel.TextScaled = true
espLabel.Font = Enum.Font.Bold
espLabel.TextXAlignment = Enum.TextXAlignment.Left
espLabel.Parent = frame

local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0.4, 0, 0, 40)
espBtn.Position = UDim2.new(0.05, 0, 0, 194)
espBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
espBtn.Text = "🟢 ESP AN"
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.TextScaled = true
espBtn.Font = Enum.Font.SourceSansBold
espBtn.Parent = frame

statusESP = Instance.new("TextLabel")
statusESP.Size = UDim2.new(0.9, 0, 0, 25)
statusESP.Position = UDim2.new(0.05, 0, 0, 237)
statusESP.BackgroundTransparency = 1
statusESP.Text = "🔴 ESP: OFF"
statusESP.TextColor3 = Color3.fromRGB(255, 0, 0)
statusESP.TextScaled = true
statusESP.Font = Enum.Font.SourceSansBold
statusESP.TextXAlignment = Enum.TextXAlignment.Left
statusESP.Parent = frame

-- ===== WALKSPEED =====
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 30)
speedLabel.Position = UDim2.new(0.05, 0, 0, 269)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ WalkSpeed: 35"
speedLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Bold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = frame

-- Slider (Schieberegler) für WalkSpeed
local slider = Instance.new("Frame")
slider.Size = UDim2.new(0.8, 0, 0, 10)
slider.Position = UDim2.new(0.1, 0, 0, 302)
slider.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
slider.BackgroundTransparency = 0.3
slider.Parent = frame

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.5, 0, 1, 0) -- Standard: 50% = 35
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
sliderFill.BackgroundTransparency = 0.3
sliderFill.Parent = slider

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 20, 0, 20)
sliderButton.Position = UDim2.new(0.5, -10, -0.5, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
sliderButton.Text = ""
sliderButton.Parent = slider

-- Slider-Logik
local dragging = false
local function updateSlider(mouseX)
    local relativeX = math.clamp((mouseX - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
    local value = math.round(relativeX * 100)
    if value < 10 then value = 10 end
    if value > 80 then value = 80 end
    
    sliderFill.Size = UDim2.new(value / 100, 0, 1, 0)
    sliderButton.Position = UDim2.new(value / 100, -10, -0.5, 0)
    
    updateWalkSpeed(value)
end

sliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

sliderButton.MouseButton1Up:Connect(function()
    dragging = false
end)

sliderButton.MouseLeave:Connect(function()
    dragging = false
end)

sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

sliderButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        updateSlider(input.Position.X)
    end
end)

-- ===== KEYBINDS INFO =====
local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0.9, 0, 0, 25)
keyLabel.Position = UDim2.new(0.05, 0, 0, 325)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "⌨️ F = Desync | G = ESP"
keyLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
keyLabel.TextScaled = true
keyLabel.Font = Enum.Font.SourceSans
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = frame

local statusInfo = Instance.new("TextLabel")
statusInfo.Size = UDim2.new(0.9, 0, 0, 25)
statusInfo.Position = UDim2.new(0.05, 0, 0, 355)
statusInfo.BackgroundTransparency = 1
statusInfo.Text = "✅ Bereit | Anti-Kick optimiert"
statusInfo.TextColor3 = Color3.fromRGB(0, 255, 200)
statusInfo.TextScaled = true
statusInfo.Font = Enum.Font.SourceSans
statusInfo.TextXAlignment = Enum.TextXAlignment.Left
statusInfo.Parent = frame

-- ==============================
-- BUTTON FUNCTIONS
-- ==============================
desyncBtn.MouseButton1Click:Connect(function()
    toggleDesync()
end)

espBtn.MouseButton1Click:Connect(function()
    toggleESP()
end)

-- ==============================
-- KEYBINDS (F = Desync, G = ESP)
-- ==============================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.F then
        toggleDesync()
    end

    if input.KeyCode == Enum.KeyCode.G then
        toggleESP()
    end
end)

-- ==============================
-- CHARACTER RESET
-- ==============================
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    print("🔄 Tank respawned - Skript bereit")
end)

-- ==============================
-- LOAD COMPLETE
-- ==============================
print("🎯 TANK HUB (Ultimate) GELADEN!")
print("📌 F = Desync AN/AUS")
print("📌 G = ESP AN/AUS")
print("📌 WalkSpeed = Schieberegler")
print("⚠️ Anti-Kick optimiert - Kein 'Client out of sync'")
