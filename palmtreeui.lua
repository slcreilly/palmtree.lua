-- ============================================
-- 🌴 PALMTREE.LUA v4 - Ultra Compact Mobile UI
-- Dynamic Gradient Background + Full Docs
-- ============================================

local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Colors
local Colors = {
    NeonPink = Color3.fromRGB(255, 42, 133),
    NeonCyan = Color3.fromRGB(0, 229, 255),
    Purple = Color3.fromRGB(140, 80, 220),
    White = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(240, 240, 250),
    TextSecondary = Color3.fromRGB(160, 160, 180),
    ToggleOff = Color3.fromRGB(50, 50, 65),
    SliderTrack = Color3.fromRGB(40, 40, 55),
    InputBg = Color3.fromRGB(25, 25, 38),
    ContainerBg = Color3.fromRGB(18, 18, 28),
    Green = Color3.fromRGB(70, 230, 120),
    Gold = Color3.fromRGB(255, 200, 50),
}

-- Dynamic gradient color pairs (for main background only)
local Gradients = {
    {Color3.fromRGB(10, 8, 25), Color3.fromRGB(20, 5, 25)},
    {Color3.fromRGB(8, 12, 28), Color3.fromRGB(22, 8, 22)},
    {Color3.fromRGB(12, 6, 25), Color3.fromRGB(18, 12, 30)},
    {Color3.fromRGB(6, 14, 28), Color3.fromRGB(25, 6, 22)},
    {Color3.fromRGB(14, 6, 22), Color3.fromRGB(8, 16, 30)},
}

local FONT = {
    Title = Enum.Font.GothamBlack,
    Header = Enum.Font.GothamBold,
    Body = Enum.Font.GothamSemibold,
    Text = Enum.Font.Gotham,
    Mono = Enum.Font.RobotoMono,
    Script = Enum.Font.FredokaOne,
}

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

function Library:CreateWindow(title)
    title = title or "PalmTree"
    
    -- Cleanup
    local uiName = "PT_" .. math.random(1000, 9999)
    if CoreGui:FindFirstChild(uiName) then CoreGui[uiName]:Destroy() end
    
    local ScreenGui = create("ScreenGui", {
        Name = uiName, Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false, Enabled = true,
    })
    
    -- ===== MAIN (ULTRA COMPACT) =====
    local Main = create("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Gradients[1][1],
        Position = UDim2.new(0.5, -140, 0.5, -110),
        Size = UDim2.new(0, 280, 0, 220),
        ClipsDescendants = true,
        BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Main})
    create("UIStroke", {Parent = Main, Color = Colors.NeonPink, Transparency = 0.6, Thickness = 1})
    
    -- ===== DYNAMIC GRADIENT (Background only) =====
    local gradientOverlay = create("Frame", {
        Parent = Main, BackgroundColor3 = Gradients[1][2],
        BackgroundTransparency = 0.35, Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0, ZIndex = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = gradientOverlay})
    
    local gIdx, gAlpha = 1, 0
    coroutine.wrap(function()
        while ScreenGui and ScreenGui.Parent do
            local curr = Gradients[gIdx]
            local next = Gradients[gIdx % #Gradients + 1]
            gAlpha = gAlpha + 0.006
            if gAlpha >= 1 then gAlpha = 0; gIdx = gIdx % #Gradients + 1 end
            Main.BackgroundColor3 = curr[1]:Lerp(next[1], gAlpha)
            gradientOverlay.BackgroundColor3 = curr[2]:Lerp(next[2], gAlpha)
            RunService.Heartbeat:Wait()
        end
    end)()
    
    -- ===== HEADER =====
    local Header = create("Frame", {
        Parent = Main, BackgroundColor3 = Color3.fromRGB(8, 8, 16),
        BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 24),
        BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Header})
    create("Frame", {
        Parent = Header, BackgroundColor3 = Color3.fromRGB(8, 8, 16),
        BackgroundTransparency = 0.2, BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0.5, 0),
    })
    
    create("TextLabel", {
        Parent = Header, BackgroundTransparency = 1,
        Position = UDim2.new(0.04, 0, 0, 0), Size = UDim2.new(0, 16, 1, 0),
        Font = FONT.Body, Text = "🌴", TextSize = 10,
    })
    create("TextLabel", {
        Parent = Header, BackgroundTransparency = 1,
        Position = UDim2.new(0.14, 0, 0, 0), Size = UDim2.new(0.5, 0, 1, 0),
        Font = FONT.Script, Text = title, TextColor3 = Colors.White,
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Minimize button
    local MinBtn = create("TextButton", {
        Parent = Header, BackgroundColor3 = Colors.NeonCyan,
        BackgroundTransparency = 0.85, Position = UDim2.new(0.88, 0, 0.15, 0),
        Size = UDim2.new(0, 18, 0, 18), Font = FONT.Header, Text = "−",
        TextColor3 = Colors.White, TextSize = 14, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = MinBtn})
    
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            for _, c in ipairs(Main:GetChildren()) do
                if c ~= Header and c ~= gradientOverlay then c.Visible = false end
            end
            Tween(Main, {Size = UDim2.new(0, 280, 0, 24)}, 0.15)
            MinBtn.Text = "+"
        else
            for _, c in ipairs(Main:GetChildren()) do c.Visible = true end
            Tween(Main, {Size = UDim2.new(0, 280, 0, 220)}, 0.15)
            MinBtn.Text = "−"
        end
    end)
    
    MakeDraggable(Main, Header)
    
    -- ===== LEFT SIDEBAR =====
    local Sidebar = create("Frame", {
        Parent = Main, BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.94, Position = UDim2.new(0, 0, 0.11, 0),
        Size = UDim2.new(0, 70, 0, 196), BorderSizePixel = 0, ClipsDescendants = true,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Sidebar})
    create("UIStroke", {Parent = Sidebar, Color = Colors.Purple, Transparency = 0.4, Thickness = 0.8})
    
    create("UIListLayout", {
        Parent = Sidebar, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1),
    })
    create("UIPadding", {
        Parent = Sidebar, PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4),
    })
    
    -- ===== CENTER =====
    local Center = create("Frame", {
        Parent = Main, BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.94, Position = UDim2.new(0.265, 0, 0.11, 0),
        Size = UDim2.new(0, 125, 0, 196), BorderSizePixel = 0, ClipsDescendants = true,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Center})
    create("UIStroke", {Parent = Center, Color = Colors.Purple, Transparency = 0.4, Thickness = 0.8})
    
    create("UIPadding", {
        Parent = Center, PaddingTop = UDim.new(0, 3), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4),
    })
    
    -- Center title
    local CenterTitleFrame = create("Frame", {
        Parent = Center, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), BorderSizePixel = 0,
    })
    local CenterIcon = create("TextLabel", {
        Parent = CenterTitleFrame, BackgroundTransparency = 1, Size = UDim2.new(0, 14, 1, 0),
        Font = FONT.Body, Text = "⚔️", TextSize = 9,
    })
    local CenterTitle = create("TextLabel", {
        Parent = CenterTitleFrame, BackgroundTransparency = 1,
        Position = UDim2.new(0.15, 0, 0, 0), Size = UDim2.new(0.85, 0, 1, 0),
        Font = FONT.Header, Text = "Combat", TextColor3 = Colors.White,
        TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local CenterContent = create("Frame", {
        Parent = Center, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.12, 0), Size = UDim2.new(1, 0, 0.88, 0), BorderSizePixel = 0,
    })
    create("UIListLayout", {
        Parent = CenterContent, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2),
    })
    
    -- ===== RIGHT PANEL =====
    local RightPanel = create("Frame", {
        Parent = Main, BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.94, Position = UDim2.new(0.72, 0, 0.11, 0),
        Size = UDim2.new(0, 72, 0, 196), BorderSizePixel = 0, ClipsDescendants = true,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = RightPanel})
    create("UIStroke", {Parent = RightPanel, Color = Colors.Purple, Transparency = 0.4, Thickness = 0.8})
    
    create("UIListLayout", {
        Parent = RightPanel, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3),
    })
    create("UIPadding", {
        Parent = RightPanel, PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4),
    })
    
    -- ===== KEYBIND TOGGLE =====
    UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == Enum.KeyCode.RightShift then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    -- ===== TABS =====
    local Tabs = {}
    local navBtns = {}
    
    function Tabs:CreateTab(name, icon)
        icon = icon or ""
        
        local NavBtn = create("TextButton", {
            Parent = Sidebar, BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20),
            Font = FONT.Text, RichText = true, Text = icon .. " " .. name,
            TextColor3 = Colors.TextSecondary, TextSize = 8,
            TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, BorderSizePixel = 0,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = NavBtn})
        
        local Page = create("Frame", {
            Parent = CenterContent, BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0), Visible = false, BorderSizePixel = 0,
        })
        create("UIListLayout", {
            Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2),
        })
        
        table.insert(navBtns, {btn = NavBtn, page = Page, name = name, icon = icon})
        
        NavBtn.MouseButton1Click:Connect(function()
            CenterTitle.Text = name; CenterIcon.Text = icon
            for _, n in ipairs(navBtns) do
                n.page.Visible = false
                Tween(n.btn, {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1, TextColor3 = Colors.TextSecondary}, 0.12)
            end
            Page.Visible = true
            Tween(NavBtn, {BackgroundColor3 = Colors.NeonPink, BackgroundTransparency = 0, TextColor3 = Colors.White}, 0.12)
        end)
        
        if #navBtns == 1 then
            Page.Visible = true
            Tween(NavBtn, {BackgroundColor3 = Colors.NeonPink, BackgroundTransparency = 0, TextColor3 = Colors.White}, 0)
            CenterTitle.Text = name; CenterIcon.Text = icon
        end
        
        -- ===== SECTIONS =====
        local Sections = {}
        
        function Sections:AddSection(name)
            local SectionFrame = create("Frame", {
                Parent = Page, BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0,
            })
            local SectionList = create("UIListLayout", {
                Parent = SectionFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1),
            })
            
            -- Header
            local SectionHeader = create("Frame", {
                Parent = SectionFrame, BackgroundColor3 = Colors.NeonPink,
                BackgroundTransparency = 0.85, Size = UDim2.new(1, 0, 0, 16), BorderSizePixel = 0,
            })
            create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = SectionHeader})
            create("TextLabel", {
                Parent = SectionHeader, BackgroundTransparency = 1,
                Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.94, 0, 1, 0),
                Font = FONT.Header, Text = name, TextColor3 = Colors.White, TextSize = 8,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            local function UpdateSize()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
            end
            SectionFrame.ChildAdded:Connect(UpdateSize)
            SectionFrame.ChildRemoved:Connect(UpdateSize)
            
            local Elements = {}
            
            local function CreateElement(height)
                height = height or 22
                local el = create("TextButton", {
                    Parent = SectionFrame, BackgroundColor3 = Colors.ContainerBg,
                    Size = UDim2.new(1, 0, 0, height), AutoButtonColor = false,
                    Text = "", BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = el})
                el.MouseEnter:Connect(function() Tween(el, {BackgroundColor3 = Color3.fromRGB(25, 25, 38)}, 0.08) end)
                el.MouseLeave:Connect(function() Tween(el, {BackgroundColor3 = Colors.ContainerBg}, 0.08) end)
                return el
            end
            
            -- ===== TOGGLE =====
            function Elements:AddToggle(name, default, callback)
                default = default or false
                local toggled = default
                local btn = CreateElement()
                
                create("TextLabel", {
                    Parent = btn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.6, 0, 1, 0),
                    Font = FONT.Text, Text = name, TextColor3 = Colors.Text,
                    TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local track = create("Frame", {
                    Parent = btn, BackgroundColor3 = Colors.ToggleOff, BorderSizePixel = 0,
                    Position = UDim2.new(0.78, 0, 0.5, -6), Size = UDim2.new(0, 24, 0, 12),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})
                
                local dot = create("Frame", {
                    Parent = track, BackgroundColor3 = Colors.White, BorderSizePixel = 0,
                    Position = default and UDim2.new(1, -10, 0.5, -4) or UDim2.new(0, 1, 0.5, -4),
                    Size = UDim2.new(0, 8, 0, 8),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                
                local function SetToggle(state, instant)
                    toggled = state
                    local pos = state and UDim2.new(1, -10, 0.5, -4) or UDim2.new(0, 1, 0.5, -4)
                    if instant then
                        dot.Position = pos
                        track.BackgroundColor3 = state and Colors.NeonPink or Colors.ToggleOff
                    else
                        Tween(dot, {Position = pos}, 0.18, Enum.EasingStyle.Back)
                        Tween(track, {BackgroundColor3 = state and Colors.NeonPink or Colors.ToggleOff}, 0.12)
                    end
                end
                
                if default then SetToggle(true, true) end
                btn.MouseButton1Click:Connect(function() SetToggle(not toggled); callback(toggled) end)
                UpdateSize()
                return {SetState = function(s) SetToggle(s) end}
            end
            
            -- ===== SLIDER =====
            function Elements:AddSlider(name, min, max, default, callback)
                min, max = min or 0, max or 100
                default = math.clamp(default or min, min, max)
                local btn = CreateElement(34)
                
                create("TextLabel", {
                    Parent = btn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0.06, 0), Size = UDim2.new(0.5, 0, 0, 11),
                    Font = FONT.Text, Text = name, TextColor3 = Colors.Text,
                    TextSize = 7, TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local valBox = create("Frame", {
                    Parent = btn, BackgroundColor3 = Colors.InputBg,
                    Position = UDim2.new(0.72, 0, 0.06, 0), Size = UDim2.new(0, 26, 0, 11), BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = valBox})
                local valLabel = create("TextLabel", {
                    Parent = valBox, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
                    Font = FONT.Mono, Text = tostring(default), TextColor3 = Colors.NeonPink, TextSize = 7,
                })
                
                local track = create("Frame", {
                    Parent = btn, BackgroundColor3 = Colors.SliderTrack, BorderSizePixel = 0,
                    Position = UDim2.new(0.06, 0, 0.6, 0), Size = UDim2.new(0.88, 0, 0, 2),
                })
                create("UICorner", {CornerRadius = UDim.new(0, 1), Parent = track})
                
                local pct = (default - min) / (max - min)
                local fill = create("Frame", {
                    Parent = track, BackgroundColor3 = Colors.NeonPink, BorderSizePixel = 0,
                    Size = UDim2.new(pct, 0, 1, 0),
                })
                create("UICorner", {CornerRadius = UDim.new(0, 1), Parent = fill})
                
                local dot = create("Frame", {
                    Parent = fill, BackgroundColor3 = Colors.White, BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.new(0, 8, 0, 8),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                create("UIStroke", {Parent = dot, Color = Colors.NeonPink, Thickness = 1})
                
                local mouse = Players.LocalPlayer:GetMouse()
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
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = true; UpdateValue(inp.Position.X)
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                        UpdateValue(inp.Position.X)
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                
                UpdateSize()
                return {SetValue = function(v) v = math.clamp(v, min, max); fill.Size = UDim2.new((v - min) / (max - min), 0, 1, 0); valLabel.Text = tostring(v) end}
            end
            
            -- ===== DROPDOWN =====
            function Elements:AddDropdown(name, options, callback)
                callback = callback or function() end
                local opened = false
                
                local dropFrame = create("Frame", {
                    Parent = SectionFrame, BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 22), BorderSizePixel = 0,
                })
                create("UIListLayout", {Parent = dropFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1)})
                
                local mainBtn = create("TextButton", {
                    Parent = dropFrame, BackgroundColor3 = Colors.ContainerBg,
                    Size = UDim2.new(1, 0, 0, 22), AutoButtonColor = false,
                    Font = FONT.Text, Text = "  " .. name, TextColor3 = Colors.Text,
                    TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = mainBtn})
                
                local arrow = create("TextLabel", {
                    Parent = mainBtn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.84, 0, 0, 0), Size = UDim2.new(0, 14, 1, 0),
                    Font = FONT.Text, Text = "▾", TextColor3 = Colors.NeonPink, TextSize = 7,
                })
                
                local optFrames = {}
                for _, opt in ipairs(options) do
                    local optBtn = create("TextButton", {
                        Parent = dropFrame, BackgroundColor3 = Colors.InputBg,
                        Size = UDim2.new(1, 0, 0, 20), AutoButtonColor = false,
                        Font = FONT.Text, Text = "  " .. opt, TextColor3 = Colors.TextSecondary,
                        TextSize = 7, TextXAlignment = Enum.TextXAlignment.Left,
                        Visible = false, BorderSizePixel = 0,
                    })
                    create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = optBtn})
                    optBtn.MouseButton1Click:Connect(function()
                        mainBtn.Text = "  " .. opt; callback(opt)
                        opened = false; arrow.Rotation = 0
                        for _, o in ipairs(optFrames) do o.Visible = false end
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 22)}, 0.12)
                        UpdateSize()
                    end)
                    table.insert(optFrames, optBtn)
                end
                
                mainBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        arrow.Rotation = 180
                        for _, o in ipairs(optFrames) do o.Visible = true end
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, dropFrame.UIListLayout.AbsoluteContentSize.Y)}, 0.12)
                    else
                        arrow.Rotation = 0
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 22)}, 0.12)
                        task.wait(0.12)
                        for _, o in ipairs(optFrames) do o.Visible = false end
                    end
                    UpdateSize()
                end)
                
                UpdateSize()
                return {Refresh = function(newOpts)
                    for _, o in ipairs(optFrames) do o:Destroy() end
                    optFrames = {}
                    for _, opt in ipairs(newOpts) do
                        local o = create("TextButton", {
                            Parent = dropFrame, BackgroundColor3 = Colors.InputBg,
                            Size = UDim2.new(1, 0, 0, 20), AutoButtonColor = false,
                            Font = FONT.Text, Text = "  " .. opt, TextColor3 = Colors.TextSecondary,
                            TextSize = 7, TextXAlignment = Enum.TextXAlignment.Left,
                            Visible = opened, BorderSizePixel = 0,
                        })
                        create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = o})
                        o.MouseButton1Click:Connect(function()
                            mainBtn.Text = "  " .. opt; callback(opt)
                            opened = false; arrow.Rotation = 0
                            for _, o2 in ipairs(optFrames) do o2.Visible = false end
                            Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 22)}, 0.12)
                            UpdateSize()
                        end)
                        table.insert(optFrames, o)
                    end
                    if opened then dropFrame.Size = UDim2.new(1, 0, 0, dropFrame.UIListLayout.AbsoluteContentSize.Y) end
                    UpdateSize()
                end}
            end
            
            -- ===== BUTTON =====
            function Elements:AddButton(name, callback)
                local btn = CreateElement()
                create("TextLabel", {
                    Parent = btn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.76, 0, 1, 0),
                    Font = FONT.Text, Text = name, TextColor3 = Colors.Text,
                    TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left,
                })
                create("TextLabel", {
                    Parent = btn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.86, 0, 0, 0), Size = UDim2.new(0, 12, 1, 0),
                    Font = FONT.Body, Text = "→", TextColor3 = Colors.NeonPink, TextSize = 9,
                })
                btn.MouseButton1Click:Connect(function()
                    Tween(btn, {BackgroundColor3 = Colors.NeonPink}, 0.05)
                    task.wait(0.05); Tween(btn, {BackgroundColor3 = Colors.ContainerBg}, 0.1)
                    callback()
                end)
                UpdateSize()
                return {SetText = function(t) btn.TextLabel.Text = t end}
            end
            
            -- ===== LABEL =====
            function Elements:AddLabel(text)
                local lbl = create("TextLabel", {
                    Parent = SectionFrame, BackgroundColor3 = Colors.NeonPink,
                    BackgroundTransparency = 0.85, Size = UDim2.new(1, 0, 0, 16),
                    Font = FONT.Header, Text = "  " .. text, TextColor3 = Colors.White,
                    TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = lbl})
                UpdateSize()
                return {SetText = function(t) lbl.Text = "  " .. t end}
            end
            
            -- ===== NOTIFICATION =====
            function Elements:AddNotification(text, ntype)
                ntype = ntype or "info"
                local cols = {success = Colors.Green, info = Colors.Purple, warning = Colors.Gold}
                local notif = create("Frame", {
                    Parent = RightPanel, BackgroundColor3 = Colors.ContainerBg,
                    Size = UDim2.new(1, 0, 0, 18), BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = notif})
                create("Frame", {
                    Parent = notif, BackgroundColor3 = cols[ntype] or Colors.NeonPink,
                    BorderSizePixel = 0, Size = UDim2.new(0, 2, 1, 0),
                })
                local icon = ntype == "success" and "✓" or ntype == "warning" and "⚠" or "ℹ"
                create("TextLabel", {
                    Parent = notif, BackgroundTransparency = 1,
                    Position = UDim2.new(0.08, 0, 0, 0), Size = UDim2.new(0, 10, 1, 0),
                    Font = FONT.Body, Text = icon, TextColor3 = cols[ntype] or Colors.NeonPink, TextSize = 7,
                })
                create("TextLabel", {
                    Parent = notif, BackgroundTransparency = 1,
                    Position = UDim2.new(0.22, 0, 0, 0), Size = UDim2.new(0.74, 0, 1, 0),
                    Font = FONT.Text, Text = text, TextColor3 = Colors.TextSecondary,
                    TextSize = 6, TextXAlignment = Enum.TextXAlignment.Left,
                })
            end
            
            return Elements
        end
        return Sections
    end
    return Tabs
end

return Library
