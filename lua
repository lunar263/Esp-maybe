local function illuminateTarget(targetCharacter, duration, color, intensity)
  local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
  if targetRootPart then
    local originalTransparency = targetRootPart.Transparency
    local effectTime = 0

    local function updateTime()
      effectTime += task.wait()
      if effectTime < duration then
        local transparencyMod = math.sin(effectTime * math.pi / duration) * intensity
        targetRootPart.Transparency = 1 - transparencyMod
        targetRootPart.Material.Diffuse = color * transparencyMod
        task.delay(0.01, updateTime)
      else
        targetRootPart.Transparency = originalTransparency
        targetRootPart.Material.Diffuse = targetRootPart.Material.DiffuseOriginal
      end
    end

    task.delay(0.1, updateTime)
  end
end

local function identifyOpponents(localPlayer, isTeamBased)
  local opponents = {}
  for _, player in ipairs(game.Players:GetPlayers()) do
    if player ~= localPlayer and player.Character then
      if not isTeamBased or (isTeamBased and player.Team ~= localPlayer.Team) then
        table.insert(opponents, player.Character)
      end
    end
  end
  return opponents
end

local function initiatePulse(localPlayer, isTeamBased, illuminationColor, illuminationIntensity)
  local character = localPlayer.Character
  if character then
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
      local enemies = identifyOpponents(localPlayer, isTeamBased)
      for _, enemy in ipairs(enemies) do
        local rootPart = enemy:FindFirstChild("HumanoidRootPart")
        if rootPart then
          local distance = (character.HumanoidRootPart.Position - rootPart.Position).Magnitude
          if distance < 25 then
            illuminateTarget(enemy, 5, illuminationColor, illuminationIntensity)
          end
        end
      end
    end
  end
end

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
  character.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "HumanoidRootPart" then
      -- Customizable illumination (color, intensity)
      local illuminationColor = Color3.fromRGB(255, 0, 0) -- Replace with desired color
      local illuminationIntensity = 0.75 -- Adjust for preferred intensity
      initiatePulse(localPlayer, false, illuminationColor, illuminationIntensity) -- Team-based illumination can be enabled here by passing true to the second argument
    end
  end)
end)
