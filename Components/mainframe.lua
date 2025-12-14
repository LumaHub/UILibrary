local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Utility Functions
local function Tween(instance, properties, duration, style, direction)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(instance, TweenInfo.new(duration, style, direction), properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Tween(frame, {Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)}, 0.1)
        end
    end)
end

-- Create Window
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "UI Library"
    local windowTheme = config.Theme or "Dark"
    local keybind = config.Keybind or Enum.KeyCode.RightControl
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Notifications = {}
    
    -- Color Themes
    local Themes = {
        Dark = {
            Background = Color3.fromRGB(15, 15, 20),
            Secondary = Color3.fromRGB(20, 20, 28),
            Tertiary = Color3.fromRGB(25, 25, 35),
            Accent = Color3.fromRGB(88, 101, 242),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(150, 150, 160),
            Border = Color3.fromRGB(40, 40, 50)
        },
        Light = {
            Background = Color3.fromRGB(240, 240, 245),
            Secondary = Color3.fromRGB(250, 250, 255),
            Tertiary = Color3.fromRGB(255, 255, 255),
            Accent = Color3.fromRGB(88, 101, 242),
            Text = Color3.fromRGB(20, 20, 30),
            SubText = Color3.fromRGB(100, 100, 120),
            Border = Color3.fromRGB(220, 220, 230)
        },
        Ocean = {
            Background = Color3.fromRGB(10, 15, 25),
            Secondary = Color3.fromRGB(15, 22, 35),
            Tertiary = Color3.fromRGB(20, 28, 42),
            Accent = Color3.fromRGB(0, 150, 255),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(140, 180, 220),
            Border = Color3.fromRGB(30, 50, 80)
        }
    }
    
    Window.Theme = Themes[windowTheme] or Themes.Dark
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LumaHubUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if syn then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 700, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainFrame.BackgroundColor3 = Window.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Window.Theme.Border
    MainStroke.Thickness = 1
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame
    
    -- Shadow Effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.7
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame
    
    -- Mobile Scale
    local UIScale = Instance.new("UIScale")
    UIScale.Parent = MainFrame
    
    local function updateScale()
        local screenSize = ScreenGui.AbsoluteSize
        local scaleX = screenSize.X / 1920
        local scaleY = screenSize.Y / 1080
        UIScale.Scale = math.min(scaleX, scaleY, 1)
    end
    
    updateScale()
    ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale)
    
    -- Top Bar
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
    
    local AccentGradient = Instance.new("UIGradient")
    AccentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Window.Theme.Accent),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 80, 255)),
        ColorSequenceKeypoint.new(1, Window.Theme.Accent)
    }
    AccentGradient.Parent = TopBarAccent
    
    -- Animate gradient
    task.spawn(function()
        while ScreenGui.Parent do
            for i = 0, 360, 1 do
                if not ScreenGui.Parent then break end
                AccentGradient.Rotation = i
                task.wait(0.03)
            end
        end
    end)
    
    -- Title
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
    
    -- Close Button
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
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}, 0.2)
        task.wait(0.1)
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Window.Theme.Tertiary}, 0.2)
    end)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Position = UDim2.new(1, -90, 0, 5)
    MinimizeButton.BackgroundColor3 = Window.Theme.Tertiary
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Window.Theme.Text
    MinimizeButton.TextSize = 24
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TopBar
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 8)
    MinimizeCorner.Parent = MinimizeButton
    
    local isMinimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 50)}, 0.3)
            MinimizeButton.Text = "+"
        else
            Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 500)}, 0.3)
            MinimizeButton.Text = "−"
        end
    end)
    
    MinimizeButton.MouseEnter:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Window.Theme.Accent}, 0.2)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Window.Theme.Tertiary}, 0.2)
    end)
    
    MakeDraggable(MainFrame, TopBar)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 150, 1, -50)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.BackgroundColor3 = Window.Theme.Secondary
    TabContainer.BorderSizePixel = 0
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
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -150, 1, -50)
    ContentContainer.Position = UDim2.new(0, 150, 0, 50)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Keybind Toggle
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == keybind then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    -- Entrance Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 500)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- Create Tab
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or "📄"
        
        local Tab = {}
        Tab.Sections = {}
        Tab.Elements = {}
        
        -- Tab Button
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
        
        local TabIcon = Instance.new("TextLabel")
        TabIcon.Size = UDim2.new(0, 30, 1, 0)
        TabIcon.Position = UDim2.new(0, 5, 0, 0)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Text = tabIcon
        TabIcon.TextColor3 = Window.Theme.SubText
        TabIcon.TextSize = 18
        TabIcon.Font = Enum.Font.Gotham
        TabIcon.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -40, 1, 0)
        TabLabel.Position = UDim2.new(0, 40, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Window.Theme.SubText
        TabLabel.TextSize = 14
        TabLabel.Font = Enum.Font.GothamMedium
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, -20, 1, -20)
        TabContent.Position = UDim2.new(0, 10, 0, 10)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Window.Theme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local TabContentList = Instance.new("UIListLayout")
        TabContentList.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentList.Padding = UDim.new(0, 10)
        TabContentList.Parent = TabContent
        
        TabContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentList.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab Selection
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundColor3 = Window.Theme.Tertiary}, 0.2)
                tab.Label.TextColor3 = Window.Theme.SubText
                tab.Icon.TextColor3 = Window.Theme.SubText
            end
            
            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = Window.Theme.Accent}, 0.2)
            TabLabel.TextColor3 = Window.Theme.Text
            TabIcon.TextColor3 = Window.Theme.Text
            Window.CurrentTab = Tab
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(
                    Window.Theme.Tertiary.R * 255 + 10,
                    Window.Theme.Tertiary.G * 255 + 10,
                    Window.Theme.Tertiary.B * 255 + 10
                )}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = Window.Theme.Tertiary}, 0.2)
            end
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.Label = TabLabel
        Tab.Icon = TabIcon
        
        table.insert(Window.Tabs, Tab)
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            TabButton.MouseButton1Click:Fire()
        end
        
        -- Create Section
        function Tab:CreateSection(sectionName)
            local Section = Instance.new("Frame")
            Section.Name = sectionName
            Section.Size = UDim2.new(1, 0, 0, 35)
            Section.BackgroundColor3 = Window.Theme.Secondary
            Section.BorderSizePixel = 0
            Section.Parent = TabContent
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = Section
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, -20, 1, 0)
            SectionLabel.Position = UDim2.new(0, 10, 0, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = sectionName
            SectionLabel.TextColor3 = Window.Theme.Text
            SectionLabel.TextSize = 16
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = Section
            
            local SectionAccent = Instance.new("Frame")
            SectionAccent.Size = UDim2.new(0, 3, 1, 0)
            SectionAccent.BackgroundColor3 = Window.Theme.Accent
            SectionAccent.BorderSizePixel = 0
            SectionAccent.Parent = Section
            
            local AccentCorner = Instance.new("UICorner")
            AccentCorner.CornerRadius = UDim.new(0, 8)
            AccentCorner.Parent = SectionAccent
            
            table.insert(Tab.Sections, Section)
            
            return Section
        end
        
        -- Create Button
        function Tab:CreateButton(config)
            config = config or {}
            local buttonName = config.Name or "Button"
            local buttonCallback = config.Callback or function() end
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = buttonName
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.BackgroundColor3 = Window.Theme.Secondary
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = ButtonFrame
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -20, 1, -10)
            Button.Position = UDim2.new(0, 10, 0, 5)
            Button.BackgroundColor3 = Window.Theme.Tertiary
            Button.BorderSizePixel = 0
            Button.Text = buttonName
            Button.TextColor3 = Window.Theme.Text
            Button.TextSize = 14
            Button.Font = Enum.Font.GothamMedium
            Button.AutoButtonColor = false
            Button.Parent = ButtonFrame
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                Tween(Button, {BackgroundColor3 = Window.Theme.Accent}, 0.1)
                task.wait(0.1)
                Tween(Button, {BackgroundColor3 = Window.Theme.Tertiary}, 0.2)
                
                local success, err = pcall(buttonCallback)
                if not success then
                    warn("Button callback error:", err)
                end
            end)
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(
                    Window.Theme.Tertiary.R * 255 + 15,
                    Window.Theme.Tertiary.G * 255 + 15,
                    Window.Theme.Tertiary.B * 255 + 15
                )}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Window.Theme.Tertiary}, 0.2)
            end)
            
            return Button
        end
        
        -- Create Toggle
        function Tab:CreateToggle(config)
            config = config or {}
            local toggleName = config.Name or "Toggle"
            local toggleDefault = config.Default or false
            local toggleCallback = config.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = toggleName
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Window.Theme.Secondary
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = toggleName
            ToggleLabel.TextColor3 = Window.Theme.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.GothamMedium
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleButton.BackgroundColor3 = toggleDefault and Window.Theme.Accent or Window.Theme.Tertiary
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.AutoButtonColor = false
            ToggleButton.Parent = ToggleFrame
            
            local ToggleBtnCorner = Instance.new("UICorner")
            ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
            ToggleBtnCorner.Parent = ToggleButton
            
            local ToggleIndicator = Instance.new("Frame")
            ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            ToggleIndicator.Position = toggleDefault and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleIndicator.BorderSizePixel = 0
            ToggleIndicator.Parent = ToggleButton
            
            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = ToggleIndicator
            
            local toggled = toggleDefault
            
            local function updateToggle(value)
                toggled = value
                Tween(ToggleButton, {BackgroundColor3 = toggled and Window.Theme.Accent or Window.Theme.Tertiary}, 0.2)
                Tween(ToggleIndicator, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
                
                local success, err = pcall(toggleCallback, toggled)
                if not success then
                    warn("Toggle callback error:", err)
                end
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                updateToggle(not toggled)
            end)
            
            if toggleDefault then
                task.spawn(function()
                    pcall(toggleCallback, true)
                end)
            end
            
            return {
                SetValue = updateToggle,
                GetValue = function() return toggled end
            }
        end
        
        -- Create Slider
        function Tab:CreateSlider(config)
            config = config or {}
            local sliderName = config.Name or "Slider"
            local sliderMin = config.Min or 0
            local sliderMax = config.Max or 100
            local sliderDefault = config.Default or sliderMin
            local sliderIncrement = config.Increment or 1
            local sliderCallback = config.Callback or function() end
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = sliderName
            SliderFrame.Size = UDim2.new(1, 0, 0, 55)
            SliderFrame.BackgroundColor3 = Window.Theme.Secondary
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -70, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = sliderName
            SliderLabel.TextColor3 = Window.Theme.Text
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.GothamMedium
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 60, 0, 20)
            SliderValue.Position = UDim2.new(1, -70, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(sliderDefault)
            SliderValue.TextColor3 = Window.Theme.Accent
            SliderValue.TextSize = 14
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Size = UDim2.new(1, -20, 0, 6)
            SliderTrack.Position = UDim2.new(0, 10, 1, -15)
            SliderTrack.BackgroundColor3 = Window.Theme.Tertiary
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Parent = SliderFrame
            
            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = SliderTrack
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((sliderDefault - sliderMin) / (sliderMax - sliderMin), 0, 1, 0)
            SliderFill.BackgroundColor3 = Window.Theme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderTrack
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SliderFill
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(0, 16, 0, 16)
            SliderButton.Position = UDim2.new((sliderDefault - sliderMin) / (sliderMax - sliderMin), -8, 0.5, -8)
            SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderButton.BorderSizePixel = 0
            SliderButton.Text = ""
            SliderButton.AutoButtonColor = false
            SliderButton.Parent = SliderTrack
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(1, 0)
            BtnCorner.Parent = SliderButton
            
            local dragging = false
            local currentValue = sliderDefault
            
            local function updateSlider(value)
                value = math.clamp(value, sliderMin, sliderMax)
                value = math.floor(value / sliderIncrement + 0.5) * sliderIncrement
                currentValue = value
                
                local percentage = (value - sliderMin) / (sliderMax - sliderMin)
                Tween(SliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
                Tween(SliderButton, {Position = UDim2.new(percentage, -8, 0.5, -8)}, 0.1)
                SliderValue.Text = tostring(value)
                
                local success, err = pcall(sliderCallback, value)
                if not success then
                    warn("Slider callback error:", err)
                end
            end
            
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local percentage = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    local value = sliderMin + (sliderMax - sliderMin) * percentage
                    updateSlider(value)
                    dragging = true
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local percentage = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    local value = sliderMin + (sliderMax - sliderMin) * percentage
                    updateSlider(value)
                end
            end)
            
            task.spawn(function()
                pcall(sliderCallback, sliderDefault)
            end)
            
            return {
                SetValue = updateSlider,
                GetValue = function() return currentValue end
            }
        end
        
        -- Create Textbox
        function Tab:CreateTextbox(config)
            config = config or {}
            local textboxName = config.Name or "Textbox"
            local textboxDefault = config.Default or ""
            local textboxPlaceholder = config.Placeholder or "Enter text..."
            local textboxCallback = config.Callback or function() end
            
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = textboxName
            TextboxFrame.Size = UDim2.new(1, 0, 0, 70)
            TextboxFrame.BackgroundColor3 = Window.Theme.Secondary
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Parent = TabContent
            
            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 8)
            TextboxCorner.Parent = TextboxFrame
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(1, -20, 0, 20)
            TextboxLabel.Position = UDim2.new(0, 10, 0, 5)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = textboxName
            TextboxLabel.TextColor3 = Window.Theme.Text
            TextboxLabel.TextSize = 14
            TextboxLabel.Font = Enum.Font.GothamMedium
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame
            
            local Textbox = Instance.new("TextBox")
            Textbox.Size = UDim2.new(1, -20, 0, 30)
            Textbox.Position = UDim2.new(0, 10, 0, 30)
            Textbox.BackgroundColor3 = Window.Theme.Tertiary
            Textbox.BorderSizePixel = 0
            Textbox.Text = textboxDefault
            Textbox.PlaceholderText = textboxPlaceholder
            Textbox.TextColor3 = Window.Theme.Text
            Textbox.PlaceholderColor3 = Window.Theme.SubText
            Textbox.TextSize = 13
            Textbox.Font = Enum.Font.Gotham
            Textbox.ClearTextOnFocus = false
            Textbox.Parent = TextboxFrame
            
            local TxtCorner = Instance.new("UICorner")
            TxtCorner.CornerRadius = UDim.new(0, 6)
            TxtCorner.Parent = Textbox
            
            local TxtPadding = Instance.new("UIPadding")
            TxtPadding.PaddingLeft = UDim.new(0, 10)
            TxtPadding.PaddingRight = UDim.new(0, 10)
            TxtPadding.Parent = Textbox
            
            Textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    local success, err = pcall(textboxCallback, Textbox.Text)
                    if not success then
                        warn("Textbox callback error:", err)
                    end
                end
            end)
            
            Textbox.Focused:Connect(function()
                Tween(Textbox, {BackgroundColor3 = Color3.fromRGB(
                    Window.Theme.Tertiary.R * 255 + 10,
                    Window.Theme.Tertiary.G * 255 + 10,
                    Window.Theme.Tertiary.B * 255 + 10
                )}, 0.2)
            end)
            
            Textbox.FocusLost:Connect(function()
                Tween(Textbox, {BackgroundColor3 = Window.Theme.Tertiary}, 0.2)
            end)
            
            return {
                SetValue = function(value)
                    Textbox.Text = value
                end,
                GetValue = function()
                    return Textbox.Text
                end
            }
        end
        
        -- Create Dropdown
        function Tab:CreateDropdown(config)
            config = config or {}
            local dropdownName = config.Name or "Dropdown"
            local dropdownOptions = config.Options or {"Option 1", "Option 2"}
            local dropdownDefault = config.Default or dropdownOptions[1]
            local dropdownCallback = config.Callback or function() end
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = dropdownName
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.BackgroundColor3 = Window.Theme.Secondary
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = false
            DropdownFrame.Parent = TabContent
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, -20, 1, -10)
            DropdownButton.Position = UDim2.new(0, 10, 0, 5)
            DropdownButton.BackgroundColor3 = Window.Theme.Tertiary
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Text = ""
            DropdownButton.AutoButtonColor = false
            DropdownButton.Parent = DropdownFrame
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = DropdownButton
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(1, -50, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = dropdownName
            DropdownLabel.TextColor3 = Window.Theme.SubText
            DropdownLabel.TextSize = 13
            DropdownLabel.Font = Enum.Font.GothamMedium
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownButton
            
            local DropdownValue = Instance.new("TextLabel")
            DropdownValue.Size = UDim2.new(1, -50, 1, 0)
            DropdownValue.Position = UDim2.new(0, 10, 0, 0)
            DropdownValue.BackgroundTransparency = 1
            DropdownValue.Text = dropdownDefault
            DropdownValue.TextColor3 = Window.Theme.Text
            DropdownValue.TextSize = 13
            DropdownValue.Font = Enum.Font.GothamBold
            DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
            DropdownValue.Parent = DropdownButton
            
            local DropdownIcon = Instance.new("TextLabel")
            DropdownIcon.Size = UDim2.new(0, 20, 1, 0)
            DropdownIcon.Position = UDim2.new(1, -30, 0, 0)
            DropdownIcon.BackgroundTransparency = 1
            DropdownIcon.Text = "▼"
            DropdownIcon.TextColor3 = Window.Theme.SubText
            DropdownIcon.TextSize = 10
            DropdownIcon.Font = Enum.Font.Gotham
            DropdownIcon.Parent = DropdownButton
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Size = UDim2.new(1, -20, 0, 0)
            DropdownList.Position = UDim2.new(0, 10, 1, 5)
            DropdownList.BackgroundColor3 = Window.Theme.Tertiary
            DropdownList.BorderSizePixel = 0
            DropdownList.Visible = false
            DropdownList.ZIndex = 100
            DropdownList.ClipsDescendants = true
            DropdownList.Parent = DropdownFrame
            
            local ListCorner = Instance.new("UICorner")
            ListCorner.CornerRadius = UDim.new(0, 6)
            ListCorner.Parent = DropdownList
            
            local ListStroke = Instance.new("UIStroke")
            ListStroke.Color = Window.Theme.Border
            ListStroke.Thickness = 1
            ListStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            ListStroke.Parent = DropdownList
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 2)
            ListLayout.Parent = DropdownList
            
            local ListPadding = Instance.new("UIPadding")
            ListPadding.PaddingTop = UDim.new(0, 5)
            ListPadding.PaddingBottom = UDim.new(0, 5)
            ListPadding.PaddingLeft = UDim.new(0, 5)
            ListPadding.PaddingRight = UDim2.new(0, 5)
            ListPadding.Parent = DropdownList
            
            local isOpen = false
            local currentValue = dropdownDefault
            
            for _, option in ipairs(dropdownOptions) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, -10, 0, 25)
                OptionButton.BackgroundColor3 = Window.Theme.Secondary
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = option
                OptionButton.TextColor3 = Window.Theme.Text
                OptionButton.TextSize = 13
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.AutoButtonColor = false
                OptionButton.Parent = DropdownList
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 4)
                OptionCorner.Parent = OptionButton
                
                OptionButton.MouseButton1Click:Connect(function()
                    currentValue = option
                    DropdownValue.Text = option
                    isOpen = false
                    Tween(DropdownList, {Size = UDim2.new(1, -20, 0, 0)}, 0.2)
                    task.wait(0.2)
                    DropdownList.Visible = false
                    DropdownIcon.Text = "▼"
                    
                    local success, err = pcall(dropdownCallback, option)
                    if not success then
                        warn("Dropdown callback error:", err)
                    end
                end)
                
                OptionButton.MouseEnter:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Window.Theme.Accent}, 0.2)
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    Tween(OptionButton, {BackgroundColor3 = Window.Theme.Secondary}, 0.2)
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                DropdownList.Visible = true
                
                if isOpen then
                    local listHeight = (#dropdownOptions * 27) + 10
                    Tween(DropdownList, {Size = UDim2.new(1, -20, 0, listHeight)}, 0.2)
                    DropdownIcon.Text = "▲"
                else
                    Tween(DropdownList, {Size = UDim2.new(1, -20, 0, 0)}, 0.2)
                    task.wait(0.2)
                    DropdownList.Visible = false
                    DropdownIcon.Text = "▼"
                end
            end)
            
            DropdownButton.MouseEnter:Connect(function()
                Tween(DropdownButton, {BackgroundColor3 = Color3.fromRGB(
                    Window.Theme.Tertiary.R * 255 + 10,
                    Window.Theme.Tertiary.G * 255 + 10,
                    Window.Theme.Tertiary.B * 255 + 10
                )}, 0.2)
            end)
            
            DropdownButton.MouseLeave:Connect(function()
                Tween(DropdownButton, {BackgroundColor3 = Window.Theme.Tertiary}, 0.2)
            end)
            
            task.spawn(function()
                pcall(dropdownCallback, dropdownDefault)
            end)
            
            return {
                SetValue = function(value)
                    if table.find(dropdownOptions, value) then
                        currentValue = value
                        DropdownValue.Text = value
                        pcall(dropdownCallback, value)
                    end
                end,
                GetValue = function() return currentValue end,
                SetOptions = function(newOptions)
                    for _, child in pairs(DropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    dropdownOptions = newOptions
                    
                    for _, option in ipairs(newOptions) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Size = UDim2.new(1, -10, 0, 25)
                        OptionButton.BackgroundColor3 = Window.Theme.Secondary
                        OptionButton.BorderSizePixel = 0
                        OptionButton.Text = option
                        OptionButton.TextColor3 = Window.Theme.Text
                        OptionButton.TextSize = 13
                        OptionButton.Font = Enum.Font.Gotham
                        OptionButton.AutoButtonColor = false
                        OptionButton.Parent = DropdownList
                        
                        local OptionCorner = Instance.new("UICorner")
                        OptionCorner.CornerRadius = UDim.new(0, 4)
                        OptionCorner.Parent = OptionButton
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            currentValue = option
                            DropdownValue.Text = option
                            isOpen = false
                            Tween(DropdownList, {Size = UDim2.new(1, -20, 0, 0)}, 0.2)
                            task.wait(0.2)
                            DropdownList.Visible = false
                            DropdownIcon.Text = "▼"
                            pcall(dropdownCallback, option)
                        end)
                        
                        OptionButton.MouseEnter:Connect(function()
                            Tween(OptionButton, {BackgroundColor3 = Window.Theme.Accent}, 0.2)
                        end)
                        
                        OptionButton.MouseLeave:Connect(function()
                            Tween(OptionButton, {BackgroundColor3 = Window.Theme.Secondary}, 0.2)
                        end)
                    end
                end
            }
        end
        
        -- Create Label
        function Tab:CreateLabel(config)
            config = config or {}
            local labelText = config.Text or "Label"
            
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Size = UDim2.new(1, 0, 0, 30)
            LabelFrame.BackgroundColor3 = Window.Theme.Secondary
            LabelFrame.BorderSizePixel = 0
            LabelFrame.Parent = TabContent
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 8)
            LabelCorner.Parent = LabelFrame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = labelText
            Label.TextColor3 = Window.Theme.SubText
            Label.TextSize = 13
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true
            Label.Parent = LabelFrame
            
            return {
                SetText = function(text)
                    Label.Text = text
                end
            }
        end
        
        -- Create Keybind
        function Tab:CreateKeybind(config)
            config = config or {}
            local keybindName = config.Name or "Keybind"
            local keybindDefault = config.Default or Enum.KeyCode.E
            local keybindCallback = config.Callback or function() end
            
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Name = keybindName
            KeybindFrame.Size = UDim2.new(1, 0, 0, 40)
            KeybindFrame.BackgroundColor3 = Window.Theme.Secondary
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.Parent = TabContent
            
            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 8)
            KeybindCorner.Parent = KeybindFrame
            
            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Size = UDim2.new(1, -100, 1, 0)
            KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Text = keybindName
            KeybindLabel.TextColor3 = Window.Theme.Text
            KeybindLabel.TextSize = 14
            KeybindLabel.Font = Enum.Font.GothamMedium
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = KeybindFrame
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Size = UDim2.new(0, 80, 0, 25)
            KeybindButton.Position = UDim2.new(1, -90, 0.5, -12.5)
            KeybindButton.BackgroundColor3 = Window.Theme.Tertiary
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Text = keybindDefault.Name
            KeybindButton.TextColor3 = Window.Theme.Accent
            KeybindButton.TextSize = 12
            KeybindButton.Font = Enum.Font.GothamBold
            KeybindButton.AutoButtonColor = false
            KeybindButton.Parent = KeybindFrame
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = KeybindButton
            
            local currentKeybind = keybindDefault
            local listening = false
            
            KeybindButton.MouseButton1Click:Connect(function()
                listening = true
                KeybindButton.Text = "..."
                KeybindButton.TextColor3 = Window.Theme.Text
            end)
            
            UserInputService.InputBegan:Connect(function(input, processed)
                if not processed then
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKeybind = input.KeyCode
                        KeybindButton.Text = input.KeyCode.Name
                        KeybindButton.TextColor3 = Window.Theme.Accent
                        listening = false
                    elseif input.KeyCode == currentKeybind and not listening then
                        local success, err = pcall(keybindCallback)
                        if not success then
                            warn("Keybind callback error:", err)
                        end
                    end
                end
            end)
            
            KeybindButton.MouseEnter:Connect(function()
                Tween(KeybindButton, {BackgroundColor3 = Color3.fromRGB(
                    Window.Theme.Tertiary.R * 255 + 10,
                    Window.Theme.Tertiary.G * 255 + 10,
                    Window.Theme.Tertiary.B * 255 + 10
                )}, 0.2)
            end)
            
            KeybindButton.MouseLeave:Connect(function()
                Tween(KeybindButton, {BackgroundColor3 = Window.Theme.Tertiary}, 0.2)
            end)
            
            return {
                SetKeybind = function(keybind)
                    currentKeybind = keybind
                    KeybindButton.Text = keybind.Name
                end,
                GetKeybind = function() return currentKeybind end
            }
        end
        
        return Tab
    end
    
    -- Notification System
    function Window:Notify(config)
        config = config or {}
        local title = config.Title or "Notification"
        local content = config.Content or "This is a notification"
        local duration = config.Duration or 3
        local icon = config.Icon or "ℹ️"
        
        local NotificationContainer = Instance.new("Frame")
        NotificationContainer.Size = UDim2.new(0, 0, 0, 80)
        NotificationContainer.Position = UDim2.new(1, -20, 1, -100 - (#Window.Notifications * 90))
        NotificationContainer.BackgroundColor3 = Window.Theme.Secondary
        NotificationContainer.BorderSizePixel = 0
        NotificationContainer.ClipsDescendants = true
        NotificationContainer.Parent = ScreenGui
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 10)
        NotifCorner.Parent = NotificationContainer
        
        local NotifStroke = Instance.new("UIStroke")
        NotifStroke.Color = Window.Theme.Border
        NotifStroke.Thickness = 1
        NotifStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        NotifStroke.Parent = NotificationContainer
        
        local NotifAccent = Instance.new("Frame")
        NotifAccent.Size = UDim2.new(0, 3, 1, 0)
        NotifAccent.BackgroundColor3 = Window.Theme.Accent
        NotifAccent.BorderSizePixel = 0
        NotifAccent.Parent = NotificationContainer
        
        local AccentCorner = Instance.new("UICorner")
        AccentCorner.CornerRadius = UDim.new(0, 10)
        AccentCorner.Parent = NotifAccent
        
        local NotifIcon = Instance.new("TextLabel")
        NotifIcon.Size = UDim2.new(0, 40, 0, 40)
        NotifIcon.Position = UDim2.new(0, 10, 0, 10)
        NotifIcon.BackgroundTransparency = 1
        NotifIcon.Text = icon
        NotifIcon.TextColor3 = Window.Theme.Accent
        NotifIcon.TextSize = 24
        NotifIcon.Font = Enum.Font.Gotham
        NotifIcon.Parent = NotificationContainer
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Size = UDim2.new(1, -60, 0, 20)
        NotifTitle.Position = UDim2.new(0, 55, 0, 10)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Text = title
        NotifTitle.TextColor3 = Window.Theme.Text
        NotifTitle.TextSize = 14
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.Parent = NotificationContainer
        
        local NotifContent = Instance.new("TextLabel")
        NotifContent.Size = UDim2.new(1, -60, 0, 40)
        NotifContent.Position = UDim2.new(0, 55, 0, 30)
        NotifContent.BackgroundTransparency = 1
        NotifContent.Text = content
        NotifContent.TextColor3 = Window.Theme.SubText
        NotifContent.TextSize = 12
        NotifContent.Font = Enum.Font.Gotham
        NotifContent.TextXAlignment = Enum.TextXAlignment.Left
        NotifContent.TextYAlignment = Enum.TextYAlignment.Top
        NotifContent.TextWrapped = true
        NotifContent.Parent = NotificationContainer
        
        table.insert(Window.Notifications, NotificationContainer)
        
        Tween(NotificationContainer, {Size = UDim2.new(0, 350, 0, 80)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        task.delay(duration, function()
            Tween(NotificationContainer, {Position = UDim2.new(1, 20, NotificationContainer.Position.Y.Scale, NotificationContainer.Position.Y.Offset)}, 0.3)
            task.wait(0.3)
            NotificationContainer:Destroy()
            
            for i, notif in pairs(Window.Notifications) do
                if notif == NotificationContainer then
                    table.remove(Window.Notifications, i)
                    break
                end
            end
            
            for i, notif in pairs(Window.Notifications) do
                Tween(notif, {Position = UDim2.new(1, -20, 1, -100 - (i * 90))}, 0.2)
            end
        end)
    end
    
    return Window
end

return Library
