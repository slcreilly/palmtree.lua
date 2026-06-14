-- ============================================
-- 🌴 PALMTREE.LUA v11.5 — GUARANTEED WORKING
-- ============================================

local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")

local Themes = {
    ["Miami Sunset"] = {
        Name = "Miami Sunset",
        Gradient = {{Color3.fromRGB(255, 94, 91), Color3.fromRGB(15, 23, 42)}, {Color3.fromRGB(255, 179, 71), Color3.fromRGB(20, 25, 48)}},
        Accent = Color3.fromRGB(255, 94, 91), Secondary = Color3.fromRGB(122, 92, 250), Cyan = Color3.fromRGB(0, 210, 240),
        Border = Color3.fromRGB(255, 94, 91), ContainerBg = Color3.fromRGB(25, 8, 45), InputBg = Color3.fromRGB(30, 10, 50),
        CardBg = Color3.fromRGB(30, 12, 55), Text = Color3.fromRGB(255, 245, 250), TextMuted = Color3.fromRGB(180, 150, 195),
        ToggleOff = Color3.fromRGB(50, 20, 70), SliderTrack = Color3.fromRGB(40, 15, 60),
    },
}

local ActiveTheme = Themes["Miami Sunset"]
local ActiveThemeName = "Miami Sunset"
local CustomThemes = {}

local FONT = {
    Header = Enum.Font.GothamBold, Body = Enum.Font.GothamSemibold,
    Text = Enum.Font.Gotham, Mono = Enum.Font.RobotoMono, Script = Enum.Font.FredokaOne,
}

local ConfigFolder = "PalmTree_Configs"
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local function create(class, props) local i = Instance.new(class); for k, v in pairs(props) do i[k] = v end; return i end
local function Tween(obj, props, dur) return TweenService:Create(obj, TweenInfo.new(dur or 0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play() end

local function MakeDraggable(gui, dragPart)
    local dragging, startPos, startMouse, input
    dragPart.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging, startPos, startMouse, input = true, gui.Position, inp.Position, inp
            inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then dragging = false end end)
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
    
    -- Clean up old instances
    for _, v in ipairs(CoreGui:GetChildren()) do
        if v.Name == uiName then v:Destroy() end
    end
    
    local ScreenGui = create("ScreenGui", {
        Name = uiName, Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false, Enabled = true,
    })
    
    local allConnections = {}
    local WindowAPI = {}
    local Flags = {}
    local allElements = {}
    local elementCounter = 0
    
    -- Notifications
    local NotifHolder = create("Frame", {Parent = ScreenGui, BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -10, 1, -10), Size = UDim2.new(0, 220, 0, 0), BorderSizePixel = 0, ZIndex = 100})
    create("UIListLayout", {Parent = NotifHolder, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), VerticalAlignment = Enum.VerticalAlignment.Bottom})
    
    function WindowAPI:Notify(data)
        local notif = create("Frame", {Parent = NotifHolder, BackgroundColor3 = ActiveTheme.ContainerBg, Size = UDim2.new(1, 0, 0, 24), BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 100})
        create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = notif})
        create("UIStroke", {Parent = notif, Color = ActiveTheme.Accent, Transparency = 0.3, Thickness = 1.5})
        create("Frame", {Parent = notif, BackgroundColor3 = ActiveTheme.Accent, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(0, 3, 1, 0)})
        create("TextLabel", {Parent = notif, BackgroundTransparency = 1, Position = UDim2.new(0.08, 0, 0, 0), Size = UDim2.new(0.88, 0, 1, 0), Font = FONT.Text, Text = data.Content or "", TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 100})
        Tween(notif, {BackgroundTransparency = 0}, 0.2)
        task.delay(data.Duration or 3, function() if notif and notif.Parent then Tween(notif, {BackgroundTransparency = 1}, 0.3); task.wait(0.3); notif:Destroy() end end)
    end
    
    -- Main window
    local Main = create("Frame", {Parent = ScreenGui, Position = UDim2.new(0.5, -250, 0.5, -150), Size = UDim2.new(0, 500, 0, 300), ClipsDescendants = true, BorderSizePixel = 0, BackgroundColor3 = ActiveTheme.ContainerBg})
    create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    create("UIStroke", {Parent = Main, Color = ActiveTheme.Border, Transparency = 0.4, Thickness = 2})
    
    -- Gradient
    local BgGradient = create("UIGradient", {Parent = Main, Color = ColorSequence.new({ColorSequenceKeypoint.new(0, ActiveTheme.Gradient[1][1]), ColorSequenceKeypoint.new(1, ActiveTheme.Gradient[1][2])}), Rotation = 180})
    
    -- Header
    local Header = create("Frame", {Parent = Main, BackgroundColor3 = Color3.fromRGB(20, 4, 45), BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 30), BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Header})
    create("Frame", {Parent = Header, BackgroundColor3 = Color3.fromRGB(20, 4, 45), BackgroundTransparency = 0.2, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0.5, 0)})
    
    create("TextLabel", {Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0.03, 0, 0, 0), Size = UDim2.new(0, 20, 1, 0), Font = FONT.Body, Text = "🌴", TextSize = 14})
    create("TextLabel", {Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0.1, 0, 0.05, 0), Size = UDim2.new(0.35, 0, 0.45, 0), Font = FONT.Script, Text = title, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left})
    create("TextLabel", {Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0.1, 0, 0.5, 0), Size = UDim2.new(0.3, 0, 0.4, 0), Font = FONT.Text, Text = ActiveThemeName, TextColor3 = ActiveTheme.Accent, TextSize = 7, TextXAlignment = Enum.TextXAlignment.Left})
    
    local MinBtn = create("TextButton", {Parent = Header, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.8, Position = UDim2.new(0.92, 0, 0.15, 0), Size = UDim2.new(0, 22, 0, 22), Font = FONT.Header, Text = "−", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 16, BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = MinBtn})
    
    local CloseBtn = create("TextButton", {Parent = Header, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.8, Position = UDim2.new(0.97, 0, 0.15, 0), Size = UDim2.new(0, 22, 0, 22), Font = FONT.Header, Text = "×", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 16, BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = CloseBtn})
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui.Enabled = false end)
    
    local minimized = false
    local ContentArea
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then ContentArea.Visible = false; Tween(Main, {Size = UDim2.new(0, 500, 0, 30)}, 0.15); MinBtn.Text = "+"
        else ContentArea.Visible = true; Tween(Main, {Size = UDim2.new(0, 500, 0, 300)}, 0.15); MinBtn.Text = "−" end
    end)
    
    MakeDraggable(Main, Header)
    
    ContentArea = create("Frame", {Parent = Main, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0.1, 0), Size = UDim2.new(1, 0, 0.9, 0), BorderSizePixel = 0})
    
    -- Left sidebar
    local LeftSidebar = create("Frame", {Parent = ContentArea, BackgroundColor3 = Color3.fromRGB(20, 4, 40), BackgroundTransparency = 0.4, Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(0, 115, 1, 0), BorderSizePixel = 0, ClipsDescendants = true})
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = LeftSidebar})
    create("UIStroke", {Parent = LeftSidebar, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1.5})
    create("UIListLayout", {Parent = LeftSidebar, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3)})
    create("UIPadding", {Parent = LeftSidebar, PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
    
    -- Center
    local Center = create("Frame", {Parent = ContentArea, BackgroundColor3 = Color3.fromRGB(20, 4, 40), BackgroundTransparency = 0.4, Position = UDim2.new(0.24, 0, 0, 0), Size = UDim2.new(0, 255, 1, 0), BorderSizePixel = 0, ClipsDescendants = true})
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Center})
    create("UIStroke", {Parent = Center, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1.5})
    
    local CenterScroll = create("ScrollingFrame", {Parent = Center, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = ActiveTheme.Accent, CanvasSize = UDim2.new(0, 0, 0, 0)})
    create("UIPadding", {Parent = CenterScroll, PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), PaddingTop = UDim.new(0, 4)})
    
    local CenterTitleFrame = create("Frame", {Parent = CenterScroll, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.8, Size = UDim2.new(1, 0, 0, 20), BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = CenterTitleFrame})
    local CenterIcon = create("TextLabel", {Parent = CenterTitleFrame, BackgroundTransparency = 1, Position = UDim2.new(0.03, 0, 0, 0), Size = UDim2.new(0, 16, 1, 0), Font = FONT.Body, Text = "⚔️", TextSize = 11})
    local CenterTitle = create("TextLabel", {Parent = CenterTitleFrame, BackgroundTransparency = 1, Position = UDim2.new(0.13, 0, 0, 0), Size = UDim2.new(0.87, 0, 1, 0), Font = FONT.Header, Text = "Combat", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left})
    
    local ScrollContent = create("Frame", {Parent = CenterScroll, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0})
    local ScrollContentList = create("UIListLayout", {Parent = ScrollContent, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    
    local function UpdateScrollSize() ScrollContent.Size = UDim2.new(1, 0, 0, ScrollContentList.AbsoluteContentSize.Y); CenterScroll.CanvasSize = UDim2.new(0, 0, 0, ScrollContentList.AbsoluteContentSize.Y + 28) end
    
    -- Right panel
    local RightPanel = create("Frame", {Parent = ContentArea, BackgroundColor3 = Color3.fromRGB(20, 4, 40), BackgroundTransparency = 0.4, Position = UDim2.new(0.765, 0, 0, 0), Size = UDim2.new(0, 115, 1, 0), BorderSizePixel = 0, ClipsDescendants = true})
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = RightPanel})
    create("UIStroke", {Parent = RightPanel, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1.5})
    create("UIListLayout", {Parent = RightPanel, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)})
    create("UIPadding", {Parent = RightPanel, PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
    
    create("TextLabel", {Parent = RightPanel, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.8, Size = UDim2.new(1, 0, 0, 20), BorderSizePixel = 0, Font = FONT.Header, Text = "💾 Configs", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left})
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = RightPanel:FindFirstChildOfClass("TextLabel")})
    
    local ConfigInput = create("TextBox", {Parent = RightPanel, BackgroundColor3 = ActiveTheme.InputBg, Size = UDim2.new(1, 0, 0, 22), Font = FONT.Text, PlaceholderText = "Config name...", TextColor3 = ActiveTheme.Text, PlaceholderColor3 = ActiveTheme.TextMuted, TextSize = 9, ClearTextOnFocus = false, BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ConfigInput}); create("UIStroke", {Parent = ConfigInput, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1})
    
    local ConfigBtnFrame = create("Frame", {Parent = RightPanel, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), BorderSizePixel = 0})
    create("UIListLayout", {Parent = ConfigBtnFrame, SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4)})
    local SaveBtn = create("TextButton", {Parent = ConfigBtnFrame, BackgroundColor3 = ActiveTheme.Accent, Size = UDim2.new(0.48, 0, 1, 0), Font = FONT.Header, Text = "Save", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SaveBtn})
    local LoadBtn = create("TextButton", {Parent = ConfigBtnFrame, BackgroundColor3 = ActiveTheme.Cyan, Size = UDim2.new(0.48, 0, 1, 0), Font = FONT.Header, Text = "Refresh", TextColor3 = Color3.fromRGB(20, 4, 40), TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = LoadBtn})
    
    local ConfigListFrame = create("ScrollingFrame", {Parent = RightPanel, BackgroundColor3 = ActiveTheme.InputBg, Size = UDim2.new(1, 0, 1, -72), BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = ActiveTheme.Accent, CanvasSize = UDim2.new(0, 0, 0, 0)})
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ConfigListFrame})
    local ConfigListLayout = create("UIListLayout", {Parent = ConfigListFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3)})
    create("UIPadding", {Parent = ConfigListFrame, PaddingTop = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
    
    local function RefreshConfigList()
        for _, c in ipairs(ConfigListFrame:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        local configs = {}
        pcall(function() for _, file in ipairs(listfiles(ConfigFolder)) do local n = file:match("([^\\/]+)%.json$"); if n then table.insert(configs, n) end end end)
        table.sort(configs)
        for _, name in ipairs(configs) do
            local row = create("Frame", {Parent = ConfigListFrame, BackgroundColor3 = ActiveTheme.ContainerBg, Size = UDim2.new(1, 0, 0, 22), BorderSizePixel = 0})
            create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = row}); create("UIStroke", {Parent = row, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1})
            local lBtn = create("TextButton", {Parent = row, BackgroundTransparency = 1, Position = UDim2.new(0.03, 0, 0, 0), Size = UDim2.new(0.6, 0, 1, 0), Font = FONT.Text, Text = "📁 " .. name, TextColor3 = ActiveTheme.Text, TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false})
            lBtn.MouseButton1Click:Connect(function()
                local s, d = pcall(function() return HttpService:JSONDecode(readfile(ConfigFolder .. "/" .. name .. ".json")) end)
                if s and d then for _, e in ipairs(allElements) do if d[e.id] ~= nil and e.set then e.set(d[e.id]) end end end
            end)
            local dBtn = create("TextButton", {Parent = row, BackgroundColor3 = Color3.fromRGB(255, 60, 80), BackgroundTransparency = 0.7, Position = UDim2.new(0.75, 0, 0.1, 0), Size = UDim2.new(0, 18, 0, 16), Font = FONT.Header, Text = "×", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0})
            create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = dBtn})
            dBtn.MouseButton1Click:Connect(function() pcall(function() delfile(ConfigFolder .. "/" .. name .. ".json") end); RefreshConfigList() end)
        end
        ConfigListFrame.CanvasSize = UDim2.new(0, 0, 0, ConfigListLayout.AbsoluteContentSize.Y + 10)
    end
    SaveBtn.MouseButton1Click:Connect(function()
        local n = ConfigInput.Text; if n == "" or n:match("^%s*$") then return end
        local d = {}; for _, e in ipairs(allElements) do if e.get then d[e.id] = e.get() end end
        pcall(function() writefile(ConfigFolder .. "/" .. n .. ".json", HttpService:JSONEncode(d)) end); RefreshConfigList()
    end)
    LoadBtn.MouseButton1Click:Connect(function() RefreshConfigList() end)
    RefreshConfigList()
    
    -- Theme
    function WindowAPI:SetTheme(themeName)
        if CustomThemes[themeName] then ActiveTheme = CustomThemes[themeName]
        elseif Themes[themeName] then ActiveTheme = Themes[themeName] end
        ActiveThemeName = themeName
    end
    function WindowAPI:RegisterTheme(name, data) CustomThemes[name] = data; data.Name = name end
    function WindowAPI:ExportTheme() return ActiveTheme end
    function WindowAPI:ImportTheme(data) WindowAPI:RegisterTheme(data.Name or "Custom", data); WindowAPI:SetTheme(data.Name or "Custom") end
    
    -- Keybind toggle
    UserInputService.InputBegan:Connect(function(inp, gpe) if gpe then return end; if inp.KeyCode == Enum.KeyCode.RightShift then ScreenGui.Enabled = not ScreenGui.Enabled end end)
    
    -- Tabs
    local Tabs = {}
    local allPages = {}
    local allButtons = {}
    
    local function SelectPage(page, button, icon, title)
        for _, p in ipairs(allPages) do p.Visible = false end
        for _, b in ipairs(allButtons) do Tween(b.btn, {BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.3, TextColor3 = ActiveTheme.TextMuted}, 0.12) end
        page.Visible = true; Tween(button.btn, {BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.1, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.12)
        CenterIcon.Text = icon; CenterTitle.Text = title; UpdateScrollSize()
    end
    
    function Tabs:CreateTab(tabData)
        local name, icon = type(tabData) == "table" and tabData.Name or tabData, type(tabData) == "table" and (tabData.Icon or "") or ""
        local NavBtn = create("TextButton", {Parent = LeftSidebar, BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.3, Size = UDim2.new(1, 0, 0, 24), Font = FONT.Body, RichText = true, Text = icon .. "  " .. name, TextColor3 = ActiveTheme.Text, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, BorderSizePixel = 0})
        create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = NavBtn}); create("UIStroke", {Parent = NavBtn, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 1})
        
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
            local contentHolder = create("Frame", {Parent = SectionFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), BorderSizePixel = 0})
            local contentList = create("UIListLayout", {Parent = contentHolder, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
            local function UpdateSectionSize() contentHolder.Size = UDim2.new(1, 0, 0, contentList.AbsoluteContentSize.Y); SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y); ResizePage() end
            contentHolder.ChildAdded:Connect(function() task.wait(0.03); UpdateSectionSize() end)
            
            local Elements = {}
            
            local function CreateElement(height)
                height = height or 26
                local el = create("TextButton", {Parent = contentHolder, BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, height), AutoButtonColor = false, Text = "", BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = el})
                create("UIStroke", {Parent = el, Color = ActiveTheme.Border, Transparency = 0.6, Thickness = 0.8})
                el.MouseEnter:Connect(function() Tween(el, {BackgroundColor3 = Color3.fromRGB(40, 15, 60), BackgroundTransparency = 0.1}, 0.1) end)
                el.MouseLeave:Connect(function() Tween(el, {BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.2}, 0.1) end)
                return el
            end
            
            -- Card
            function Elements:AddCard(data)
                local card = create("Frame", {Parent = contentHolder, BackgroundColor3 = ActiveTheme.CardBg or ActiveTheme.ContainerBg, BackgroundTransparency = 0.12, Size = UDim2.new(1, 0, 0, 55), BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = card})
                create("UIStroke", {Parent = card, Color = ActiveTheme.Accent, Transparency = 0.25, Thickness = 1.5})
                if data.Icon then create("TextLabel", {Parent = card, BackgroundTransparency = 1, Position = UDim2.new(0.05, 0, 0.05, 0), Size = UDim2.new(0, 24, 0, 24), Font = FONT.Body, Text = data.Icon, TextSize = 18}) end
                create("TextLabel", {Parent = card, BackgroundTransparency = 1, Position = UDim2.new(data.Icon and 0.18 or 0.05, 0, 0.08, 0), Size = UDim2.new(data.Icon and 0.78 or 0.9, 0, 0, 16), Font = FONT.Header, Text = data.Title or "", TextColor3 = ActiveTheme.Accent, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left})
                create("TextLabel", {Parent = card, BackgroundTransparency = 1, Position = UDim2.new(0.05, 0, 0.42, 0), Size = UDim2.new(0.9, 0, 0, 26), Font = FONT.Text, Text = data.Description or "", TextColor3 = ActiveTheme.TextMuted, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true})
                UpdateSectionSize()
            end
            
            -- Toggle
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
                local dot = create("Frame", {Parent = track, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Position = def and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5), Size = UDim2.new(0, 10, 0, 10)})
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot}); create("UIStroke", {Parent = dot, Color = ActiveTheme.Accent, Thickness = 1.5})
                
                local function SetToggle(state, instant)
                    toggled = state; if flag then Flags[flag] = state end
                    local pos = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
                    if instant then dot.Position = pos; track.BackgroundColor3 = state and ActiveTheme.Accent or ActiveTheme.ToggleOff
                    else Tween(dot, {Position = pos}, 0.25, Enum.EasingStyle.Back); Tween(track, {BackgroundColor3 = state and ActiveTheme.Accent or ActiveTheme.ToggleOff}, 0.15) end
                    cb(state)
                end
                if def then SetToggle(true, true) end
                btn.MouseButton1Click:Connect(function() SetToggle(not toggled) end)
                table.insert(allElements, {id = elementId, get = function() return toggled end, set = function(v) SetToggle(v, true) end})
                UpdateSectionSize()
                return {SetState = function(s) SetToggle(s) end, Flag = flag, SetVisible = function(v) btn.Visible = v; UpdateSectionSize() end, Destroy = function() btn:Destroy(); UpdateSectionSize() end}
            end
            
            -- Slider
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
                local dot = create("Frame", {Parent = fill, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 11, 0, 11)})
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = dot}); create("UIStroke", {Parent = dot, Color = ActiveTheme.Accent, Thickness = 2})
                
                local mouse = Players.LocalPlayer:GetMouse(); local dragging = false
                local function SetSliderValue(val, instant) val = math.clamp(val, mn, mx); currentValue = val; if flag then Flags[flag] = val end; local p = (val - mn) / (mx - mn); fill.Size = UDim2.new(p, 0, 1, 0); valLabel.Text = tostring(val); if not instant then cb(val) end end
                track.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = true; local relX = math.clamp(inp.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X); SetSliderValue(math.floor(mn + (mx - mn) * (relX / track.AbsoluteSize.X))) end end)
                local inputConn = UserInputService.InputChanged:Connect(function(inp) if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local relX = math.clamp(inp.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X); SetSliderValue(math.floor(mn + (mx - mn) * (relX / track.AbsoluteSize.X))) end end)
                table.insert(allConnections, inputConn)
                local endConn = UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
                table.insert(allConnections, endConn)
                table.insert(allElements, {id = elementId, get = function() return currentValue end, set = function(v) SetSliderValue(v, true); cb(v) end})
                UpdateSectionSize()
                return {SetValue = function(v) SetSliderValue(v) end, Flag = flag, SetVisible = function(v) btn.Visible = v; UpdateSectionSize() end, Destroy = function() btn:Destroy(); UpdateSectionSize() end}
            end
            
            -- Dropdown
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
                    optBtn.MouseButton1Click:Connect(function() mainBtn.Text = "  " .. opt; callback(opt); opened = false; arrow.Rotation = 0; for _, o in ipairs(optFrames) do o.Visible = false end; Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 26)}, 0.15); UpdateSectionSize() end)
                    table.insert(optFrames, optBtn)
                end
                mainBtn.MouseButton1Click:Connect(function() opened = not opened; if opened then arrow.Rotation = 180; for _, o in ipairs(optFrames) do o.Visible = true end; Tween(dropFrame, {Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y)}, 0.15) else arrow.Rotation = 0; Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 26)}, 0.15); task.wait(0.15); for _, o in ipairs(optFrames) do o.Visible = false end end; UpdateSectionSize() end)
                UpdateSectionSize()
                return {Refresh = function(no) for _, o in ipairs(optFrames) do o:Destroy() end; optFrames = {}; for _, opt in ipairs(no) do local o = create("TextButton", {Parent = dropFrame, BackgroundColor3 = ActiveTheme.InputBg, Size = UDim2.new(1, 0, 0, 24), AutoButtonColor = false, Font = FONT.Text, Text = "   " .. opt, TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, Visible = opened, BorderSizePixel = 0, ZIndex = 12}); create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = o}); o.MouseButton1Click:Connect(function() mainBtn.Text = "  " .. opt; callback(opt); opened = false; arrow.Rotation = 0; for _, o2 in ipairs(optFrames) do o2.Visible = false end; Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 26)}, 0.15); UpdateSectionSize() end); table.insert(optFrames, o) end; if opened then dropFrame.Size = UDim2.new(1, 0, 0, dropList.AbsoluteContentSize.Y) end; UpdateSectionSize() end}
            end
            
            -- Keybind
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
            
            -- Color Picker
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
            
            -- TextBox
            function Elements:AddTextBox(name, default, callback)
                default = default or ""; local btn = CreateElement()
                create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.3, 0, 1, 0), Font = FONT.Body, Text = name, TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left})
                local tb = create("TextBox", {Parent = btn, BackgroundColor3 = ActiveTheme.InputBg, Position = UDim2.new(0.38, 0, 0.5, -9), Size = UDim2.new(0.56, 0, 0, 18), Font = FONT.Text, Text = default, TextColor3 = ActiveTheme.Text, PlaceholderColor3 = ActiveTheme.TextMuted, TextSize = 9, ClearTextOnFocus = false, BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = tb}); create("UIStroke", {Parent = tb, Color = ActiveTheme.Border, Transparency = 0.4, Thickness = 1})
                tb.FocusLost:Connect(function(ep) if ep then callback(tb.Text) end end)
                UpdateSectionSize()
                return {GetText = function() return tb.Text end, SetText = function(t) tb.Text = t end, SetVisible = function(v) btn.Visible = v; UpdateSectionSize() end, Destroy = function() btn:Destroy(); UpdateSectionSize() end}
            end
            
            -- Button
            function Elements:AddButton(name, callback)
                local btn = CreateElement()
                create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.76, 0, 1, 0), Font = FONT.Body, Text = name, TextColor3 = ActiveTheme.Text, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left})
                create("TextLabel", {Parent = btn, BackgroundTransparency = 1, Position = UDim2.new(0.85, 0, 0, 0), Size = UDim2.new(0, 16, 1, 0), Font = FONT.Header, Text = "→", TextColor3 = ActiveTheme.Accent, TextSize = 12})
                btn.MouseButton1Click:Connect(function() Tween(btn, {BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0}, 0.06); task.wait(0.08); Tween(btn, {BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.2}, 0.15); callback() end)
                UpdateSectionSize()
                return {SetText = function(t) btn.TextLabel.Text = t end, SetVisible = function(v) btn.Visible = v; UpdateSectionSize() end, Destroy = function() btn:Destroy(); UpdateSectionSize() end}
            end
            
            -- Label
            function Elements:AddLabel(text)
                local lbl = create("Frame", {Parent = contentHolder, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.75, Size = UDim2.new(1, 0, 0, 18), BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = lbl})
                local lt = create("TextLabel", {Parent = lbl, BackgroundTransparency = 1, Position = UDim2.new(0.06, 0, 0, 0), Size = UDim2.new(0.94, 0, 1, 0), Font = FONT.Header, Text = "  " .. text, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left})
                UpdateSectionSize()
                return {SetText = function(t) lt.Text = "  " .. t end, Bind = function(fn) coroutine.wrap(function() while lbl and lbl.Parent do lt.Text = "  " .. fn(); RunService.Heartbeat:Wait() end end)() end, SetVisible = function(v) lbl.Visible = v; UpdateSectionSize() end, Destroy = function() lbl:Destroy(); UpdateSectionSize() end}
            end
            
            -- Paragraph
            function Elements:AddParagraph(title, content)
                local p = create("Frame", {Parent = contentHolder, BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 40), BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = p}); create("UIStroke", {Parent = p, Color = ActiveTheme.Border, Transparency = 0.5, Thickness = 0.8})
                create("TextLabel", {Parent = p, BackgroundTransparency = 1, Position = UDim2.new(0.04, 0, 0.05, 0), Size = UDim2.new(0.92, 0, 0, 14), Font = FONT.Header, Text = title, TextColor3 = ActiveTheme.Accent, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left})
                create("TextLabel", {Parent = p, BackgroundTransparency = 1, Position = UDim2.new(0.04, 0, 0.45, 0), Size = UDim2.new(0.92, 0, 0, 18), Font = FONT.Text, Text = content, TextColor3 = ActiveTheme.TextMuted, TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true})
                UpdateSectionSize()
            end
            
            -- Separator
            function Elements:AddSeparator()
                local s = create("Frame", {Parent = contentHolder, BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.6, Size = UDim2.new(1, 0, 0, 2), BorderSizePixel = 0})
                create("UICorner", {CornerRadius = UDim.new(0, 1), Parent = s}); UpdateSectionSize()
            end
            
            return Elements
        end
        return Sections
    end
    
    -- Local tab
    local LocalTab = Tabs:CreateTab({Name = "Local", Icon = "📋"})
    local LocalSection = LocalTab:AddSection("Player Info")
    local player = Players.LocalPlayer; local char = player.Character; local hum = char and char:FindFirstChild("Humanoid")
    for _, pair in ipairs({{"👤 Username", player.Name}, {"🆔 UserId", player.UserId}, {"📅 Age", player.AccountAge .. "d"}, {"⚡ Ping", tostring(math.floor(Stats.PerformanceStats.Ping:GetValue())) .. "ms"}, {"⏰ Time", os.date("%H:%M:%S")}, {"🏃 WalkSpeed", hum and tostring(hum.WalkSpeed) or "N/A"}, {"❤️ Health", hum and tostring(math.floor(hum.Health)) or "N/A"}}) do
        LocalSection:AddLabel(pair[1] .. ": " .. tostring(pair[2]))
    end
    
    -- Status bar
    local StatusBar = create("Frame", {Parent = ScreenGui, BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.3, Position = UDim2.new(0.01, 0, 0.01, 0), Size = UDim2.new(0, 200, 0, 20), BorderSizePixel = 0})
    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = StatusBar}); create("UIStroke", {Parent = StatusBar, Color = ActiveTheme.Border, Transparency = 0.4, Thickness = 1})
    local StatusLabel = create("TextLabel", {Parent = StatusBar, BackgroundTransparency = 1, Position = UDim2.new(0.04, 0, 0, 0), Size = UDim2.new(0.92, 0, 1, 0), Font = FONT.Body, Text = title .. " | " .. ActiveThemeName, TextColor3 = ActiveTheme.Text, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left})
    coroutine.wrap(function() while StatusBar and StatusBar.Parent do local fps = math.floor(1 / (RunService.RenderStepped:Wait() or 0.016)); StatusLabel.Text = title .. " | " .. fps .. " FPS" end end)()
    
    function WindowAPI:SetSize(w, h) Tween(Main, {Size = UDim2.new(0, w, 0, h)}, 0.2) end
    function WindowAPI:Destroy() pcall(function() ScreenGui:Destroy() end) end
    WindowAPI.Flags = Flags
    WindowAPI.OpenThemeEditor = function() WindowAPI:Notify({Content = "Theme editor coming soon!", Type = "info"}) end
    WindowAPI.SetStatusBar = function(data) StatusLabel.Text = table.concat(data, " | ") end
    
    return WindowAPI
end

return Library
