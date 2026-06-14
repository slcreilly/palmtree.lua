--// Kavo UI Library – Optimized, Modern & Mobile‑Ready
--// Palmtree (Retrowave / Island) default theme
--// Changes: Mobile + PC drag, removed infinite loops, modern visual design,
--// keybind toggle, emoji tabs, smooth toggle switches, QoL improvements.

local Kavo = {}

local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")

local Utility = {}
local ThemeObjects = {}          -- stores objects that need automatic theme updates

--// Registration system – eliminates all while wait() loops
function Kavo:RegisterThemeObject(obj, propertyKey, themeColorKey)
	table.insert(ThemeObjects, {Obj = obj, Property = propertyKey, ThemeColor = themeColorKey})
end

function Kavo:UpdateTheme()
	for _, item in ipairs(ThemeObjects) do
		local color = themeList[item.ThemeColor]
		if color then
			item.Obj[item.Property] = color
		end
	end
	-- update special elements like scrollbar colour
	if pagesFolder then
		for _, page in ipairs(pagesFolder:GetChildren()) do
			if page:IsA("ScrollingFrame") then
				page.ScrollBarImageColor3 = themeList.SchemeColor
			end
		end
	end
	-- re‑apply tab styles
	Kavo:_applyTabStyles()
end

--// Improved Drag (Mouse + Touch)
function Kavo:DraggingEnabled(frame, parent)
	parent = parent or frame
	local uis = game:GetService("UserInputService")
	local dragging = false
	local dragInput, dragStartPos, frameStartPos

	frame.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStartPos = inp.Position
			frameStartPos = parent.Position
			dragInput = inp
			inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
			dragInput = inp
		end
	end)

	uis.InputChanged:Connect(function(inp)
		if inp == dragInput and dragging then
			local delta = inp.Position - dragStartPos
			parent.Position = UDim2.new(
				frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X,
				frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y
			)
		end
	end)
end

function Utility:TweenObject(obj, properties, duration, ...)
	tween:Create(obj, tweeninfo(duration, ...), properties):Play()
end

--// Default Palmtree Theme (Retrowave / Island)
local themes = {
	SchemeColor = Color3.fromRGB(0, 206, 209),    -- turquoise
	Background  = Color3.fromRGB(26, 26, 46),      -- dark navy
	Header      = Color3.fromRGB(20, 20, 35),
	TextColor   = Color3.fromRGB(255, 255, 255),
	ElementColor= Color3.fromRGB(36, 36, 56)
}

-- Legacy theme names still supported
local themeStyles = {
	DarkTheme = {
		SchemeColor = Color3.fromRGB(64, 64, 64),
		Background = Color3.fromRGB(0, 0, 0),
		Header = Color3.fromRGB(0, 0, 0),
		TextColor = Color3.fromRGB(255,255,255),
		ElementColor = Color3.fromRGB(20, 20, 20)
	},
	LightTheme = {
		SchemeColor = Color3.fromRGB(150, 150, 150),
		Background = Color3.fromRGB(255,255,255),
		Header = Color3.fromRGB(200, 200, 200),
		TextColor = Color3.fromRGB(0,0,0),
		ElementColor = Color3.fromRGB(224, 224, 224)
	},
	BloodTheme = {
		SchemeColor = Color3.fromRGB(227, 27, 27),
		Background = Color3.fromRGB(10, 10, 10),
		Header = Color3.fromRGB(5, 5, 5),
		TextColor = Color3.fromRGB(255,255,255),
		ElementColor = Color3.fromRGB(20, 20, 20)
	},
	GrapeTheme = {
		SchemeColor = Color3.fromRGB(166, 71, 214),
		Background = Color3.fromRGB(64, 50, 71),
		Header = Color3.fromRGB(36, 28, 41),
		TextColor = Color3.fromRGB(255,255,255),
		ElementColor = Color3.fromRGB(74, 58, 84)
	},
	Ocean = {
		SchemeColor = Color3.fromRGB(86, 76, 251),
		Background = Color3.fromRGB(26, 32, 58),
		Header = Color3.fromRGB(38, 45, 71),
		TextColor = Color3.fromRGB(200, 200, 200),
		ElementColor = Color3.fromRGB(38, 45, 71)
	},
	Midnight = {
		SchemeColor = Color3.fromRGB(26, 189, 158),
		Background = Color3.fromRGB(44, 62, 82),
		Header = Color3.fromRGB(57, 81, 105),
		TextColor = Color3.fromRGB(255, 255, 255),
		ElementColor = Color3.fromRGB(52, 74, 95)
	},
	Sentinel = {
		SchemeColor = Color3.fromRGB(230, 35, 69),
		Background = Color3.fromRGB(32, 32, 32),
		Header = Color3.fromRGB(24, 24, 24),
		TextColor = Color3.fromRGB(119, 209, 138),
		ElementColor = Color3.fromRGB(24, 24, 24)
	},
	Synapse = {
		SchemeColor = Color3.fromRGB(46, 48, 43),
		Background = Color3.fromRGB(13, 15, 12),
		Header = Color3.fromRGB(36, 38, 35),
		TextColor = Color3.fromRGB(152, 99, 53),
		ElementColor = Color3.fromRGB(24, 24, 24)
	},
	Serpent = {
		SchemeColor = Color3.fromRGB(0, 166, 58),
		Background = Color3.fromRGB(31, 41, 43),
		Header = Color3.fromRGB(22, 29, 31),
		TextColor = Color3.fromRGB(255,255,255),
		ElementColor = Color3.fromRGB(22, 29, 31)
	}
}

local Name = "KavoConfig.JSON"

pcall(function()
	if not pcall(function() readfile(Name) end) then
		writefile(Name, game:service'HttpService':JSONEncode({}))
	end
end)

local LibName = tostring(math.random(1, 100))..tostring(math.random(1,50))..tostring(math.random(1, 100))

function Kavo:ToggleUI()
	if game.CoreGui[LibName] then
		game.CoreGui[LibName].Enabled = not game.CoreGui[LibName].Enabled
	end
end

--// Reference to pages folder (for scrollbar updates)
local pagesFolder

--// Create the main UI
function Kavo.CreateLib(kavName, themeList)
	-- Handle old string-based theme names
	if type(themeList) == "string" and themeStyles[themeList] then
		themeList = themeStyles[themeList]
	elseif not themeList or type(themeList) ~= "table" then
		themeList = themes          -- default Palmtree
	else
		-- fill missing colours
		themeList.SchemeColor = themeList.SchemeColor or Color3.fromRGB(0,206,209)
		themeList.Background  = themeList.Background  or Color3.fromRGB(26,26,46)
		themeList.Header      = themeList.Header      or Color3.fromRGB(20,20,35)
		themeList.TextColor   = themeList.TextColor   or Color3.fromRGB(255,255,255)
		themeList.ElementColor= themeList.ElementColor or Color3.fromRGB(36,36,56)
	end

	kavName = kavName or "Library"
	-- destroy any existing instance with same name
	for _,v in ipairs(game.CoreGui:GetChildren()) do
		if v:IsA("ScreenGui") and v.Name == kavName then
			v:Destroy()
		end
	end

	--// UI construction ----------------------------------------
	local ScreenGui = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local MainCorner = Instance.new("UICorner")
	local MainHeader = Instance.new("Frame")
	local headerCover = Instance.new("UICorner")
	local title = Instance.new("TextLabel")
	local close = Instance.new("ImageButton")
	local MainSide = Instance.new("Frame")
	local sideCorner = Instance.new("UICorner")
	local tabFrames = Instance.new("Frame")
	local tabListing = Instance.new("UIListLayout")
	local pages = Instance.new("Frame")
	Pages = Instance.new("Folder")
	pagesFolder = Pages
	local infoContainer = Instance.new("Frame")
	local blurFrame = Instance.new("Frame")

	ScreenGui.Parent = game.CoreGui
	ScreenGui.Name = LibName
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false

	-- Keybind toggle (RightShift)
	game:GetService("UserInputService").InputBegan:Connect(function(inp, gpe)
		if gpe then return end
		if inp.KeyCode == Enum.KeyCode.RightShift then
			ScreenGui.Enabled = not ScreenGui.Enabled
		end
	end)

	Main.Name = "Main"
	Main.Parent = ScreenGui
	Main.BackgroundColor3 = themeList.Background
	Main.ClipsDescendants = true
	Main.Position = UDim2.new(0.3365, 0, 0.2755, 0)
	Main.Size = UDim2.new(0, 540, 0, 330)

	MainCorner.CornerRadius = UDim.new(0, 8)
	MainCorner.Parent = Main

	MainHeader.Name = "MainHeader"
	MainHeader.Parent = Main
	MainHeader.BackgroundColor3 = themeList.Header
	MainHeader.Size = UDim2.new(0, 540, 0, 34)

	headerCover.CornerRadius = UDim.new(0, 8)
	headerCover.Parent = MainHeader

	title.Name = "title"
	title.Parent = MainHeader
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0.02, 0, 0, 0)
	title.Size = UDim2.new(0, 200, 1, 0)
	title.Font = Enum.Font.GothamBold
	title.Text = kavName
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.TextSize = 16
	title.TextXAlignment = Enum.TextXAlignment.Left

	close.Name = "close"
	close.Parent = MainHeader
	close.BackgroundTransparency = 1
	close.AnchorPoint = Vector2.new(1, 0.5)
	close.Position = UDim2.new(1, -10, 0.5, 0)
	close.Size = UDim2.new(0, 24, 0, 24)
	close.ZIndex = 2
	close.Image = "rbxassetid://3926305904"
	close.ImageRectOffset = Vector2.new(284, 4)
	close.ImageRectSize = Vector2.new(24, 24)

	close.MouseButton1Click:Connect(function()
		local tw = tween:Create(Main, tweeninfo(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0,0,0,0),
			Position = UDim2.new(0, Main.AbsolutePosition.X + Main.AbsoluteSize.X/2, 0, Main.AbsolutePosition.Y + Main.AbsoluteSize.Y/2)
		})
		tw.Completed:Connect(function()
			ScreenGui:Destroy()
		end)
		tw:Play()
	end)

	MainSide.Name = "MainSide"
	MainSide.Parent = Main
	MainSide.BackgroundColor3 = themeList.Header
	MainSide.Position = UDim2.new(0, 0, 0.103, 0)
	MainSide.Size = UDim2.new(0, 160, 0, 296)

	sideCorner.CornerRadius = UDim.new(0, 8)
	sideCorner.Parent = MainSide

	tabFrames.Name = "tabFrames"
	tabFrames.Parent = MainSide
	tabFrames.BackgroundTransparency = 1
	tabFrames.Position = UDim2.new(0.05, 0, 0.02, 0)
	tabFrames.Size = UDim2.new(0, 152, 0, 285)

	tabListing.Parent = tabFrames
	tabListing.SortOrder = Enum.SortOrder.LayoutOrder
	tabListing.Padding = UDim.new(0, 4)

	pages.Name = "pages"
	pages.Parent = Main
	pages.BackgroundTransparency = 1
	pages.BorderSizePixel = 0
	pages.Position = UDim2.new(0.32, 0, 0.14, 0)
	pages.Size = UDim2.new(0, 360, 0, 270)

	Pages.Name = "Pages"
	Pages.Parent = pages

	infoContainer.Name = "infoContainer"
	infoContainer.Parent = Main
	infoContainer.BackgroundTransparency = 1
	infoContainer.ClipsDescendants = true
	infoContainer.Position = UDim2.new(0.32, 0, 0.89, 0)
	infoContainer.Size = UDim2.new(0, 360, 0, 30)

	blurFrame.Name = "blurFrame"
	blurFrame.Parent = pages
	blurFrame.BackgroundColor3 = Color3.new(0,0,0)
	blurFrame.BackgroundTransparency = 1
	blurFrame.BorderSizePixel = 0
	blurFrame.Position = UDim2.new(-0.02, 0, -0.04, 0)
	blurFrame.Size = UDim2.new(0, 376, 0, 289)
	blurFrame.ZIndex = 999

	Kavo:DraggingEnabled(MainHeader, Main)

	-- Register static theme‑dependent objects
	Kavo:RegisterThemeObject(MainHeader, "BackgroundColor3", "Header")
	Kavo:RegisterThemeObject(MainSide, "BackgroundColor3", "Header")
	Kavo:RegisterThemeObject(Main, "BackgroundColor3", "Background")

	--// Store tabs for styling updates
	local tabButtons = {}
	local selectedTabButton = nil

	function Kavo:_applyTabStyles()
		for _, btn in ipairs(tabButtons) do
			if btn == selectedTabButton then
				btn.BackgroundColor3 = themeList.SchemeColor
				-- choose contrast text
				if themeList.SchemeColor == Color3.new(1,1,1) then
					btn.TextColor3 = Color3.new(0,0,0)
				elseif themeList.SchemeColor == Color3.new(0,0,0) then
					btn.TextColor3 = Color3.new(1,1,1)
				else
					btn.TextColor3 = Color3.new(1,1,1)  -- default white
				end
				btn.BackgroundTransparency = 0
			else
				btn.BackgroundTransparency = 1
				btn.TextColor3 = themeList.TextColor
			end
		end
	end

	--// Changing theme colours dynamically
	function Kavo:ChangeColor(prope, color)
		if prope == "Background" then
			themeList.Background = color
		elseif prope == "SchemeColor" then
			themeList.SchemeColor = color
		elseif prope == "Header" then
			themeList.Header = color
		elseif prope == "TextColor" then
			themeList.TextColor = color
		elseif prope == "ElementColor" then
			themeList.ElementColor = color
		end
		Kavo:UpdateTheme()
	end

	--// Tabs -----------------------------------------------------
	local Tabs = {}
	local firstTab = true

	function Tabs:NewTab(tabName, icon)
		icon = icon or ""   -- emoji, e.g. "🌴"
		tabName = tabName or "Tab"

		local tabButton = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")
		local page = Instance.new("ScrollingFrame")
		local pageListing = Instance.new("UIListLayout")

		-- Auto‑size scroll canvas
		local function UpdateSize()
			page.CanvasSize = UDim2.new(0, pageListing.AbsoluteContentSize.X, 0, pageListing.AbsoluteContentSize.Y)
		end

		page.Name = "Page"
		page.Parent = Pages
		page.BackgroundColor3 = themeList.Background
		page.BorderSizePixel = 0
		page.Position = UDim2.new(0, 0, -0.0037, 0)
		page.Size = UDim2.new(1, 0, 1, 0)
		page.ScrollBarThickness = 4
		page.ScrollBarImageColor3 = themeList.SchemeColor
		page.Visible = false

		pageListing.Parent = page
		pageListing.SortOrder = Enum.SortOrder.LayoutOrder
		pageListing.Padding = UDim.new(0, 5)

		tabButton.Name = tabName.."TabButton"
		tabButton.Parent = tabFrames
		tabButton.Size = UDim2.new(0, 148, 0, 32)
		tabButton.AutoButtonColor = false
		tabButton.Font = Enum.Font.GothamSemibold
		tabButton.RichText = true
		tabButton.Text = icon .. "  " .. tabName
		tabButton.TextSize = 14
		tabButton.TextXAlignment = Enum.TextXAlignment.Left
		tabButton.TextColor3 = themeList.TextColor
		tabButton.BackgroundTransparency = 1

		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = tabButton

		table.insert(tabButtons, tabButton)

		if firstTab then
			firstTab = false
			page.Visible = true
			selectedTabButton = tabButton
			Kavo:_applyTabStyles()
			UpdateSize()
		end

		tabButton.MouseButton1Click:Connect(function()
			for _, p in ipairs(Pages:GetChildren()) do
				p.Visible = false
			end
			page.Visible = true
			selectedTabButton = tabButton
			Kavo:_applyTabStyles()
			UpdateSize()
		end)

		page.ChildAdded:Connect(UpdateSize)
		page.ChildRemoved:Connect(UpdateSize)

		--// Sections ------------------------------------------------
		local Sections = {}
		local focusing = false
		local viewDe = false

		function Sections:NewSection(secName, hidden)
			secName = secName or "Section"
			local sectionFrame = Instance.new("Frame")
			local sectionList = Instance.new("UIListLayout")
			local sectionHead = Instance.new("Frame")
			local sHeadCorner = Instance.new("UICorner")
			local sectionName = Instance.new("TextLabel")
			local sectionInners = Instance.new("Frame")
			local sectionElListing = Instance.new("UIListLayout")

			sectionFrame.Parent = page
			sectionFrame.BackgroundColor3 = themeList.Background
			sectionFrame.BorderSizePixel = 0

			sectionList.Parent = sectionFrame
			sectionList.SortOrder = Enum.SortOrder.LayoutOrder
			sectionList.Padding = UDim.new(0, 5)

			sectionHead.Name = "sectionHead"
			sectionHead.Parent = sectionFrame
			sectionHead.BackgroundColor3 = themeList.SchemeColor
			sectionHead.Size = UDim2.new(0, 352, 0, 33)
			if hidden then sectionHead.Visible = false end

			sHeadCorner.CornerRadius = UDim.new(0, 6)
			sHeadCorner.Parent = sectionHead

			sectionName.Parent = sectionHead
			sectionName.BackgroundTransparency = 1
			sectionName.Position = UDim2.new(0.02, 0, 0, 0)
			sectionName.Size = UDim2.new(0.96, 0, 1, 0)
			sectionName.Font = Enum.Font.GothamSemibold
			sectionName.Text = secName
			sectionName.RichText = true
			sectionName.TextSize = 14
			sectionName.TextXAlignment = Enum.TextXAlignment.Left

			-- text contrast on scheme colour
			if themeList.SchemeColor == Color3.new(1,1,1) then
				sectionName.TextColor3 = Color3.new(0,0,0)
			elseif themeList.SchemeColor == Color3.new(0,0,0) then
				sectionName.TextColor3 = Color3.new(1,1,1)
			else
				sectionName.TextColor3 = Color3.new(1,1,1)
			end

			sectionInners.Name = "sectionInners"
			sectionInners.Parent = sectionFrame
			sectionInners.BackgroundTransparency = 1
			sectionInners.Position = UDim2.new(0, 0, 0.19, 0)

			sectionElListing.Parent = sectionInners
			sectionElListing.SortOrder = Enum.SortOrder.LayoutOrder
			sectionElListing.Padding = UDim.new(0, 3)

			Kavo:RegisterThemeObject(sectionHead, "BackgroundColor3", "SchemeColor")
			Kavo:RegisterThemeObject(sectionName, "TextColor3", "TextColor")

			local function updateSectionFrame()
				sectionInners.Size = UDim2.new(1, 0, 0, sectionElListing.AbsoluteContentSize.Y)
				sectionFrame.Size = UDim2.new(0, 352, 0, sectionList.AbsoluteContentSize.Y)
			end
			updateSectionFrame()
			UpdateSize()

			local Elements = {}

			-- Helper to add hover glow
			local function applyHover(btn, callbackOn, callbackOff)
				btn.MouseEnter:Connect(function()
					if not focusing then
						tween:Create(btn, tweeninfo(0.12), {
							BackgroundColor3 = themeList.ElementColor:Lerp(Color3.new(1,1,1), 0.1)
						}):Play()
						if callbackOn then callbackOn() end
					end
				end)
				btn.MouseLeave:Connect(function()
					if not focusing then
						tween:Create(btn, tweeninfo(0.12), {
							BackgroundColor3 = themeList.ElementColor
						}):Play()
						if callbackOff then callbackOff() end
					end
				end)
			end

			--// Button -------------------------------------------------
			function Elements:NewButton(bname, tipINf, callback)
				callback = callback or function() end
				tipINf = tipINf or "Click to perform action"

				local buttonElement = Instance.new("TextButton")
				local UICorner = Instance.new("UICorner")
				local btnInfo = Instance.new("TextLabel")
				local viewInfo = Instance.new("ImageButton")
				local touch = Instance.new("ImageLabel")
				local Sample = Instance.new("ImageLabel")

				buttonElement.Parent = sectionInners
				buttonElement.BackgroundColor3 = themeList.ElementColor
				buttonElement.ClipsDescendants = true
				buttonElement.Size = UDim2.new(0, 352, 0, 33)
				buttonElement.AutoButtonColor = false
				buttonElement.Font = Enum.Font.SourceSans
				buttonElement.Text = ""
				buttonElement.TextColor3 = Color3.new(0,0,0)
				buttonElement.TextSize = 14

				UICorner.CornerRadius = UDim.new(0, 6)
				UICorner.Parent = buttonElement

				viewInfo.Name = "viewInfo"
				viewInfo.Parent = buttonElement
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(0.93, 0, 0.18, 0)
				viewInfo.Size = UDim2.new(0, 20, 0, 20)
				viewInfo.ZIndex = 2
				viewInfo.Image = "rbxassetid://3926305904"
				viewInfo.ImageColor3 = themeList.SchemeColor
				viewInfo.ImageRectOffset = Vector2.new(764, 764)
				viewInfo.ImageRectSize = Vector2.new(36, 36)

				Sample.Name = "Sample"
				Sample.Parent = buttonElement
				Sample.BackgroundTransparency = 1
				Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
				Sample.ImageColor3 = themeList.SchemeColor
				Sample.ImageTransparency = 0.6

				touch.Parent = buttonElement
				touch.BackgroundTransparency = 1
				touch.Position = UDim2.new(0.02, 0, 0.18, 0)
				touch.Size = UDim2.new(0, 20, 0, 20)
				touch.Image = "rbxassetid://3926305904"
				touch.ImageColor3 = themeList.SchemeColor
				touch.ImageRectOffset = Vector2.new(84, 204)
				touch.ImageRectSize = Vector2.new(36, 36)

				btnInfo.Parent = buttonElement
				btnInfo.BackgroundTransparency = 1
				btnInfo.Position = UDim2.new(0.095, 0, 0, 0)
				btnInfo.Size = UDim2.new(0.8, 0, 1, 0)
				btnInfo.Font = Enum.Font.GothamSemibold
				btnInfo.Text = bname
				btnInfo.RichText = true
				btnInfo.TextSize = 14
				btnInfo.TextXAlignment = Enum.TextXAlignment.Left

				-- info popup
				local moreInfo = Instance.new("TextLabel")
				local UICornerInf = Instance.new("UICorner")
				moreInfo.Name = "TipMore"
				moreInfo.Parent = infoContainer
				moreInfo.BackgroundColor3 = themeList.SchemeColor:Lerp(Color3.new(0,0,0), 0.2)
				moreInfo.Position = UDim2.new(0, 0, 2, 0)
				moreInfo.Size = UDim2.new(0, 352, 0, 30)
				moreInfo.ZIndex = 9
				moreInfo.Font = Enum.Font.GothamSemibold
				moreInfo.Text = "  " .. tipINf
				moreInfo.RichText = true
				moreInfo.TextColor3 = Color3.new(1,1,1)
				moreInfo.TextSize = 14
				moreInfo.TextXAlignment = Enum.TextXAlignment.Left
				UICornerInf.CornerRadius = UDim.new(0, 6)
				UICornerInf.Parent = moreInfo

				-- ripple effect on click
				local ms = game.Players.LocalPlayer:GetMouse()
				buttonElement.MouseButton1Click:Connect(function()
					if focusing then
						for _, v in ipairs(infoContainer:GetChildren()) do
							tween:Create(v, tweeninfo(0.15), {Position = UDim2.new(0,0,2,0)}):Play()
						end
						focusing = false
						tween:Create(blurFrame, tweeninfo(0.15), {BackgroundTransparency = 1}):Play()
						return
					end
					callback()
					-- ripple
					local c = Sample:Clone()
					c.Parent = buttonElement
					local x = ms.X - c.AbsolutePosition.X
					local y = ms.Y - c.AbsolutePosition.Y
					c.Position = UDim2.new(0, x, 0, y)
					local s = math.max(buttonElement.AbsoluteSize.X, buttonElement.AbsoluteSize.Y) * 1.5
					local twRipple = tween:Create(c, tweeninfo(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, s, 0, s),
						Position = UDim2.new(0.5, -s/2, 0.5, -s/2),
						ImageTransparency = 1
					})
					twRipple.Completed:Connect(function() c:Destroy() end)
					twRipple:Play()
				end)

				-- view info button
				viewInfo.MouseButton1Click:Connect(function()
					if viewDe then return end
					viewDe = true
					focusing = true
					for _, v in ipairs(infoContainer:GetChildren()) do
						if v ~= moreInfo then
							tween:Create(v, tweeninfo(0.15), {Position = UDim2.new(0,0,2,0)}):Play()
						end
					end
					tween:Create(moreInfo, tweeninfo(0.15), {Position = UDim2.new(0,0,0,0)}):Play()
					tween:Create(blurFrame, tweeninfo(0.15), {BackgroundTransparency = 0.5}):Play()
					delay(1.5, function()
						focusing = false
						tween:Create(moreInfo, tweeninfo(0.15), {Position = UDim2.new(0,0,2,0)}):Play()
						tween:Create(blurFrame, tweeninfo(0.15), {BackgroundTransparency = 1}):Play()
						viewDe = false
					end)
				end)

				applyHover(buttonElement)
				updateSectionFrame()
				UpdateSize()

				Kavo:RegisterThemeObject(buttonElement, "BackgroundColor3", "ElementColor")
				Kavo:RegisterThemeObject(btnInfo, "TextColor3", "TextColor")
				Kavo:RegisterThemeObject(viewInfo, "ImageColor3", "SchemeColor")
				Kavo:RegisterThemeObject(touch, "ImageColor3", "SchemeColor")
				Kavo:RegisterThemeObject(Sample, "ImageColor3", "SchemeColor")

				local ButtonFunction = {}
				function ButtonFunction:UpdateButton(newTitle)
					btnInfo.Text = newTitle
				end
				return ButtonFunction
			end

			--// TextBox ------------------------------------------------
			function Elements:NewTextBox(tname, tTip, callback)
				callback = callback or function() end
				tTip = tTip or "Type and press Enter"

				local textboxElement = Instance.new("TextButton")
				local UICorner = Instance.new("UICorner")
				local togName = Instance.new("TextLabel")
				local viewInfo = Instance.new("ImageButton")
				local write = Instance.new("ImageLabel")
				local TextBox = Instance.new("TextBox")
				local UICorner_2 = Instance.new("UICorner")

				textboxElement.Parent = sectionInners
				textboxElement.BackgroundColor3 = themeList.ElementColor
				textboxElement.ClipsDescendants = true
				textboxElement.Size = UDim2.new(0, 352, 0, 33)
				textboxElement.AutoButtonColor = false
				textboxElement.Font = Enum.Font.SourceSans
				textboxElement.Text = ""

				UICorner.CornerRadius = UDim.new(0, 6)
				UICorner.Parent = textboxElement

				viewInfo.Parent = textboxElement
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(0.93, 0, 0.18, 0)
				viewInfo.Size = UDim2.new(0, 20, 0, 20)
				viewInfo.ZIndex = 2
				viewInfo.Image = "rbxassetid://3926305904"
				viewInfo.ImageRectOffset = Vector2.new(764, 764)
				viewInfo.ImageRectSize = Vector2.new(36, 36)

				write.Parent = textboxElement
				write.BackgroundTransparency = 1
				write.Position = UDim2.new(0.02, 0, 0.18, 0)
				write.Size = UDim2.new(0, 20, 0, 20)
				write.Image = "rbxassetid://3926305904"
				write.ImageRectOffset = Vector2.new(324, 604)
				write.ImageRectSize = Vector2.new(36, 36)

				TextBox.Parent = textboxElement
				TextBox.BackgroundColor3 = themeList.ElementColor:Lerp(Color3.new(0,0,0), 0.1)
				TextBox.BorderSizePixel = 0
				TextBox.Position = UDim2.new(0.5, -80, 0.5, -9)
				TextBox.Size = UDim2.new(0, 160, 0, 18)
				TextBox.ClearTextOnFocus = false
				TextBox.Font = Enum.Font.Gotham
				TextBox.PlaceholderText = "Type here!"
				TextBox.Text = ""
				TextBox.TextColor3 = themeList.SchemeColor
				TextBox.TextSize = 12

				UICorner_2.CornerRadius = UDim.new(0, 4)
				UICorner_2.Parent = TextBox

				togName.Parent = textboxElement
				togName.BackgroundTransparency = 1
				togName.Position = UDim2.new(0.095, 0, 0.5, -7)
				togName.Size = UDim2.new(0, 130, 0, 14)
				togName.Font = Enum.Font.GothamSemibold
				togName.Text = tname
				togName.RichText = true
				togName.TextSize = 14
				togName.TextXAlignment = Enum.TextXAlignment.Left

				local moreInfo = Instance.new("TextLabel")
				local UICornerInf = Instance.new("UICorner")
				moreInfo.Parent = infoContainer
				moreInfo.BackgroundColor3 = themeList.SchemeColor:Lerp(Color3.new(0,0,0), 0.2)
				moreInfo.Position = UDim2.new(0, 0, 2, 0)
				moreInfo.Size = UDim2.new(0, 352, 0, 30)
				moreInfo.ZIndex = 9
				moreInfo.Font = Enum.Font.GothamSemibold
				moreInfo.Text = "  "..tTip
				moreInfo.RichText = true
				moreInfo.TextColor3 = Color3.new(1,1,1)
				moreInfo.TextSize = 14
				moreInfo.TextXAlignment = Enum.TextXAlignment.Left
				UICornerInf.CornerRadius = UDim.new(0, 6)
				UICornerInf.Parent = moreInfo

				textboxElement.MouseButton1Click:Connect(function()
					if focusing then
						for _, v in ipairs(infoContainer:GetChildren()) do
							tween:Create(v, tweeninfo(0.15), {Position = UDim2.new(0,0,2,0)}):Play()
						end
						focusing = false
						tween:Create(blurFrame, tweeninfo(0.15), {BackgroundTransparency = 1}):Play()
					end
				end)

				TextBox.FocusLost:Connect(function(enterPressed)
					if focusing then
						focusing = false
						-- hide info if open
					end
					if enterPressed then
						callback(TextBox.Text)
						TextBox.Text = ""
					end
				end)

				viewInfo.MouseButton1Click:Connect(function()
					if viewDe then return end
					viewDe = true
					focusing = true
					for _, v in ipairs(infoContainer:GetChildren()) do
						if v ~= moreInfo then
							tween:Create(v, tweeninfo(0.15), {Position = UDim2.new(0,0,2,0)}):Play()
						end
					end
					tween:Create(moreInfo, tweeninfo(0.15), {Position = UDim2.new(0,0,0,0)}):Play()
					tween:Create(blurFrame, tweeninfo(0.15), {BackgroundTransparency = 0.5}):Play()
					delay(1.5, function()
						focusing = false
						tween:Create(moreInfo, tweeninfo(0.15), {Position = UDim2.new(0,0,2,0)}):Play()
						tween:Create(blurFrame, tweeninfo(0.15), {BackgroundTransparency = 1}):Play()
						viewDe = false
					end)
				end)

				applyHover(textboxElement)
				updateSectionFrame()
				UpdateSize()

				Kavo:RegisterThemeObject(textboxElement, "BackgroundColor3", "ElementColor")
				Kavo:RegisterThemeObject(togName, "TextColor3", "TextColor")
				Kavo:RegisterThemeObject(viewInfo, "ImageColor3", "SchemeColor")
				Kavo:RegisterThemeObject(write, "ImageColor3", "SchemeColor")
				Kavo:RegisterThemeObject(TextBox, "TextColor3", "SchemeColor")
			end

			--// Toggle (Modern Slider Switch) -------------------------
			function Elements:NewToggle(tname, nTip, callback)
				callback = callback or function() end
				nTip = nTip or "Toggle state"

				local toggleElement = Instance.new("TextButton")
				local UICorner = Instance.new("UICorner")
				local togName = Instance.new("TextLabel")
				local viewInfo = Instance.new("ImageButton")

				-- custom toggle frame
				local toggleFrame = Instance.new("Frame")
				local toggleFrameCorner = Instance.new("UICorner")
				local toggleCircle = Instance.new("Frame")
				local toggleCircleCorner = Instance.new("UICorner")

				toggleElement.Parent = sectionInners
				toggleElement.BackgroundColor3 = themeList.ElementColor
				toggleElement.ClipsDescendants = true
				toggleElement.Size = UDim2.new(0, 352, 0, 33)
				toggleElement.AutoButtonColor = false
				toggleElement.Font = Enum.Font.SourceSans
				toggleElement.Text = ""

				UICorner.CornerRadius = UDim.new(0, 6)
				UICorner.Parent = toggleElement

				togName.Parent = toggleElement
				togName.BackgroundTransparency = 1
				togName.Position = UDim2.new(0.095, 0, 0.5, -7)
				togName.Size = UDim2.new(0, 250, 0, 14)
				togName.Font = Enum.Font.GothamSemibold
				togName.Text = tname
				togName.RichText = true
				togName.TextSize = 14
				togName.TextXAlignment = Enum.TextXAlignment.Left

				viewInfo.Parent = toggleElement
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(0.93, 0, 0.18, 0)
				viewInfo.Size = UDim2.new(0, 20, 0, 20)
				viewInfo.ZIndex = 2
				viewInfo.Image = "rbxassetid://3926305904"
				viewInfo.ImageRectOffset = Vector2.new(764, 764)
				viewInfo.ImageRectSize = Vector2.new(36, 36)

				-- Switch design
				toggleFrame.Parent = toggleElement
				toggleFrame.BackgroundColor3 = themeList.ElementColor:Lerp(Color3.new(1,1,1), 0.15)
				toggleFrame.BorderSizePixel = 0
				toggleFrame.Position = UDim2.new(1, -60, 0.5, -10)
				toggleFrame.Size = UDim2.new(0, 40, 0, 20)
				toggleFrameCorner.CornerRadius = UDim.new(1, 0)
				toggleFrameCorner.Parent = toggleFrame

				toggleCircle.Parent = toggleFrame
				toggleCircle.BackgroundColor3 = themeList.SchemeColor
				toggleCircle.BorderSizePixel = 0
				toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
				toggleCircle.Size = UDim2.new(0, 16, 0, 16)
				toggleCircleCorner.CornerRadius = UDim.new(1, 0)
				toggleCircleCorner.Parent = toggleCircle

				local toggled = false

				local moreInfo = Instance.new("TextLabel")
				local UICornerInf = Instance.new("UICorner")
				moreInfo.Parent = infoContainer
				moreInfo.BackgroundColor3 = themeList.SchemeColor:Lerp(Color3.new(0,0,0), 0.2)
				moreInfo.Position = UDim2.new(0, 0, 2, 0)
				moreInfo.Size = UDim2.new(0, 352, 0, 30)
				moreInfo.ZIndex = 9
				moreInfo.Font = Enum.Font.GothamSemibold
				moreInfo.Text = "  "..nTip
				moreInfo.RichText = true
				moreInfo.TextColor3 = Color3.new(1,1,1)
				moreInfo.TextSize = 14
				moreInfo.TextXAlignment = Enum.TextXAlignment.Left
				UICornerInf.CornerRadius = UDim.new(0, 6)
				UICornerInf.Parent = moreInfo

				local function setToggle(on)
					toggled = on
					if on then
						tween:Create(toggleCircle, tweeninfo(0.15), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
						tween:Create(toggleFrame, tweeninfo(0.15), {BackgroundColor3 = themeList.SchemeColor}):Play()
					else
						tween:Create(toggleCircle, tweeninfo(0.15), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
						tween:Create(toggleFrame, tweeninfo(0.15), {BackgroundColor3 = themeList.ElementColor:Lerp(Color3.new(1,1,1), 0.15)}):Play()
					end
				end

				toggleElement.MouseButton1Click:Connect(function()
					if focusing then return end
					setToggle(not toggled)
					pcall(callback, toggled)
				end)

				viewInfo.MouseButton1Click:Connect(function()
					if viewDe then return end
					viewDe = true
					focusing = true
					for _, v in ipairs(infoContainer:GetChildren()) do
						if v ~= moreInfo then
							tween:Create(v, tweeninfo(0.15), {Position = UDim2.new(0,0,2,0)}):Play()
						end
					end
					tween:Create(moreInfo, tweeninfo(0.15), {Position = UDim2.new(0,0,0,0)}):Play()
					tween:Create(blurFrame, tweeninfo(0.15), {BackgroundTransparency = 0.5}):Play()
					delay(1.5, function()
						focusing = false
						tween:Create(moreInfo, tweeninfo(0.15), {Position = UDim2.new(0,0,2,0)}):Play()
						tween:Create(blurFrame, tweeninfo(0.15), {BackgroundTransparency = 1}):Play()
						viewDe = false
					end)
				end)

				applyHover(toggleElement)
				updateSectionFrame()
				UpdateSize()

				Kavo:RegisterThemeObject(toggleElement, "BackgroundColor3", "ElementColor")
				Kavo:RegisterThemeObject(togName, "TextColor3", "TextColor")
				Kavo:RegisterThemeObject(viewInfo, "ImageColor3", "SchemeColor")
				-- toggle circle colour registered as SchemeColor
				Kavo:RegisterThemeObject(toggleCircle, "BackgroundColor3", "SchemeColor")

				local TogFunction = {}
				function TogFunction:UpdateToggle(newText, isTogOn)
					if newText then togName.Text = newText end
					if isTogOn ~= nil then
						setToggle(isTogOn)
						pcall(callback, isTogOn)
					end
				end
				return TogFunction
			end

			--// Slider -------------------------------------------------
			function Elements:NewSlider(slidInf, slidTip, maxvalue, minvalue, callback)
				maxvalue = maxvalue or 500
				minvalue = minvalue or 16
				callback = callback or function() end

				local sliderElement = Instance.new("TextButton")
				local UICorner = Instance.new("UICorner")
				local togName = Instance.new("TextLabel")
				local viewInfo = Instance.new("ImageButton")
				local sliderBtn = Instance.new("TextButton")
				local sliderDrag = Instance.new("Frame")
				local sliderThumb = Instance.new("Frame")   -- circle thumb
				local val = Instance.new("TextLabel")

				sliderElement.Parent = sectionInners
				sliderElement.BackgroundColor3 = themeList.ElementColor
				sliderElement.ClipsDescendants = true
				sliderElement.Size = UDim2.new(0, 352, 0, 33)
				sliderElement.AutoButtonColor = false
				sliderElement.Font = Enum.Font.SourceSans
				sliderElement.Text = ""

				UICorner.CornerRadius = UDim.new(0, 6)
				UICorner.Parent = sliderElement

				togName.Parent = sliderElement
				togName.BackgroundTransparency = 1
				togName.Position = UDim2.new(0.095, 0, 0.5, -7)
				togName.Size = UDim2.new(0, 130, 0, 14)
				togName.Font = Enum.Font.GothamSemibold
				togName.Text = slidInf
				togName.RichText = true
				togName.TextSize = 14
				togName.TextXAlignment = Enum.TextXAlignment.Left

				viewInfo.Parent = sliderElement
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(0.93, 0, 0.18, 0)
				viewInfo.Size = UDim2.new(0, 20, 0, 20)
				viewInfo.ZIndex = 2
				viewInfo.Image = "rbxassetid://3926305904"
				viewInfo.ImageRectOffset = Vector2.new(764, 764)
				viewInfo.ImageRectSize = Vector2.new(36, 36)

				sliderBtn.Parent = sliderElement
				sliderBtn.BackgroundColor3 = themeList.ElementColor:Lerp(Color3.new(0,0,0), 0.15)
				sliderBtn.BorderSizePixel = 0
				sliderBtn.Position = UDim2.new(0.49, 0, 0.6, 0)
				sliderBtn.Size = UDim2.new(0, 150, 0, 6)
				sliderBtn.AutoButtonColor = false
				sliderBtn.Text = ""
				local sliderBtnCorner = Instance.new("UICorner")
				sliderBtnCorner.CornerRadius = UDim.new(0, 3)
				sliderBtnCorner.Parent = sliderBtn

				sliderDrag.Parent = sliderBtn
				sliderDrag.BackgroundColor3 = themeList.SchemeColor
				sliderDrag.BorderSizePixel = 0
				sliderDrag.Size = UDim2.new(0, 50, 1, 0)  -- initial
				local dragCorner = Instance.new("UICorner")
				dragCorner.CornerRadius = UDim.new(0, 3)
				dragCorner.Parent = sliderDrag

				sliderThumb.Parent = sliderDrag
				sliderThumb.BackgroundColor3 = themeList.SchemeColor
				sliderThumb.BorderSizePixel = 0
				sliderThumb.AnchorPoint = Vector2.new(1, 0.5)
				sliderThumb.Position = UDim2.new(1, 0, 0.5, 0)
				sliderThumb.Size = UDim2.new(0, 12, 0, 12)
				local thumbCorner = Instance.new("UICorner")
				thumbCorner.CornerRadius = UDim.new(1, 0)
				thumbCorner.Parent = sliderThumb

				val.Parent = sliderElement
				val.BackgroundTransparency = 1
				val.Position = UDim2.new(0.35, 0, 0.5, -7)
				val.Size = UDim2.new(0, 50, 0, 14)
				val.Font = Enum.Font.GothamSemibold
				val.Text = tostring(minvalue)
				val.TextColor3 = themeList.TextColor
				val.TextSize = 14
				val.TextTransparency = 0.5

				local moreInfo = Instance.new("TextLabel")
				local UICornerInf = Instance.new("UICorner")
				moreInfo.Parent = infoContainer
				moreInfo.BackgroundColor3 = themeList.SchemeColor:Lerp(Color3.new(0,0,0), 0.2)
				moreInfo.Position = UDim2.new(0, 0, 2, 0)
				moreInfo.Size = UDim2.new(0, 352, 0, 30)
				moreInfo.ZIndex = 9
				moreInfo.Font = Enum.Font.GothamSemibold
				moreInfo.Text = "  "..slidTip
				moreInfo.RichText = true
				moreInfo.TextColor3 = Color3.new(1,1,1)
				moreInfo.TextSize = 14
				moreInfo.TextXAlignment = Enum.TextXAlignment.Left
				UICornerInf.CornerRadius = UDim.new(0, 6)
				UICornerInf.Parent = moreInfo

				local mouse = game.Players.LocalPlayer:GetMouse()
				local uis = game:GetService("UserInputService")
				local sliderActive = false
				local moveConn, releaseConn

				local function updateValue()
					local percent = sliderDrag.AbsoluteSize.X / 150
					local value = math.floor(minvalue + (maxvalue - minvalue) * percent)
					val.Text = tostring(value)
					pcall(callback, value)
					return value
				end

				sliderBtn.MouseButton1Down:Connect(function()
					if focusing then return end
					sliderActive = true
					val.TextTransparency = 0
					moveConn = mouse.Move:Connect(function()
						local x = math.clamp(mouse.X - sliderBtn.AbsolutePosition.X, 0, 150)
						sliderDrag.Size = UDim2.new(0, x, 1, 0)
						updateValue()
					end)
					releaseConn = uis.InputEnded:Connect(function(inp)
						if inp.UserInputType == Enum.UserInputType.MouseButton1 then
							sliderActive = false
							if moveConn then moveConn:Disconnect() end
							if releaseConn then releaseConn:Disconnect() end
							updateValue()
							tween:Create(val, tweeninfo(0.1), {TextTransparency = 0.5}):Play()
						end
					end)
				end)

				viewInfo.MouseButton1Click:Connect(function()
					if viewDe then return end
					viewDe = true
					focusing = true
					for _, v in ipairs(infoContainer:GetChildren()) do
						if v ~= moreInfo then
							tween:Create(v, tweeninfo(0.15), {Position = UDim2.new(0,0,2,0)}):Play()
						end
					end
					tween:Create(moreInfo, tweeninfo(0.15), {Position = UDim2.new(0,0,0,0)}):Play()
					tween:Create(blurFrame, tweeninfo(0.15), {BackgroundTransparency = 0.5}):Play()
					delay(1.5, function()
						focusing = false
						tween:Create(moreInfo, tweeninfo(0.15), {Position = UDim2.new(0,0,2,0)}):Play()
						tween:Create(blurFrame, tweeninfo(0.15), {BackgroundTransparency = 1}):Play()
						viewDe = false
					end)
				end)

				applyHover(sliderElement)
				updateSectionFrame()
				UpdateSize()

				Kavo:RegisterThemeObject(sliderElement, "BackgroundColor3", "ElementColor")
				Kavo:RegisterThemeObject(togName, "TextColor3", "TextColor")
				Kavo:RegisterThemeObject(viewInfo, "ImageColor3", "SchemeColor")
				Kavo:RegisterThemeObject(sliderDrag, "BackgroundColor3", "SchemeColor")
				Kavo:RegisterThemeObject(sliderThumb, "BackgroundColor3", "SchemeColor")
				Kavo:RegisterThemeObject(val, "TextColor3", "TextColor")
			end

			--// Dropdown -----------------------------------------------
			function Elements:NewDropdown(dropname, dropinf, list, callback)
				callback = callback or function() end
				local dropFrame = Instance.new("Frame")
				local dropOpen = Instance.new("TextButton")
				local itemText = Instance.new("TextLabel")
				local viewInfo = Instance.new("ImageButton")
				local UICorner = Instance.new("UICorner")
				local UIListLayout = Instance.new("UIListLayout")

				dropFrame.Parent = sectionInners
				dropFrame.BackgroundColor3 = themeList.Background
				dropFrame.BorderSizePixel = 0
				dropFrame.Size = UDim2.new(0, 352, 0, 33)
				dropFrame.ClipsDescendants = true

				dropOpen.Parent = dropFrame
				dropOpen.BackgroundColor3 = themeList.ElementColor
				dropOpen.Size = UDim2.new(0, 352, 0, 33)
				dropOpen.AutoButtonColor = false
				dropOpen.Font = Enum.Font.SourceSans
				dropOpen.Text = ""

				UICorner.CornerRadius = UDim.new(0, 6)
				UICorner.Parent = dropOpen

				itemText.Parent = dropOpen
				itemText.BackgroundTransparency = 1
				itemText.Position = UDim2.new(0.1, 0, 0.5, -7)
				itemText.Size = UDim2.new(0, 200, 0, 14)
				itemText.Font = Enum.Font.GothamSemibold
				itemText.Text = dropname
				itemText.RichText = true
				itemText.TextSize = 14
				itemText.TextXAlignment = Enum.TextXAlignment.Left

				viewInfo.Parent = dropOpen
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(0.93, 0, 0.18, 0)
				viewInfo.Size = UDim2.new(0, 20, 0, 20)
				viewInfo.ZIndex = 2
				viewInfo.Image = "rbxassetid://3926305904"
				viewInfo.ImageRectOffset = Vector2.new(764, 764)
				viewInfo.ImageRectSize = Vector2.new(36, 36)

				UIListLayout.Parent = dropFrame
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0, 3)

				local opened = false
				local function closeDropdown()
					opened = false
					dropFrame:TweenSize(UDim2.new(0,352,0,33), "InOut", "Linear", 0.1, true)
				end

				dropOpen.MouseButton1Click:Connect(function()
					if focusing then return end
					if opened then
						closeDropdown()
					else
						opened = true
						dropFrame:TweenSize(UDim2.new(0,352,0, UIListLayout.AbsoluteContentSize.Y), "InOut", "Linear", 0.1, true)
					end
					updateSectionFrame()
					UpdateSize()
				end)

				local moreInfo = Instance.new("TextLabel")
				local UICornerInf = Instance.new("UICorner")
				moreInfo.Parent = infoContainer
				moreInfo.BackgroundColor3 = themeList.SchemeColor:Lerp(Color3.new(0,0,0), 0.2)
				moreInfo.Position = UDim2.new(0, 0, 2, 0)
				moreInfo.Size = UDim2.new(0, 352, 0, 30)
				moreInfo.ZIndex = 9
				moreInfo.Font = Enum.Font.GothamSemibold
				moreInfo.Text = "  "..dropinf
				moreInfo.RichText = true
				moreInfo.TextColor3 = Color3.new(1,1,1)
				moreInfo.TextSize = 14
				moreInfo.TextXAlignment = Enum.TextXAlignment.Left
				UICornerInf.CornerRadius = UDim.new(0, 6)
				UICornerInf.Parent = moreInfo

				local function addOption(name)
					local opt = Instance.new("TextButton")
					local optCorner = Instance.new("UICorner")
					opt.Parent = dropFrame
					opt.BackgroundColor3 = themeList.ElementColor
					opt.Size = UDim2.new(0, 352, 0, 33)
					opt.AutoButtonColor = false
					opt.Font = Enum.Font.GothamSemibold
					opt.Text = "  "..name
					opt.TextSize = 14
					opt.TextXAlignment = Enum.TextXAlignment.Left
					optCorner.CornerRadius = UDim.new(0, 6)
					optCorner.Parent = opt
					opt.MouseButton1Click:Connect(function()
						itemText.Text = name
						callback(name)
						closeDropdown()
						updateSectionFrame()
						UpdateSize()
					end)
					applyHover(opt)
					Kavo:RegisterThemeObject(opt, "BackgroundColor3", "ElementColor")
					Kavo:RegisterThemeObject(opt, "TextColor3", "TextColor")
				end

				for _, v in ipairs(list) do
					addOption(v)
				end

				applyHover(dropOpen)
				updateSectionFrame()
				UpdateSize()

				Kavo:RegisterThemeObject(dropOpen, "BackgroundColor3", "ElementColor")
				Kavo:RegisterThemeObject(itemText, "TextColor3", "TextColor")
				Kavo:RegisterThemeObject(viewInfo, "ImageColor3", "SchemeColor")

				local DropFunction = {}
				function DropFunction:Refresh(newList)
					for _, v in ipairs(dropFrame:GetChildren()) do
						if v:IsA("TextButton") and v ~= dropOpen then
							v:Destroy()
						end
					end
					for _, v in ipairs(newList) do
						addOption(v)
					end
					if opened then
						dropFrame:TweenSize(UDim2.new(0,352,0, UIListLayout.AbsoluteContentSize.Y), "InOut", "Linear", 0.1, true)
					end
					updateSectionFrame()
					UpdateSize()
				end
				return DropFunction
			end

			--// Keybind ------------------------------------------------
			function Elements:NewKeybind(keytext, keyinf, firstKey, callback)
				callback = callback or function() end
				local oldKey = firstKey.Name

				local keybindElement = Instance.new("TextButton")
				local UICorner = Instance.new("UICorner")
				local togName = Instance.new("TextLabel")
				local viewInfo = Instance.new("ImageButton")
				local keyLabel = Instance.new("TextLabel")

				keybindElement.Parent = sectionInners
				keybindElement.BackgroundColor3 = themeList.ElementColor
				keybindElement.ClipsDescendants = true
				keybindElement.Size = UDim2.new(0, 352, 0, 33)
				keybindElement.AutoButtonColor = false
				keybindElement.Font = Enum.Font.SourceSans
				keybindElement.Text = ""

				UICorner.CornerRadius = UDim.new(0, 6)
				UICorner.Parent = keybindElement

				togName.Parent = keybindElement
				togName.BackgroundTransparency = 1
				togName.Position = UDim2.new(0.095, 0, 0.5, -7)
				togName.Size = UDim2.new(0, 200, 0, 14)
				togName.Font = Enum.Font.GothamSemibold
				togName.Text = keytext
				togName.RichText = true
				togName.TextSize = 14
				togName.TextXAlignment = Enum.TextXAlignment.Left

				viewInfo.Parent = keybindElement
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(0.93, 0, 0.18, 0)
				viewInfo.Size = UDim2.new(0, 20, 0, 20)
				viewInfo.ZIndex = 2
				viewInfo.Image = "rbxassetid://3926305904"
				viewInfo.ImageRectOffset = Vector2.new(764, 764)
				viewInfo.ImageRectSize = Vector2.new(36, 36)

				keyLabel.Parent = keybindElement
				keyLabel.BackgroundTransparency = 1
				keyLabel.Position = UDim2.new(0.72, 0, 0.5, -7)
				keyLabel.Size = UDim2.new(0, 70, 0, 14)
				keyLabel.Font = Enum.Font.GothamSemibold
				keyLabel.Text = oldKey
				keyLabel.TextColor3 = themeList.SchemeColor
				keyLabel.TextSize = 14
				keyLabel.TextXAlignment = Enum.TextXAlignment.Right

				keybindElement.MouseButton1Click:Connect(function()
					if focusing then return end
					keyLabel.Text = "..."
					local inp = game:GetService("UserInputService").InputBegan:Wait()
					if inp.KeyCode.Name ~= "Unknown" then
						oldKey = inp.KeyCode.Name
						keyLabel.Text = oldKey
					end
				end)

				game:GetService("UserInputService").InputBegan:Connect(function(inp, gpe)
					if not gpe and inp.KeyCode.Name == oldKey then
						callback()
					end
				end)

				local moreInfo = Instance.new("TextLabel")
				local UICornerInf = Instance.new("UICorner")
				moreInfo.Parent = infoContainer
				moreInfo.BackgroundColor3 = themeList.SchemeColor:Lerp(Color3.new(0,0,0), 0.2)
				moreInfo.Position = UDim2.new(0, 0, 2, 0)
				moreInfo.Size = UDim2.new(0, 352, 0, 30)
				moreInfo.ZIndex = 9
				moreInfo.Font = Enum.Font.GothamSemibold
				moreInfo.Text = "  "..keyinf
				moreInfo.RichText = true
				moreInfo.TextColor3 = Color3.new(1,1,1)
				moreInfo.TextSize = 14
				moreInfo.TextXAlignment = Enum.TextXAlignment.Left
				UICornerInf.CornerRadius = UDim.new(0, 6)
				UICornerInf.Parent = moreInfo

				viewInfo.MouseButton1Click:Connect(function()
					if viewDe then return end
					viewDe = true
					focusing = true
					for _, v in ipairs(infoContainer:GetChildren()) do
						if v ~= moreInfo then
							tween:Create(v, tweeninfo(0.15), {Position = UDim2.new(0,0,2,0)}):Play()
						end
					end
					tween:Create(moreInfo, tweeninfo(0.15), {Position = UDim2.new(0,0,0,0)}):Play()
					tween:Create(blurFrame, tweeninfo(0.15), {BackgroundTransparency = 0.5}):Play()
					delay(1.5, function()
						focusing = false
						tween:Create(moreInfo, tweeninfo(0.15), {Position = UDim2.new(0,0,2,0)}):Play()
						tween:Create(blurFrame, tweeninfo(0.15), {BackgroundTransparency = 1}):Play()
						viewDe = false
					end)
				end)

				applyHover(keybindElement)
				updateSectionFrame()
				UpdateSize()

				Kavo:RegisterThemeObject(keybindElement, "BackgroundColor3", "ElementColor")
				Kavo:RegisterThemeObject(togName, "TextColor3", "TextColor")
				Kavo:RegisterThemeObject(viewInfo, "ImageColor3", "SchemeColor")
				Kavo:RegisterThemeObject(keyLabel, "TextColor3", "SchemeColor")
			end

			--// ColorPicker -------------------------------------------
			function Elements:NewColorPicker(colText, colInf, defcolor, callback)
				callback = callback or function() end
				defcolor = defcolor or Color3.fromRGB(1,1,1)

				local colorElement = Instance.new("TextButton")
				local UICorner = Instance.new("UICorner")
				local colorHeader = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local touch = Instance.new("ImageLabel")
				local togName = Instance.new("TextLabel")
				local viewInfo = Instance.new("ImageButton")
				local colorCurrent = Instance.new("Frame")
				local UICorner_3 = Instance.new("UICorner")
				local UIListLayout = Instance.new("UIListLayout")
				local colorInners = Instance.new("Frame")
				local UICorner_4 = Instance.new("UICorner")
				local rgb = Instance.new("ImageButton")
				local UICorner_5 = Instance.new("UICorner")
				local rbgcircle = Instance.new("ImageLabel")
				local darkness = Instance.new("ImageButton")
				local UICorner_6 = Instance.new("UICorner")
				local darkcircle = Instance.new("ImageLabel")
				local toggleDisabled = Instance.new("ImageLabel")
				local toggleEnabled = Instance.new("ImageLabel")
				local onrainbow = Instance.new("TextButton")
				local togName_2 = Instance.new("TextLabel")
				local Sample = Instance.new("ImageLabel")

				local h, s, v = Color3.toHSV(defcolor)

				colorElement.Parent = sectionInners
				colorElement.BackgroundColor3 = themeList.ElementColor
				colorElement.ClipsDescendants = true
				colorElement.Size = UDim2.new(0, 352, 0, 33)
				colorElement.AutoButtonColor = false
				colorElement.Font = Enum.Font.SourceSans
				colorElement.Text = ""
				colorElement.TextColor3 = Color3.new(0,0,0)
				colorElement.TextSize = 14

				UICorner.CornerRadius = UDim.new(0, 6)
				UICorner.Parent = colorElement

				colorHeader.Parent = colorElement
				colorHeader.BackgroundColor3 = themeList.ElementColor
				colorHeader.Size = UDim2.new(0, 352, 0, 33)
				colorHeader.ClipsDescendants = true

				UICorner_2.CornerRadius = UDim.new(0, 6)
				UICorner_2.Parent = colorHeader

				touch.Parent = colorHeader
				touch.BackgroundTransparency = 1
				touch.Position = UDim2.new(0.02, 0, 0.18, 0)
				touch.Size = UDim2.new(0, 20, 0, 20)
				touch.Image = "rbxassetid://3926305904"
				touch.ImageColor3 = themeList.SchemeColor
				touch.ImageRectOffset = Vector2.new(44, 964)
				touch.ImageRectSize = Vector2.new(36, 36)

				togName.Parent = colorHeader
				togName.BackgroundTransparency = 1
				togName.Position = UDim2.new(0.095, 0, 0, 0)
				togName.Size = UDim2.new(0.7, 0, 1, 0)
				togName.Font = Enum.Font.GothamSemibold
				togName.Text = colText
				togName.RichText = true
				togName.TextSize = 14
				togName.TextXAlignment = Enum.TextXAlignment.Left

				colorCurrent.Parent = colorHeader
				colorCurrent.BackgroundColor3 = defcolor
				colorCurrent.Position = UDim2.new(1, -60, 0.5, -9)
				colorCurrent.Size = UDim2.new(0, 40, 0, 18)

				UICorner_3.CornerRadius = UDim.new(0, 4)
				UICorner_3.Parent = colorCurrent

				UIListLayout.Parent = colorElement
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0, 3)

				colorInners.Parent = colorElement
				colorInners.BackgroundColor3 = themeList.ElementColor
				colorInners.Size = UDim2.new(0, 352, 0, 105)

				UICorner_4.CornerRadius = UDim.new(0, 6)
				UICorner_4.Parent = colorInners

				rgb.Name = "rgb"
				rgb.Parent = colorInners
				rgb.BackgroundColor3 = Color3.new(1,1,1)
				rgb.BackgroundTransparency = 1
				rgb.Position = UDim2.new(0.02, 0, 0.05, 0)
				rgb.Size = UDim2.new(0, 211, 0, 93)
				rgb.Image = "http://www.roblox.com/asset/?id=6523286724"

				UICorner_5.CornerRadius = UDim.new(0, 4)
				UICorner_5.Parent = rgb

				rbgcircle.Parent = rgb
				rbgcircle.BackgroundTransparency = 1
				rbgcircle.Size = UDim2.new(0, 14, 0, 14)
				rbgcircle.Image = "rbxassetid://3926309567"
				rbgcircle.ImageColor3 = Color3.new(0,0,0)
				rbgcircle.ImageRectOffset = Vector2.new(628, 420)
				rbgcircle.ImageRectSize = Vector2.new(48, 48)

				darkness.Name = "darkness"
				darkness.Parent = colorInners
				darkness.BackgroundColor3 = Color3.new(1,1,1)
				darkness.BackgroundTransparency = 1
				darkness.Position = UDim2.new(0.636, 0, 0.05, 0)
				darkness.Size = UDim2.new(0, 18, 0, 93)
				darkness.Image = "http://www.roblox.com/asset/?id=6523291212"

				UICorner_6.CornerRadius = UDim.new(0, 4)
				UICorner_6.Parent = darkness

				darkcircle.Parent = darkness
				darkcircle.BackgroundTransparency = 1
				darkcircle.AnchorPoint = Vector2.new(0.5, 0)
				darkcircle.Size = UDim2.new(0, 14, 0, 14)
				darkcircle.Image = "rbxassetid://3926309567"
				darkcircle.ImageColor3 = Color3.new(0,0,0)
				darkcircle.ImageRectOffset = Vector2.new(628, 420)
				darkcircle.ImageRectSize = Vector2.new(48, 48)

				toggleDisabled.Parent = colorInners
				toggleDisabled.BackgroundTransparency = 1
				toggleDisabled.Position = UDim2.new(0.705, 0, 0.065, 0)
				toggleDisabled.Size = UDim2.new(0, 21, 0, 21)
				toggleDisabled.Image = "rbxassetid://3926309567"
				toggleDisabled.ImageColor3 = themeList.SchemeColor
				toggleDisabled.ImageRectOffset = Vector2.new(628, 420)
				toggleDisabled.ImageRectSize = Vector2.new(48, 48)

				toggleEnabled.Parent = colorInners
				toggleEnabled.BackgroundTransparency = 1
				toggleEnabled.Position = UDim2.new(0.705, 0, 0.065, 0)
				toggleEnabled.Size = UDim2.new(0, 21, 0, 21)
				toggleEnabled.Image = "rbxassetid://3926309567"
				toggleEnabled.ImageColor3 = themeList.SchemeColor
				toggleEnabled.ImageRectOffset = Vector2.new(784, 420)
				toggleEnabled.ImageRectSize = Vector2.new(48, 48)
				toggleEnabled.ImageTransparency = 1

				onrainbow.Parent = toggleEnabled
				onrainbow.BackgroundTransparency = 1
				onrainbow.Size = UDim2.new(1, 0, 1, 0)
				onrainbow.Font = Enum.Font.SourceSans
				onrainbow.Text = ""

				togName_2.Parent = colorInners
				togName_2.BackgroundTransparency = 1
				togName_2.Position = UDim2.new(0.78, 0, 0.1, 0)
				togName_2.Size = UDim2.new(0, 70, 0, 14)
				togName_2.Font = Enum.Font.GothamSemibold
				togName_2.Text = "Rainbow"
				togName_2.TextColor3 = themeList.TextColor
				togName_2.TextSize = 14
				togName_2.TextXAlignment = Enum.TextXAlignment.Left

				viewInfo.Parent = colorHeader
				viewInfo.BackgroundTransparency = 1
				viewInfo.Position = UDim2.new(0.93, 0, 0.18, 0)
				viewInfo.Size = UDim2.new(0, 20, 0, 20)
				viewInfo.Image = "rbxassetid://3926305904"
				viewInfo.ImageColor3 = themeList.SchemeColor
				viewInfo.ImageRectOffset = Vector2.new(764, 764)
				viewInfo.ImageRectSize = Vector2.new(36, 36)

				Sample.Parent = colorHeader
				Sample.BackgroundTransparency = 1
				Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
				Sample.ImageColor3 = themeList.SchemeColor
				Sample.ImageTransparency = 0.6

				local moreInfo = Instance.new("TextLabel")
				local UICornerInf = Instance.new("UICorner")
				moreInfo.Parent = infoContainer
				moreInfo.BackgroundColor3 = themeList.SchemeColor:Lerp(Color3.new(0,0,0), 0.2)
				moreInfo.Position = UDim2.new(0, 0, 2, 0)
				moreInfo.Size = UDim2.new(0, 352, 0, 30)
				moreInfo.ZIndex = 9
				moreInfo.Font = Enum.Font.GothamSemibold
				moreInfo.Text = "  "..colInf
				moreInfo.RichText = true
				moreInfo.TextColor3 = Color3.new(1,1,1)
				moreInfo.TextSize = 14
				moreInfo.TextXAlignment = Enum.TextXAlignment.Left
				UICornerInf.CornerRadius = UDim.new(0, 6)
				UICornerInf.Parent = moreInfo

				local colorOpened = false
				local ms = game.Players.LocalPlayer:GetMouse()
				local plr = game.Players.LocalPlayer
				local mouse = plr:GetMouse()
				local uis = game:GetService("UserInputService")
				local rs = game:GetService("RunService")

				local colorpicker = false
				local darknesss = false
				local color = {h, s, v}
				local rainbow = false
				local rainbowconnection, counter = nil, 0

				local function zigzag(X) return math.acos(math.cos(X*math.pi))/math.pi end

				local function setColorFromTable(tbl)
					color = tbl
					local realcolor = Color3.fromHSV(color[1], color[2], color[3])
					colorCurrent.BackgroundColor3 = realcolor
					callback(realcolor)
					-- update cursors visually
					local cx, cy = rbgcircle.AbsoluteSize.X/2, rbgcircle.AbsoluteSize.Y/2
					rbgcircle.Position = UDim2.new(1 - color[1], -cx, color[2], -cy)
					darkcircle.Position = UDim2.new(0.5, 0, 1 - color[3], -cy)
				end

				local function updateRGB()
					local x = math.clamp((mouse.X - rgb.AbsolutePosition.X) / rgb.AbsoluteSize.X, 0, 1)
					local y = math.clamp((mouse.Y - rgb.AbsolutePosition.Y) / rgb.AbsoluteSize.Y, 0, 1)
					local cx, cy = rbgcircle.AbsoluteSize.X/2, rbgcircle.AbsoluteSize.Y/2
					rbgcircle.Position = UDim2.new(x, -cx, y, -cy)
					color[1] = 1 - x
					color[2] = y
					local realcolor = Color3.fromHSV(color[1], color[2], color[3])
					colorCurrent.BackgroundColor3 = realcolor
					callback(realcolor)
				end

				local function updateDarkness()
					local y = math.clamp((mouse.Y - darkness.AbsolutePosition.Y) / darkness.AbsoluteSize.Y, 0, 1)
					darkcircle.Position = UDim2.new(0.5, 0, y, -darkcircle.AbsoluteSize.Y/2)
					color[3] = 1 - y
					local realcolor = Color3.fromHSV(color[1], color[2], color[3])
					colorCurrent.BackgroundColor3 = realcolor
					callback(realcolor)
				end

				rgb.MouseButton1Down:Connect(function()
					if focusing then return end
					colorpicker = true
					mouse.Move:Connect(updateRGB)
					local conn = uis.InputEnded:Connect(function(inp)
						if inp.UserInputType == Enum.UserInputType.MouseButton1 then
							colorpicker = false
							conn:Disconnect()
						end
					end)
				end)

				darkness.MouseButton1Down:Connect(function()
					if focusing then return end
					darknesss = true
					mouse.Move:Connect(updateDarkness)
					local conn = uis.InputEnded:Connect(function(inp)
						if inp.UserInputType == Enum.UserInputType.MouseButton1 then
							darknesss = false
							conn:Disconnect()
						end
					end)
				end)

				onrainbow.MouseButton1Click:Connect(function()
					rainbow = not rainbow
					if rainbow then
						toggleEnabled.ImageTransparency = 0
						rainbowconnection = rs.RenderStepped:Connect(function()
							counter = counter + 0.01
							setColorFromTable({zigzag(counter), 1, 1})
						end)
					else
						toggleEnabled.ImageTransparency = 1
						if rainbowconnection then rainbowconnection:Disconnect() end
					end
				end)

				colorElement.MouseButton1Click:Connect(function()
					if focusing then
						for _, v in ipairs(infoContainer:GetChildren()) do
							tween:Create(v, tweeninfo(0.15), {Position = UDim2.new(0,0,2,0)}):Play()
						end
						focusing = false
						tween:Create(blurFrame, tweeninfo(0.15), {BackgroundTransparency = 1}):Play()
						return
					end
					colorOpened = not colorOpened
					if colorOpened then
						colorElement:TweenSize(UDim2.new(0,352,0,141), "InOut", "Linear", 0.1, true)
					else
						colorElement:TweenSize(UDim2.new(0,352,0,33), "InOut", "Linear", 0.1, true)
					end
					updateSectionFrame()
					UpdateSize()
				end)

				viewInfo.MouseButton1Click:Connect(function()
					if viewDe then return end
					viewDe = true
					focusing = true
					for _, v in ipairs(infoContainer:GetChildren()) do
						if v ~= moreInfo then
							tween:Create(v, tweeninfo(0.15), {Position = UDim2.new(0,0,2,0)}):Play()
						end
					end
					tween:Create(moreInfo, tweeninfo(0.15), {Position = UDim2.new(0,0,0,0)}):Play()
					tween:Create(blurFrame, tweeninfo(0.15), {BackgroundTransparency = 0.5}):Play()
					delay(1.5, function()
						focusing = false
						tween:Create(moreInfo, tweeninfo(0.15), {Position = UDim2.new(0,0,2,0)}):Play()
						tween:Create(blurFrame, tweeninfo(0.15), {BackgroundTransparency = 1}):Play()
						viewDe = false
					end)
				end)

				applyHover(colorElement)
				updateSectionFrame()
				UpdateSize()

				Kavo:RegisterThemeObject(colorElement, "BackgroundColor3", "ElementColor")
				Kavo:RegisterThemeObject(colorHeader, "BackgroundColor3", "ElementColor")
				Kavo:RegisterThemeObject(colorInners, "BackgroundColor3", "ElementColor")
				Kavo:RegisterThemeObject(togName, "TextColor3", "TextColor")
				Kavo:RegisterThemeObject(togName_2, "TextColor3", "TextColor")
				Kavo:RegisterThemeObject(viewInfo, "ImageColor3", "SchemeColor")
				Kavo:RegisterThemeObject(touch, "ImageColor3", "SchemeColor")
				Kavo:RegisterThemeObject(toggleDisabled, "ImageColor3", "SchemeColor")
				Kavo:RegisterThemeObject(toggleEnabled, "ImageColor3", "SchemeColor")
				Kavo:RegisterThemeObject(Sample, "ImageColor3", "SchemeColor")

				setColorFromTable({h, s, v})
			end

			--// Label -------------------------------------------------
			function Elements:NewLabel(title)
				local label = Instance.new("TextLabel")
				local UICorner = Instance.new("UICorner")
				label.Parent = sectionInners
				label.BackgroundColor3 = themeList.SchemeColor
				label.BorderSizePixel = 0
				label.ClipsDescendants = true
				label.Size = UDim2.new(0, 352, 0, 33)
				label.Font = Enum.Font.GothamSemibold
				label.Text = "  "..title
				label.RichText = true
				label.TextSize = 14
				label.TextXAlignment = Enum.TextXAlignment.Left
				UICorner.CornerRadius = UDim.new(0, 6)
				UICorner.Parent = label

				updateSectionFrame()
				UpdateSize()

				Kavo:RegisterThemeObject(label, "BackgroundColor3", "SchemeColor")
				Kavo:RegisterThemeObject(label, "TextColor3", "TextColor")

				local LabelFunc = {}
				function LabelFunc:UpdateLabel(newText)
					label.Text = "  "..newText
				end
				return LabelFunc
			end

			return Elements
		end
		return Sections
	end

	Kavo:UpdateTheme()   -- apply initial theme
	return Tabs
end

return Kavo