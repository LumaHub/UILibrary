local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

-- ///////////////////////////////////////////////////////////
-- //                 PART 1: THE LOADER                    //
-- //      (Original consistent UI with callback added)     //
-- ///////////////////////////////////////////////////////////

local Loader = {}

function Loader.Load(settings)
    settings = settings or {}
    local customTitle = settings.Title or "UI LIBRARY"
    local customSubtitle = settings.Subtitle or "Preparing interface..."
    local discordEnabled = settings.DiscordLink ~= nil
    local discordLink = settings.DiscordLink or "https://discord.gg/example"
    local youtubeEnabled = settings.YoutubeLink ~= nil
    local youtubeLink = settings.YoutubeLink or "https://youtube.com/@example"
    local onComplete = settings.Callback or function() end
    
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
    local DOCK_OFFSET = 20
    
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
        uiScale.Scale = math.max(scale, 0.6) 
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
        dockContainer.BorderSizePixel = 0
        dockContainer.ZIndex = 10
        dockContainer.Parent = screenGui

        local dockCorner = Instance.new("UICorner")
        dockCorner.CornerRadius = UDim.new(0, 16)
        dockCorner.Parent = dockContainer

        local dockStroke = Instance.new("UIStroke")
        dockStroke.Color = Color3.fromRGB(35, 35, 45)
        dockStroke.Thickness = 1
        dockStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        dockStroke.Parent = dockContainer

        local dockAccent = Instance.new("Frame")
        dockAccent.Name = "DockAccent"
        dockAccent.Size = UDim2.new(1, 0, 0, 2)
        dockAccent.Position = UDim2.new(0, 0, 0, 0)
        dockAccent.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
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
            discordButton.BorderSizePixel = 0
            discordButton.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png" 
            discordButton.ScaleType = Enum.ScaleType.Fit
            discordButton.ZIndex = 11
            discordButton.Parent = dockContainer

            local discordCorner = Instance.new("UICorner")
            discordCorner.CornerRadius = UDim.new(0, 12)
            discordCorner.Parent = discordButton

            local discordStroke = Instance.new("UIStroke")
            discordStroke.Color = Color3.fromRGB(88, 101, 242)
            discordStroke.Thickness = 2
            discordStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            discordStroke.Parent = discordButton

            local discordText = Instance.new("TextLabel")
            discordText.Size = UDim2.new(1, 0, 1, 0)
            discordText.BackgroundTransparency = 1
            discordText.Text = "DC"
            discordText.TextColor3 = Color3.fromRGB(88, 101, 242)
            discordText.TextSize = 20
            discordText.Font = Enum.Font.GothamBold
            discordText.Parent = discordButton

            discordButton.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(discordLink)
                end
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
            youtubeButton.BorderSizePixel = 0
            youtubeButton.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
            youtubeButton.ScaleType = Enum.ScaleType.Fit
            youtubeButton.ZIndex = 11
            youtubeButton.Parent = dockContainer

            local youtubeCorner = Instance.new("UICorner")
            youtubeCorner.CornerRadius = UDim.new(0, 12)
            youtubeCorner.Parent = youtubeButton

            local youtubeStroke = Instance.new("UIStroke")
            youtubeStroke.Color = Color3.fromRGB(255, 0, 0)
            youtubeStroke.Thickness = 2
            youtubeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            youtubeStroke.Parent = youtubeButton

            local youtubeText = Instance.new("TextLabel")
            youtubeText.Size = UDim2.new(1, 0, 1, 0)
            youtubeText.BackgroundTransparency = 1
            youtubeText.Text = "YT"
            youtubeText.TextColor3 = Color3.fromRGB(255, 0, 0)
            youtubeText.TextSize = 20
            youtubeText.Font = Enum.Font.GothamBold
            youtubeText.Parent = youtubeButton

            youtubeButton.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(youtubeLink)
                end
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
                        if rotationConnection then rotationConnection:Disconnect() end
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

    local executorLabel = Instance.new("TextLabel")
    executorLabel.Name = "Executor"
    executorLabel.Size = UDim2.new(1, 0, 0, 24)
    executorLabel.Position = UDim2.new(0, 0, 0, 60)
    executorLabel.BackgroundTransparency = 1
    executorLabel.Text = "Executor: Unknown"
    executorLabel.TextColor3 = Color3.fromRGB(80, 120, 255)
    executorLabel.TextSize = 14
    executorLabel.Font = Enum.Font.GothamMedium
    executorLabel.TextXAlignment = Enum.TextXAlignment.Left
    executorLabel.TextTransparency = 1
    executorLabel.TextScaled = true
    executorLabel.Parent = infoContainer

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

    local brandTextStroke = Instance.new("UIStroke")
    brandTextStroke.Color = Color3.fromRGB(220, 80, 150)
    brandTextStroke.Thickness = 2
    brandTextStroke.Transparency = 1
    brandTextStroke.Parent = brandText

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
            Position = UDim2.new(0.5, 0, 0.5, -(MAIN_CONTAINER_HEIGHT/2 + DOCK_HEIGHT/2 + DOCK_OFFSET))
        }
        local dockTween = TweenService:Create(dockContainer, entranceTweenInfo, dockEnterGoal)
        dockTween:Play()
    end

    task.wait(0.3)

    local fadeElements = {
        loaderLabel, usernameLabel, userIdLabel, executorLabel, statusText,
        titleLabel, subtitleLabel, percentLabel, statusLabel, brandText
    }

    for i, element in ipairs(fadeElements) do
        task.spawn(function()
            task.wait(i * 0.05)
            if element:IsA("TextLabel") then
                TweenService:Create(element, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
                if element == brandText then
                    TweenService:Create(brandTextStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0}):Play()
                end
            end
        end)
    end

    task.wait(0.3)
    TweenService:Create(titleGlow, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Thickness = 2}):Play()

    local pulseConnection
    pulseConnection = RunService.RenderStepped:Connect(function()
        local pulse = (math.sin(tick() * 4) + 1) / 2
        statusIndicator.BackgroundColor3 = Color3.fromRGB(60 + pulse * 40, 200 + pulse * 55, 100 + pulse * 40)
    end)

    local gradientRotation = 0
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
                        if gradient:IsA("UIGradient") then gradient.Rotation = accentGradientRotation end
                    end
                end
            end
        end

        local offsetX = math.sin(tick() * 0.4) * 0.1
        local offsetY = math.cos(tick() * 0.3) * 0.1
        dynamicBg1.Position = UDim2.new(-0.25 + offsetX, 0, -0.25 + offsetY, 0)
        
        brandGradient.Rotation = brandGradient.Rotation + (dt * 25)
    end)

    local loadingSteps = {
        {progress = 15, duration = 0.5, status = "Connecting to services...", subtitle = "Establishing connection..."},
        {progress = 30, duration = 0.5, status = "Loading UI components...", subtitle = "Preparing interface..."},
        {progress = 50, duration = 0.5, status = "Initializing modules...", subtitle = "Setting up core systems..."},
        {progress = 75, duration = 0.5, status = "Configuring settings...", subtitle = "Applying preferences..."},
        {progress = 100, duration = 0.5, status = "Complete!", subtitle = "Welcome to LumaHub"}
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
        task.wait(0.5)
        for _, step in ipairs(loadingSteps) do
            statusLabel.Text = step.status
            subtitleLabel.Text = step.subtitle
            local progressTween = updateProgress(step.progress, step.duration)
            progressTween.Completed:Wait()
        end
        
        task.wait(0.5)

        if pulseConnection then pulseConnection:Disconnect() end
        if gradientConnection then gradientConnection:Disconnect() end
        if rotationConnection then rotationConnection:Disconnect() end

        local fadeOutInfoFinal = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(fullBg, fadeOutInfoFinal, {BackgroundTransparency = 1}):Play()
        TweenService:Create(mainContainer, fadeOutInfoFinal, {BackgroundTransparency = 1}):Play()
        
        if dockContainer then
            TweenService:Create(dockContainer, fadeOutInfoFinal, {BackgroundTransparency = 1}):Play()
        end

        TweenService:Create(blur, fadeOutInfoFinal, {Size = 0}):Play()
        task.wait(0.5)
        
        if blur.Parent then blur:Destroy() end
        screenGui:Destroy()
        
        onComplete()
    end

    task.spawn(animateLoading)
end


-- ///////////////////////////////////////////////////////////
-- //                 PART 2: THE LIBRARY                   //
-- //     (Fixed MainFrame with themes + mobile support)    //
-- ///////////////////////////////////////////////////////////

local Library = {}
Library.__index = Library

function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "UI Library"
    local windowTheme = config.Theme or "Dark"
    local keybind = config.Keybind or Enum.KeyCode.RightControl
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Notifications = {}
    
    local Themes = {
        Dark = {Background = Color3.fromRGB(20, 20, 25), Secondary = Color3.fromRGB(25, 25, 30), Tertiary = Color3.fromRGB(30, 30, 35), Accent = Color3.fromRGB(88, 101, 242), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(160, 160, 170), Border = Color3.fromRGB(45, 45, 50)},
        OLED = {Background = Color3.fromRGB(0, 0, 0), Secondary = Color3.fromRGB(10, 10, 10), Tertiary = Color3.fromRGB(15, 15, 15), Accent = Color3.fromRGB(255, 255, 255), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(180, 180, 180), Border = Color3.fromRGB(30, 30, 30)},
        Grey = {Background = Color3.fromRGB(45, 45, 45), Secondary = Color3.fromRGB(55, 55, 55), Tertiary = Color3.fromRGB(65, 65, 65), Accent = Color3.fromRGB(180, 180, 180), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(200, 200, 200), Border = Color3.fromRGB(80, 80, 80)},
        BlossomPink = {Background = Color3.fromRGB(255, 240, 245), Secondary = Color3.fromRGB(255, 228, 225), Tertiary = Color3.fromRGB(255, 218, 225), Accent = Color3.fromRGB(255, 105, 180), Text = Color3.fromRGB(80, 40, 60), SubText = Color3.fromRGB(120, 80, 100), Border = Color3.fromRGB(255, 182, 193)},
        DarkPink = {Background = Color3.fromRGB(30, 20, 25), Secondary = Color3.fromRGB(40, 25, 35), Tertiary = Color3.fromRGB(50, 30, 40), Accent = Color3.fromRGB(255, 20, 147), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(200, 150, 180), Border = Color3.fromRGB(80, 40, 60)},
        CrimsonRed = {Background = Color3.fromRGB(25, 10, 10), Secondary = Color3.fromRGB(35, 15, 15), Tertiary = Color3.fromRGB(45, 20, 20), Accent = Color3.fromRGB(220, 20, 60), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(200, 150, 150), Border = Color3.fromRGB(80, 30, 30)},
        DarkRed = {Background = Color3.fromRGB(20, 5, 5), Secondary = Color3.fromRGB(30, 10, 10), Tertiary = Color3.fromRGB(40, 15, 15), Accent = Color3.fromRGB(139, 0, 0), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(180, 130, 130), Border = Color3.fromRGB(60, 20, 20)},
        Green = {Background = Color3.fromRGB(15, 25, 15), Secondary = Color3.fromRGB(20, 35, 20), Tertiary = Color3.fromRGB(25, 45, 25), Accent = Color3.fromRGB(0, 200, 80), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(150, 200, 150), Border = Color3.fromRGB(30, 60, 30)},
        Ocean = {Background = Color3.fromRGB(10, 15, 25), Secondary = Color3.fromRGB(15, 22, 35), Tertiary = Color3.fromRGB(20, 28, 42), Accent = Color3.fromRGB(0, 150, 255), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(140, 180, 220), Border = Color3.fromRGB(30, 50, 80)},
        Blue = {Background = Color3.fromRGB(10, 10, 30), Secondary = Color3.fromRGB(15, 15, 40), Tertiary = Color3.fromRGB(20, 20, 50), Accent = Color3.fromRGB(50, 80, 255), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(150, 150, 220), Border = Color3.fromRGB(30, 30, 80)},
        Purple = {Background = Color3.fromRGB(20, 10, 30), Secondary = Color3.fromRGB(30, 15, 40), Tertiary = Color3.fromRGB(40, 20, 50), Accent = Color3.fromRGB(160, 50, 255), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(200, 150, 255), Border = Color3.fromRGB(60, 30, 80)},
        Midnight = {Background = Color3.fromRGB(8, 8, 15), Secondary = Color3.fromRGB(12, 12, 22), Tertiary = Color3.fromRGB(18, 18, 30), Accent = Color3.fromRGB(100, 100, 255), Text = Color3.fromRGB(220, 220, 255), SubText = Color3.fromRGB(120, 120, 160), Border = Color3.fromRGB(25, 25, 40)},
        Forest = {Background = Color3.fromRGB(10, 20, 10), Secondary = Color3.fromRGB(15, 25, 15), Tertiary = Color3.fromRGB(20, 30, 20), Accent = Color3.fromRGB(34, 139, 34), Text = Color3.fromRGB(230, 255, 230), SubText = Color3.fromRGB(150, 180, 150), Border = Color3.fromRGB(20, 50, 20)},
        Sunset = {Background = Color3.fromRGB(30, 15, 10), Secondary = Color3.fromRGB(40, 20, 15), Tertiary = Color3.fromRGB(50, 25, 20), Accent = Color3.fromRGB(255, 140, 0), Text = Color3.fromRGB(255, 240, 230), SubText = Color3.fromRGB(200, 160, 140), Border = Color3.fromRGB(80, 40, 20)},
        Void = {Background = Color3.fromRGB(5, 5, 5), Secondary = Color3.fromRGB(10, 10, 10), Tertiary = Color3.fromRGB(15, 15, 15), Accent = Color3.fromRGB(120, 0, 255), Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(100, 100, 100), Border = Color3.fromRGB(20, 20, 20)}
    }
    
    Window.Theme = Themes[windowTheme] or Themes.Dark
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LumaHubUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 700, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainFrame.BackgroundColor3 = Window.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Mobile Responsive Logic
    local function UpdateScale()
        if UserInputService.TouchEnabled then
            if ScreenGui.AbsoluteSize.X < 800 then
                MainFrame.Size = UDim2.new(0, ScreenGui.AbsoluteSize.X * 0.9, 0, ScreenGui.AbsoluteSize.Y * 0.7)
                MainFrame.Position = UDim2.new(0.5, -(ScreenGui.AbsoluteSize.X * 0.9)/2, 0.5, -(ScreenGui.AbsoluteSize.Y * 0.7)/2)
            else
                MainFrame.Size = UDim2.new(0, 700, 0, 500)
                MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
            end
        end
    end
    ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateScale)
    UpdateScale()

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Window.Theme.Border
    MainStroke.Thickness = 1
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Window.Theme.Secondary
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar
    
    local TopBarAccent = Instance.new("Frame")
    TopBarAccent.Name = "Accent"
    TopBarAccent.Size = UDim2.new(1, 0, 0, 2)
    TopBarAccent.Position = UDim2.new(0, 0, 1, -2)
    TopBarAccent.BackgroundColor3 = Window.Theme.Accent
    TopBarAccent.BorderSizePixel = 0
    TopBarAccent.Parent = TopBar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 300, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = windowName
    Title.TextColor3 = Window.Theme.Text
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -45, 0, 5)
    CloseButton.BackgroundColor3 = Window.Theme.Tertiary
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Window.Theme.Text
    CloseButton.TextSize = 24
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0,0,0,0)}):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    -- Draggable
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Mobile Toggle
    if UserInputService.TouchEnabled then
        local toggleBtn = Instance.new("ImageButton")
        toggleBtn.Size = UDim2.new(0, 50, 0, 50)
        toggleBtn.Position = UDim2.new(0.8, 0, 0.1, 0)
        toggleBtn.BackgroundColor3 = Window.Theme.Accent
        toggleBtn.Image = "rbxassetid://100583949363345" -- UI Icon
        toggleBtn.Parent = ScreenGui
        local tc = Instance.new("UICorner")
        tc.CornerRadius = UDim.new(1,0)
        tc.Parent = toggleBtn
        toggleBtn.MouseButton1Click:Connect(function()
            MainFrame.Visible = not MainFrame.Visible
        end)
    end
    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 150, 1, -50)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.BackgroundColor3 = Window.Theme.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 2
    TabContainer.Parent = MainFrame
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.Parent = TabContainer
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -150, 1, -50)
    ContentContainer.Position = UDim2.new(0, 150, 0, 50)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == keybind then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or "📄"
        
        local Tab = {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Window.Theme.Tertiary
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -10, 1, 0)
        TabLabel.Position = UDim2.new(0, 10, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabIcon .. " " .. tabName
        TabLabel.TextColor3 = Window.Theme.SubText
        TabLabel.TextSize = 14
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, -20, 1, -20)
        TabContent.Position = UDim2.new(0, 10, 0, 10)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Window.Theme.Accent
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local TabContentList = Instance.new("UIListLayout")
        TabContentList.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentList.Padding = UDim.new(0, 10)
        TabContentList.Parent = TabContent
        
        TabContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentList.AbsoluteContentSize.Y + 10)
        end)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                TweenService:Create(tab.Button, TweenInfo.new(0.2), {BackgroundColor3 = Window.Theme.Tertiary}):Play()
                tab.Label.TextColor3 = Window.Theme.SubText
            end
            TabContent.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Window.Theme.Accent}):Play()
            TabLabel.TextColor3 = Window.Theme.Text
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.Label = TabLabel
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            TabButton.MouseButton1Click:Fire()
        end
        
        function Tab:CreateSection(sectionName)
            local Section = Instance.new("Frame")
            Section.Size = UDim2.new(1, 0, 0, 30)
            Section.BackgroundColor3 = Window.Theme.Secondary
            Section.Parent = TabContent
            local sc = Instance.new("UICorner")
            sc.CornerRadius = UDim.new(0,8)
            sc.Parent = Section
            local sl = Instance.new("TextLabel")
            sl.Size = UDim2.new(1,-20,1,0)
            sl.Position = UDim2.new(0,10,0,0)
            sl.BackgroundTransparency = 1
            sl.Text = sectionName
            sl.TextColor3 = Window.Theme.Text
            sl.Font = Enum.Font.GothamBold
            sl.TextSize = 14
            sl.TextXAlignment = Enum.TextXAlignment.Left
            sl.Parent = Section
        end

        function Tab:CreateButton(config)
            local buttonName = config.Name or "Button"
            local cb = config.Callback or function() end
            
            local btnFrame = Instance.new("Frame")
            btnFrame.Size = UDim2.new(1,0,0,40)
            btnFrame.BackgroundColor3 = Window.Theme.Secondary
            btnFrame.Parent = TabContent
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0,8)
            bc.Parent = btnFrame
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,-10,1,-10)
            btn.Position = UDim2.new(0,5,0,5)
            btn.BackgroundColor3 = Window.Theme.Tertiary
            btn.Text = buttonName
            btn.TextColor3 = Window.Theme.Text
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 14
            btn.Parent = btnFrame
            local btc = Instance.new("UICorner")
            btc.CornerRadius = UDim.new(0,6)
            btc.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Window.Theme.Accent}):Play()
                task.wait(0.1)
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Window.Theme.Tertiary}):Play()
                pcall(cb)
            end)
        end

        function Tab:CreateToggle(config)
            local name = config.Name or "Toggle"
            local default = config.Default or false
            local cb = config.Callback or function() end
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1,0,0,40)
            frame.BackgroundColor3 = Window.Theme.Secondary
            frame.Parent = TabContent
            local fc = Instance.new("UICorner")
            fc.CornerRadius = UDim.new(0,8)
            fc.Parent = frame
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1,-60,1,0)
            lbl.Position = UDim2.new(0,10,0,0)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = Window.Theme.Text
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0,40,0,20)
            btn.Position = UDim2.new(1,-50,0.5,-10)
            btn.BackgroundColor3 = default and Window.Theme.Accent or Window.Theme.Tertiary
            btn.Text = ""
            btn.Parent = frame
            local btc = Instance.new("UICorner")
            btc.CornerRadius = UDim.new(1,0)
            btc.Parent = btn
            
            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0,16,0,16)
            circle.Position = default and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
            circle.BackgroundColor3 = Color3.new(1,1,1)
            circle.Parent = btn
            local cc = Instance.new("UICorner")
            cc.CornerRadius = UDim.new(1,0)
            cc.Parent = circle
            
            local toggled = default
            btn.MouseButton1Click:Connect(function()
                toggled = not toggled
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = toggled and Window.Theme.Accent or Window.Theme.Tertiary}):Play()
                TweenService:Create(circle, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
                pcall(cb, toggled)
            end)
        end

        function Tab:CreateSlider(config)
            local name = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local def = config.Default or min
            local cb = config.Callback or function() end
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1,0,0,50)
            frame.BackgroundColor3 = Window.Theme.Secondary
            frame.Parent = TabContent
            local fc = Instance.new("UICorner")
            fc.CornerRadius = UDim.new(0,8)
            fc.Parent = frame
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1,-20,0,20)
            lbl.Position = UDim2.new(0,10,0,5)
            lbl.BackgroundTransparency = 1
            lbl.Text = name
            lbl.TextColor3 = Window.Theme.Text
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame
            
            local val = Instance.new("TextLabel")
            val.Size = UDim2.new(0,50,0,20)
            val.Position = UDim2.new(1,-60,0,5)
            val.BackgroundTransparency = 1
            val.Text = tostring(def)
            val.TextColor3 = Window.Theme.Accent
            val.Font = Enum.Font.GothamBold
            val.TextSize = 14
            val.TextXAlignment = Enum.TextXAlignment.Right
            val.Parent = frame
            
            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1,-20,0,6)
            bar.Position = UDim2.new(0,10,0,30)
            bar.BackgroundColor3 = Window.Theme.Tertiary
            bar.Parent = frame
            local brc = Instance.new("UICorner")
            brc.CornerRadius = UDim.new(1,0)
            brc.Parent = bar
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((def - min)/(max - min), 0, 1, 0)
            fill.BackgroundColor3 = Window.Theme.Accent
            fill.BorderSizePixel = 0
            fill.Parent = bar
            local flc = Instance.new("UICorner")
            flc.CornerRadius = UDim.new(1,0)
            flc.Parent = fill
            
            local trigger = Instance.new("TextButton")
            trigger.Size = UDim2.new(1,0,1,0)
            trigger.BackgroundTransparency = 1
            trigger.Text = ""
            trigger.Parent = bar
            
            local dragging = false
            trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local scale = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + ((max - min) * scale))
                    fill.Size = UDim2.new(scale, 0, 1, 0)
                    val.Text = tostring(value)
                    pcall(cb, value)
                end
            end)
        end
        
        return Tab
    end
    
    function Window:Notify(config)
        local title = config.Title or "Notification"
        local content = config.Content or ""
        local duration = config.Duration or 3
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0, 300, 0, 70)
        container.Position = UDim2.new(1, 20, 1, -100 - (#Window.Notifications * 80))
        container.BackgroundColor3 = Window.Theme.Secondary
        container.Parent = ScreenGui
        local cc = Instance.new("UICorner")
        cc.CornerRadius = UDim.new(0,8)
        cc.Parent = container
        local cs = Instance.new("UIStroke")
        cs.Color = Window.Theme.Border
        cs.Parent = container
        
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(0,4,1,0)
        bar.BackgroundColor3 = Window.Theme.Accent
        bar.Parent = container
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0,8)
        bc.Parent = bar
        
        local tl = Instance.new("TextLabel")
        tl.Size = UDim2.new(1,-20,0,20)
        tl.Position = UDim2.new(0,15,0,10)
        tl.BackgroundTransparency = 1
        tl.Text = title
        tl.TextColor3 = Window.Theme.Text
        tl.Font = Enum.Font.GothamBold
        tl.TextSize = 14
        tl.TextXAlignment = Enum.TextXAlignment.Left
        tl.Parent = container
        
        local cl = Instance.new("TextLabel")
        cl.Size = UDim2.new(1,-20,0,30)
        cl.Position = UDim2.new(0,15,0,30)
        cl.BackgroundTransparency = 1
        cl.Text = content
        cl.TextColor3 = Window.Theme.SubText
        cl.Font = Enum.Font.Gotham
        cl.TextSize = 13
        cl.TextWrapped = true
        cl.TextXAlignment = Enum.TextXAlignment.Left
        cl.TextYAlignment = Enum.TextYAlignment.Top
        cl.Parent = container
        
        table.insert(Window.Notifications, container)
        TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.new(1, -320, 1, -100 - (#Window.Notifications-1)*80)}):Play()
        
        task.delay(duration, function()
            TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.new(1, 20, 1, -100)}):Play()
            task.wait(0.5)
            container:Destroy()
        end)
    end
    
    return Window
end

-- ///////////////////////////////////////////////////////////
-- //                 PART 3: EXECUTION                     //
-- ///////////////////////////////////////////////////////////

Loader.Load({
    Title = "LUMAHUB",
    Subtitle = "Loading your premium UI...",
    DiscordLink = "https://discord.gg/lumahub",
    YoutubeLink = "https://youtube.com/@lumahub",
    Callback = function()
        -- This runs after the loader finishes
        local Window = Library:CreateWindow({
            Name = "LumaHub | Premium",
            Theme = "Dark", 
            Keybind = Enum.KeyCode.RightControl
        })

        Window:Notify({
            Title = "Welcome Back!",
            Content = "LumaHub has been initialized successfully",
            Duration = 5
        })

        local MainTab = Window:CreateTab({
            Name = "Main",
            Icon = "🏠"
        })

        MainTab:CreateSection("Core Features")

        MainTab:CreateButton({
            Name = "Test Feature",
            Callback = function()
                Window:Notify({
                    Title = "Feature Activated",
                    Content = "This is a test feature!",
                    Duration = 3
                })
            end
        })

        MainTab:CreateToggle({
            Name = "Example Toggle",
            Default = false,
            Callback = function(value)
                print("Toggle state:", value)
            end
        })

        local SettingsTab = Window:CreateTab({
            Name = "Settings",
            Icon = "⚙️"
        })

        SettingsTab:CreateSection("Configuration")

        SettingsTab:CreateSlider({
            Name = "Example Slider",
            Min = 0,
            Max = 100,
            Default = 50,
            Callback = function(value)
                print("Slider value:", value)
            end
        })
    end
})
