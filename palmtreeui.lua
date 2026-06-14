-- ============================================
-- 🌴 PALMTREE.LUA v3 - Miami Sunset Edition
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
    -- Backgrounds
    MainBg = Color3.fromRGB(13, 13, 22),
    SidebarBg = Color3.fromRGB(10, 10, 18),
    ContainerBg = Color3.fromRGB(18, 18, 30),
    CardBg = Color3.fromRGB(22, 22, 36),
    
    -- Accents
    NeonPink = Color3.fromRGB(255, 42, 133),
    NeonCyan = Color3.fromRGB(0, 229, 255),
    Purple = Color3.fromRGB(140, 80, 220),
    SoftPurple = Color3.fromRGB(100, 60, 180),
    
    -- Text
    White = Color3.fromRGB(255, 255, 255),
    TextPrimary = Color3.fromRGB(240, 240, 250),
    TextSecondary = Color3.fromRGB(160, 160, 180),
    TextMuted = Color3.fromRGB(120, 120, 140),
    
    -- UI Elements
    ToggleOff = Color3.fromRGB(50, 50, 65),
    ToggleOn = Color3.fromRGB(255, 42, 133),
    SliderTrack = Color3.fromRGB(40, 40, 55),
    SliderFill = Color3.fromRGB(255, 42, 133),
    InputBg = Color3.fromRGB(30, 30, 45),
    
    -- Status
    Green = Color3.fromRGB(70, 230, 120),
    Gold = Color3.fromRGB(255, 200, 50),
    
    -- Glass effect
    GlassBorder = Color3.fromRGB(140, 80, 220),
    GlassBg = Color3.fromRGB(255, 255, 255),
}

local GlassTransparency = 0.92
local GlassBorderTransparency = 0.3

-- Fonts (using built-in Roblox fonts that look clean)
local FONT_TITLE = Enum.Font.GothamBlack
local FONT_HEADER = Enum.Font.GothamBold
local FONT_BODY = Enum.Font.GothamSemibold
local FONT_TEXT = Enum.Font.Gotham
local FONT_MONO = Enum.Font.RobotoMono
local FONT_SCRIPT = Enum.Font.FredokaOne -- closest to script font

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

-- Glass container creator
local function CreateGlassContainer(parent, size, position)
    local container = create("Frame", {
        Parent = parent,
        BackgroundColor3 = Colors.GlassBg,
        BackgroundTransparency = GlassTransparency,
        Size = size,
        Position = position,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })
    
    local corner = create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = container})
    
    local border = create("UIStroke", {
        Parent = container,
        Color = Colors.GlassBorder,
        Transparency = GlassBorderTransparency,
        Thickness = 1.2,
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
    })
    
    -- Main window
    local Main = create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Colors.MainBg,
        Position = UDim2.new(0.2, 0, 0.1, 0),
        Size = UDim2.new(0, 750, 0, 480),
        ClipsDescendants = true,
        BorderSizePixel = 0,
    })
    
    local MainCorner = create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Main})
    
    local MainStroke = create("UIStroke", {
        Parent = Main,
        Color = Colors.NeonPink,
        Transparency = 0.7,
        Thickness = 1,
    })
    
    -- ===== HEADER =====
    local Header = create("Frame", {
        Name = "Header",
        Parent = Main,
        BackgroundColor3 = Colors.SidebarBg,
        Size = UDim2.new(1, 0, 0, 45),
        BorderSizePixel = 0,
    })
    
    local HeaderCorner = create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Header})
    local HeaderCover = create("Frame", {
        Parent = Header,
        BackgroundColor3 = Colors.SidebarBg,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0),
    })
    
    -- Logo
    local LogoIcon = create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.02, 0, 0, 0),
        Size = UDim2.new(0, 25, 1, 0),
        Font = FONT_BODY,
        Text = "🌴",
        TextSize = 18,
    })
    
    local LogoText = create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.07, 0, 0, 0),
        Size = UDim2.new(0.25, 0, 0.55, 0),
        Font = FONT_SCRIPT,
        Text = title,
        TextColor3 = Colors.White,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local Subline = create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.07, 0, 0.55, 0),
        Size = UDim2.new(0.15, 0, 0.4, 0),
        Font = FONT_TEXT,
        Text = "Miami Sunset",
        TextColor3 = Colors.NeonPink,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Close button
    local CloseBtn = create("TextButton", {
        Parent = Header,
        BackgroundColor3 = Colors.NeonPink,
        BackgroundTransparency = 0.9,
        Position = UDim2.new(0.95, 0, 0.2, 0),
        Size = UDim2.new(0, 28, 0, 28),
        Font = FONT_HEADER,
        Text = "×",
        TextColor3 = Colors.White,
        TextSize = 20,
        BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = CloseBtn})
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {BackgroundTransparency = 0.5}, 0.15)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {BackgroundTransparency = 0.9}, 0.15)
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    MakeDraggable(Main, Header)
    
    -- ===== LEFT SIDEBAR =====
    local LeftSidebar = CreateGlassContainer(Main, 
        UDim2.new(0, 150, 0, 435), 
        UDim2.new(0, 0, 0.094, 0))
    
    local NavList = create("UIListLayout", {
        Parent = LeftSidebar,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
    })
    
    local NavPadding = create("UIPadding", {
        Parent = LeftSidebar,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
    })
    
    -- ===== CENTER PANEL =====
    local CenterPanel = CreateGlassContainer(Main,
        UDim2.new(0, 370, 0, 435),
        UDim2.new(0.21, 0, 0.094, 0))
    
    local CenterPadding = create("UIPadding", {
        Parent = CenterPanel,
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 8),
    })
    
    -- Center title area
    local CenterTitleFrame = create("Frame", {
        Parent = CenterPanel,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        BorderSizePixel = 0,
    })
    
    local CenterIcon = create("TextLabel", {
        Parent = CenterTitleFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 25, 1, 0),
        Font = FONT_BODY,
        Text = "🎯",
        TextSize = 16,
    })
    
    local CenterTitle = create("TextLabel", {
        Parent = CenterTitleFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.08, 0, 0, 0),
        Size = UDim2.new(0.4, 0, 0.5, 0),
        Font = FONT_HEADER,
        Text = "Combat",
        TextColor3 = Colors.White,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local CenterSubtitle = create("TextLabel", {
        Parent = CenterTitleFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.08, 0, 0.5, 0),
        Size = UDim2.new(0.6, 0, 0.5, 0),
        Font = FONT_TEXT,
        Text = "Aimbot, Silent Aim, Triggerbot and more.",
        TextColor3 = Colors.TextSecondary,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Center content list
    local CenterContent = create("Frame", {
        Parent = CenterPanel,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.12, 0),
        Size = UDim2.new(1, 0, 0.85, 0),
        BorderSizePixel = 0,
    })
    
    local CenterList = create("UIListLayout", {
        Parent = CenterContent,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
    })
    
    -- ===== RIGHT SIDEBAR =====
    local RightSidebar = CreateGlassContainer(Main,
        UDim2.new(0, 220, 0, 435),
        UDim2.new(0.71, 0, 0.094, 0))
    
    local RightPadding = create("UIPadding", {
        Parent = RightSidebar,
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
    })
    
    local RightList = create("UIListLayout", {
        Parent = RightSidebar,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
    })
    
    -- ===== TOGGLE KEYBIND =====
    UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == Enum.KeyCode.RightShift then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    -- ===== TAB SYSTEM =====
    local Tabs = {}
    local CurrentTab = nil
    local navButtons = {}
    
    local navItems = {
        {name = "Combat", icon = "⚔️"},
        {name = "Visuals", icon = "👁️"},
        {name = "Player", icon = "🧑"},
        {name = "World", icon = "🌍"},
        {name = "Misc", icon = "🔧"},
        {name = "Themes", icon = "🎨"},
        {name = "Configs", icon = "📁"},
        {name = "Settings", icon = "⚙️"},
        {name = "Credits", icon = "💗"},
    }
    
    function Tabs:CreateTab(name, icon)
        icon = icon or ""
        
        -- Navigation button
        local NavBtn = create("TextButton", {
            Parent = LeftSidebar,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 32),
            Font = FONT_BODY,
            RichText = true,
            Text = icon .. "  " .. name,
            TextColor3 = Colors.TextSecondary,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            BorderSizePixel = 0,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = NavBtn})
        
        -- Center page
        local Page = create("Frame", {
            Parent = CenterContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            BorderSizePixel = 0,
        })
        
        local PageList = create("UIListLayout", {
            Parent = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4),
        })
        
        table.insert(navButtons, {btn = NavBtn, page = Page})
        
        NavBtn.MouseButton1Click:Connect(function()
            -- Update center title
            CenterTitle.Text = name
            CenterIcon.Text = icon
            
            -- Hide all pages, deselect all
            for _, nav in ipairs(navButtons) do
                nav.page.Visible = false
                Tween(nav.btn, {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    TextColor3 = Colors.TextSecondary,
                }, 0.2)
            end
            
            -- Show selected
            Page.Visible = true
            Tween(NavBtn, {
                BackgroundColor3 = Colors.NeonPink,
                BackgroundTransparency = 0,
                TextColor3 = Colors.White,
            }, 0.2)
            
            CurrentTab = Page
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
            CurrentTab = Page
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
                Padding = UDim.new(0, 3),
            })
            
            -- Section header
            local SectionHeader = create("Frame", {
                Parent = SectionFrame,
                BackgroundColor3 = Colors.NeonPink,
                BackgroundTransparency = 0.85,
                Size = UDim2.new(1, 0, 0, 26),
                BorderSizePixel = 0,
            })
            create("UICorner", {CornerRadius = UDim.new(0, 7), Parent = SectionHeader})
            
            local SectionTitle = create("TextLabel", {
                Parent = SectionHeader,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.05, 0, 0, 0),
                Size = UDim2.new(0.95, 0, 1, 0),
                Font = FONT_HEADER,
                Text = name,
                TextColor3 = Colors.White,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            local function UpdateSectionSize()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
            end
            SectionFrame.ChildAdded:Connect(UpdateSectionSize)
            SectionFrame.ChildRemoved:Connect(UpdateSectionSize)
            
            local Elements = {}
            
            -- Helper: Element base
            local function CreateElement(height)
                height = height or 34
                local el = create("TextButton", {
                    Parent = SectionFrame,
                    BackgroundColor3 = Colors.ContainerBg,
                    Size = UDim2.new(1, 0, 0, height),
                    AutoButtonColor = false,
                    Text = "",
                    BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 7), Parent = el})
                
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
                
                local label = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0),
                    Size = UDim2.new(0.68, 0, 1, 0),
                    Font = FONT_BODY,
                    Text = name,
                    TextColor3 = Colors.TextPrimary,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                -- Pill toggle
                local track = create("Frame", {
                    Parent = btn,
                    BackgroundColor3 = Colors.ToggleOff,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.82, 0, 0.5, -8),
                    Size = UDim2.new(0, 36, 0, 16),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})
                
                local dot = create("Frame", {
                    Parent = track,
                    BackgroundColor3 = Colors.White,
                    BorderSizePixel = 0,
                    Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
                    Size = UDim2.new(0, 12, 0, 12),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                
                local function SetToggle(state, instant)
                    toggled = state
                    local pos = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                    local trackColor = state and Colors.ToggleOn or Colors.ToggleOff
                    
                    if instant then
                        dot.Position = pos
                        track.BackgroundColor3 = trackColor
                    else
                        Tween(dot, {Position = pos}, 0.25, Enum.EasingStyle.Back)
                        Tween(track, {BackgroundColor3 = trackColor}, 0.2)
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
                
                local btn = CreateElement(46)
                
                local label = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0.05, 0),
                    Size = UDim2.new(0.55, 0, 0, 16),
                    Font = FONT_BODY,
                    Text = name,
                    TextColor3 = Colors.TextPrimary,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local valBox = create("Frame", {
                    Parent = btn,
                    BackgroundColor3 = Colors.InputBg,
                    Position = UDim2.new(0.78, 0, 0.05, 0),
                    Size = UDim2.new(0, 40, 0, 16),
                    BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = valBox})
                
                local valLabel = create("TextLabel", {
                    Parent = valBox,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = FONT_MONO,
                    Text = tostring(default),
                    TextColor3 = Colors.NeonPink,
                    TextSize = 10,
                })
                
                -- Track
                local track = create("Frame", {
                    Parent = btn,
                    BackgroundColor3 = Colors.SliderTrack,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.06, 0, 0.62, 0),
                    Size = UDim2.new(0.88, 0, 0, 4),
                })
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = track})
                
                local percent = (default - min) / (max - min)
                local fill = create("Frame", {
                    Parent = track,
                    BackgroundColor3 = Colors.SliderFill,
                    BorderSizePixel = 0,
                    Size = UDim2.new(percent, 0, 1, 0),
                })
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = fill})
                
                -- Glow dot
                local dot = create("Frame", {
                    Parent = fill,
                    BackgroundColor3 = Colors.White,
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.new(0, 12, 0, 12),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                
                local dotGlow = create("UIStroke", {
                    Parent = dot,
                    Color = Colors.NeonPink,
                    Thickness = 2,
                })
                
                -- Slider logic
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
                    Size = UDim2.new(1, 0, 0, 34),
                    BorderSizePixel = 0,
                })
                
                local dropList = create("UIListLayout", {
                    Parent = dropFrame,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 3),
                })
                
                local mainBtn = create("TextButton", {
                    Parent = dropFrame,
                    BackgroundColor3 = Colors.ContainerBg,
                    Size = UDim2.new(1, 0, 0, 34),
                    AutoButtonColor = false,
                    Font = FONT_BODY,
                    Text = "  " .. name,
                    TextColor3 = Colors.TextPrimary,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 7), Parent = mainBtn})
                
                local arrow = create("TextLabel", {
                    Parent = mainBtn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.88, 0, 0, 0),
                    Size = UDim2.new(0, 25, 1, 0),
                    Font = FONT_TEXT,
                    Text = "▾",
                    TextColor3 = Colors.NeonPink,
                    TextSize = 12,
                })
                
                local optionFrames = {}
                
                local function CreateOption(option)
                    local optBtn = create("TextButton", {
                        Parent = dropFrame,
                        BackgroundColor3 = Colors.InputBg,
                        Size = UDim2.new(1, 0, 0, 32),
                        AutoButtonColor = false,
                        Font = FONT_TEXT,
                        Text = "   " .. option,
                        TextColor3 = Colors.TextSecondary,
                        TextSize = 11,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Visible = false,
                        BorderSizePixel = 0,
                    })
                    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = optBtn})
                    
                    optBtn.MouseEnter:Connect(function()
                        Tween(optBtn, {TextColor3 = Colors.White}, 0.1)
                    end)
                    optBtn.MouseLeave:Connect(function()
                        Tween(optBtn, {TextColor3 = Colors.TextSecondary}, 0.1)
                    end)
                    
                    optBtn.MouseButton1Click:Connect(function()
                        mainBtn.Text = "  " .. option
                        callback(option)
                        opened = false
                        arrow.Rotation = 0
                        for _, o in ipairs(optionFrames) do o.Visible = false end
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 34)}, 0.15)
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
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y)}, 0.15)
                    else
                        arrow.Rotation = 0
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 34)}, 0.15)
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
                            dropFrame.Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y)
                        end
                        UpdateSectionSize()
                    end
                }
            end
            
            -- ===== BUTTON =====
            function Elements:AddButton(name, callback)
                local btn = CreateElement()
                
                local label = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0),
                    Size = UDim2.new(0.8, 0, 1, 0),
                    Font = FONT_BODY,
                    Text = name,
                    TextColor3 = Colors.TextPrimary,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local arrowIcon = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.9, 0, 0, 0),
                    Size = UDim2.new(0, 20, 1, 0),
                    Font = FONT_BODY,
                    Text = "→",
                    TextColor3 = Colors.NeonPink,
                    TextSize = 14,
                })
                
                btn.MouseButton1Click:Connect(function()
                    Tween(btn, {BackgroundColor3 = Colors.NeonPink}, 0.06)
                    task.wait(0.06)
                    Tween(btn, {BackgroundColor3 = Colors.ContainerBg}, 0.15)
                    callback()
                end)
                
                UpdateSectionSize()
                return {SetText = function(t) label.Text = t end}
            end
            
            -- ===== LABEL =====
            function Elements:AddLabel(text)
                local lbl = create("TextLabel", {
                    Parent = SectionFrame,
                    BackgroundColor3 = Colors.NeonPink,
                    BackgroundTransparency = 0.85,
                    Size = UDim2.new(1, 0, 0, 26),
                    Font = FONT_HEADER,
                    Text = "  " .. text,
                    TextColor3 = Colors.White,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 7), Parent = lbl})
                
                UpdateSectionSize()
                return {SetText = function(t) lbl.Text = "  " .. t end}
            end
            
            -- ===== NOTIFICATION (for right sidebar) =====
            function Elements:AddNotification(text, type)
                type = type or "info"
                local colors = {
                    success = Colors.Green,
                    info = Colors.SoftPurple,
                    warning = Colors.Gold,
                }
                
                local notif = create("Frame", {
                    Parent = RightSidebar,
                    BackgroundColor3 = Colors.ContainerBg,
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 7), Parent = notif})
                
                -- Left accent border
                local accent = create("Frame", {
                    Parent = notif,
                    BackgroundColor3 = colors[type] or Colors.NeonPink,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(0, 3, 1, 0),
                })
                create("UICorner", {CornerRadius = UDim.new(0, 7), Parent = accent})
                
                local icon = type == "success" and "✓" or type == "warning" and "⚠" or "ℹ"
                
                local iconLabel = create("TextLabel", {
                    Parent = notif,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0),
                    Size = UDim2.new(0, 18, 1, 0),
                    Font = FONT_BODY,
                    Text = icon,
                    TextColor3 = colors[type] or Colors.NeonPink,
                    TextSize = 14,
                })
                
                local textLabel = create("TextLabel", {
                    Parent = notif,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.18, 0, 0, 0),
                    Size = UDim2.new(0.78, 0, 1, 0),
                    Font = FONT_TEXT,
                    Text = text,
                    TextColor3 = Colors.TextSecondary,
                    TextSize = 10,
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
