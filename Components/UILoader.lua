local Loader = {}

function Loader.Load(settings)
    settings = settings or {}
    local customTitle = settings.Title or "UI LIBRARY"
    local customSubtitle = settings.Subtitle or "Preparing interface..."
    local discordEnabled = settings.DiscordLink ~= nil
    local discordLink = settings.DiscordLink or "https://discord.gg/example"
    local youtubeEnabled = settings.YoutubeLink ~= nil
    local youtubeLink = settings.YoutubeLink or "https://youtube.com/@example"
    
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")

    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    if playerGui:FindFirstChild("UILoaderGui") then
        playerGui:FindFirstChild("UILoaderGui"):Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UILoaderGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting

    local blurTween = TweenService:Create(blur, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 24})
    blurTween:Play()

    local fullBg = Instance.new("Frame")
    fullBg.Name = "FullBackground"
    fullBg.Size = UDim2.new(1, 0, 1, 0)
    fullBg.Position = UDim2.new(0, 0, 0, 0)
    fullBg.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    fullBg.BackgroundTransparency = 1
    fullBg.BorderSizePixel = 0
    fullBg.ZIndex = 1
    fullBg.Parent = screenGui

    TweenService:Create(fullBg, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()

    local gridContainer = Instance.new("Frame")
    gridContainer.Name = "GridContainer"
    gridContainer.Size = UDim2.new(1, 0, 1, 0)
    gridContainer.BackgroundTransparency = 1
    gridContainer.ZIndex = 2
    gridContainer.Parent = screenGui

    for i = 1, 12 do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0, 1, 1, 0)
        line.Position = UDim2.new(i / 13, 0, 0, 0)
        line.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        line.BackgroundTransparency = 0.95
        line.BorderSizePixel = 0
        line.Parent = gridContainer
    end

    for i = 1, 8 do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, i / 9, 0)
        line.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        line.BackgroundTransparency = 0.95
        line.BorderSizePixel = 0
        line.Parent = gridContainer
    end

    local MAIN_CONTAINER_WIDTH = 1150
    local MAIN_CONTAINER_HEIGHT = 480
    local DOCK_HEIGHT = 70
    local DOCK_OFFSET = 8
    
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(0, MAIN_CONTAINER_WIDTH, 0, MAIN_CONTAINER_HEIGHT)
    mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    mainContainer.BackgroundTransparency = 1
    mainContainer.ZIndex = 4
    mainContainer.Parent = screenGui

    local uiScale = Instance.new("UIScale")
    uiScale.Parent = mainContainer
    
    local function updateScale()
        local screenSize = screenGui.AbsoluteSize
        local scaleX = screenSize.X / 1920
        local scaleY = screenSize.Y / 1080
        local scale = math.min(scaleX, scaleY, 1)
        uiScale.Scale = scale
    end
    
    updateScale()
    screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale)

    local dockContainer
    local iconSize = 50
    local iconSpacing = 12
    local totalIcons = (discordEnabled and 1 or 0) + (youtubeEnabled and 1 or 0)
    local dockWidth = (iconSize * totalIcons) + (iconSpacing * (totalIcons + 1))

    if discordEnabled or youtubeEnabled then
        dockContainer = Instance.new("Frame")
        dockContainer.Name = "DockContainer"
        
        dockContainer.Size = UDim2.new(0, 0, 0, 0)
        dockContainer.Position = UDim2.new(0.5, 0, 0.5, -(MAIN_CONTAINER_HEIGHT/2 + DOCK_HEIGHT/2 + DOCK_OFFSET))
        
        dockContainer.AnchorPoint = Vector2.new(0.5, 0.5)
        dockContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        dockContainer.BackgroundTransparency = 1
        dockContainer.BorderSizePixel = 0
        dockContainer.ZIndex = 10
        dockContainer.Parent = screenGui

        local dockCorner = Instance.new("UICorner")
        dockCorner.CornerRadius = UDim.new(0, 16)
        dockCorner.Parent = dockContainer

        local dockStroke = Instance.new("UIStroke")
        dockStroke.Color = Color3.fromRGB(35, 35, 45)
        dockStroke.Thickness = 1
        dockStroke.Transparency = 1
        dockStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        dockStroke.Parent = dockContainer

        local dockAccent = Instance.new("Frame")
        dockAccent.Name = "DockAccent"
        dockAccent.Size = UDim2.new(1, 0, 0, 2)
        dockAccent.Position = UDim2.new(0, 0, 0, 0)
        dockAccent.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
        dockAccent.BackgroundTransparency = 1
        dockAccent.BorderSizePixel = 0
        dockAccent.Parent = dockContainer

        local dockAccentCorner = Instance.new("UICorner")
        dockAccentCorner.CornerRadius = UDim.new(0, 16)
        dockAccentCorner.Parent = dockAccent

        local dockAccentGradient = Instance.new("UIGradient")
        dockAccentGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 120, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 80, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 120, 255))
        }
        dockAccentGradient.Parent = dockAccent

        local currentX = iconSpacing

        if discordEnabled then
            local discordButton = Instance.new("ImageButton")
            discordButton.Name = "DiscordButton"
            discordButton.Size = UDim2.new(0, iconSize, 0, iconSize)
            discordButton.Position = UDim2.new(0, currentX, 0.5, 0)
            discordButton.AnchorPoint = Vector2.new(0, 0.5)
            discordButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            discordButton.BackgroundTransparency = 1
            discordButton.BorderSizePixel = 0
            
            discordButton.Image = "rbxassetid://134745882888823"
            discordButton.ImageTransparency = 1
            
            discordButton.ScaleType = Enum.ScaleType.Fit
            discordButton.ZIndex = 11
            discordButton.Parent = dockContainer

            local discordCorner = Instance.new("UICorner")
            discordCorner.CornerRadius = UDim.new(0, 12)
            discordCorner.Parent = discordButton

            local discordStroke = Instance.new("UIStroke")
            discordStroke.Color = Color3.fromRGB(88, 101, 242)
            discordStroke.Thickness = 2
            discordStroke.Transparency = 1
            discordStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            discordStroke.Parent = discordButton

            discordButton.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(discordLink)
                end
                
                local originalSize = discordButton.Size
                TweenService:Create(discordButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, iconSize * 0.9, 0, iconSize * 0.9)
                }):Play()
                
                task.wait(0.1)
                TweenService:Create(discordButton, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = originalSize
                }):Play()
            end)

            discordButton.MouseEnter:Connect(function()
                TweenService:Create(discordButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, iconSize * 1.1, 0, iconSize * 1.1),
                    BackgroundColor3 = Color3.fromRGB(38, 38, 48)
                }):Play()
            end)

            discordButton.MouseLeave:Connect(function()
                TweenService:Create(discordButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, iconSize, 0, iconSize),
                    BackgroundColor3 = Color3.fromRGB(28, 28, 38)
                }):Play()
            end)

            currentX = currentX + iconSize + iconSpacing
        end

        if youtubeEnabled then
            local youtubeButton = Instance.new("ImageButton")
            youtubeButton.Name = "YoutubeButton"
            youtubeButton.Size = UDim2.new(0, iconSize, 0, iconSize)
            youtubeButton.Position = UDim2.new(0, currentX, 0.5, 0)
            youtubeButton.AnchorPoint = Vector2.new(0, 0.5)
            youtubeButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            youtubeButton.BackgroundTransparency = 1
            youtubeButton.BorderSizePixel = 0
            
            youtubeButton.Image = "rbxassetid://81575690017550"
            youtubeButton.ImageTransparency = 1
            
            youtubeButton.ScaleType = Enum.ScaleType.Fit
            youtubeButton.ZIndex = 11
            youtubeButton.Parent = dockContainer

            local youtubeCorner = Instance.new("UICorner")
            youtubeCorner.CornerRadius = UDim.new(0, 12)
            youtubeCorner.Parent = youtubeButton

            local youtubeStroke = Instance.new("UIStroke")
            youtubeStroke.Color = Color3.fromRGB(255, 0, 0)
            youtubeStroke.Thickness = 2
            youtubeStroke.Transparency = 1
            youtubeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            youtubeStroke.Parent = youtubeButton

            youtubeButton.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(youtubeLink)
                end
            
                local originalSize = youtubeButton.Size
                TweenService:Create(youtubeButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, iconSize * 0.9, 0, iconSize * 0.9)
                }):Play()
            
                task.wait(0.1)
                TweenService:Create(youtubeButton, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = originalSize
                }):Play()
            end)

            youtubeButton.MouseEnter:Connect(function()
                TweenService:Create(youtubeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, iconSize * 1.1, 0, iconSize * 1.1),
                    BackgroundColor3 = Color3.fromRGB(38, 38, 48)
                }):Play()
            end)

            youtubeButton.MouseLeave:Connect(function()
                TweenService:Create(youtubeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, iconSize, 0, iconSize),
                    BackgroundColor3 = Color3.fromRGB(28, 28, 38)
                }):Play()
            end)
        end
    end

    local infoFrame = Instance.new("Frame")
    infoFrame.Name = "InfoFrame"
    infoFrame.Size = UDim2.new(0, 280, 0, 480)
    infoFrame.Position = UDim2.new(0, 0, 0, 0)
    infoFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    infoFrame.BorderSizePixel = 0
    infoFrame.ClipsDescendants = false
    infoFrame.Parent = mainContainer

    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 20)
    infoCorner.Parent = infoFrame

    local infoStroke = Instance.new("UIStroke")
    infoStroke.Color = Color3.fromRGB(35, 35, 45)
    infoStroke.Thickness = 1
    infoStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    infoStroke.Parent = infoFrame

    local topAccent = Instance.new("Frame")
    topAccent.Name = "TopAccent"
    topAccent.Size = UDim2.new(1, 0, 0, 2)
    topAccent.Position = UDim2.new(0, 0, 0, 0)
    topAccent.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    topAccent.BorderSizePixel = 0
    topAccent.Parent = infoFrame

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 20)
    accentCorner.Parent = topAccent

    local accentGradient = Instance.new("UIGradient")
    accentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 120, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 80, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 120, 255))
    }
    accentGradient.Parent = topAccent

    local loaderLabel = Instance.new("TextLabel")
    loaderLabel.Name = "LoaderLabel"
    loaderLabel.Size = UDim2.new(1, -40, 0, 30)
    loaderLabel.Position = UDim2.new(0, 20, 0, 20)
    loaderLabel.BackgroundTransparency = 1
    loaderLabel.Text = "Loader"
    loaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    loaderLabel.TextSize = 14
    loaderLabel.Font = Enum.Font.GothamMedium
    loaderLabel.TextXAlignment = Enum.TextXAlignment.Left
    loaderLabel.TextTransparency = 1
    loaderLabel.Parent = infoFrame

    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, -40, 0, 1)
    divider.Position = UDim2.new(0, 20, 0, 55)
    divider.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    divider.BorderSizePixel = 0
    divider.Parent = infoFrame

    local viewportContainer = Instance.new("Frame")
    viewportContainer.Name = "ViewportContainer"
    viewportContainer.Size = UDim2.new(0, 220, 0, 220)
    viewportContainer.Position = UDim2.new(0.5, 0, 0, 80)
    viewportContainer.AnchorPoint = Vector2.new(0.5, 0)
    viewportContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    viewportContainer.BorderSizePixel = 0
    viewportContainer.Parent = infoFrame

    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 16)
    containerCorner.Parent = viewportContainer

    local containerStroke = Instance.new("UIStroke")
    containerStroke.Color = Color3.fromRGB(50, 50, 60)
    containerStroke.Thickness = 1
    containerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    containerStroke.Parent = viewportContainer

    local viewportFrame = Instance.new("ViewportFrame")
    viewportFrame.Name = "AvatarViewport"
    viewportFrame.Size = UDim2.new(1, 0, 1, 0)
    viewportFrame.BackgroundTransparency = 1
    viewportFrame.BorderSizePixel = 0
    viewportFrame.Parent = viewportContainer

    local camera = Instance.new("Camera")
    camera.Parent = viewportFrame
    viewportFrame.CurrentCamera = camera

    local worldModel = Instance.new("WorldModel")
    worldModel.Parent = viewportFrame

    local rigModel = nil
    local rotationConnection = nil

    local function setupCharacter()
        task.spawn(function()
            local character = player.Character or player.CharacterAdded:Wait()
            task.wait(0.3)

            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end

            local description = humanoid:GetAppliedDescription()
            if not description then return end

            local rig = Players:CreateHumanoidModelFromDescription(description, Enum.HumanoidRigType.R15)

            for _, obj in pairs(rig:GetDescendants()) do
                if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                    obj:Destroy()
                end
            end

            rig.Parent = worldModel
            rigModel = rig

            local hrp = rig:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Anchored = true
                local humRoot = rig:FindFirstChild("Humanoid") and rig:FindFirstChild("Humanoid").RootPart or hrp
                camera.CFrame = CFrame.new(humRoot.Position + Vector3.new(0, 1.2, 4.5), humRoot.Position + Vector3.new(0, 1.2, 0))

                rotationConnection = RunService.RenderStepped:Connect(function(dt)
                    if not rig or not rig.Parent then
                        if rotationConnection then
                            rotationConnection:Disconnect()
                        end
                        return
                    end
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(dt * 35), 0)
                end)
            end
        end)
    end

    setupCharacter()

    local infoContainer = Instance.new("Frame")
    infoContainer.Name = "InfoContainer"
    infoContainer.Size = UDim2.new(1, -40, 0, 120)
    infoContainer.Position = UDim2.new(0, 20, 0, 320)
    infoContainer.BackgroundTransparency = 1
    infoContainer.Parent = infoFrame

    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Name = "Username"
    usernameLabel.Size = UDim2.new(1, 0, 0, 28)
    usernameLabel.Position = UDim2.new(0, 0, 0, 0)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Text = player.Name
    usernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    usernameLabel.TextSize = 18
    usernameLabel.Font = Enum.Font.GothamBold
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    usernameLabel.TextTransparency = 1
    usernameLabel.TextScaled = true
    usernameLabel.Parent = infoContainer

    local usernameConstraint = Instance.new("UITextSizeConstraint")
    usernameConstraint.MaxTextSize = 18
    usernameConstraint.Parent = usernameLabel

    local userIdLabel = Instance.new("TextLabel")
    userIdLabel.Name = "UserId"
    userIdLabel.Size = UDim2.new(1, 0, 0, 24)
    userIdLabel.Position = UDim2.new(0, 0, 0, 32)
    userIdLabel.BackgroundTransparency = 1
    userIdLabel.Text = "ID: " .. tostring(player.UserId)
    userIdLabel.TextColor3 = Color3.fromRGB(130, 130, 145)
    userIdLabel.TextSize = 14
    userIdLabel.Font = Enum.Font.Gotham
    userIdLabel.TextXAlignment = Enum.TextXAlignment.Left
    userIdLabel.TextTransparency = 1
    userIdLabel.TextScaled = true
    userIdLabel.Parent = infoContainer

    local userIdConstraint = Instance.new("UITextSizeConstraint")
    userIdConstraint.MaxTextSize = 14
    userIdConstraint.Parent = userIdLabel

    local executorName = "Unknown"
    if identifyexecutor then
        executorName = identifyexecutor()
    elseif KRNL_LOADED then
        executorName = "KRNL"
    elseif syn then
        executorName = "Synapse X"
    elseif SENTINEL_V2 then
        executorName = "Sentinel"
    end

    local executorLabel = Instance.new("TextLabel")
    executorLabel.Name = "Executor"
    executorLabel.Size = UDim2.new(1, 0, 0, 24)
    executorLabel.Position = UDim2.new(0, 0, 0, 60)
    executorLabel.BackgroundTransparency = 1
    executorLabel.Text = "Executor: " .. executorName
    executorLabel.TextColor3 = Color3.fromRGB(80, 120, 255)
    executorLabel.TextSize = 14
    executorLabel.Font = Enum.Font.GothamMedium
    executorLabel.TextXAlignment = Enum.TextXAlignment.Left
    executorLabel.TextTransparency = 1
    executorLabel.TextScaled = true
    executorLabel.Parent = infoContainer

    local executorConstraint = Instance.new("UITextSizeConstraint")
    executorConstraint.MaxTextSize = 14
    executorConstraint.Parent = executorLabel

    local statusContainer = Instance.new("Frame")
    statusContainer.Name = "StatusContainer"
    statusContainer.Size = UDim2.new(1, -40, 0, 24)
    statusContainer.Position = UDim2.new(0, 20, 1, -44)
    statusContainer.BackgroundTransparency = 1
    statusContainer.Parent = infoFrame

    local statusIndicator = Instance.new("Frame")
    statusIndicator.Name = "StatusIndicator"
    statusIndicator.Size = UDim2.new(0, 8, 0, 8)
    statusIndicator.Position = UDim2.new(0, 0, 0.5, -4)
    statusIndicator.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
    statusIndicator.BorderSizePixel = 0
    statusIndicator.Parent = statusContainer

    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = statusIndicator

    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -16, 1, 0)
    statusText.Position = UDim2.new(0, 16, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Online"
    statusText.TextColor3 = Color3.fromRGB(130, 130, 145)
    statusText.TextSize = 13
    statusText.Font = Enum.Font.Gotham
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextTransparency = 1
    statusText.Parent = statusContainer

    local loadingFrame = Instance.new("Frame")
    loadingFrame.Name = "LoadingFrame"
    loadingFrame.Size = UDim2.new(0, 650, 0, 480)
    loadingFrame.Position = UDim2.new(0, 290, 0, 0)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    loadingFrame.BorderSizePixel = 0
    loadingFrame.ClipsDescendants = true
    loadingFrame.Parent = mainContainer

    local loadingCorner = Instance.new("UICorner")
    loadingCorner.CornerRadius = UDim.new(0, 20)
    loadingCorner.Parent = loadingFrame

    local loadingStroke = Instance.new("UIStroke")
    loadingStroke.Color = Color3.fromRGB(35, 35, 45)
    loadingStroke.Thickness = 1
    loadingStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    loadingStroke.Parent = loadingFrame

    local loadingAccent = Instance.new("Frame")
    loadingAccent.Name = "LoadingAccent"
    loadingAccent.Size = UDim2.new(1, 0, 0, 2)
    loadingAccent.Position = UDim2.new(0, 0, 0, 0)
    loadingAccent.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    loadingAccent.BorderSizePixel = 0
    loadingAccent.ZIndex = 3
    loadingAccent.Parent = loadingFrame

    local loadingAccentCorner = Instance.new("UICorner")
    loadingAccentCorner.CornerRadius = UDim.new(0, 20)
    loadingAccentCorner.Parent = loadingAccent

    local loadingAccentGradient = Instance.new("UIGradient")
    loadingAccentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 120, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 80, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 120, 255))
    }
    loadingAccentGradient.Parent = loadingAccent

    local dynamicBg1 = Instance.new("Frame")
    dynamicBg1.Name = "DynamicBg1"
    dynamicBg1.Size = UDim2.new(1.5, 0, 1.5, 0)
    dynamicBg1.Position = UDim2.new(-0.25, 0, -0.25, 0)
    dynamicBg1.BackgroundTransparency = 0.7
    dynamicBg1.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    dynamicBg1.BorderSizePixel = 0
    dynamicBg1.ZIndex = 1
    dynamicBg1.Parent = loadingFrame

    local gradient1 = Instance.new("UIGradient")
    gradient1.Rotation = 45
    gradient1.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 120, 255)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(140, 80, 255)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 80, 140)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 120, 255))
    }
    gradient1.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.95),
        NumberSequenceKeypoint.new(0.5, 0.85),
        NumberSequenceKeypoint.new(1, 0.95)
    }
    gradient1.Parent = dynamicBg1

    local dynamicBg2 = Instance.new("Frame")
    dynamicBg2.Name = "DynamicBg2"
    dynamicBg2.Size = UDim2.new(1.5, 0, 1.5, 0)
    dynamicBg2.Position = UDim2.new(-0.25, 0, -0.25, 0)
    dynamicBg2.BackgroundTransparency = 0.8
    dynamicBg2.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    dynamicBg2.BorderSizePixel = 0
    dynamicBg2.ZIndex = 1
    dynamicBg2.Parent = loadingFrame

    local gradient2 = Instance.new("UIGradient")
    gradient2.Rotation = -30
    gradient2.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 80))
    }
    gradient2.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.5, 0.75),
        NumberSequenceKeypoint.new(1, 0.9)
    }
    gradient2.Parent = dynamicBg2

    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 2
    contentFrame.Parent = loadingFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -60, 0, 50)
    titleLabel.Position = UDim2.new(0, 30, 0, 60)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = customTitle
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 38
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTransparency = 1
    titleLabel.TextScaled = true
    titleLabel.Parent = contentFrame

    local titleConstraint = Instance.new("UITextSizeConstraint")
    titleConstraint.MaxTextSize = 38
    titleConstraint.Parent = titleLabel

    local titleGlow = Instance.new("UIStroke")
    titleGlow.Color = Color3.fromRGB(80, 120, 255)
    titleGlow.Thickness = 0
    titleGlow.Transparency = 0.3
    titleGlow.Parent = titleLabel

    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Name = "Subtitle"
    subtitleLabel.Size = UDim2.new(1, -60, 0, 28)
    subtitleLabel.Position = UDim2.new(0, 30, 0, 115)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = customSubtitle
    subtitleLabel.TextColor3 = Color3.fromRGB(130, 130, 145)
    subtitleLabel.TextSize = 15
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.TextTransparency = 1
    subtitleLabel.TextScaled = true
    subtitleLabel.Parent = contentFrame

    local subtitleConstraint = Instance.new("UITextSizeConstraint")
    subtitleConstraint.MaxTextSize = 15
    subtitleConstraint.Parent = subtitleLabel

    local progressContainer = Instance.new("Frame")
    progressContainer.Name = "ProgressContainer"
    progressContainer.Size = UDim2.new(1, -60, 0, 8)
    progressContainer.Position = UDim2.new(0, 30, 0, 260)
    progressContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    progressContainer.BorderSizePixel = 0
    progressContainer.Parent = contentFrame

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(1, 0)
    progressCorner.Parent = progressContainer

    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressContainer

    local progressBarCorner = Instance.new("UICorner")
    progressBarCorner.CornerRadius = UDim.new(1, 0)
    progressBarCorner.Parent = progressBar

    local progressGradient = Instance.new("UIGradient")
    progressGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 120, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 80, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 120, 255))
    }
    progressGradient.Parent = progressBar

    local progressGlow = Instance.new("Frame")
    progressGlow.Name = "ProgressGlow"
    progressGlow.Size = UDim2.new(0, 60, 1, 8)
    progressGlow.Position = UDim2.new(1, -30, 0, -4)
    progressGlow.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    progressGlow.BackgroundTransparency = 0.8
    progressGlow.BorderSizePixel = 0
    progressGlow.Parent = progressBar

    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(1, 0)
    glowCorner.Parent = progressGlow

    local glowGradient = Instance.new("UIGradient")
    glowGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    }
    glowGradient.Parent = progressGlow

    local percentLabel = Instance.new("TextLabel")
    percentLabel.Name = "Percent"
    percentLabel.Size = UDim2.new(1, -60, 0, 32)
    percentLabel.Position = UDim2.new(0, 30, 0, 280)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Text = "0%"
    percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    percentLabel.TextSize = 22
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.TextXAlignment = Enum.TextXAlignment.Left
    percentLabel.TextTransparency = 1
    percentLabel.TextScaled = true
    percentLabel.Parent = contentFrame

    local percentConstraint = Instance.new("UITextSizeConstraint")
    percentConstraint.MaxTextSize = 22
    percentConstraint.Parent = percentLabel

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "Status"
    statusLabel.Size = UDim2.new(1, -60, 0, 24)
    statusLabel.Position = UDim2.new(0, 30, 1, -60)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Initializing..."
    statusLabel.TextColor3 = Color3.fromRGB(80, 120, 255)
    statusLabel.TextSize = 13
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.TextTransparency = 1
    statusLabel.TextScaled = true
    statusLabel.Parent = contentFrame

    local statusConstraint = Instance.new("UITextSizeConstraint")
    statusConstraint.MaxTextSize = 13
    statusConstraint.Parent = statusLabel

    local brandFrame = Instance.new("Frame")
    brandFrame.Name = "BrandFrame"
    brandFrame.Size = UDim2.new(0, 200, 0, 480)
    brandFrame.Position = UDim2.new(0, 950, 0, 0)
    brandFrame.BackgroundColor3 = Color3.fromRGB(255, 120, 180)
    brandFrame.BorderSizePixel = 0
    brandFrame.ClipsDescendants = true
    brandFrame.Parent = mainContainer

    local brandCorner = Instance.new("UICorner")
    brandCorner.CornerRadius = UDim.new(0, 20)
    brandCorner.Parent = brandFrame

    local brandStroke = Instance.new("UIStroke")
    brandStroke.Color = Color3.fromRGB(255, 170, 210)
    brandStroke.Thickness = 1
    brandStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    brandStroke.Parent = brandFrame

    local brandAccent = Instance.new("Frame")
    brandAccent.Name = "BrandAccent"
    brandAccent.Size = UDim2.new(1, 0, 0, 2)
    brandAccent.Position = UDim2.new(0, 0, 0, 0)
    brandAccent.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    brandAccent.BorderSizePixel = 0
    brandAccent.ZIndex = 3
    brandAccent.Parent = brandFrame

    local brandAccentCorner = Instance.new("UICorner")
    brandAccentCorner.CornerRadius = UDim.new(0, 20)
    brandAccentCorner.Parent = brandAccent

    local brandAccentGradient = Instance.new("UIGradient")
    brandAccentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 120, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 80, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 120, 255))
    }
    brandAccentGradient.Parent = brandAccent

    local brandGradient = Instance.new("UIGradient")
    brandGradient.Rotation = 45
    brandGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 180)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 150, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 180))
    }
    brandGradient.Parent = brandFrame

    local logoImage = Instance.new("ImageLabel")
    logoImage.Name = "LogoImage"
    logoImage.Size = UDim2.new(0, 160, 0, 160)
    logoImage.Position = UDim2.new(0.5, 0, 0, 120)
    logoImage.AnchorPoint = Vector2.new(0.5, 0)
    logoImage.BackgroundTransparency = 1
    logoImage.Image = "rbxassetid://125073427434619"
    logoImage.ScaleType = Enum.ScaleType.Fit
    logoImage.ImageTransparency = 1
    logoImage.Parent = brandFrame

    local brandText = Instance.new("TextLabel")
    brandText.Name = "BrandText"
    brandText.Size = UDim2.new(1, -40, 0, 80)
    brandText.Position = UDim2.new(0, 20, 1, -120)
    brandText.BackgroundTransparency = 1
    brandText.Text = "UI Brought to you by\nLumaHub"
    brandText.TextColor3 = Color3.fromRGB(255, 255, 255)
    brandText.TextSize = 16
    brandText.Font = Enum.Font.GothamBold
    brandText.TextXAlignment = Enum.TextXAlignment.Center
    brandText.TextYAlignment = Enum.TextYAlignment.Center
    brandText.TextTransparency = 1
    brandText.TextScaled = true
    brandText.Parent = brandFrame

    local brandTextConstraint = Instance.new("UITextSizeConstraint")
    brandTextConstraint.MaxTextSize = 16
    brandTextConstraint.Parent = brandText

    local brandTextStroke = Instance.new("UIStroke")
    brandTextStroke.Color = Color3.fromRGB(220, 80, 150)
    brandTextStroke.Thickness = 2
    brandTextStroke.Transparency = 1
    brandTextStroke.Parent = brandText

    -- SYNCHRONIZED ENTRANCE ANIMATIONS
    mainContainer.Position = UDim2.new(0.5, 0, 0.5, 50)
    mainContainer.Size = UDim2.new(0, MAIN_CONTAINER_WIDTH, 0, 0)

    local entranceTweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    
    local mainEntranceTween = TweenService:Create(mainContainer, entranceTweenInfo, {
        Size = UDim2.new(0, MAIN_CONTAINER_WIDTH, 0, MAIN_CONTAINER_HEIGHT),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    
    mainEntranceTween:Play()

    if dockContainer then
        local dockEnterGoal = {
            Size = UDim2.new(0, dockWidth, 0, DOCK_HEIGHT),
            Position = UDim2.new(0.5, 0, 0.5, -(MAIN_CONTAINER_HEIGHT/2 + DOCK_HEIGHT/2 + DOCK_OFFSET)),
            BackgroundTransparency = 0
        }
        
        local dockTween = TweenService:Create(dockContainer, entranceTweenInfo, dockEnterGoal)
        dockTween:Play()
        
        task.wait(0.5)
        local dockFadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        for _, child in pairs(dockContainer:GetDescendants()) do
            if child:IsA("UIStroke") then
                TweenService:Create(child, dockFadeInfo, {Transparency = 0}):Play()
            elseif child:IsA("Frame") and child.Name == "DockAccent" then
                TweenService:Create(child, dockFadeInfo, {BackgroundTransparency = 0}):Play()
            elseif child:IsA("ImageButton") then
                TweenService:Create(child, dockFadeInfo, {
                    BackgroundTransparency = 0,
                    ImageTransparency = 0
                }):Play()
            end
        end
    end

    task.wait(0.3)

    local fadeElements = {
        loaderLabel, usernameLabel, userIdLabel, executorLabel, statusText,
        titleLabel, subtitleLabel, percentLabel, statusLabel, logoImage, brandText
    }

    for i, element in ipairs(fadeElements) do
        task.spawn(function()
            task.wait(i * 0.05)
            if element:IsA("TextLabel") then
                TweenService:Create(element, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
                if element == brandText then
                    TweenService:Create(brandTextStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0}):Play()
                end
            elseif element:IsA("ImageLabel") then
                TweenService:Create(element, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
            end
        end)
    end

    task.wait(0.3)
    TweenService:Create(titleGlow, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Thickness = 2}):Play()

    local pulseConnection
    pulseConnection = RunService.RenderStepped:Connect(function()
        local pulse = (math.sin(tick() * 4) + 1) / 2
        statusIndicator.BackgroundColor3 = Color3.fromRGB(
            60 + pulse * 40,
            200 + pulse * 55,
            100 + pulse * 40
        )
    end)

    local gradientRotation = 0
    local gradient1Rotation = 0
    local gradient2Rotation = 0
    local dockGradientRotation = 0
    local accentGradientRotation = 0
    local gradientConnection
    gradientConnection = RunService.RenderStepped:Connect(function(dt)
        accentGradientRotation = accentGradientRotation + (dt * 30)
        accentGradient.Rotation = accentGradientRotation
        progressGradient.Rotation = accentGradientRotation
        loadingAccentGradient.Rotation = accentGradientRotation
        brandAccentGradient.Rotation = accentGradientRotation

        if dockContainer then
            for _, child in pairs(dockContainer:GetChildren()) do
                if child.Name == "DockAccent" then
                    for _, gradient in pairs(child:GetChildren()) do
                        if gradient:IsA("UIGradient") then
                            gradient.Rotation = accentGradientRotation
                        end
                    end
                end
            end
        end

        gradient1Rotation = gradient1Rotation + (dt * 20)
        gradient1.Rotation = gradient1Rotation
        
        gradient2Rotation = gradient2Rotation - (dt * 15)
        gradient2.Rotation = gradient2Rotation

        local offsetX = math.sin(tick() * 0.4) * 0.1
        local offsetY = math.cos(tick() * 0.3) * 0.1
        dynamicBg1.Position = UDim2.new(-0.25 + offsetX, 0, -0.25 + offsetY, 0)
        
        local offset2X = math.cos(tick() * 0.5) * 0.15
        local offset2Y = math.sin(tick() * 0.6) * 0.12
        dynamicBg2.Position = UDim2.new(-0.25 + offset2X, 0, -0.25 + offset2Y, 0)

        brandGradient.Rotation = brandGradient.Rotation + (dt * 25)
    end)

    local loadingSteps = {
        {progress = 15, duration = 1.0, status = "Connecting to services...", subtitle = "Establishing connection..."},
        {progress = 28, duration = 1.2, status = "Loading UI components...", subtitle = "Preparing interface..."},
        {progress = 45, duration = 1.4, status = "Initializing modules...", subtitle = "Setting up core systems..."},
        {progress = 62, duration = 1.0, status = "Loading assets...", subtitle = "Fetching resources..."},
        {progress = 78, duration = 1.4, status = "Configuring settings...", subtitle = "Applying preferences..."},
        {progress = 92, duration = 1.2, status = "Finalizing setup...", subtitle = "Almost ready..."},
        {progress = 100, duration = 0.8, status = "Complete!", subtitle = "Welcome to LumaHub"}
    }

    local function updateProgress(newProgress, duration)
        local tweenInfo = TweenInfo.new(duration * 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {Size = UDim2.new(newProgress / 100, 0, 1, 0)}
        local progressTween = TweenService:Create(progressBar, tweenInfo, goal)
        progressTween:Play()
        
        local currentProgress = 0
        local startTime = tick()
        local progressUpdateConnection
        progressUpdateConnection = RunService.RenderStepped:Connect(function()
            local elapsed = tick() - startTime
            local alpha = math.min(elapsed / (duration * 0.8), 1)
            currentProgress = math.floor(currentProgress + (newProgress - currentProgress) * alpha)
            percentLabel.Text = currentProgress .. "%"
            
            if alpha >= 1 then
                percentLabel.Text = newProgress .. "%"
                progressUpdateConnection:Disconnect()
            end
        end)
        
        return progressTween
    end

    local function animateLoading()
        task.wait(1.0)

        for i, step in ipairs(loadingSteps) do
            local stepDuration = step.duration
            local postTweenWait = stepDuration * 0.2

            local fadeOutInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(statusLabel, fadeOutInfo, {TextTransparency = 1}):Play()
            TweenService:Create(subtitleLabel, fadeOutInfo, {TextTransparency = 1}):Play()

            task.wait(0.2)

            statusLabel.Text = step.status
            subtitleLabel.Text = step.subtitle

            local fadeInInfo = TweenService:Create(statusLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
            fadeInInfo:Play()
            TweenService:Create(subtitleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

            local progressTween = updateProgress(step.progress, stepDuration)
            progressTween.Completed:Wait()

            task.wait(postTweenWait)

            if step.progress == 100 then
                task.wait(0.8)

                if pulseConnection then pulseConnection:Disconnect() end
                if gradientConnection then gradientConnection:Disconnect() end
                if rotationConnection then rotationConnection:Disconnect() end

                local fadeOutInfoFinal = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                TweenService:Create(fullBg, fadeOutInfoFinal, {BackgroundTransparency = 1}):Play()
                
                for _, line in pairs(gridContainer:GetChildren()) do
                    if line:IsA("Frame") then
                        TweenService:Create(line, fadeOutInfoFinal, {BackgroundTransparency = 1}):Play()
                    end
                end

                if rigModel then
                    for _, part in pairs(rigModel:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("Decal") then
                            TweenService:Create(part, fadeOutInfoFinal, {Transparency = 1}):Play()
                        end
                    end
                end

                local allChildren = mainContainer:GetDescendants()
                if dockContainer then
                    local dockChildren = dockContainer:GetDescendants()
                    for _, child in pairs(dockChildren) do
                        table.insert(allChildren, child)
                    end
                    table.insert(allChildren, dockContainer)
                end

                for _, obj in pairs(allChildren) do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                        TweenService:Create(obj, fadeOutInfoFinal, {TextTransparency = 1}):Play()
                    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                        TweenService:Create(obj, fadeOutInfoFinal, {ImageTransparency = 1}):Play()
                    elseif obj:IsA("Frame") and obj ~= fullBg and obj.Parent ~= screenGui then 
                        TweenService:Create(obj, fadeOutInfoFinal, {BackgroundTransparency = 1}):Play()
                    elseif obj:IsA("UIStroke") then
                        TweenService:Create(obj, fadeOutInfoFinal, {Transparency = 1}):Play()
                    end
                end

                local exitTweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)
                
                local collapseTween = TweenService:Create(mainContainer, exitTweenInfo, {
                    Size = UDim2.new(0, MAIN_CONTAINER_WIDTH, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 50)
                })

                if dockContainer then
                    local dockExitGoal = {
                        Size = UDim2.new(0, 0, 0, 0),
                        Position = UDim2.new(0.5, 0, 0.5, -(MAIN_CONTAINER_HEIGHT/2 + DOCK_OFFSET + 100))
                    }
                    TweenService:Create(dockContainer, exitTweenInfo, dockExitGoal):Play()
                end

                local blurOut = TweenService:Create(blur, fadeOutInfoFinal, {Size = 0})

                collapseTween:Play()
                blurOut:Play()

                collapseTween.Completed:Wait()

                if blur.Parent then
                    blur:Destroy()
                end

                screenGui:Destroy()

                break
            end
        end
    end

    task.spawn(animateLoading)
end

return Loader
