-- ============================================
-- 🌴 PALMTREE.LUA v3.1 - Miami Sunset Edition
-- Mobile Optimized + Dynamic Gradient
-- ============================================

local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Miami Sunset Color Palette
local Colors = {
    NeonPink = Color3.fromRGB(255, 42, 133),
    NeonCyan = Color3.fromRGB(0, 229, 255),
    Purple = Color3.fromRGB(140, 80, 220),
    SoftPurple = Color3.fromRGB(100, 60, 180),
    
    White = Color3.fromRGB(255, 255, 255),
    TextPrimary = Color3.fromRGB(240, 240, 250),
    TextSecondary = Color3.fromRGB(160, 160, 180),
    TextMuted = Color3.fromRGB(120, 120, 140),
    
    ToggleOff = Color3.fromRGB(50, 50, 65),
    SliderTrack = Color3.fromRGB(40, 40, 55),
    InputBg = Color3.fromRGB(30, 30, 45),
    ContainerBg = Color3.fromRGB(18, 18, 30),
    CardBg = Color3.fromRGB(22, 22, 36),
    
    Green = Color3.fromRGB(70, 230, 120),
    Gold = Color3.fromRGB(255, 200, 50),
}

-- Dynamic gradient colors
local GradientColors = {
    {Color3.fromRGB(13, 13, 35), Color3.fromRGB(20, 10, 35)},  -- Deep purple/navy
    {Color3.fromRGB(10, 15, 30), Color3.fromRGB(25, 10, 30)},  -- Dark blue/pink hint
    {Color3.fromRGB(15, 10, 30), Color3.fromRGB(20, 15, 40)},  -- Purple shift
    {Color3.fromRGB(10, 15, 35), Color3.fromRGB(30, 10, 35)},  -- Cyan hint
    {Color3.fromRGB(20, 10, 30), Color3.fromRGB(10, 20, 35)},  -- Blue shift
    {Color3.fromRGB(15, 10, 35), Color3.fromRGB(25, 10, 25)},  -- Pink shift
    {Color3.fromRGB(10, 12, 35), Color3.fromRGB(22, 8, 32)},   -- Back to start
}

local FONT_TITLE = Enum.Font.GothamBlack
local FONT_HEADER = Enum.Font.GothamBold
local FONT_BODY = Enum.Font.GothamSemibold
local FONT_TEXT = Enum.Font.Gotham
local FONT_MONO = Enum.Font.RobotoMono
local FONT_SCRIPT = Enum.Font.FredokaOne

local function create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

local function Tween(obj, props, duration, easing)
    easing = easing or Enum.EasingStyle.Quart
    duration = duration or 0.2
    return TweenService:Create(obj, TweenInfo.new(duration, easing, Enum.EasingDirection.Out), props):Play()
end

-- Glass container
local function CreateGlassContainer(parent, size, position)
    local container = create("Frame", {
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.92,
        Size = size,
        Position = position,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })
    
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = container})
    
    create("UIStroke", {
        Parent = container,
        Color = Colors.Purple,
        Transparency = 0.3,
        Thickness = 1,
    })
    
    return container
end

-- Mobile + PC Drag
local function MakeDraggable(gui, dragPart)
    local dragging, startPos, startMouse, input
    
    dragPart.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or 
           inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = gui.Position
            startMouse = inp.Position
            input = inp
            
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(inp)
        if inp == input and dragging then
            local delta = inp.Position - startMouse
            gui.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function Library:CreateWindow(title)
    title = title or "PalmTree.lua"
    
    local uiName = "PalmTree_" .. HttpService:GenerateGUID(false):sub(1, 8)
    
    if CoreGui:FindFirstChild(uiName) then
        CoreGui[uiName]:Destroy()
    end
    
    local ScreenGui = create("ScreenGui", {
        Name = uiName,
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        Enabled = true,
    })
    
    -- ===== MAIN WINDOW (Smaller for mobile) =====
    local Main = create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = GradientColors[1][1],
        Position = UDim2.new(0.5, -230, 0.5, -160),
        Size = UDim2.new(0, 460, 0, 320),
        ClipsDescendants = true,
        BorderSizePixel = 0,
    })
    
    create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    
    create("UIStroke", {
        Parent = Main,
        Color = Colors.NeonPink,
        Transparency = 0.6,
        Thickness = 1,
    })
    
    -- ===== DYNAMIC GRADIENT ANIMATION =====
    local gradientFrame = create("Frame", {
        Parent = Main,
        BackgroundColor3 = GradientColors[1][2],
        BackgroundTransparency = 0.3,
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0,
        ZIndex = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = gradientFrame})
    
    -- Animate gradient colors
    local colorIndex = 1
    local colorAlpha = 0
    
    coroutine.wrap(function()
        while ScreenGui and ScreenGui.Parent do
            local current = GradientColors[colorIndex]
            local next = GradientColors[colorIndex % #GradientColors + 1]
            
            colorAlpha = colorAlpha + 0.008
            if colorAlpha >= 1 then
                colorAlpha = 0
                colorIndex = colorIndex % #GradientColors + 1
            end
            
            local lerped1 = current[1]:Lerp(next[1], colorAlpha)
            local lerped2 = current[2]:Lerp(next[2], colorAlpha)
            
            Main.BackgroundColor3 = lerped1
            gradientFrame.BackgroundColor3 = lerped2
            
            RunService.Heartbeat:Wait()
        end
    end)()
    
    -- ===== HEADER =====
    local Header = create("Frame", {
        Name = "Header",
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(10, 10, 18),
        BackgroundTransparency = 0.3,
        Size = UDim2.new(1, 0, 0, 35),
        BorderSizePixel = 0,
    })
    
    create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Header})
    
    local HeaderCover = create("Frame", {
        Parent = Header,
        BackgroundColor3 = Color3.fromRGB(10, 10, 18),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0),
    })
    
    -- Logo
    create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.03, 0, 0, 0),
        Size = UDim2.new(0, 20, 1, 0),
        Font = FONT_BODY,
        Text = "🌴",
        TextSize = 14,
    })
    
    create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.1, 0, 0, 0),
        Size = UDim2.new(0.4, 0, 0.5, 0),
        Font = FONT_SCRIPT,
        Text = title,
        TextColor3 = Colors.White,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.1, 0, 0.5, 0),
        Size = UDim2.new(0.3, 0, 0.4, 0),
        Font = FONT_TEXT,
        Text = "Miami Sunset",
        TextColor3 = Colors.NeonPink,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Minimize button (instead of close)
    local MinBtn = create("TextButton", {
        Parent = Header,
        BackgroundColor3 = Colors.NeonCyan,
        BackgroundTransparency = 0.85,
        Position = UDim2.new(0.9, 0, 0.2, 0),
        Size = UDim2.new(0, 24, 0, 24),
        Font = FONT_HEADER,
        Text = "−",
        TextColor3 = Colors.White,
        TextSize = 18,
        BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = MinBtn})
    
    MinBtn.MouseEnter:Connect(function()
        Tween(MinBtn, {BackgroundTransparency = 0.5}, 0.15)
    end)
    MinBtn.MouseLeave:Connect(function()
        Tween(MinBtn, {BackgroundTransparency = 0.85}, 0.15)
    end)
    
    -- Toggle minimize/maximize
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            -- Hide content, keep header
            for _, child in ipairs(Main:GetChildren()) do
                if child ~= Header and child ~= gradientFrame then
                    child.Visible = false
                end
            end
            Tween(Main, {Size = UDim2.new(0, 460, 0, 35)}, 0.2)
            MinBtn.Text = "+"
        else
            -- Show content
            for _, child in ipairs(Main:GetChildren()) do
                child.Visible = true
            end
            Tween(Main, {Size = UDim2.new(0, 460, 0, 320)}, 0.2)
            MinBtn.Text = "−"
        end
    end)
    
    MakeDraggable(Main, Header)
    
    -- ===== LEFT SIDEBAR =====
    local LeftSidebar = CreateGlassContainer(Main, 
        UDim2.new(0, 120, 0, 285), 
        UDim2.new(0, 0, 0.109, 0))
    
    create("UIListLayout", {
        Parent = LeftSidebar,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
    })
    
    create("UIPadding", {
        Parent = LeftSidebar,
        PaddingTop = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
    })
    
    -- ===== CENTER PANEL =====
    local CenterPanel = CreateGlassContainer(Main,
        UDim2.new(0, 210, 0, 285),
        UDim2.new(0.275, 0, 0.109, 0))
    
    create("UIPadding", {
        Parent = CenterPanel,
        PaddingTop = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
    })
    
    -- Center title
    local CenterTitleFrame = create("Frame", {
        Parent = CenterPanel,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 24),
        BorderSizePixel = 0,
    })
    
    local CenterIcon = create("TextLabel", {
        Parent = CenterTitleFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 1, 0),
        Font = FONT_BODY,
        Text = "⚔️",
        TextSize = 13,
    })
    
    local CenterTitle = create("TextLabel", {
        Parent = CenterTitleFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.12, 0, 0, 0),
        Size = UDim2.new(0.5, 0, 0.5, 0),
        Font = FONT_HEADER,
        Text = "Combat",
        TextColor3 = Colors.White,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    create("TextLabel", {
        Parent = CenterTitleFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.12, 0, 0.5, 0),
        Size = UDim2.new(0.8, 0, 0.5, 0),
        Font = FONT_TEXT,
        Text = "Aimbot, Silent Aim & more",
        TextColor3 = Colors.TextSecondary,
        TextSize = 8,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Center content
    local CenterContent = create("Frame", {
        Parent = CenterPanel,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.12, 0),
        Size = UDim2.new(1, 0, 0.88, 0),
        BorderSizePixel = 0,
    })
    
    create("UIListLayout", {
        Parent = CenterContent,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 3),
    })
    
    -- ===== RIGHT SIDEBAR =====
    local RightSidebar = CreateGlassContainer(Main,
        UDim2.new(0, 120, 0, 285),
        UDim2.new(0.74, 0, 0.109, 0))
    
    create("UIPadding", {
        Parent = RightSidebar,
        PaddingTop = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
    })
    
    create("UIListLayout", {
        Parent = RightSidebar,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
    })
    
    -- ===== KEYBIND TOGGLE (Proper open/close) =====
    UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == Enum.KeyCode.RightShift then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    -- ===== TAB SYSTEM =====
    local Tabs = {}
    local navButtons = {}
    
    function Tabs:CreateTab(name, icon)
        icon = icon or ""
        
        -- Nav button
        local NavBtn = create("TextButton", {
            Parent = LeftSidebar,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 26),
            Font = FONT_BODY,
            RichText = true,
            Text = icon .. " " .. name,
            TextColor3 = Colors.TextSecondary,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            BorderSizePixel = 0,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = NavBtn})
        
        -- Center page
        local Page = create("Frame", {
            Parent = CenterContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            BorderSizePixel = 0,
        })
        
        create("UIListLayout", {
            Parent = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 3),
        })
        
        table.insert(navButtons, {btn = NavBtn, page = Page, name = name, icon = icon})
        
        NavBtn.MouseButton1Click:Connect(function()
            CenterTitle.Text = name
            CenterIcon.Text = icon
            
            for _, nav in ipairs(navButtons) do
                nav.page.Visible = false
                Tween(nav.btn, {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    TextColor3 = Colors.TextSecondary,
                }, 0.15)
            end
            
            Page.Visible = true
            Tween(NavBtn, {
                BackgroundColor3 = Colors.NeonPink,
                BackgroundTransparency = 0,
                TextColor3 = Colors.White,
            }, 0.15)
        end)
        
        -- Auto-select first
        if #navButtons == 1 then
            Page.Visible = true
            Tween(NavBtn, {
                BackgroundColor3 = Colors.NeonPink,
                BackgroundTransparency = 0,
                TextColor3 = Colors.White,
            }, 0)
            CenterTitle.Text = name
            CenterIcon.Text = icon
        end
        
        -- ===== SECTIONS =====
        local Sections = {}
        
        function Sections:AddSection(name)
            local SectionFrame = create("Frame", {
                Parent = Page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                BorderSizePixel = 0,
            })
            
            local SectionList = create("UIListLayout", {
                Parent = SectionFrame,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2),
            })
            
            -- Section header
            local SectionHeader = create("Frame", {
                Parent = SectionFrame,
                BackgroundColor3 = Colors.NeonPink,
                BackgroundTransparency = 0.85,
                Size = UDim2.new(1, 0, 0, 22),
                BorderSizePixel = 0,
            })
            create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = SectionHeader})
            
            create("TextLabel", {
                Parent = SectionHeader,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.05, 0, 0, 0),
                Size = UDim2.new(0.95, 0, 1, 0),
                Font = FONT_HEADER,
                Text = name,
                TextColor3 = Colors.White,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            local function UpdateSectionSize()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
            end
            SectionFrame.ChildAdded:Connect(UpdateSectionSize)
            SectionFrame.ChildRemoved:Connect(UpdateSectionSize)
            
            local Elements = {}
            
            local function CreateElement(height)
                height = height or 28
                local el = create("TextButton", {
                    Parent = SectionFrame,
                    BackgroundColor3 = Colors.ContainerBg,
                    Size = UDim2.new(1, 0, 0, height),
                    AutoButtonColor = false,
                    Text = "",
                    BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = el})
                
                el.MouseEnter:Connect(function()
                    Tween(el, {BackgroundColor3 = Colors.CardBg}, 0.1)
                end)
                el.MouseLeave:Connect(function()
                    Tween(el, {BackgroundColor3 = Colors.ContainerBg}, 0.1)
                end)
                
                return el
            end
            
            -- ===== TOGGLE =====
            function Elements:AddToggle(name, default, callback)
                default = default or false
                local toggled = default
                
                local btn = CreateElement()
                
                create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0),
                    Size = UDim2.new(0.65, 0, 1, 0),
                    Font = FONT_TEXT,
                    Text = name,
                    TextColor3 = Colors.TextPrimary,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local track = create("Frame", {
                    Parent = btn,
                    BackgroundColor3 = Colors.ToggleOff,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.8, 0, 0.5, -7),
                    Size = UDim2.new(0, 30, 0, 14),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})
                
                local dot = create("Frame", {
                    Parent = track,
                    BackgroundColor3 = Colors.White,
                    BorderSizePixel = 0,
                    Position = default and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5),
                    Size = UDim2.new(0, 10, 0, 10),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                
                local function SetToggle(state, instant)
                    toggled = state
                    local pos = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
                    local trackColor = state and Colors.NeonPink or Colors.ToggleOff
                    
                    if instant then
                        dot.Position = pos
                        track.BackgroundColor3 = trackColor
                    else
                        Tween(dot, {Position = pos}, 0.2, Enum.EasingStyle.Back)
                        Tween(track, {BackgroundColor3 = trackColor}, 0.15)
                    end
                end
                
                if default then SetToggle(true, true) end
                
                btn.MouseButton1Click:Connect(function()
                    SetToggle(not toggled)
                    callback(toggled)
                end)
                
                UpdateSectionSize()
                return {SetState = function(s) SetToggle(s) end}
            end
            
            -- ===== SLIDER =====
            function Elements:AddSlider(name, min, max, default, callback)
                min = min or 0
                max = max or 100
                default = math.clamp(default or min, min, max)
                
                local btn = CreateElement(40)
                
                create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0.05, 0),
                    Size = UDim2.new(0.5, 0, 0, 14),
                    Font = FONT_TEXT,
                    Text = name,
                    TextColor3 = Colors.TextPrimary,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local valBox = create("Frame", {
                    Parent = btn,
                    BackgroundColor3 = Colors.InputBg,
                    Position = UDim2.new(0.75, 0, 0.05, 0),
                    Size = UDim2.new(0, 32, 0, 14),
                    BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = valBox})
                
                local valLabel = create("TextLabel", {
                    Parent = valBox,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = FONT_MONO,
                    Text = tostring(default),
                    TextColor3 = Colors.NeonPink,
                    TextSize = 9,
                })
                
                local track = create("Frame", {
                    Parent = btn,
                    BackgroundColor3 = Colors.SliderTrack,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.06, 0, 0.6, 0),
                    Size = UDim2.new(0.88, 0, 0, 3),
                })
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = track})
                
                local percent = (default - min) / (max - min)
                local fill = create("Frame", {
                    Parent = track,
                    BackgroundColor3 = Colors.NeonPink,
                    BorderSizePixel = 0,
                    Size = UDim2.new(percent, 0, 1, 0),
                })
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = fill})
                
                local dot = create("Frame", {
                    Parent = fill,
                    BackgroundColor3 = Colors.White,
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.new(0, 10, 0, 10),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                
                create("UIStroke", {
                    Parent = dot,
                    Color = Colors.NeonPink,
                    Thickness = 1.5,
                })
                
                local player = Players.LocalPlayer
                local mouse = player:GetMouse()
                local dragging = false
                
                local function UpdateValue(inputX)
                    local relX = math.clamp(inputX - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                    local p = relX / track.AbsoluteSize.X
                    local val = math.floor(min + (max - min) * p)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    valLabel.Text = tostring(val)
                    callback(val)
                end
                
                track.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or 
                       inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        UpdateValue(inp.Position.X)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(inp)
                    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or 
                       inp.UserInputType == Enum.UserInputType.Touch) then
                        UpdateValue(inp.Position.X)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or 
                       inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                
                UpdateSectionSize()
                return {
                    SetValue = function(v)
                        v = math.clamp(v, min, max)
                        fill.Size = UDim2.new((v - min) / (max - min), 0, 1, 0)
                        valLabel.Text = tostring(v)
                    end
                }
            end
            
            -- ===== DROPDOWN =====
            function Elements:AddDropdown(name, options, callback)
                callback = callback or function() end
                local opened = false
                
                local dropFrame = create("Frame", {
                    Parent = SectionFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 28),
                    BorderSizePixel = 0,
                })
                
                create("UIListLayout", {
                    Parent = dropFrame,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2),
                })
                
                local mainBtn = create("TextButton", {
                    Parent = dropFrame,
                    BackgroundColor3 = Colors.ContainerBg,
                    Size = UDim2.new(1, 0, 0, 28),
                    AutoButtonColor = false,
                    Font = FONT_TEXT,
                    Text = "  " .. name,
                    TextColor3 = Colors.TextPrimary,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = mainBtn})
                
                local arrow = create("TextLabel", {
                    Parent = mainBtn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.86, 0, 0, 0),
                    Size = UDim2.new(0, 20, 1, 0),
                    Font = FONT_TEXT,
                    Text = "▾",
                    TextColor3 = Colors.NeonPink,
                    TextSize = 10,
                })
                
                local optionFrames = {}
                
                local function CreateOption(option)
                    local optBtn = create("TextButton", {
                        Parent = dropFrame,
                        BackgroundColor3 = Colors.InputBg,
                        Size = UDim2.new(1, 0, 0, 26),
                        AutoButtonColor = false,
                        Font = FONT_TEXT,
                        Text = "   " .. option,
                        TextColor3 = Colors.TextSecondary,
                        TextSize = 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Visible = false,
                        BorderSizePixel = 0,
                    })
                    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = optBtn})
                    
                    optBtn.MouseButton1Click:Connect(function()
                        mainBtn.Text = "  " .. option
                        callback(option)
                        opened = false
                        arrow.Rotation = 0
                        for _, o in ipairs(optionFrames) do o.Visible = false end
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 28)}, 0.15)
                        UpdateSectionSize()
                    end)
                    
                    return optBtn
                end
                
                for _, opt in ipairs(options) do
                    table.insert(optionFrames, CreateOption(opt))
                end
                
                mainBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        arrow.Rotation = 180
                        for _, o in ipairs(optionFrames) do o.Visible = true end
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, dropFrame.UIListLayout.AbsoluteContentSize.Y)}, 0.15)
                    else
                        arrow.Rotation = 0
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 28)}, 0.15)
                        task.wait(0.15)
                        for _, o in ipairs(optionFrames) do o.Visible = false end
                    end
                    UpdateSectionSize()
                end)
                
                UpdateSectionSize()
                return {
                    Refresh = function(newOpts)
                        for _, o in ipairs(optionFrames) do o:Destroy() end
                        optionFrames = {}
                        for _, opt in ipairs(newOpts) do
                            local o = CreateOption(opt)
                            if opened then o.Visible = true end
                            table.insert(optionFrames, o)
                        end
                        if opened then
                            dropFrame.Size = UDim2.new(1, 0, 0, dropFrame.UIListLayout.AbsoluteContentSize.Y)
                        end
                        UpdateSectionSize()
                    end
                }
            end
            
            -- ===== BUTTON =====
            function Elements:AddButton(name, callback)
                local btn = CreateElement()
                
                create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0),
                    Size = UDim2.new(0.78, 0, 1, 0),
                    Font = FONT_TEXT,
                    Text = name,
                    TextColor3 = Colors.TextPrimary,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.88, 0, 0, 0),
                    Size = UDim2.new(0, 16, 1, 0),
                    Font = FONT_BODY,
                    Text = "→",
                    TextColor3 = Colors.NeonPink,
                    TextSize = 12,
                })
                
                btn.MouseButton1Click:Connect(function()
                    Tween(btn, {BackgroundColor3 = Colors.NeonPink}, 0.06)
                    task.wait(0.06)
                    Tween(btn, {BackgroundColor3 = Colors.ContainerBg}, 0.15)
                    callback()
                end)
                
                UpdateSectionSize()
                return {SetText = function(t) btn.TextLabel.Text = t end}
            end
            
            -- ===== LABEL =====
            function Elements:AddLabel(text)
                local lbl = create("TextLabel", {
                    Parent = SectionFrame,
                    BackgroundColor3 = Colors.NeonPink,
                    BackgroundTransparency = 0.85,
                    Size = UDim2.new(1, 0, 0, 22),
                    Font = FONT_HEADER,
                    Text = "  " .. text,
                    TextColor3 = Colors.White,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = lbl})
                
                UpdateSectionSize()
                return {SetText = function(t) lbl.Text = "  " .. t end}
            end
            
            -- ===== NOTIFICATION =====
            function Elements:AddNotification(text, notifType)
                notifType = notifType or "info"
                local colors = {
                    success = Colors.Green,
                    info = Colors.SoftPurple,
                    warning = Colors.Gold,
                }
                
                local notif = create("Frame", {
                    Parent = RightSidebar,
                    BackgroundColor3 = Colors.ContainerBg,
                    Size = UDim2.new(1, 0, 0, 24),
                    BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = notif})
                
                create("Frame", {
                    Parent = notif,
                    BackgroundColor3 = colors[notifType] or Colors.NeonPink,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(0, 2, 1, 0),
                })
                
                local icon = notifType == "success" and "✓" or notifType == "warning" and "⚠" or "ℹ"
                
                create("TextLabel", {
                    Parent = notif,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0),
                    Size = UDim2.new(0, 14, 1, 0),
                    Font = FONT_BODY,
                    Text = icon,
                    TextColor3 = colors[notifType] or Colors.NeonPink,
                    TextSize = 10,
                })
                
                create("TextLabel", {
                    Parent = notif,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.2, 0, 0, 0),
                    Size = UDim2.new(0.76, 0, 1, 0),
                    Font = FONT_TEXT,
                    Text = text,
                    TextColor3 = Colors.TextSecondary,
                    TextSize = 8,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
            end
            
            return Elements
        end
        
        return Sections
    end
    
    return Tabs
end

return Library
