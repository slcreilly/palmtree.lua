-- ============================================
-- SIMPLE UI LIBRARY - Mobile + PC Ready
-- ============================================

local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Colors
local Colors = {
    Main = Color3.fromRGB(25, 25, 35),
    Header = Color3.fromRGB(20, 20, 30),
    Tab = Color3.fromRGB(35, 35, 50),
    Element = Color3.fromRGB(30, 30, 42),
    Accent = Color3.fromRGB(0, 200, 200),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 190),
}

-- Services
local function create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

-- Tween helper
local function Tween(obj, props, duration)
    return TweenService:Create(obj, TweenInfo.new(duration), props):Play()
end

-- Drag function (Mobile + PC)
local function MakeDraggable(gui, dragPart)
    local dragging, startPos, startMouse
    local input = nil
    
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
    
    dragPart.InputChanged:Connect(function(inp)
        if inp == input and dragging then
            local delta = inp.Position - startMouse
            gui.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Create UI
function Library:CreateWindow(title)
    title = title or "UI"
    
    -- Cleanup old
    if CoreGui:FindFirstChild(title .. "_UI") then
        CoreGui[title .. "_UI"]:Destroy()
    end
    
    -- ScreenGui
    local ScreenGui = create("ScreenGui", {
        Name = title .. "_UI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
    })
    
    -- Main Frame
    local Main = create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Colors.Main,
        Position = UDim2.new(0.3, 0, 0.25, 0),
        Size = UDim2.new(0, 500, 0, 320),
        ClipsDescendants = true,
    })
    
    local MainCorner = create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = Main,
    })
    
    -- Header
    local Header = create("Frame", {
        Name = "Header",
        Parent = Main,
        BackgroundColor3 = Colors.Header,
        Size = UDim2.new(0, 500, 0, 35),
    })
    
    local HeaderCorner = create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = Header,
    })
    
    -- Cover bottom corners
    local HeaderCover = create("Frame", {
        Parent = Header,
        BackgroundColor3 = Colors.Header,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.7, 0),
        Size = UDim2.new(1, 0, 0.3, 0),
    })
    
    -- Title
    local TitleLabel = create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.03, 0, 0, 0),
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
        BackgroundTransparency = 1,
        Position = UDim2.new(0.92, 0, 0.15, 0),
        Size = UDim2.new(0, 25, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Colors.Text,
        TextSize = 22,
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        Main:Destroy()
    end)
    
    MakeDraggable(Main, Header)
    
    -- Left sidebar (tabs)
    local Sidebar = create("Frame", {
        Name = "Sidebar",
        Parent = Main,
        BackgroundColor3 = Colors.Header,
        Position = UDim2.new(0, 0, 0.11, 0),
        Size = UDim2.new(0, 140, 0, 285),
    })
    
    local SidebarCorner = create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = Sidebar,
    })
    
    local TabList = create("UIListLayout", {
        Parent = Sidebar,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    })
    
    local SidePadding = create("UIPadding", {
        Parent = Sidebar,
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
    })
    
    -- Pages container
    local PagesFrame = create("Frame", {
        Name = "Pages",
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.31, 0, 0.14, 0),
        Size = UDim2.new(0.67, 0, 0.84, 0),
    })
    
    -- Tab system
    local Tabs = {}
    local CurrentTab = nil
    
    function Tabs:CreateTab(name, icon)
        icon = icon or ""
        
        -- Tab button
        local TabButton = create("TextButton", {
            Parent = Sidebar,
            BackgroundColor3 = Colors.Tab,
            Size = UDim2.new(0, 125, 0, 32),
            Font = Enum.Font.GothamSemibold,
            RichText = true,
            Text = icon .. "  " .. name,
            TextColor3 = Colors.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
        })
        
        local TabCorner = create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = TabButton,
        })
        
        -- Page (ScrollingFrame)
        local Page = create("ScrollingFrame", {
            Parent = PagesFrame,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Colors.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
        })
        
        local PageList = create("UIListLayout", {
            Parent = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
        })
        
        local function UpdateCanvas()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 10)
        end
        
        Page.ChildAdded:Connect(UpdateCanvas)
        Page.ChildRemoved:Connect(UpdateCanvas)
        
        -- Switch tab
        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Page.Visible = false
                Tween(CurrentTab.Button, {
                    BackgroundColor3 = Colors.Tab,
                    TextColor3 = Colors.Text,
                }, 0.15)
            end
            
            Page.Visible = true
            Tween(TabButton, {
                BackgroundColor3 = Colors.Accent,
                TextColor3 = Color3.new(0, 0, 0),
            }, 0.15)
            
            CurrentTab = {Button = TabButton, Page = Page}
            UpdateCanvas()
        end)
        
        -- Auto-select first tab
        if not CurrentTab then
            Page.Visible = true
            Tween(TabButton, {
                BackgroundColor3 = Colors.Accent,
                TextColor3 = Color3.new(0, 0, 0),
            }, 0.15)
            CurrentTab = {Button = TabButton, Page = Page}
        end
        
        -- Section system
        local Sections = {}
        
        function Sections:AddSection(name)
            local SectionFrame = create("Frame", {
                Parent = Page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 0),
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
                Size = UDim2.new(1, 0, 0, 28),
            })
            
            local HeaderCorner = create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = SectionHeader,
            })
            
            local SectionTitle = create("TextLabel", {
                Parent = SectionHeader,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.04, 0, 0, 0),
                Size = UDim2.new(0.96, 0, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = name,
                TextColor3 = Color3.new(0, 0, 0),
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            local function UpdateSectionSize()
                SectionFrame.Size = UDim2.new(1, -10, 0, SectionList.AbsoluteContentSize.Y)
                UpdateCanvas()
            end
            
            SectionFrame.ChildAdded:Connect(UpdateSectionSize)
            SectionFrame.ChildRemoved:Connect(UpdateSectionSize)
            
            -- Elements
            local Elements = {}
            
            -- Helper: Create element base
            local function CreateElement()
                local Element = create("TextButton", {
                    Parent = SectionFrame,
                    BackgroundColor3 = Colors.Element,
                    Size = UDim2.new(1, 0, 0, 34),
                    AutoButtonColor = false,
                    Font = Enum.Font.SourceSans,
                    Text = "",
                    TextSize = 14,
                })
                
                local Corner = create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = Element,
                })
                
                -- Hover effect
                Element.MouseEnter:Connect(function()
                    Tween(Element, {BackgroundColor3 = Colors.Element:Lerp(Color3.new(1,1,1), 0.05)}, 0.1)
                end)
                Element.MouseLeave:Connect(function()
                    Tween(Element, {BackgroundColor3 = Colors.Element}, 0.1)
                end)
                
                return Element
            end
            
            -- BUTTON
            function Elements:AddButton(name, callback)
                local btn = CreateElement()
                
                local icon = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.03, 0, 0, 0),
                    Size = UDim2.new(0, 25, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = "▶",
                    TextColor3 = Colors.Accent,
                    TextSize = 14,
                })
                
                local label = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.12, 0, 0, 0),
                    Size = UDim2.new(0.85, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                btn.MouseButton1Click:Connect(function()
                    Tween(btn, {BackgroundColor3 = Colors.Accent}, 0.08)
                    task.wait(0.08)
                    Tween(btn, {BackgroundColor3 = Colors.Element}, 0.08)
                    callback()
                end)
                
                UpdateSectionSize()
                
                return {
                    SetText = function(text) label.Text = text end
                }
            end
            
            -- TOGGLE
            function Elements:AddToggle(name, default, callback)
                default = default or false
                local toggled = default
                
                local btn = CreateElement()
                
                local label = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.04, 0, 0, 0),
                    Size = UDim2.new(0.7, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                -- Toggle switch
                local switchBg = create("Frame", {
                    Parent = btn,
                    BackgroundColor3 = Colors.Element:Lerp(Color3.new(1,1,1), 0.2),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.88, 0, 0.5, -10),
                    Size = UDim2.new(0, 38, 0, 20),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = switchBg})
                
                local switchDot = create("Frame", {
                    Parent = switchBg,
                    BackgroundColor3 = Colors.Accent,
                    BorderSizePixel = 0,
                    Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = switchDot})
                
                local function SetToggle(state)
                    toggled = state
                    if state then
                        Tween(switchDot, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.15)
                        Tween(switchBg, {BackgroundColor3 = Colors.Accent}, 0.15)
                    else
                        Tween(switchDot, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.15)
                        Tween(switchBg, {BackgroundColor3 = Colors.Element:Lerp(Color3.new(1,1,1), 0.2)}, 0.15)
                    end
                end
                
                if default then SetToggle(true) end
                
                btn.MouseButton1Click:Connect(function()
                    SetToggle(not toggled)
                    callback(toggled)
                end)
                
                UpdateSectionSize()
                
                return {
                    SetState = function(state) SetToggle(state); callback(state) end
                }
            end
            
            -- SLIDER
            function Elements:AddSlider(name, min, max, default, callback)
                min = min or 0
                max = max or 100
                default = default or min
                
                local btn = CreateElement()
                btn.Size = UDim2.new(1, 0, 0, 45) -- taller for slider
                
                local label = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.04, 0, 0, 0),
                    Size = UDim2.new(0.5, 0, 0.5, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local valueLabel = create("TextLabel", {
                    Parent = btn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.04, 0, 0.45, 0),
                    Size = UDim2.new(0.3, 0, 0.5, 0),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(default),
                    TextColor3 = Colors.Accent,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                -- Slider bar
                local sliderBar = create("TextButton", {
                    Parent = btn,
                    BackgroundColor3 = Colors.Element:Lerp(Color3.new(1,1,1), 0.15),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.35, 0, 0.65, 0),
                    Size = UDim2.new(0.6, 0, 0, 6),
                    AutoButtonColor = false,
                    Text = "",
                })
                create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = sliderBar})
                
                local fill = create("Frame", {
                    Parent = sliderBar,
                    BackgroundColor3 = Colors.Accent,
                    BorderSizePixel = 0,
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                })
                create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = fill})
                
                -- Dot
                local dot = create("Frame", {
                    Parent = fill,
                    BackgroundColor3 = Colors.Accent,
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.new(0, 12, 0, 12),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                
                local mouse = game.Players.LocalPlayer:GetMouse()
                
                sliderBar.MouseButton1Down:Connect(function()
                    local moveConn = mouse.Move:Connect(function()
                        local percent = math.clamp((mouse.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                        local value = math.floor(min + (max - min) * percent)
                        fill.Size = UDim2.new(percent, 0, 1, 0)
                        valueLabel.Text = tostring(value)
                        callback(value)
                    end)
                    
                    local endConn = UserInputService.InputEnded:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                            moveConn:Disconnect()
                            endConn:Disconnect()
                        end
                    end)
                end)
                
                UpdateSectionSize()
                
                return {
                    SetValue = function(val)
                        local percent = (val - min) / (max - min)
                        fill.Size = UDim2.new(percent, 0, 1, 0)
                        valueLabel.Text = tostring(val)
                    end
                }
            end
            
            -- DROPDOWN
            function Elements:AddDropdown(name, options, callback)
                callback = callback or function() end
                local opened = false
                
                local dropFrame = create("Frame", {
                    Parent = SectionFrame,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 34),
                })
                
                local dropList = create("UIListLayout", {
                    Parent = dropFrame,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 3),
                })
                
                local mainBtn = create("TextButton", {
                    Parent = dropFrame,
                    BackgroundColor3 = Colors.Element,
                    Size = UDim2.new(1, 0, 0, 34),
                    AutoButtonColor = false,
                    Font = Enum.Font.Gotham,
                    Text = "  " .. name,
                    TextColor3 = Colors.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = mainBtn})
                
                mainBtn.MouseEnter:Connect(function()
                    if not opened then Tween(mainBtn, {BackgroundColor3 = Colors.Element:Lerp(Color3.new(1,1,1), 0.05)}, 0.1) end
                end)
                mainBtn.MouseLeave:Connect(function()
                    if not opened then Tween(mainBtn, {BackgroundColor3 = Colors.Element}, 0.1) end
                end)
                
                -- Arrow indicator
                local arrow = create("TextLabel", {
                    Parent = mainBtn,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.9, 0, 0, 0),
                    Size = UDim2.new(0, 30, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = "▼",
                    TextColor3 = Colors.Accent,
                    TextSize = 12,
                })
                
                -- Options
                local optionFrames = {}
                for _, option in ipairs(options) do
                    local optBtn = create("TextButton", {
                        Parent = dropFrame,
                        BackgroundColor3 = Colors.Element,
                        Size = UDim2.new(1, 0, 0, 34),
                        AutoButtonColor = false,
                        Font = Enum.Font.Gotham,
                        Text = "    " .. option,
                        TextColor3 = Colors.SubText,
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Visible = false,
                    })
                    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = optBtn})
                    
                    optBtn.MouseButton1Click:Connect(function()
                        mainBtn.Text = "  " .. option
                        callback(option)
                        
                        -- Close dropdown
                        opened = false
                        arrow.Text = "▼"
                        for _, o in ipairs(optionFrames) do o.Visible = false end
                        dropFrame.Size = UDim2.new(1, 0, 0, 34)
                        UpdateSectionSize()
                        UpdateCanvas()
                    end)
                    
                    table.insert(optionFrames, optBtn)
                end
                
                mainBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        arrow.Text = "▲"
                        for _, o in ipairs(optionFrames) do o.Visible = true end
                        dropFrame.Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y)
                    else
                        arrow.Text = "▼"
                        for _, o in ipairs(optionFrames) do o.Visible = false end
                        dropFrame.Size = UDim2.new(1, 0, 0, 34)
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
                            local optBtn = create("TextButton", {
                                Parent = dropFrame,
                                BackgroundColor3 = Colors.Element,
                                Size = UDim2.new(1, 0, 0, 34),
                                AutoButtonColor = false,
                                Font = Enum.Font.Gotham,
                                Text = "    " .. option,
                                TextColor3 = Colors.SubText,
                                TextSize = 13,
                                TextXAlignment = Enum.TextXAlignment.Left,
                                Visible = opened,
                            })
                            create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = optBtn})
                            
                            optBtn.MouseButton1Click:Connect(function()
                                mainBtn.Text = "  " .. option
                                callback(option)
                                opened = false
                                arrow.Text = "▼"
                                for _, o in ipairs(optionFrames) do o.Visible = false end
                                dropFrame.Size = UDim2.new(1, 0, 0, 34)
                                UpdateSectionSize()
                                UpdateCanvas()
                            end)
                            
                            table.insert(optionFrames, optBtn)
                        end
                        if opened then
                            dropFrame.Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y)
                        end
                        UpdateSectionSize()
                        UpdateCanvas()
                    end
                }
            end
            
            -- LABEL
            function Elements:AddLabel(text)
                local label = create("TextLabel", {
                    Parent = SectionFrame,
                    BackgroundColor3 = Colors.Accent,
                    Size = UDim2.new(1, 0, 0, 28),
                    Font = Enum.Font.GothamBold,
                    Text = "  " .. text,
                    TextColor3 = Color3.new(0, 0, 0),
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = label})
                
                UpdateSectionSize()
                
                return {
                    SetText = function(t) label.Text = "  " .. t end
                }
            end
            
            return Elements
        end
        
        return Sections
    end
    
    return Tabs
end

return Library
