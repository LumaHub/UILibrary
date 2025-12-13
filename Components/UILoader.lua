local Loader = {}

function Loader.Load(settings)
    settings = settings or {}
    local customTitle = settings.Title or "UI LIBRARY" [cite: 92]
    local customSubtitle = settings.Subtitle or "Preparing interface..." [cite: 92]
    local discordEnabled = settings.DiscordLink ~= nil [cite: 92]
    local discordLink = settings.DiscordLink or "https://discord.gg/example" [cite: 92]
    local youtubeEnabled = settings.YoutubeLink ~= nil [cite: 92]
    local youtubeLink = settings.YoutubeLink or "https://youtube.com/@example" [cite: 92]
    
    local Players = game:GetService("Players") [cite: 92]
    local TweenService = game:GetService("TweenService") [cite: 92]
    local RunService = game:GetService("RunService") [cite: 92]
    local Lighting = game:GetService("Lighting") [cite: 93]

    local player = Players.LocalPlayer [cite: 93]
    local playerGui = player:WaitForChild("PlayerGui") [cite: 93]

    if playerGui:FindFirstChild("UILoaderGui") then
        playerGui:FindFirstChild("UILoaderGui"):Destroy() [cite: 93]
    end

    local screenGui = Instance.new("ScreenGui") [cite: 93]
    screenGui.Name = "UILoaderGui" [cite: 93]
    screenGui.ResetOnSpawn = false [cite: 93]
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling [cite: 93]
    screenGui.IgnoreGuiInset = true [cite: 93]
    screenGui.Parent = playerGui [cite: 93]

    local blur = Instance.new("BlurEffect") [cite: 93]
    blur.Size = 0 [cite: 93]
    blur.Parent = Lighting [cite: 93]

    local blurTween = TweenService:Create(blur, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 24}) [cite: 94]
    blurTween:Play() [cite: 94]

    local fullBg = Instance.new("Frame") [cite: 94]
    fullBg.Name = "FullBackground" [cite: 94]
    fullBg.Size = UDim2.new(1, 0, 1, 0) [cite: 94]
    fullBg.Position = UDim2.new(0, 0, 0, 0) [cite: 94]
    fullBg.BackgroundColor3 = Color3.fromRGB(8, 8, 12) [cite: 94]
    fullBg.BackgroundTransparency = 1 [cite: 94]
    fullBg.BorderSizePixel = 0 [cite: 94]
    fullBg.ZIndex = 1 [cite: 94]
    fullBg.Parent = screenGui [cite: 94]

    TweenService:Create(fullBg, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play() [cite: 94]

    local gridContainer = Instance.new("Frame") [cite: 95]
    gridContainer.Name = "GridContainer" [cite: 95]
    gridContainer.Size = UDim2.new(1, 0, 1, 0) [cite: 95]
    gridContainer.BackgroundTransparency = 1 [cite: 95]
    gridContainer.ZIndex = 2 [cite: 95]
    gridContainer.Parent = screenGui [cite: 95]

    for i = 1, 12 do
        local line = Instance.new("Frame") [cite: 95]
        line.Size = UDim2.new(0, 1, 1, 0) [cite: 95]
        line.Position = UDim2.new(i / 13, 0, 0, 0) [cite: 95]
        line.BackgroundColor3 = Color3.fromRGB(40, 40, 50) [cite: 95]
        line.BackgroundTransparency = 0.95 [cite: 95]
        line.BorderSizePixel = 0 [cite: 95]
        line.Parent = gridContainer [cite: 96]
    end

    for i = 1, 8 do
        local line = Instance.new("Frame") [cite: 96]
        line.Size = UDim2.new(1, 0, 0, 1) [cite: 96]
        line.Position = UDim2.new(0, 0, i / 9, 0) [cite: 96]
        line.BackgroundColor3 = Color3.fromRGB(40, 40, 50) [cite: 96]
        line.BackgroundTransparency = 0.95 [cite: 96]
        line.BorderSizePixel = 0 [cite: 96]
        line.Parent = gridContainer [cite: 97]
    end

    local mainContainer = Instance.new("Frame") [cite: 97]
    mainContainer.Name = "MainContainer" [cite: 97]
    mainContainer.Size = UDim2.new(0, 1150, 0, 480) [cite: 97]
    mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0) [cite: 97]
    mainContainer.AnchorPoint = Vector2.new(0.5, 0.5) [cite: 97]
    mainContainer.BackgroundTransparency = 1 [cite: 97]
    mainContainer.ZIndex = 4 [cite: 97]
    mainContainer.Parent = screenGui [cite: 97]

    local dockContainer
    local iconSize = 50
    local iconSpacing = 12
    local totalIcons = (discordEnabled and 1 or 0) + (youtubeEnabled and 1 or 0)
    local dockWidth = (iconSize * totalIcons) + (iconSpacing * (totalIcons + 1)) [cite: 102]
    local dockHeight = 70
    local dockOffset = 20 -- Spacing between mainContainer and dockContainer

    if discordEnabled or youtubeEnabled then
        dockContainer = Instance.new("Frame") [cite: 98]
        dockContainer.Name = "DockContainer" [cite: 98]
        
        -- Initial Size (0,0) and Position (below main frame for entrance)
        dockContainer.Size = UDim2.new(0, 0, 0, 0)
        
        -- Centered horizontally (0.5), positioned below main container (0.5+0.5+offset)
        local mainContainerHalfHeight = 480 / 2
        local startYPosition = 0.5 + (mainContainerHalfHeight + dockHeight/2 + dockOffset) / screenGui.AbsoluteSize.Y
        dockContainer.Position = UDim2.new(0.5, 0, startYPosition, 0) 
        
        dockContainer.AnchorPoint = Vector2.new(0.5, 0.5) [cite: 98]
        dockContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 24) [cite: 98]
        dockContainer.BorderSizePixel = 0 [cite: 98]
        dockContainer.ZIndex = 10 [cite: 98]
        dockContainer.Parent = screenGui -- MUST be in ScreenGui to be separate from MainContainer

        local dockCorner = Instance.new("UICorner") [cite: 98]
        dockCorner.CornerRadius = UDim.new(0, 16) [cite: 99]
        dockCorner.Parent = dockContainer [cite: 99]

        local dockStroke = Instance.new("UIStroke") [cite: 99]
        dockStroke.Color = Color3.fromRGB(35, 35, 45) [cite: 99]
        dockStroke.Thickness = 1 [cite: 105]
        dockStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border [cite: 99]
        dockStroke.Parent = dockContainer [cite: 99]

        local dockAccent = Instance.new("Frame") [cite: 99]
        dockAccent.Name = "DockAccent" [cite: 100]
        dockAccent.Size = UDim2.new(1, 0, 0, 2) [cite: 100]
        dockAccent.Position = UDim2.new(0, 0, 0, 0) [cite: 100]
        dockAccent.BackgroundColor3 = Color3.fromRGB(80, 120, 255) [cite: 100]
        dockAccent.BorderSizePixel = 0 [cite: 100]
        dockAccent.Parent = dockContainer [cite: 100]

        local dockAccentCorner = Instance.new("UICorner") [cite: 100]
        dockAccentCorner.CornerRadius = UDim.new(0, 16) [cite: 100]
        dockAccentCorner.Parent = dockAccent [cite: 100]

        local dockAccentGradient = Instance.new("UIGradient") [cite: 100]
        dockAccentGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 120, 255)), [cite: 101]
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 80, 255)), [cite: 101]
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 120, 255)) [cite: 101]
        }
        dockAccentGradient.Parent = dockAccent [cite: 101]

        local currentX = iconSpacing

        if discordEnabled then
            local discordButton = Instance.new("ImageButton") [cite: 102]
            discordButton.Name = "DiscordButton" [cite: 103]
            discordButton.Size = UDim2.new(0, iconSize, 0, iconSize) [cite: 103]
            discordButton.Position = UDim2.new(0, currentX, 0.5, 0) [cite: 103]
            discordButton.AnchorPoint = Vector2.new(0, 0.5) [cite: 103]
            discordButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38) [cite: 103]
            discordButton.BorderSizePixel = 0 [cite: 103]
            
            -- FIXED ASSET ID
            discordButton.Image = "rbxassetid://6022830843" -- New, reliable white discord icon
            
            discordButton.ScaleType = Enum.ScaleType.Fit [cite: 103]
            discordButton.ZIndex = 11 [cite: 104]
            discordButton.Parent = dockContainer [cite: 104]

            local discordCorner = Instance.new("UICorner") [cite: 104]
            discordCorner.CornerRadius = UDim.new(0, 12) [cite: 104]
            discordCorner.Parent = discordButton [cite: 104]

            local discordStroke = Instance.new("UIStroke") [cite: 104]
            discordStroke.Color = Color3.fromRGB(50, 50, 60) [cite: 105]
            discordStroke.Thickness = 1 [cite: 105]
            discordStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border [cite: 105]
            discordStroke.Parent = discordButton [cite: 105]

            discordButton.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(discordLink) [cite: 106]
                end
                
                local originalSize = discordButton.Size [cite: 106]
                TweenService:Create(discordButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, iconSize * 0.9, 0, iconSize * 0.9) [cite: 107]
                }):Play()
                
                task.wait(0.1) [cite: 107]
                TweenService:Create(discordButton, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = originalSize [cite: 107]
                }):Play()
            end)

            discordButton.MouseEnter:Connect(function()
                TweenService:Create(discordButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, iconSize * 1.1, 0, iconSize * 1.1), [cite: 108]
                    BackgroundColor3 = Color3.fromRGB(38, 38, 48) [cite: 108]
                }):Play()
            end)

            discordButton.MouseLeave:Connect(function()
                TweenService:Create(discordButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, iconSize, 0, iconSize), [cite: 109]
                    BackgroundColor3 = Color3.fromRGB(28, 28, 38) [cite: 109]
                }):Play()
            end) [cite: 110]

            currentX = currentX + iconSize + iconSpacing [cite: 110]
        end

        if youtubeEnabled then
            local youtubeButton = Instance.new("ImageButton") [cite: 110]
            youtubeButton.Name = "YoutubeButton" [cite: 111]
            youtubeButton.Size = UDim2.new(0, iconSize, 0, iconSize) [cite: 111]
            youtubeButton.Position = UDim2.new(0, currentX, 0.5, 0) [cite: 111]
            youtubeButton.AnchorPoint = Vector2.new(0, 0.5) [cite: 111]
            youtubeButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38) [cite: 111]
            youtubeButton.BorderSizePixel = 0 [cite: 111]
            
            -- FIXED ASSET ID
            youtubeButton.Image = "rbxassetid://6022830388" -- New, reliable white youtube icon
            
            youtubeButton.ScaleType = Enum.ScaleType.Fit [cite: 111]
            youtubeButton.ZIndex = 11 [cite: 112]
            youtubeButton.Parent = dockContainer [cite: 112]

            local youtubeCorner = Instance.new("UICorner") [cite: 112]
            youtubeCorner.CornerRadius = UDim.new(0, 12) [cite: 112]
            youtubeCorner.Parent = youtubeButton [cite: 112]

            local youtubeStroke = Instance.new("UIStroke") [cite: 112]
            youtubeStroke.Color = Color3.fromRGB(50, 50, 60) [cite: 113]
            youtubeStroke.Thickness = 1 [cite: 113]
            youtubeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border [cite: 113]
            youtubeStroke.Parent = youtubeButton [cite: 113]

            youtubeButton.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(youtubeLink) [cite: 113]
                end
            
                local originalSize = youtubeButton.Size [cite: 114]
                TweenService:Create(youtubeButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, iconSize * 0.9, 0, iconSize * 0.9) [cite: 114]
                }):Play()
            
                task.wait(0.1) [cite: 115]
                TweenService:Create(youtubeButton, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = originalSize [cite: 115]
                }):Play()
            end)

            youtubeButton.MouseEnter:Connect(function()
                TweenService:Create(youtubeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, iconSize * 1.1, 0, iconSize * 1.1), [cite: 116]
                    BackgroundColor3 = Color3.fromRGB(38, 38, 48) [cite: 116]
                }):Play()
            end)

            youtubeButton.MouseLeave:Connect(function()
                TweenService:Create(youtubeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, iconSize, 0, iconSize), [cite: 117]
                    BackgroundColor3 = Color3.fromRGB(28, 28, 38) [cite: 117]
                }):Play()
            end)

            currentX = currentX + iconSize + iconSpacing [cite: 118]
        end
    end

    local infoFrame = Instance.new("Frame") [cite: 118]
    infoFrame.Name = "InfoFrame" [cite: 118]
    infoFrame.Size = UDim2.new(0, 280, 0, 480) [cite: 118]
    infoFrame.Position = UDim2.new(0, 0, 0, 0) [cite: 118]
    infoFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24) [cite: 118]
    infoFrame.BorderSizePixel = 0 [cite: 118]
    infoFrame.ClipsDescendants = false [cite: 118]
    infoFrame.Parent = mainContainer [cite: 118]

    local infoCorner = Instance.new("UICorner") [cite: 119]
    infoCorner.CornerRadius = UDim.new(0, 20) [cite: 119]
    infoCorner.Parent = infoFrame [cite: 119]

    local infoStroke = Instance.new("UIStroke") [cite: 119]
    infoStroke.Color = Color3.fromRGB(35, 35, 45) [cite: 119]
    infoStroke.Thickness = 1 [cite: 119]
    infoStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border [cite: 119]
    infoStroke.Parent = infoFrame [cite: 119]

    local topAccent = Instance.new("Frame") [cite: 120]
    topAccent.Name = "TopAccent" [cite: 120]
    topAccent.Size = UDim2.new(1, 0, 0, 2) [cite: 120]
    topAccent.Position = UDim2.new(0, 0, 0, 0) [cite: 120]
    topAccent.BackgroundColor3 = Color3.fromRGB(80, 120, 255) [cite: 120]
    topAccent.BorderSizePixel = 0 [cite: 120]
    topAccent.Parent = infoFrame [cite: 120]

    local accentCorner = Instance.new("UICorner") [cite: 120]
    accentCorner.CornerRadius = UDim.new(0, 20) [cite: 120]
    accentCorner.Parent = topAccent [cite: 120]

    local accentGradient = Instance.new("UIGradient") [cite: 120]
    accentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 120, 255)), [cite: 120]
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 80, 255)), [cite: 120]
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 120, 255)) [cite: 120]
    }
    accentGradient.Parent = topAccent [cite: 120]

    local loaderLabel = Instance.new("TextLabel") [cite: 120]
    loaderLabel.Name = "LoaderLabel" [cite: 121]
    loaderLabel.Size = UDim2.new(1, -40, 0, 30) [cite: 121]
    loaderLabel.Position = UDim2.new(0, 20, 0, 20) [cite: 121]
    loaderLabel.BackgroundTransparency = 1 [cite: 121]
    loaderLabel.Text = "Loader" [cite: 121]
    loaderLabel.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 121]
    loaderLabel.TextSize = 14 [cite: 121]
    loaderLabel.Font = Enum.Font.GothamMedium [cite: 121]
    loaderLabel.TextXAlignment = Enum.TextXAlignment.Left [cite: 121]
    loaderLabel.TextTransparency = 1 [cite: 121]
    loaderLabel.Parent = infoFrame [cite: 121]

    local divider = Instance.new("Frame") [cite: 121]
    divider.Name = "Divider" [cite: 121]
    divider.Size = UDim2.new(1, -40, 0, 1) [cite: 121]
    divider.Position = UDim2.new(0, 20, 0, 55) [cite: 121]
    divider.BackgroundColor3 = Color3.fromRGB(35, 35, 45) [cite: 121]
    divider.BorderSizePixel = 0 [cite: 121]
    divider.Parent = infoFrame [cite: 121]

    local viewportContainer = Instance.new("Frame") [cite: 122]
    viewportContainer.Name = "ViewportContainer" [cite: 122]
    viewportContainer.Size = UDim2.new(0, 220, 0, 220) [cite: 122]
    viewportContainer.Position = UDim2.new(0.5, 0, 0, 80) [cite: 122]
    viewportContainer.AnchorPoint = Vector2.new(0.5, 0) [cite: 122]
    viewportContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 38) [cite: 122]
    viewportContainer.BorderSizePixel = 0 [cite: 122]
    viewportContainer.Parent = infoFrame [cite: 122]

    local containerCorner = Instance.new("UICorner") [cite: 122]
    containerCorner.CornerRadius = UDim.new(0, 16) [cite: 122]
    containerCorner.Parent = viewportContainer [cite: 122]

    local containerStroke = Instance.new("UIStroke") [cite: 122]
    containerStroke.Color = Color3.fromRGB(50, 50, 60) [cite: 123]
    containerStroke.Thickness = 1 [cite: 123]
    containerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border [cite: 123]
    containerStroke.Parent = viewportContainer [cite: 123]

    local viewportFrame = Instance.new("ViewportFrame") [cite: 123]
    viewportFrame.Name = "AvatarViewport" [cite: 123]
    viewportFrame.Size = UDim2.new(1, 0, 1, 0) [cite: 123]
    viewportFrame.BackgroundTransparency = 1 [cite: 123]
    viewportFrame.BorderSizePixel = 0 [cite: 123]
    viewportFrame.Parent = viewportContainer [cite: 123]

    local camera = Instance.new("Camera") [cite: 123]
    camera.Parent = viewportFrame [cite: 123]
    viewportFrame.CurrentCamera = camera [cite: 123]

    local worldModel = Instance.new("WorldModel") [cite: 123]
    worldModel.Parent = viewportFrame [cite: 123]

    local rigModel = nil
    local rotationConnection = nil

    local function setupCharacter()
        task.spawn(function() [cite: 124]
            local character = player.Character or player.CharacterAdded:Wait() [cite: 124]
            task.wait(0.3) [cite: 124]

            local humanoid = character:FindFirstChildOfClass("Humanoid") [cite: 124]
            if not humanoid then return end [cite: 124]

            local description = humanoid:GetAppliedDescription() [cite: 124]
            if not description then return end [cite: 124]

            local rig = Players:CreateHumanoidModelFromDescription(description, Enum.HumanoidRigType.R15) [cite: 125]

            for _, obj in pairs(rig:GetDescendants()) do
                if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                    obj:Destroy() [cite: 126]
                end
            end

            rig.Parent = worldModel [cite: 126]
            rigModel = rig [cite: 126]

            local hrp = rig:FindFirstChild("HumanoidRootPart") [cite: 126]
            if hrp then [cite: 126]
                hrp.Anchored = true [cite: 127]
                local humRoot = rig:FindFirstChild("Humanoid") and rig:FindFirstChild("Humanoid").RootPart or hrp [cite: 127]
                camera.CFrame = CFrame.new(humRoot.Position + Vector3.new(0, 1.2, 4.5), humRoot.Position + Vector3.new(0, 1.2, 0)) [cite: 127]

                rotationConnection = RunService.RenderStepped:Connect(function(dt)
                    if not rig or not rig.Parent then
                        if rotationConnection then
                            rotationConnection:Disconnect() [cite: 128]
                        end
                        return [cite: 128]
                    end
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(dt * 35), 0) [cite: 129]
                end)
            end
        end)
    end

    setupCharacter() [cite: 129]

    local infoContainer = Instance.new("Frame") [cite: 129]
    infoContainer.Name = "InfoContainer" [cite: 130]
    infoContainer.Size = UDim2.new(1, -40, 0, 120) [cite: 130]
    infoContainer.Position = UDim2.new(0, 20, 0, 320) [cite: 130]
    infoContainer.BackgroundTransparency = 1 [cite: 130]
    infoContainer.Parent = infoFrame [cite: 130]

    local usernameLabel = Instance.new("TextLabel") [cite: 130]
    usernameLabel.Name = "Username" [cite: 130]
    usernameLabel.Size = UDim2.new(1, 0, 0, 28) [cite: 130]
    usernameLabel.Position = UDim2.new(0, 0, 0, 0) [cite: 130]
    usernameLabel.BackgroundTransparency = 1 [cite: 130]
    usernameLabel.Text = player.Name [cite: 130]
    usernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 130]
    usernameLabel.TextSize = 18 [cite: 130]
    usernameLabel.Font = Enum.Font.GothamBold [cite: 130]
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left [cite: 130]
    usernameLabel.TextTransparency = 1 [cite: 130]
    usernameLabel.Parent = infoContainer [cite: 130]

    local userIdLabel = Instance.new("TextLabel") [cite: 131]
    userIdLabel.Name = "UserId" [cite: 131]
    userIdLabel.Size = UDim2.new(1, 0, 0, 24) [cite: 131]
    userIdLabel.Position = UDim2.new(0, 0, 0, 32) [cite: 131]
    userIdLabel.BackgroundTransparency = 1 [cite: 131]
    userIdLabel.Text = "ID: " .. tostring(player.UserId) [cite: 131]
    userIdLabel.TextColor3 = Color3.fromRGB(130, 130, 145) [cite: 131]
    userIdLabel.TextSize = 14 [cite: 131]
    userIdLabel.Font = Enum.Font.Gotham [cite: 131]
    userIdLabel.TextXAlignment = Enum.TextXAlignment.Left [cite: 131]
    userIdLabel.TextTransparency = 1 [cite: 131]
    userIdLabel.Parent = infoContainer [cite: 131]

    local executorName = "Unknown" [cite: 131]
    if identifyexecutor then [cite: 132]
        executorName = identifyexecutor() [cite: 132]
    elseif KRNL_LOADED then [cite: 132]
        executorName = "KRNL" [cite: 132]
    elseif syn then [cite: 132]
        executorName = "Synapse X" [cite: 132]
    elseif SENTINEL_V2 then [cite: 132]
        executorName = "Sentinel" [cite: 132]
    end

    local executorLabel = Instance.new("TextLabel") [cite: 132]
    executorLabel.Name = "Executor" [cite: 132]
    executorLabel.Size = UDim2.new(1, 0, 0, 24) [cite: 132]
    executorLabel.Position = UDim2.new(0, 0, 0, 60) [cite: 132]
    executorLabel.BackgroundTransparency = 1 [cite: 132]
    executorLabel.Text = "Executor: " .. executorName [cite: 133]
    executorLabel.TextColor3 = Color3.fromRGB(80, 120, 255) [cite: 133]
    executorLabel.TextSize = 14 [cite: 133]
    executorLabel.Font = Enum.Font.GothamMedium [cite: 133]
    executorLabel.TextXAlignment = Enum.TextXAlignment.Left [cite: 133]
    executorLabel.TextTransparency = 1 [cite: 133]
    executorLabel.Parent = infoContainer [cite: 133]

    local statusContainer = Instance.new("Frame") [cite: 133]
    statusContainer.Name = "StatusContainer" [cite: 134]
    statusContainer.Size = UDim2.new(1, -40, 0, 24) [cite: 134]
    statusContainer.Position = UDim2.new(0, 20, 1, -44) [cite: 134]
    statusContainer.BackgroundTransparency = 1 [cite: 134]
    statusContainer.Parent = infoFrame [cite: 134]

    local statusIndicator = Instance.new("Frame") [cite: 134]
    statusIndicator.Name = "StatusIndicator" [cite: 134]
    statusIndicator.Size = UDim2.new(0, 8, 0, 8) [cite: 134]
    statusIndicator.Position = UDim2.new(0, 0, 0.5, -4) [cite: 134]
    statusIndicator.BackgroundColor3 = Color3.fromRGB(80, 255, 120) [cite: 134]
    statusIndicator.BorderSizePixel = 0 [cite: 134]
    statusIndicator.Parent = statusContainer [cite: 134]

    local indicatorCorner = Instance.new("UICorner") [cite: 134]
    indicatorCorner.CornerRadius = UDim.new(1, 0) [cite: 134]
    indicatorCorner.Parent = statusIndicator [cite: 134]

    local statusText = Instance.new("TextLabel") [cite: 134]
    statusText.Size = UDim2.new(1, -16, 1, 0) [cite: 135]
    statusText.Position = UDim2.new(0, 16, 0, 0) [cite: 135]
    statusText.BackgroundTransparency = 1 [cite: 135]
    statusText.Text = "Online" [cite: 135]
    statusText.TextColor3 = Color3.fromRGB(130, 130, 145) [cite: 135]
    statusText.TextSize = 13 [cite: 135]
    statusText.Font = Enum.Font.Gotham [cite: 135]
    statusText.TextXAlignment = Enum.TextXAlignment.Left [cite: 135]
    statusText.TextTransparency = 1 [cite: 135]
    statusText.Parent = statusContainer [cite: 135]

    local loadingFrame = Instance.new("Frame") [cite: 135]
    loadingFrame.Name = "LoadingFrame" [cite: 136]
    loadingFrame.Size = UDim2.new(0, 650, 0, 480) [cite: 136]
    loadingFrame.Position = UDim2.new(0, 290, 0, 0) [cite: 136]
    loadingFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16) [cite: 136]
    loadingFrame.BorderSizePixel = 0 [cite: 136]
    loadingFrame.ClipsDescendants = true [cite: 136]
    loadingFrame.Parent = mainContainer [cite: 136]

    local loadingCorner = Instance.new("UICorner") [cite: 136]
    loadingCorner.CornerRadius = UDim.new(0, 20) [cite: 136]
    loadingCorner.Parent = loadingFrame [cite: 136]

    local loadingStroke = Instance.new("UIStroke") [cite: 136]
    loadingStroke.Color = Color3.fromRGB(35, 35, 45) [cite: 136]
    loadingStroke.Thickness = 1 [cite: 136]
    loadingStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border [cite: 136]
    loadingStroke.Parent = loadingFrame [cite: 136]

    local dynamicBg1 = Instance.new("Frame") [cite: 136]
    dynamicBg1.Name = "DynamicBg1" [cite: 136]
    dynamicBg1.Size = UDim2.new(1.5, 0, 1.5, 0) [cite: 137]
    dynamicBg1.Position = UDim2.new(-0.25, 0, -0.25, 0) [cite: 137]
    dynamicBg1.BackgroundTransparency = 0.7 [cite: 137]
    dynamicBg1.BackgroundColor3 = Color3.fromRGB(12, 12, 16) [cite: 137]
    dynamicBg1.BorderSizePixel = 0 [cite: 137]
    dynamicBg1.ZIndex = 1 [cite: 137]
    dynamicBg1.Parent = loadingFrame [cite: 137]

    local gradient1 = Instance.new("UIGradient") [cite: 137]
    gradient1.Rotation = 45 [cite: 137]
    gradient1.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 120, 255)), [cite: 137]
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(140, 80, 255)), [cite: 137]
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 80, 140)), [cite: 137]
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 120, 255)) [cite: 137]
    }
    gradient1.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.95), [cite: 138]
        NumberSequenceKeypoint.new(0.5, 0.85), [cite: 138]
        NumberSequenceKeypoint.new(1, 0.95) [cite: 138]
    }
    gradient1.Parent = dynamicBg1 [cite: 138]

    local dynamicBg2 = Instance.new("Frame") [cite: 138]
    dynamicBg2.Name = "DynamicBg2" [cite: 138]
    dynamicBg2.Size = UDim2.new(1.5, 0, 1.5, 0) [cite: 138]
    dynamicBg2.Position = UDim2.new(-0.25, 0, -0.25, 0) [cite: 138]
    dynamicBg2.BackgroundTransparency = 0.8 [cite: 138]
    dynamicBg2.BackgroundColor3 = Color3.fromRGB(12, 12, 16) [cite: 138]
    dynamicBg2.BorderSizePixel = 0 [cite: 138]
    dynamicBg2.ZIndex = 1 [cite: 138]
    dynamicBg2.Parent = loadingFrame [cite: 138]

    local gradient2 = Instance.new("UIGradient") [cite: 138]
    gradient2.Rotation = -30 [cite: 139]
    gradient2.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 80)), [cite: 139]
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 200, 255)), [cite: 139]
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 80)) [cite: 139]
    }
    gradient2.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.9), [cite: 139]
        NumberSequenceKeypoint.new(0.5, 0.75), [cite: 139]
        NumberSequenceKeypoint.new(1, 0.9) [cite: 139]
    }
    gradient2.Parent = dynamicBg2 [cite: 139]

    local contentFrame = Instance.new("Frame") [cite: 139]
    contentFrame.Name = "ContentFrame" [cite: 140]
    contentFrame.Size = UDim2.new(1, 0, 1, 0) [cite: 140]
    contentFrame.BackgroundTransparency = 1 [cite: 140]
    contentFrame.ZIndex = 2 [cite: 140]
    contentFrame.Parent = loadingFrame [cite: 140]

    local titleLabel = Instance.new("TextLabel") [cite: 140]
    titleLabel.Name = "Title" [cite: 140]
    titleLabel.Size = UDim2.new(1, -60, 0, 50) [cite: 140]
    titleLabel.Position = UDim2.new(0, 30, 0, 60) [cite: 140]
    titleLabel.BackgroundTransparency = 1 [cite: 140]
    titleLabel.Text = customTitle [cite: 140]
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 140]
    titleLabel.TextSize = 38 [cite: 140]
    titleLabel.Font = Enum.Font.GothamBold [cite: 140]
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left [cite: 140]
    titleLabel.TextTransparency = 1 [cite: 140]
    titleLabel.Parent = contentFrame [cite: 140]

    local titleGlow = Instance.new("UIStroke") [cite: 140]
    titleGlow.Color = Color3.fromRGB(80, 120, 255) [cite: 141]
    titleGlow.Thickness = 0 [cite: 141]
    titleGlow.Transparency = 0.3 [cite: 141]
    titleGlow.Parent = titleLabel [cite: 141]

    local subtitleLabel = Instance.new("TextLabel") [cite: 141]
    subtitleLabel.Name = "Subtitle" [cite: 141]
    subtitleLabel.Size = UDim2.new(1, -60, 0, 28) [cite: 142]
    subtitleLabel.Position = UDim2.new(0, 30, 0, 115) [cite: 142]
    subtitleLabel.BackgroundTransparency = 1 [cite: 142]
    subtitleLabel.Text = customSubtitle [cite: 142]
    subtitleLabel.TextColor3 = Color3.fromRGB(130, 130, 145) [cite: 142]
    subtitleLabel.TextSize = 15 [cite: 142]
    subtitleLabel.Font = Enum.Font.Gotham [cite: 142]
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left [cite: 142]
    subtitleLabel.TextTransparency = 1 [cite: 142]
    subtitleLabel.Parent = contentFrame [cite: 142]

    local progressContainer = Instance.new("Frame") [cite: 142]
    progressContainer.Name = "ProgressContainer" [cite: 142]
    progressContainer.Size = UDim2.new(1, -60, 0, 8) [cite: 142]
    progressContainer.Position = UDim2.new(0, 30, 0, 260) [cite: 142]
    progressContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 28) [cite: 142]
    progressContainer.BorderSizePixel = 0 [cite: 142]
    progressContainer.Parent = contentFrame [cite: 142]

    local progressCorner = Instance.new("UICorner") [cite: 143]
    progressCorner.CornerRadius = UDim.new(1, 0) [cite: 143]
    progressCorner.Parent = progressContainer [cite: 143]

    local progressBar = Instance.new("Frame") [cite: 143]
    progressBar.Name = "ProgressBar" [cite: 143]
    progressBar.Size = UDim2.new(0, 0, 1, 0) [cite: 143]
    progressBar.BackgroundColor3 = Color3.fromRGB(80, 120, 255) [cite: 143]
    progressBar.BorderSizePixel = 0 [cite: 143]
    progressBar.Parent = progressContainer [cite: 143]

    local progressBarCorner = Instance.new("UICorner") [cite: 143]
    progressBarCorner.CornerRadius = UDim.new(1, 0) [cite: 143]
    progressBarCorner.Parent = progressBar [cite: 143]

    local progressGradient = Instance.new("UIGradient") [cite: 143]
    progressGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 120, 255)), [cite: 143]
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 80, 255)), [cite: 143]
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 120, 255)) [cite: 143]
    }
    progressGradient.Parent = progressBar [cite: 143]

    local progressGlow = Instance.new("Frame") [cite: 144]
    progressGlow.Name = "ProgressGlow" [cite: 144]
    progressGlow.Size = UDim2.new(0, 60, 1, 8) [cite: 144]
    progressGlow.Position = UDim2.new(1, -30, 0, -4) [cite: 144]
    progressGlow.BackgroundColor3 = Color3.fromRGB(80, 120, 255) [cite: 144]
    progressGlow.BackgroundTransparency = 0.8 [cite: 144]
    progressGlow.BorderSizePixel = 0 [cite: 144]
    progressGlow.Parent = progressBar [cite: 144]

    local glowCorner = Instance.new("UICorner") [cite: 144]
    glowCorner.CornerRadius = UDim.new(1, 0) [cite: 144]
    glowCorner.Parent = progressGlow [cite: 144]

    local glowGradient = Instance.new("UIGradient") [cite: 144]
    glowGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1), [cite: 145]
        NumberSequenceKeypoint.new(0.5, 0), [cite: 145]
        NumberSequenceKeypoint.new(1, 1) [cite: 145]
    }
    glowGradient.Parent = progressGlow [cite: 145]

    local percentLabel = Instance.new("TextLabel") [cite: 145]
    percentLabel.Name = "Percent" [cite: 145]
    percentLabel.Size = UDim2.new(1, -60, 0, 32) [cite: 145]
    percentLabel.Position = UDim2.new(0, 30, 0, 280) [cite: 145]
    percentLabel.BackgroundTransparency = 1 [cite: 145]
    percentLabel.Text = "0%" [cite: 145]
    percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 146]
    percentLabel.TextSize = 22 [cite: 146]
    percentLabel.Font = Enum.Font.GothamBold [cite: 146]
    percentLabel.TextXAlignment = Enum.TextXAlignment.Left [cite: 146]
    percentLabel.TextTransparency = 1 [cite: 146]
    percentLabel.Parent = contentFrame [cite: 146]

    local statusLabel = Instance.new("TextLabel") [cite: 146]
    statusLabel.Name = "Status" [cite: 146]
    statusLabel.Size = UDim2.new(1, -60, 0, 24) [cite: 146]
    statusLabel.Position = UDim2.new(0, 30, 1, -60) [cite: 146]
    statusLabel.BackgroundTransparency = 1 [cite: 146]
    statusLabel.Text = "Initializing..." [cite: 146]
    statusLabel.TextColor3 = Color3.fromRGB(80, 120, 255) [cite: 146]
    statusLabel.TextSize = 13 [cite: 146]
    statusLabel.Font = Enum.Font.GothamMedium [cite: 146]
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left [cite: 146]
    statusLabel.TextTransparency = 1 [cite: 146]
    statusLabel.Parent = contentFrame [cite: 146]

    local brandFrame = Instance.new("Frame") [cite: 147]
    brandFrame.Name = "BrandFrame" [cite: 147]
    brandFrame.Size = UDim2.new(0, 200, 0, 480) [cite: 147]
    brandFrame.Position = UDim2.new(0, 950, 0, 0) [cite: 147]
    brandFrame.BackgroundColor3 = Color3.fromRGB(255, 120, 180) [cite: 147]
    brandFrame.BorderSizePixel = 0 [cite: 147]
    brandFrame.ClipsDescendants = true [cite: 147]
    brandFrame.Parent = mainContainer [cite: 147]

    local brandCorner = Instance.new("UICorner") [cite: 147]
    brandCorner.CornerRadius = UDim.new(0, 20) [cite: 147]
    brandCorner.Parent = brandFrame [cite: 147]

    local brandStroke = Instance.new("UIStroke") [cite: 147]
    brandStroke.Color = Color3.fromRGB(255, 170, 210) [cite: 147]
    brandStroke.Thickness = 1 [cite: 148]
    brandStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border [cite: 148]
    brandStroke.Parent = brandFrame [cite: 148]

    local brandGradient = Instance.new("UIGradient") [cite: 148]
    brandGradient.Rotation = 45 [cite: 148]
    brandGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 180)), [cite: 148]
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 150, 200)), [cite: 148]
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 180)) [cite: 148]
    }
    brandGradient.Parent = brandFrame [cite: 148]

    local logoImage = Instance.new("ImageLabel") [cite: 148]
    logoImage.Name = "LogoImage" [cite: 149]
    logoImage.Size = UDim2.new(0, 160, 0, 160) [cite: 149]
    logoImage.Position = UDim2.new(0.5, 0, 0, 120) [cite: 149]
    logoImage.AnchorPoint = Vector2.new(0.5, 0) [cite: 149]
    logoImage.BackgroundTransparency = 1 [cite: 149]
    logoImage.Image = "rbxassetid://125073427434619" [cite: 149] -- Using original ID
    logoImage.ScaleType = Enum.ScaleType.Fit [cite: 149]
    logoImage.ImageTransparency = 1 [cite: 149]
    logoImage.Parent = brandFrame [cite: 149]

    local brandText = Instance.new("TextLabel") [cite: 150]
    brandText.Name = "BrandText" [cite: 150]
    brandText.Size = UDim2.new(1, -40, 0, 80) [cite: 150]
    brandText.Position = UDim2.new(0, 20, 1, -120) [cite: 150]
    brandText.BackgroundTransparency = 1 [cite: 150]
    brandText.Text = "UI Brought to you by\nLumaHub" [cite: 150]
    brandText.TextColor3 = Color3.fromRGB(255, 255, 255) [cite: 150]
    brandText.TextSize = 16 [cite: 150]
    brandText.Font = Enum.Font.GothamBold [cite: 150]
    brandText.TextXAlignment = Enum.TextXAlignment.Center [cite: 150]
    brandText.TextYAlignment = Enum.TextYAlignment.Center [cite: 150]
    brandText.TextTransparency = 1 [cite: 150]
    brandText.Parent = brandFrame [cite: 150]

    local brandTextStroke = Instance.new("UIStroke") [cite: 150]
    brandTextStroke.Color = Color3.fromRGB(220, 80, 150) [cite: 151]
    brandTextStroke.Thickness = 2 [cite: 151]
    brandTextStroke.Transparency = 1 [cite: 151]
    brandTextStroke.Parent = brandText [cite: 151]

    -- Initial state for entrance animation
    mainContainer.Position = UDim2.new(0.5, 0, 0.5, 50) [cite: 151]
    mainContainer.Size = UDim2.new(0, 1150, 0, 0) [cite: 151]

    local entranceTween = TweenService:Create(mainContainer, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 1150, 0, 480), [cite: 152]
        Position = UDim2.new(0.5, 0, 0.5, 0) [cite: 152]
    })
    entranceTween:Play() [cite: 152]

    if dockContainer then
        local dockEnterGoal = {
            Size = UDim2.new(0, dockWidth, 0, dockHeight),
            -- Center Y position relative to screen: 0.5 (center) - half_main_height - half_dock_height - offset
            Position = UDim2.new(0.5, 0, 0.5, - (480/2 + dockHeight/2 + dockOffset)) 
        }
        
        task.wait(0.3) [cite: 152]
        local dockTween = TweenService:Create(dockContainer, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), dockEnterGoal) [cite: 152]
        dockTween:Play() [cite: 152]
    end

    
    task.wait(0.3) [cite: 153]

    local fadeElements = {
        loaderLabel, usernameLabel, userIdLabel, executorLabel, statusText,
        titleLabel, subtitleLabel, percentLabel, statusLabel, logoImage, brandText
    } [cite: 153]

    for i, element in ipairs(fadeElements) do
        task.spawn(function()
            task.wait(i * 0.05) [cite: 153]
            if element:IsA("TextLabel") then
                TweenService:Create(element, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play() [cite: 154]
                if element == brandText then
                    TweenService:Create(brandTextStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0}):Play() [cite: 154]
                end
            elseif element:IsA("ImageLabel") then
                TweenService:Create(element, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play() [cite: 155]
            end
        end)
    end

    task.wait(0.3) [cite: 155]
    TweenService:Create(titleGlow, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Thickness = 2}):Play() [cite: 155]

    local pulseConnection
    pulseConnection = RunService.RenderStepped:Connect(function()
        local pulse = (math.sin(tick() * 4) + 1) / 2 [cite: 156]
        statusIndicator.BackgroundColor3 = Color3.fromRGB(
            60 + pulse * 40, [cite: 156]
            200 + pulse * 55, [cite: 156]
            100 + pulse * 40 [cite: 156]
        )
    end)

    local gradientRotation = 0
    local gradient1Rotation = 0
    local gradient2Rotation = 0
    local dockGradientRotation = 0
    local gradientConnection
    gradientConnection = RunService.RenderStepped:Connect(function(dt)
        gradientRotation = gradientRotation + (dt * 30) [cite: 157]
        accentGradient.Rotation = gradientRotation [cite: 157]
        progressGradient.Rotation = gradientRotation [cite: 157]

        if dockContainer then
            dockGradientRotation = dockGradientRotation + (dt * 30) [cite: 157]
            for _, child in pairs(dockContainer:GetChildren()) do
                if child.Name == "DockAccent" then
                    for _, gradient in pairs(child:GetChildren()) do [cite: 158]
                        if gradient:IsA("UIGradient") then
                            gradient.Rotation = dockGradientRotation [cite: 158]
                        end
                    end [cite: 159]
                end
            end
        end

        gradient1Rotation = gradient1Rotation + (dt * 20) [cite: 159]
        gradient1.Rotation = gradient1Rotation [cite: 159]
        
        gradient2Rotation = gradient2Rotation - (dt * 15) [cite: 160]
        gradient2.Rotation = gradient2Rotation [cite: 160]

        
        local offsetX = math.sin(tick() * 0.4) * 0.1 [cite: 160]
        local offsetY = math.cos(tick() * 0.3) * 0.1 [cite: 160]
        dynamicBg1.Position = UDim2.new(-0.25 + offsetX, 0, -0.25 + offsetY, 0) [cite: 160]
        
        local offset2X = math.cos(tick() * 0.5) * 0.15 [cite: 160]
        local offset2Y = math.sin(tick() * 0.6) * 0.12 [cite: 160]
        dynamicBg2.Position = UDim2.new(-0.25 + offset2X, 0, -0.25 + offset2Y, 0) [cite: 161]

      
        brandGradient.Rotation = brandGradient.Rotation + (dt * 25) [cite: 161]
    end)

    local loadingSteps = {
        {progress = 15, duration = 1.0, status = "Connecting to services...", subtitle = "Establishing connection..."}, [cite: 161]
        {progress = 28, duration = 1.2, status = "Loading UI components...", subtitle = "Preparing interface..."}, [cite: 162]
        {progress = 45, duration = 1.4, status = "Initializing modules...", subtitle = "Setting up core systems..."}, [cite: 162]
        {progress = 62, duration = 1.0, status = "Loading assets...", subtitle = "Fetching resources..."}, [cite: 162]
        {progress = 78, duration = 1.4, status = "Configuring settings...", subtitle = "Applying preferences..."}, [cite: 162]
        {progress = 92, duration = 1.2, status = "Finalizing setup...", subtitle = "Almost ready..."}, [cite: 162]
        {progress = 100, duration = 0.8, status = "Complete!", subtitle = "Welcome to LumaHub"} [cite: 162]
    }

    local function updateProgress(newProgress, duration)
        local tweenInfo = TweenInfo.new(duration * 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) [cite: 163]
        local goal = {Size = UDim2.new(newProgress / 100, 0, 1, 0)} [cite: 163]
        local progressTween = TweenService:Create(progressBar, tweenInfo, goal) [cite: 163]
        progressTween:Play() [cite: 163]
        
        local currentProgress = 0 [cite: 163]
        local startTime = tick() [cite: 164]
        local progressUpdateConnection
        progressUpdateConnection = RunService.RenderStepped:Connect(function()
            local elapsed = tick() - startTime [cite: 164]
            local alpha = math.min(elapsed / (duration * 0.8), 1) [cite: 164]
            currentProgress = math.floor(currentProgress + (newProgress - currentProgress) * alpha) [cite: 164]
            percentLabel.Text = currentProgress .. "%" [cite: 164]
            
            if alpha >= 1 then
                percentLabel.Text = newProgress .. "%" [cite: 165]
                progressUpdateConnection:Disconnect() [cite: 165]
            end
        end)
        
        return progressTween
    end

    local function animateLoading()
        task.wait(1.0) [cite: 165]

        for i, step in ipairs(loadingSteps) do [cite: 165]
            local stepDuration = step.duration [cite: 166]
            local postTweenWait = stepDuration * 0.2 [cite: 166]

            local fadeOutInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) [cite: 166]
            TweenService:Create(statusLabel, fadeOutInfo, {TextTransparency = 1}):Play() [cite: 166]
            TweenService:Create(subtitleLabel, fadeOutInfo, {TextTransparency = 1}):Play() [cite: 166]

            task.wait(0.2) [cite: 166]

            statusLabel.Text = step.status [cite: 167]
            subtitleLabel.Text = step.subtitle [cite: 167]

            local fadeInInfo = TweenService:Create(statusLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}) [cite: 167]
            fadeInInfo:Play() [cite: 167]
            TweenService:Create(subtitleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play() [cite: 167]

            local progressTween = updateProgress(step.progress, stepDuration) [cite: 167]
            progressTween.Completed:Wait() [cite: 167]

            task.wait(postTweenWait) [cite: 168]

            if step.progress == 100 then [cite: 168]
                task.wait(0.8) [cite: 168]

                if pulseConnection then pulseConnection:Disconnect() end [cite: 168]
                if gradientConnection then gradientConnection:Disconnect() end [cite: 168]
                if rotationConnection then rotationConnection:Disconnect() end [cite: 168]

                local fadeOutInfoFinal = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) [cite: 169]

                -- 1. Full Screen Overlays Fade Out
                TweenService:Create(fullBg, fadeOutInfoFinal, {BackgroundTransparency = 1}):Play() [cite: 169]
                
                for _, line in pairs(gridContainer:GetChildren()) do
                    if line:IsA("Frame") then
                        TweenService:Create(line, fadeOutInfoFinal, {BackgroundTransparency = 1}):Play() [cite: 170]
                    end
                end

                -- 2. Rig Transparency
                if rigModel then [cite: 170]
                    for _, part in pairs(rigModel:GetDescendants()) do [cite: 171]
                        if part:IsA("BasePart") or part:IsA("Decal") then
                            TweenService:Create(part, fadeOutInfoFinal, {Transparency = 1}):Play() [cite: 171]
                        end
                    end [cite: 172]
                end

                -- 3. Main Container Elements Fade Out
                local allChildren = mainContainer:GetDescendants()
                if dockContainer then
                    local dockChildren = dockContainer:GetDescendants()
                    for _, child in pairs(dockChildren) do
                        table.insert(allChildren, child)
                    end
                end

                for _, obj in pairs(allChildren) do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                        TweenService:Create(obj, fadeOutInfoFinal, {TextTransparency = 1}):Play() [cite: 173]
                    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                        TweenService:Create(obj, fadeOutInfoFinal, {ImageTransparency = 1}):Play() [cite: 173]
                    elseif obj:IsA("Frame") and obj ~= fullBg and obj.Parent ~= screenGui and not obj:IsDescendantOf(dockContainer) then 
                        TweenService:Create(obj, fadeOutInfoFinal, {BackgroundTransparency = 1}):Play() [cite: 174]
                    elseif obj:IsA("UIStroke") then
                        TweenService:Create(obj, fadeOutInfoFinal, {Transparency = 1}):Play() [cite: 174]
                    end
                end

                -- 4. Collapse and Blur Out
                local collapseTween = TweenService:Create(mainContainer, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 1150, 0, 0), [cite: 179]
                    Position = UDim2.new(0.5, 0, 0.5, 50) [cite: 179]
                })

                if dockContainer then
                    local dockExitGoal = {
                        Size = UDim2.new(0, 0, 0, 0),
                        -- Animate to the initial start position (below screen) to match entrance
                        Position = UDim2.new(0.5, 0, startYPosition, 0)
                    }
                    TweenService:Create(dockContainer, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), dockExitGoal):Play() [cite: 180]
                end

                local blurOut = TweenService:Create(blur, fadeOutInfoFinal, {Size = 0}) [cite: 180]

                collapseTween:Play() [cite: 181]
                blurOut:Play() [cite: 181]

                collapseTween.Completed:Wait() [cite: 181]

                if blur.Parent then [cite: 181]
                    blur:Destroy() [cite: 181]
                end

                screenGui:Destroy() [cite: 182]

                break [cite: 182]
            end
        end
    end

    task.spawn(animateLoading) [cite: 182]
end

return Loader
