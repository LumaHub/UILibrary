local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local LumaHub = {}

-- Safely creates a slightly brighter color (lerps toward pure white)
local function BrightenColor(color, factor)
    local white = Color3.new(1, 1, 1)
    return color:lerp(white, factor)
end

-- Re-organized Themes to include the LumaHub table for clean return
local Themes = {
    Crimson = {
        Main = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(220, 60, 60),
        Stroke = Color3.fromRGB(100, 30, 30),
        Text = Color3.fromRGB(255, 230, 230),
        Glow = Color3.fromRGB(255, 100, 100)
    },
    Blossom = {
        Main = Color3.fromRGB(20, 18, 22),
        Accent = Color3.fromRGB(255, 105, 180),
        Stroke = Color3.fromRGB(120, 50, 90),
        Text = Color3.fromRGB(255, 240, 255),
        Glow = Color3.fromRGB(255, 150, 200)
    },
    Dark = {
        Main = Color3.fromRGB(10, 10, 10),
        Accent = Color3.fromRGB(100, 100, 100),
        Stroke = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(200, 200, 200),
        Glow = Color3.fromRGB(150, 150, 150)
    },
    Ocean = {
        Main = Color3.fromRGB(15, 20, 30),
        Accent = Color3.fromRGB(0, 190, 255),
        Stroke = Color3.fromRGB(30, 60, 90),
        Text = Color3.fromRGB(230, 245, 255),
        Glow = Color3.fromRGB(100, 200, 255)
    }
}

function LumaHub.Load(Settings)
    Settings = Settings or {}
    local SelectedTheme = Themes[Settings.Theme] or Themes.Blossom
    local TitleText = Settings.Title or "LumaHub"
    
    local ExecutorName = "Unknown"
    if identifyexecutor then
        local success, name = pcall(identifyexecutor)
        if success then
            ExecutorName = name
        end
    end
    
    local LumaGui = Instance.new("ScreenGui")
    LumaGui.Name = "LumaLoader"
    LumaGui.IgnoreGuiInset = true
    LumaGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if gethui then
        LumaGui.Parent = gethui()
    elseif syn and syn.protect_gui then 
        syn.protect_gui(LumaGui)
        LumaGui.Parent = CoreGui
    else
        LumaGui.Parent = CoreGui
    end
    
    -- Blur effect
    local Blur = Instance.new("BlurEffect")
    Blur.Size = 0
    Blur.Parent = game.Workspace.CurrentCamera
    
    -- Main Background
    local MainBackground = Instance.new("Frame")
    MainBackground.Name = "MainBackground"
    MainBackground.Parent = LumaGui
    MainBackground.AnchorPoint = Vector2.new(0.5, 0.5)
    MainBackground.BackgroundColor3 = SelectedTheme.Main
    MainBackground.BorderSizePixel = 0
    MainBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainBackground.Size = UDim2.new(0, 0, 0, 0) 
    MainBackground.ClipsDescendants = true
    MainBackground.BackgroundTransparency = 0.1
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainBackground
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainBackground
    MainStroke.Thickness = 2
    MainStroke.Color = SelectedTheme.Stroke
    MainStroke.Transparency = 1
    
    -- Animated gradient (FIXED line 147)
    local BackgroundGradient = Instance.new("UIGradient")
    BackgroundGradient.Rotation = 45
    BackgroundGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, SelectedTheme.Main),
        ColorSequenceKeypoint.new(0.5, BrightenColor(SelectedTheme.Main, 0.15)), -- Safely brightens the main color
        ColorSequenceKeypoint.new(1, SelectedTheme.Main)
    })
    BackgroundGradient.Parent = MainBackground
    
    -- Gradient animation
    local gradientActive = true
    spawn(function()
        while gradientActive and MainBackground.Parent do
            for i = 0, 360, 2 do
                if not gradientActive or not MainBackground.Parent then break end
                BackgroundGradient.Rotation = i
                task.wait(0.03)
            end
        end
    end)
    
    -- Glow effect
    local GlowFrame = Instance.new("Frame")
    GlowFrame.Name = "Glow"
    GlowFrame.Parent = MainBackground
    GlowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    GlowFrame.BackgroundColor3 = SelectedTheme.Glow
    GlowFrame.BackgroundTransparency = 0.7
    GlowFrame.BorderSizePixel = 0
    GlowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    GlowFrame.Size = UDim2.new(1.1, 0, 1.1, 0)
    GlowFrame.ZIndex = 0
    
    local GlowCorner = Instance.new("UICorner")
    GlowCorner.CornerRadius = UDim.new(0, 12)
    GlowCorner.Parent = GlowFrame
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "Content"
    ContentContainer.Parent = MainBackground
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Size = UDim2.new(1, 0, 1, 0)
    ContentContainer.Visible = false
    ContentContainer.ZIndex = 2
    
    -- Title with shadow
    local TitleShadow = Instance.new("TextLabel")
    TitleShadow.Parent = ContentContainer
    TitleShadow.BackgroundTransparency = 1
    TitleShadow.Position = UDim2.new(0.052, 0, 0.082, 0)
    TitleShadow.Size = UDim2.new(0.9, 0, 0.1, 0)
    TitleShadow.Font = Enum.Font.GothamBold
    TitleShadow.Text = TitleText
    TitleShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
    TitleShadow.TextSize = 22
    TitleShadow.TextXAlignment = Enum.TextXAlignment.Left
    TitleShadow.TextTransparency = 0.5
    TitleShadow.ZIndex = 1
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = ContentContainer
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0.05, 0, 0.08, 0)
    TitleLabel.Size = UDim2.new(0.9, 0, 0.1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = TitleText
    TitleLabel.TextColor3 = SelectedTheme.Text
    TitleLabel.TextSize = 22
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextTransparency = 1
    TitleLabel.ZIndex = 2
    
    -- Glowing text effect
    local TitleGlow = Instance.new("TextLabel")
    TitleGlow.Parent = ContentContainer
    TitleGlow.BackgroundTransparency = 1
    TitleGlow.Position = UDim2.new(0.05, 0, 0.08, 0)
    TitleGlow.Size = UDim2.new(0.9, 0, 0.1, 0)
    TitleGlow.Font = Enum.Font.GothamBold
    TitleGlow.Text = TitleText
    TitleGlow.TextColor3 = SelectedTheme.Accent
    TitleGlow.TextSize = 22
    TitleGlow.TextXAlignment = Enum.TextXAlignment.Left
    TitleGlow.TextTransparency = 0.5
    TitleGlow.ZIndex = 3
    
    -- Animated loading bar
    local LoadingBarContainer = Instance.new("Frame")
    LoadingBarContainer.Parent = ContentContainer
    LoadingBarContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    LoadingBarContainer.BorderSizePixel = 0
    LoadingBarContainer.Position = UDim2.new(0.05, 0, 0.85, 0)
    LoadingBarContainer.Size = UDim2.new(0.9, 0, 0.03, 0)
    LoadingBarContainer.BackgroundTransparency = 1
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = LoadingBarContainer
    
    local BarStroke = Instance.new("UIStroke")
    BarStroke.Parent = LoadingBarContainer
    BarStroke.Thickness = 1
    BarStroke.Color = SelectedTheme.Stroke
    BarStroke.Transparency = 1
    
    local LoadingFill = Instance.new("Frame")
    LoadingFill.Parent = LoadingBarContainer
    LoadingFill.BackgroundColor3 = SelectedTheme.Accent
    LoadingFill.BorderSizePixel = 0
    LoadingFill.Size = UDim2.new(0, 0, 1, 0)
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = LoadingFill
    
    -- Gradient on loading bar (FIXED line 211)
    local FillGradient = Instance.new("UIGradient")
    FillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, SelectedTheme.Accent),
        ColorSequenceKeypoint.new(0.5, BrightenColor(SelectedTheme.Accent, 0.1)), -- Safely brightens the accent color
        ColorSequenceKeypoint.new(1, SelectedTheme.Accent)
    })
    FillGradient.Parent = LoadingFill
    
    -- Shimmer effect
    local shimmerActive = true
    spawn(function()
        while shimmerActive and LoadingFill.Parent do
            for i = 0, 1, 0.05 do
                if not shimmerActive or not LoadingFill.Parent then break end
                FillGradient.Offset = Vector2.new(i, 0)
                task.wait(0.03)
            end
            for i = 1, 0, -0.05 do
                if not shimmerActive or not LoadingFill.Parent then break end
                FillGradient.Offset = Vector2.new(i, 0)
                task.wait(0.03)
            end
        end
    end)
    
    -- Viewport with better styling
    local ViewportContainer = Instance.new("Frame")
    ViewportContainer.Parent = ContentContainer
    ViewportContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ViewportContainer.BackgroundTransparency = 0.9
    ViewportContainer.Position = UDim2.new(0.05, 0, 0.22, 0)
    ViewportContainer.Size = UDim2.new(0.25, 0, 0.55, 0)
    ViewportContainer.BackgroundTransparency = 1
    
    local ViewportCorner = Instance.new("UICorner")
    ViewportCorner.CornerRadius = UDim.new(0, 10)
    ViewportCorner.Parent = ViewportContainer
    
    local ViewportStroke = Instance.new("UIStroke")
    ViewportStroke.Parent = ViewportContainer
    ViewportStroke.Thickness = 2
    ViewportStroke.Color = SelectedTheme.Accent
    ViewportStroke.Transparency = 1
    
    -- Animated border
    local ViewportGradient = Instance.new("UIGradient")
    ViewportGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, SelectedTheme.Accent),
        ColorSequenceKeypoint.new(0.5, SelectedTheme.Stroke),
        ColorSequenceKeypoint.new(1, SelectedTheme.Accent)
    })
    ViewportGradient.Parent = ViewportStroke
    
    local borderActive = true
    spawn(function()
        while borderActive and ViewportStroke.Parent do
            for i = 0, 360, 5 do
                if not borderActive or not ViewportStroke.Parent then break end
                ViewportGradient.Rotation = i
                task.wait(0.03)
            end
        end
    end)
    
    local AvatarView = Instance.new("ViewportFrame")
    AvatarView.Parent = ViewportContainer
    AvatarView.BackgroundTransparency = 1
    AvatarView.Size = UDim2.new(1, 0, 1, 0)
    AvatarView.Ambient = Color3.fromRGB(255, 255, 255)
    AvatarView.LightColor = SelectedTheme.Accent
    AvatarView.LightDirection = Vector3.new(0, -1, -1)
    
    local WorldModel = Instance.new("WorldModel")
    WorldModel.Parent = AvatarView
    
    local Camera = Instance.new("Camera")
    Camera.Parent = AvatarView
    AvatarView.CurrentCamera = Camera
    
    -- Clone character and add dance animation
    local ClonedChar, AnimTrack, CameraConn
    local success = pcall(function()
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        Character.Archivable = true
        ClonedChar = Character:Clone()
        ClonedChar.Parent = WorldModel
        
        local RootPart = ClonedChar:WaitForChild("HumanoidRootPart")
        RootPart.Anchored = true
        ClonedChar:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))
        
        -- Load dance animation
        local AnimationIds = {
            "rbxassetid://3333499508", -- Griddy
            "rbxassetid://3695333486", -- Shoulder Dance
            "rbxassetid://4265725525", -- Shuffle Dance
            "rbxassetid://3361276673"  -- Take the L
        }
        
        local Humanoid = ClonedChar:WaitForChild("Humanoid")
        local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
        
        local Animation = Instance.new("Animation")
        Animation.AnimationId = AnimationIds[math.random(1, #AnimationIds)]
        
        AnimTrack = Animator:LoadAnimation(Animation)
        AnimTrack.Looped = true
        AnimTrack:Play()
        
        -- Dynamic camera movement
        Camera.CFrame = CFrame.new(Vector3.new(0, 1.5, -5), RootPart.Position + Vector3.new(0, 1, 0))
        
        local CameraTime = 0
        CameraConn = RunService.RenderStepped:Connect(function(dt)
            if ClonedChar and ClonedChar.PrimaryPart then
                CameraTime = CameraTime + dt
                local Offset = math.sin(CameraTime * 0.5) * 0.3
                Camera.CFrame = CFrame.new(Vector3.new(Offset, 1.5 + math.sin(CameraTime) * 0.2, -5), RootPart.Position + Vector3.new(0, 1, 0))
            end
        end)
    end)
    
    -- Info labels with particles
    local InfoFrame = Instance.new("Frame")
    InfoFrame.Parent = ContentContainer
    InfoFrame.BackgroundTransparency = 1
    InfoFrame.Position = UDim2.new(0.35, 0, 0.22, 0)
    InfoFrame.Size = UDim2.new(0.6, 0, 0.55, 0)
    
    local function CreateInfoLabel(Text, Order)
        local Container = Instance.new("Frame")
        Container.Parent = InfoFrame
        Container.BackgroundTransparency = 1
        Container.Position = UDim2.new(0, 0, (Order - 1) * 0.25, 0)
        Container.Size = UDim2.new(1, 0, 0.2, 0)
        
        local Accent = Instance.new("Frame")
        Accent.Parent = Container
        Accent.BackgroundColor3 = SelectedTheme.Accent
        Accent.BorderSizePixel = 0
        Accent.Size = UDim2.new(0, 0, 0, 2)
        Accent.Position = UDim2.new(0, 0, 1, -2)
        
        local AccentCorner = Instance.new("UICorner")
        AccentCorner.CornerRadius = UDim.new(1, 0)
        AccentCorner.Parent = Accent
        
        spawn(function()
            task.wait(Order * 0.1)
            TweenService:Create(Accent, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, 2)}):Play()
        end)
        
        local Label = Instance.new("TextLabel")
        Label.Parent = Container
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.Font = Enum.Font.GothamMedium
        Label.Text = Text
        Label.TextColor3 = SelectedTheme.Text
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextTransparency = 1
        
        return Label
    end
    
    local NameLabel = CreateInfoLabel("USER: " .. LocalPlayer.DisplayName, 1)
    local IDLabel = CreateInfoLabel("ID: " .. LocalPlayer.UserId, 2)
    local ClientLabel = CreateInfoLabel("CLIENT: " .. ExecutorName, 3)
    local StatusLabel = CreateInfoLabel("STATUS: Initializing...", 4)
    StatusLabel.TextColor3 = SelectedTheme.Accent
    
    -- Particles for extra flair
    local particlesActive = true
    local function CreateParticles()
        for i = 1, 15 do
            local Particle = Instance.new("Frame")
            Particle.Parent = MainBackground
            Particle.BackgroundColor3 = SelectedTheme.Accent
            Particle.BackgroundTransparency = 0.7
            Particle.BorderSizePixel = 0
            Particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
            Particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
            Particle.ZIndex = 10
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(1, 0)
            Corner.Parent = Particle
            
            spawn(function()
                while particlesActive and Particle.Parent do
                    local NewPos = UDim2.new(math.random(), 0, math.random(), 0)
                    TweenService:Create(Particle, TweenInfo.new(math.random(2, 4), Enum.EasingStyle.Sine), {Position = NewPos}):Play()
                    task.wait(math.random(2, 4))
                end
            end)
        end
    end
    
    -- Sound
    local LoadSound = Instance.new("Sound")
    LoadSound.SoundId = "rbxassetid://6895079853"
    LoadSound.Volume = 0.5
    LoadSound.Parent = LumaGui
    
    pcall(function()
        LoadSound:Play()
    end)
    
    -- Start animations
    TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 15}):Play()
    
    local OpenTween = TweenService:Create(MainBackground, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 520, 0, 280)})
    OpenTween:Play()
    
    spawn(function()
        task.wait(0.3)
        TweenService:Create(GlowFrame, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.9}):Play()
    end)
    
    OpenTween.Completed:Wait()
    
    ContentContainer.Visible = true
    CreateParticles()
    
    local FadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad)
    TweenService:Create(MainStroke, FadeInfo, {Transparency = 0.3}):Play()
    TweenService:Create(TitleLabel, FadeInfo, {TextTransparency = 0}):Play()
    TweenService:Create(TitleShadow, FadeInfo, {TextTransparency = 0.7}):Play()
    TweenService:Create(TitleGlow, FadeInfo, {TextTransparency = 0.8}):Play()
    TweenService:Create(LoadingBarContainer, FadeInfo, {BackgroundTransparency = 0.7}):Play()
    TweenService:Create(BarStroke, FadeInfo, {Transparency = 0.5}):Play()
    TweenService:Create(ViewportContainer, FadeInfo, {BackgroundTransparency = 0.85}):Play()
    TweenService:Create(ViewportStroke, FadeInfo, {Transparency = 0.3}):Play()
    
    for _, lbl in pairs({NameLabel, IDLabel, ClientLabel, StatusLabel}) do
        TweenService:Create(lbl, FadeInfo, {TextTransparency = 0}):Play()
        task.wait(0.15)
    end
    
    -- Loading stages with better animations
    StatusLabel.Text = "STATUS: Loading Scripts..."
    TweenService:Create(LoadingFill, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0.35, 0, 1, 0)}):Play()
    task.wait(1.2)
    
    StatusLabel.Text = "STATUS: Getting Data..."
    TweenService:Create(LoadingFill, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0.75, 0, 1, 0)}):Play()
    task.wait(1)
    
    StatusLabel.Text = "STATUS: Finalizing..."
    TweenService:Create(LoadingFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0.95, 0, 1, 0)}):Play()
    task.wait(0.8)
    
    StatusLabel.Text = "STATUS: Ready!"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    TweenService:Create(LoadingFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(0.8)
    
    -- Close with blur fade
    TweenService:Create(Blur, TweenInfo.new(0.6), {Size = 0}):Play()
    
    local CloseTween = TweenService:Create(MainBackground, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    CloseTween:Play()
    CloseTween.Completed:Wait()
    
    -- Cleanup
    gradientActive = false
    shimmerActive = false
    borderActive = false
    particlesActive = false
    
    if CameraConn then CameraConn:Disconnect() end
    if AnimTrack then AnimTrack:Stop() end
    Blur:Destroy()
    LumaGui:Destroy()
    
    return true
end

-- Direct execution support (for loadstring)
return LumaHub
