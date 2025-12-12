local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Library = {}

function Library:CreateWindow(Settings)
    local Window = {}
    Settings = Settings or {}
    
    local TitleText = Settings.Title or "LumaHub UI"
    local SubTitleText = Settings.Subtitle or "Interface"
    local AccentColor = Settings.Accent or Color3.fromRGB(80, 120, 255)
    
    local isMinimized = false
    local isSidebarExpanded = true

    local gui = Instance.new("ScreenGui")
    gui.Name = "LumaLibrary"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true
    
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = CoreGui
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 750, 0, 450)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = gui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(35, 35, 45)
    mainStroke.Thickness = 1
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mainStroke.Parent = mainFrame

    -- Main Content Area (Background)
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -50, 1, 0)
    contentArea.Position = UDim2.new(0, 50, 0, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.ClipsDescendants = true
    contentArea.Parent = mainFrame

    -- Title Bar for Dragging and Controls
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    titleBar.ZIndex = 3
    titleBar.Parent = mainFrame
    
    local titleBarLabel = Instance.new("TextLabel")
    titleBarLabel.Name = "Title"
    titleBarLabel.Size = UDim2.new(1, -100, 1, 0)
    titleBarLabel.Position = UDim2.new(0, 50, 0, 0)
    titleBarLabel.BackgroundTransparency = 1
    titleBarLabel.Text = TitleText .. " - " .. SubTitleText
    titleBarLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    titleBarLabel.TextSize = 14
    titleBarLabel.Font = Enum.Font.GothamMedium
    titleBarLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleBarLabel.Parent = titleBar

    -- Control Buttons
    local function createControlButton(name, icon, position, color, callback)
        local button = Instance.new("ImageButton")
        button.Name = name
        button.Size = UDim2.new(0, 30, 0, 30)
        button.Position = position
        button.BackgroundTransparency = 1
        button.Image = icon
        button.ImageColor3 = color
        button.ImageTransparency = 0.3
        button.Parent = titleBar
        button.MouseEnter:Connect(function() TweenService:Create(button, TweenInfo.new(0.1), {ImageTransparency = 0}):Play() end)
        button.MouseLeave:Connect(function() TweenService:Create(button, TweenInfo.new(0.1), {ImageTransparency = 0.3}):Play() end)
        button.MouseButton1Click:Connect(callback)
        return button
    end

    local function toggleMinimize()
        isMinimized = not isMinimized
        local sizeGoal = isMinimized and UDim2.new(0, 350, 0, 30) or UDim2.new(0, 750, 0, 450)
        local icon = isMinimized and "rbxassetid://3926306509" or "rbxassetid://3926306168" -- Square or Minus
        
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = sizeGoal}):Play()
        TweenService:Create(contentArea, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {CanvasGroupTransparency = isMinimized and 1 or 0}):Play()
        
        minimizeButton.Image = icon
    end

    local closeButton = createControlButton("CloseButton", "rbxassetid://3926305904", UDim2.new(1, -30, 0, 0), Color3.fromRGB(255, 80, 80), function()
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {CanvasGroupTransparency = 1}):Play()
        task.wait(0.4)
        gui:Destroy()
    end)
    closeButton.ImageTransparency = 0.1
    
    local minimizeButton = createControlButton("MinimizeButton", "rbxassetid://3926306168", UDim2.new(1, -60, 0, 0), Color3.fromRGB(255, 255, 255), toggleMinimize)

    -- Sidebar Implementation
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 50, 1, 0) -- Starts small
    sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 2
    sidebar.Parent = mainFrame

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 12)
    sidebarCorner.Parent = sidebar

    local sidebarDivider = Instance.new("Frame")
    sidebarDivider.Name = "Divider"
    sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
    sidebarDivider.Position = UDim2.new(1, 0, 0, 0)
    sidebarDivider.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sidebarDivider.BorderSizePixel = 0
    sidebarDivider.Parent = sidebar

    local titleContainer = Instance.new("Frame")
    titleContainer.Name = "TitleContainer"
    titleContainer.Size = UDim2.new(1, 0, 0, 70)
    titleContainer.BackgroundTransparency = 1
    titleContainer.Parent = sidebar

    local titleLabelSidebar = Instance.new("TextLabel")
    titleLabelSidebar.Name = "Title"
    titleLabelSidebar.Size = UDim2.new(1, -30, 0, 30)
    titleLabelSidebar.Position = UDim2.new(0, 15, 0, 15)
    titleLabelSidebar.BackgroundTransparency = 1
    titleLabelSidebar.Text = TitleText
    titleLabelSidebar.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabelSidebar.TextSize = 22
    titleLabelSidebar.Font = Enum.Font.GothamBold
    titleLabelSidebar.TextXAlignment = Enum.TextXAlignment.Left
    titleLabelSidebar.Parent = titleContainer

    local subLabel = Instance.new("TextLabel")
    subLabel.Name = "Subtitle"
    subLabel.Size = UDim2.new(1, -30, 0, 20)
    subLabel.Position = UDim2.new(0, 15, 0, 42)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = SubTitleText
    subLabel.TextColor3 = AccentColor
    subLabel.TextSize = 13
    subLabel.Font = Enum.Font.GothamMedium
    subLabel.TextXAlignment = Enum.TextXAlignment.Left
    subLabel.Parent = titleContainer
    
    local function setSidebarTextTransparency(transparency)
        TweenService:Create(titleLabelSidebar, TweenInfo.new(0.3), {TextTransparency = transparency}):Play()
        TweenService:Create(subLabel, TweenInfo.new(0.3), {TextTransparency = transparency}):Play()
    end

    local function expandSidebar()
        if isSidebarExpanded then return end
        isSidebarExpanded = true
        TweenService:Create(sidebar, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 200, 1, 0)}):Play()
        TweenService:Create(contentArea, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 200, 0, 0), Size = UDim2.new(1, -200, 1, 0)}):Play()
        setSidebarTextTransparency(0)
    end

    local function collapseSidebar()
        if not isSidebarExpanded then return end
        isSidebarExpanded = false
        setSidebarTextTransparency(1)
        TweenService:Create(sidebar, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 50, 1, 0)}):Play()
        TweenService:Create(contentArea, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 50, 0, 0), Size = UDim2.new(1, -50, 1, 0)}):Play()
    end
    
    sidebar.MouseEnter:Connect(expandSidebar)
    sidebar.MouseLeave:Connect(collapseSidebar)
    
    collapseSidebar()

    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, 0, 1, -80)
    tabContainer.Position = UDim2.new(0, 0, 0, 80)
    tabContainer.BackgroundTransparency = 1
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 2
    tabContainer.ScrollBarImageColor3 = AccentColor
    tabContainer.Parent = sidebar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabContainer

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 10)
    tabPadding.PaddingRight = UDim.new(0, 10)
    tabPadding.Parent = tabContainer

    -- Dragging Logic (Using TitleBar/Sidebar)
    local dragging
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    local tabs = {}
    local firstTab = true

    function Window:CreateTab(name, icon)
        local tab = {}
        
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Button"
        tabButton.Size = UDim2.new(1, 0, 0, 36)
        tabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundTransparency = 1
        tabButton.Text = ""
        tabButton.AutoButtonColor = false
        tabButton.LayoutOrder = #tabs + 1 -- Alignment fix
        tabButton.Parent = tabContainer

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = tabButton

        local btnTitle = Instance.new("TextLabel")
        btnTitle.Name = "Title"
        btnTitle.Size = UDim2.new(1, -40, 1, 0)
        btnTitle.Position = UDim2.new(0, 12, 0, 0)
        btnTitle.BackgroundTransparency = 1
        btnTitle.Text = name
        btnTitle.TextColor3 = Color3.fromRGB(150, 150, 160)
        btnTitle.TextSize = 14
        btnTitle.Font = Enum.Font.GothamMedium
        btnTitle.TextXAlignment = Enum.TextXAlignment.Left
        btnTitle.Parent = tabButton

        if icon then
            btnTitle.Position = UDim2.new(0, 36, 0, 0)
            btnTitle.Size = UDim2.new(1, -40, 1, 0)
            
            local iconImg = Instance.new("ImageLabel")
            iconImg.Name = "Icon"
            iconImg.Size = UDim2.new(0, 20, 0, 20)
            iconImg.Position = UDim2.new(0, 8, 0.5, -10)
            iconImg.BackgroundTransparency = 1
            iconImg.Image = icon
            iconImg.ImageColor3 = Color3.fromRGB(150, 150, 160)
            iconImg.Parent = tabButton
            tab.Icon = iconImg
        end

        local page = Instance.new("ScrollingFrame")
        page.Name = name .. "Page"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = AccentColor
        page.Visible = false
        page.Parent = contentArea

        local pagePadding = Instance.new("UIPadding")
        pagePadding.PaddingTop = UDim.new(0, 20)
        pagePadding.PaddingLeft = UDim.new(0, 20)
        pagePadding.PaddingRight = UDim.new(0, 20)
        pagePadding.PaddingBottom = UDim.new(0, 20)
        pagePadding.Parent = page

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 10)
        pageLayout.Parent = page
        
        tab.Page = page
        tab.Button = tabButton
        tab.BtnTitle = btnTitle

        local function Activate()
            if isMinimized then return end 
            for _, t in pairs(tabs) do
                TweenService:Create(t.BtnTitle, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 160)}):Play()
                TweenService:Create(t.Button, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                if t.Icon then
                    TweenService:Create(t.Icon, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(150, 150, 160)}):Play()
                end
                t.Page.Visible = false
            end
            
            TweenService:Create(btnTitle, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(tabButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.95, BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
            if tab.Icon then
                TweenService:Create(tab.Icon, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end
            
            page.Visible = true
            page.CanvasPosition = Vector2.new(0,0)
            
            page.Position = UDim2.new(0, 0, 0, 10)
            page.CanvasGroupTransparency = 1
            
            TweenService:Create(page, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, 0),
                CanvasGroupTransparency = 0
            }):Play()
        end

        tabButton.MouseButton1Click:Connect(Activate)

        if firstTab then
            firstTab = false
            Activate()
        end
        
        table.insert(tabs, tab)
        
        return tab
    end

    function Window:CreateInfoTab()
        local infoTab = Window:CreateTab("Information", "rbxassetid://3926305904")
        local page = infoTab.Page
        
        -- Use a Frame to contain the elements and set its height for UIListLayout
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 300) 
        container.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
        container.BorderSizePixel = 0
        container.Parent = page
        
        local cCorner = Instance.new("UICorner")
        cCorner.CornerRadius = UDim.new(0, 12)
        cCorner.Parent = container
        
        local cStroke = Instance.new("UIStroke")
        cStroke.Color = Color3.fromRGB(40, 40, 50)
        cStroke.Thickness = 1
        cStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        cStroke.Parent = container
        
        local assetId = "rbxassetid://125073427434619"
        
        local imageGlow = Instance.new("ImageLabel")
        imageGlow.Size = UDim2.new(0, 110, 0, 110)
        imageGlow.Position = UDim2.new(0.5, 0, 0, 30)
        imageGlow.AnchorPoint = Vector2.new(0.5, 0)
        imageGlow.BackgroundTransparency = 1
        imageGlow.Image = assetId
        imageGlow.ImageTransparency = 0.6
        imageGlow.ImageColor3 = AccentColor
        imageGlow.Parent = container
        
        local function animateGlow()
            local t1 = TweenService:Create(imageGlow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 120, 0, 120), ImageTransparency = 0.7})
            local t2 = TweenService:Create(imageGlow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 110, 0, 110), ImageTransparency = 0.6})
            t1:Play()
            t1.Completed:Wait()
            t2:Play()
            t2.Completed:Wait()
            if imageGlow.Parent then -- Stop if the UI is closed
                animateGlow()
            end
        end
        task.spawn(animateGlow)
        
        local mainImage = Instance.new("ImageLabel")
        mainImage.Size = UDim2.new(0, 100, 0, 100)
        mainImage.Position = UDim2.new(0.5, 0, 0, 35)
        mainImage.AnchorPoint = Vector2.new(0.5, 0)
        mainImage.BackgroundTransparency = 1
        mainImage.Image = assetId
        mainImage.Parent = container
        
        local imgCorner = Instance.new("UICorner")
        imgCorner.CornerRadius = UDim.new(1, 0)
        imgCorner.Parent = mainImage
        
        local devTitle = Instance.new("TextLabel")
        devTitle.Size = UDim2.new(1, 0, 0, 30)
        devTitle.Position = UDim2.new(0, 0, 0, 145)
        devTitle.BackgroundTransparency = 1
        devTitle.Text = "LumaHub"
        devTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        devTitle.TextSize = 24
        devTitle.Font = Enum.Font.GothamBold
        devTitle.Parent = container
        
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, AccentColor)
        }
        grad.Parent = devTitle
        
        local descText = "This UI library was made by revin for LumaHub mainly used to design our scripts and use our custom ui library instead of relying to different ones like Rayfield. You can also use it, if you'd like to."
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -40, 0, 80) -- Adjusted height to fit text
        descLabel.Position = UDim2.new(0.5, 0, 0, 180)
        descLabel.AnchorPoint = Vector2.new(0.5, 0)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = descText
        descLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
        descLabel.TextSize = 14
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextWrapped = true
        descLabel.TextXAlignment = Enum.TextXAlignment.Center
        descLabel.TextYAlignment = Enum.TextYAlignment.Top
        descLabel.Parent = container
        
        return infoTab
    end
    
    function Window:Destroy()
        -- Ensure the close button logic is used for clean shutdown
        closeButton.MouseButton1Click:Fire() 
    end
    
    return Window
end

return Library
