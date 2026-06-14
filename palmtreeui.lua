-- ============================================
-- 🌴 PALMTREE.LUA v5.2 - FULLY FIXED
-- ============================================

local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")

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
    ContainerBg = Color3.fromRGB(20, 20, 32),
    Green = Color3.fromRGB(70, 230, 120),
    Gold = Color3.fromRGB(255, 200, 50),
    Red = Color3.fromRGB(255, 70, 70),
}

-- More vibrant gradients
local Gradients = {
    {Color3.fromRGB(10, 5, 30), Color3.fromRGB(30, 5, 40)},
    {Color3.fromRGB(5, 15, 35), Color3.fromRGB(25, 5, 35)},
    {Color3.fromRGB(15, 5, 30), Color3.fromRGB(20, 10, 45)},
    {Color3.fromRGB(5, 10, 35), Color3.fromRGB(35, 5, 30)},
    {Color3.fromRGB(20, 5, 25), Color3.fromRGB(10, 20, 40)},
}

local FONT = {
    Title = Enum.Font.GothamBlack,
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
    
    -- Notification holder (bottom right)
    local NotifHolder = create("Frame", {
        Parent = ScreenGui, BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -10, 1, -10),
        Size = UDim2.new(0, 190, 0, 0),
        BorderSizePixel = 0,
    })
    local NotifList = create("UIListLayout", {
        Parent = NotifHolder, SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4), VerticalAlignment = Enum.VerticalAlignment.Bottom,
    })
    
    local function SendNotification(text, ntype)
        ntype = ntype or "info"
        local cols = {success = Colors.Green, info = Colors.NeonCyan, warning = Colors.Gold}
        
        local notif = create("Frame", {
            Parent = NotifHolder, BackgroundColor3 = Colors.ContainerBg,
            Size = UDim2.new(1, 0, 0, 24), BorderSizePixel = 0,
            BackgroundTransparency = 1, ClipsDescendants = true,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = notif})
        create("UIStroke", {Parent = notif, Color = cols[ntype] or Colors.NeonPink, Transparency = 0.3, Thickness = 1})
        
        local icon = ntype == "success" and "✓" or ntype == "warning" and "⚠" or "ℹ"
        create("TextLabel", {
            Parent = notif, BackgroundTransparency = 1,
            Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0, 16, 1, 0),
            Font = FONT.Body, Text = icon, TextColor3 = cols[ntype] or Colors.NeonPink, TextSize = 10,
        })
        create("TextLabel", {
            Parent = notif, BackgroundTransparency = 1,
            Position = UDim2.new(0.18, 0, 0, 0), Size = UDim2.new(0.78, 0, 1, 0),
            Font = FONT.Text, Text = text, TextColor3 = Colors.Text,
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
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Main})
    create("UIStroke", {Parent = Main, Color = Colors.NeonPink, Transparency = 0.4, Thickness = 1.5})
    
    -- ===== DYNAMIC GRADIENT BACKGROUND =====
    local BgGradient = create("UIGradient", {
        Parent = Main,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Gradients[1][1]),
            ColorSequenceKeypoint.new(1, Gradients[1][2]),
        }),
        Rotation = 45,
    })
    
    local gIdx, gAlpha = 1, 0
    coroutine.wrap(function()
        while BgGradient and BgGradient.Parent do
            local curr = Gradients[gIdx]
            local nxt = Gradients[gIdx % #Gradients + 1]
            gAlpha = gAlpha + 0.003
            if gAlpha >= 1 then gAlpha = 0; gIdx = gIdx % #Gradients + 1 end
            
            local c1 = curr[1]:Lerp(nxt[1], gAlpha)
            local c2 = curr[2]:Lerp(nxt[2], gAlpha)
            
            BgGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, c1),
                ColorSequenceKeypoint.new(1, c2),
            })
            
            RunService.Heartbeat:Wait()
        end
    end)()
    
    -- ===== HEADER =====
    local Header = create("Frame", {
        Parent = Main, BackgroundColor3 = Color3.fromRGB(10, 10, 20),
        BackgroundTransparency = 0.3, Size = UDim2.new(1, 0, 0, 28),
        BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Header})
    create("Frame", {
        Parent = Header, BackgroundColor3 = Color3.fromRGB(10, 10, 20),
        BackgroundTransparency = 0.3, BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0.5, 0),
    })
    
    create("TextLabel", {
        Parent = Header, BackgroundTransparency = 1,
        Position = UDim2.new(0.03, 0, 0, 0), Size = UDim2.new(0, 18, 1, 0),
        Font = FONT.Body, Text = "🌴", TextSize = 12,
    })
    create("TextLabel", {
        Parent = Header, BackgroundTransparency = 1,
        Position = UDim2.new(0.1, 0, 0, 0), Size = UDim2.new(0.35, 0, 0.5, 0),
        Font = FONT.Script, Text = title, TextColor3 = Colors.White,
        TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
    })
    create("TextLabel", {
        Parent = Header, BackgroundTransparency = 1,
        Position = UDim2.new(0.1, 0, 0.5, 0), Size = UDim2.new(0.25, 0, 0.4, 0),
        Font = FONT.Text, Text = "Miami Sunset", TextColor3 = Colors.NeonPink,
        TextSize = 7, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Minimize button
    local MinBtn = create("TextButton", {
        Parent = Header, BackgroundColor3 = Colors.NeonCyan,
        BackgroundTransparency = 0.85, Position = UDim2.new(0.92, 0, 0.15, 0),
        Size = UDim2.new(0, 20, 0, 20), Font = FONT.Header, Text = "−",
        TextColor3 = Colors.White, TextSize = 14, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = MinBtn})
    
    -- Close button (hides, doesn't destroy)
    local CloseBtn = create("TextButton", {
        Parent = Header, BackgroundColor3 = Colors.Red,
        BackgroundTransparency = 0.85, Position = UDim2.new(0.97, 0, 0.15, 0),
        Size = UDim2.new(0, 20, 0, 20), Font = FONT.Header, Text = "×",
        TextColor3 = Colors.White, TextSize = 14, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = CloseBtn})
    
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
    end)
    
    local minimized = false
    local ContentArea
    
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            ContentArea.Visible = false
            Tween(Main, {Size = UDim2.new(0, 520, 0, 28)}, 0.15)
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
        Position = UDim2.new(0, 0, 0.0875, 0),
        Size = UDim2.new(1, 0, 0.9125, 0),
        BorderSizePixel = 0,
    })
    
    -- ===== LEFT SIDEBAR =====
    local LeftSidebar = create("Frame", {
        Parent = ContentArea, BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.93, Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 120, 1, 0), BorderSizePixel = 0, ClipsDescendants = true,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = LeftSidebar})
    create("UIStroke", {Parent = LeftSidebar, Color = Colors.Purple, Transparency = 0.3, Thickness = 1})
    
    local SidebarList = create("UIListLayout", {
        Parent = LeftSidebar, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2),
    })
    create("UIPadding", {
        Parent = LeftSidebar, PaddingTop = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5),
    })
    
    -- ===== CENTER SCROLLING PANEL =====
    local Center = create("Frame", {
        Parent = ContentArea, BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.93, Position = UDim2.new(0.24, 0, 0, 0),
        Size = UDim2.new(0, 230, 1, 0), BorderSizePixel = 0, ClipsDescendants = true,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Center})
    create("UIStroke", {Parent = Center, Color = Colors.Purple, Transparency = 0.3, Thickness = 1})
    
    local CenterScroll = create("ScrollingFrame", {
        Parent = Center, BackgroundTransparency = 1,
        Size = UDim2.new(1, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2),
        BorderSizePixel = 0, ScrollBarThickness = 2,
        ScrollBarImageColor3 = Colors.NeonPink,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
    })
    
    -- Title inside scroll
    local CenterTitleFrame = create("Frame", {
        Parent = CenterScroll, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18), BorderSizePixel = 0,
    })
    local CenterIcon = create("TextLabel", {
        Parent = CenterTitleFrame, BackgroundTransparency = 1,
        Size = UDim2.new(0, 14, 1, 0), Font = FONT.Body, Text = "⚔️", TextSize = 10,
    })
    local CenterTitle = create("TextLabel", {
        Parent = CenterTitleFrame, BackgroundTransparency = 1,
        Position = UDim2.new(0.1, 0, 0, 0), Size = UDim2.new(0.9, 0, 1, 0),
        Font = FONT.Header, Text = "Combat", TextColor3 = Colors.White,
        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Pages container (ALL pages go here including Local)
    local PagesContainer = create("Frame", {
        Parent = CenterScroll, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0,
    })
    local PagesList = create("UIListLayout", {
        Parent = PagesContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4),
    })
    
    -- Update scroll when pages change
    local function UpdateScroll()
        task.wait()
        local totalHeight = 18 + PagesList.AbsoluteContentSize.Y + 10
        CenterScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(totalHeight, CenterScroll.AbsoluteSize.Y))
    end
    PagesContainer.ChildAdded:Connect(UpdateScroll)
    PagesContainer.ChildRemoved:Connect(UpdateScroll)
    
    -- ===== RIGHT PANEL (CONFIGS) =====
    local RightPanel = create("Frame", {
        Parent = ContentArea, BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.93, Position = UDim2.new(0.7, 0, 0, 0),
        Size = UDim2.new(0, 150, 1, 0), BorderSizePixel = 0, ClipsDescendants = true,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = RightPanel})
    create("UIStroke", {Parent = RightPanel, Color = Colors.Purple, Transparency = 0.3, Thickness = 1})
    
    local RightList = create("UIListLayout", {
        Parent = RightPanel, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3),
    })
    create("UIPadding", {
        Parent = RightPanel, PaddingTop = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5),
    })
    
    -- Config header
    create("TextLabel", {
        Parent = RightPanel, BackgroundColor3 = Colors.NeonCyan,
        BackgroundTransparency = 0.85, Size = UDim2.new(1, 0, 0, 18),
        Font = FONT.Header, Text = "💾 Configs", TextColor3 = Colors.White,
        TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = RightPanel:FindFirstChildOfClass("TextLabel")})
    
    local ConfigInput = create("TextBox", {
        Parent = RightPanel, BackgroundColor3 = Colors.InputBg,
        Size = UDim2.new(1, 0, 0, 20), Font = FONT.Text, PlaceholderText = "Config name...",
        TextColor3 = Colors.White, PlaceholderColor3 = Colors.TextSecondary,
        TextSize = 8, ClearTextOnFocus = false, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ConfigInput})
    
    -- Save/Refresh buttons
    local ConfigBtnFrame = create("Frame", {
        Parent = RightPanel, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20), BorderSizePixel = 0,
    })
    local ConfigBtnList = create("UIListLayout", {
        Parent = ConfigBtnFrame, SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 3),
    })
    
    local SaveBtn = create("TextButton", {
        Parent = ConfigBtnFrame, BackgroundColor3 = Colors.NeonPink,
        Size = UDim2.new(0.48, 0, 1, 0), Font = FONT.Header, Text = "Save",
        TextColor3 = Colors.White, TextSize = 9, AutoButtonColor = false, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = SaveBtn})
    
    local RefreshBtn = create("TextButton", {
        Parent = ConfigBtnFrame, BackgroundColor3 = Colors.NeonCyan,
        Size = UDim2.new(0.48, 0, 1, 0), Font = FONT.Header, Text = "Refresh",
        TextColor3 = Color3.fromRGB(0, 0, 0), TextSize = 9, AutoButtonColor = false, BorderSizePixel = 0,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = RefreshBtn})
    
    -- Config list
    local ConfigListFrame = create("ScrollingFrame", {
        Parent = RightPanel, BackgroundColor3 = Colors.InputBg,
        Size = UDim2.new(1, 0, 1, -68), BorderSizePixel = 0,
        ScrollBarThickness = 2, ScrollBarImageColor3 = Colors.NeonPink,
        CanvasSize = UDim2.new(0, 0, 0, 0),
    })
    create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ConfigListFrame})
    local ConfigListLayout = create("UIListLayout", {
        Parent = ConfigListFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2),
    })
    create("UIPadding", {
        Parent = ConfigListFrame, PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4),
    })
    
    -- ===== CONFIG SYSTEM =====
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
                Size = UDim2.new(1, 0, 0, 20), BorderSizePixel = 0,
            })
            create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = row})
            
            local loadBtn = create("TextButton", {
                Parent = row, BackgroundTransparency = 1,
                Position = UDim2.new(0.02, 0, 0, 0), Size = UDim2.new(0.6, 0, 1, 0),
                Font = FONT.Text, Text = "📁 " .. name, TextColor3 = Colors.Text,
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
                Position = UDim2.new(0.75, 0, 0.1, 0), Size = UDim2.new(0, 18, 0, 16),
                Font = FONT.Header, Text = "×", TextColor3 = Colors.White,
                TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0,
            })
            create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = delBtn})
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
    
    RefreshBtn.MouseButton1Click:Connect(function() RefreshConfigList() end)
    RefreshConfigList()
    
    -- ===== KEYBIND TOGGLE =====
    UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == Enum.KeyCode.RightShift then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    -- ===== TAB SYSTEM =====
    local Tabs = {}
    local allPages = {}  -- Track ALL pages including Local
    local allButtons = {} -- Track ALL buttons including Local
    
    -- Helper to select a page
    local function SelectPage(page, button, icon, title)
        for _, p in ipairs(allPages) do
            p.Visible = false
        end
        for _, b in ipairs(allButtons) do
            Tween(b, {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                TextColor3 = Colors.TextSecondary,
            }, 0.12)
        end
        
        page.Visible = true
        Tween(button, {
            BackgroundColor3 = Colors.NeonPink,
            BackgroundTransparency = 0,
            TextColor3 = Colors.White,
        }, 0.12)
        
        CenterIcon.Text = icon
        CenterTitle.Text = title
        UpdateScroll()
    end
    
    function Tabs:CreateTab(name, icon)
        icon = icon or ""
        
        local NavBtn = create("TextButton", {
            Parent = LeftSidebar, BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22),
            Font = FONT.Text, RichText = true, Text = icon .. " " .. name,
            TextColor3 = Colors.TextSecondary, TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, BorderSizePixel = 0,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = NavBtn})
        
        local Page = create("Frame", {
            Parent = PagesContainer, BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0), Visible = false, BorderSizePixel = 0,
        })
        local PageList = create("UIListLayout", {
            Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2),
        })
        
        -- Track page content changes for scroll
        Page.ChildAdded:Connect(UpdateScroll)
        Page.ChildRemoved:Connect(UpdateScroll)
        
        table.insert(allPages, Page)
        table.insert(allButtons, NavBtn)
        
        NavBtn.MouseButton1Click:Connect(function()
            SelectPage(Page, NavBtn, icon, name)
        end)
        
        -- Auto-select first tab
        if #allPages == 1 then
            SelectPage(Page, NavBtn, icon, name)
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
            
            local function UpdateSectionSize()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
                UpdateScroll()
            end
            SectionFrame.ChildAdded:Connect(UpdateSectionSize)
            SectionFrame.ChildRemoved:Connect(UpdateSectionSize)
            
            local Elements = {}
            
            local function CreateElement(height)
                height = height or 24
                local el = create("TextButton", {
                    Parent = SectionFrame, BackgroundColor3 = Colors.ContainerBg,
                    Size = UDim2.new(1, 0, 0, height), AutoButtonColor = false,
                    Text = "", BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = el})
                el.MouseEnter:Connect(function() Tween(el, {BackgroundColor3 = Color3.fromRGB(30, 30, 44)}, 0.08) end)
                el.MouseLeave:Connect(function() Tween(el, {BackgroundColor3 = Colors.ContainerBg}, 0.08) end)
                return el
            end
            
            -- TOGGLE
            function Elements:AddToggle(name, default, callback)
                default = default or false
                local toggled = default
                local btn = CreateElement()
                
                elementCounter = elementCounter + 1
                local elementId = "toggle_" .. elementCounter
                
                create("TextLabel", {
                    Parent = btn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.6, 0, 1, 0),
                    Font = FONT.Text, Text = name, TextColor3 = Colors.Text,
                    TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local track = create("Frame", {
                    Parent = btn, BackgroundColor3 = Colors.ToggleOff, BorderSizePixel = 0,
                    Position = UDim2.new(0.78, 0, 0.5, -6), Size = UDim2.new(0, 28, 0, 12),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})
                
                local dot = create("Frame", {
                    Parent = track, BackgroundColor3 = Colors.White, BorderSizePixel = 0,
                    Position = default and UDim2.new(1, -11, 0.5, -4.5) or UDim2.new(0, 1, 0.5, -4.5),
                    Size = UDim2.new(0, 9, 0, 9),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                
                local function SetToggle(state, instant)
                    toggled = state
                    local pos = state and UDim2.new(1, -11, 0.5, -4.5) or UDim2.new(0, 1, 0.5, -4.5)
                    if instant then
                        dot.Position = pos
                        track.BackgroundColor3 = state and Colors.NeonPink or Colors.ToggleOff
                    else
                        Tween(dot, {Position = pos}, 0.2, Enum.EasingStyle.Back)
                        Tween(track, {BackgroundColor3 = state and Colors.NeonPink or Colors.ToggleOff}, 0.12)
                    end
                    if not instant then
                        SendNotification(name .. ": " .. (state and "ON" or "OFF"), state and "success" or "info")
                    end
                end
                
                if default then SetToggle(true, true) end
                btn.MouseButton1Click:Connect(function()
                    SetToggle(not toggled)
                    callback(toggled)
                end)
                
                table.insert(allElements, {
                    id = elementId,
                    get = function() return toggled end,
                    set = function(v) SetToggle(v, true); callback(v) end,
                })
                
                UpdateSectionSize()
                return {SetState = function(s) SetToggle(s) end}
            end
            
            -- SLIDER
            function Elements:AddSlider(name, min, max, default, callback)
                min, max = min or 0, max or 100
                default = math.clamp(default or min, min, max)
                local btn = CreateElement(36)
                local currentValue = default
                
                elementCounter = elementCounter + 1
                local elementId = "slider_" .. elementCounter
                
                create("TextLabel", {
                    Parent = btn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0.06, 0), Size = UDim2.new(0.5, 0, 0, 12),
                    Font = FONT.Text, Text = name, TextColor3 = Colors.Text,
                    TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local valBox = create("Frame", {
                    Parent = btn, BackgroundColor3 = Colors.InputBg,
                    Position = UDim2.new(0.72, 0, 0.06, 0), Size = UDim2.new(0, 32, 0, 12), BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = valBox})
                local valLabel = create("TextLabel", {
                    Parent = valBox, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
                    Font = FONT.Mono, Text = tostring(default), TextColor3 = Colors.NeonPink, TextSize = 7,
                })
                
                local track = create("Frame", {
                    Parent = btn, BackgroundColor3 = Colors.SliderTrack, BorderSizePixel = 0,
                    Position = UDim2.new(0.06, 0, 0.6, 0), Size = UDim2.new(0.88, 0, 0, 3),
                })
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = track})
                
                local pct = (default - min) / (max - min)
                local fill = create("Frame", {
                    Parent = track, BackgroundColor3 = Colors.NeonPink, BorderSizePixel = 0,
                    Size = UDim2.new(pct, 0, 1, 0),
                })
                create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = fill})
                
                local dot = create("Frame", {
                    Parent = fill, BackgroundColor3 = Colors.White, BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.new(0, 9, 0, 9),
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot})
                create("UIStroke", {Parent = dot, Color = Colors.NeonPink, Thickness = 1.5})
                
                local mouse = Players.LocalPlayer:GetMouse()
                local dragging = false
                local lastNotif = 0
                
                local function UpdateValue(inputX, fromDrag)
                    local relX = math.clamp(inputX - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                    local p = relX / track.AbsoluteSize.X
                    local val = math.floor(min + (max - min) * p)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    valLabel.Text = tostring(val)
                    currentValue = val
                    callback(val)
                    
                    if fromDrag and tick() - lastNotif > 1 then
                        lastNotif = tick()
                        SendNotification(name .. ": " .. val, "info")
                    end
                end
                
                track.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = true; lastNotif = 0; UpdateValue(inp.Position.X, true)
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                        UpdateValue(inp.Position.X, true)
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        if dragging then SendNotification(name .. " set to: " .. currentValue, "success") end
                        dragging = false
                    end
                end)
                
                table.insert(allElements, {
                    id = elementId,
                    get = function() return currentValue end,
                    set = function(v)
                        v = math.clamp(v, min, max); currentValue = v
                        fill.Size = UDim2.new((v - min) / (max - min), 0, 1, 0)
                        valLabel.Text = tostring(v)
                    end,
                })
                
                UpdateSectionSize()
                return {SetValue = function(v)
                    v = math.clamp(v, min, max); currentValue = v
                    fill.Size = UDim2.new((v - min) / (max - min), 0, 1, 0)
                    valLabel.Text = tostring(v)
                end}
            end
            
            -- DROPDOWN
            function Elements:AddDropdown(name, options, callback)
                callback = callback or function() end
                local opened = false
                
                local dropFrame = create("Frame", {
                    Parent = SectionFrame, BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 24), BorderSizePixel = 0,
                })
                local dropList = create("UIListLayout", {
                    Parent = dropFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1),
                })
                
                local mainBtn = create("TextButton", {
                    Parent = dropFrame, BackgroundColor3 = Colors.ContainerBg,
                    Size = UDim2.new(1, 0, 0, 24), AutoButtonColor = false,
                    Font = FONT.Text, Text = "  " .. name, TextColor3 = Colors.Text,
                    TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = mainBtn})
                
                local arrow = create("TextLabel", {
                    Parent = mainBtn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.86, 0, 0, 0), Size = UDim2.new(0, 16, 1, 0),
                    Font = FONT.Text, Text = "▾", TextColor3 = Colors.NeonPink, TextSize = 8,
                })
                
                local optFrames = {}
                for _, opt in ipairs(options) do
                    local optBtn = create("TextButton", {
                        Parent = dropFrame, BackgroundColor3 = Colors.InputBg,
                        Size = UDim2.new(1, 0, 0, 22), AutoButtonColor = false,
                        Font = FONT.Text, Text = "  " .. opt, TextColor3 = Colors.TextSecondary,
                        TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left,
                        Visible = false, BorderSizePixel = 0,
                    })
                    create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = optBtn})
                    optBtn.MouseButton1Click:Connect(function()
                        mainBtn.Text = "  " .. opt
                        callback(opt)
                        SendNotification(name .. ": " .. opt, "info")
                        opened = false; arrow.Rotation = 0
                        for _, o in ipairs(optFrames) do o.Visible = false end
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 24)}, 0.12)
                        UpdateSectionSize(); UpdateScroll()
                    end)
                    table.insert(optFrames, optBtn)
                end
                
                mainBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        arrow.Rotation = 180
                        for _, o in ipairs(optFrames) do o.Visible = true end
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y)}, 0.12)
                    else
                        arrow.Rotation = 0
                        Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 24)}, 0.12)
                        task.wait(0.12)
                        for _, o in ipairs(optFrames) do o.Visible = false end
                    end
                    UpdateSectionSize(); UpdateScroll()
                end)
                
                UpdateSectionSize()
                return {Refresh = function(newOpts)
                    for _, o in ipairs(optFrames) do o:Destroy() end
                    optFrames = {}
                    for _, opt in ipairs(newOpts) do
                        local o = create("TextButton", {
                            Parent = dropFrame, BackgroundColor3 = Colors.InputBg,
                            Size = UDim2.new(1, 0, 0, 22), AutoButtonColor = false,
                            Font = FONT.Text, Text = "  " .. opt, TextColor3 = Colors.TextSecondary,
                            TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left,
                            Visible = opened, BorderSizePixel = 0,
                        })
                        create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = o})
                        o.MouseButton1Click:Connect(function()
                            mainBtn.Text = "  " .. opt; callback(opt)
                            opened = false; arrow.Rotation = 0
                            for _, o2 in ipairs(optFrames) do o2.Visible = false end
                            Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 24)}, 0.12)
                            UpdateSectionSize(); UpdateScroll()
                        end)
                        table.insert(optFrames, o)
                    end
                    if opened then dropFrame.Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y) end
                    UpdateSectionSize(); UpdateScroll()
                end}
            end
            
            -- TEXTBOX
            function Elements:AddTextBox(name, default, callback)
                default = default or ""
                local btn = CreateElement()
                
                create("TextLabel", {
                    Parent = btn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.32, 0, 1, 0),
                    Font = FONT.Text, Text = name, TextColor3 = Colors.Text,
                    TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local textBox = create("TextBox", {
                    Parent = btn, BackgroundColor3 = Colors.InputBg,
                    Position = UDim2.new(0.4, 0, 0.5, -8), Size = UDim2.new(0.54, 0, 0, 16),
                    Font = FONT.Text, Text = default, TextColor3 = Colors.White,
                    PlaceholderColor3 = Colors.TextSecondary, TextSize = 8,
                    ClearTextOnFocus = false, BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = textBox})
                
                textBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then callback(textBox.Text) end
                end)
                
                UpdateSectionSize()
                return {GetText = function() return textBox.Text end, SetText = function(t) textBox.Text = t end}
            end
            
            -- BUTTON
            function Elements:AddButton(name, callback)
                local btn = CreateElement()
                create("TextLabel", {
                    Parent = btn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.76, 0, 1, 0),
                    Font = FONT.Text, Text = name, TextColor3 = Colors.Text,
                    TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left,
                })
                create("TextLabel", {
                    Parent = btn, BackgroundTransparency = 1,
                    Position = UDim2.new(0.86, 0, 0, 0), Size = UDim2.new(0, 12, 1, 0),
                    Font = FONT.Body, Text = "→", TextColor3 = Colors.NeonPink, TextSize = 10,
                })
                btn.MouseButton1Click:Connect(function()
                    Tween(btn, {BackgroundColor3 = Colors.NeonPink}, 0.05)
                    task.wait(0.05); Tween(btn, {BackgroundColor3 = Colors.ContainerBg}, 0.1)
                    callback()
                end)
                UpdateSectionSize()
                return {SetText = function(t) btn.TextLabel.Text = t end}
            end
            
            -- LABEL
            function Elements:AddLabel(text)
                local lbl = create("TextLabel", {
                    Parent = SectionFrame, BackgroundColor3 = Colors.NeonPink,
                    BackgroundTransparency = 0.85, Size = UDim2.new(1, 0, 0, 16),
                    Font = FONT.Header, Text = "  " .. text, TextColor3 = Colors.White,
                    TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                })
                create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = lbl})
                UpdateSectionSize()
                return {SetText = function(t) lbl.Text = "  " .. t end}
            end
            
            return Elements
        end
        return Sections
    end
    
    -- ===== CREATE LOCAL TAB (as a regular tab) =====
    local LocalTab = Tabs:CreateTab("Local", "📋")
    local LocalSection = LocalTab:AddSection("Player Information")
    
    -- Populate local info
    local function PopulateLocalInfo()
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
            {"🔄 FPS", tostring(math.floor(1 / (RunService.RenderStepped:Wait() or 0.016)))},
            {"⏰ Time", os.date("%H:%M:%S")},
            {"🏃 WalkSpeed", hum and tostring(hum.WalkSpeed) or "N/A"},
            {"🦘 JumpPower", hum and tostring(hum.JumpPower) or "N/A"},
            {"❤️ Health", hum and tostring(math.floor(hum.Health)) or "N/A"},
            {"🔧 Executor", (identifyexecutor and identifyexecutor()) or "Unknown"},
        }
        
        for _, pair in ipairs(infoPairs) do
            LocalSection:AddLabel(pair[1] .. ": " .. tostring(pair[2]))
        end
    end
    
    PopulateLocalInfo()
    
    return Tabs
end

return Library
