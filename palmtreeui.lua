-- ============================================================
-- 🌴 PALMTREE UI — FULL CORE ENGINE 
-- ============================================================

local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local SafeParent = CoreGui 

local ActiveTheme = {
    Accent = Color3.fromRGB(255, 94, 91),
    Cyan = Color3.fromRGB(0, 210, 240),
    Border = Color3.fromRGB(255, 94, 91),
    ContainerBg = Color3.fromRGB(25, 8, 45),
    InputBg = Color3.fromRGB(30, 10, 50),
    Text = Color3.fromRGB(255, 245, 250),
    TextMuted = Color3.fromRGB(180, 150, 195),
    ToggleOff = Color3.fromRGB(50, 20, 70),
    SliderTrack = Color3.fromRGB(40, 15, 60),
}

local ConfigFolder = "PalmTree_Configs"
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local function Tween(obj, props, dur)
    return TweenService:Create(obj, TweenInfo.new(dur or 0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
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

function Library.CreateWindow(title)
    title = title or "PalmTree"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PalmTree_" .. tostring(math.random(10000, 99999))
    ScreenGui.Parent = SafeParent
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Enabled = true
    
    local TestFrame = Instance.new("Frame")
    TestFrame.Parent = ScreenGui
    TestFrame.Size = UDim2.new(0, 540, 0, 340)
    TestFrame.Position = UDim2.new(0.5, -270, 0.5, -170)
    TestFrame.BackgroundColor3 = ActiveTheme.ContainerBg
    TestFrame.BorderSizePixel = 0
    TestFrame.ClipsDescendants = false
    
    local TestCorner = Instance.new("UICorner")
    TestCorner.CornerRadius = UDim.new(0, 10)
    TestCorner.Parent = TestFrame
    
    local TestStroke = Instance.new("UIStroke")
    TestStroke.Color = ActiveTheme.Border
    TestStroke.Thickness = 3
    TestStroke.Parent = TestFrame
    
    -- ===== 📊 STATIC DRAGGABLE STATUS BAR WITH TRANSPARENT BACKGROUND =====
    local StatusBar = Instance.new("Frame")
    StatusBar.Parent = ScreenGui
    StatusBar.Size = UDim2.new(0, 540, 0, 24)
    StatusBar.Position = UDim2.new(0.5, -270, 0.5, 178)
    StatusBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    StatusBar.BackgroundTransparency = 1
    StatusBar.BorderSizePixel = 0
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 6)
    StatusCorner.Parent = StatusBar
    
    local StatusStroke = Instance.new("UIStroke")
    StatusStroke.Color = ActiveTheme.Border
    StatusStroke.Thickness = 1.5
    StatusStroke.Parent = StatusBar
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Parent = StatusBar
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0, 10, 0, 0)
    StatusLabel.Size = UDim2.new(1, -20, 1, 0)
    StatusLabel.Font = Enum.Font.RobotoMono
    StatusLabel.Text = "palmtree.lua | fps: -- | ms: --"
    StatusLabel.TextColor3 = ActiveTheme.Text
    StatusLabel.TextSize = 10
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    MakeDraggable(StatusBar, StatusBar)
    
    local fpsCount = 0
    RunService.RenderStepped:Connect(function(dt)
        fpsCount = math.round(1 / dt)
        local ping = math.round(Stats.PerformanceStats.Ping:GetValue())
        StatusLabel.Text = string.format("palmtree.lua | fps: %d | ms: %d", fpsCount, ping)
        StatusStroke.Color = TestStroke.Color
    end)
    
    -- ===== HEADER =====
    local Header = Instance.new("Frame")
    Header.Parent = TestFrame
    Header.Size = UDim2.new(1, 0, 0, 30)
    Header.BackgroundColor3 = Color3.fromRGB(20, 4, 45)
    Header.BorderSizePixel = 0
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 10)
    HeaderCorner.Parent = Header
    
    local HeaderCover = Instance.new("Frame")
    HeaderCover.Parent = Header
    HeaderCover.BackgroundColor3 = Color3.fromRGB(20, 4, 45)
    HeaderCover.BorderSizePixel = 0
    HeaderCover.Position = UDim2.new(0, 0, 0.5, 0)
    HeaderCover.Size = UDim2.new(1, 0, 0.5, 0)
    
    local Title = Instance.new("TextLabel")
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.04, 0, 0, 0)
    Title.Size = UDim2.new(0.8, 0, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🌴 " .. title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- ===== FIX CLOSE BUTTON PERMANENTLY =====
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = Header
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 94, 91)
    CloseBtn.BackgroundTransparency = 0.8
    CloseBtn.Position = UDim2.new(0.93, 0, 0.15, 0)
    CloseBtn.Size = UDim2.new(0, 22, 0, 22)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 16
    CloseBtn.BorderSizePixel = 0
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 5)
    CloseCorner.Parent = CloseBtn
    
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == Enum.KeyCode.RightShift then
            ScreenGui:Destroy()
        end
    end)
    
    MakeDraggable(TestFrame, Header)
    
    local ContentArea = Instance.new("Frame")
    ContentArea.Parent = TestFrame
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 5, 0, 35)
    ContentArea.Size = UDim2.new(1, -10, 1, -40)
    
    local Sidebar = Instance.new("Frame")
    Sidebar.Parent = ContentArea
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 4, 40)
    Sidebar.BackgroundTransparency = 0.4
    Sidebar.Size = UDim2.new(0, 110, 1, 0)
    Sidebar.BorderSizePixel = 0
    Sidebar.ClipsDescendants = true
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = Sidebar
    
    local SidebarStroke = Instance.new("UIStroke")
    SidebarStroke.Color = ActiveTheme.Border
    SidebarStroke.Transparency = 0.5
    SidebarStroke.Thickness = 1.5
    SidebarStroke.Parent = Sidebar
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Parent = Sidebar
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 3)
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.Parent = Sidebar
    SidebarPadding.PaddingTop = UDim.new(0, 6)
    SidebarPadding.PaddingLeft = UDim.new(0, 5)
    SidebarPadding.PaddingRight = UDim.new(0, 5)
    
    local Center = Instance.new("Frame")
    Center.Parent = ContentArea
    Center.BackgroundColor3 = Color3.fromRGB(20, 4, 40)
    Center.BackgroundTransparency = 0.4
    Center.Position = UDim2.new(0, 115, 0, 0)
    Center.Size = UDim2.new(1, -250, 1, 0)
    Center.BorderSizePixel = 0
    Center.ClipsDescendants = true
    
    local CenterCorner = Instance.new("UICorner")
    CenterCorner.CornerRadius = UDim.new(0, 8)
    CenterCorner.Parent = Center
    
    local CenterStroke = Instance.new("UIStroke")
    CenterStroke.Color = ActiveTheme.Border
    CenterStroke.Transparency = 0.5
    CenterStroke.Thickness = 1.5
    CenterStroke.Parent = Center
    
    local CenterScroll = Instance.new("ScrollingFrame")
    CenterScroll.Parent = Center
    CenterScroll.BackgroundTransparency = 1
    CenterScroll.Size = UDim2.new(1, 0, 1, 0)
    CenterScroll.BorderSizePixel = 0
    CenterScroll.ScrollBarThickness = 3
    CenterScroll.ScrollBarImageColor3 = ActiveTheme.Accent
    CenterScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local ScrollPadding = Instance.new("UIPadding")
    ScrollPadding.Parent = CenterScroll
    ScrollPadding.PaddingLeft = UDim.new(0, 4)
    ScrollPadding.PaddingRight = UDim.new(0, 4)
    ScrollPadding.PaddingTop = UDim.new(0, 4)
    
    local CenterTitleFrame = Instance.new("Frame")
    CenterTitleFrame.Parent = CenterScroll
    CenterTitleFrame.BackgroundColor3 = ActiveTheme.Accent
    CenterTitleFrame.BackgroundTransparency = 0.8
    CenterTitleFrame.Size = UDim2.new(1, 0, 0, 20)
    CenterTitleFrame.BorderSizePixel = 0
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 6)
    TitleCorner.Parent = CenterTitleFrame
    
    local CenterIcon = Instance.new("TextLabel")
    CenterIcon.Parent = CenterTitleFrame
    CenterIcon.BackgroundTransparency = 1
    CenterIcon.Position = UDim2.new(0.03, 0, 0, 0)
    CenterIcon.Size = UDim2.new(0, 16, 1, 0)
    CenterIcon.Font = Enum.Font.GothamSemibold
    CenterIcon.Text = ""
    CenterIcon.TextSize = 11
    
    local CenterTitle = Instance.new("TextLabel")
    CenterTitle.Parent = CenterTitleFrame
    CenterTitle.BackgroundTransparency = 1
    CenterTitle.Position = UDim2.new(0.13, 0, 0, 0)
    CenterTitle.Size = UDim2.new(0.87, 0, 1, 0)
    CenterTitle.Font = Enum.Font.GothamBold
    CenterTitle.Text = ""
    CenterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    CenterTitle.TextSize = 10
    CenterTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local ScrollContent = Instance.new("Frame")
    ScrollContent.Parent = CenterScroll
    ScrollContent.BackgroundTransparency = 1
    ScrollContent.Position = UDim2.new(0, 0, 0, 25)
    ScrollContent.Size = UDim2.new(1, 0, 0, 0)
    ScrollContent.BorderSizePixel = 0
    
    local ScrollContentList = Instance.new("UIListLayout")
    ScrollContentList.Parent = ScrollContent
    ScrollContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ScrollContentList.Padding = UDim.new(0, 5)
    
    local function UpdateScrollSize()
        ScrollContent.Size = UDim2.new(1, 0, 0, ScrollContentList.AbsoluteContentSize.Y)
        CenterScroll.CanvasSize = UDim2.new(0, 0, 0, ScrollContentList.AbsoluteContentSize.Y + 35)
    end
    
    -- ===== REAL WORKING CONFIGURATION HUB =====
    local RightPanel = Instance.new("Frame")
    RightPanel.Parent = ContentArea
    RightPanel.BackgroundColor3 = Color3.fromRGB(20, 4, 40)
    RightPanel.BackgroundTransparency = 0.4
    RightPanel.Position = UDim2.new(1, -130, 0, 0)
    RightPanel.Size = UDim2.new(0, 130, 1, 0)
    RightPanel.BorderSizePixel = 0
    RightPanel.ClipsDescendants = true
    
    local RightCorner = Instance.new("UICorner")
    RightCorner.CornerRadius = UDim.new(0, 8)
    RightCorner.Parent = RightPanel
    
    local RightStroke = Instance.new("UIStroke")
    RightStroke.Color = ActiveTheme.Border
    RightStroke.Transparency = 0.5
    RightStroke.Thickness = 1.5
    RightStroke.Parent = RightPanel
    
    local RightList = Instance.new("UIListLayout")
    RightList.Parent = RightPanel
    RightList.SortOrder = Enum.SortOrder.LayoutOrder
    RightList.Padding = UDim.new(0, 4)
    
    local RightPadding = Instance.new("UIPadding")
    RightPadding.Parent = RightPanel
    RightPadding.PaddingTop = UDim.new(0, 6)
    RightPadding.PaddingLeft = UDim.new(0, 5)
    RightPadding.PaddingRight = UDim.new(0, 5)
    
    local ConfigHeader = Instance.new("TextLabel")
    ConfigHeader.Parent = RightPanel
    ConfigHeader.BackgroundColor3 = ActiveTheme.Accent
    ConfigHeader.BackgroundTransparency = 0.8
    ConfigHeader.Size = UDim2.new(1, 0, 0, 20)
    ConfigHeader.BorderSizePixel = 0
    ConfigHeader.Font = Enum.Font.GothamBold
    ConfigHeader.Text = "💾 Configs"
    ConfigHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
    ConfigHeader.TextSize = 9
    ConfigHeader.TextXAlignment = Enum.TextXAlignment.Left
    
    local ConfigHeaderCorner = Instance.new("UICorner")
    ConfigHeaderCorner.CornerRadius = UDim.new(0, 6)
    ConfigHeaderCorner.Parent = ConfigHeader
    
    local ConfigInput = Instance.new("TextBox")
    ConfigInput.Parent = RightPanel
    ConfigInput.Size = UDim2.new(1, 0, 0, 24)
    ConfigInput.BackgroundColor3 = ActiveTheme.InputBg
    ConfigInput.BorderSizePixel = 0
    ConfigInput.Font = Enum.Font.Gotham
    ConfigInput.PlaceholderText = "Config Name..."
    ConfigInput.Text = ""
    ConfigInput.TextColor3 = ActiveTheme.Text
    ConfigInput.TextSize = 10
    
    local ConfigInputCorner = Instance.new("UICorner")
    ConfigInputCorner.CornerRadius = UDim.new(0, 4)
    ConfigInputCorner.Parent = ConfigInput
    
    local SaveCfgBtn = Instance.new("TextButton")
    SaveCfgBtn.Parent = RightPanel
    SaveCfgBtn.Size = UDim2.new(1, 0, 0, 22)
    SaveCfgBtn.BackgroundColor3 = ActiveTheme.Accent
    SaveCfgBtn.BorderSizePixel = 0
    SaveCfgBtn.Font = Enum.Font.GothamSemibold
    SaveCfgBtn.Text = "Save Config"
    SaveCfgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SaveCfgBtn.TextSize = 9
    
    local SaveCorner = Instance.new("UICorner")
    SaveCorner.CornerRadius = UDim.new(0, 4)
    SaveCorner.Parent = SaveCfgBtn
    
    local DeleteCfgBtn = Instance.new("TextButton")
    DeleteCfgBtn.Parent = RightPanel
    DeleteCfgBtn.Size = UDim2.new(1, 0, 0, 22)
    DeleteCfgBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
    DeleteCfgBtn.BorderSizePixel = 0
    DeleteCfgBtn.Font = Enum.Font.GothamSemibold
    DeleteCfgBtn.Text = "Delete Config"
    DeleteCfgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DeleteCfgBtn.TextSize = 9
    
    local DeleteCorner = Instance.new("UICorner")
    DeleteCorner.CornerRadius = UDim.new(0, 4)
    DeleteCorner.Parent = DeleteCfgBtn

    local WindowAPI = {Flags = {}, Tabs = {}}
    local allPages = {}
    local allButtons = {}
    
    SaveCfgBtn.MouseButton1Click:Connect(function()
        local name = ConfigInput.Text
        if name ~= "" then
            local data = {}
            for k, v in pairs(WindowAPI.Flags) do
                if type(v) == "table" and v.Color then
                    data[k] = {v.Color.R, v.Color.G, v.Color.B}
                else
                    data[k] = v
                end
            end
            writefile(ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
            WindowAPI.Notify({Content = "Successfully saved config: " .. name})
        end
    end)
    
    DeleteCfgBtn.MouseButton1Click:Connect(function()
        local name = ConfigInput.Text
        if name ~= "" and writefile then
            pcall(function()
                delfile(ConfigFolder .. "/" .. name .. ".json")
                WindowAPI.Notify({Content = "Deleted configuration file."})
            end)
        end
    end)
    
    local NotifHolder = Instance.new("Frame")
    NotifHolder.Parent = ScreenGui
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.AnchorPoint = Vector2.new(1, 1)
    NotifHolder.Position = UDim2.new(1, -10, 1, -10)
    NotifHolder.Size = UDim2.new(0, 200, 0, 200)
    
    local NotifList = Instance.new("UIListLayout")
    NotifList.Parent = NotifHolder
    NotifList.SortOrder = Enum.SortOrder.LayoutOrder
    NotifList.Padding = UDim.new(0, 4)
    NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    
    function WindowAPI.Notify(data)
        local notif = Instance.new("Frame")
        notif.Parent = NotifHolder
        notif.BackgroundColor3 = ActiveTheme.ContainerBg
        notif.Size = UDim2.new(1, 0, 0, 24)
        notif.BorderSizePixel = 0
        
        local nc = Instance.new("UICorner")
        nc.CornerRadius = UDim.new(0, 5)
        nc.Parent = notif
        
        local ns = Instance.new("UIStroke")
        ns.Color = ActiveTheme.Accent
        ns.Transparency = 0.3
        ns.Thickness = 1.5
        ns.Parent = notif
        
        local label = Instance.new("TextLabel")
        label.Parent = notif
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0.08, 0, 0, 0)
        label.Size = UDim2.new(0.88, 0, 1, 0)
        label.Font = Enum.Font.Gotham
        label.Text = data.Content or ""
        label.TextColor3 = ActiveTheme.Text
        label.TextSize = 9
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        task.delay(3, function()
            if notif and notif.Parent then notif:Destroy() end
        end)
    end
    
    local function SelectPage(page, button, icon, title)
        for _, p in ipairs(allPages) do p.Visible = false end
        for _, b in ipairs(allButtons) do
            Tween(b.btn, {BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.3, TextColor3 = ActiveTheme.TextMuted}, 0.12)
        end
        page.Visible = true
        Tween(button.btn, {BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0.1, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.12)
        CenterIcon.Text = icon
        CenterTitle.Text = title
        UpdateScrollSize()
    end
    
    function WindowAPI.Tabs.CreateTab(tabData)
        local name = type(tabData) == "table" and tabData.Name or tabData
        local icon = type(tabData) == "table" and (tabData.Icon or "") or ""
        
        local NavBtn = Instance.new("TextButton")
        NavBtn.Parent = Sidebar
        NavBtn.BackgroundColor3 = ActiveTheme.ContainerBg
        NavBtn.BackgroundTransparency = 0.3
        NavBtn.Size = UDim2.new(1, 0, 0, 24)
        NavBtn.Font = Enum.Font.GothamSemibold
        NavBtn.Text = icon .. "  " .. name
        NavBtn.TextColor3 = ActiveTheme.Text
        NavBtn.TextSize = 10
        NavBtn.TextXAlignment = Enum.TextXAlignment.Left
        NavBtn.AutoButtonColor = false
        NavBtn.BorderSizePixel = 0
        
        local NavCorner = Instance.new("UICorner")
        NavCorner.CornerRadius = UDim.new(0, 6)
        NavCorner.Parent = NavBtn
        
        local NavStroke = Instance.new("UIStroke")
        NavStroke.Color = ActiveTheme.Border
        NavStroke.Transparency = 0.5
        NavStroke.Thickness = 1
        NavStroke.Parent = NavBtn
        
        local Page = Instance.new("Frame")
        Page.Parent = ScrollContent
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 0, 0)
        Page.Visible = false
        Page.BorderSizePixel = 0
        
        local PageList = Instance.new("UIListLayout")
        PageList.Parent = Page
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Padding = UDim.new(0, 2)
        
        local function ResizePage()
            Page.Size = UDim2.new(1, 0, 0, PageList.AbsoluteContentSize.Y)
            UpdateScrollSize()
        end
        Page.ChildAdded:Connect(function() task.wait(0.03); ResizePage() end)
        Page.ChildRemoved:Connect(function() task.wait(0.03); ResizePage() end)
        
        local tabEntry = {btn = NavBtn, page = Page, name = name, icon = icon}
        table.insert(allPages, Page)
        table.insert(allButtons, tabEntry)
        
        NavBtn.MouseButton1Click:Connect(function() SelectPage(Page, tabEntry, icon, name) end)
        if #allPages == 1 then 
            task.spawn(function() task.wait(0.1); SelectPage(Page, tabEntry, icon, name) end)
        end
        
        local Sections = {}
        
        function Sections.AddSection(secName)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Parent = Page
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.BorderSizePixel = 0
            
            local SectionList = Instance.new("UIListLayout")
            SectionList.Parent = SectionFrame
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            SectionList.Padding = UDim.new(0, 2)
            
            local contentHolder = Instance.new("Frame")
            contentHolder.Parent = SectionFrame
            contentHolder.BackgroundTransparency = 1
            contentHolder.Size = UDim2.new(1, 0, 0, 0)
            contentHolder.BorderSizePixel = 0
            
            local contentList = Instance.new("UIListLayout")
            contentList.Parent = contentHolder
            contentList.SortOrder = Enum.SortOrder.LayoutOrder
            contentList.Padding = UDim.new(0, 2)
            
            local function UpdateSectionSize()
                contentHolder.Size = UDim2.new(1, 0, 0, contentList.AbsoluteContentSize.Y)
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
                ResizePage()
            end
            contentHolder.ChildAdded:Connect(function() task.wait(0.03); UpdateSectionSize() end)
            
            local Elements = {}
            
            local function CreateElement(height)
                height = height or 26
                local el = Instance.new("TextButton")
                el.Parent = contentHolder
                el.BackgroundColor3 = ActiveTheme.ContainerBg
                el.BackgroundTransparency = 0.2
                el.Size = UDim2.new(1, 0, 0, height)
                el.AutoButtonColor = false
                el.Text = ""
                el.BorderSizePixel = 0
                
                local ec = Instance.new("UICorner")
                ec.CornerRadius = UDim.new(0, 6)
                ec.Parent = el
                
                local es = Instance.new("UIStroke")
                es.Color = ActiveTheme.Border
                es.Transparency = 0.6
                es.Thickness = 0.8
                es.Parent = el
                
                el.MouseEnter:Connect(function() Tween(el, {BackgroundColor3 = Color3.fromRGB(40, 15, 60), BackgroundTransparency = 0.1}, 0.1) end)
                el.MouseLeave:Connect(function() Tween(el, {BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.2}, 0.1) end)
                
                return el
            end
            
            function Elements.AddToggle(data, default, callback)
                local elName, flag, def, cb
                if type(data) == "table" then
                    elName = data.Name; flag = data.Flag; def = data.Default or false; cb = data.Callback or function() end
                else
                    elName = data; def = default or false; cb = callback or function() end
                end
                
                local toggled = def
                local btn = CreateElement()
                if flag then WindowAPI.Flags[flag] = def end
                
                local label = Instance.new("TextLabel")
                label.Parent = btn
                label.BackgroundTransparency = 1
                label.Position = UDim2.new(0.06, 0, 0, 0)
                label.Size = UDim2.new(0.58, 0, 1, 0)
                label.Font = Enum.Font.GothamSemibold
                label.Text = elName
                label.TextColor3 = ActiveTheme.Text
                label.TextSize = 10
                label.TextXAlignment = Enum.TextXAlignment.Left
                
                local track = Instance.new("Frame")
                track.Parent = btn
                track.BackgroundColor3 = ActiveTheme.ToggleOff
                track.Position = UDim2.new(0.76, 0, 0.5, -7)
                track.Size = UDim2.new(0, 30, 0, 14)
                
                local tc = Instance.new("UICorner")
                tc.CornerRadius = UDim.new(1, 0)
                tc.Parent = track
                
                local dot = Instance.new("Frame")
                dot.Parent = track
                dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                dot.Position = def and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
                dot.Size = UDim2.new(0, 10, 0, 10)
                
                local dc = Instance.new("UICorner")
                dc.CornerRadius = UDim.new(1, 0)
                dc.Parent = dot
                
                local ds = Instance.new("UIStroke")
                ds.Color = ActiveTheme.Accent
                ds.Thickness = 1.5
                ds.Parent = dot
                
                local function SetToggle(state, instant)
                    toggled = state
                    if flag then WindowAPI.Flags[flag] = state end
                    local pos = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
                    if instant then
                        dot.Position = pos
                        track.BackgroundColor3 = state and ActiveTheme.Accent or ActiveTheme.ToggleOff
                    else
                        Tween(dot, {Position = pos}, 0.25, Enum.EasingStyle.Back)
                        Tween(track, {BackgroundColor3 = state and ActiveTheme.Accent or ActiveTheme.ToggleOff}, 0.15)
                    end
                    cb(state)
                end
                
                if def then SetToggle(true, true) end
                btn.MouseButton1Click:Connect(function() SetToggle(not toggled) end)
                
                UpdateSectionSize()
                return {SetState = function(s) SetToggle(s) end, Flag = flag}
            end
            
            function Elements.AddSlider(data, min, max, default, callback)
                local elName, flag, mn, mx, def, cb
                if type(data) == "table" then
                    elName = data.Name; flag = data.Flag; mn = data.Min or 0; mx = data.Max or 100; def = data.Default or mn; cb = data.Callback or function() end
                else
                    elName = data; mn = min or 0; mx = max or 100; def = default or mn; cb = callback or function() end
                end
                def = math.clamp(def, mn, mx)
                local currentValue = def
                local btn = CreateElement(38)
                if flag then WindowAPI.Flags[flag] = def end
                
                local label = Instance.new("TextLabel")
                label.Parent = btn
                label.BackgroundTransparency = 1
                label.Position = UDim2.new(0.06, 0, 0.05, 0)
                label.Size = UDim2.new(0.5, 0, 0, 13)
                label.Font = Enum.Font.GothamSemibold
                label.Text = elName
                label.TextColor3 = ActiveTheme.Text
                label.TextSize = 9
                label.TextXAlignment = Enum.TextXAlignment.Left
                
                local valBox = Instance.new("Frame")
                valBox.Parent = btn
                valBox.BackgroundColor3 = ActiveTheme.InputBg
                valBox.Position = UDim2.new(0.7, 0, 0.05, 0)
                valBox.Size = UDim2.new(0, 36, 0, 13)
                
                local vc = Instance.new("UICorner")
                vc.CornerRadius = UDim.new(0, 4)
                vc.Parent = valBox
                
                local valLabel = Instance.new("TextLabel")
                valLabel.Parent = valBox
                valLabel.BackgroundTransparency = 1
                valLabel.Size = UDim2.new(1, 0, 1, 0)
                valLabel.Font = Enum.Font.RobotoMono
                valLabel.Text = tostring(def)
                valLabel.TextColor3 = ActiveTheme.Accent
                valLabel.TextSize = 8
                
                local track = Instance.new("Frame")
                track.Parent = btn
                track.BackgroundColor3 = ActiveTheme.SliderTrack
                track.Position = UDim2.new(0.06, 0, 0.6, 0)
                track.Size = UDim2.new(0.88, 0, 0, 4)
                
                local trc = Instance.new("UICorner")
                trc.CornerRadius = UDim.new(0, 2)
                trc.Parent = track
                
                local fill = Instance.new("Frame")
                fill.Parent = track
                fill.BackgroundColor3 = ActiveTheme.Accent
                fill.Size = UDim2.new((def - mn) / (mx - mn), 0, 1, 0)
                
                local fc = Instance.new("UICorner")
                fc.CornerRadius = UDim.new(0, 2)
                fc.Parent = fill
                
                local dot = Instance.new("Frame")
                dot.Parent = fill
                dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                dot.AnchorPoint = Vector2.new(1, 0.5)
                dot.Position = UDim2.new(1, 0, 0.5, 0)
                dot.Size = UDim2.new(0, 11, 0, 11)
                
                local dc = Instance.new("UICorner")
                dc.CornerRadius = UDim.new(1, 0)
                dc.Parent = dot
                
                local ds = Instance.new("UIStroke")
                ds.Color = ActiveTheme.Accent
                ds.Thickness = 2
                ds.Parent = dot
                
                local dragging = false
                
                local function SetSliderValue(val, instant)
                    val = math.clamp(val, mn, mx)
                    currentValue = val
                    if flag then WindowAPI.Flags[flag] = val end
                    local p = (val - mn) / (mx - mn)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    valLabel.Text = tostring(val)
                    if not instant then cb(val) end
                end
                
                track.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        local relX = math.clamp(inp.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                        SetSliderValue(math.floor(mn + (mx - mn) * (relX / track.AbsoluteSize.X)))
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(inp)
                    if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                        local relX = math.clamp(inp.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                        SetSliderValue(math.floor(mn + (mx - mn) * (relX / track.AbsoluteSize.X)))
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                
                UpdateSectionSize()
                return {SetValue = function(v) SetSliderValue(v) end, Flag = flag}
            end
            
            function Elements.AddDropdown(name, options, callback)
                callback = callback or function() end
                local opened = false
                
                local dropFrame = Instance.new("Frame")
                dropFrame.Parent = contentHolder
                dropFrame.BackgroundTransparency = 1
                dropFrame.Size = UDim2.new(1, 0, 0, 26)
                dropFrame.ZIndex = 10
                
                local dropList = Instance.new("UIListLayout")
                dropList.Parent = dropFrame
                dropList.SortOrder = Enum.SortOrder.LayoutOrder
                dropList.Padding = UDim.new(0, 2)
                
                local mainBtn = Instance.new("TextButton")
                mainBtn.Parent = dropFrame
                mainBtn.BackgroundColor3 = ActiveTheme.ContainerBg
                mainBtn.BackgroundTransparency = 0.2
                mainBtn.Size = UDim2.new(1, 0, 0, 26)
                mainBtn.AutoButtonColor = false
                mainBtn.Font = Enum.Font.GothamSemibold
                mainBtn.Text = "  " .. name
                mainBtn.TextColor3 = ActiveTheme.Text
                mainBtn.TextSize = 10
                mainBtn.TextXAlignment = Enum.TextXAlignment.Left
                mainBtn.ZIndex = 10
                
                local mc = Instance.new("UICorner")
                mc.CornerRadius = UDim.new(0, 6)
                mc.Parent = mainBtn
                
                local arrow = Instance.new("TextLabel")
                arrow.Parent = mainBtn
                arrow.BackgroundTransparency = 1
                arrow.Position = UDim2.new(0.85, 0, 0, 0)
                arrow.Size = UDim2.new(0, 18, 1, 0)
                arrow.Font = Enum.Font.GothamSemibold
                arrow.Text = "▾"
                arrow.TextColor3 = ActiveTheme.Accent
                arrow.TextSize = 10
                arrow.ZIndex = 11
                
                local optFrames = {}
                for _, opt in ipairs(options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Parent = dropFrame
                    optBtn.BackgroundColor3 = ActiveTheme.InputBg
                    optBtn.Size = UDim2.new(1, 0, 0, 24)
                    optBtn.AutoButtonColor = false
                    optBtn.Font = Enum.Font.Gotham
                    optBtn.Text = "   " .. opt
                    optBtn.TextColor3 = ActiveTheme.Text
                    optBtn.TextSize = 9
                    optBtn.TextXAlignment = Enum.TextXAlignment.Left
                    optBtn.Visible = false
                    optBtn.ZIndex = 12
                    
                    local oc = Instance.new("UICorner")
                    oc.CornerRadius = UDim.new(0, 5)
                    oc.Parent = optBtn
                    
                    optBtn.MouseButton1Click:Connect(function()
                        mainBtn.Text = "  " .. opt
                        callback(opt)
                        opened = false
                        arrow.Rotation = 0
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
                        local o = Instance.new("TextButton")
                        o.Parent = dropFrame
                        o.BackgroundColor3 = ActiveTheme.InputBg
                        o.Size = UDim2.new(1, 0, 0, 24)
                        o.AutoButtonColor = false
                        o.Font = Enum.Font.Gotham
                        o.Text = "   " .. opt
                        o.TextColor3 = ActiveTheme.Text
                        o.TextSize = 9
                        o.TextXAlignment = Enum.TextXAlignment.Left
                        o.Visible = opened
                        o.ZIndex = 12
                        
                        local oc = Instance.new("UICorner")
                        oc.CornerRadius = UDim.new(0, 5)
                        oc.Parent = o
                        
                        o.MouseButton1Click:Connect(function()
                            mainBtn.Text = "  " .. opt
                            callback(opt)
                            opened = false
                            arrow.Rotation = 0
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
            
            -- ===== THE NEW COLOR PICKER COMPONENT =====
            function Elements.AddColorPicker(data, defaultColor, callback)
                local cpName, flag
                if type(data) == "table" then
                    cpName = data.Name; flag = data.Flag
                else
                    cpName = data
                end
                
                defaultColor = defaultColor or Color3.fromRGB(255, 255, 255)
                local currentSelection = defaultColor
                if flag then WindowAPI.Flags[flag] = defaultColor end
                
                local btn = CreateElement(26)
                
                local label = Instance.new("TextLabel")
                label.Parent = btn
                label.BackgroundTransparency = 1
                label.Position = UDim2.new(0.06, 0, 0, 0)
                label.Size = UDim2.new(0.6, 0, 1, 0)
                label.Font = Enum.Font.GothamSemibold
                label.Text = cpName
                label.TextColor3 = ActiveTheme.Text
                label.TextSize = 10
                label.TextXAlignment = Enum.TextXAlignment.Left
                
                local ColorDisplay = Instance.new("Frame")
                ColorDisplay.Parent = btn
                ColorDisplay.Size = UDim2.new(0, 24, 0, 14)
                ColorDisplay.Position = UDim2.new(1, -34, 0.5, -7)
                ColorDisplay.BackgroundColor3 = defaultColor
                
                local cdc = Instance.new("UICorner")
                cdc.CornerRadius = UDim.new(0, 4)
                cdc.Parent = ColorDisplay
                
                btn.MouseButton1Click:Connect(function()
                    local randomColor = Color3.fromHSV(math.random(), 0.8, 0.9)
                    currentSelection = randomColor
                    ColorDisplay.BackgroundColor3 = randomColor
                    TestStroke.Color = randomColor
                    StatusStroke.Color = randomColor
                    if flag then WindowAPI.Flags[flag] = randomColor end
                    callback(randomColor)
                end)
                
                UpdateSectionSize()
                return {SetColor = function(color)
                    currentSelection = color
                    ColorDisplay.BackgroundColor3 = color
                    if flag then WindowAPI.Flags[flag] = color end
                end, Flag = flag}
            end
            
            function Elements.AddButton(name, callback)
                local btn = CreateElement()
                local label = Instance.new("TextLabel")
                label.Parent = btn
                label.BackgroundTransparency = 1
                label.Position = UDim2.new(0.06, 0, 0, 0)
                label.Size = UDim2.new(0.76, 0, 1, 0)
                label.Font = Enum.Font.GothamSemibold
                label.Text = name
                label.TextColor3 = ActiveTheme.Text
                label.TextSize = 10
                label.TextXAlignment = Enum.TextXAlignment.Left
                
                local arrowIcon = Instance.new("TextLabel")
                arrowIcon.Parent = btn
                arrowIcon.BackgroundTransparency = 1
                arrowIcon.Position = UDim2.new(0.85, 0, 0, 0)
                arrowIcon.Size = UDim2.new(0, 16, 1, 0)
                arrowIcon.Font = Enum.Font.GothamBold
                arrowIcon.Text = "→"
                arrowIcon.TextColor3 = ActiveTheme.Accent
                arrowIcon.TextSize = 12
                
                btn.MouseButton1Click:Connect(function()
                    Tween(btn, {BackgroundColor3 = ActiveTheme.Accent, BackgroundTransparency = 0}, 0.06)
                    task.wait(0.08)
                    Tween(btn, {BackgroundColor3 = ActiveTheme.ContainerBg, BackgroundTransparency = 0.2}, 0.15)
                    callback()
                end)
                
                UpdateSectionSize()
                return {SetText = function(t) label.Text = t end}
            end
            
            function Elements.AddLabel(text)
                local lbl = Instance.new("Frame")
                lbl.Parent = contentHolder
                lbl.BackgroundColor3 = ActiveTheme.Accent
                lbl.BackgroundTransparency = 0.75
                lbl.Size = UDim2.new(1, 0, 0, 18)
                
                local lc = Instance.new("UICorner")
                lc.CornerRadius = UDim.new(0, 6)
                lc.Parent = lbl
                
                local lt = Instance.new("TextLabel")
                lt.Parent = lbl
                lt.BackgroundTransparency = 1
                lt.Position = UDim2.new(0.06, 0, 0, 0)
                lt.Size = UDim2.new(0.94, 0, 1, 0)
                lt.Font = Enum.Font.GothamBold
                lt.Text = "  " .. text
                lt.TextColor3 = Color3.fromRGB(255, 255, 255)
                lt.TextSize = 9
                lt.TextXAlignment = Enum.TextXAlignment.Left
                
                UpdateSectionSize()
                return {SetText = function(t) lt.Text = "  " .. t end}
            end
            
            return Elements
        end
        return Sections
    end
    return WindowAPI
end

return Library
