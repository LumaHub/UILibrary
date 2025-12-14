local library = {}

local players = game:GetService("Players")
local tweenservice = game:GetService("TweenService")
local runservice = game:GetService("RunService")
local userinputservice = game:GetService("UserInputService")
local textservice = game:GetService("TextService")

local player = players.LocalPlayer
local mouse = player:GetMouse()

library.themes = {
    ocean = {
        bg = Color3.fromRGB(12, 15, 25),
        bg2 = Color3.fromRGB(18, 22, 35),
        accent = Color3.fromRGB(64, 156, 255),
        accent2 = Color3.fromRGB(41, 128, 185),
        text = Color3.fromRGB(255, 255, 255),
        textdark = Color3.fromRGB(150, 160, 175),
        border = Color3.fromRGB(35, 45, 60)
    },
    blossom = {
        bg = Color3.fromRGB(25, 15, 20),
        bg2 = Color3.fromRGB(35, 22, 30),
        accent = Color3.fromRGB(255, 120, 180),
        accent2 = Color3.fromRGB(255, 90, 150),
        text = Color3.fromRGB(255, 255, 255),
        textdark = Color3.fromRGB(180, 150, 165),
        border = Color3.fromRGB(60, 35, 50)
    },
    crimson = {
        bg = Color3.fromRGB(20, 10, 12),
        bg2 = Color3.fromRGB(30, 15, 18),
        accent = Color3.fromRGB(220, 50, 50),
        accent2 = Color3.fromRGB(180, 30, 30),
        text = Color3.fromRGB(255, 255, 255),
        textdark = Color3.fromRGB(175, 140, 145),
        border = Color3.fromRGB(55, 25, 30)
    },
    oled = {
        bg = Color3.fromRGB(0, 0, 0),
        bg2 = Color3.fromRGB(10, 10, 10),
        accent = Color3.fromRGB(255, 255, 255),
        accent2 = Color3.fromRGB(200, 200, 200),
        text = Color3.fromRGB(255, 255, 255),
        textdark = Color3.fromRGB(130, 130, 130),
        border = Color3.fromRGB(30, 30, 30)
    },
    dark = {
        bg = Color3.fromRGB(18, 18, 24),
        bg2 = Color3.fromRGB(28, 28, 38),
        accent = Color3.fromRGB(100, 120, 255),
        accent2 = Color3.fromRGB(80, 100, 220),
        text = Color3.fromRGB(255, 255, 255),
        textdark = Color3.fromRGB(140, 140, 155),
        border = Color3.fromRGB(40, 40, 50)
    },
    grey = {
        bg = Color3.fromRGB(45, 45, 50),
        bg2 = Color3.fromRGB(55, 55, 60),
        accent = Color3.fromRGB(120, 120, 130),
        accent2 = Color3.fromRGB(100, 100, 110),
        text = Color3.fromRGB(255, 255, 255),
        textdark = Color3.fromRGB(180, 180, 190),
        border = Color3.fromRGB(70, 70, 80)
    },
    white = {
        bg = Color3.fromRGB(245, 245, 250),
        bg2 = Color3.fromRGB(235, 235, 242),
        accent = Color3.fromRGB(80, 120, 255),
        accent2 = Color3.fromRGB(60, 100, 220),
        text = Color3.fromRGB(20, 20, 30),
        textdark = Color3.fromRGB(100, 100, 115),
        border = Color3.fromRGB(200, 200, 210)
    }
}

local currenttheme = library.themes.ocean

local function tween(obj, props, duration, style, direction)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local t = tweenservice:Create(obj, TweenInfo.new(duration, style, direction), props)
    t:Play()
    return t
end

local function makecorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function makestroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or currenttheme.border
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function makedraggable(frame)
    local dragging = false
    local dragstart = nil
    local startpos = nil
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragstart = input.Position
            startpos = frame.Position
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    userinputservice.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragstart
            frame.Position = UDim2.new(
                startpos.X.Scale,
                startpos.X.Offset + delta.X,
                startpos.Y.Scale,
                startpos.Y.Offset + delta.Y
            )
        end
    end)
end

function library:create(config)
    config = config or {}
    local windowname = config.name or "lumahub"
    local themename = config.theme or "ocean"
    currenttheme = library.themes[themename] or library.themes.ocean
    
    local loadersettings = {
        Title = config.loadertitle or windowname,
        Subtitle = config.loadersubtitle or "loading interface...",
        DiscordLink = config.discord,
        YoutubeLink = config.youtube
    }
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "lumahub_" .. windowname
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if gethui then
        gui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = player.PlayerGui
    else
        gui.Parent = player.PlayerGui
    end
    
    local main = Instance.new("Frame")
    main.Name = "main"
    main.Size = UDim2.new(0, 0, 0, 0)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = currenttheme.bg
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Visible = false
    main.Parent = gui
    
    makecorner(main, 12)
    makestroke(main, currenttheme.border)
    
    local topbar = Instance.new("Frame")
    topbar.Name = "topbar"
    topbar.Size = UDim2.new(1, 0, 0, 40)
    topbar.BackgroundColor3 = currenttheme.bg2
    topbar.BorderSizePixel = 0
    topbar.Parent = main
    
    makecorner(topbar, 12)
    
    local topaccent = Instance.new("Frame")
    topaccent.Size = UDim2.new(1, 0, 0, 2)
    topaccent.Position = UDim2.new(0, 0, 0, 0)
    topaccent.BackgroundColor3 = currenttheme.accent
    topaccent.BorderSizePixel = 0
    topaccent.Parent = topbar
    
    makecorner(topaccent, 12)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = windowname
    title.TextColor3 = currenttheme.text
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topbar
    
    local minimize = Instance.new("TextButton")
    minimize.Size = UDim2.new(0, 30, 0, 30)
    minimize.Position = UDim2.new(1, -35, 0.5, -15)
    minimize.BackgroundColor3 = currenttheme.bg
    minimize.Text = "_"
    minimize.TextColor3 = currenttheme.text
    minimize.TextSize = 18
    minimize.Font = Enum.Font.GothamBold
    minimize.Parent = topbar
    
    makecorner(minimize, 6)
    
    local minimized = false
    local originalsize = UDim2.new(0, 550, 0, 400)
    
    minimize.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tween(main, {Size = UDim2.new(0, 550, 0, 40)}, 0.4, Enum.EasingStyle.Exponential)
            minimize.Text = "+"
        else
            tween(main, {Size = originalsize}, 0.4, Enum.EasingStyle.Exponential)
            minimize.Text = "_"
        end
    end)
    
    minimize.MouseEnter:Connect(function()
        tween(minimize, {BackgroundColor3 = currenttheme.accent}, 0.2)
    end)
    
    minimize.MouseLeave:Connect(function()
        tween(minimize, {BackgroundColor3 = currenttheme.bg}, 0.2)
    end)
    
    makedraggable(topbar)
    
    local tabcontainer = Instance.new("Frame")
    tabcontainer.Size = UDim2.new(0, 140, 1, -48)
    tabcontainer.Position = UDim2.new(0, 8, 0, 48)
    tabcontainer.BackgroundTransparency = 1
    tabcontainer.Parent = main
    
    local tablayout = Instance.new("UIListLayout")
    tablayout.SortOrder = Enum.SortOrder.LayoutOrder
    tablayout.Padding = UDim.new(0, 4)
    tablayout.Parent = tabcontainer
    
    local contentcontainer = Instance.new("Frame")
    contentcontainer.Size = UDim2.new(1, -156, 1, -56)
    contentcontainer.Position = UDim2.new(0, 148, 0, 48)
    contentcontainer.BackgroundColor3 = currenttheme.bg2
    contentcontainer.BorderSizePixel = 0
    contentcontainer.ClipsDescendants = true
    contentcontainer.Parent = main
    
    makecorner(contentcontainer, 8)
    
    local credits = Instance.new("TextLabel")
    credits.Size = UDim2.new(1, 0, 0, 20)
    credits.Position = UDim2.new(0, 0, 1, -24)
    credits.BackgroundTransparency = 1
    credits.Text = "powered by lumahub"
    credits.TextColor3 = currenttheme.textdark
    credits.TextSize = 10
    credits.Font = Enum.Font.Gotham
    credits.TextXAlignment = Enum.TextXAlignment.Center
    credits.Parent = main
    
    local window = {}
    window.tabs = {}
    window.currenttab = nil
    
    function window:newtab(config)
        config = config or {}
        local tabname = config.name or "tab"
        local icon = config.icon
        
        local tabbtn = Instance.new("TextButton")
        tabbtn.Size = UDim2.new(1, 0, 0, 36)
        tabbtn.BackgroundColor3 = currenttheme.bg
        tabbtn.Text = ""
        tabbtn.Parent = tabcontainer
        
        makecorner(tabbtn, 8)
        
        local tabicon = Instance.new("TextLabel")
        tabicon.Size = UDim2.new(0, 20, 0, 20)
        tabicon.Position = UDim2.new(0, 10, 0.5, -10)
        tabicon.BackgroundTransparency = 1
        tabicon.Text = icon or "•"
        tabicon.TextColor3 = currenttheme.textdark
        tabicon.TextSize = 16
        tabicon.Font = Enum.Font.GothamBold
        tabicon.Parent = tabbtn
        
        local tabtext = Instance.new("TextLabel")
        tabtext.Size = UDim2.new(1, -40, 1, 0)
        tabtext.Position = UDim2.new(0, 35, 0, 0)
        tabtext.BackgroundTransparency = 1
        tabtext.Text = tabname
        tabtext.TextColor3 = currenttheme.textdark
        tabtext.TextSize = 13
        tabtext.Font = Enum.Font.GothamMedium
        tabtext.TextXAlignment = Enum.TextXAlignment.Left
        tabtext.Parent = tabbtn
        
        local tabcontent = Instance.new("ScrollingFrame")
        tabcontent.Size = UDim2.new(1, -16, 1, -16)
        tabcontent.Position = UDim2.new(0, 8, 0, 8)
        tabcontent.BackgroundTransparency = 1
        tabcontent.BorderSizePixel = 0
        tabcontent.ScrollBarThickness = 4
        tabcontent.ScrollBarImageColor3 = currenttheme.accent
        tabcontent.Visible = false
        tabcontent.Parent = contentcontainer
        
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 8)
        layout.Parent = tabcontent
        
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabcontent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
        end)
        
        tabbtn.MouseButton1Click:Connect(function()
            for _, tab in pairs(window.tabs) do
                tween(tab.button, {BackgroundColor3 = currenttheme.bg})
                tween(tab.icon, {TextColor3 = currenttheme.textdark})
                tween(tab.text, {TextColor3 = currenttheme.textdark})
                tab.content.Visible = false
            end
            
            tween(tabbtn, {BackgroundColor3 = currenttheme.accent})
            tween(tabicon, {TextColor3 = currenttheme.text})
            tween(tabtext, {TextColor3 = currenttheme.text})
            tabcontent.Visible = true
            window.currenttab = tab
        end)
        
        local tab = {}
        tab.button = tabbtn
        tab.icon = tabicon
        tab.text = tabtext
        tab.content = tabcontent
        tab.elements = {}
        
        function tab:addlabel(text)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 30)
            label.BackgroundTransparency = 1
            label.Text = text or "label"
            label.TextColor3 = currenttheme.text
            label.TextSize = 14
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextWrapped = true
            label.Parent = tabcontent
            
            return label
        end
        
        function tab:addbutton(config)
            config = config or {}
            local btntext = config.text or "button"
            local callback = config.callback or function() end
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 36)
            btn.BackgroundColor3 = currenttheme.bg
            btn.Text = ""
            btn.Parent = tabcontent
            
            makecorner(btn, 8)
            makestroke(btn, currenttheme.border)
            
            local btnlabel = Instance.new("TextLabel")
            btnlabel.Size = UDim2.new(1, -16, 1, 0)
            btnlabel.Position = UDim2.new(0, 8, 0, 0)
            btnlabel.BackgroundTransparency = 1
            btnlabel.Text = btntext
            btnlabel.TextColor3 = currenttheme.text
            btnlabel.TextSize = 13
            btnlabel.Font = Enum.Font.GothamMedium
            btnlabel.TextXAlignment = Enum.TextXAlignment.Center
            btnlabel.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                tween(btn, {BackgroundColor3 = currenttheme.accent}, 0.1)
                task.wait(0.15)
                tween(btn, {BackgroundColor3 = currenttheme.bg}, 0.2)
                callback()
            end)
            
            btn.MouseEnter:Connect(function()
                tween(btn, {BackgroundColor3 = currenttheme.bg2})
            end)
            
            btn.MouseLeave:Connect(function()
                tween(btn, {BackgroundColor3 = currenttheme.bg})
            end)
            
            return btn
        end
        
        function tab:addtoggle(config)
            config = config or {}
            local toggletext = config.text or "toggle"
            local default = config.default or false
            local callback = config.callback or function() end
            
            local toggled = default
            
            local toggleframe = Instance.new("Frame")
            toggleframe.Size = UDim2.new(1, 0, 0, 36)
            toggleframe.BackgroundColor3 = currenttheme.bg
            toggleframe.BorderSizePixel = 0
            toggleframe.Parent = tabcontent
            
            makecorner(toggleframe, 8)
            makestroke(toggleframe, currenttheme.border)
            
            local togglelabel = Instance.new("TextLabel")
            togglelabel.Size = UDim2.new(1, -60, 1, 0)
            togglelabel.Position = UDim2.new(0, 12, 0, 0)
            togglelabel.BackgroundTransparency = 1
            togglelabel.Text = toggletext
            togglelabel.TextColor3 = currenttheme.text
            togglelabel.TextSize = 13
            togglelabel.Font = Enum.Font.Gotham
            togglelabel.TextXAlignment = Enum.TextXAlignment.Left
            togglelabel.Parent = toggleframe
            
            local togglebtn = Instance.new("TextButton")
            togglebtn.Size = UDim2.new(0, 40, 0, 20)
            togglebtn.Position = UDim2.new(1, -48, 0.5, -10)
            togglebtn.BackgroundColor3 = toggled and currenttheme.accent or currenttheme.bg2
            togglebtn.Text = ""
            togglebtn.Parent = toggleframe
            
            makecorner(togglebtn, 10)
            
            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 16, 0, 16)
            indicator.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            indicator.BackgroundColor3 = currenttheme.text
            indicator.BorderSizePixel = 0
            indicator.Parent = togglebtn
            
            makecorner(indicator, 8)
            
            togglebtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                tween(togglebtn, {BackgroundColor3 = toggled and currenttheme.accent or currenttheme.bg2})
                tween(indicator, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
                
                callback(toggled)
            end)
            
            return {
                set = function(value)
                    toggled = value
                    togglebtn.BackgroundColor3 = toggled and currenttheme.accent or currenttheme.bg2
                    indicator.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                end
            }
        end
        
        function tab:addslider(config)
            config = config or {}
            local slidertext = config.text or "slider"
            local min = config.min or 0
            local max = config.max or 100
            local default = config.default or min
            local increment = config.increment or 1
            local callback = config.callback or function() end
            
            local value = default
            local dragging = false
            
            local sliderframe = Instance.new("Frame")
            sliderframe.Size = UDim2.new(1, 0, 0, 50)
            sliderframe.BackgroundColor3 = currenttheme.bg
            sliderframe.BorderSizePixel = 0
            sliderframe.Parent = tabcontent
            
            makecorner(sliderframe, 8)
            makestroke(sliderframe, currenttheme.border)
            
            local sliderlabel = Instance.new("TextLabel")
            sliderlabel.Size = UDim2.new(1, -60, 0, 20)
            sliderlabel.Position = UDim2.new(0, 12, 0, 8)
            sliderlabel.BackgroundTransparency = 1
            sliderlabel.Text = slidertext
            sliderlabel.TextColor3 = currenttheme.text
            sliderlabel.TextSize = 13
            sliderlabel.Font = Enum.Font.Gotham
            sliderlabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderlabel.Parent = sliderframe
            
            local slidervalue = Instance.new("TextLabel")
            slidervalue.Size = UDim2.new(0, 50, 0, 20)
            slidervalue.Position = UDim2.new(1, -60, 0, 8)
            slidervalue.BackgroundTransparency = 1
            slidervalue.Text = tostring(value)
            slidervalue.TextColor3 = currenttheme.accent
            slidervalue.TextSize = 13
            slidervalue.Font = Enum.Font.GothamBold
            slidervalue.TextXAlignment = Enum.TextXAlignment.Right
            slidervalue.Parent = sliderframe
            
            local sliderback = Instance.new("Frame")
            sliderback.Size = UDim2.new(1, -24, 0, 4)
            sliderback.Position = UDim2.new(0, 12, 1, -14)
            sliderback.BackgroundColor3 = currenttheme.bg2
            sliderback.BorderSizePixel = 0
            sliderback.Parent = sliderframe
            
            makecorner(sliderback, 2)
            
            local sliderfill = Instance.new("Frame")
            sliderfill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            sliderfill.BackgroundColor3 = currenttheme.accent
            sliderfill.BorderSizePixel = 0
            sliderfill.Parent = sliderback
            
            makecorner(sliderfill, 2)
            
            local function updateslider(input)
                local pos = math.clamp((input.Position.X - sliderback.AbsolutePosition.X) / sliderback.AbsoluteSize.X, 0, 1)
                value = math.floor(((max - min) * pos + min) / increment + 0.5) * increment
                value = math.clamp(value, min, max)
                
                sliderfill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                slidervalue.Text = tostring(value)
                callback(value)
            end
            
            sliderback.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateslider(input)
                end
            end)
            
            sliderback.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            userinputservice.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateslider(input)
                end
            end)
            
            return {
                set = function(newvalue)
                    value = math.clamp(newvalue, min, max)
                    sliderfill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    slidervalue.Text = tostring(value)
                end
            }
        end
        
        function tab:adddropdown(config)
            config = config or {}
            local droptext = config.text or "dropdown"
            local options = config.options or {"option 1", "option 2"}
            local default = config.default
            local callback = config.callback or function() end
            
            local selected = default or options[1]
            local open = false
            
            local dropframe = Instance.new("Frame")
            dropframe.Size = UDim2.new(1, 0, 0, 36)
            dropframe.BackgroundColor3 = currenttheme.bg
            dropframe.BorderSizePixel = 0
            dropframe.ClipsDescendants = false
            dropframe.Parent = tabcontent
            
            makecorner(dropframe, 8)
            makestroke(dropframe, currenttheme.border)
            
            local droplabel = Instance.new("TextLabel")
            droplabel.Size = UDim2.new(1, -60, 1, 0)
            droplabel.Position = UDim2.new(0, 12, 0, 0)
            droplabel.BackgroundTransparency = 1
            droplabel.Text = droptext
            droplabel.TextColor3 = currenttheme.text
            droplabel.TextSize = 13
            droplabel.Font = Enum.Font.Gotham
            droplabel.TextXAlignment = Enum.TextXAlignment.Left
            droplabel.Parent = dropframe
            
            local dropbtn = Instance.new("TextButton")
            dropbtn.Size = UDim2.new(1, -24, 0, 28)
            dropbtn.Position = UDim2.new(0, 12, 0, 4)
            dropbtn.BackgroundColor3 = currenttheme.bg2
            dropbtn.Text = ""
            dropbtn.ZIndex = 2
            dropbtn.Parent = dropframe
            
            makecorner(dropbtn, 6)
            
            local dropselected = Instance.new("TextLabel")
            dropselected.Size = UDim2.new(1, -30, 1, 0)
            dropselected.Position = UDim2.new(0, 8, 0, 0)
            dropselected.BackgroundTransparency = 1
            dropselected.Text = selected
            dropselected.TextColor3 = currenttheme.text
            dropselected.TextSize = 12
            dropselected.Font = Enum.Font.Gotham
            dropselected.TextXAlignment = Enum.TextXAlignment.Left
            dropselected.Parent = dropbtn
            
            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -24, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "▼"
            arrow.TextColor3 = currenttheme.textdark
            arrow.TextSize = 10
            arrow.Font = Enum.Font.Gotham
            arrow.Parent = dropbtn
            
            local optionsframe = Instance.new("Frame")
            optionsframe.Size = UDim2.new(1, -24, 0, 0)
            optionsframe.Position = UDim2.new(0, 12, 0, 36)
            optionsframe.BackgroundColor3 = currenttheme.bg2
            optionsframe.BorderSizePixel = 0
            optionsframe.ClipsDescendants = true
            optionsframe.ZIndex = 3
            optionsframe.Visible = false
            optionsframe.Parent = dropframe
            
            makecorner(optionsframe, 6)
            makestroke(optionsframe, currenttheme.border)
            
            local optionslayout = Instance.new("UIListLayout")
            optionslayout.SortOrder = Enum.SortOrder.LayoutOrder
            optionslayout.Parent = optionsframe
            
            for i, option in ipairs(options) do
                local optionbtn = Instance.new("TextButton")
                optionbtn.Size = UDim2.new(1, 0, 0, 28)
                optionbtn.BackgroundColor3 = currenttheme.bg2
                optionbtn.Text = ""
                optionbtn.ZIndex = 4
                optionbtn.Parent = optionsframe
                
                local optiontext = Instance.new("TextLabel")
                optiontext.Size = UDim2.new(1, -16, 1, 0)
                optiontext.Position = UDim2.new(0, 8, 0, 0)
                optiontext.BackgroundTransparency = 1
                optiontext.Text = option
                optiontext.TextColor3 = currenttheme.text
                optiontext.TextSize = 12
                optiontext.Font = Enum.Font.Gotham
                optiontext.TextXAlignment = Enum.TextXAlignment.Left
                optiontext.ZIndex = 4
                optiontext.Parent = optionbtn
                
                optionbtn.MouseButton1Click:Connect(function()
                    selected = option
                    dropselected.Text = selected
                    open = false
                    optionsframe.Visible = false
                    dropframe.Size = UDim2.new(1, 0, 0, 36)
                    tween(optionsframe, {Size = UDim2.new(1, -24, 0, 0)}, 0.2)
                    tween(arrow, {Rotation = 0}, 0.2)
                    callback(selected)
                end)
                
                optionbtn.MouseEnter:Connect(function()
                    tween(optionbtn, {BackgroundColor3 = currenttheme.bg})
                end)
                
                optionbtn.MouseLeave:Connect(function()
                    tween(optionbtn, {BackgroundColor3 = currenttheme.bg2})
                end)
            end
            
            dropbtn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    optionsframe.Visible = true
                    local height = #options * 28
                    dropframe.Size = UDim2.new(1, 0, 0, 36 + height + 4)
                    tween(optionsframe, {Size = UDim2.new(1, -24, 0, height)}, 0.2)
                    tween(arrow, {Rotation = 180}, 0.2)
                else
                    optionsframe.Visible = false
                    dropframe.Size = UDim2.new(1, 0, 0, 36)
                    tween(optionsframe, {Size = UDim2.new(1, -24, 0, 0)}, 0.2)
                    tween(arrow, {Rotation = 0}, 0.2)
                end
            end)
            
            return {
                set = function(option)
                    selected = option
                    dropselected.Text = selected
                end,
                refresh = function(newoptions)
                    for _, child in pairs(optionsframe:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    options = newoptions
                    for i, option in ipairs(options) do
                        local optionbtn = Instance.new("TextButton")
                        optionbtn.Size = UDim2.new(1, 0, 0, 28)
                        optionbtn.BackgroundColor3 = currenttheme.bg2
                        optionbtn.Text = ""
                        optionbtn.ZIndex = 4
                        optionbtn.Parent = optionsframe
                        
                        local optiontext = Instance.new("TextLabel")
                        optiontext.Size = UDim2.new(1, -16, 1, 0)
                        optiontext.Position = UDim2.new(0, 8, 0, 0)
                        optiontext.BackgroundTransparency = 1
                        optiontext.Text = option
                        optiontext.TextColor3 = currenttheme.text
                        optiontext.TextSize = 12
                        optiontext.Font = Enum.Font.Gotham
                        optiontext.TextXAlignment = Enum.TextXAlignment.Left
                        optiontext.ZIndex = 4
                        optiontext.Parent = optionbtn
                        
                        optionbtn.MouseButton1Click:Connect(function()
                            selected = option
                            dropselected.Text = selected
                            open = false
                            optionsframe.Visible = false
                            dropframe.Size = UDim2.new(1, 0, 0, 36)
                            tween(optionsframe, {Size = UDim2.new(1, -24, 0, 0)}, 0.2)
                            tween(arrow, {Rotation = 0}, 0.2)
                            callback(selected)
                        end)
                        
                        optionbtn.MouseEnter:Connect(function()
                            tween(optionbtn, {BackgroundColor3 = currenttheme.bg})
                        end)
                        
                        optionbtn.MouseLeave:Connect(function()
                            tween(optionbtn, {BackgroundColor3 = currenttheme.bg2})
                        end)
                    end
                end
            }
        end
        
        function tab:addinput(config)
            config = config or {}
            local inputtext = config.text or "input"
            local placeholder = config.placeholder or "enter text..."
            local callback = config.callback or function() end
            
            local inputframe = Instance.new("Frame")
            inputframe.Size = UDim2.new(1, 0, 0, 36)
            inputframe.BackgroundColor3 = currenttheme.bg
            inputframe.BorderSizePixel = 0
            inputframe.Parent = tabcontent
            
            makecorner(inputframe, 8)
            makestroke(inputframe, currenttheme.border)
            
            local inputlabel = Instance.new("TextLabel")
            inputlabel.Size = UDim2.new(1, -12, 0, 18)
            inputlabel.Position = UDim2.new(0, 12, 0, 4)
            inputlabel.BackgroundTransparency = 1
            inputlabel.Text = inputtext
            inputlabel.TextColor3 = currenttheme.text
            inputlabel.TextSize = 12
            inputlabel.Font = Enum.Font.Gotham
            inputlabel.TextXAlignment = Enum.TextXAlignment.Left
            inputlabel.Parent = inputframe
            
            local inputbox = Instance.new("TextBox")
            inputbox.Size = UDim2.new(1, -24, 0, 24)
            inputbox.Position = UDim2.new(0, 12, 0, 22)
            inputbox.BackgroundColor3 = currenttheme.bg2
            inputbox.Text = ""
            inputbox.PlaceholderText = placeholder
            inputbox.TextColor3 = currenttheme.text
            inputbox.PlaceholderColor3 = currenttheme.textdark
            inputbox.TextSize = 12
            inputbox.Font = Enum.Font.Gotham
            inputbox.TextXAlignment = Enum.TextXAlignment.Left
            inputbox.ClearTextOnFocus = false
            inputbox.Parent = inputframe
            
            makecorner(inputbox, 6)
            
            local inputpadding = Instance.new("UIPadding")
            inputpadding.PaddingLeft = UDim.new(0, 8)
            inputpadding.PaddingRight = UDim.new(0, 8)
            inputpadding.Parent = inputbox
            
            inputbox.FocusLost:Connect(function(enter)
                if enter then
                    callback(inputbox.Text)
                end
            end)
            
            inputframe.Size = UDim2.new(1, 0, 0, 54)
            
            return {
                set = function(text)
                    inputbox.Text = text
                end
            }
        end
        
        function tab:addsection(text)
            local section = Instance.new("Frame")
            section.Size = UDim2.new(1, 0, 0, 28)
            section.BackgroundTransparency = 1
            section.Parent = tabcontent
            
            local sectiontext = Instance.new("TextLabel")
            sectiontext.Size = UDim2.new(1, 0, 1, 0)
            sectiontext.BackgroundTransparency = 1
            sectiontext.Text = text or "section"
            sectiontext.TextColor3 = currenttheme.accent
            sectiontext.TextSize = 14
            sectiontext.Font = Enum.Font.GothamBold
            sectiontext.TextXAlignment = Enum.TextXAlignment.Left
            sectiontext.Parent = section
            
            return section
        end
        
        table.insert(window.tabs, tab)
        
        if not window.currenttab then
            tabbtn.BackgroundColor3 = currenttheme.accent
            tabicon.TextColor3 = currenttheme.text
            tabtext.TextColor3 = currenttheme.text
            tabcontent.Visible = true
            window.currenttab = tab
        end
        
        return tab
    end
    
    task.spawn(function()
        if config.loader ~= false then
            local loadermodule = loadstring(game:HttpGet("https://raw.githubusercontent.com/LumaHub/UILibrary/main/loader.lua"))()
            loadermodule.Load(loadersettings)
            task.wait(8)
        end
        
        main.Visible = true
        tween(main, {Size = originalsize}, 0.5, Enum.EasingStyle.Exponential)
    end)
    
    return window
end

return library
