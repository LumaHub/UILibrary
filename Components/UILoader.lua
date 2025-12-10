-- SERVICES
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local LumaHub = {}

-- CONFIGURATION CONSTANTS
local UI_SIZE = UDim2.fromOffset(800, 550)
local SIDEBAR_WIDTH = 180
local LOADER_SIZE = UDim2.fromOffset(520, 280)
local TOGGLE_KEY = Enum.KeyCode.RightShift -- Default key to open/close the UI

-- STORE ORIGINALS
local OriginalAmbient = pcall(function() return Lighting.Ambient end) and Lighting.Ambient or Color3.new(0, 0, 0)
local AmbientTween
local AmbientActive = false
local CharacterCleanupTable = {}

-- THEMES (Extending the dark theme professionalism)
local Themes = {
    Crimson = {
        Main = Color3.fromRGB(15, 15, 15),
        Accent = Color3.fromRGB(255, 75, 75),
        Stroke = Color3.fromRGB(30, 30, 30),
        Text = Color3.fromRGB(240, 240, 240),
        SubText = Color3.fromRGB(180, 180, 180),
        Input = Color3.fromRGB(25, 25, 25)
    },
    Ocean = {
        Main = Color3.fromRGB(10, 15, 20),
        Accent = Color3.fromRGB(0, 190, 255),
        Stroke = Color3.fromRGB(20, 30, 40),
        Text = Color3.fromRGB(230, 245, 255),
        SubText = Color3.fromRGB(170, 200, 220),
        Input = Color3.fromRGB(15, 25, 35)
    },
    Dark = { -- Default Theme
        Main = Color3.fromRGB(18, 18, 18),
        Accent = Color3.fromRGB(130, 130, 130), -- Subtle grey accent for professional look
        Stroke = Color3.fromRGB(35, 35, 35),
        Text = Color3.fromRGB(200, 200, 200),
        SubText = Color3.fromRGB(150, 150, 150),
        Input = Color3.fromRGB(25, 25, 25)
    }
}

-- HELPER FUNCTIONS

local function BrightenColor(color, factor)
    local white = Color3.new(1, 1, 1)
    return color:lerp(white, factor)
end

local function Tween(Instance, Goal, Time, EasingStyle, EasingDirection)
    local info = TweenInfo.new(Time or 0.5, EasingStyle or Enum.EasingStyle.Quart, EasingDirection or Enum.EasingDirection.Out)
    return TweenService:Create(Instance, info, Goal):Play()
end

local function Sound(id, volume, parent)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(id)
    sound.Volume = volume or 0.5
    pcall(function() sound.Parent = parent end)
    pcall(function() sound:Play() end)
    return sound
end

-- DYNAMIC AMBIENT LIGHTING EFFECT (More robust)
local function StartAmbientEffect(themeColor)
    AmbientActive = true
    spawn(function()
        pcall(function()
            while AmbientActive do
                local dark = themeColor:Lerp(Color3.fromRGB(0, 0, 0), 0.7)
                Tween(Lighting, {Ambient = dark}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut):Wait()
                Tween(Lighting, {Ambient = themeColor}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut):Wait()
            end
        end)
    end)
end

local function StopAmbientEffect()
    AmbientActive = false
    pcall(function() if AmbientTween then AmbientTween:Cancel() end end)
    pcall(function() Tween(Lighting, {Ambient = OriginalAmbient}, 0.5) end)
end

---------------------------------------------------
--  NOTIFICATION SYSTEM (Cleaned up and separated)
---------------------------------------------------

local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "LumaNotifications"
NotificationGui.DisplayOrder = 100 
NotificationGui.IgnoreGuiInset = true
pcall(function() NotificationGui.Parent = CoreGui end) -- Use generic CoreGui parent

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
    
    -- Stack existing notifications
    for _, item in pairs(NotifContainer:GetChildren()) do
        if item:IsA("Frame") and item.Name == "Notification" and item ~= Notification then
            Tween(item, {Position = item.Position + UDim2.new(0, 0, 0, 90)}, 0.3)
        end
    end

    local Corner = Instance.new("UICorner", Notification)
    Corner.CornerRadius = UDim.new(0, 8)

    local Stroke = Instance.new("UIStroke", Notification)
    Stroke.Thickness = 2
    Stroke.Color = Theme.Stroke
    Stroke.Transparency = 0.5
    
    local AccentBar = Instance.new("Frame", Notification)
    AccentBar.BackgroundColor3 = Theme.Accent
    AccentBar.BorderSizePixel = 0
    AccentBar.Position = UDim2.new(0, 0, 0, 0)
    AccentBar.Size = UDim2.new(0, 3, 1, 0)
    
    local TitleLabel = Instance.new("TextLabel", Notification)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Position = UDim2.new(0, 15, 0, 8)
    TitleLabel.Size = UDim2.new(1, -20, 0.4, 0)
    TitleLabel.TextTransparency = 1 

    local MessageLabel = Instance.new("TextLabel", Notification)
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.Text = Message
    MessageLabel.TextColor3 = Theme.SubText
    MessageLabel.TextSize = 13
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.Position = UDim2.new(0, 15, 0.4, 0)
    MessageLabel.Size = UDim2.new(1, -20, 0.5, 0)
    MessageLabel.TextWrapped = true
    MessageLabel.TextTransparency = 1 

    -- Animate In
    local initialPosition = Notification.Position
    Notification.Position = UDim2.new(0, 300, initialPosition.Y.Offset, 0) 
    
    Tween(Notification, {Position = initialPosition, BackgroundTransparency = 0.05}, 0.5)
    Tween(TitleLabel, {TextTransparency = 0}, 0.5)
    Tween(MessageLabel, {TextTransparency = 0}, 0.5)
    
    Sound(1063273387, 0.5, Notification) -- Notification chime
    
    task.wait(Duration)
    
    -- Animate Out
    Tween(Notification, {Position = UDim2.new(0, 300, initialPosition.Y.Offset, 0), BackgroundTransparency = 1}, 0.5)
    Tween(TitleLabel, {TextTransparency = 1}, 0.5)
    Tween(MessageLabel, {TextTransparency = 1}, 0.5)
    
    task.wait(0.5)
    Notification:Destroy()

    -- Pull remaining notifications up
    local offsetAdjustment = -90
    for _, item in pairs(NotifContainer:GetChildren()) do
        if item:IsA("Frame") and item.Name == "Notification" then
            Tween(item, {Position = item.Position + UDim2.new(0, 0, 0, offsetAdjustment)}, 0.3)
        end
    end
end

---------------------------------------------------
--  LOADER UI FUNCTIONS (UILoader.Load)
---------------------------------------------------

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
    pcall(function() LumaGui.Parent = CoreGui end)

    local Blur = Instance.new("BlurEffect")
    pcall(function() Blur.Size = 0 end)
    pcall(function() Blur.Parent = game.Workspace.CurrentCamera end)

    StartAmbientEffect(SelectedTheme.Accent)

    -- MAIN LOADER FRAME
    local MainBackground = Instance.new("Frame")
    MainBackground.Name = "MainBackground"
    MainBackground.Parent = LumaGui
    MainBackground.AnchorPoint = Vector2.new(0.5, 0.5)
    MainBackground.BackgroundColor3 = SelectedTheme.Main
    MainBackground.BorderSizePixel = 0
    MainBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainBackground.Size = UDim2.new(0, 0, 0, 0) 
    MainBackground.ClipsDescendants = true
    MainBackground.BackgroundTransparency = 1 
    
    local MainCorner = Instance.new("UICorner", MainBackground)
    MainCorner.CornerRadius = UDim.new(0, 12)
    
    local MainStroke = Instance.new("UIStroke", MainBackground)
    MainStroke.Thickness = 2
    MainStroke.Color = SelectedTheme.Stroke
    MainStroke.Transparency = 1
    
    -- Animated gradient (ColorSequence check for error fix)
    local BackgroundGradient = Instance.new("UIGradient", MainBackground)
    BackgroundGradient.Rotation = 45
    BackgroundGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, SelectedTheme.Main),
        ColorSequenceKeypoint.new(0.5, BrightenColor(SelectedTheme.Main, 0.15)), 
        ColorSequenceKeypoint.new(1, SelectedTheme.Main)
    })
    
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
    local GlowFrame = Instance.new("Frame", MainBackground)
    GlowFrame.Name = "Glow"
    GlowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    GlowFrame.BackgroundColor3 = SelectedTheme.Glow
    GlowFrame.BackgroundTransparency = 1 
    GlowFrame.BorderSizePixel = 0
    GlowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    GlowFrame.Size = UDim2.new(1.1, 0, 1.1, 0)
    GlowFrame.ZIndex = 0
    
    local GlowCorner = Instance.new("UICorner", GlowFrame)
    GlowCorner.CornerRadius = UDim.new(0, 12)
    
    local ContentContainer = Instance.new("Frame", MainBackground)
    ContentContainer.Name = "Content"
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Size = UDim2.new(1, 0, 1, 0)
    ContentContainer.Visible = false
    ContentContainer.ZIndex = 2
    
    -- Title elements
    local TitleLabel = Instance.new("TextLabel", ContentContainer)
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
    
    -- Animated loading bar
    local LoadingBarContainer = Instance.new("Frame", ContentContainer)
    LoadingBarContainer.BackgroundColor3 = SelectedTheme.Input
    LoadingBarContainer.BorderSizePixel = 0
    LoadingBarContainer.Position = UDim2.new(0.05, 0, 0.85, 0)
    LoadingBarContainer.Size = UDim2.new(0.9, 0, 0.03, 0)
    LoadingBarContainer.BackgroundTransparency = 1 
    
    local BarCorner = Instance.new("UICorner", LoadingBarContainer)
    BarCorner.CornerRadius = UDim.new(1, 0)
    
    local BarStroke = Instance.new("UIStroke", LoadingBarContainer)
    BarStroke.Thickness = 1
    BarStroke.Color = SelectedTheme.Stroke
    BarStroke.Transparency = 1
    
    local LoadingFill = Instance.new("Frame", LoadingBarContainer)
    LoadingFill.BackgroundColor3 = SelectedTheme.Accent
    LoadingFill.BorderSizePixel = 0
    LoadingFill.Size = UDim2.new(0, 0, 1, 0)
    
    local FillCorner = Instance.new("UICorner", LoadingFill)
    FillCorner.CornerRadius = UDim.new(1, 0)
    
    local FillGradient = Instance.new("UIGradient", LoadingFill)
    FillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, SelectedTheme.Accent),
        ColorSequenceKeypoint.new(0.5, BrightenColor(SelectedTheme.Accent, 0.1)), 
        ColorSequenceKeypoint.new(1, SelectedTheme.Accent)
    })
    
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
    
    -- ViewportFrame Container
    local ViewportContainer = Instance.new("Frame", ContentContainer)
    ViewportContainer.BackgroundColor3 = SelectedTheme.Input
    ViewportContainer.BackgroundTransparency = 1 
    ViewportContainer.Position = UDim2.new(0.05, 0, 0.22, 0)
    ViewportContainer.Size = UDim2.new(0.25, 0, 0.55, 0)
    
    local ViewportCorner = Instance.new("UICorner", ViewportContainer)
    ViewportCorner.CornerRadius = UDim.new(0, 10)
    
    local ViewportStroke = Instance.new("UIStroke", ViewportContainer)
    ViewportStroke.Thickness = 2
    ViewportStroke.Color = SelectedTheme.Accent
    ViewportStroke.Transparency = 1
    
    local ViewportGradient = Instance.new("UIGradient", ViewportStroke)
    ViewportGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, SelectedTheme.Accent),
        ColorSequenceKeypoint.new(0.5, SelectedTheme.Stroke),
        ColorSequenceKeypoint.new(1, SelectedTheme.Accent)
    })
    
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
    
    local AvatarView = Instance.new("ViewportFrame", ViewportContainer)
    AvatarView.BackgroundTransparency = 1
    AvatarView.Size = UDim2.new(1, 0, 1, 0)
    AvatarView.Ambient = Color3.fromRGB(255, 255, 255)
    AvatarView.LightColor = BrightenColor(SelectedTheme.Accent, 0.2)
    AvatarView.LightDirection = Vector3.new(0, -1, -1)
    
    local WorldModel = Instance.new("WorldModel", AvatarView)
    local Camera = Instance.new("Camera", AvatarView)
    AvatarView.CurrentCamera = Camera
    
    local AnimTrack, CameraConn
    
    -- ROBUST AVATAR LOADING
    spawn(function()
        local success, char = pcall(function()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local clone = character:Clone()
            return clone
        end)

        if success and char and char:FindFirstChild("HumanoidRootPart") then
            local ClonedChar = char
            ClonedChar.Parent = WorldModel
            table.insert(CharacterCleanupTable, ClonedChar)
            
            local RootPart = ClonedChar:WaitForChild("HumanoidRootPart")
            RootPart.Anchored = true
            ClonedChar:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))
            
            local Humanoid = ClonedChar:WaitForChild("Humanoid")
            local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
            
            local Animation = Instance.new("Animation")
            Animation.AnimationId = "rbxassetid://3695333486" -- Safe default
            
            pcall(function()
                AnimTrack = Animator:LoadAnimation(Animation)
                if AnimTrack then 
                    AnimTrack.Looped = true
                    AnimTrack:Play()
                end
            end)
            
            Camera.CFrame = CFrame.new(Vector3.new(0, 1.5, -5), RootPart.Position + Vector3.new(0, 1, 0))
            
            -- Initial 360 rotation (Improved, more reliable tween)
            Tween(RootPart, {CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(360), 0)}, 1.5, Enum.EasingStyle.Quart)
            
            local CameraTime = 0
            CameraConn = RunService.RenderStepped:Connect(function(dt)
                if ClonedChar and ClonedChar.PrimaryPart then
                    CameraTime = CameraTime + dt
                    local Offset = math.sin(CameraTime * 0.5) * 0.3
                    Camera.CFrame = CFrame.new(Vector3.new(Offset, 1.5 + math.sin(CameraTime) * 0.2, -5), RootPart.Position + Vector3.new(0, 1, 0))
                end
            end)
        else
             -- Fallback text if avatar fails to load
            local FailLabel = Instance.new("TextLabel", ViewportContainer)
            FailLabel.Text = "Avatar Failed to Load"
            FailLabel.TextColor3 = Color3.fromRGB(200, 50, 50)
            FailLabel.BackgroundTransparency = 1
            FailLabel.Size = UDim2.new(1, 0, 1, 0)
            FailLabel.Font = Enum.Font.Gotham
        end
    end)
    
    -- Info Labels
    local InfoFrame = Instance.new("Frame", ContentContainer)
    InfoFrame.BackgroundTransparency = 1
    InfoFrame.Position = UDim2.new(0.35, 0, 0.22, 0)
    InfoFrame.Size = UDim2.new(0.6, 0, 0.55, 0)
    
    local function CreateInfoLabel(Text, Order)
        local Container = Instance.new("Frame")
        Container.Parent = InfoFrame
        Container.BackgroundTransparency = 1
        Container.Position = UDim2.new(0, 0, (Order - 1) * 0.25, 0)
        Container.Size = UDim2.new(1, 0, 0.2, 0)
        
        local Accent = Instance.new("Frame", Container)
        Accent.BackgroundColor3 = SelectedTheme.Accent
        Accent.BorderSizePixel = 0
        Accent.Size = UDim2.new(0, 0, 0, 1) -- Thinner line for professionalism
        Accent.Position = UDim2.new(0, 0, 1, -1)
        
        local AccentCorner = Instance.new("UICorner", Accent)
        AccentCorner.CornerRadius = UDim.new(1, 0)
        
        spawn(function()
            task.wait(Order * 0.1)
            Tween(Accent, {Size = UDim2.new(1, 0, 0, 1)}, 0.5)
        end)
        
        local Label = Instance.new("TextLabel", Container)
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
            local Particle = Instance.new("Frame", MainBackground)
            Particle.BackgroundColor3 = SelectedTheme.Accent
            Particle.BackgroundTransparency = 1 
            Particle.BorderSizePixel = 0
            Particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
            Particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
            Particle.ZIndex = 10
            
            local Corner = Instance.new("UICorner", Particle)
            Corner.CornerRadius = UDim.new(1, 0)
            
            spawn(function()
                Tween(Particle, {BackgroundTransparency = 0.7}, 0.5)
                while particlesActive and Particle.Parent do
                    local NewPos = UDim2.new(math.random(), 0, math.random(), 0)
                    Tween(Particle, {Position = NewPos}, math.random(2, 4), Enum.EasingStyle.Sine)
                    task.wait(math.random(2, 4))
                end
            end)
        end
    end
    
    Sound(600200877, 0.3, LumaGui) -- UI Open Chime (Lower volume)
    
    -- 1. INITIAL OPENING TWEEN (SMOOTH SIZE AND FADE)
    pcall(function() Tween(Blur, {Size = 15}, 0.5) end)
    
    local OpenTween = Tween(MainBackground, {
        Size = LOADER_SIZE,
        BackgroundTransparency = 0 -- Fully visible
    }, 0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    spawn(function()
        task.wait(0.3)
        Tween(GlowFrame, {BackgroundTransparency = 0.7}, 1.5)
    end)
    
    OpenTween.Completed:Wait()
    
    ContentContainer.Visible = true
    CreateParticles()
    
    -- 2. CONTENT FADE IN
    local FadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart)
    
    TweenService:Create(MainStroke, FadeInfo, {Transparency = 0.3}):Play()
    TweenService:Create(ViewportContainer, FadeInfo, {BackgroundTransparency = 0.05}):Play()
    TweenService:Create(ViewportStroke, FadeInfo, {Transparency = 0.3}):Play()

    TweenService:Create(TitleLabel, FadeInfo, {TextTransparency = 0}):Play()
    TweenService:Create(LoadingBarContainer, FadeInfo, {BackgroundTransparency = 0.7}):Play()
    TweenService:Create(BarStroke, FadeInfo, {Transparency = 0.5}):Play()
    task.wait(0.1)

    for _, lbl in pairs({NameLabel, IDLabel, ClientLabel, StatusLabel}) do
        TweenService:Create(lbl, FadeInfo, {TextTransparency = 0}):Play()
        task.wait(0.05)
    end
    
    -- 3. LOADING STAGES
    StatusLabel.Text = "STATUS: Loading Core Modules..."
    Tween(LoadingFill, {Size = UDim2.new(0.35, 0, 1, 0)}, 1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    task.wait(1.2)
    Sound(1063273387, 0.4, LumaGui) -- Stage Complete

    StatusLabel.Text = "STATUS: Initializing Components..."
    Tween(LoadingFill, {Size = UDim2.new(0.75, 0, 1, 0)}, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    task.wait(1)
    Sound(1063273387, 0.4, LumaGui)

    StatusLabel.Text = "STATUS: Injecting Hooks & Finalizing..."
    Tween(LoadingFill, {Size = UDim2.new(0.95, 0, 1, 0)}, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    task.wait(0.8)
    
    StatusLabel.Text = "STATUS: READY!"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    Tween(LoadingFill, {Size = UDim2.new(1, 0, 1, 0)}, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    Sound(4488899884, 0.8, LumaGui) -- Ready Chime

    LumaHub.Notify("LumaHub Loaded", "Welcome! Press Right Shift to toggle.", 4, Settings.Theme or "Dark")

    task.wait(0.8)
    
    -- 4. CLOSING TWEEN (PROFESSIONAL FADE OUT)
    
    -- Fade out content/loader box
    local CloseFadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart)
    
    TweenService:Create(ContentContainer, CloseFadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(MainBackground, CloseFadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(MainStroke, CloseFadeInfo, {Transparency = 1}):Play()
    TweenService:Create(GlowFrame, CloseFadeInfo, {BackgroundTransparency = 1}):Play()
    
    Sound(600201103, 0.5, LumaGui) -- UI Close
    
    task.wait(0.5) 
    
    -- Shrink the main frame (smooth transition)
    Tween(MainBackground, {Size = UDim2.new(0, 0, 0, 0)}, 0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In):Wait()
    
    -- Cleanup Loader
    gradientActive = false
    shimmerActive = false
    borderActive = false
    particlesActive = false
    
    pcall(function() if CameraConn then CameraConn:Disconnect() end end)
    pcall(function() if AnimTrack then AnimTrack:Stop() end end)
    for _, item in pairs(CharacterCleanupTable) do pcall(function() item:Destroy() end) end
    
    pcall(function() Blur:Destroy() end)
    LumaGui:Destroy()
    
    -- NOW INITIALIZE THE MAIN UI
    local MainUI = LumaHub.CreateMainUI(SelectedTheme)
    
    -- Toggle Logic
    local IsOpen = false
    local function ToggleUI()
        IsOpen = not IsOpen
        if IsOpen then
            pcall(function() Tween(MainUI.Blur, {Size = 10}, 0.3) end)
            Tween(MainUI.Container, {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.4)
            Sound(600200877, 0.3, MainUI.Gui)
        else
            pcall(function() Tween(MainUI.Blur, {Size = 0}, 0.3) end)
            Tween(MainUI.Container, {Position = UDim2.new(0.5, 0, 0.5, 50)}, 0.4) -- Slight drop effect
            Sound(600201103, 0.3, MainUI.Gui)
        end
        MainUI.Container.Active = IsOpen
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == TOGGLE_KEY and not gameProcessed then
            ToggleUI()
        end
    end)
    
    return LumaHub 
end


---------------------------------------------------
--  MAIN UI STRUCTURE (Core UI - ~700 Lines)
---------------------------------------------------

function LumaHub.CreateMainUI(Theme)
    
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "LumaHub_MainUI"
    Gui.IgnoreGuiInset = true
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() Gui.Parent = CoreGui end)

    local Blur = Instance.new("BlurEffect")
    pcall(function() Blur.Size = 0 end)
    pcall(function() Blur.Parent = game.Workspace.CurrentCamera end)

    local Container = Instance.new("Frame", Gui)
    Container.Name = "MainContainer"
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.Position = UDim2.new(0.5, 0, 0.5, 50) -- Start slightly off-screen for toggle drop effect
    Container.Size = UI_SIZE
    Container.BackgroundColor3 = Theme.Main
    Container.BackgroundTransparency = 0.05
    Container.BorderSizePixel = 0
    Container.Active = false -- Hidden initially
    
    local Corner = Instance.new("UICorner", Container)
    Corner.CornerRadius = UDim.new(0, 15)
    
    local Stroke = Instance.new("UIStroke", Container)
    Stroke.Thickness = 2
    Stroke.Color = Theme.Stroke
    Stroke.Transparency = 0.1
    
    -- UI Gradient effect
    local UIGrad = Instance.new("UIGradient", Container)
    UIGrad.Rotation = 90
    UIGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Main),
        ColorSequenceKeypoint.new(0.01, BrightenColor(Theme.Main, 0.05)),
        ColorSequenceKeypoint.new(1, Theme.Main)
    })

    -- 1. SIDEBAR (Navigation/Tabs)
    local Sidebar = Instance.new("Frame", Container)
    Sidebar.Name = "Sidebar"
    Sidebar.BackgroundColor3 = BrightenColor(Theme.Main, 0.05)
    Sidebar.BackgroundTransparency = 0
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 0)
    Sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 1, 0)
    Sidebar.ClipsDescendants = true
    
    local SidebarStroke = Instance.new("UIStroke", Sidebar)
    SidebarStroke.Thickness = 1
    SidebarStroke.Color = Theme.Stroke
    SidebarStroke.Transparency = 0.5
    SidebarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Padding = Instance.new("UIPadding", Sidebar)
    Padding.PaddingTop = UDim.new(0, 10)
    Padding.PaddingBottom = UDim.new(0, 10)
    
    local List = Instance.new("UIListLayout", Sidebar)
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.Padding = UDim.new(0, 5)
    List.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- Sidebar Title
    local SidebarTitle = Instance.new("TextLabel", Sidebar)
    SidebarTitle.Text = "LUMA HUB"
    SidebarTitle.Font = Enum.Font.GothamBold
    SidebarTitle.TextColor3 = Theme.Accent
    SidebarTitle.TextSize = 18
    SidebarTitle.BackgroundTransparency = 1
    SidebarTitle.Size = UDim2.new(1, 0, 0, 30)
    SidebarTitle.LayoutOrder = 0
    
    -- Tab data storage
    local TabButtons = {}
    local TabPages = {}
    local ActiveTab = nil
    
    local function CreateTab(Name, Icon, LayoutOrder)
        -- Button
        local Button = Instance.new("TextButton", Sidebar)
        Button.Name = Name .. "Button"
        Button.Text = "  " .. Name
        Button.Font = Enum.Font.GothamMedium
        Button.TextColor3 = Theme.SubText
        Button.TextSize = 16
        Button.TextXAlignment = Enum.TextXAlignment.Left
        Button.BackgroundColor3 = Theme.Main
        Button.BackgroundTransparency = 1
        Button.Size = UDim2.new(0.9, 0, 0, 35)
        Button.LayoutOrder = LayoutOrder
        
        -- Accent Indicator
        local Indicator = Instance.new("Frame", Button)
        Indicator.Name = "Indicator"
        Indicator.Size = UDim2.new(0, 3, 1, 0)
        Indicator.BackgroundColor3 = Theme.Accent
        Indicator.BackgroundTransparency = 1 -- Hidden initially
        
        -- Page
        local Page = Instance.new("Frame", Content)
        Page.Name = Name .. "Page"
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        
        table.insert(TabButtons, Button)
        TabPages[Name] = Page
        
        -- Activation Logic
        local function SelectTab()
            if ActiveTab == Name then return end

            -- Deactivate previous tab
            if ActiveTab then
                Tween(TabButtons[ActiveTab].Indicator, {BackgroundTransparency = 1}, 0.2)
                TabButtons[ActiveTab].TextColor3 = Theme.SubText
                TabPages[ActiveTab].Visible = false
            end
            
            -- Activate new tab
            ActiveTab = Name
            Tween(Indicator, {BackgroundTransparency = 0}, 0.2)
            Button.TextColor3 = Theme.Text
            Page.Visible = true
            Sound(600201103, 0.3, Button) -- Subtle select sound
        end
        
        Button.MouseButton1Click:Connect(SelectTab)

        -- Initial setup to store button by name
        TabButtons[Name] = Button
        
        return {Button = Button, Page = Page, Select = SelectTab}
    end

    -- 2. CONTENT AREA (Tabs go here)
    local Content = Instance.new("Frame", Container)
    Content.Name = "ContentArea"
    Content.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.Position = UDim2.new(0, SIDEBAR_WIDTH, 0, 0)
    Content.Size = UDim2.new(1, -SIDEBAR_WIDTH, 1, 0)
    
    -- Padding for Content Area
    local ContentPadding = Instance.new("UIPadding", Content)
    ContentPadding.PaddingLeft = UDim.new(0, 15)
    ContentPadding.PaddingTop = UDim.new(0, 15)
    ContentPadding.PaddingRight = UDim.new(0, 15)
    ContentPadding.PaddingBottom = UDim.new(0, 15)
    
    -- Content List Layout (for modules)
    local ContentList = Instance.new("UIListLayout", Content)
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 10)
    ContentList.FillDirection = Enum.FillDirection.Vertical
    ContentList.HorizontalAlignment = Enum.HorizontalAlignment.Left
    
    -- Add Default Tabs
    local Toggles = CreateTab("Toggles", nil, 1)
    local Combat = CreateTab("Combat", nil, 2)
    local Player = CreateTab("Player", nil, 3)
    local Movement = CreateTab("Movement", nil, 4)
    local Settings = CreateTab("Settings", nil, 99)
    
    -- Automatically select the first tab
    task.spawn(function()
        task.wait(0.1)
        Toggles.Select()
    end)
    
    -- Example Module structure for the Toggles Tab
    local ExampleSection = Instance.new("Frame", Toggles.Page)
    ExampleSection.Name = "ModuleSection"
    ExampleSection.BackgroundColor3 = BrightenColor(Theme.Main, 0.1)
    ExampleSection.BackgroundTransparency = 0.1
    ExampleSection.Size = UDim2.new(1, 0, 0, 150)
    
    local SectionCorner = Instance.new("UICorner", ExampleSection)
    SectionCorner.CornerRadius = UDim.new(0, 8)
    
    local Title = Instance.new("TextLabel", ExampleSection)
    Title.Text = "Example Module Section"
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Theme.Text
    Title.TextSize = 14
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Position = UDim2.new(0, 10, 0, 5)
    
    -- The Main UI component table
    local UI = {
        Gui = Gui,
        Container = Container,
        Blur = Blur,
        Theme = Theme,
        Tabs = {Toggles = Toggles.Page, Combat = Combat.Page, Settings = Settings.Page},
        Modules = {}, -- Where external module creators will add their content
        Toggle = nil -- Placeholder for toggle function
    }
    
    return UI
end

-- Return the LumaHub TABLE (contains Load, Notify, and CreateMainUI)
return LumaHub
