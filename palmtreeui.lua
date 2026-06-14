-- ============================================
-- 🌴 PALMTREE.LUA v7.1 - MIAMI SUNSET PREMIUM
-- Headers Removed, Colors Maximized
-- ============================================

local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")

-- MIAMI SUNSET COLOR PALETTE
local Colors = {
    -- Primary Accents
    NeonPink = Color3.fromRGB(255, 42, 133),
    HotPink = Color3.fromRGB(255, 20, 120),
    NeonCyan = Color3.fromRGB(0, 229, 255),
    ElectricBlue = Color3.fromRGB(80, 180, 255),
    
    -- Sunset Warmth
    SunsetOrange = Color3.fromRGB(255, 140, 50),
    GoldenYellow = Color3.fromRGB(255, 200, 60),
    Coral = Color3.fromRGB(255, 110, 130),
    
    -- Deep Purples
    DeepPurple = Color3.fromRGB(120, 50, 200),
    Violet = Color3.fromRGB(160, 80, 255),
    MidnightPurple = Color3.fromRGB(40, 20, 80),
    
    -- Text
    White = Color3.fromRGB(255, 255, 255),
    TextBright = Color3.fromRGB(255, 245, 250),
    TextSoft = Color3.fromRGB(220, 200, 230),
    TextMuted = Color3.fromRGB(180, 160, 200),
    
    -- UI Elements
    ToggleOff = Color3.fromRGB(60, 40, 80),
    SliderTrack = Color3.fromRGB(50, 30, 70),
    InputBg = Color3.fromRGB(35, 20, 55),
    ContainerBg = Color3.fromRGB(30, 18, 50),
    ContainerHover = Color3.fromRGB(45, 28, 65),
    
    -- Status
    Green = Color3.fromRGB(100, 255, 150),
    Gold = Color3.fromRGB(255, 210, 70),
    Red = Color3.fromRGB(255, 60, 80),
}

-- Sunset gradients
local Gradients = {
    {Color3.fromRGB(30, 10, 50), Color3.fromRGB(50, 10, 40)},   -- Deep purple to dark pink
    {Color3.fromRGB(40, 15, 55), Color3.fromRGB(30, 20, 60)},   -- Purple shift
    {Color3.fromRGB(50, 10, 40), Color3.fromRGB(60, 20, 30)},   -- Pink to dark red
    {Color3.fromRGB(30, 20, 60), Color3.fromRGB(20, 30, 55)},   -- Purple to blue
    {Color3.fromRGB(20, 30, 55), Color3.fromRGB(30, 15, 50)},   -- Blue back to purple
}

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
    
    local uiName = "PT_" .. math.random(1000, 9999)
    if CoreGui:FindFirstChild(uiName) then CoreGui[uiName]:Destroy() end
    
    local ScreenGui = create("ScreenGui", {
        Name = uiName, Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false, Enabled = true,
    })
    
    -- Notification holder
    local NotifHolder = create("Frame", {
        Parent = ScreenGui, BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -10, 1, -10),
        Size = UDim2.new(0, 200, 0, 0),
        BorderSizePixel = 0,
    })
    create("UIListLayout", {
        Parent = NotifHolder, SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4), VerticalAlignment = Enum.VerticalAlignment.Bottom,
    })
    
    local function SendNotification(text, ntype)
        ntype = ntype or "info"
        local cols = {success = Colors.Green, info = Colors.NeonCyan, warning = Colors.SunsetOrange}
        local notif = create("Frame", {
            Parent = NotifHolder, BackgroundColor3 = Colors.ContainerBg,
            Size = UDim2.new(1, 0, 0, 24), BorderSizePixel = 0,
            BackgroundTransparency = 1,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = notif})
        create("UIStroke", {Parent = notif, Color = cols[ntype] or Colors.NeonPink, Transparency = 0.2, Thickness = 1.5})
        
        -- Left accent bar
        create("Frame", {
            Parent = notif, BackgroundColor3 = cols[ntype] or Colors.NeonPink,
            BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 3, 1, 0),
        })
        
        local icon = ntype == "success" and "✓" or ntype == "warning" and "⚠" or "ℹ"
        create("TextLabel", {
            Parent = notif, BackgroundTransparency = 1,
            Position = UDim2.new(0.08, 0, 0, 0), Size = UDim2.new(0, 16, 1, 0),
            Font = FONT.Body, Text = icon, TextColor3 = cols[ntype] or Colors.NeonPink, TextSize = 10,
        })
        create("TextLabel", {
            Parent = notif, BackgroundTransparency = 1,
            Position = UDim2.new(0.2, 0, 0, 0), Size = UDim2.new(0.76, 0, 1, 0),
            Font = FONT.Text, Text = text, TextColor3 = Colors.TextBright,
            TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left,
        })
        
        Tween(notif, {BackgroundTransparency = 0}, 0.2)
        task.delay(2.5, function()
            if notif and notif.Parent then
                Tween(notif, {BackgroundTransparency = 1}, 0.3)
                task.wait(0.3)
                notif:Destroy()
            end
        end)
    end
    
    -- ===== MAIN WINDOW =====
    local Main = create("Frame", {
        Parent = ScreenGui,
        Position = UDim2.new(0.5, -260, 0.5, -160),
        Size = UDim2.new(0, 520, 0, 320),
        ClipsDescendants = true,
        BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    
    -- GLOW BORDER
    create("UIStroke", {
        Parent = Main, Color = Colors.NeonPink,
        Transparency = 0.3, Thickness = 2,
    })
    
    -- Sunset gradient background
    local BgGradient = create("UIGradient", {
        Parent = Main,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Gradients[1][1]),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 15, 45)),
            ColorSequenceKeypoint.new(1, Gradients[1][2]),
        }),
        Rotation = 135,
    })
    
    local gIdx, gAlpha = 1, 0
    coroutine.wrap(function()
        while BgGradient and BgGradient.Parent do
            local curr = Gradients[gIdx]
            local nxt = Gradients[gIdx % #Gradients + 1]
            gAlpha = gAlpha + 0.002
            if gAlpha >= 1 then gAlpha = 0; gIdx = gIdx % #Gradients + 1 end
            BgGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, curr[1]:Lerp(nxt[1], gAlpha)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 15, 45)),
                ColorSequenceKeypoint.new(1, curr[2]:Lerp(nxt[2], gAlpha)),
            })
            RunService.Heartbeat:Wait()
        end
    end)()
    
    -- ===== HEADER =====
    local Header = create("Frame", {
        Parent = Main, BackgroundColor3 = Colors.MidnightPurple,
        BackgroundTransparency = 0.15, Size = UDim2.new(1, 0, 0, 30),
        BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Header})
    create("Frame", {
        Parent = Header, BackgroundColor3 = Colors.MidnightPurple,
        BackgroundTransparency = 0.15, BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0.5, 0),
    })
    
    -- Palm tree icon
    create("TextLabel", {
        Parent = Header, BackgroundTransparency = 1,
        Position = UDim2.new(0.025, 0, 0, 0), Size = UDim2.new(0, 20, 1, 0),
        Font = FONT.Body, Text = "🌴", TextSize = 14,
    })
    
    -- Title
    create("TextLabel", {
        Parent = Header, BackgroundTransparency = 1,
        Position = UDim2.new(0.09, 0, 0.05, 0), Size = UDim2.new(0.35, 0, 0.45, 0),
        Font = FONT.Script, Text = title, TextColor3 = Colors.White,
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Subtitle
    create("TextLabel", {
        Parent = Header, BackgroundTransparency = 1,
        Position = UDim2.new(0.09, 0, 0.5, 0), Size = UDim2.new(0.25, 0, 0.4, 0),
        Font = FONT.Text, Text = "Miami Sunset", TextColor3 = Colors.SunsetOrange,
        TextSize = 7, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Minimize button
    local MinBtn = create("TextButton", {
        Parent = Header, BackgroundColor3 = Colors.NeonCyan,
        BackgroundTransparency = 0.8, Position = UDim2.new(0.92, 0, 0.12, 0),
        Size = UDim2.new(0, 22, 0, 22), Font = FONT.Header, Text = "−",
        TextColor3 = Colors.White, TextSize = 16, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = MinBtn})
    create("UIStroke", {Parent = MinBtn, Color = Colors.NeonCyan, Transparency = 0.3, Thickness = 1})
    
    -- Close button
    local CloseBtn = create("TextButton", {
        Parent = Header, BackgroundColor3 = Colors.HotPink,
        BackgroundTransparency = 0.8, Position = UDim2.new(0.97, 0, 0.12, 0),
        Size = UDim2.new(0, 22, 0, 22), Font = FONT.Header, Text = "×",
        TextColor3 = Colors.White, TextSize = 16, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = CloseBtn})
    create("UIStroke", {Parent = CloseBtn, Color = Colors.HotPink, Transparency = 0.3, Thickness = 1})
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {BackgroundTransparency = 0.3, BackgroundColor3 = Colors.Red}, 0.1)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {BackgroundTransparency = 0.8, BackgroundColor3 = Colors.HotPink}, 0.1)
    end)
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
    
    -- ===== CONTENT AREA =====
    ContentArea = create("Frame", {
        Parent = Main, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.094, 0),
        Size = UDim2.new(1, 0, 0.906, 0),
        BorderSizePixel = 0,
    })
    
    -- ===== LEFT SIDEBAR =====
    local LeftSidebar = create("Frame", {
        Parent = ContentArea, BackgroundColor3 = Colors.MidnightPurple,
        BackgroundTransparency = 0.5, Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 120, 1, 0), BorderSizePixel = 0, ClipsDescendants = true,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = LeftSidebar})
    create("UIStroke", {Parent = LeftSidebar, Color = Colors.Violet, Transparency = 0.3, Thickness = 1.5})
    
    create("UIListLayout", {
        Parent = LeftSidebar, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3),
    })
    create("UIPadding", {
        Parent = LeftSidebar, PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
    })
    
    -- ===== CENTER SCROLLING =====
    local Center = create("Frame", {
        Parent = ContentArea, BackgroundColor3 = Colors.MidnightPurple,
        BackgroundTransparency = 0.5, Position = UDim2.new(0.24, 0, 0, 0),
        Size = UDim2.new(0, 230, 1, 0), BorderSizePixel = 0, ClipsDescendants = true,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Center})
    create("UIStroke", {Parent = Center, Color = Colors.Violet, Transparency = 0.3, Thickness = 1.5})
    
    local CenterScroll = create("ScrollingFrame", {
        Parent = Center, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = Colors.NeonPink,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
    })
    
    create("UIPadding", {
        Parent = CenterScroll,
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        PaddingTop = UDim.new(0, 4),
    })
    
    -- Title bar
    local CenterTitleFrame = create("Frame", {
        Parent = CenterScroll, BackgroundColor3 = Colors.NeonPink,
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
        Font = FONT.Header, Text = "Combat", TextColor3 = Colors.White,
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Content
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
    
    -- ===== RIGHT PANEL =====
    local RightPanel = create("Frame", {
        Parent = ContentArea, BackgroundColor3 = Colors.MidnightPurple,
        BackgroundTransparency = 0.5, Position = UDim2.new(0.7, 0, 0, 0),
        Size = UDim2.new(0, 150, 1, 0), BorderSizePixel = 0, ClipsDescendants = true,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = RightPanel})
    create("UIStroke", {Parent = RightPanel, Color = Colors.Violet, Transparency = 0.3, Thickness = 1.5})
    
    create("UIListLayout", {
        Parent = RightPanel, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4),
    })
    create("UIPadding", {
        Parent = RightPanel, PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
    })
    
    -- Config header
    local ConfigHeader = create("Frame", {
        Parent = RightPanel, BackgroundColor3 = Colors.NeonCyan,
        BackgroundTransparency = 0.8, Size = UDim2.new(1, 0, 0, 20), BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ConfigHeader})
    create("TextLabel", {
        Parent = ConfigHeader, BackgroundTransparency = 1,
        Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.94, 0, 1, 0),
        Font = FONT.Header, Text = "💾 Configs", TextColor3 = Colors.MidnightPurple,
        TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local ConfigInput = create("TextBox", {
        Parent = RightPanel, BackgroundColor3 = Colors.InputBg,
        Size = UDim2.new(1, 0, 0, 22), Font = FONT.Text, PlaceholderText = "Config name...",
        TextColor3 = Colors.White, PlaceholderColor3 = Colors.TextMuted,
        TextSize = 9, ClearTextOnFocus = false, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ConfigInput})
    create("UIStroke", {Parent = ConfigInput, Color = Colors.NeonCyan, Transparency = 0.5, Thickness = 1})
    
    local ConfigBtnFrame = create("Frame", {
        Parent = RightPanel, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 22), BorderSizePixel = 0,
    })
    create("UIListLayout", {
        Parent = ConfigBtnFrame, SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4),
    })
    
    local SaveBtn = create("TextButton", {
        Parent = ConfigBtnFrame, BackgroundColor3 = Colors.NeonPink,
        Size = UDim2.new(0.48, 0, 1, 0), Font = FONT.Header, Text = "Save",
        TextColor3 = Colors.White, TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SaveBtn})
    create("UIStroke", {Parent = SaveBtn, Color = Colors.HotPink, Transparency = 0.3, Thickness = 1})
    
    local LoadBtn = create("TextButton", {
        Parent = ConfigBtnFrame, BackgroundColor3 = Colors.NeonCyan,
        Size = UDim2.new(0.48, 0, 1, 0), Font = FONT.Header, Text = "Refresh",
        TextColor3 = Colors.MidnightPurple, TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = LoadBtn})
    create("UIStroke", {Parent = LoadBtn, Color = Colors.NeonCyan, Transparency = 0.3, Thickness = 1})
    
    local ConfigListFrame = create("ScrollingFrame", {
        Parent = RightPanel, BackgroundColor3 = Colors.InputBg,
        Size = UDim2.new(1, 0, 1, -72), BorderSizePixel = 0,
        ScrollBarThickness = 2, ScrollBarImageColor3 = Colors.NeonPink,
        CanvasSize = UDim2.new(0, 0, 0, 0),
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ConfigListFrame})
    local ConfigListLayout = create("UIListLayout", {
        Parent = ConfigListFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3),
    })
    create("UIPadding", {
        Parent = ConfigListFrame, PaddingTop = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5),
    })
    
    -- Config system
    local allElements = {}
    local elementCounter = 0
    
    local function RefreshConfigList()
        for _, c in ipairs(ConfigListFrame:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        
        local configs = {}
        pcall(function()
            for _, file in ipairs(listfiles(ConfigFolder)) do
                local name = file:match("([^\\/]+)%.json$")
                if name then table.insert(configs, name) end
            end
        end)
        
        table.sort(configs)
        
        for _, name in ipairs(configs) do
            local row = create("Frame", {
                Parent = ConfigListFrame, BackgroundColor3 = Colors.ContainerBg,
                Size = UDim2.new(1, 0, 0, 22), BorderSizePixel = 0,
            })
            create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = row})
            create("UIStroke", {Parent = row, Color = Colors.Violet, Transparency = 0.4, Thickness = 1})
            
            local loadBtn = create("TextButton", {
                Parent = row, BackgroundTransparency = 1,
                Position = UDim2.new(0.03, 0, 0, 0), Size = UDim2.new(0.58, 0, 1, 0),
                Font = FONT.Text, Text = "📁 " .. name, TextColor3 = Colors.TextBright,
                TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false,
            })
            loadBtn.MouseButton1Click:Connect(function()
                local success, data = pcall(function()
                    return HttpService:JSONDecode(readfile(ConfigFolder .. "/" .. name .. ".json"))
                end)
                if success and data then
                    for _, element in ipairs(allElements) do
                        if data[element.id] ~= nil and element.set then
                            element.set(data[element.id])
                        end
                    end
                    SendNotification("Loaded: " .. name, "success")
                end
            end)
            
            local delBtn = create("TextButton", {
                Parent = row, BackgroundColor3 = Colors.Red,
                BackgroundTransparency = 0.7, Position = UDim2.new(0.74, 0, 0.1, 0),
                Size = UDim2.new(0, 18, 0, 16), Font = FONT.Header, Text = "×",
                TextColor3 = Colors.White, TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0,
            })
            create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = delBtn})
            delBtn.MouseButton1Click:Connect(function()
                pcall(function() delfile(ConfigFolder .. "/" .. name .. ".json") end)
                RefreshConfigList()
                SendNotification("Deleted: " .. name, "warning")
            end)
        end
        
        ConfigListFrame.CanvasSize = UDim2.new(0, 0, 0, ConfigListLayout.AbsoluteContentSize.Y + 10)
    end
    
    SaveBtn.MouseButton1Click:Connect(function()
        local name = ConfigInput.Text
        if name == "" or name:match("^%s*$") then
            SendNotification("Enter a config name!", "warning")
            return
        end
        
        local data = {}
        for _, element in ipairs(allElements) do
            if element.get then
                data[element.id] = element.get()
            end
        end
        
        pcall(function()
            writefile(ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
        end)
        
        RefreshConfigList()
        SendNotification("Saved: " .. name, "success")
    end)
    
    LoadBtn.MouseButton1Click:Connect(function() RefreshConfigList() end)
    RefreshConfigList()
    
    -- Keybind toggle
    UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == Enum.KeyCode.RightShift then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    -- ===== TAB SYSTEM =====
    local Tabs = {}
    local allPages = {}
    local allButtons = {}
    
    local function SelectPage(page, button, icon, title)
        for _, p in ipairs(allPages) do p.Visible = false end
        for _, b in ipairs(allButtons) do
            Tween(b, {
                BackgroundColor3 = Colors.ContainerBg,
                BackgroundTransparency = 1,
                TextColor3 = Colors.TextMuted,
            }, 0.15)
        end
        
        page.Visible = true
        Tween(button, {
            BackgroundColor3 = Colors.NeonPink,
            BackgroundTransparency = 0.1,
            TextColor3 = Colors.White,
        }, 0.15)
        
        CenterIcon.Text = icon
        CenterTitle.Text = title
        UpdateScrollSize()
    end
    
    function Tabs:CreateTab(name, icon)
        icon = icon or ""
        
        local NavBtn = create("TextButton", {
            Parent = LeftSidebar, BackgroundColor3 = Colors.ContainerBg,
            BackgroundTransparency = 0.3, Size = UDim2.new(1, 0, 0, 24),
            Font = FONT.Body, RichText = true, Text = icon .. "  " .. name,
            TextColor3 = Colors.TextSoft, TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, BorderSizePixel = 0,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = NavBtn})
        create("UIStroke", {Parent = NavBtn, Color = Colors.Violet, Transparency = 0.4, Thickness = 1})
        
        NavBtn.MouseEnter:Connect(function()
            if allButtons[allPages == page] ~= NavBtn then
                Tween(NavBtn, {BackgroundColor3 = Colors.DeepPurple, BackgroundTransparency = 0.5}, 0.1)
            end
        end)
        NavBtn.MouseLeave:Connect(function()
            if allButtons[allPages == page] ~= NavBtn then
                Tween(NavBtn, {BackgroundColor3 = Colors.ContainerBg, BackgroundTransparency = 0.3}, 0.1)
            end
        end)
        
        local Page = create("Frame", {
            Parent = ScrollContent, BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0), Visible = false, BorderSizePixel = 0,
        })
        local PageList = create("UIListLayout", {
            Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2),
        })
        
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
        
        -- ===== SECTIONS (NO HEADERS) =====
        local Sections = {}
        
        function Sections:AddSection(name)
            local SectionFrame = create("Frame", {
                Parent = Page, BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0,
            })
            local SectionList = create("UIListLayout", {
                Parent = SectionFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2),
            })
            
            local function UpdateSectionSize()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
                ResizePage()
            end
            
            SectionFrame.ChildAdded:Connect(function() task.wait(0.03); UpdateSectionSize() end)
            
            local Elements = {}
            
            local function CreateElement(height)
                height = height or 26
                local el = create("TextButton", {
                    Parent = SectionFrame, BackgroundColor3 = Colors.ContainerBg,
                    BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, height),
                    AutoButtonColor = false, Text = "", BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = el})
                create("UIStroke", {Parent = el, Color = Colors.Violet, Transparency = 0.5, Thickness = 0.8})
                
                el.MouseEnter:Connect(function()
                    Tween(el, {BackgroundColor3 = Colors.ContainerHover, BackgroundTransparency = 0.1}, 0.1)
                    el.UIStroke.Transparency = 0.2
                end)
                el.MouseLeave:Connect(function()
                    Tween(el, {BackgroundColor3 = Colors.ContainerBg, BackgroundTransparency = 0.2}, 0.1)
                    el.UIStroke.Transparency = 0.5
                end)
                
                return el
            end
            
            -- TOGGLE
            function Elements:AddToggle(name, default, callback)
                default = default or false
                local toggled = default
                local btn = CreateElement()
                
                elementCounter = elementCounter + 1
                local elementId = "toggle_" .. elementCounter
                local track, dot
                
                create("TextLabel", {
                    Parent = btn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.58, 0, 1, 0),
                    Font = FONT.Body, Text = name, TextColor3 = Colors.TextBright,
                    TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                track = create("Frame", {
                    Parent = btn, BackgroundColor3 = Colors.ToggleOff, BorderSizePixel = 0,
                    Position = UDim2.new(0.76, 0, 0.5, -7), Size = UDim2.new(0, 30, 0, 14),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})
                create("UIStroke", {Parent = track, Color = Colors.Violet, Transparency = 0.3, Thickness = 1})
                
                dot = create("Frame", {
                    Parent = track, BackgroundColor3 = Colors.White, BorderSizePixel = 0,
                    Position = default and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5),
                    Size = UDim2.new(0, 10, 0, 10),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                create("UIStroke", {Parent = dot, Color = Colors.NeonPink, Transparency = 0, Thickness = 1.5})
                
                local function SetToggle(state, instant)
                    toggled = state
                    local pos = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
                    if instant then
                        dot.Position = pos
                        track.BackgroundColor3 = state and Colors.NeonPink or Colors.ToggleOff
                    else
                        Tween(dot, {Position = pos}, 0.25, Enum.EasingStyle.Back)
                        Tween(track, {BackgroundColor3 = state and Colors.NeonPink or Colors.ToggleOff}, 0.15)
                    end
                    if not instant then
                        SendNotification(name .. ": " .. (state and "ON" or "OFF"), state and "success" or "info")
                    end
                    callback(state)
                end
                
                if default then SetToggle(true, true) end
                btn.MouseButton1Click:Connect(function() SetToggle(not toggled) end)
                
                table.insert(allElements, {
                    id = elementId, get = function() return toggled end,
                    set = function(v) SetToggle(v, true) end,
                })
                
                UpdateSectionSize()
                return {SetState = function(s) SetToggle(s) end}
            end
            
            -- SLIDER
            function Elements:AddSlider(name, min, max, default, callback)
                min, max = min or 0, max or 100
                default = math.clamp(default or min, min, max)
                local btn = CreateElement(38)
                local currentValue = default
                
                elementCounter = elementCounter + 1
                local elementId = "slider_" .. elementCounter
                
                create("TextLabel", {
                    Parent = btn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0.05, 0), Size = UDim2.new(0.5, 0, 0, 13),
                    Font = FONT.Body, Text = name, TextColor3 = Colors.TextBright,
                    TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local valBox = create("Frame", {
                    Parent = btn, BackgroundColor3 = Colors.InputBg,
                    Position = UDim2.new(0.7, 0, 0.05, 0), Size = UDim2.new(0, 36, 0, 13), BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = valBox})
                create("UIStroke", {Parent = valBox, Color = Colors.NeonPink, Transparency = 0.3, Thickness = 1})
                
                local valLabel = create("TextLabel", {
                    Parent = valBox, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
                    Font = FONT.Mono, Text = tostring(default), TextColor3 = Colors.NeonPink, TextSize = 8,
                })
                
                local track = create("Frame", {
                    Parent = btn, BackgroundColor3 = Colors.SliderTrack, BorderSizePixel = 0,
                    Position = UDim2.new(0.06, 0, 0.6, 0), Size = UDim2.new(0.88, 0, 0, 4),
                })
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = track})
                
                local fill = create("Frame", {
                    Parent = track, BackgroundColor3 = Colors.SunsetOrange, BorderSizePixel = 0,
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                })
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = fill})
                create("UIGradient", {
                    Parent = fill, Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Colors.NeonPink),
                        ColorSequenceKeypoint.new(1, Colors.SunsetOrange),
                    }),
                })
                
                local dot = create("Frame", {
                    Parent = fill, BackgroundColor3 = Colors.White, BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.new(0, 11, 0, 11),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                create("UIStroke", {Parent = dot, Color = Colors.NeonPink, Thickness = 2})
                
                local mouse = Players.LocalPlayer:GetMouse()
                local dragging = false
                local lastNotif = 0
                
                local function SetSliderValue(val, instant)
                    val = math.clamp(val, min, max)
                    currentValue = val
                    local p = (val - min) / (max - min)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    valLabel.Text = tostring(val)
                    if not instant then callback(val) end
                end
                
                local function UpdateFromInput(inputX, fromDrag)
                    local relX = math.clamp(inputX - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                    local val = math.floor(min + (max - min) * (relX / track.AbsoluteSize.X))
                    SetSliderValue(val)
                    if fromDrag and tick() - lastNotif > 1 then
                        lastNotif = tick()
                        SendNotification(name .. ": " .. val, "info")
                    end
                end
                
                track.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = true; lastNotif = 0; UpdateFromInput(inp.Position.X, true)
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                        UpdateFromInput(inp.Position.X, true)
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        if dragging then SendNotification(name .. " set to: " .. currentValue, "success") end
                        dragging = false
                    end
                end)
                
                table.insert(allElements, {
                    id = elementId, get = function() return currentValue end,
                    set = function(v) SetSliderValue(v, true); callback(v) end,
                })
                
                UpdateSectionSize()
                return {SetValue = function(v) SetSliderValue(v) end}
            end
            
            -- DROPDOWN
            function Elements:AddDropdown(name, options, callback)
                callback = callback or function() end
                local opened = false
                
                local dropFrame = create("Frame", {
                    Parent = SectionFrame, BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 26), BorderSizePixel = 0,
                })
                local dropList = create("UIListLayout", {
                    Parent = dropFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2),
                })
                
                local mainBtn = create("TextButton", {
                    Parent = dropFrame, BackgroundColor3 = Colors.ContainerBg,
                    BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 26), AutoButtonColor = false,
                    Font = FONT.Body, Text = "  " .. name, TextColor3 = Colors.TextBright,
                    TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = mainBtn})
                create("UIStroke", {Parent = mainBtn, Color = Colors.Violet, Transparency = 0.5, Thickness = 0.8})
                
                local arrow = create("TextLabel", {
                    Parent = mainBtn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.85, 0, 0, 0), Size = UDim2.new(0, 18, 1, 0),
                    Font = FONT.Body, Text = "▾", TextColor3 = Colors.NeonPink, TextSize = 10,
                })
                
                local optFrames = {}
                for _, opt in ipairs(options) do
                    local optBtn = create("TextButton", {
                        Parent = dropFrame, BackgroundColor3 = Colors.InputBg,
                        Size = UDim2.new(1, 0, 0, 24), AutoButtonColor = false,
                        Font = FONT.Text, Text = "   " .. opt, TextColor3 = Colors.TextSoft,
                        TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
                        Visible = false, BorderSizePixel = 0,
                    })
                    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = optBtn})
                    create("UIStroke", {Parent = optBtn, Color = Colors.Violet, Transparency = 0.4, Thickness = 0.8})
                    
                    optBtn.MouseEnter:Connect(function()
                        Tween(optBtn, {TextColor3 = Colors.White, BackgroundColor3 = Colors.DeepPurple}, 0.1)
                    end)
                    optBtn.MouseLeave:Connect(function()
                        Tween(optBtn, {TextColor3 = Colors.TextSoft, BackgroundColor3 = Colors.InputBg}, 0.1)
                    end)
                    
                    optBtn.MouseButton1Click:Connect(function()
                        mainBtn.Text = "  " .. opt
                        callback(opt)
                        SendNotification(name .. ": " .. opt, "info")
                        opened = false; arrow.Rotation = 0
                        for _, o in ipairs(optFrames) do o.Visible = false end
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 26)}, 0.15)
                        UpdateSectionSize()
                    end)
                    table.insert(optFrames, optBtn)
                end
                
                mainBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        arrow.Rotation = 180
                        for _, o in ipairs(optFrames) do o.Visible = true end
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y)}, 0.15)
                    else
                        arrow.Rotation = 0
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 26)}, 0.15)
                        task.wait(0.15)
                        for _, o in ipairs(optFrames) do o.Visible = false end
                    end
                    UpdateSectionSize()
                end)
                
                UpdateSectionSize()
                return {Refresh = function(newOpts)
                    for _, o in ipairs(optFrames) do o:Destroy() end
                    optFrames = {}
                    for _, opt in ipairs(newOpts) do
                        local o = create("TextButton", {
                            Parent = dropFrame, BackgroundColor3 = Colors.InputBg,
                            Size = UDim2.new(1, 0, 0, 24), AutoButtonColor = false,
                            Font = FONT.Text, Text = "   " .. opt, TextColor3 = Colors.TextSoft,
                            TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
                            Visible = opened, BorderSizePixel = 0,
                        })
                        create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = o})
                        create("UIStroke", {Parent = o, Color = Colors.Violet, Transparency = 0.4, Thickness = 0.8})
                        o.MouseButton1Click:Connect(function()
                            mainBtn.Text = "  " .. opt; callback(opt)
                            opened = false; arrow.Rotation = 0
                            for _, o2 in ipairs(optFrames) do o2.Visible = false end
                            Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 26)}, 0.15)
                            UpdateSectionSize()
                        end)
                        table.insert(optFrames, o)
                    end
                    if opened then dropFrame.Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y) end
                    UpdateSectionSize()
                end}
            end
            
            -- TEXTBOX
            function Elements:AddTextBox(name, default, callback)
                default = default or ""
                local btn = CreateElement()
                create("TextLabel", {
                    Parent = btn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.3, 0, 1, 0),
                    Font = FONT.Body, Text = name, TextColor3 = Colors.TextBright,
                    TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
                })
                local textBox = create("TextBox", {
                    Parent = btn, BackgroundColor3 = Colors.InputBg,
                    Position = UDim2.new(0.38, 0, 0.5, -9), Size = UDim2.new(0.56, 0, 0, 18),
                    Font = FONT.Text, Text = default, TextColor3 = Colors.White,
                    PlaceholderColor3 = Colors.TextMuted, TextSize = 9,
                    ClearTextOnFocus = false, BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = textBox})
                create("UIStroke", {Parent = textBox, Color = Colors.NeonCyan, Transparency = 0.4, Thickness = 1})
                textBox.FocusLost:Connect(function(ep) if ep then callback(textBox.Text) end end)
                UpdateSectionSize()
                return {GetText = function() return textBox.Text end, SetText = function(t) textBox.Text = t end}
            end
            
            -- BUTTON
            function Elements:AddButton(name, callback)
                local btn = CreateElement()
                create("TextLabel", {
                    Parent = btn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.76, 0, 1, 0),
                    Font = FONT.Body, Text = name, TextColor3 = Colors.TextBright,
                    TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
                })
                create("TextLabel", {
                    Parent = btn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.85, 0, 0, 0), Size = UDim2.new(0, 16, 1, 0),
                    Font = FONT.Header, Text = "→", TextColor3 = Colors.SunsetOrange, TextSize = 12,
                })
                btn.MouseButton1Click:Connect(function()
                    Tween(btn, {BackgroundColor3 = Colors.SunsetOrange, BackgroundTransparency = 0}, 0.05)
                    Tween(btn.UIStroke, {Color = Colors.GoldenYellow, Transparency = 0}, 0.05)
                    task.wait(0.08)
                    Tween(btn, {BackgroundColor3 = Colors.ContainerBg, BackgroundTransparency = 0.2}, 0.15)
                    Tween(btn.UIStroke, {Color = Colors.Violet, Transparency = 0.5}, 0.15)
                    callback()
                end)
                UpdateSectionSize()
                return {SetText = function(t) btn.TextLabel.Text = t end}
            end
            
            -- LABEL
            function Elements:AddLabel(text)
                local lbl = create("Frame", {
                    Parent = SectionFrame, BackgroundColor3 = Colors.NeonPink,
                    BackgroundTransparency = 0.75, Size = UDim2.new(1, 0, 0, 18), BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = lbl})
                create("UIGradient", {
                    Parent = lbl, Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Colors.NeonPink),
                        ColorSequenceKeypoint.new(1, Colors.SunsetOrange),
                    }),
                    Rotation = 90,
                })
                create("TextLabel", {
                    Parent = lbl, BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.94, 0, 1, 0),
                    Font = FONT.Header, Text = "  " .. text, TextColor3 = Colors.White,
                    TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
                })
                UpdateSectionSize()
                return {SetText = function(t) lbl.TextLabel.Text = "  " .. t end}
            end
            
            return Elements
        end
        return Sections
    end
    
    -- Create Local tab
    local LocalTab = Tabs:CreateTab("Local", "📋")
    local LocalSection = LocalTab:AddSection("Player Info")
    
    local player = Players.LocalPlayer
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    
    local infoPairs = {
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
    }
    
    for _, pair in ipairs(infoPairs) do
        LocalSection:AddLabel(pair[1] .. ": " .. tostring(pair[2]))
    end
    
    return Tabs
end

return Library
