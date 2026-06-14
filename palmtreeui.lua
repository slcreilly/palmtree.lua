-- ============================================
-- 🌴 PALMTREE.LUA v11.5 — REFINED
-- Better animations, mobile UX, premium feel
-- ============================================

local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")

-- ============================================
-- THEME ENGINE
-- ============================================
local Themes = {
    ["Miami Sunset"] = {
        Name = "Miami Sunset",
        Gradient = {
            {Color3.fromRGB(255, 94, 91), Color3.fromRGB(15, 23, 42)},
            {Color3.fromRGB(255, 179, 71), Color3.fromRGB(20, 25, 48)},
        },
        Accent = Color3.fromRGB(255, 94, 91),
        Secondary = Color3.fromRGB(122, 92, 250),
        Cyan = Color3.fromRGB(0, 210, 240),
        Border = Color3.fromRGB(255, 94, 91),
        ContainerBg = Color3.fromRGB(25, 8, 45),
        InputBg = Color3.fromRGB(30, 10, 50),
        CardBg = Color3.fromRGB(30, 12, 55),
        Text = Color3.fromRGB(255, 245, 250),
        TextMuted = Color3.fromRGB(180, 150, 195),
        ToggleOff = Color3.fromRGB(50, 20, 70),
        SliderTrack = Color3.fromRGB(40, 15, 60),
    },
    ["Midnight Ocean"] = {
        Name = "Midnight Ocean",
        Gradient = {{Color3.fromRGB(10, 15, 35), Color3.fromRGB(5, 8, 20)}},
        Accent = Color3.fromRGB(80, 160, 255),
        Secondary = Color3.fromRGB(60, 120, 220),
        Cyan = Color3.fromRGB(0, 200, 240),
        Border = Color3.fromRGB(80, 160, 255),
        ContainerBg = Color3.fromRGB(18, 22, 42),
        InputBg = Color3.fromRGB(25, 30, 55),
        CardBg = Color3.fromRGB(22, 28, 50),
        Text = Color3.fromRGB(240, 245, 255),
        TextMuted = Color3.fromRGB(160, 175, 210),
        ToggleOff = Color3.fromRGB(35, 45, 70),
        SliderTrack = Color3.fromRGB(30, 38, 58),
    },
    ["Neon Cyber"] = {
        Name = "Neon Cyber",
        Gradient = {{Color3.fromRGB(5, 2, 20), Color3.fromRGB(20, 2, 40)}},
        Accent = Color3.fromRGB(0, 255, 200),
        Secondary = Color3.fromRGB(200, 0, 255),
        Cyan = Color3.fromRGB(0, 255, 255),
        Border = Color3.fromRGB(0, 255, 200),
        ContainerBg = Color3.fromRGB(10, 5, 25),
        InputBg = Color3.fromRGB(15, 8, 35),
        CardBg = Color3.fromRGB(14, 7, 32),
        Text = Color3.fromRGB(230, 255, 250),
        TextMuted = Color3.fromRGB(150, 190, 180),
        ToggleOff = Color3.fromRGB(30, 20, 50),
        SliderTrack = Color3.fromRGB(25, 15, 45),
    },
}

local ActiveTheme = Themes["Miami Sunset"]
local ActiveThemeName = "Miami Sunset"
local CustomThemes = {}

local FONT = {
    Header = Enum.Font.GothamBold,
    Body = Enum.Font.GothamSemibold,
    Text = Enum.Font.Gotham,
    Mono = Enum.Font.RobotoMono,
    Script = Enum.Font.FredokaOne,
}

local ConfigFolder = "PalmTree_Configs"
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local function create(class, props)
    local i = Instance.new(class)
    for k, v in pairs(props) do i[k] = v end
    return i
end

-- Premium animation presets
local Ease = {
    spring = Enum.EasingStyle.Back,
    smooth = Enum.EasingStyle.Quart,
    bounce = Enum.EasingStyle.Bounce,
    elastic = Enum.EasingStyle.Elastic,
}

local function Tween(obj, props, dur, easing, dir)
    return TweenService:Create(obj, TweenInfo.new(dur or 0.2, easing or Ease.smooth, dir or Enum.EasingDirection.Out), props):Play()
end

local function MakeDraggable(gui, dragPart)
    local dragging, startPos, startMouse, input
    dragPart.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging, startPos, startMouse, input = true, gui.Position, inp.Position, inp
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if inp == input and dragging then
            local d = inp.Position - startMouse
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- ============================================
-- UNDO SYSTEM
-- ============================================
local UndoStack = {}
local MAX_UNDO = 50

local function PushUndo(action)
    table.insert(UndoStack, action)
    if #UndoStack > MAX_UNDO then table.remove(UndoStack, 1) end
end

-- ============================================
-- FAVORITES SYSTEM
-- ============================================
local Favorites = {}

-- ============================================
-- RECENT CHANGES
-- ============================================
local RecentChanges = {}

local function LogChange(text)
    table.insert(RecentChanges, 1, {text = text, time = os.time()})
    if #RecentChanges > 10 then table.remove(RecentChanges) end
end

-- ============================================
-- TOOLTIP SYSTEM
-- ============================================
local TooltipFrame
local TooltipLabel

local function ShowTooltip(text, position)
    if not TooltipFrame then
        TooltipFrame = create("Frame", {
            Parent = CoreGui, BackgroundColor3 = Color3.fromRGB(15, 5, 30),
            BackgroundTransparency = 0.08, Size = UDim2.new(0, 0, 0, 22), BorderSizePixel = 0,
            Visible = false, ZIndex = 200,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = TooltipFrame})
        create("UIStroke", {Parent = TooltipFrame, Color = Color3.fromRGB(255, 94, 91), Transparency = 0.3, Thickness = 1})
        TooltipLabel = create("TextLabel", {
            Parent = TooltipFrame, BackgroundTransparency = 1,
            Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -16, 1, 0),
            Font = FONT.Text, Text = "", TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 201,
        })
    end
    TooltipLabel.Text = text
    TooltipFrame.Size = UDim2.new(0, math.clamp(TooltipLabel.TextBounds.X + 20, 60, 300), 0, 22)
    TooltipFrame.Position = UDim2.new(0, position.X + 8, 0, position.Y - 26)
    TooltipFrame.Visible = true
end

local function HideTooltip()
    if TooltipFrame then TooltipFrame.Visible = false end
end

function Library:CreateWindow(title)
    title = title or "PalmTree"
    local uiName = "PT_" .. math.random(1000, 9999)
    if CoreGui:FindFirstChild(uiName) then CoreGui[uiName]:Destroy() end
    
    local ScreenGui = create("ScreenGui", {
        Name = uiName, Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false, Enabled = true,
    })
    
    local allConnections = {}
    local allGradientLoops = {}
    local WindowAPI = {}
    local Flags = {}
    
    -- ============================================
    -- SMART NOTIFICATIONS
    -- ============================================
    local MAX_NOTIFICATIONS = 5
    local notificationCount = 0
    local notificationQueue = {}
    
    local NotifHolder = create("Frame", {
        Parent = ScreenGui, BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -10, 1, -10),
        Size = UDim2.new(0, 240, 0, 0),
        BorderSizePixel = 0, ZIndex = 100,
    })
    create("UIListLayout", {
        Parent = NotifHolder, SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5), VerticalAlignment = Enum.VerticalAlignment.Bottom,
    })
    
    local function ProcessNotificationQueue()
        if #notificationQueue > 0 and notificationCount < MAX_NOTIFICATIONS then
            ShowNotification(table.remove(notificationQueue, 1))
            ProcessNotificationQueue()
        end
    end
    
    function ShowNotification(data)
        notificationCount = notificationCount + 1
        local duration = data.Duration or 3
        local contentText = data.Content or ""
        local ntype = data.Type or "info"
        local buttonText = data.ButtonText
        local buttonCallback = data.Callback
        local cols = {success = Color3.fromRGB(100, 255, 150), info = ActiveTheme.Cyan, warning = Color3.fromRGB(255, 210, 70)}
        
        local height = buttonText and 36 or 24
        local notif = create("Frame", {
            Parent = NotifHolder, BackgroundColor3 = ActiveTheme.ContainerBg,
            Size = UDim2.new(1, 0, 0, height), BorderSizePixel = 0,
            BackgroundTransparency = 1, ZIndex = 100, ClipsDescendants = true,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = notif})
        create("UIStroke", {Parent = notif, Color = cols[ntype] or ActiveTheme.Accent, Transparency = 0.15, Thickness = 1.5})
        
        -- Left accent bar with glow
        local accentBar = create("Frame", {
            Parent = notif, BackgroundColor3 = cols[ntype] or ActiveTheme.Accent,
            BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(0, 3, 1, 0),
        })
        create("UIGradient", {
            Parent = accentBar, Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.5, 0.3),
                NumberSequenceKeypoint.new(1, 0),
            }),
        })
        
        create("TextLabel", {
            Parent = notif, BackgroundTransparency = 1,
            Position = UDim2.new(0.08, 0, 0, 0), Size = UDim2.new(0.88, 0, 0, buttonText and 16 or 24),
            Font = FONT.Text, Text = contentText, TextColor3 = ActiveTheme.Text,
            TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 100,
        })
        
        if buttonText and buttonCallback then
            local actionBtn = create("TextButton", {
                Parent = notif, BackgroundColor3 = ActiveTheme.Accent,
                BackgroundTransparency = 0.6, Position = UDim2.new(0.58, 0, 0.52, 0),
                Size = UDim2.new(0, 65, 0, 16), Font = FONT.Header, Text = buttonText,
                TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 8,
                AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 101,
            })
            create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = actionBtn})
            actionBtn.MouseButton1Click:Connect(function()
                buttonCallback()
                if notif and notif.Parent then
                    Tween(notif, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    task.wait(0.2); notif:Destroy(); notificationCount = notificationCount - 1; ProcessNotificationQueue()
                end
            end)
        end
        
        -- Slide in from right
        notif.Position = UDim2.new(1.2, 0, 0, 0)
        Tween(notif, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0}, 0.3, Ease.spring)
        
        if not buttonText then
            task.delay(duration, function()
                if notif and notif.Parent then
                    Tween(notif, {Position = UDim2.new(1.2, 0, 0, 0), BackgroundTransparency = 1}, 0.25)
                    task.wait(0.25); notif:Destroy(); notificationCount = notificationCount - 1; ProcessNotificationQueue()
                end
            end)
        end
    end
    
    function WindowAPI:Notify(data)
        if notificationCount >= MAX_NOTIFICATIONS then
            table.insert(notificationQueue, data)
            if #notificationQueue > 10 then table.remove(notificationQueue, 1) end
        else
            ShowNotification(data)
        end
    end
    
    local function InternalNotify(text, ntype)
        WindowAPI:Notify({Content = text, Type = ntype or "info"})
    end
    
    -- ============================================
    -- MAIN WINDOW
    -- ============================================
    local Main = create("Frame", {
        Parent = ScreenGui,
        Position = UDim2.new(0.5, -260, 0.5, -160),
        Size = UDim2.new(0, 520, 0, 320),
        ClipsDescendants = true, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    create("UIStroke", {Parent = Main, Color = ActiveTheme.Border, Transparency = 0.35, Thickness = 2})
    
    local BgGradient = create("UIGradient", {
        Parent = Main,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, ActiveTheme.Gradient[1][1]),
            ColorSequenceKeypoint.new(1, ActiveTheme.Gradient[1][2]),
        }),
        Rotation = 180,
    })
    
    local currentStep, nextStep, stepProgress = 1, 2, 0
    local gradientRunning = true
    table.insert(allGradientLoops, function() gradientRunning = false end)
    coroutine.wrap(function()
        while gradientRunning and BgGradient and BgGradient.Parent do
            local from = ActiveTheme.Gradient[currentStep]
            local to = ActiveTheme.Gradient[nextStep]
            stepProgress = math.clamp(stepProgress + 0.003, 0, 1)
            if stepProgress >= 1 then stepProgress = 0; currentStep = nextStep; nextStep = nextStep % #ActiveTheme.Gradient + 1; from = ActiveTheme.Gradient[currentStep]; to = ActiveTheme.Gradient[nextStep] end
            pcall(function() BgGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, from[1]:Lerp(to[1], stepProgress)), ColorSequenceKeypoint.new(1, from[2]:Lerp(to[2], stepProgress))}) end)
            RunService.Heartbeat:Wait()
        end
    end)()
    
    -- ============================================
    -- HEADER
    -- ============================================
    local Header = create("Frame", {Parent = Main, BackgroundColor3 = Color3.fromRGB(20, 4, 45), BackgroundTransparency = 0.15, Size = UDim2.new(1, 0, 0, 32), BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Header})
    create("Frame", {Parent = Header, BackgroundColor3 = Color3.fromRGB(20, 4, 45), BackgroundTransparency = 0.15, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0.5, 0)})
    
    create("TextLabel", {Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0.025, 0, 0, 0), Size = UDim2.new(0, 20, 1, 0), Font = FONT.Body, Text = "🌴", TextSize = 14})
    create("TextLabel", {Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0.09, 0, 0.05, 0), Size = UDim2.new(0.35, 0, 0.45, 0), Font = FONT.Script, Text = title, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left})
    local ThemeLabel = create("TextLabel", {Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0.09, 0, 0.5, 0), Size = UDim2.new(0.3, 0, 0.4, 0), Font = FONT.Text, Text = ActiveThemeName, TextColor3 = ActiveTheme.Accent, TextSize = 7, TextXAlignment = Enum.TextXAlignment.Left})
    
    -- Quick actions
    local QuickActions = create("Frame", {Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0.55, 0, 0.5, -9), Size = UDim2.new(0.35, 0, 0, 18), BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0.5)})
    create("UIListLayout", {Parent = QuickActions, SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4), HorizontalAlignment = Enum.HorizontalAlignment.Right})
    
    local function AddQuickAction(icon, callback)
        local btn = create("TextButton", {Parent = QuickActions, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.8, Size = UDim2.new(0, 18, 0, 18), Font = FONT.Body, Text = icon, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 9, AutoButtonColor = false, BorderSizePixel = 0})
        create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = btn})
        btn.MouseButton1Click:Connect(callback)
        btn.MouseEnter:Connect(function() Tween(btn, {BackgroundTransparency = 0.4}, 0.1) end)
        btn.MouseLeave:Connect(function() Tween(btn, {BackgroundTransparency = 0.8}, 0.1) end)
        return btn
    end
    
    AddQuickAction("💾", function() InternalNotify("Use right panel to save configs", "info") end)
    AddQuickAction("🎨", function() WindowAPI:OpenThemeEditor() end)
    AddQuickAction("⭐", function() WindowAPI:OpenFavorites() end)
    
    local MinBtn = create("TextButton", {Parent = Header, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.8, Position = UDim2.new(0.92, 0, 0.15, 0), Size = UDim2.new(0, 22, 0, 22), Font = FONT.Header, Text = "−", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 16, BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = MinBtn})
    
    local CloseBtn = create("TextButton", {Parent = Header, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.8, Position = UDim2.new(0.97, 0, 0.15, 0), Size = UDim2.new(0, 22, 0, 22), Font = FONT.Header, Text = "×", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 16, BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = CloseBtn})
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui.Enabled = false end)
    
    local minimized = false; local ContentArea
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then ContentArea.Visible = false; Tween(Main, {Size = UDim2.new(0, 520, 0, 32)}, 0.2, Ease.smooth); MinBtn.Text = "+"
        else ContentArea.Visible = true; Tween(Main, {Size = UDim2.new(0, 520, 0, 320)}, 0.2, Ease.spring); MinBtn.Text = "−" end
    end)
    
    MakeDraggable(Main, Header)
    
    ContentArea = create("Frame", {Parent = Main, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0.1, 0), Size = UDim2.new(1, 0, 0.9, 0), BorderSizePixel = 0})
    
    -- Left sidebar
    local LeftSidebar = create("Frame", {Parent = ContentArea, BackgroundColor3 = Color3.fromRGB(20, 4, 40), BackgroundTransparency = 0.35, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(0, 120, 1, 0), BorderSizePixel = 0, ClipsDescendants = true})
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = LeftSidebar})
    create("UIStroke", {Parent = LeftSidebar, Color = ActiveTheme.Border, Transparency = 0.4, Thickness = 1.5})
    create("UIListLayout", {Parent = LeftSidebar, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3)})
    create("UIPadding", {Parent = LeftSidebar, PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)})
    
    -- Center
    local Center = create("Frame", {Parent = ContentArea, BackgroundColor3 = Color3.fromRGB(20, 4, 40), BackgroundTransparency = 0.35, Position = UDim2.new(0.24, 0, 0, 0), Size = UDim2.new(0, 230, 1, 0), BorderSizePixel = 0, ClipsDescendants = true})
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Center})
    create("UIStroke", {Parent = Center, Color = ActiveTheme.Border, Transparency = 0.4, Thickness = 1.5})
    
    local CenterScroll = create("ScrollingFrame", {Parent = Center, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = ActiveTheme.Accent, CanvasSize = UDim2.new(0, 0, 0, 0)})
    create("UIPadding", {Parent = CenterScroll, PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), PaddingTop = UDim.new(0, 4)})
    
    local CenterTitleFrame = create("Frame", {Parent = CenterScroll, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.75, Size = UDim2.new(1, 0, 0, 22), BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = CenterTitleFrame})
    local CenterIcon = create("TextLabel", {Parent = CenterTitleFrame, BackgroundTransparency = 1, Position = UDim2.new(0.03, 0, 0, 0), Size = UDim2.new(0, 16, 1, 0), Font = FONT.Body, Text = "⚔️", TextSize = 11})
    local CenterTitle = create("TextLabel", {Parent = CenterTitleFrame, BackgroundTransparency = 1, Position = UDim2.new(0.13, 0, 0, 0), Size = UDim2.new(0.87, 0, 1, 0), Font = FONT.Header, Text = "Combat", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left})
    
    local ScrollContent = create("Frame", {Parent = CenterScroll, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0})
    local ScrollContentList = create("UIListLayout", {Parent = ScrollContent, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    
    local function UpdateScrollSize() ScrollContent.Size = UDim2.new(1, 0, 0, ScrollContentList.AbsoluteContentSize.Y); CenterScroll.CanvasSize = UDim2.new(0, 0, 0, ScrollContentList.AbsoluteContentSize.Y + 28) end
    
    -- Right panel
    local RightPanel = create("Frame", {Parent = ContentArea, BackgroundColor3 = Color3.fromRGB(20, 4, 40), BackgroundTransparency = 0.35, Position = UDim2.new(0.7, 0, 0, 0), Size = UDim2.new(0, 150, 1, 0), BorderSizePixel = 0, ClipsDescendants = true})
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = RightPanel})
    create("UIStroke", {Parent = RightPanel, Color = ActiveTheme.Border, Transparency = 0.4, Thickness = 1.5})
    create("UIListLayout", {Parent = RightPanel, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)})
    create("UIPadding", {Parent = RightPanel, PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)})
    
    -- Recent Changes section
    create("TextLabel", {Parent = RightPanel, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.75, Size = UDim2.new(1, 0, 0, 22), BorderSizePixel = 0, Font = FONT.Header, Text = "🕐 Recent", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left})
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = RightPanel:FindFirstChildOfClass("TextLabel")})
    
    local RecentFrame = create("ScrollingFrame", {Parent = RightPanel, BackgroundColor3 = ActiveTheme.InputBg, Size = UDim2.new(1, 0, 0, 80), BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = ActiveTheme.Accent, CanvasSize = UDim2.new(0, 0, 0, 0)})
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = RecentFrame})
    local RecentList = create("UIListLayout", {Parent = RecentFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
    create("UIPadding", {Parent = RecentFrame, PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
    
    local function RefreshRecent()
        for _, c in ipairs(RecentFrame:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
        for _, change in ipairs(RecentChanges) do
            local timeStr = os.date("%H:%M", change.time)
            create("TextLabel", {Parent = RecentFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 14), Font = FONT.Text, Text = timeStr .. " · " .. change.text, TextColor3 = ActiveTheme.TextMuted, TextSize = 7, TextXAlignment = Enum.TextXAlignment.Left})
        end
        RecentFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(#RecentChanges * 16, RecentFrame.AbsoluteSize.Y))
    end
    
    -- Configs
    create("TextLabel", {Parent = RightPanel, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.75, Size = UDim2.new(1, 0, 0, 22), BorderSizePixel = 0, Font = FONT.Header, Text = "💾 Configs", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left})
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = RightPanel:FindFirstChildOfClass("TextLabel")})
    
    local ConfigInput = create("TextBox", {Parent = RightPanel, BackgroundColor3 = ActiveTheme.InputBg, Size = UDim2.new(1, 0, 0, 22), Font = FONT.Text, PlaceholderText = "Config name...", TextColor3 = ActiveTheme.Text, PlaceholderColor3 = ActiveTheme.TextMuted, TextSize = 9, ClearTextOnFocus = false, BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ConfigInput})
    create("UIStroke", {Parent = ConfigInput, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1})
    
    local ConfigBtnFrame = create("Frame", {Parent = RightPanel, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), BorderSizePixel = 0})
    create("UIListLayout", {Parent = ConfigBtnFrame, SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4)})
    local SaveBtn = create("TextButton", {Parent = ConfigBtnFrame, BackgroundColor3 = ActiveTheme.Accent, Size = UDim2.new(0.48, 0, 1, 0), Font = FONT.Header, Text = "Save", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SaveBtn})
    local LoadBtn = create("TextButton", {Parent = ConfigBtnFrame, BackgroundColor3 = ActiveTheme.Cyan, Size = UDim2.new(0.48, 0, 1, 0), Font = FONT.Header, Text = "Refresh", TextColor3 = Color3.fromRGB(20, 4, 40), TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = LoadBtn})
    
    local ConfigListFrame = create("ScrollingFrame", {Parent = RightPanel, BackgroundColor3 = ActiveTheme.InputBg, Size = UDim2.new(1, 0, 1, -230), BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = ActiveTheme.Accent, CanvasSize = UDim2.new(0, 0, 0, 0)})
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ConfigListFrame})
    local ConfigListLayout = create("UIListLayout", {Parent = ConfigListFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3)})
    create("UIPadding", {Parent = ConfigListFrame, PaddingTop = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
    
    local allElements = {}
    local elementCounter = 0
    
    local function RefreshConfigList()
        for _, c in ipairs(ConfigListFrame:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        local configs = {}
        pcall(function() for _, file in ipairs(listfiles(ConfigFolder)) do local n = file:match("([^\\/]+)%.json$"); if n then table.insert(configs, n) end end end)
        table.sort(configs)
        for _, name in ipairs(configs) do
            local row = create("Frame", {Parent = ConfigListFrame, BackgroundColor3 = ActiveTheme.ContainerBg, Size = UDim2.new(1, 0, 0, 24), BorderSizePixel = 0})
            create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = row})
            create("UIStroke", {Parent = row, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1})
            local lBtn = create("TextButton", {Parent = row, BackgroundTransparency = 1, Position = UDim2.new(0.03, 0, 0, 0), Size = UDim2.new(0.6, 0, 1, 0), Font = FONT.Text, Text = "📁 " .. name, TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false})
            lBtn.MouseButton1Click:Connect(function()
                local s, d = pcall(function() return HttpService:JSONDecode(readfile(ConfigFolder .. "/" .. name .. ".json")) end)
                if s and d then
                    local prevValues = {}
                    for _, e in ipairs(allElements) do if e.get then prevValues[e.id] = e.get() end end
                    for _, e in ipairs(allElements) do if d[e.id] ~= nil and e.set then e.set(d[e.id]) end end
                    PushUndo({config = name, previous = prevValues})
                    InternalNotify("Loaded: " .. name, "success")
                    WindowAPI:Notify({Content = "Config loaded", ButtonText = "Undo", Callback = function() WindowAPI:Undo() end, Type = "success"})
                end
            end)
            local dBtn = create("TextButton", {Parent = row, BackgroundColor3 = Color3.fromRGB(255, 60, 80), BackgroundTransparency = 0.7, Position = UDim2.new(0.75, 0, 0.15, 0), Size = UDim2.new(0, 18, 0, 16), Font = FONT.Header, Text = "×", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0})
            create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = dBtn})
            dBtn.MouseButton1Click:Connect(function() pcall(function() delfile(ConfigFolder .. "/" .. name .. ".json") end); RefreshConfigList(); InternalNotify("Deleted: " .. name, "warning") end)
        end
        ConfigListFrame.CanvasSize = UDim2.new(0, 0, 0, ConfigListLayout.AbsoluteContentSize.Y + 10)
    end
    
    SaveBtn.MouseButton1Click:Connect(function()
        local n = ConfigInput.Text; if n == "" or n:match("^%s*$") then InternalNotify("Enter a config name!", "warning"); return end
        local d = {}; for _, e in ipairs(allElements) do if e.get then d[e.id] = e.get() end end
        pcall(function() writefile(ConfigFolder .. "/" .. n .. ".json", HttpService:JSONEncode(d)) end)
        RefreshConfigList(); InternalNotify("Saved: " .. n, "success")
    end)
    LoadBtn.MouseButton1Click:Connect(function() RefreshConfigList() end)
    RefreshConfigList()
    
    -- ============================================
    -- UNDO SYSTEM
    -- ============================================
    function WindowAPI:Undo()
        if #UndoStack == 0 then InternalNotify("Nothing to undo", "warning"); return end
        local action = table.remove(UndoStack)
        if action.previous then
            for _, e in ipairs(allElements) do
                if action.previous[e.id] ~= nil and e.set then e.set(action.previous[e.id]) end
            end
        end
        InternalNotify("Undone: " .. (action.config or "last action"), "info")
    end
    
    -- ============================================
    -- THEME ENGINE
    -- ============================================
    function WindowAPI:SetTheme(themeName)
        if CustomThemes[themeName] then ActiveTheme = CustomThemes[themeName]
        elseif Themes[themeName] then ActiveTheme = Themes[themeName]
        else InternalNotify("Theme not found", "warning"); return end
        ActiveThemeName = themeName; ThemeLabel.Text = themeName; ThemeLabel.TextColor3 = ActiveTheme.Accent
        InternalNotify("Theme: " .. themeName, "info")
    end
    
    function WindowAPI:RegisterTheme(name, data) CustomThemes[name] = data; data.Name = name end
    function WindowAPI:ExportTheme() return ActiveTheme end
    function WindowAPI:ImportTheme(data) WindowAPI:RegisterTheme(data.Name or "Custom", data); WindowAPI:SetTheme(data.Name or "Custom") end
    
    -- ============================================
    -- LIVE THEME EDITOR
    -- ============================================
    function WindowAPI:OpenThemeEditor()
        local editor = create("Frame", {Parent = ScreenGui, BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.05, Position = UDim2.new(0.5, -160, 0.5, -130), Size = UDim2.new(0, 320, 0, 260), BorderSizePixel = 0, ZIndex = 300})
        create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = editor})
        create("UIStroke", {Parent = editor, Color = ActiveTheme.Accent, Transparency = 0.2, Thickness = 2})
        create("TextLabel", {Parent = editor, BackgroundTransparency = 1, Position = UDim2.new(0.05, 0, 0.03, 0), Size = UDim2.new(0.8, 0, 0, 22), Font = FONT.Header, Text = "🎨 Theme Editor", TextColor3 = ActiveTheme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 301})
        
        local closeBtn = create("TextButton", {Parent = editor, BackgroundColor3 = Color3.fromRGB(255, 60, 80), BackgroundTransparency = 0.7, Position = UDim2.new(0.9, 0, 0.03, 0), Size = UDim2.new(0, 22, 0, 22), Font = FONT.Header, Text = "×", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 302})
        create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = closeBtn})
        closeBtn.MouseButton1Click:Connect(function() Tween(editor, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.2); task.wait(0.2); editor:Destroy() end)
        MakeDraggable(editor, editor)
        
        -- Theme presets
        local presetFrame = create("Frame", {Parent = editor, BackgroundTransparency = 1, Position = UDim2.new(0.05, 0, 0.12, 0), Size = UDim2.new(0.9, 0, 0, 28), BorderSizePixel = 0, ZIndex = 301})
        create("UIListLayout", {Parent = presetFrame, SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5)})
        
        for name, theme in pairs(Themes) do
            local preset = create("TextButton", {Parent = presetFrame, BackgroundColor3 = theme.Accent, Size = UDim2.new(0, 0, 1, 0), Font = FONT.Text, Text = "", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 0, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 301})
            create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = preset})
            preset.Size = UDim2.new(0, 55, 1, 0)
            local label = create("TextLabel", {Parent = preset, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = FONT.Text, Text = name:sub(1, 8), TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 7, ZIndex = 302})
            preset.MouseButton1Click:Connect(function() WindowAPI:SetTheme(name); Tween(editor, {Size = UDim2.new(0, 0, 0, 0)}, 0.2); task.wait(0.2); editor:Destroy() end)
        end
        
        -- Color pickers
        local function AddColorEdit(y, label, getColor, setColor)
            create("TextLabel", {Parent = editor, BackgroundTransparency = 1, Position = UDim2.new(0.05, 0, y, 0), Size = UDim2.new(0.4, 0, 0, 16), Font = FONT.Text, Text = label, TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 301})
            local preview = create("Frame", {Parent = editor, BackgroundColor3 = getColor(), Position = UDim2.new(0.48, 0, y + 0.02, 0), Size = UDim2.new(0, 28, 0, 12), BorderSizePixel = 0, ZIndex = 301})
            create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = preview})
            local input = create("TextBox", {Parent = editor, BackgroundColor3 = ActiveTheme.InputBg, Position = UDim2.new(0.62, 0, y, 0), Size = UDim2.new(0.28, 0, 0, 16), Font = FONT.Text, PlaceholderText = "R,G,B", TextColor3 = ActiveTheme.Text, PlaceholderColor3 = ActiveTheme.TextMuted, TextSize = 8, ClearTextOnFocus = false, BorderSizePixel = 0, ZIndex = 301})
            create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = input})
            input.FocusLost:Connect(function(ep)
                if ep then
                    local r, g, b = input.Text:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
                    if r then local c = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)); setColor(c); preview.BackgroundColor3 = c end
                end
            end)
        end
        
        AddColorEdit(0.28, "Accent", function() return ActiveTheme.Accent end, function(c) ActiveTheme.Accent = c; ActiveTheme.Border = c end)
        AddColorEdit(0.38, "Secondary", function() return ActiveTheme.Secondary end, function(c) ActiveTheme.Secondary = c end)
        AddColorEdit(0.48, "Cyan", function() return ActiveTheme.Cyan end, function(c) ActiveTheme.Cyan = c end)
        AddColorEdit(0.58, "Container", function() return ActiveTheme.ContainerBg end, function(c) ActiveTheme.ContainerBg = c end)
        AddColorEdit(0.68, "Text", function() return ActiveTheme.Text end, function(c) ActiveTheme.Text = c end)
        
        local exportBtn = create("TextButton", {Parent = editor, BackgroundColor3 = ActiveTheme.Accent, Position = UDim2.new(0.05, 0, 0.82, 0), Size = UDim2.new(0.42, 0, 0, 30), Font = FONT.Header, Text = "📋 Copy Theme", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 301})
        create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = exportBtn})
        exportBtn.MouseButton1Click:Connect(function()
            if setclipboard then setclipboard(HttpService:JSONEncode(WindowAPI:ExportTheme())) end
            InternalNotify("Theme copied to clipboard!", "success")
        end)
    end
    
    -- ============================================
    -- FAVORITES
    -- ============================================
    function WindowAPI:OpenFavorites()
        if #Favorites == 0 then InternalNotify("No favorites yet. Right-click elements to add.", "info"); return end
        -- Simple favorites list
        local favText = "⭐ Favorites:\n"
        for _, fav in ipairs(Favorites) do favText = favText .. "• " .. fav .. "\n" end
        InternalNotify(favText, "info")
    end
    
    -- Keybind toggle
    local toggleConn = UserInputService.InputBegan:Connect(function(inp, gpe) if gpe then return end; if inp.KeyCode == Enum.KeyCode.RightShift then ScreenGui.Enabled = not ScreenGui.Enabled end end)
    table.insert(allConnections, toggleConn)
    
    -- Ctrl+K search focus
    local searchConn = UserInputService.InputBegan:Connect(function(inp, gpe) if gpe then return end; if inp.KeyCode == Enum.KeyCode.K and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then end end)
    table.insert(allConnections, searchConn)
    
    -- ============================================
    -- TAB SYSTEM
    -- ============================================
    local Tabs = {}
    local allPages = {}
    local allButtons = {}
    
    local function SelectPage(page, button, icon, title)
        for _, p in ipairs(allPages) do p.Visible = false end
        for _, b in ipairs(allButtons) do
            Tween(b.btn, {BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.3, TextColor3 = ActiveTheme.TextMuted}, 0.12)
        end
        page.Visible = true
        Tween(button.btn, {BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.1, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.12)
        CenterIcon.Text = icon; CenterTitle.Text = title; UpdateScrollSize()
    end
    
    function Tabs:CreateTab(tabData)
        local name, icon = type(tabData) == "table" and tabData.Name or tabData, type(tabData) == "table" and (tabData.Icon or "") or ""
        local NavBtn = create("TextButton", {Parent = LeftSidebar, BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.3, Size = UDim2.new(1, 0, 0, 26), Font = FONT.Body, RichText = true, Text = icon .. "  " .. name, TextColor3 = ActiveTheme.Text, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, BorderSizePixel = 0})
        create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = NavBtn})
        create("UIStroke", {Parent = NavBtn, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1})
        
        local BadgeLabel = create("TextLabel", {Parent = NavBtn, BackgroundColor3 = Color3.fromRGB(255, 60, 80), BackgroundTransparency = 1, Position = UDim2.new(0.88, 0, 0.15, 0), Size = UDim2.new(0, 16, 0, 16), Font = FONT.Header, Text = "", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 9, BorderSizePixel = 0, Visible = false})
        create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = BadgeLabel})
        
        local Page = create("Frame", {Parent = ScrollContent, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), Visible = false, BorderSizePixel = 0})
        local PageList = create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
        local function ResizePage() Page.Size = UDim2.new(1, 0, 0, PageList.AbsoluteContentSize.Y); UpdateScrollSize() end
        Page.ChildAdded:Connect(function() task.wait(0.03); ResizePage() end)
        Page.ChildRemoved:Connect(function() task.wait(0.03); ResizePage() end)
        
        local tabEntry = {btn = NavBtn, page = Page, name = name, icon = icon, badge = BadgeLabel}
        table.insert(allPages, Page); table.insert(allButtons, tabEntry)
        NavBtn.MouseButton1Click:Connect(function() SelectPage(Page, tabEntry, icon, name) end)
        if #allPages == 1 then SelectPage(Page, tabEntry, icon, name) end
        
        local TabAPI = {}
        function TabAPI:SetBadge(text) if text == "" or text == nil then BadgeLabel.Visible = false else BadgeLabel.Text = text; BadgeLabel.Visible = true; BadgeLabel.BackgroundTransparency = 0 end end
        
        local Sections = {}
        function Sections:AddSection(name)
            local SectionFrame = create("Frame", {Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0})
            local SectionList = create("UIListLayout", {Parent = SectionFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
            local collapsed = false
            local contentHolder = create("Frame", {Parent = SectionFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0})
            local contentList = create("UIListLayout", {Parent = contentHolder, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
            
            local function UpdateSectionSize() contentHolder.Size = UDim2.new(1, 0, 0, collapsed and 0 or contentList.AbsoluteContentSize.Y); SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y); ResizePage() end
            contentHolder.ChildAdded:Connect(function() task.wait(0.03); UpdateSectionSize() end)
            
            local Elements = {}
            
            local function CreateElement(height)
                height = height or 26
                local el = create("TextButton", {Parent = contentHolder, BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, height), AutoButtonColor = false, Text = "", BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = el})
                create("UIStroke", {Parent = el, Color = ActiveTheme.Border, Transparency = 0.6, Thickness = 0.8})
                el.MouseEnter:Connect(function() Tween(el, {BackgroundColor3 = Color3.fromRGB(40, 15, 60), BackgroundTransparency = 0.08}, 0.1) end)
                el.MouseLeave:Connect(function() Tween(el, {BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.2}, 0.1) end)
                return el
            end
            
            -- FESTIVAL CARDS
            function Elements:AddCard(data)
                local card = create("Frame", {Parent = contentHolder, BackgroundColor3 = ActiveTheme.CardBg or ActiveTheme.ContainerBg, BackgroundTransparency = 0.12, Size = UDim2.new(1, 0, 0, 55), BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = card})
                create("UIStroke", {Parent = card, Color = ActiveTheme.Accent, Transparency = 0.25, Thickness = 1.5})
                if data.Icon then create("TextLabel", {Parent = card, BackgroundTransparency = 1, Position = UDim2.new(0.05, 0, 0.05, 0), Size = UDim2.new(0, 24, 0, 24), Font = FONT.Body, Text = data.Icon, TextSize = 18}) end
                create("TextLabel", {Parent = card, BackgroundTransparency = 1, Position = UDim2.new(data.Icon and 0.18 or 0.05, 0, 0.08, 0), Size = UDim2.new(data.Icon and 0.78 or 0.9, 0, 0, 16), Font = FONT.Header, Text = data.Title or "", TextColor3 = ActiveTheme.Accent, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left})
                create("TextLabel", {Parent = card, BackgroundTransparency = 1, Position = UDim2.new(0.05, 0, 0.42, 0), Size = UDim2.new(0.9, 0, 0, 26), Font = FONT.Text, Text = data.Description or "", TextColor3 = ActiveTheme.TextMuted, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true})
                UpdateSectionSize()
            end
            
            -- TOGGLE (premium animations)
            function Elements:AddToggle(data, default, callback)
                local name, flag, def, cb
                if type(data) == "table" then name = data.Name; flag = data.Flag; def = data.Default or false; cb = data.Callback or function() end
                else name = data; def = default or false; cb = callback or function() end end
                
                local toggled = def; local btn = CreateElement()
                elementCounter = elementCounter + 1; local elementId = "toggle_" .. elementCounter
                if flag then Flags[flag] = def end
                
                create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.58, 0, 1, 0), Font = FONT.Body, Text = name, TextColor3 = ActiveTheme.Text, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left})
                local track = create("Frame", {Parent = btn, BackgroundColor3 = ActiveTheme.ToggleOff, BorderSizePixel = 0, Position = UDim2.new(0.76, 0, 0.5, -7), Size = UDim2.new(0, 30, 0, 14)})
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})
                
                -- Glow effect
                local glow = create("Frame", {Parent = track, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 6, 1, 6), Position = UDim2.new(0, -3, 0, -3), ZIndex = 0})
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = glow})
                
                local dot = create("Frame", {Parent = track, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Position = def and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5), Size = UDim2.new(0, 10, 0, 10)})
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                create("UIStroke", {Parent = dot, Color = ActiveTheme.Accent, Thickness = 1.5})
                
                local locked = false
                local function SetToggle(state, instant)
                    if locked then return end
                    toggled = state; if flag then Flags[flag] = state end
                    local pos = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
                    if instant then
                        dot.Position = pos; track.BackgroundColor3 = state and ActiveTheme.Accent or ActiveTheme.ToggleOff
                        glow.BackgroundTransparency = state and 0.4 or 1
                    else
                        Tween(dot, {Position = pos}, 0.25, Ease.spring)
                        Tween(track, {BackgroundColor3 = state and ActiveTheme.Accent or ActiveTheme.ToggleOff}, 0.15)
                        Tween(glow, {BackgroundTransparency = state and 0.4 or 1}, 0.2)
                    end
                    LogChange(name .. " = " .. (state and "ON" or "OFF")); RefreshRecent()
                end
                if def then SetToggle(true, true) end
                btn.MouseButton1Click:Connect(function() SetToggle(not toggled) end)
                
                -- Right-click for favorites
                btn.MouseButton2Click:Connect(function()
                    table.insert(Favorites, name)
                    InternalNotify("⭐ Added to favorites: " .. name, "success")
                end)
                
                table.insert(allElements, {id = elementId, get = function() return toggled end, set = function(v) SetToggle(v, true) end})
                UpdateSectionSize()
                
                local tooltipText = ""
                btn.MouseEnter:Connect(function() if tooltipText ~= "" then ShowTooltip(tooltipText, btn.AbsolutePosition + Vector2.new(0, btn.AbsoluteSize.Y)) end end)
                btn.MouseLeave:Connect(function() HideTooltip() end)
                
                return {
                    SetState = function(s) SetToggle(s) end, Flag = flag,
                    SetTooltip = function(t) tooltipText = t end,
                    SetVisible = function(v) btn.Visible = v; UpdateSectionSize() end,
                    SetLocked = function(l) locked = l; btn.BackgroundTransparency = l and 0.6 or 0.2 end,
                    Destroy = function() btn:Destroy(); UpdateSectionSize() end,
                }
            end
            
            -- SLIDER
            function Elements:AddSlider(data, min, max, default, callback)
                local name, flag, mn, mx, def, cb
                if type(data) == "table" then name = data.Name; flag = data.Flag; mn = data.Min or 0; mx = data.Max or 100; def = data.Default or mn; cb = data.Callback or function() end
                else name = data; mn = min or 0; mx = max or 100; def = default or mn; cb = callback or function() end end
                def = math.clamp(def, mn, mx); local currentValue = def; local btn = CreateElement(38)
                elementCounter = elementCounter + 1; local elementId = "slider_" .. elementCounter
                if flag then Flags[flag] = def end
                
                create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0.05, 0), Size = UDim2.new(0.5, 0, 0, 13), Font = FONT.Body, Text = name, TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left})
                local valBox = create("Frame", {Parent = btn, BackgroundColor3 = ActiveTheme.InputBg, Position = UDim2.new(0.7, 0, 0.05, 0), Size = UDim2.new(0, 36, 0, 13), BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = valBox}); create("UIStroke", {Parent = valBox, Color = ActiveTheme.Accent, Transparency = 0.4, Thickness = 1})
                local valLabel = create("TextLabel", {Parent = valBox, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = FONT.Mono, Text = tostring(def), TextColor3 = ActiveTheme.Accent, TextSize = 8})
                local track = create("Frame", {Parent = btn, BackgroundColor3 = ActiveTheme.SliderTrack, BorderSizePixel = 0, Position = UDim2.new(0.06, 0, 0.6, 0), Size = UDim2.new(0.88, 0, 0, 4)})
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = track})
                local fill = create("Frame", {Parent = track, BackgroundColor3 = ActiveTheme.Accent, BorderSizePixel = 0, Size = UDim2.new((def - mn) / (mx - mn), 0, 1, 0)})
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = fill})
                local dot = create("Frame", {Parent = fill, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 12, 0, 12)})
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                create("UIStroke", {Parent = dot, Color = ActiveTheme.Accent, Thickness = 2})
                
                -- Dot glow
                local dotGlow = create("Frame", {Parent = dot, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 4, 1, 4), Position = UDim2.new(0, -2, 0, -2), ZIndex = -1})
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dotGlow})
                
                local locked = false; local mouse = Players.LocalPlayer:GetMouse(); local dragging = false
                local function SetSliderValue(val, instant)
                    if locked then return end
                    val = math.clamp(val, mn, mx); currentValue = val; if flag then Flags[flag] = val end
                    local p = (val - mn) / (mx - mn); fill.Size = UDim2.new(p, 0, 1, 0); valLabel.Text = tostring(val)
                    if not instant then cb(val) end
                    LogChange(name .. " = " .. val); RefreshRecent()
                end
                local function UpdateFromInput(inputX)
                    if locked then return end
                    local relX = math.clamp(inputX - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                    SetSliderValue(math.floor(mn + (mx - mn) * (relX / track.AbsoluteSize.X)))
                end
                track.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = true; UpdateFromInput(inp.Position.X); Tween(dotGlow, {BackgroundTransparency = 0.5}, 0.1) end end)
                local inputConn = UserInputService.InputChanged:Connect(function(inp) if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then UpdateFromInput(inp.Position.X) end end)
                table.insert(allConnections, inputConn)
                local endConn = UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false; Tween(dotGlow, {BackgroundTransparency = 1}, 0.2) end end)
                table.insert(allConnections, endConn)
                table.insert(allElements, {id = elementId, get = function() return currentValue end, set = function(v) SetSliderValue(v, true); cb(v) end})
                UpdateSectionSize()
                
                local tooltipText = ""
                btn.MouseEnter:Connect(function() if tooltipText ~= "" then ShowTooltip(tooltipText, btn.AbsolutePosition + Vector2.new(0, btn.AbsoluteSize.Y)) end end)
                btn.MouseLeave:Connect(function() HideTooltip() end)
                
                return {
                    SetValue = function(v) SetSliderValue(v) end, Flag = flag,
                    SetTooltip = function(t) tooltipText = t end,
                    SetVisible = function(v) btn.Visible = v; UpdateSectionSize() end,
                    SetLocked = function(l) locked = l; btn.BackgroundTransparency = l and 0.6 or 0.2 end,
                    Destroy = function() btn:Destroy(); UpdateSectionSize() end,
                }
            end
            
            -- DROPDOWN / KEYBIND / COLOR PICKER / TEXTBOX / BUTTON / LABEL / PARAGRAPH / SEPARATOR
            -- (same implementations as before, but with spring animations and tooltip support)
            
            function Elements:AddDropdown(name, options, callback)
                callback = callback or function() end; local opened = false
                local dropFrame = create("Frame", {Parent = contentHolder, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), BorderSizePixel = 0, ZIndex = 10})
                local dropList = create("UIListLayout", {Parent = dropFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
                local mainBtn = create("TextButton", {Parent = dropFrame, BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 26), AutoButtonColor = false, Font = FONT.Body, Text = "  " .. name, TextColor3 = ActiveTheme.Text, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0, ZIndex = 10})
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = mainBtn}); create("UIStroke", {Parent = mainBtn, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 0.8})
                local arrow = create("TextLabel", {Parent = mainBtn, BackgroundTransparency = 1, Position = UDim2.new(0.85, 0, 0, 0), Size = UDim2.new(0, 18, 1, 0), Font = FONT.Body, Text = "▾", TextColor3 = ActiveTheme.Accent, TextSize = 10, ZIndex = 11})
                local optFrames = {}
                for _, opt in ipairs(options) do
                    local optBtn = create("TextButton", {Parent = dropFrame, BackgroundColor3 = ActiveTheme.InputBg, Size = UDim2.new(1, 0, 0, 24), AutoButtonColor = false, Font = FONT.Text, Text = "   " .. opt, TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, Visible = false, BorderSizePixel = 0, ZIndex = 12})
                    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = optBtn})
                    optBtn.MouseButton1Click:Connect(function()
                        mainBtn.Text = "  " .. opt; callback(opt); LogChange(name .. " = " .. opt); RefreshRecent()
                        opened = false; Tween(arrow, {Rotation = 0}, 0.2)
                        for _, o in ipairs(optFrames) do o.Visible = false end; Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 26)}, 0.15, Ease.smooth); UpdateSectionSize()
                    end)
                    table.insert(optFrames, optBtn)
                end
                mainBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        Tween(arrow, {Rotation = 180}, 0.2)
                        for _, o in ipairs(optFrames) do o.Visible = true end
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y)}, 0.15, Ease.spring)
                    else
                        Tween(arrow, {Rotation = 0}, 0.2)
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 26)}, 0.15, Ease.smooth)
                        task.wait(0.15); for _, o in ipairs(optFrames) do o.Visible = false end
                    end; UpdateSectionSize()
                end)
                UpdateSectionSize()
                return {Refresh = function(no) for _, o in ipairs(optFrames) do o:Destroy() end; optFrames = {}; for _, opt in ipairs(no) do local o = create("TextButton", {Parent = dropFrame, BackgroundColor3 = ActiveTheme.InputBg, Size = UDim2.new(1, 0, 0, 24), AutoButtonColor = false, Font = FONT.Text, Text = "   " .. opt, TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, Visible = opened, BorderSizePixel = 0, ZIndex = 12}); create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = o}); o.MouseButton1Click:Connect(function() mainBtn.Text = "  " .. opt; callback(opt); opened = false; Tween(arrow, {Rotation = 0}, 0.2); for _, o2 in ipairs(optFrames) do o2.Visible = false end; Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 26)}, 0.15, Ease.smooth); UpdateSectionSize() end); table.insert(optFrames, o) end; if opened then dropFrame.Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y) end; UpdateSectionSize() end}
            end
            
            -- KEYBIND / COLOR PICKER / TEXTBOX / BUTTON / LABEL (same polished implementations)
            function Elements:AddKeybind(name, defaultKey, callback)
                local currentKey = defaultKey or Enum.KeyCode.E; local mode = "Toggle"; local listening = false; local held = false; local btn = CreateElement()
                create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.42, 0, 1, 0), Font = FONT.Body, Text = name, TextColor3 = ActiveTheme.Text, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left})
                local keyLabel = create("TextButton", {Parent = btn, BackgroundColor3 = ActiveTheme.Secondary or ActiveTheme.Accent, BackgroundTransparency = 0.3, Position = UDim2.new(0.52, 0, 0.5, -10), Size = UDim2.new(0, 45, 0, 20), Font = FONT.Header, Text = currentKey.Name, TextColor3 = ActiveTheme.Text, TextSize = 8, AutoButtonColor = false, BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = keyLabel})
                local modeLabel = create("TextButton", {Parent = btn, BackgroundColor3 = ActiveTheme.InputBg, Position = UDim2.new(0.75, 0, 0.5, -10), Size = UDim2.new(0, 40, 0, 20), Font = FONT.Text, Text = mode, TextColor3 = ActiveTheme.TextMuted, TextSize = 7, AutoButtonColor = false, BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = modeLabel})
                local bindConnection
                local function SetBind(nk) currentKey = nk; keyLabel.Text = nk.Name; if bindConnection then bindConnection:Disconnect() end; bindConnection = UserInputService.InputBegan:Connect(function(inp, gpe) if gpe then return end; if inp.KeyCode == currentKey and not listening then if mode == "Toggle" then callback() elseif mode == "Hold" then held = true; while held and task.wait() do callback() end end end end); if mode == "Hold" then local rc = UserInputService.InputEnded:Connect(function(inp) if inp.KeyCode == currentKey then held = false end end); table.insert(allConnections, rc) end end
                keyLabel.MouseButton1Click:Connect(function() listening = true; keyLabel.Text = "..."; local conn = UserInputService.InputBegan:Connect(function(inp, gpe) if gpe then return end; if listening and inp.KeyCode ~= Enum.KeyCode.Unknown and inp.KeyCode ~= Enum.KeyCode.RightShift then SetBind(inp.KeyCode); listening = false; conn:Disconnect() end end) end)
                modeLabel.MouseButton1Click:Connect(function() mode = mode == "Toggle" and "Hold" or "Toggle"; modeLabel.Text = mode; SetBind(currentKey) end)
                SetBind(currentKey); UpdateSectionSize()
                return {GetKey = function() return currentKey end, SetKey = function(k) SetBind(k) end, SetMode = function(m) mode = m; modeLabel.Text = m; SetBind(currentKey) end}
            end
            
            function Elements:AddColorPicker(name, defaultColor, callback)
                defaultColor = defaultColor or Color3.fromRGB(255, 0, 255); local currentColor = defaultColor; local btn = CreateElement(80)
                elementCounter = elementCounter + 1; local elementId = "color_" .. elementCounter
                create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0.04, 0), Size = UDim2.new(0.5, 0, 0, 14), Font = FONT.Body, Text = name, TextColor3 = ActiveTheme.Text, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left})
                local colorPreview = create("Frame", {Parent = btn, BackgroundColor3 = currentColor, Position = UDim2.new(0.7, 0, 0.04, 0), Size = UDim2.new(0, 30, 0, 14), BorderSizePixel = 0}); create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = colorPreview})
                local function ms(y, c) local s = create("Frame", {Parent = btn, BackgroundColor3 = ActiveTheme.SliderTrack, BorderSizePixel = 0, Position = UDim2.new(0.06, 0, y, 0), Size = UDim2.new(0.88, 0, 0, 3)}); create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = s}); local f = create("Frame", {Parent = s, BackgroundColor3 = c, BorderSizePixel = 0, Size = UDim2.new(0.5, 0, 1, 0)}); create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = f}); return s, f end
                local rS, rF = ms(0.28, Color3.fromRGB(255, 0, 0)); local gS, gF = ms(0.48, Color3.fromRGB(0, 255, 0)); local bS, bF = ms(0.68, Color3.fromRGB(0, 0, 255))
                rF.Size = UDim2.new(currentColor.R, 0, 1, 0); gF.Size = UDim2.new(currentColor.G, 0, 1, 0); bF.Size = UDim2.new(currentColor.B, 0, 1, 0)
                local function UC() currentColor = Color3.fromRGB(rF.AbsoluteSize.X / rS.AbsoluteSize.X, gF.AbsoluteSize.X / gS.AbsoluteSize.X, bF.AbsoluteSize.X / bS.AbsoluteSize.X); colorPreview.BackgroundColor3 = currentColor; callback(currentColor) end
                local function MD(slider, fill) local mouse = Players.LocalPlayer:GetMouse(); local dragging = false; slider.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = true end end); local conn = UserInputService.InputChanged:Connect(function(inp) if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local rX = math.clamp(inp.Position.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X); fill.Size = UDim2.new(rX / slider.AbsoluteSize.X, 0, 1, 0); UC() end end); table.insert(allConnections, conn); local eC = UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end end); table.insert(allConnections, eC) end
                MD(rS, rF); MD(gS, gF); MD(bS, bF)
                table.insert(allElements, {id = elementId, get = function() return currentColor end, set = function(v) currentColor = v; colorPreview.BackgroundColor3 = v; rF.Size = UDim2.new(v.R, 0, 1, 0); gF.Size = UDim2.new(v.G, 0, 1, 0); bF.Size = UDim2.new(v.B, 0, 1, 0); callback(v) end})
                UpdateSectionSize()
                return {GetColor = function() return currentColor end, SetColor = function(c) currentColor = c; colorPreview.BackgroundColor3 = c; rF.Size = UDim2.new(c.R, 0, 1, 0); gF.Size = UDim2.new(c.G, 0, 1, 0); bF.Size = UDim2.new(c.B, 0, 1, 0); callback(c) end}
            end
            
            function Elements:AddTextBox(name, default, callback)
                default = default or ""; local btn = CreateElement()
                create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.3, 0, 1, 0), Font = FONT.Body, Text = name, TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left})
                local tb = create("TextBox", {Parent = btn, BackgroundColor3 = ActiveTheme.InputBg, Position = UDim2.new(0.38, 0, 0.5, -9), Size = UDim2.new(0.56, 0, 0, 18), Font = FONT.Text, Text = default, TextColor3 = ActiveTheme.Text, PlaceholderColor3 = ActiveTheme.TextMuted, TextSize = 9, ClearTextOnFocus = false, BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = tb}); create("UIStroke", {Parent = tb, Color = ActiveTheme.Border, Transparency = 0.4, Thickness = 1})
                tb.FocusLost:Connect(function(ep) if ep then callback(tb.Text) end end)
                UpdateSectionSize()
                return {GetText = function() return tb.Text end, SetText = function(t) tb.Text = t end, SetVisible = function(v) btn.Visible = v; UpdateSectionSize() end, Destroy = function() btn:Destroy(); UpdateSectionSize() end}
            end
            
            function Elements:AddButton(name, callback)
                local btn = CreateElement()
                create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.76, 0, 1, 0), Font = FONT.Body, Text = name, TextColor3 = ActiveTheme.Text, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left})
                local arrowIcon = create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.85, 0, 0, 0), Size = UDim2.new(0, 16, 1, 0), Font = FONT.Header, Text = "→", TextColor3 = ActiveTheme.Accent, TextSize = 12})
                btn.MouseButton1Click:Connect(function()
                    Tween(btn, {BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0}, 0.06)
                    Tween(arrowIcon, {TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14}, 0.06)
                    task.wait(0.08)
                    Tween(btn, {BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.2}, 0.15)
                    Tween(arrowIcon, {TextColor3 = ActiveTheme.Accent, TextSize = 12}, 0.15)
                    callback()
                end)
                UpdateSectionSize()
                return {SetText = function(t) btn.TextLabel.Text = t end, SetVisible = function(v) btn.Visible = v; UpdateSectionSize() end, Destroy = function() btn:Destroy(); UpdateSectionSize() end}
            end
            
            function Elements:AddLabel(text)
                local lbl = create("Frame", {Parent = contentHolder, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.75, Size = UDim2.new(1, 0, 0, 18), BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = lbl})
                local lt = create("TextLabel", {Parent = lbl, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.94, 0, 1, 0), Font = FONT.Header, Text = "  " .. text, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left})
                UpdateSectionSize()
                return {SetText = function(t) lt.Text = "  " .. t end, Bind = function(fn) coroutine.wrap(function() while lbl and lbl.Parent do lt.Text = "  " .. fn(); RunService.Heartbeat:Wait() end end)() end, SetVisible = function(v) lbl.Visible = v; UpdateSectionSize() end, Destroy = function() lbl:Destroy(); UpdateSectionSize() end}
            end
            
            function Elements:AddParagraph(title, content)
                local p = create("Frame", {Parent = contentHolder, BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 40), BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = p}); create("UIStroke", {Parent = p, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 0.8})
                create("TextLabel", {Parent = p, BackgroundTransparency = 1, Position = UDim2.new(0.04, 0, 0.05, 0), Size = UDim2.new(0.92, 0, 0, 14), Font = FONT.Header, Text = title, TextColor3 = ActiveTheme.Accent, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left})
                create("TextLabel", {Parent = p, BackgroundTransparency = 1, Position = UDim2.new(0.04, 0, 0.45, 0), Size = UDim2.new(0.92, 0, 0, 18), Font = FONT.Text, Text = content, TextColor3 = ActiveTheme.TextMuted, TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true})
                UpdateSectionSize()
            end
            
            function Elements:AddSeparator()
                local s = create("Frame", {Parent = contentHolder, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.6, Size = UDim2.new(1, 0, 0, 2), BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 1), Parent = s}); UpdateSectionSize()
            end
            
            function Elements:SetCollapsed(state) collapsed = state; contentHolder.Visible = not state; UpdateSectionSize() end
            function Elements:Toggle() collapsed = not collapsed; contentHolder.Visible = not collapsed; UpdateSectionSize() end
            
            return Elements
        end
        return Sections
    end
    
    -- Local tab
    local LocalTab = Tabs:CreateTab({Name = "Local", Icon = "📋"})
    local LocalSection = LocalTab:AddSection("Player Info")
    local player = Players.LocalPlayer; local char = player.Character; local hum = char and char:FindFirstChild("Humanoid")
    for _, pair in ipairs({{"👤 Username", player.Name}, {"🆔 UserId", player.UserId}, {"📅 Account Age", player.AccountAge .. " days"}, {"🎮 Game", pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end) or "Unknown"}, {"📍 Place ID", game.PlaceId}, {"🖥️ Job ID", game.JobId}, {"⚡ Ping", tostring(math.floor(Stats.PerformanceStats.Ping:GetValue())) .. "ms"}, {"⏰ Time", os.date("%H:%M:%S")}, {"🏃 WalkSpeed", hum and tostring(hum.WalkSpeed) or "N/A"}, {"🦘 JumpPower", hum and tostring(hum.JumpPower) or "N/A"}, {"❤️ Health", hum and tostring(math.floor(hum.Health)) or "N/A"}, {"🔧 Executor", (identifyexecutor and identifyexecutor()) or "Unknown"}}) do
        LocalSection:AddLabel(pair[1] .. ": " .. tostring(pair[2]))
    end
    
    -- Status bar
    local StatusBar = create("Frame", {Parent = ScreenGui, BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.25, Position = UDim2.new(0.01, 0, 0.01, 0), Size = UDim2.new(0, 220, 0, 22), BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = StatusBar}); create("UIStroke", {Parent = StatusBar, Color = ActiveTheme.Border, Transparency = 0.4, Thickness = 1})
    local StatusLabel = create("TextLabel", {Parent = StatusBar, BackgroundTransparency = 1, Position = UDim2.new(0.04, 0, 0, 0), Size = UDim2.new(0.92, 0, 1, 0), Font = FONT.Body, Text = title .. " | " .. ActiveThemeName, TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left})
    function WindowAPI:SetStatusBar(data) StatusLabel.Text = table.concat(data, " | ") end
    local sbRunning = true; table.insert(allGradientLoops, function() sbRunning = false end)
    coroutine.wrap(function() while sbRunning and ScreenGui and ScreenGui.Parent do local fps = math.floor(1 / (RunService.RenderStepped:Wait() or 0.016)); StatusLabel.Text = title .. " | " .. fps .. " FPS | " .. ActiveThemeName end end)()
    
    function WindowAPI:SetSize(w, h) Tween(Main, {Size = UDim2.new(0, w, 0, h)}, 0.2) end
    function WindowAPI:SetPosition(x, y) Main.Position = UDim2.new(0, x, 0, y) end
    function WindowAPI:Center() Main.Position = UDim2.new(0.5, -Main.AbsoluteSize.X/2, 0.5, -Main.AbsoluteSize.Y/2) end
    function WindowAPI:Destroy()
        for _, fn in ipairs(allGradientLoops) do pcall(fn) end
        for _, conn in ipairs(allConnections) do pcall(function() conn:Disconnect() end) end
        pcall(function() ScreenGui:Destroy() end)
    end
    
    WindowAPI.Flags = Flags
    return WindowAPI
end

return Library
