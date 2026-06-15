-- Простой Mobile Touch Fling + Fly (без сложного GUI)

local player = game.Players.LocalPlayer
local enabledFling = false
local flying = false
local flySpeed = 80

print("=== Скрипт загружается... ===")

-- Ждём загрузку персонажа
player.CharacterAdded:Connect(function() wait(1) end)
if player.Character == nil then
    player.CharacterAdded:Wait()
end

wait(1.5)

-- ====================== FLING ======================
local function createFling()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    local thrust = Instance.new("BodyThrust")
    thrust.Name = "FlingThrust"
    thrust.Force = Vector3.new(30000, 16000, 30000)
    thrust.Parent = root
    
    print("Fling ВКЛ — касайся игроков")
end

local function removeFling()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local t = root:FindFirstChild("FlingThrust")
        if t then t:Destroy() end
    end
    print("Fling ВЫКЛ")
end

-- ====================== FLY ======================
local bodyVelocity, bodyGyro = nil, nil

local function startFly()
    if flying then return end
    flying = true
    
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if hum then hum.PlatformStand = true end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(99999,99999,99999)
    bodyVelocity.Parent = root
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(99999,99999,99999)
    bodyGyro.P = 12500
    bodyGyro.Parent = root
    
    print("Полёт ВКЛ — тяни пальцем по экрану")
end

local function stopFly()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then hum.PlatformStand = false end
    print("Полёт ВЫКЛ")
end

-- ====================== Touch Controls ======================
local UIS = game:GetService("UserInputService")
local lastTouch = nil

UIS.TouchStarted:Connect(function(touch)
    lastTouch = touch.Position
end)

UIS.TouchMoved:Connect(function(touch)
    if not flying then return end
    local delta = (touch.Position - lastTouch)
    lastTouch = touch.Position
    
    local cam = workspace.CurrentCamera
    local moveDir = (cam.CFrame.RightVector * delta.X + cam.CFrame.LookVector * -delta.Y) * 0.6
    
    if bodyVelocity then
        bodyVelocity.Velocity = moveDir.Unit * flySpeed
    end
end)

UIS.TouchEnded:Connect(function()
    lastTouch = nil
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, 15, 0)
    end
end)

-- Кнопки через чат (для теста)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Fling + Fly";
    Text = "Напиши в чат: fling / fly / jump";
    Duration = 10;
})

game.Players.LocalPlayer.Chatted:Connect(function(msg)
    msg = msg:lower()
    if msg == "fling" then
        enabledFling = not enabledFling
        if enabledFling then createFling() else removeFling() end
    elseif msg == "fly" then
        if flying then stopFly() else startFly() end
    elseif msg == "jump" then
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then
            hum.JumpPower = 120
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    elseif msg == "speed" then
        flySpeed = flySpeed + 20
        print("Скорость:", flySpeed)
    end
end)

print("✅ Скрипт загружен!")
print("Команды в чат:")
print("   fling  → вкл/выкл флинг")
print("   fly    → вкл/выкл полёт")
print("   jump   → супер прыжок")
print("   speed  → увеличить скорость")
