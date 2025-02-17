local Stamp = game.ReplicatedStorage.BuildingBridge.Stamp

function findPlot(n)
    for _, v in pairs(workspace.BuildingAreas:GetChildren()) do
        if v.Player.Value == n then
            return v.PlayerArea
        end
    end
    return nil
end

-- Get the player's plot baseplate position
local Base = findPlot(game.Players.LocalPlayer.Name).BasePlate
local basePosition = Base.Position -- Center of the plot

-- Function to place a block in a **spherical pattern** from bottom to top
function placeBlockInSphere(id, radius, numBlocks, yOffset)
    local blocksPlaced = 0
    local phiIncrement = math.pi * (3 - math.sqrt(5)) -- Golden angle approximation for even distribution
    for i = 0, numBlocks - 1 do
        -- Calculate spherical coordinates
        local y = -1 + (i / (numBlocks - 1)) * 2 -- Y ranges from -1 to 1 (bottom to top)
        local radiusAtY = math.sqrt(1 - y * y) * radius -- Radius at given Y height
        local theta = phiIncrement * i -- Angle around the Z-axis

        local x = basePosition.X + radiusAtY * math.cos(theta)
        local z = basePosition.Z + radiusAtY * math.sin(theta)
        local yPos = basePosition.Y + y * radius + yOffset -- Adjusted Y with offset

        -- Place block at the calculated position
        local placementPosition = Vector3.new(x, yPos, z)
        task.spawn(function()
        	Stamp:InvokeServer(id, CFrame.new(placementPosition))
        end)
        blocksPlaced = blocksPlaced + 1
    end
end

-- **Usage Example**:
placeBlockInSphere(_G.SID, _G.SRadius, _G.SBCount, _G.SY) -- ID, Radius, Block Count, Y-Offset
