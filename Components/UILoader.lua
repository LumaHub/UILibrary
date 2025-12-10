local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local LumaHub = {}

local Themes = {
	Crimson = {
		Main = Color3.fromRGB(20, 20, 20),
		Accent = Color3.fromRGB(220, 60, 60),
		Stroke = Color3.fromRGB(100, 30, 30),
		Text = Color3.fromRGB(255, 230, 230)
	},
	Blossom = {
		Main = Color3.fromRGB(20, 18, 22),
		Accent = Color3.fromRGB(255, 105, 180),
		Stroke = Color3.fromRGB(120, 50, 90),
		Text = Color3.fromRGB(255, 240, 255)
	},
	Dark = {
		Main = Color3.fromRGB(10, 10, 10),
		Accent = Color3.fromRGB(100, 100, 100),
		Stroke = Color3.fromRGB(40, 40, 40),
		Text = Color3.fromRGB(200, 200, 200)
	},
	Ocean = {
		Main = Color3.fromRGB(15, 20, 30),
		Accent = Color3.fromRGB(0, 190, 255),
		Stroke = Color3.fromRGB(30, 60, 90),
		Text = Color3.fromRGB(230, 245, 255)
	}
}

function LumaHub.Load(Settings)
	local SelectedTheme = Themes[Settings.Theme] or Themes.Blossom
	local TitleText = Settings.Title or "LumaHub"
	
	local ExecutorName = "Unknown"
	if identifyexecutor then
		ExecutorName = identifyexecutor()
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
	
	local MainBackground = Instance.new("Frame")
	MainBackground.Name = "MainBackground"
	MainBackground.Parent = LumaGui
	MainBackground.AnchorPoint = Vector2.new(0.5, 0.5)
	MainBackground.BackgroundColor3 = SelectedTheme.Main
	MainBackground.BorderSizePixel = 0
	MainBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainBackground.Size = UDim2.new(0, 0, 0, 0) 
	MainBackground.ClipsDescendants = true
	
	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 10)
	MainCorner.Parent = MainBackground
	
	local MainStroke = Instance.new("UIStroke")
	MainStroke.Parent = MainBackground
	MainStroke.Thickness = 1
	MainStroke.Color = SelectedTheme.Stroke
	MainStroke.Transparency = 1 
	
	local BackgroundGradient = Instance.new("UIGradient")
	BackgroundGradient.Rotation = 45
	BackgroundGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, SelectedTheme.Main),
		ColorSequenceKeypoint.new(1, Color3.new(SelectedTheme.Main.R * 1.2, SelectedTheme.Main.G * 1.2, SelectedTheme.Main.B * 1.2))
	})
	BackgroundGradient.Parent = MainBackground
	
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "Content"
	ContentContainer.Parent = MainBackground
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Size = UDim2.new(1, 0, 1, 0)
	ContentContainer.Visible = false 
	
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
	
	local LoadingBarContainer = Instance.new("Frame")
	LoadingBarContainer.Parent = ContentContainer
	LoadingBarContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	LoadingBarContainer.BorderSizePixel = 0
	LoadingBarContainer.Position = UDim2.new(0.05, 0, 0.85, 0)
	LoadingBarContainer.Size = UDim2.new(0.9, 0, 0.025, 0)
	LoadingBarContainer.BackgroundTransparency = 1
	
	local BarCorner = Instance.new("UICorner")
	BarCorner.CornerRadius = UDim.new(1, 0)
	BarCorner.Parent = LoadingBarContainer
	
	local LoadingFill = Instance.new("Frame")
	LoadingFill.Parent = LoadingBarContainer
	LoadingFill.BackgroundColor3 = SelectedTheme.Accent
	LoadingFill.BorderSizePixel = 0
	LoadingFill.Size = UDim2.new(0, 0, 1, 0)
	
	local FillCorner = Instance.new("UICorner")
	FillCorner.CornerRadius = UDim.new(1, 0)
	FillCorner.Parent = LoadingFill
	
	local ViewportContainer = Instance.new("Frame")
	ViewportContainer.Parent = ContentContainer
	ViewportContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ViewportContainer.BackgroundTransparency = 0.95
	ViewportContainer.Position = UDim2.new(0.05, 0, 0.22, 0)
	ViewportContainer.Size = UDim2.new(0.25, 0, 0.55, 0)
	ViewportContainer.BackgroundTransparency = 1 
	
	local ViewportCorner = Instance.new("UICorner")
	ViewportCorner.CornerRadius = UDim.new(0, 8)
	ViewportCorner.Parent = ViewportContainer
	
	local ViewportStroke = Instance.new("UIStroke")
	ViewportStroke.Parent = ViewportContainer
	ViewportStroke.Thickness = 1
	ViewportStroke.Color = SelectedTheme.Stroke
	ViewportStroke.Transparency = 1 
	
	local AvatarView = Instance.new("ViewportFrame")
	AvatarView.Parent = ViewportContainer
	AvatarView.BackgroundTransparency = 1
	AvatarView.Size = UDim2.new(1, 0, 1, 0)
	AvatarView.Ambient = Color3.fromRGB(200, 200, 200)
	AvatarView.LightColor = Color3.fromRGB(255, 255, 255)
	
	local WorldModel = Instance.new("WorldModel")
	WorldModel.Parent = AvatarView
	
	local Camera = Instance.new("Camera")
	Camera.Parent = AvatarView
	AvatarView.CurrentCamera = Camera
	
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	Character.Archivable = true
	local ClonedChar = Character:Clone()
	ClonedChar.Parent = WorldModel
	
	local RootPart = ClonedChar:WaitForChild("HumanoidRootPart")
	RootPart.Anchored = true
	ClonedChar:SetPrimaryPartCFrame(CFrame.new(0,0,0))
	Camera.CFrame = CFrame.new(Vector3.new(0, 1.5, -5), RootPart.Position + Vector3.new(0, 1, 0))
	
	local RotationConn = RunService.RenderStepped:Connect(function()
		if ClonedChar and ClonedChar.PrimaryPart then
			ClonedChar:SetPrimaryPartCFrame(ClonedChar.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(1), 0))
		end
	end)
	
	local InfoFrame = Instance.new("Frame")
	InfoFrame.Parent = ContentContainer
	InfoFrame.BackgroundTransparency = 1
	InfoFrame.Position = UDim2.new(0.35, 0, 0.22, 0)
	InfoFrame.Size = UDim2.new(0.6, 0, 0.55, 0)
	
	local function CreateInfoLabel(Text, Order)
		local Label = Instance.new("TextLabel")
		Label.Parent = InfoFrame
		Label.BackgroundTransparency = 1
		Label.Position = UDim2.new(0, 0, (Order - 1) * 0.25, 0)
		Label.Size = UDim2.new(1, 0, 0.2, 0)
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
	
	local LoadSound = Instance.new("Sound")
	LoadSound.SoundId = "rbxassetid://6895079853" 
	LoadSound.Volume = 0.5
	LoadSound.Parent = LumaGui
	
	LoadSound:Play()
	
	local OpenTween = TweenService:Create(MainBackground, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 480, 0, 260)})
	OpenTween:Play()
	OpenTween.Completed:Wait()
	
	ContentContainer.Visible = true
	
	local FadeInfo = TweenInfo.new(0.5)
	TweenService:Create(MainStroke, FadeInfo, {Transparency = 0}):Play()
	TweenService:Create(TitleLabel, FadeInfo, {TextTransparency = 0}):Play()
	TweenService:Create(LoadingBarContainer, FadeInfo, {BackgroundTransparency = 0}):Play()
	TweenService:Create(ViewportContainer, FadeInfo, {BackgroundTransparency = 0.95}):Play()
	TweenService:Create(ViewportStroke, FadeInfo, {Transparency = 0.8}):Play()
	
	for _, lbl in pairs({NameLabel, IDLabel, ClientLabel, StatusLabel}) do
		TweenService:Create(lbl, FadeInfo, {TextTransparency = 0}):Play()
		task.wait(0.1)
	end
	
	StatusLabel.Text = "STATUS: Loading Scripts..."
	TweenService:Create(LoadingFill, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0.4, 0, 1, 0)}):Play()
	task.wait(1.2)
	
	StatusLabel.Text = "STATUS: Getting Data..."
	TweenService:Create(LoadingFill, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0.8, 0, 1, 0)}):Play()
	task.wait(1)
	
	StatusLabel.Text = "STATUS: Ready!"
	TweenService:Create(LoadingFill, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 0, 1, 0)}):Play()
	task.wait(0.8)
	
	local CloseTween = TweenService:Create(MainBackground, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
	CloseTween:Play()
	CloseTween.Completed:Wait()
	
	if RotationConn then RotationConn:Disconnect() end
	LumaGui:Destroy()
	
	return true
end

return LumaHub
