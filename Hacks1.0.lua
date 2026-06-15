local player = game.Players.LocalPlayer
local enabledFling = false
local flying = false
local power = 25000
local flySpeed = 100

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
    thrust.Force = Vector3.new(power, power * 0.6, power)
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
            
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + cam.CFrame.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - cam.CFrame.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - cam.CFrame.RightVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + cam.CFrame.RightVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
            
            bodyVelocity.Velocity = moveDirection.Unit * flySpeed
            bodyGyro.CFrame = cam.CFrame
            wait()
        end
    end)
end

local function stopFly()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.PlatformStand = false
    end
end

-- ====================== ТОГГЛЫ ======================
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    
    if input.KeyCode == Enum.KeyCode.F then        -- F = Toggle Fling
        enabledFling = not enabledFling
        if enabledFling then
            createFling()
            print("Touch Fling ВКЛ")
        else
            removeFling()
            print("Touch Fling ВЫКЛ")
        end
        
    elseif input.KeyCode == Enum.KeyCode.G then    -- G = Toggle Fly
        if flying then
            stopFly()
            print("Полёт ВЫКЛ")
        else
            startFly()
            print("Полёт ВКЛ")
        end
    end
end)

-- Автообновление при респавне
player.CharacterAdded:Connect(function()
    wait(1.5)
    if enabledFling then createFling() end
    if flying then startFly() end
end)

print("🎮 Touch Fling + Fly загружен!")
print("   F — Вкл/Выкл Fling")
print("   G — Вкл/Выкл Полёт")
