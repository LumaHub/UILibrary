local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local LumaHub = {}

function LumaHub.Load(Settings)
	local TitleText = Settings.Title or "LumaHub"
	local AccentColor = Settings.Color or Color3.fromRGB(115, 120, 255)
	
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
	MainBackground.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	MainBackground.BorderSizePixel = 0
	MainBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainBackground.Size = UDim2.new(0, 0, 0, 0)
	MainBackground.ClipsDescendants = true
	
	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 12)
	MainCorner.Parent = MainBackground
	
	local MainStroke = Instance.new("UIStroke")
	MainStroke.Parent = MainBackground
	MainStroke.Thickness = 1.5
	MainStroke.Color = Color3.fromRGB(45, 45, 45)
	
	local LoaderContent = Instance.new("Frame")
	LoaderContent.Name = "Content"
	LoaderContent.Parent = MainBackground
	LoaderContent.BackgroundTransparency = 1
	LoaderContent.Size = UDim2.new(1, 0, 1, 0)
	LoaderContent.Visible = false
	
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.Parent = LoaderContent
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0.35, 0, 0.35, 0)
	TitleLabel.Size = UDim2.new(0.6, 0, 0.15, 0)
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = TitleText
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextSize = 24
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	local LoadingBarBack = Instance.new("Frame")
	LoadingBarBack.Name = "BarBack"
	LoadingBarBack.Parent = LoaderContent
	LoadingBarBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	LoadingBarBack.BorderSizePixel = 0
	LoadingBarBack.Position = UDim2.new(0.35, 0, 0.6, 0)
	LoadingBarBack.Size = UDim2.new(0.55, 0, 0.02, 0)
	
	local BarCorner = Instance.new("UICorner")
	BarCorner.CornerRadius = UDim.new(1, 0)
	BarCorner.Parent = LoadingBarBack
	
	local LoadingBarFill = Instance.new("Frame")
	LoadingBarFill.Name = "Fill"
	LoadingBarFill.Parent = LoadingBarBack
	LoadingBarFill.BackgroundColor3 = AccentColor
	LoadingBarFill.BorderSizePixel = 0
	LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
	
	local FillCorner = Instance.new("UICorner")
	FillCorner.CornerRadius = UDim.new(1, 0)
	FillCorner.Parent = LoadingBarFill
	
	local FillGradient = Instance.new("UIGradient")
	FillGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, AccentColor),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
	})
	FillGradient.Parent = LoadingBarFill
	
	local AvatarContainer = Instance.new("ViewportFrame")
	AvatarContainer.Name = "AvatarView"
	AvatarContainer.Parent = LoaderContent
	AvatarContainer.BackgroundTransparency = 1
	AvatarContainer.Position = UDim2.new(0.05, 0, 0.15, 0)
	AvatarContainer.Size = UDim2.new(0.25, 0, 0.7, 0)
	AvatarContainer.Ambient = Color3.fromRGB(255, 255, 255)
	AvatarContainer.LightColor = Color3.fromRGB(255, 255, 255)
	AvatarContainer.LightDirection = Vector3.new(1, 1, 1)
	
	local WorldModel = Instance.new("WorldModel")
	WorldModel.Parent = AvatarContainer
	
	local Camera = Instance.new("Camera")
	Camera.Parent = AvatarContainer
	AvatarContainer.CurrentCamera = Camera
	
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	Character.Archivable = true
	
	local ClonedCharacter = Character:Clone()
	ClonedCharacter.Parent = WorldModel
	
	local PrimaryPart = ClonedCharacter:WaitForChild("HumanoidRootPart")
	PrimaryPart.Anchored = true
	
	ClonedCharacter:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))
	
	Camera.CFrame = CFrame.new(Vector3.new(0, 2, -6), PrimaryPart.Position + Vector3.new(0, 1.5, 0))
	
	local RotationConnection
	RotationConnection = RunService.RenderStepped:Connect(function()
		if ClonedCharacter and ClonedCharacter.PrimaryPart then
			ClonedCharacter:SetPrimaryPartCFrame(ClonedCharacter.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(1), 0))
		end
	end)
	
	local OpenTween = TweenService:Create(MainBackground, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 250)})
	OpenTween:Play()
	
	OpenTween.Completed:Wait()
	LoaderContent.Visible = true
	
	local BarTween = TweenService:Create(LoadingBarFill, TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 0, 1, 0)})
	BarTween:Play()
	
	BarTween.Completed:Wait()
	
	task.wait(0.5)
	
	local CloseTween = TweenService:Create(MainBackground, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
	CloseTween:Play()
	
	CloseTween.Completed:Wait()
	
	if RotationConnection then
		RotationConnection:Disconnect()
	end
	LumaGui:Destroy()
	
	return true
end

return LumaHub
