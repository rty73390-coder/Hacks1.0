local player = game.Players.LocalPlayer
local enabledFling = false
local flying = false
local flySpeed = 80

local bodyVelocity = nil
local bodyGyro = nil
local touchConnection = nil

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileFlingFly"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 280)
Frame.Position = UDim2.new(1, -320, 0.5, -140)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Title.Text = "📱 Touch Fling + Fly"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0, 55)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(0, 255, 100)
Status.Text = "Готово к использованию"
Status.TextScaled = true
Status.Font = Enum.Font.Gotham
Status.Parent = Frame

local function createBtn(text, y, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
