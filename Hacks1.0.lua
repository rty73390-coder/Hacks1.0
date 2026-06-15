local player = game.Players.LocalPlayer
local enabledFling = false
local flying = false

local flySpeed = 100
local jumpPower = 150
local flingPower = 25000

local bodyVelocity = nil
local bodyGyro = nil

local function createFling()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = player.Character.HumanoidRootPart
    
    for _, part in pairs(player.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    local thrust = Instance.new("BodyThrust")
    thrust.Name = "FlingThrust"
    thrust.Parent = root
    thrust.Force = Vector3.new(flingPower, flingPower * 0.6, flingPower)
    thrust.Location = root.Position
end

local function removeFling()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local thrust = player.Character.HumanoidRootPart:FindFirstChild("FlingThrust")
        if thrust then thrust:Destroy() end
    end
end

local function startFly()
    if flying then return end
    flying = true
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local root = character.HumanoidRootPart
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then humanoid.PlatformStand = true end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FlyVelocity"
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = root
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "FlyGyro"
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.P = 12500
    bodyGyro.Parent = root
    
    spawn(function()
        while flying and character and character.Parent do
            local cam = workspace.CurrentCamera
            local moveDirection = Vector3.new(0, 0, 0)
            
            local uis = game:GetService("UserInputService")
            if uis:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + cam.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - cam.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - cam.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + cam.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
            if uis:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
            
            bodyVelocity.Velocity = moveDirection.Unit * flySpeed
            bodyGyro.CFrame = cam.CFrame
            game:GetService("RunService").Heartbeat:Wait()
        end
    end)
end

local function stopFly()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.PlatformStand = false
    end
end

local function superJump()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if humanoid and root then
        humanoid.JumpPower = jumpPower
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    local key = input.KeyCode
    
    if key == Enum.KeyCode.F then           -- F = Fling
        enabledFling = not enabledFling
        if enabledFling then
            createFling()
            print("Touch Fling ВКЛ")
        else
            removeFling()
            print("Touch Fling ВЫКЛ")
        end
        
    elseif key == Enum.KeyCode.G then       -- G = Fly
        if flying then
            stopFly()
            print("Полёт ВЫКЛ")
        else
            startFly()
            print("Полёт ВКЛ")
        end
        
    elseif key == Enum.KeyCode.LeftShift then -- Shift = Супер прыжок
        superJump()
        
    elseif key == Enum.KeyCode.Equals then  -- + = Увеличить скорость полёта
        flySpeed = flySpeed + 20
        print("Скорость полёта: " .. flySpeed)
        
    elseif key == Enum.KeyCode.Minus then   -- - = Уменьшить скорость полёта
        flySpeed = math.max(20, flySpeed - 20)
        print("Скорость полёта: " .. flySpeed)
    end
end)

player.CharacterAdded:Connect(function()
    wait(1.5)
    if enabledFling then createFling() end
    if flying then startFly() end
end)

print("Скрипт загружен")
print("   F — Вкл/Выкл Fling")
print("   G — Вкл/Выкл Полёт")
print("   Shift — Супер прыжок")
print("   + / - — Изменить скорость полёта")
