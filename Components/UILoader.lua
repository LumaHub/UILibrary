local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local LumaHub = {}

-- Store original ambient color for restoration, checking if Lighting is accessible
local OriginalAmbient = pcall(function() return Lighting.Ambient end) and Lighting.Ambient or Color3.new(0, 0, 0)
local AmbientTween
local AmbientActive = false

-- Helper function to safely brighten a color by lerping towards white (0-1 range safe)
local function BrightenColor(color, factor)
    local white = Color3.new(1, 1, 1)
    return color:lerp(white, factor)
end

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
    Dark = { -- Default Theme
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

-- Dynamic Ambient Effect (Added pcall for executor compatibility)
local function StartAmbientEffect(themeColor)
    AmbientActive = true
    spawn(function()
        pcall(function() -- Wrap in pcall for environments that block Lighting access
            while AmbientActive do
                -- Tween 1: Darken slightly
                AmbientTween = TweenService:Create(Lighting, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Ambient = themeColor:Lerp(Color3.fromRGB(0, 0, 0), 0.7)
                })
                AmbientTween:Play()
                AmbientTween.Completed:Wait()

                -- Tween 2: Return to theme color
                AmbientTween = TweenService:Create(Lighting, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Ambient = themeColor
                })
                AmbientTween:Play()
                AmbientTween.Completed:Wait()
            end
        end)
    end)
end

local function StopAmbientEffect()
    AmbientActive = false
    if AmbientTween then pcall(function() AmbientTween:Cancel() end) end
    -- Restore original ambient color smoothly
    pcall(function()
        TweenService:Create(Lighting, TweenInfo.new(0.5), {Ambient = OriginalAmbient}):Play()
    end)
end

-- Notification System Setup
local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "LumaNotifications"
NotificationGui.DisplayOrder = 100 
NotificationGui.IgnoreGuiInset = true

if gethui then
    NotificationGui.Parent = gethui()
elseif syn and syn.protect_gui then 
    syn.protect_gui(NotificationGui)
    NotificationGui.Parent = CoreGui
else
    NotificationGui.Parent = CoreGui
end

local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "Container"
NotifContainer.Parent = NotificationGui
NotifContainer.AnchorPoint = Vector2.new(1, 0)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Position = UDim2.new(1, -20, 0, 20)
NotifContainer.Size = UDim2.new(0, 250, 0, 0) 

function LumaHub.Notify(Title, Message, Duration, ThemeKey)
    local Theme = Themes[ThemeKey] or Themes.Dark
    Duration = Duration or 5
    
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Parent = NotifContainer
    Notification.AnchorPoint = Vector2.new(0, 0) 
    Notification.BackgroundColor3 = Theme.Main
    Notification.BorderSizePixel = 0
    Notification.Position = UDim2.new(0, 0, 0, 0)
    Notification.Size = UDim2.new(1, 0, 0, 80)
    Notification.BackgroundTransparency = 1 

    for _, item in pairs(NotifContainer:GetChildren()) do
        if item:IsA("Frame") and item.Name == "Notification" and item ~= Notification then
            TweenService:Create(item, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = item.Position + UDim2.new(0, 0, 0, 90)}):Play()
        end
    end

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Notification

    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = Notification
    Stroke.Thickness = 2
    Stroke.Color = Theme.Stroke
    Stroke.Transparency = 0.5
    
    local AccentBar = Instance.new("Frame")
    AccentBar.Parent = Notification
    AccentBar.BackgroundColor3 = Theme.Accent
    AccentBar.BorderSizePixel = 0
    AccentBar.Position = UDim2.new(0, 0, 0, 0)
    AccentBar.Size = UDim2.new(0, 5, 1, 0)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = Notification
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Position = UDim2.new(0, 15, 0, 8)
    TitleLabel.Size = UDim2.new(1, -20, 0.4, 0)
    TitleLabel.TextTransparency = 1 

    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Parent = Notification
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.Text = Message
    MessageLabel.TextColor3 = BrightenColor(Theme.Text, 0.2)
    MessageLabel.TextSize = 13
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.Position = UDim2.new(0, 15, 0.4, 0)
    MessageLabel.Size = UDim2.new(1, -20, 0.5, 0)
    MessageLabel.TextWrapped = true
    MessageLabel.TextTransparency = 1 

    -- Animate In
    local initialPosition = Notification.Position
    Notification.Position = UDim2.new(0, 300, initialPosition.Y.Offset, 0) 
    
    TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = initialPosition,
        BackgroundTransparency = 0.05 -- Use a very low transparency for visibility
    }):Play()
    
    TweenService:Create(TitleLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(MessageLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    
    local NotifSound = Instance.new("Sound")
    NotifSound.SoundId = "rbxassetid://1063273387" 
    NotifSound.Volume = 0.5
    NotifSound.Parent = Notification
    pcall(function() NotifSound:Play() end)

    task.wait(Duration)
    
    -- Animate Out
    TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = UDim2.new(0, 300, initialPosition.Y.Offset, 0),
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(TitleLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(MessageLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    
    task.wait(0.5)
    Notification:Destroy()

    local offsetAdjustment = -90
    for _, item in pairs(NotifContainer:GetChildren()) do
        if item:IsA("Frame") and item.Name == "Notification" then
            TweenService:Create(item, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = item.Position + UDim2.new(0, 0, 0, offsetAdjustment)}):Play()
        end
    end
end

function LumaHub.Load(Settings)
    Settings = Settings or {}
    local SelectedTheme = Themes[Settings.Theme] or Themes.Dark
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
    
    local Blur = Instance.new("BlurEffect")
    pcall(function() Blur.Size = 0 end) -- Wrap Blur manipulation in pcall
    pcall(function() Blur.Parent = game.Workspace.CurrentCamera end)

    StartAmbientEffect(SelectedTheme.Accent)

    -- Main Background Frame (Set fixed BackgroundColor3 for reliability)
    local MainBackground = Instance.new("Frame")
    MainBackground.Name = "MainBackground"
    MainBackground.Parent = LumaGui
    MainBackground.AnchorPoint = Vector2.new(0.5, 0.5)
    MainBackground.BackgroundColor3 = SelectedTheme.Main -- Use the theme's main color directly
    MainBackground.BorderSizePixel = 0
    MainBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainBackground.Size = UDim2.new(0, 0, 0, 0) 
    MainBackground.ClipsDescendants = true
    MainBackground.BackgroundTransparency = 1 
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainBackground
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainBackground
    MainStroke.Thickness = 2
    MainStroke.Color = SelectedTheme.Stroke
    MainStroke.Transparency = 1
    
    local BackgroundGradient = Instance.new("UIGradient")
    BackgroundGradient.Rotation = 45
    BackgroundGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, SelectedTheme.Main),
        ColorSequenceKeypoint.new(0.5, BrightenColor(SelectedTheme.Main, 0.15)), 
        ColorSequenceKeypoint.new(1, SelectedTheme.Main)
    })
    BackgroundGradient.Parent = MainBackground
    
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
    GlowFrame.BackgroundTransparency = 1 
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
    
    -- Title elements
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
    TitleShadow.TextTransparency = 1 
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
    TitleGlow.TextTransparency = 1 
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
    
    local FillGradient = Instance.new("UIGradient")
    FillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, SelectedTheme.Accent),
        ColorSequenceKeypoint.new(0.5, BrightenColor(SelectedTheme.Accent, 0.1)), 
        ColorSequenceKeypoint.new(1, SelectedTheme.Accent)
    })
    FillGradient.Parent = LoadingFill
    
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
    
    -- ViewportFrame
    local ViewportContainer = Instance.new("Frame")
    ViewportContainer.Parent = ContentContainer
    ViewportContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ViewportContainer.BackgroundTransparency = 1 
    ViewportContainer.Position = UDim2.new(0.05, 0, 0.22, 0)
    ViewportContainer.Size = UDim2.new(0.25, 0, 0.55, 0)
    
    local ViewportCorner = Instance.new("UICorner")
    ViewportCorner.CornerRadius = UDim.new(0, 10)
    ViewportCorner.Parent = ViewportContainer
    
    local ViewportStroke = Instance.new("UIStroke")
    ViewportStroke.Parent = ViewportContainer
    ViewportStroke.Thickness = 2
    ViewportStroke.Color = SelectedTheme.Accent
    ViewportStroke.Transparency = 1
    
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
    
    local ClonedChar, AnimTrack, CameraConn
    
    -- IMPROVED: Robust ViewportFrame Character Loading
    spawn(function()
        local success, char = pcall(function()
            -- Wait longer for the character to ensure it's loaded
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local success, clone = pcall(function() return character:Clone() end)
            if success then
                return clone
            else
                return nil
            end
        end)

        if success and char and char:FindFirstChild("HumanoidRootPart") then
            ClonedChar = char
            ClonedChar.Parent = WorldModel
            
            local RootPart = ClonedChar:WaitForChild("HumanoidRootPart")
            RootPart.Anchored = true
            ClonedChar:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))
            
            local Humanoid = ClonedChar:WaitForChild("Humanoid")
            local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
            
            local Animation = Instance.new("Animation")
            Animation.AnimationId = "rbxassetid://3695333486" 
            
            pcall(function()
                AnimTrack = Animator:LoadAnimation(Animation)
                if AnimTrack then 
                    AnimTrack.Looped = true
                    AnimTrack:Play()
                end
            end)
            
            Camera.CFrame = CFrame.new(Vector3.new(0, 1.5, -5), RootPart.Position + Vector3.new(0, 1, 0))
            
            -- Initial 360 rotation (Guaranteed to run once the character is ready)
            TweenService:Create(RootPart, TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(360), 0)
            }):Play()
            
            local CameraTime = 0
            CameraConn = RunService.RenderStepped:Connect(function(dt)
                if ClonedChar and ClonedChar.PrimaryPart then
                    CameraTime = CameraTime + dt
                    local Offset = math.sin(CameraTime * 0.5) * 0.3
                    Camera.CFrame = CFrame.new(Vector3.new(Offset, 1.5 + math.sin(CameraTime) * 0.2, -5), RootPart.Position + Vector3.new(0, 1, 0))
                end
            end)
        end
    end)
    
    -- Info Labels
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
    
    local particlesActive = true
    local function CreateParticles()
        for i = 1, 15 do
            local Particle = Instance.new("Frame")
            Particle.Parent = MainBackground
            Particle.BackgroundColor3 = SelectedTheme.Accent
            Particle.BackgroundTransparency = 1 
            Particle.BorderSizePixel = 0
            Particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
            Particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
            Particle.ZIndex = 10
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(1, 0)
            Corner.Parent = Particle
            
            spawn(function()
                TweenService:Create(Particle, TweenInfo.new(0.5), {BackgroundTransparency = 0.7}):Play()
                while particlesActive and Particle.Parent do
                    local NewPos = UDim2.new(math.random(), 0, math.random(), 0)
                    TweenService:Create(Particle, TweenInfo.new(math.random(2, 4), Enum.EasingStyle.Sine), {Position = NewPos}):Play()
                    task.wait(math.random(2, 4))
                end
            end)
        end
    end
    
    -- Sound Effect: UI Open Chime
    local OpenSound = Instance.new("Sound")
    OpenSound.SoundId = "rbxassetid://600200877" 
    OpenSound.Volume = 0.5 
    OpenSound.Parent = LumaGui
    pcall(function() OpenSound:Play() end)
    
    -- 1. INITIAL OPENING TWEEN (SMOOTH SIZE AND FADE)
    pcall(function() TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 15}):Play() end)
    
    local OpenTween = TweenService:Create(MainBackground, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 520, 0, 280),
        BackgroundTransparency = 0 -- Fade to fully visible background color
    })
    OpenTween:Play()
    
    spawn(function()
        task.wait(0.3)
        TweenService:Create(GlowFrame, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.7}):Play()
    end)
    
    OpenTween.Completed:Wait()
    
    ContentContainer.Visible = true
    CreateParticles()
    
    -- 2. CONTENT FADE IN
    local FadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart)
    
    TweenService:Create(MainStroke, FadeInfo, {Transparency = 0.3}):Play()
    TweenService:Create(ViewportContainer, FadeInfo, {BackgroundTransparency = 0.9}):Play()
    TweenService:Create(ViewportStroke, FadeInfo, {Transparency = 0.3}):Play()

    -- Staggered text fade-in
    TweenService:Create(TitleLabel, FadeInfo, {TextTransparency = 0}):Play()
    TweenService:Create(TitleShadow, FadeInfo, {TextTransparency = 0.7}):Play()
    TweenService:Create(TitleGlow, FadeInfo, {TextTransparency = 0.8}):Play()
    task.wait(0.1)

    TweenService:Create(LoadingBarContainer, FadeInfo, {BackgroundTransparency = 0.7}):Play()
    TweenService:Create(BarStroke, FadeInfo, {Transparency = 0.5}):Play()
    task.wait(0.1)

    for _, lbl in pairs({NameLabel, IDLabel, ClientLabel, StatusLabel}) do
        TweenService:Create(lbl, FadeInfo, {TextTransparency = 0}):Play()
        task.wait(0.1)
    end
    
    -- 3. LOADING STAGES
    StatusLabel.Text = "STATUS: Loading Scripts..."
    TweenService:Create(LoadingFill, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0.35, 0, 1, 0)}):Play()
    task.wait(1.2)
    
    local StageSound = Instance.new("Sound")
    StageSound.SoundId = "rbxassetid://1063273387" 
    StageSound.Volume = 0.4
    StageSound.Parent = LumaGui
    pcall(function() StageSound:Play() end)

    StatusLabel.Text = "STATUS: Getting Data..."
    TweenService:Create(LoadingFill, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0.75, 0, 1, 0)}):Play()
    task.wait(1)

    pcall(function() StageSound:Play() end)
    
    StatusLabel.Text = "STATUS: Finalizing..."
    TweenService:Create(LoadingFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0.95, 0, 1, 0)}):Play()
    task.wait(0.8)
    
    StatusLabel.Text = "STATUS: Ready!"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    TweenService:Create(LoadingFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()

    local ReadySound = Instance.new("Sound")
    ReadySound.SoundId = "rbxassetid://4488899884" 
    ReadySound.Volume = 0.8
    ReadySound.Parent = LumaGui
    pcall(function() ReadySound:Play() end)

    LumaHub.Notify("LumaHub Loaded", "Welcome, " .. LocalPlayer.DisplayName .. "! Core UI Initialized.", 4, Settings.Theme or "Dark")

    task.wait(0.8)
    
    -- 4. CLOSING TWEEN (PROFESSIONAL FADE OUT)
    StopAmbientEffect() 
    pcall(function() TweenService:Create(Blur, TweenInfo.new(0.6), {Size = 0}):Play() end)
    
    -- Fade out all content completely first
    local CloseFadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart)
    
    TweenService:Create(ContentContainer, CloseFadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(MainBackground, CloseFadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(MainStroke, CloseFadeInfo, {Transparency = 1}):Play()
    TweenService:Create(GlowFrame, CloseFadeInfo, {BackgroundTransparency = 1}):Play()
    
    local CloseSound = Instance.new("Sound")
    CloseSound.SoundId = "rbxassetid://600201103" 
    CloseSound.Volume = 0.5 
    CloseSound.Parent = LumaGui
    pcall(function() CloseSound:Play() end)
    
    task.wait(0.5) 
    
    -- Then shrink the main frame (smooth transition)
    local CloseTween = TweenService:Create(MainBackground, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    CloseTween:Play()
    CloseTween.Completed:Wait()
    
    -- Cleanup
    gradientActive = false
    shimmerActive = false
    borderActive = false
    particlesActive = false
    
    if CameraConn then pcall(function() CameraConn:Disconnect() end) end
    if AnimTrack then pcall(function() AnimTrack:Stop() end) end
    
    pcall(function() Blur:Destroy() end)
    LumaGui:Destroy()
    
    return LumaHub 
end

-- Return the LumaHub TABLE (contains Load and Notify)
return LumaHub
