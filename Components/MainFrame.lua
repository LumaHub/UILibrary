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
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
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

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 200, 1, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 2
    sidebar.Parent = mainFrame

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 12)
    sidebarCorner.Parent = sidebar

    local sidebarFix = Instance.new("Frame")
    sidebarFix.Name = "SquareFix"
    sidebarFix.Size = UDim2.new(0, 10, 1, 0)
    sidebarFix.Position = UDim2.new(1, -10, 0, 0)
    sidebarFix.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    sidebarFix.BorderSizePixel = 0
    sidebarFix.Parent = sidebar

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

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -30, 0, 30)
    titleLabel.Position = UDim2.new(0, 15, 0, 15)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = TitleText
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 22
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleContainer

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

    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -200, 1, 0)
    contentArea.Position = UDim2.new(0, 200, 0, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.ClipsDescendants = true
    contentArea.Parent = mainFrame

    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    sidebar.InputBegan:Connect(function(input)
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

    sidebar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 750, 0, 450)
    }):Play()

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
            iconImg.Size = UDim2.new(0, 20, 0, 20)
            iconImg.Position = UDim2.new(0, 8, 0.5, -10)
            iconImg.BackgroundTransparency = 1
            iconImg.Image = icon
            iconImg.ImageColor3 = Color3.fromRGB(150, 150, 160)
            iconImg.Parent = tabButton
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

        local function Activate()
            for _, t in pairs(tabs) do
                TweenService:Create(t.BtnTitle, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 160)}):Play()
                TweenService:Create(t.Button, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                if t.Icon then
                    TweenService:Create(t.Icon, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(150, 150, 160)}):Play()
                end
                t.Page.Visible = false
            end
            
            TweenService:Create(btnTitle, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(tabButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.95}):Play()
            if icon then
                TweenService:Create(tabButton:FindFirstChild("ImageLabel"), TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
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
        
        table.insert(tabs, {
            Button = tabButton,
            BtnTitle = btnTitle,
            Icon = tabButton:FindFirstChild("ImageLabel"),
            Page = page
        })
        
        return tab
    end

    function Window:CreateInfoTab()
        local infoTab = Window:CreateTab("Information", "rbxassetid://3926305904")
        local page = infoTab.Page.Parent:FindFirstChild("InformationPage")
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 300)
        container.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
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
            animateGlow()
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
        descLabel.Size = UDim2.new(1, -40, 0, 100)
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

    return Window
end

return Library
