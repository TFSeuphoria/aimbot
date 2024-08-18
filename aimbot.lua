local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

local function getClosestEnemy()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Team ~= player.Team and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Head") then
            local distance = (otherPlayer.Character.Head.Position - player.Character.Head.Position).magnitude
            if distance < shortestDistance then
                closestPlayer = otherPlayer
                shortestDistance = distance
            end
        end
    end

    return closestPlayer
end

local function lockOntoTarget(target)
    if target and target.Character and target.Character:FindFirstChild("Head") then
        local head = target.Character.Head
        camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
    end
end

local function createESP(player)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = player.Character
    highlight.FillColor = Color3.fromRGB(139, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = player.Character
end

local function removeESP(player)
    if player.Character and player.Character:FindFirstChildOfClass("Highlight") then
        player.Character:FindFirstChildOfClass("Highlight"):Destroy()
    end
end

local function updateESP()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Team ~= player.Team and otherPlayer.Character then
            if not otherPlayer.Character:FindFirstChildOfClass("Highlight") then
                createESP(otherPlayer)
            end
        else
            removeESP(otherPlayer)
        end
    end
end

local tracking = false
local target = nil

mouse.Button2Down:Connect(function()
    target = getClosestEnemy()
    tracking = true
end)

mouse.Button2Up:Connect(function()
    tracking = false
end)

RunService.RenderStepped:Connect(function()
    if tracking and target then
        lockOntoTarget(target)
    end
    updateESP()
end)
