-- ============================================
-- 🌴 PALMTREE.LUA v9 - PROFESSIONAL EDITION
-- Flags, Keybinds, ColorPickers, Themes, Search
-- Dependencies, Multi-Dropdowns, Watermark
-- ============================================

local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local TextService = game:GetService("TextService")

-- ============================================
-- THEME SYSTEM
-- ============================================
local Themes = {
    ["Miami Sunset"] = {
        Gradient = {
            {Color3.fromRGB(255, 94, 91), Color3.fromRGB(15, 23, 42)},
            {Color3.fromRGB(255, 179, 71), Color3.fromRGB(20, 25, 48)},
            {Color3.fromRGB(240, 120, 80), Color3.fromRGB(18, 20, 45)},
            {Color3.fromRGB(255, 140, 60), Color3.fromRGB(15, 23, 42)},
        },
        Accent = Color3.fromRGB(255, 94, 91),
        Secondary = Color3.fromRGB(122, 92, 250),
        Cyan = Color3.fromRGB(0, 210, 240),
        Border = Color3.fromRGB(255, 94, 91),
        ContainerBg = Color3.fromRGB(25, 8, 45),
        InputBg = Color3.fromRGB(30, 10, 50),
        Text = Color3.fromRGB(255, 245, 250),
        TextMuted = Color3.fromRGB(180, 150, 195),
    },
    ["Midnight"] = {
        Gradient = {
            {Color3.fromRGB(10, 10, 30), Color3.fromRGB(5, 5, 20)},
            {Color3.fromRGB(15, 12, 35), Color3.fromRGB(8, 6, 22)},
        },
        Accent = Color3.fromRGB(100, 150, 255),
        Secondary = Color3.fromRGB(80, 100, 200),
        Cyan = Color3.fromRGB(0, 180, 220),
        Border = Color3.fromRGB(100, 150, 255),
        ContainerBg = Color3.fromRGB(20, 20, 40),
        InputBg = Color3.fromRGB(30, 30, 55),
        Text = Color3.fromRGB(240, 245, 255),
        TextMuted = Color3.fromRGB(160, 170, 200),
    },
    ["Cyber"] = {
        Gradient = {
            {Color3.fromRGB(5, 2, 20), Color3.fromRGB(20, 2, 40)},
            {Color3.fromRGB(8, 3, 25), Color3.fromRGB(25, 3, 45)},
        },
        Accent = Color3.fromRGB(0, 255, 200),
        Secondary = Color3.fromRGB(200, 0, 255),
        Cyan = Color3.fromRGB(0, 255, 255),
        Border = Color3.fromRGB(0, 255, 200),
        ContainerBg = Color3.fromRGB(10, 5, 25),
        InputBg = Color3.fromRGB(15, 8, 35),
        Text = Color3.fromRGB(230, 255, 250),
        TextMuted = Color3.fromRGB(150, 180, 175),
    },
}

local ActiveTheme = Themes["Miami Sunset"]
local ActiveThemeName = "Miami Sunset"

local FONT = {
    Header = Enum.Font.GothamBold,
    Body = Enum.Font.GothamSemibold,
    Text = Enum.Font.Gotham,
    Mono = Enum.Font.RobotoMono,
    Script = Enum.Font.FredokaOne,
}

local ConfigFolder = "PalmTree_Configs"
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
local function create(class, props)
    local i = Instance.new(class)
    for k, v in pairs(props) do i[k] = v end
    return i
end

local function Tween(obj, props, dur, easing)
    return TweenService:Create(obj, TweenInfo.new(dur or 0.15, easing or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
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
-- MAIN LIBRARY FUNCTION
-- ============================================
function Library:CreateWindow(title)
    title = title or "PalmTree"
    local uiName = "PT_" .. math.random(1000, 9999)
    if CoreGui:FindFirstChild(uiName) then CoreGui[uiName]:Destroy() end
    
    local ScreenGui = create("ScreenGui", {
        Name = uiName, Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false, Enabled = true,
    })
    
    -- ============================================
    -- FLAGS SYSTEM
    -- ============================================
    local Flags = {}
    
    -- ============================================
    -- NOTIFICATION SYSTEM (PUBLIC)
    -- ============================================
    local NotifHolder = create("Frame", {
        Parent = ScreenGui, BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -10, 1, -10),
        Size = UDim2.new(0, 220, 0, 0),
        BorderSizePixel = 0, ZIndex = 100,
    })
    create("UIListLayout", {
        Parent = NotifHolder, SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4), VerticalAlignment = Enum.VerticalAlignment.Bottom,
    })
    
    function Library:Notify(data)
        local duration = data.Duration or 2.5
        local titleText = data.Title or ""
        local contentText = data.Content or ""
        local ntype = data.Type or "info"
        local cols = {success = Color3.fromRGB(100, 255, 150), info = ActiveTheme.Cyan, warning = Color3.fromRGB(255, 210, 70)}
        
        local notif = create("Frame", {
            Parent = NotifHolder, BackgroundColor3 = ActiveTheme.ContainerBg,
            Size = UDim2.new(1, 0, 0, titleText ~= "" and 36 or 24), BorderSizePixel = 0,
            BackgroundTransparency = 1, ZIndex = 100,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = notif})
        create("UIStroke", {Parent = notif, Color = cols[ntype] or ActiveTheme.Accent, Transparency = 0.2, Thickness = 1.5})
        create("Frame", {
            Parent = notif, BackgroundColor3 = cols[ntype] or ActiveTheme.Accent,
            BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(0, 3, 1, 0),
        })
        
        if titleText ~= "" then
            create("TextLabel", {
                Parent = notif, BackgroundTransparency = 1,
                Position = UDim2.new(0.08, 0, 0.05, 0), Size = UDim2.new(0.88, 0, 0, 14),
                Font = FONT.Header, Text = titleText, TextColor3 = cols[ntype] or ActiveTheme.Accent,
                TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 100,
            })
            create("TextLabel", {
                Parent = notif, BackgroundTransparency = 1,
                Position = UDim2.new(0.08, 0, 0.45, 0), Size = UDim2.new(0.88, 0, 0, 16),
                Font = FONT.Text, Text = contentText, TextColor3 = ActiveTheme.Text,
                TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 100,
            })
        else
            create("TextLabel", {
                Parent = notif, BackgroundTransparency = 1,
                Position = UDim2.new(0.08, 0, 0, 0), Size = UDim2.new(0.88, 0, 1, 0),
                Font = FONT.Text, Text = contentText, TextColor3 = ActiveTheme.Text,
                TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 100,
            })
        end
        
        Tween(notif, {BackgroundTransparency = 0}, 0.2)
        task.delay(duration, function()
            if notif and notif.Parent then
                Tween(notif, {BackgroundTransparency = 1}, 0.3)
                task.wait(0.3)
                notif:Destroy()
            end
        end)
    end
    
    local function InternalNotify(text, ntype)
        Library:Notify({Content = text, Type = ntype or "info", Duration = 2.5})
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
    create("UIStroke", {Parent = Main, Color = ActiveTheme.Border, Transparency = 0.4, Thickness = 2})
    
    -- Dynamic gradient
    local BgGradient = create("UIGradient", {
        Parent = Main,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, ActiveTheme.Gradient[1][1]),
            ColorSequenceKeypoint.new(1, ActiveTheme.Gradient[1][2]),
        }),
        Rotation = 180,
    })
    
    local currentStep, nextStep, stepProgress = 1, 2, 0
    coroutine.wrap(function()
        while BgGradient and BgGradient.Parent do
            local from = ActiveTheme.Gradient[currentStep]
            local to = ActiveTheme.Gradient[nextStep]
            stepProgress = math.clamp(stepProgress + 0.004, 0, 1)
            if stepProgress >= 1 then
                stepProgress = 0
                currentStep = nextStep
                nextStep = nextStep % #ActiveTheme.Gradient + 1
                from = ActiveTheme.Gradient[currentStep]
                to = ActiveTheme.Gradient[nextStep]
            end
            BgGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, from[1]:Lerp(to[1], stepProgress)),
                ColorSequenceKeypoint.new(1, from[2]:Lerp(to[2], stepProgress)),
            })
            RunService.Heartbeat:Wait()
        end
    end)()
    
    -- Header
    local Header = create("Frame", {
        Parent = Main, BackgroundColor3 = Color3.fromRGB(20, 4, 45),
        BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 30), BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Header})
    create("Frame", {
        Parent = Header, BackgroundColor3 = Color3.fromRGB(20, 4, 45),
        BackgroundTransparency = 0.2, BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0.5, 0),
    })
    
    create("TextLabel", {
        Parent = Header, BackgroundTransparency = 1,
        Position = UDim2.new(0.025, 0, 0, 0), Size = UDim2.new(0, 20, 1, 0),
        Font = FONT.Body, Text = "🌴", TextSize = 14,
    })
    create("TextLabel", {
        Parent = Header, BackgroundTransparency = 1,
        Position = UDim2.new(0.09, 0, 0.05, 0), Size = UDim2.new(0.35, 0, 0.45, 0),
        Font = FONT.Script, Text = title, TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    })
    create("TextLabel", {
        Parent = Header, BackgroundTransparency = 1,
        Position = UDim2.new(0.09, 0, 0.5, 0), Size = UDim2.new(0.3, 0, 0.4, 0),
        Font = FONT.Text, Text = ActiveThemeName, TextColor3 = ActiveTheme.Accent,
        TextSize = 7, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Window buttons
    local MinBtn = create("TextButton", {
        Parent = Header, BackgroundColor3 = ActiveTheme.Accent,
        BackgroundTransparency = 0.8, Position = UDim2.new(0.92, 0, 0.12, 0),
        Size = UDim2.new(0, 22, 0, 22), Font = FONT.Header, Text = "−",
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 16, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = MinBtn})
    
    local CloseBtn = create("TextButton", {
        Parent = Header, BackgroundColor3 = ActiveTheme.Accent,
        BackgroundTransparency = 0.8, Position = UDim2.new(0.97, 0, 0.12, 0),
        Size = UDim2.new(0, 22, 0, 22), Font = FONT.Header, Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 16, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = CloseBtn})
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui.Enabled = false end)
    
    local minimized = false
    local ContentArea
    
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            ContentArea.Visible = false
            Tween(Main, {Size = UDim2.new(0, 520, 0, 30)}, 0.15)
            MinBtn.Text = "+"
        else
            ContentArea.Visible = true
            Tween(Main, {Size = UDim2.new(0, 520, 0, 320)}, 0.15)
            MinBtn.Text = "−"
        end
    end)
    
    MakeDraggable(Main, Header)
    
    -- Content area
    ContentArea = create("Frame", {
        Parent = Main, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.094, 0),
        Size = UDim2.new(1, 0, 0.906, 0), BorderSizePixel = 0,
    })
    
    -- Left sidebar
    local LeftSidebar = create("Frame", {
        Parent = ContentArea, BackgroundColor3 = Color3.fromRGB(20, 4, 40),
        BackgroundTransparency = 0.4, Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 120, 1, 0), BorderSizePixel = 0, ClipsDescendants = true,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = LeftSidebar})
    create("UIStroke", {Parent = LeftSidebar, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1.5})
    create("UIListLayout", {Parent = LeftSidebar, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3)})
    create("UIPadding", {Parent = LeftSidebar, PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)})
    
    -- Center
    local Center = create("Frame", {
        Parent = ContentArea, BackgroundColor3 = Color3.fromRGB(20, 4, 40),
        BackgroundTransparency = 0.4, Position = UDim2.new(0.24, 0, 0, 0),
        Size = UDim2.new(0, 230, 1, 0), BorderSizePixel = 0, ClipsDescendants = true,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Center})
    create("UIStroke", {Parent = Center, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1.5})
    
    -- Search bar
    local SearchFrame = create("Frame", {
        Parent = Center, BackgroundColor3 = ActiveTheme.InputBg,
        BackgroundTransparency = 0.3, Size = UDim2.new(1, 0, 0, 22), BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SearchFrame})
    create("UIStroke", {Parent = SearchFrame, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1})
    
    create("TextLabel", {
        Parent = SearchFrame, BackgroundTransparency = 1,
        Position = UDim2.new(0.03, 0, 0, 0), Size = UDim2.new(0, 16, 1, 0),
        Font = FONT.Body, Text = "🔍", TextSize = 10,
    })
    local SearchInput = create("TextBox", {
        Parent = SearchFrame, BackgroundTransparency = 1,
        Position = UDim2.new(0.12, 0, 0, 0), Size = UDim2.new(0.84, 0, 1, 0),
        Font = FONT.Text, PlaceholderText = "Search features...",
        TextColor3 = ActiveTheme.Text, PlaceholderColor3 = ActiveTheme.TextMuted,
        TextSize = 9, ClearTextOnFocus = false, BorderSizePixel = 0, Text = "",
    })
    
    -- Search filtering
    local allSearchable = {}
    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchInput.Text:lower()
        for _, item in ipairs(allSearchable) do
            if query == "" then
                item.element.Visible = true
                item.parent.Size = UDim2.new(1, 0, 0, 0)
            else
                local matches = item.name:lower():find(query) ~= nil
                item.element.Visible = matches
                if not matches then
                    -- Hide if no children visible
                    local anyVisible = false
                    for _, child in ipairs(item.parent:GetChildren()) do
                        if child:IsA("TextButton") and child.Visible then
                            anyVisible = true; break
                        end
                    end
                    if not anyVisible then item.parent.Visible = false end
                else
                    item.parent.Visible = true
                end
            end
        end
        task.wait(0.05)
        UpdateScrollSize()
    end)
    
    local CenterScroll = create("ScrollingFrame", {
        Parent = Center, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.085, 0),
        Size = UDim2.new(1, 0, 0.915, 0), BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = ActiveTheme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
    })
    create("UIPadding", {Parent = CenterScroll, PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), PaddingTop = UDim.new(0, 2)})
    
    local CenterTitleFrame = create("Frame", {
        Parent = CenterScroll, BackgroundColor3 = ActiveTheme.Accent,
        BackgroundTransparency = 0.8, Size = UDim2.new(1, 0, 0, 20), BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = CenterTitleFrame})
    local CenterIcon = create("TextLabel", {
        Parent = CenterTitleFrame, BackgroundTransparency = 1,
        Position = UDim2.new(0.03, 0, 0, 0), Size = UDim2.new(0, 16, 1, 0),
        Font = FONT.Body, Text = "⚔️", TextSize = 11,
    })
    local CenterTitle = create("TextLabel", {
        Parent = CenterTitleFrame, BackgroundTransparency = 1,
        Position = UDim2.new(0.13, 0, 0, 0), Size = UDim2.new(0.87, 0, 1, 0),
        Font = FONT.Header, Text = "Combat", TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local ScrollContent = create("Frame", {
        Parent = CenterScroll, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0,
    })
    local ScrollContentList = create("UIListLayout", {
        Parent = ScrollContent, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5),
    })
    
    local function UpdateScrollSize()
        ScrollContent.Size = UDim2.new(1, 0, 0, ScrollContentList.AbsoluteContentSize.Y)
        CenterScroll.CanvasSize = UDim2.new(0, 0, 0, ScrollContentList.AbsoluteContentSize.Y + 28)
    end
    
    -- Right panel
    local RightPanel = create("Frame", {
        Parent = ContentArea, BackgroundColor3 = Color3.fromRGB(20, 4, 40),
        BackgroundTransparency = 0.4, Position = UDim2.new(0.7, 0, 0, 0),
        Size = UDim2.new(0, 150, 1, 0), BorderSizePixel = 0, ClipsDescendants = true,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = RightPanel})
    create("UIStroke", {Parent = RightPanel, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1.5})
    create("UIListLayout", {Parent = RightPanel, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)})
    create("UIPadding", {Parent = RightPanel, PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6)})
    
    -- Config header
    local ConfigHeader = create("Frame", {
        Parent = RightPanel, BackgroundColor3 = ActiveTheme.Accent,
        BackgroundTransparency = 0.8, Size = UDim2.new(1, 0, 0, 20), BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ConfigHeader})
    create("TextLabel", {
        Parent = ConfigHeader, BackgroundTransparency = 1,
        Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.94, 0, 1, 0),
        Font = FONT.Header, Text = "💾 Configs", TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local ConfigInput = create("TextBox", {
        Parent = RightPanel, BackgroundColor3 = ActiveTheme.InputBg,
        Size = UDim2.new(1, 0, 0, 22), Font = FONT.Text, PlaceholderText = "Config name...",
        TextColor3 = ActiveTheme.Text, PlaceholderColor3 = ActiveTheme.TextMuted,
        TextSize = 9, ClearTextOnFocus = false, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ConfigInput})
    create("UIStroke", {Parent = ConfigInput, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1})
    
    local ConfigBtnFrame = create("Frame", {
        Parent = RightPanel, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 22), BorderSizePixel = 0,
    })
    create("UIListLayout", {Parent = ConfigBtnFrame, SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4)})
    
    local SaveBtn = create("TextButton", {
        Parent = ConfigBtnFrame, BackgroundColor3 = ActiveTheme.Accent,
        Size = UDim2.new(0.48, 0, 1, 0), Font = FONT.Header, Text = "Save",
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SaveBtn})
    
    local LoadBtn = create("TextButton", {
        Parent = ConfigBtnFrame, BackgroundColor3 = ActiveTheme.Cyan,
        Size = UDim2.new(0.48, 0, 1, 0), Font = FONT.Header, Text = "Refresh",
        TextColor3 = Color3.fromRGB(20, 4, 40), TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = LoadBtn})
    
    local ConfigListFrame = create("ScrollingFrame", {
        Parent = RightPanel, BackgroundColor3 = ActiveTheme.InputBg,
        Size = UDim2.new(1, 0, 1, -72), BorderSizePixel = 0,
        ScrollBarThickness = 2, ScrollBarImageColor3 = ActiveTheme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ConfigListFrame})
    local ConfigListLayout = create("UIListLayout", {Parent = ConfigListFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3)})
    create("UIPadding", {Parent = ConfigListFrame, PaddingTop = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
    
    -- Config system
    local allElements = {}
    local elementCounter = 0
    
    local function RefreshConfigList()
        for _, c in ipairs(ConfigListFrame:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        local configs = {}
        pcall(function()
            for _, file in ipairs(listfiles(ConfigFolder)) do
                local name = file:match("([^\\/]+)%.json$")
                if name then table.insert(configs, name) end
            end
        end)
        table.sort(configs)
        for _, name in ipairs(configs) do
            local row = create("Frame", {Parent = ConfigListFrame, BackgroundColor3 = ActiveTheme.ContainerBg, Size = UDim2.new(1, 0, 0, 22), BorderSizePixel = 0})
            create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = row})
            create("UIStroke", {Parent = row, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1})
            local loadBtn = create("TextButton", {Parent = row, BackgroundTransparency = 1, Position = UDim2.new(0.03, 0, 0, 0), Size = UDim2.new(0.58, 0, 1, 0), Font = FONT.Text, Text = "📁 " .. name, TextColor3 = ActiveTheme.Text, TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false})
            loadBtn.MouseButton1Click:Connect(function()
                local success, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFolder .. "/" .. name .. ".json")) end)
                if success and data then
                    for _, element in ipairs(allElements) do
                        if data[element.id] ~= nil and element.set then element.set(data[element.id]) end
                    end
                    InternalNotify("Loaded: " .. name, "success")
                end
            end)
            local delBtn = create("TextButton", {Parent = row, BackgroundColor3 = Color3.fromRGB(255, 60, 80), BackgroundTransparency = 0.7, Position = UDim2.new(0.74, 0, 0.1, 0), Size = UDim2.new(0, 18, 0, 16), Font = FONT.Header, Text = "×", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0})
            create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = delBtn})
            delBtn.MouseButton1Click:Connect(function()
                pcall(function() delfile(ConfigFolder .. "/" .. name .. ".json") end)
                RefreshConfigList()
                InternalNotify("Deleted: " .. name, "warning")
            end)
        end
        ConfigListFrame.CanvasSize = UDim2.new(0, 0, 0, ConfigListLayout.AbsoluteContentSize.Y + 10)
    end
    
    SaveBtn.MouseButton1Click:Connect(function()
        local name = ConfigInput.Text
        if name == "" or name:match("^%s*$") then InternalNotify("Enter a config name!", "warning"); return end
        local data = {}
        for _, element in ipairs(allElements) do if element.get then data[element.id] = element.get() end end
        pcall(function() writefile(ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data)) end)
        RefreshConfigList()
        InternalNotify("Saved: " .. name, "success")
    end)
    LoadBtn.MouseButton1Click:Connect(function() RefreshConfigList() end)
    RefreshConfigList()
    
    -- ============================================
    -- THEME MANAGER (PUBLIC)
    -- ============================================
    function Library:SetTheme(themeName)
        if Themes[themeName] then
            ActiveTheme = Themes[themeName]
            ActiveThemeName = themeName
            -- Update UI colors would go here in a full implementation
            InternalNotify("Theme: " .. themeName, "info")
        end
    end
    
    -- Keybind toggle
    UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == Enum.KeyCode.RightShift then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    -- ============================================
    -- TAB SYSTEM
    -- ============================================
    local Tabs = {}
    local allPages = {}
    local allButtons = {}
    
    local function SelectPage(page, button, icon, title)
        for _, p in ipairs(allPages) do p.Visible = false end
        for _, b in ipairs(allButtons) do
            Tween(b, {BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.3, TextColor3 = ActiveTheme.TextMuted}, 0.15)
        end
        page.Visible = true
        Tween(button, {BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.1, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
        CenterIcon.Text = icon
        CenterTitle.Text = title
        UpdateScrollSize()
    end
    
    function Tabs:CreateTab(name, icon)
        icon = icon or ""
        local NavBtn = create("TextButton", {
            Parent = LeftSidebar, BackgroundColor3 = ActiveTheme.ContainerBg,
            BackgroundTransparency = 0.3, Size = UDim2.new(1, 0, 0, 24),
            Font = FONT.Body, RichText = true, Text = icon .. "  " .. name,
            TextColor3 = ActiveTheme.Text, TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, BorderSizePixel = 0,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = NavBtn})
        create("UIStroke", {Parent = NavBtn, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1})
        
        local Page = create("Frame", {
            Parent = ScrollContent, BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0), Visible = false, BorderSizePixel = 0,
        })
        local PageList = create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
        
        local function ResizePage()
            Page.Size = UDim2.new(1, 0, 0, PageList.AbsoluteContentSize.Y)
            UpdateScrollSize()
        end
        Page.ChildAdded:Connect(function() task.wait(0.03); ResizePage() end)
        Page.ChildRemoved:Connect(function() task.wait(0.03); ResizePage() end)
        
        table.insert(allPages, Page)
        table.insert(allButtons, NavBtn)
        NavBtn.MouseButton1Click:Connect(function() SelectPage(Page, NavBtn, icon, name) end)
        if #allPages == 1 then SelectPage(Page, NavBtn, icon, name) end
        
        -- ============================================
        -- SECTIONS
        -- ============================================
        local Sections = {}
        
        function Sections:AddSection(name)
            local SectionFrame = create("Frame", {
                Parent = Page, BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0,
            })
            local SectionList = create("UIListLayout", {Parent = SectionFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
            
            local function UpdateSectionSize()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
                ResizePage()
            end
            SectionFrame.ChildAdded:Connect(function() task.wait(0.03); UpdateSectionSize() end)
            
            local Elements = {}
            
            local function CreateElement(height)
                height = height or 26
                local el = create("TextButton", {
                    Parent = SectionFrame, BackgroundColor3 = ActiveTheme.ContainerBg,
                    BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, height),
                    AutoButtonColor = false, Text = "", BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = el})
                create("UIStroke", {Parent = el, Color = ActiveTheme.Border, Transparency = 0.6, Thickness = 0.8})
                el.MouseEnter:Connect(function() Tween(el, {BackgroundColor3 = Color3.fromRGB(40, 15, 60), BackgroundTransparency = 0.1}, 0.1) end)
                el.MouseLeave:Connect(function() Tween(el, {BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.2}, 0.1) end)
                return el
            end
            
            -- ============================================
            -- TOGGLE (with Flag support)
            -- ============================================
            function Elements:AddToggle(data, default, callback)
                -- Support both old API and new flag API
                local name, flag, def, cb
                if type(data) == "table" then
                    name = data.Name; flag = data.Flag; def = data.Default or false; cb = data.Callback or function() end
                else
                    name = data; def = default or false; cb = callback or function() end
                end
                
                local toggled = def
                local btn = CreateElement()
                elementCounter = elementCounter + 1
                local elementId = "toggle_" .. elementCounter
                
                if flag then Flags[flag] = def end
                
                create("TextLabel", {
                    Parent = btn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.58, 0, 1, 0),
                    Font = FONT.Body, Text = name, TextColor3 = ActiveTheme.Text,
                    TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
                })
                local track = create("Frame", {Parent = btn, BackgroundColor3 = Color3.fromRGB(50, 20, 70), BorderSizePixel = 0, Position = UDim2.new(0.76, 0, 0.5, -7), Size = UDim2.new(0, 30, 0, 14)})
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})
                local dot = create("Frame", {Parent = track, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Position = def and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5), Size = UDim2.new(0, 10, 0, 10)})
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                create("UIStroke", {Parent = dot, Color = ActiveTheme.Accent, Thickness = 1.5})
                
                local function SetToggle(state, instant)
                    toggled = state
                    if flag then Flags[flag] = state end
                    local pos = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
                    if instant then dot.Position = pos; track.BackgroundColor3 = state and ActiveTheme.Accent or Color3.fromRGB(50, 20, 70)
                    else Tween(dot, {Position = pos}, 0.25, Enum.EasingStyle.Back); Tween(track, {BackgroundColor3 = state and ActiveTheme.Accent or Color3.fromRGB(50, 20, 70)}, 0.15) end
                    if not instant then InternalNotify(name .. ": " .. (state and "ON" or "OFF"), state and "success" or "info") end
                    cb(state)
                end
                if def then SetToggle(true, true) end
                btn.MouseButton1Click:Connect(function() SetToggle(not toggled) end)
                
                table.insert(allElements, {id = elementId, get = function() return toggled end, set = function(v) SetToggle(v, true) end})
                UpdateSectionSize()
                return {SetState = function(s) SetToggle(s) end, Flag = flag}
            end
            
            -- ============================================
            -- SLIDER
            -- ============================================
            function Elements:AddSlider(data, min, max, default, callback)
                local name, flag, mn, mx, def, cb
                if type(data) == "table" then
                    name = data.Name; flag = data.Flag; mn = data.Min or 0; mx = data.Max or 100; def = data.Default or mn; cb = data.Callback or function() end
                else
                    name = data; mn = min or 0; mx = max or 100; def = default or mn; cb = callback or function() end
                end
                
                def = math.clamp(def, mn, mx)
                local currentValue = def
                local btn = CreateElement(38)
                elementCounter = elementCounter + 1
                local elementId = "slider_" .. elementCounter
                
                if flag then Flags[flag] = def end
                
                create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0.05, 0), Size = UDim2.new(0.5, 0, 0, 13), Font = FONT.Body, Text = name, TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left})
                local valBox = create("Frame", {Parent = btn, BackgroundColor3 = ActiveTheme.InputBg, Position = UDim2.new(0.7, 0, 0.05, 0), Size = UDim2.new(0, 36, 0, 13), BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = valBox})
                create("UIStroke", {Parent = valBox, Color = ActiveTheme.Accent, Transparency = 0.4, Thickness = 1})
                local valLabel = create("TextLabel", {Parent = valBox, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = FONT.Mono, Text = tostring(def), TextColor3 = ActiveTheme.Accent, TextSize = 8})
                local track = create("Frame", {Parent = btn, BackgroundColor3 = Color3.fromRGB(40, 15, 60), BorderSizePixel = 0, Position = UDim2.new(0.06, 0, 0.6, 0), Size = UDim2.new(0.88, 0, 0, 4)})
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = track})
                local fill = create("Frame", {Parent = track, BackgroundColor3 = ActiveTheme.Accent, BorderSizePixel = 0, Size = UDim2.new((def - mn) / (mx - mn), 0, 1, 0)})
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = fill})
                local dot = create("Frame", {Parent = fill, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 11, 0, 11)})
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                create("UIStroke", {Parent = dot, Color = ActiveTheme.Accent, Thickness = 2})
                
                local mouse = Players.LocalPlayer:GetMouse()
                local dragging = false
                local lastNotif = 0
                
                local function SetSliderValue(val, instant)
                    val = math.clamp(val, mn, mx); currentValue = val
                    if flag then Flags[flag] = val end
                    local p = (val - mn) / (mx - mn)
                    fill.Size = UDim2.new(p, 0, 1, 0); valLabel.Text = tostring(val)
                    if not instant then cb(val) end
                end
                local function UpdateFromInput(inputX, fromDrag)
                    local relX = math.clamp(inputX - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                    local val = math.floor(mn + (mx - mn) * (relX / track.AbsoluteSize.X))
                    SetSliderValue(val)
                    if fromDrag and tick() - lastNotif > 1 then lastNotif = tick(); InternalNotify(name .. ": " .. val, "info") end
                end
                track.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = true; lastNotif = 0; UpdateFromInput(inp.Position.X, true) end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then UpdateFromInput(inp.Position.X, true) end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        if dragging then InternalNotify(name .. " set to: " .. currentValue, "success") end
                        dragging = false
                    end
                end)
                
                table.insert(allElements, {id = elementId, get = function() return currentValue end, set = function(v) SetSliderValue(v, true); cb(v) end})
                UpdateSectionSize()
                return {SetValue = function(v) SetSliderValue(v) end, Flag = flag}
            end
            
            -- ============================================
            -- DROPDOWN
            -- ============================================
            function Elements:AddDropdown(name, options, callback)
                callback = callback or function() end
                local opened = false
                local dropFrame = create("Frame", {Parent = SectionFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), BorderSizePixel = 0, ZIndex = 10})
                local dropList = create("UIListLayout", {Parent = dropFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
                local mainBtn = create("TextButton", {Parent = dropFrame, BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 26), AutoButtonColor = false, Font = FONT.Body, Text = "  " .. name, TextColor3 = ActiveTheme.Text, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0, ZIndex = 10})
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = mainBtn})
                create("UIStroke", {Parent = mainBtn, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 0.8})
                local arrow = create("TextLabel", {Parent = mainBtn, BackgroundTransparency = 1, Position = UDim2.new(0.85, 0, 0, 0), Size = UDim2.new(0, 18, 1, 0), Font = FONT.Body, Text = "▾", TextColor3 = ActiveTheme.Accent, TextSize = 10, ZIndex = 11})
                
                local optFrames = {}
                for _, opt in ipairs(options) do
                    local optBtn = create("TextButton", {Parent = dropFrame, BackgroundColor3 = ActiveTheme.InputBg, Size = UDim2.new(1, 0, 0, 24), AutoButtonColor = false, Font = FONT.Text, Text = "   " .. opt, TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, Visible = false, BorderSizePixel = 0, ZIndex = 12})
                    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = optBtn})
                    optBtn.MouseEnter:Connect(function() Tween(optBtn, {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = Color3.fromRGB(50, 15, 70)}, 0.1) end)
                    optBtn.MouseLeave:Connect(function() Tween(optBtn, {TextColor3 = ActiveTheme.Text, BackgroundColor3 = ActiveTheme.InputBg}, 0.1) end)
                    optBtn.MouseButton1Click:Connect(function()
                        mainBtn.Text = "  " .. opt; callback(opt)
                        InternalNotify(name .. ": " .. opt, "info")
                        opened = false; arrow.Rotation = 0
                        for _, o in ipairs(optFrames) do o.Visible = false end
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 26)}, 0.15)
                        UpdateSectionSize()
                    end)
                    table.insert(optFrames, optBtn)
                end
                mainBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then arrow.Rotation = 180; for _, o in ipairs(optFrames) do o.Visible = true end; Tween(dropFrame, {Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y)}, 0.15)
                    else arrow.Rotation = 0; Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 26)}, 0.15); task.wait(0.15); for _, o in ipairs(optFrames) do o.Visible = false end end
                    UpdateSectionSize()
                end)
                UpdateSectionSize()
                return {Refresh = function(newOpts)
                    for _, o in ipairs(optFrames) do o:Destroy() end; optFrames = {}
                    for _, opt in ipairs(newOpts) do
                        local o = create("TextButton", {Parent = dropFrame, BackgroundColor3 = ActiveTheme.InputBg, Size = UDim2.new(1, 0, 0, 24), AutoButtonColor = false, Font = FONT.Text, Text = "   " .. opt, TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, Visible = opened, BorderSizePixel = 0, ZIndex = 12})
                        create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = o})
                        o.MouseButton1Click:Connect(function() mainBtn.Text = "  " .. opt; callback(opt); opened = false; arrow.Rotation = 0; for _, o2 in ipairs(optFrames) do o2.Visible = false end; Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 26)}, 0.15); UpdateSectionSize() end)
                        table.insert(optFrames, o)
                    end
                    if opened then dropFrame.Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y) end
                    UpdateSectionSize()
                end}
            end
            
            -- ============================================
            -- MULTI DROPDOWN
            -- ============================================
            function Elements:AddMultiDropdown(name, options, callback)
                callback = callback or function() end
                local selected = {}
                for _, opt in ipairs(options) do selected[opt] = false end
                local opened = false
                
                local dropFrame = create("Frame", {Parent = SectionFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 26), BorderSizePixel = 0, ZIndex = 10})
                local dropList = create("UIListLayout", {Parent = dropFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
                local mainBtn = create("TextButton", {Parent = dropFrame, BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 26), AutoButtonColor = false, Font = FONT.Body, Text = "  " .. name, TextColor3 = ActiveTheme.Text, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0, ZIndex = 10})
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = mainBtn})
                create("UIStroke", {Parent = mainBtn, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 0.8})
                local arrow = create("TextLabel", {Parent = mainBtn, BackgroundTransparency = 1, Position = UDim2.new(0.85, 0, 0, 0), Size = UDim2.new(0, 18, 1, 0), Font = FONT.Body, Text = "▾", TextColor3 = ActiveTheme.Accent, TextSize = 10, ZIndex = 11})
                
                local function UpdateDisplay()
                    local count = 0; for _, v in pairs(selected) do if v then count = count + 1 end end
                    mainBtn.Text = "  " .. name .. (count > 0 and " (" .. count .. ")" or "")
                end
                
                local optFrames = {}
                for _, opt in ipairs(options) do
                    local optBtn = create("TextButton", {Parent = dropFrame, BackgroundColor3 = ActiveTheme.InputBg, Size = UDim2.new(1, 0, 0, 24), AutoButtonColor = false, Font = FONT.Text, Text = "   " .. opt, TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, Visible = false, BorderSizePixel = 0, ZIndex = 12})
                    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = optBtn})
                    local checkIcon = create("TextLabel", {Parent = optBtn, BackgroundTransparency = 1, Position = UDim2.new(0.88, 0, 0, 0), Size = UDim2.new(0, 18, 1, 0), Font = FONT.Body, Text = "", TextColor3 = ActiveTheme.Accent, TextSize = 10, ZIndex = 13})
                    
                    optBtn.MouseButton1Click:Connect(function()
                        selected[opt] = not selected[opt]
                        checkIcon.Text = selected[opt] and "✓" or ""
                        UpdateDisplay()
                        callback(selected)
                    end)
                    table.insert(optFrames, optBtn)
                end
                mainBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then arrow.Rotation = 180; for _, o in ipairs(optFrames) do o.Visible = true end; Tween(dropFrame, {Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y)}, 0.15)
                    else arrow.Rotation = 0; Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 26)}, 0.15); task.wait(0.15); for _, o in ipairs(optFrames) do o.Visible = false end end
                    UpdateSectionSize()
                end)
                UpdateSectionSize()
            end
            
            -- ============================================
            -- KEYBIND
            -- ============================================
            function Elements:AddKeybind(name, defaultKey, callback)
                local currentKey = defaultKey or Enum.KeyCode.E
                local listening = false
                local btn = CreateElement()
                elementCounter = elementCounter + 1
                local elementId = "keybind_" .. elementCounter
                
                create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.5, 0, 1, 0), Font = FONT.Body, Text = name, TextColor3 = ActiveTheme.Text, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left})
                local keyLabel = create("TextButton", {Parent = btn, BackgroundColor3 = ActiveTheme.Secondary or ActiveTheme.Accent, BackgroundTransparency = 0.3, Position = UDim2.new(0.7, 0, 0.5, -10), Size = UDim2.new(0, 50, 0, 20), Font = FONT.Header, Text = currentKey.Name, TextColor3 = ActiveTheme.Text, TextSize = 9, AutoButtonColor = false, BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = keyLabel})
                
                local bindConnection
                local function SetBind(newKey)
                    currentKey = newKey; keyLabel.Text = newKey.Name
                    if bindConnection then bindConnection:Disconnect() end
                    bindConnection = UserInputService.InputBegan:Connect(function(inp, gpe)
                        if gpe then return end
                        if inp.KeyCode == currentKey and not listening then callback() end
                    end)
                end
                keyLabel.MouseButton1Click:Connect(function()
                    listening = true; keyLabel.Text = "..."
                    local conn = UserInputService.InputBegan:Connect(function(inp, gpe)
                        if gpe then return end
                        if listening and inp.KeyCode ~= Enum.KeyCode.Unknown and inp.KeyCode ~= Enum.KeyCode.RightShift then
                            SetBind(inp.KeyCode); listening = false; conn:Disconnect()
                        end
                    end)
                end)
                SetBind(currentKey)
                UpdateSectionSize()
                return {GetKey = function() return currentKey end, SetKey = function(k) SetBind(k) end}
            end
            
            -- ============================================
            -- COLOR PICKER
            -- ============================================
            function Elements:AddColorPicker(name, defaultColor, callback)
                defaultColor = defaultColor or Color3.fromRGB(255, 0, 255)
                local currentColor = defaultColor
                local btn = CreateElement(80)
                elementCounter = elementCounter + 1
                local elementId = "color_" .. elementCounter
                
                create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0.04, 0), Size = UDim2.new(0.5, 0, 0, 14), Font = FONT.Body, Text = name, TextColor3 = ActiveTheme.Text, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left})
                local colorPreview = create("Frame", {Parent = btn, BackgroundColor3 = currentColor, Position = UDim2.new(0.7, 0, 0.04, 0), Size = UDim2.new(0, 30, 0, 14), BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = colorPreview})
                
                -- RGB sliders
                local rSlider = create("Frame", {Parent = btn, BackgroundColor3 = Color3.fromRGB(40, 15, 60), BorderSizePixel = 0, Position = UDim2.new(0.06, 0, 0.28, 0), Size = UDim2.new(0.88, 0, 0, 3)})
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = rSlider})
                local rFill = create("Frame", {Parent = rSlider, BackgroundColor3 = Color3.fromRGB(255, 0, 0), BorderSizePixel = 0, Size = UDim2.new(currentColor.R * 255 / 255, 0, 1, 0)})
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = rFill})
                
                local gSlider = create("Frame", {Parent = btn, BackgroundColor3 = Color3.fromRGB(40, 15, 60), BorderSizePixel = 0, Position = UDim2.new(0.06, 0, 0.48, 0), Size = UDim2.new(0.88, 0, 0, 3)})
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = gSlider})
                local gFill = create("Frame", {Parent = gSlider, BackgroundColor3 = Color3.fromRGB(0, 255, 0), BorderSizePixel = 0, Size = UDim2.new(currentColor.G * 255 / 255, 0, 1, 0)})
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = gFill})
                
                local bSlider = create("Frame", {Parent = btn, BackgroundColor3 = Color3.fromRGB(40, 15, 60), BorderSizePixel = 0, Position = UDim2.new(0.06, 0, 0.68, 0), Size = UDim2.new(0.88, 0, 0, 3)})
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = bSlider})
                local bFill = create("Frame", {Parent = bSlider, BackgroundColor3 = Color3.fromRGB(0, 0, 255), BorderSizePixel = 0, Size = UDim2.new(currentColor.B * 255 / 255, 0, 1, 0)})
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = bFill})
                
                local function UpdateColor()
                    currentColor = Color3.fromRGB(rFill.AbsoluteSize.X / rSlider.AbsoluteSize.X, gFill.AbsoluteSize.X / gSlider.AbsoluteSize.X, bFill.AbsoluteSize.X / bSlider.AbsoluteSize.X)
                    colorPreview.BackgroundColor3 = currentColor
                    callback(currentColor)
                end
                
                local function MakeSliderDraggable(slider, fill)
                    local mouse = Players.LocalPlayer:GetMouse()
                    local dragging = false
                    slider.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = true end
                    end)
                    UserInputService.InputChanged:Connect(function(inp)
                        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                            local relX = math.clamp(inp.Position.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
                            fill.Size = UDim2.new(relX / slider.AbsoluteSize.X, 0, 1, 0)
                            UpdateColor()
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
                    end)
                end
                
                MakeSliderDraggable(rSlider, rFill)
                MakeSliderDraggable(gSlider, gFill)
                MakeSliderDraggable(bSlider, bFill)
                
                table.insert(allElements, {id = elementId, get = function() return currentColor end, set = function(v) currentColor = v; colorPreview.BackgroundColor3 = v; rFill.Size = UDim2.new(v.R, 0, 1, 0); gFill.Size = UDim2.new(v.G, 0, 1, 0); bFill.Size = UDim2.new(v.B, 0, 1, 0); callback(v) end})
                UpdateSectionSize()
                return {GetColor = function() return currentColor end, SetColor = function(c) currentColor = c; colorPreview.BackgroundColor3 = c; rFill.Size = UDim2.new(c.R, 0, 1, 0); gFill.Size = UDim2.new(c.G, 0, 1, 0); bFill.Size = UDim2.new(c.B, 0, 1, 0); callback(c) end}
            end
            
            -- ============================================
            -- DEPENDENCY SYSTEM
            -- ============================================
            function Elements:DependsOn(element)
                local el = CreateElement()
                el.BackgroundTransparency = 1
                el.UIStroke:Destroy()
                el.MouseEnter:Connect(function() end)
                el.MouseLeave:Connect(function() end)
                return el
            end
            
            -- TEXTBOX
            function Elements:AddTextBox(name, default, callback)
                default = default or ""
                local btn = CreateElement()
                create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.3, 0, 1, 0), Font = FONT.Body, Text = name, TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left})
                local textBox = create("TextBox", {Parent = btn, BackgroundColor3 = ActiveTheme.InputBg, Position = UDim2.new(0.38, 0, 0.5, -9), Size = UDim2.new(0.56, 0, 0, 18), Font = FONT.Text, Text = default, TextColor3 = ActiveTheme.Text, PlaceholderColor3 = ActiveTheme.TextMuted, TextSize = 9, ClearTextOnFocus = false, BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = textBox})
                create("UIStroke", {Parent = textBox, Color = ActiveTheme.Border, Transparency = 0.4, Thickness = 1})
                textBox.FocusLost:Connect(function(ep) if ep then callback(textBox.Text) end end)
                UpdateSectionSize()
                return {GetText = function() return textBox.Text end, SetText = function(t) textBox.Text = t end}
            end
            
            -- BUTTON
            function Elements:AddButton(name, callback)
                local btn = CreateElement()
                create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.76, 0, 1, 0), Font = FONT.Body, Text = name, TextColor3 = ActiveTheme.Text, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left})
                create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.85, 0, 0, 0), Size = UDim2.new(0, 16, 1, 0), Font = FONT.Header, Text = "→", TextColor3 = ActiveTheme.Accent, TextSize = 12})
                btn.MouseButton1Click:Connect(function() Tween(btn, {BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0}, 0.05); task.wait(0.08); Tween(btn, {BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.2}, 0.15); callback() end)
                UpdateSectionSize()
                return {SetText = function(t) btn.TextLabel.Text = t end}
            end
            
            -- LABEL
            function Elements:AddLabel(text)
                local lbl = create("Frame", {Parent = SectionFrame, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.75, Size = UDim2.new(1, 0, 0, 18), BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = lbl})
                create("TextLabel", {Parent = lbl, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.94, 0, 1, 0), Font = FONT.Header, Text = "  " .. text, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left})
                UpdateSectionSize()
                table.insert(allSearchable, {element = lbl, parent = SectionFrame, name = text})
                return {SetText = function(t) lbl.TextLabel.Text = "  " .. t end}
            end
            
            return Elements
        end
        return Sections
    end
    
    -- ============================================
    -- LOCAL TAB
    -- ============================================
    local LocalTab = Tabs:CreateTab("Local", "📋")
    local LocalSection = LocalTab:AddSection("Player Info")
    local player = Players.LocalPlayer
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    for _, pair in ipairs({
        {"👤 Username", player.Name},
        {"🆔 UserId", player.UserId},
        {"📅 Account Age", player.AccountAge .. " days"},
        {"🎮 Game", pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end) or "Unknown"},
        {"📍 Place ID", game.PlaceId},
        {"🖥️ Job ID", game.JobId},
        {"⚡ Ping", tostring(math.floor(Stats.PerformanceStats.Ping:GetValue())) .. "ms"},
        {"⏰ Time", os.date("%H:%M:%S")},
        {"🏃 WalkSpeed", hum and tostring(hum.WalkSpeed) or "N/A"},
        {"🦘 JumpPower", hum and tostring(hum.JumpPower) or "N/A"},
        {"❤️ Health", hum and tostring(math.floor(hum.Health)) or "N/A"},
        {"🔧 Executor", (identifyexecutor and identifyexecutor()) or "Unknown"},
    }) do LocalSection:AddLabel(pair[1] .. ": " .. tostring(pair[2])) end
    
    -- ============================================
    -- WATERMARK SYSTEM
    -- ============================================
    local WatermarkFrame = create("Frame", {
        Parent = ScreenGui, BackgroundColor3 = ActiveTheme.ContainerBg,
        BackgroundTransparency = 0.3, Position = UDim2.new(0.01, 0, 0.01, 0),
        Size = UDim2.new(0, 200, 0, 22), BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = WatermarkFrame})
    create("UIStroke", {Parent = WatermarkFrame, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1})
    local WatermarkLabel = create("TextLabel", {
        Parent = WatermarkFrame, BackgroundTransparency = 1,
        Position = UDim2.new(0.04, 0, 0, 0), Size = UDim2.new(0.92, 0, 1, 0),
        Font = FONT.Body, Text = title .. " | " .. ActiveThemeName,
        TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    function Library:SetWatermark(data)
        WatermarkLabel.Text = data.Text or WatermarkLabel.Text
    end
    
    -- Update FPS in watermark
    coroutine.wrap(function()
        while ScreenGui and ScreenGui.Parent do
            local fps = math.floor(1 / (RunService.RenderStepped:Wait() or 0.016))
            WatermarkLabel.Text = title .. " | " .. fps .. " FPS | " .. ActiveThemeName
        end
    end)()
    
    -- ============================================
    -- WINDOW MANAGEMENT
    -- ============================================
    function Library:SetSize(w, h)
        Tween(Main, {Size = UDim2.new(0, w, 0, h)}, 0.2)
    end
    function Library:SetPosition(x, y)
        Main.Position = UDim2.new(0, x, 0, y)
    end
    function Library:Center()
        Main.Position = UDim2.new(0.5, -Main.AbsoluteSize.X/2, 0.5, -Main.AbsoluteSize.Y/2)
    end
    
    -- Expose flags
    Library.Flags = Flags
    
    return Tabs
end

return Library
