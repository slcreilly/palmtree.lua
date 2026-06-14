-- ============================================
-- PALMTREE UI LIBRARY v2 - Modern & Polished
-- ============================================

local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Modern color palette
local Colors = {
    Background = Color3.fromRGB(15, 15, 25),
    Header = Color3.fromRGB(12, 12, 20),
    Sidebar = Color3.fromRGB(10, 10, 18),
    Element = Color3.fromRGB(25, 25, 38),
    ElementHover = Color3.fromRGB(30, 30, 45),
    Accent = Color3.fromRGB(80, 200, 200),
    AccentDark = Color3.fromRGB(50, 150, 150),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(150, 150, 165),
    ToggleOff = Color3.fromRGB(55, 55, 70),
    ToggleOn = Color3.fromRGB(80, 200, 200),
    SliderBg = Color3.fromRGB(45, 45, 60),
    SliderFill = Color3.fromRGB(80, 200, 200),
    DropdownOption = Color3.fromRGB(25, 25, 38),
    Border = Color3.fromRGB(35, 35, 50),
    Shadow = Color3.fromRGB(0, 0, 0),
}

local function create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

local function Tween(obj, props, duration, easing)
    easing = easing or Enum.EasingStyle.Quad
    return TweenService:Create(obj, TweenInfo.new(duration or 0.2, easing, Enum.EasingDirection.Out), props):Play()
end

-- Enhanced drag for mobile + PC
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

-- Window shadow effect
local function AddShadow(frame)
    local shadow = create("Frame", {
        Parent = frame,
        BackgroundColor3 = Colors.Shadow,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 3, 0, 3),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = -1,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = shadow})
    return shadow
end

function Library:CreateWindow(title)
    title = title or "UI"
    
    -- Cleanup
    local uiName = title .. "_UI"
    if CoreGui:FindFirstChild(uiName) then
        CoreGui[uiName]:Destroy()
    end
    
    -- ScreenGui
    local ScreenGui = create("ScreenGui", {
        Name = uiName,
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
    })
    
    -- Main container with shadow
    local Main = create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Colors.Background,
        Position = UDim2.new(0.3, 0, 0.2, 0),
        Size = UDim2.new(0, 520, 0, 340),
        ClipsDescendants = true,
        BorderSizePixel = 0,
    })
    
    local MainCorner = create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = Main,
    })
    
    local MainShadow = create("ImageLabel", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -8, 0, -8),
        Size = UDim2.new(1, 16, 1, 16),
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 49, 49),
        ZIndex = -1,
    })
    
    -- Header bar
    local Header = create("Frame", {
        Name = "Header",
        Parent = Main,
        BackgroundColor3 = Colors.Header,
        Size = UDim2.new(1, 0, 0, 40),
        BorderSizePixel = 0,
    })
    
    local HeaderCorner = create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = Header,
    })
    
    -- Cover bottom corners
    local HeaderCover = create("Frame", {
        Parent = Header,
        BackgroundColor3 = Colors.Header,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.6, 0),
        Size = UDim2.new(1, 0, 0.4, 0),
    })
    
    -- Title with icon
    local TitleLabel = create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.04, 0, 0, 0),
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Colors.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Close button
    local CloseButton = create("TextButton", {
        Parent = Header,
        BackgroundColor3 = Color3.fromRGB(255, 70, 70),
        BackgroundTransparency = 0.8,
        Position = UDim2.new(0.92, 0, 0.15, 0),
        Size = UDim2.new(0, 28, 0, 28),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        BorderSizePixel = 0,
    })
    
    local CloseCorner = create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = CloseButton,
    })
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundTransparency = 0.4}, 0.15)
    end)
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundTransparency = 0.8}, 0.15)
    end)
    CloseButton.MouseButton1Click:Connect(function()
        Tween(Main, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.2, Enum.EasingStyle.Back)
        task.wait(0.2)
        ScreenGui:Destroy()
    end)
    
    MakeDraggable(Main, Header)
    
    -- Sidebar with glass effect
    local Sidebar = create("Frame", {
        Name = "Sidebar",
        Parent = Main,
        BackgroundColor3 = Colors.Sidebar,
        Position = UDim2.new(0, 0, 0.118, 0),
        Size = UDim2.new(0, 150, 0, 300),
        BorderSizePixel = 0,
    })
    
    local SidebarCorner = create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = Sidebar,
    })
    
    local SidePadding = create("UIPadding", {
        Parent = Sidebar,
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
    })
    
    local TabList = create("UIListLayout", {
        Parent = Sidebar,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
    })
    
    -- Pages container
    local PagesFrame = create("Frame", {
        Name = "Pages",
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.32, 0, 0.16, 0),
        Size = UDim2.new(0.66, 0, 0.82, 0),
        BorderSizePixel = 0,
    })
    
    -- Keybind toggle
    UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == Enum.KeyCode.RightShift then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    -- Tab system
    local Tabs = {}
    local CurrentTab = nil
    
    function Tabs:CreateTab(name, icon)
        icon = icon or ""
        
        -- Tab button
        local TabButton = create("TextButton", {
            Parent = Sidebar,
            BackgroundColor3 = Colors.Element,
            Size = UDim2.new(1, 0, 0, 35),
            Font = Enum.Font.GothamSemibold,
            RichText = true,
            Text = icon .. "  " .. name,
            TextColor3 = Colors.SubText,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            BorderSizePixel = 0,
            ClipsDescendants = true,
        })
        
        local TabCorner = create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = TabButton,
        })
        
        -- Page
        local Page = create("ScrollingFrame", {
            Parent = PagesFrame,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Colors.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollingDirection = Enum.ScrollingDirection.Y,
            VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
        })
        
        local PagePadding = create("UIPadding", {
            Parent = Page,
            PaddingRight = UDim.new(0, 3),
        })
        
        local PageList = create("UIListLayout", {
            Parent = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
        })
        
        local function UpdateCanvas()
            local contentHeight = PageList.AbsoluteContentSize.Y
            Page.CanvasSize = UDim2.new(0, 0, 0, math.max(contentHeight + 10, Page.AbsoluteSize.Y))
        end
        
        Page.ChildAdded:Connect(UpdateCanvas)
        Page.ChildRemoved:Connect(UpdateCanvas)
        
        -- Hover effects
        TabButton.MouseEnter:Connect(function()
            if CurrentTab and CurrentTab.Button == TabButton then return end
            Tween(TabButton, {BackgroundColor3 = Colors.ElementHover}, 0.15)
        end)
        TabButton.MouseLeave:Connect(function()
            if CurrentTab and CurrentTab.Button == TabButton then return end
            Tween(TabButton, {BackgroundColor3 = Colors.Element}, 0.15)
        end)
        
        -- Select tab
        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Page.Visible = false
                Tween(CurrentTab.Button, {
                    BackgroundColor3 = Colors.Element,
                    TextColor3 = Colors.SubText,
                }, 0.15)
            end
            
            Page.Visible = true
            Tween(TabButton, {
                BackgroundColor3 = Colors.Accent,
                TextColor3 = Color3.fromRGB(15, 15, 25),
            }, 0.15)
            
            CurrentTab = {Button = TabButton, Page = Page}
            UpdateCanvas()
        end)
        
        -- Auto-select first tab
        if not CurrentTab then
            Page.Visible = true
            Tween(TabButton, {
                BackgroundColor3 = Colors.Accent,
                TextColor3 = Color3.fromRGB(15, 15, 25),
            }, 0.15)
            CurrentTab = {Button = TabButton, Page = Page}
        end
        
        -- Sections
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
                Padding = UDim.new(0, 4),
            })
            
            -- Section header
            local SectionHeader = create("Frame", {
                Parent = SectionFrame,
                BackgroundColor3 = Colors.Accent,
                Size = UDim2.new(1, 0, 0, 30),
                BorderSizePixel = 0,
            })
            
            local HeaderCorner = create("UICorner", {
                CornerRadius = UDim.new(0, 7),
                Parent = SectionHeader,
            })
            
            local SectionTitle = create("TextLabel", {
                Parent = SectionHeader,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.05, 0, 0, 0),
                Size = UDim2.new(0.95, 0, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = name,
                TextColor3 = Color3.fromRGB(15, 15, 25),
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            local function UpdateSectionSize()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
                UpdateCanvas()
            end
            
            SectionFrame.ChildAdded:Connect(UpdateSectionSize)
            SectionFrame.ChildRemoved:Connect(UpdateSectionSize)
            
            local Elements = {}
            
            -- Helper: Element base
            local function CreateElement(height)
                height = height or 36
                local Element = create("TextButton", {
                    Parent = SectionFrame,
                    BackgroundColor3 = Colors.Element,
                    Size = UDim2.new(1, 0, 0, height),
                    AutoButtonColor = false,
                    Font = Enum.Font.SourceSans,
                    Text = "",
                    TextSize = 14,
                    BorderSizePixel = 0,
                })
                
                local Corner = create("UICorner", {
                    CornerRadius = UDim.new(0, 7),
                    Parent = Element,
                })
                
                Element.MouseEnter:Connect(function()
                    Tween(Element, {BackgroundColor3 = Colors.ElementHover}, 0.12)
                end)
                Element.MouseLeave:Connect(function()
                    Tween(Element, {BackgroundColor3 = Colors.Element}, 0.12)
                end)
                
                return Element
            end
            
            -- ===== BUTTON =====
            function Elements:AddButton(name, callback)
                local btn = CreateElement()
                
                local label = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.05, 0, 0, 0),
                    Size = UDim2.new(0.9, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                -- Arrow icon
                local arrow = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.91, 0, 0, 0),
                    Size = UDim2.new(0, 25, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = "→",
                    TextColor3 = Colors.Accent,
                    TextSize = 16,
                })
                
                btn.MouseButton1Click:Connect(function()
                    Tween(btn, {BackgroundColor3 = Colors.Accent}, 0.06)
                    task.wait(0.06)
                    Tween(btn, {BackgroundColor3 = Colors.Element}, 0.1)
                    callback()
                end)
                
                UpdateSectionSize()
                return {SetText = function(t) label.Text = t end}
            end
            
            -- ===== TOGGLE (Modern Switch) =====
            function Elements:AddToggle(name, default, callback)
                default = default or false
                local toggled = default
                
                local btn = CreateElement()
                
                local label = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.05, 0, 0, 0),
                    Size = UDim2.new(0.7, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                -- Toggle track
                local track = create("Frame", {
                    Parent = btn,
                    BackgroundColor3 = Colors.ToggleOff,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.88, 0, 0.5, -10),
                    Size = UDim2.new(0, 40, 0, 20),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})
                
                -- Toggle dot
                local dot = create("Frame", {
                    Parent = track,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                
                -- Drop shadow on dot
                local dotShadow = create("ImageLabel", {
                    Parent = dot,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -2, 0, -2),
                    Size = UDim2.new(1, 4, 1, 4),
                    Image = "rbxassetid://6014261993",
                    ImageColor3 = Color3.new(0, 0, 0),
                    ImageTransparency = 0.7,
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(49, 49, 49, 49),
                    ZIndex = -1,
                })
                
                local function SetToggle(state, instant)
                    toggled = state
                    local pos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    local trackColor = state and Colors.ToggleOn or Colors.ToggleOff
                    
                    if instant then
                        dot.Position = pos
                        track.BackgroundColor3 = trackColor
                    else
                        Tween(dot, {Position = pos}, 0.2, Enum.EasingStyle.Quart)
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
            
            -- ===== SLIDER (Fixed) =====
            function Elements:AddSlider(name, min, max, default, callback)
                min = min or 0
                max = max or 100
                default = math.clamp(default or min, min, max)
                
                local sliderHeight = 48
                local btn = CreateElement(sliderHeight)
                
                local label = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.05, 0, 0.05, 0),
                    Size = UDim2.new(0.7, 0, 0, 18),
                    Font = Enum.Font.GothamSemibold,
                    Text = name,
                    TextColor3 = Colors.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local valueLabel = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.75, 0, 0.05, 0),
                    Size = UDim2.new(0.2, 0, 0, 18),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(default),
                    TextColor3 = Colors.Accent,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                })
                
                -- Slider track
                local sliderTrack = create("Frame", {
                    Parent = btn,
                    BackgroundColor3 = Colors.SliderBg,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.05, 0, 0.58, 0),
                    Size = UDim2.new(0.9, 0, 0, 5),
                })
                create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = sliderTrack})
                
                -- Slider fill
                local percent = (default - min) / (max - min)
                local fill = create("Frame", {
                    Parent = sliderTrack,
                    BackgroundColor3 = Colors.SliderFill,
                    BorderSizePixel = 0,
                    Size = UDim2.new(percent, 0, 1, 0),
                })
                create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = fill})
                
                -- Slider dot
                local dot = create("Frame", {
                    Parent = fill,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                
                -- Dot border
                local dotBorder = create("UIStroke", {
                    Parent = dot,
                    Color = Colors.Accent,
                    Thickness = 2,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                })
                
                -- Slider functionality
                local player = game.Players.LocalPlayer
                local mouse = player:GetMouse()
                local dragging = false
                
                local function UpdateValue(inputX)
                    local relativeX = math.clamp(inputX - sliderTrack.AbsolutePosition.X, 0, sliderTrack.AbsoluteSize.X)
                    local newPercent = relativeX / sliderTrack.AbsoluteSize.X
                    local value = math.floor(min + (max - min) * newPercent)
                    
                    fill.Size = UDim2.new(newPercent, 0, 1, 0)
                    valueLabel.Text = tostring(value)
                    callback(value)
                end
                
                sliderTrack.InputBegan:Connect(function(inp)
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
                    SetValue = function(val)
                        val = math.clamp(val, min, max)
                        local p = (val - min) / (max - min)
                        fill.Size = UDim2.new(p, 0, 1, 0)
                        valueLabel.Text = tostring(val)
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
                    Size = UDim2.new(1, 0, 0, 36),
                    BorderSizePixel = 0,
                })
                
                local dropList = create("UIListLayout", {
                    Parent = dropFrame,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 3),
                })
                
                local mainBtn = create("TextButton", {
                    Parent = dropFrame,
                    BackgroundColor3 = Colors.Element,
                    Size = UDim2.new(1, 0, 0, 36),
                    AutoButtonColor = false,
                    Font = Enum.Font.Gotham,
                    Text = "  " .. name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 7), Parent = mainBtn})
                
                mainBtn.MouseEnter:Connect(function()
                    if not opened then Tween(mainBtn, {BackgroundColor3 = Colors.ElementHover}, 0.12) end
                end)
                mainBtn.MouseLeave:Connect(function()
                    if not opened then Tween(mainBtn, {BackgroundColor3 = Colors.Element}, 0.12) end
                end)
                
                local arrow = create("TextLabel", {
                    Parent = mainBtn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.88, 0, 0, 0),
                    Size = UDim2.new(0, 30, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = "▼",
                    TextColor3 = Colors.Accent,
                    TextSize = 11,
                })
                
                local optionFrames = {}
                local selectedText = name
                
                local function CreateOption(option)
                    local optBtn = create("TextButton", {
                        Parent = dropFrame,
                        BackgroundColor3 = Colors.DropdownOption,
                        Size = UDim2.new(1, 0, 0, 34),
                        AutoButtonColor = false,
                        Font = Enum.Font.Gotham,
                        Text = "   " .. option,
                        TextColor3 = Colors.SubText,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Visible = false,
                        BorderSizePixel = 0,
                    })
                    create("UICorner", {CornerRadius = UDim.new(0, 7), Parent = optBtn})
                    
                    optBtn.MouseEnter:Connect(function()
                        Tween(optBtn, {BackgroundColor3 = Colors.ElementHover}, 0.1)
                    end)
                    optBtn.MouseLeave:Connect(function()
                        Tween(optBtn, {BackgroundColor3 = Colors.DropdownOption}, 0.1)
                    end)
                    
                    optBtn.MouseButton1Click:Connect(function()
                        selectedText = option
                        mainBtn.Text = "  " .. option
                        callback(option)
                        
                        -- Close
                        opened = false
                        arrow.Rotation = 0
                        for _, o in ipairs(optionFrames) do o.Visible = false end
                        dropFrame.Size = UDim2.new(1, 0, 0, 36)
                        UpdateSectionSize()
                        UpdateCanvas()
                    end)
                    
                    return optBtn
                end
                
                for _, option in ipairs(options) do
                    table.insert(optionFrames, CreateOption(option))
                end
                
                mainBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        arrow.Rotation = 180
                        for _, o in ipairs(optionFrames) do o.Visible = true end
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y)}, 0.15)
                    else
                        arrow.Rotation = 0
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 36)}, 0.15)
                        task.wait(0.15)
                        for _, o in ipairs(optionFrames) do o.Visible = false end
                    end
                    UpdateSectionSize()
                    UpdateCanvas()
                end)
                
                UpdateSectionSize()
                
                return {
                    Refresh = function(newOptions)
                        for _, o in ipairs(optionFrames) do o:Destroy() end
                        optionFrames = {}
                        for _, option in ipairs(newOptions) do
                            local opt = CreateOption(option)
                            if opened then opt.Visible = true end
                            table.insert(optionFrames, opt)
                        end
                        if opened then
                            dropFrame.Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y)
                        end
                        UpdateSectionSize()
                        UpdateCanvas()
                    end,
                    GetValue = function() return selectedText end
                }
            end
            
            -- ===== LABEL =====
            function Elements:AddLabel(text)
                local label = create("TextLabel", {
                    Parent = SectionFrame,
                    BackgroundColor3 = Colors.Accent,
                    Size = UDim2.new(1, 0, 0, 28),
                    Font = Enum.Font.GothamBold,
                    Text = "  " .. text,
                    TextColor3 = Color3.fromRGB(15, 15, 25),
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 7), Parent = label})
                
                UpdateSectionSize()
                return {SetText = function(t) label.Text = "  " .. t end}
            end
            
            -- ===== BIND (Keybind) =====
            function Elements:AddBind(name, defaultKey, callback)
                local currentKey = defaultKey or Enum.KeyCode.F
                local listening = false
                
                local btn = CreateElement()
                
                local label = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.05, 0, 0, 0),
                    Size = UDim2.new(0.6, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local keyLabel = create("TextButton", {
                    Parent = btn,
                    BackgroundColor3 = Colors.AccentDark,
                    Position = UDim2.new(0.75, 0, 0.5, -10),
                    Size = UDim2.new(0.2, 0, 0, 20),
                    Font = Enum.Font.GothamBold,
                    Text = currentKey.Name,
                    TextColor3 = Color3.fromRGB(15, 15, 25),
                    TextSize = 10,
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = keyLabel})
                
                local bindConnection
                
                local function SetBind(newKey)
                    currentKey = newKey
                    keyLabel.Text = newKey.Name
                    
                    if bindConnection then bindConnection:Disconnect() end
                    bindConnection = UserInputService.InputBegan:Connect(function(inp, gpe)
                        if gpe then return end
                        if inp.KeyCode == currentKey then
                            callback()
                        end
                    end)
                end
                
                keyLabel.MouseButton1Click:Connect(function()
                    listening = true
                    keyLabel.Text = "..."
                    
                    local conn = UserInputService.InputBegan:Connect(function(inp, gpe)
                        if gpe then return end
                        if listening and inp.KeyCode ~= Enum.KeyCode.Unknown then
                            SetBind(inp.KeyCode)
                            listening = false
                            conn:Disconnect()
                        end
                    end)
                end)
                
                -- Initial bind
                SetBind(currentKey)
                
                UpdateSectionSize()
            end
            
            return Elements
        end
        
        return Sections
    end
    
    return Tabs
end

return Library
