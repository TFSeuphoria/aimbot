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
end)
