-- YENİ NESİL HİLE MENÜSÜ [POPUP, DÜZENLİ, F4'le Aç/Kapat, UI Framework yok, tüm fonksiyonlar TAM] --

-- ## MM2 HİLE TAM ÇALIŞIR MENÜ (DELTA EXECUTOR FRIENDLY, TÜM FONKSİYONLAR AKTİF, YENİ NESİL) ##

--------- KÖK ÇEKİRDEK ---------
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

--------- MENÜ SUNUCU BÖLÜMÜ ---------
local function notify(msg, t)
    local sgui = game:GetService("CoreGui"):FindFirstChild("PROV5_MENUNTFY") or Instance.new("ScreenGui", game:GetService("CoreGui"))
    sgui.Name = "PROV5_MENUNTFY"
    sgui.IgnoreGuiInset = true
    sgui.ResetOnSpawn = false
    local notif = Instance.new("TextLabel", sgui)
    notif.Size = UDim2.fromOffset(370, 38)
    notif.Position = UDim2.new(0.5, -185, 0.12, 0)
    notif.BackgroundColor3 = Color3.fromRGB(44,66,111)
    notif.BorderSizePixel = 0
    notif.BackgroundTransparency = 0.18
    notif.Font = Enum.Font.GothamBlack
    notif.TextColor3 = Color3.fromRGB(232,245,255)
    notif.TextStrokeTransparency = 0.75
    notif.TextSize = 20
    notif.Text = msg
    notif.ZIndex = 170
    notif.ClipsDescendants = true
    game:GetService("Debris"):AddItem(notif, t or 2)
end

-- ÇAKIŞAN MENÜLER SİL, TEK MENÜ KALSIN
for _,v in ipairs(game:GetService("CoreGui"):GetChildren()) do
    if v:IsA("ScreenGui") and (v.Name:find("PROV5HILE") or v.Name:find("MM2MENU") or v.Name == "PROV5MENUV7") then pcall(function()v:Destroy()end) end
end

--------- ANA MENÜ ARAYÜZÜ ---------
local sg = Instance.new("ScreenGui")
sg.Name = "PROV5MENUV7"
sg.IgnoreGuiInset = true
sg.ResetOnSpawn = false
sg.DisplayOrder = 1000
sg.Parent = game:GetService("CoreGui")

local Outer = Instance.new("Frame",sg)
Outer.Name = "MainPane"
Outer.Size = UDim2.fromOffset(635,513)
Outer.Position = UDim2.new(0.5,-317,0.5,-256)
Outer.AnchorPoint = Vector2.new(0.5,0.5)
Outer.BackgroundColor3 = Color3.fromRGB(32,38,57)
Outer.BorderSizePixel = 0
Outer.Visible = false

-- DRAG SUPPORT
do
    local dragging,dragStart,startPos
    Outer.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Outer.Position
        end
        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then dragging = false end
        end)
    end)
    Outer.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement then
            local dragInput=input
            UserInputService.InputChanged:Connect(function(input2)
                if dragging and input2 == dragInput then
                    local delta = input2.Position-dragStart
                    Outer.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
                end
            end)
        end
    end)
end

-- BAŞLIK BARI & MENÜ KONTROL
local topBar = Instance.new("Frame",Outer)
topBar.Size = UDim2.new(1,0,0,52)
topBar.BackgroundColor3 = Color3.fromRGB(72,139,202)
topBar.BorderSizePixel = 0

local titleLbl = Instance.new("TextLabel",topBar)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "MM2 PROV5 HİLE MENÜSÜ 2024"
titleLbl.Size = UDim2.new(1,-160,1,0)
titleLbl.Position = UDim2.new(0,16,0,0)
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 28
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.TextColor3 = Color3.fromRGB(255,255,255)

local toggleBtn = Instance.new("TextButton",topBar)
toggleBtn.Text = "Menüyü Aç/Kapat [F4]"
toggleBtn.Size = UDim2.new(0,160,1,0)
toggleBtn.Position = UDim2.new(1,-160,0,0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(46,71,111)
toggleBtn.TextColor3 = Color3.fromRGB(240,240,255)
toggleBtn.Font = Enum.Font.GothamSemibold
toggleBtn.TextSize = 17
toggleBtn.BorderSizePixel = 0

-- Menü Kapat Aç Fonksiyonu (her zaman çalışır!)
local shown = false
local function setMenuView(state)
    shown = state
    Outer.Visible = shown
    sg.Enabled = shown
end
toggleBtn.MouseButton1Click:Connect(function() setMenuView(not shown) end)
UserInputService.InputBegan:Connect(function(input,gp)
    if not gp and input.KeyCode==Enum.KeyCode.F4 then setMenuView(not shown) end
end)
wait(0.25)
setMenuView(true)

-- SEKMELER
local tabNames = {"GENEL","ROL","HAREKET","ITEM"}
local Tabs = {}
local TabPages = {}
local tabBar = Instance.new("Frame",Outer)
tabBar.Size = UDim2.new(1, -40, 0, 38)
tabBar.Position = UDim2.new(0, 20, 0, 60)
tabBar.BackgroundColor3 = Color3.fromRGB(213,228,255)
tabBar.BackgroundTransparency = 0.78
tabBar.BorderSizePixel = 0

local selectedTab = 1
for i,name in ipairs(tabNames) do
    local t = Instance.new("TextButton",tabBar)
    t.Text = name 
    t.Size = UDim2.new(0,144,0,38)
    t.Position = UDim2.new(0,(i-1)*147,0,0)
    t.Font = Enum.Font.GothamBlack
    t.TextSize = 17
    t.BorderSizePixel = 0
    t.BackgroundColor3 = (i==1 and Color3.fromRGB(53,170,255) or Color3.fromRGB(46,87,131))
    t.TextColor3 = Color3.fromRGB(255,255,255)
    Tabs[i]=t
    t.MouseButton1Click:Connect(function()
        selectedTab = i
        for j,p in ipairs(TabPages) do
            p.Visible = (j==selectedTab)
            Tabs[j].BackgroundColor3 = (j==selectedTab and Color3.fromRGB(53,170,255) or Color3.fromRGB(46,87,131))
        end
    end)
end

for i=1,#tabNames do
    local p = Instance.new("Frame",Outer)
    p.Size = UDim2.new(1,-40,1,-112)
    p.Position = UDim2.new(0,20,0,106)
    p.BackgroundTransparency = 1
    p.Visible = i==1
    TabPages[i]=p
end

--------- BUTTON FACTORY ---------
local function NewBtn(parent,txt,func,order)
    local btn = Instance.new("TextButton",parent)
    btn.Size = UDim2.new(1,-47,0,50)
    btn.Position = UDim2.new(0,24,0,18+(order-1)*58)
    btn.BackgroundColor3 = Color3.fromRGB(68,159,232)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.Text = txt
    btn.TextStrokeTransparency = 0.82
    btn.TextSize = 18
    btn.AutoButtonColor = true
    btn.ClipsDescendants = true
    btn.Name = "Option"..order
    btn.MouseButton1Click:Connect(function() func(btn) end)
    return btn
end

--------- FONKSİYON ÇEKİRDEĞİ ---------
local function getPlayers()
    local t = {}
    for _,plr in ipairs(Players:GetPlayers()) do if plr~=LocalPlayer then table.insert(t,plr) end end
    return t
end

local function getRole(plr)
    local char = plr.Character
    if not char then return "Unknown" end
    local function scan(obj)
        for _,c in ipairs(obj:GetChildren()) do
            if c.Name=="Knife" then return "Murder"
            elseif c.Name=="Gun" then return "Sheriff" end
        end
    end
    local a = scan(plr.Backpack) if a then return a end
    local b = scan(char) if b then return b end
    return "Innocent"
end

local function findMurder() for _,p in ipairs(getPlayers()) do if getRole(p)=="Murder" then return p end end end
local function findSheriff() for _,p in ipairs(getPlayers()) do if getRole(p)=="Sheriff" then return p end end end
local function findGunDrop() for _,o in ipairs(workspace:GetChildren()) do if o.Name=="GunDrop" and o:IsA("Tool") then return o end end end
local function onKnife()
    if LocalPlayer.Backpack then
        local k=LocalPlayer.Backpack:FindFirstChild("Knife")
        if k then return k end
    end
    if LocalPlayer.Character then
        return LocalPlayer.Character:FindFirstChild("Knife")
    end
end
local function onGun()
    if LocalPlayer.Backpack then
        local g=LocalPlayer.Backpack:FindFirstChild("Gun")
        if g then return g end
    end
    if LocalPlayer.Character then
        return LocalPlayer.Character:FindFirstChild("Gun")
    end
end
local function teleportTo(cf)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = cf
    end
end
local lastPos

--------- TAB 1 GENEL ---------
local gTab = TabPages[1]
local g_order = 1
local espToggle, silentAim, spinbot, fovVal = false, false, false, 70
local espObjs = {}

local function clearESP() for _,v in ipairs(espObjs) do if v and v.Parent then v:Destroy() end end espObjs={} end
local function espLoop()
    clearESP()
    for _,p in ipairs(getPlayers()) do
        if p.Character and p.Character:FindFirstChild("Head") then
            local bb = Instance.new("BillboardGui", sg)
            bb.Adornee = p.Character.Head
            bb.Size = UDim2.new(0,126,0,28)
            bb.AlwaysOnTop = true
            bb.Name = "MM2ESP"
            local role = getRole(p)
            local clr = role=="Murder" and Color3.fromRGB(255,60,60)
                    or (role=="Sheriff" and Color3.fromRGB(66,153,255))
                    or Color3.fromRGB(56,222,86)
            local lbl = Instance.new("TextLabel", bb)
            lbl.Size = UDim2.new(1,0,1,0)
            lbl.BackgroundTransparency = 1
            lbl.Text = p.Name..(
                role=="Murder" and " [KATİL]" or role=="Sheriff" and " [SHERIFF]" or "")
            lbl.TextColor3 = clr
            lbl.Font = Enum.Font.GothamBold
            lbl.TextStrokeTransparency = 0.74
            lbl.TextSize = 17
            table.insert(espObjs,bb)
        end
    end
end

NewBtn(gTab,"ESP: KAPALI",function(btn)
    espToggle = not espToggle
    btn.Text = "ESP: "..(espToggle and "AÇIK" or "KAPALI")
    if not espToggle then clearESP() end
end,g_order)
RunService.RenderStepped:Connect(function() if espToggle then pcall(espLoop) end end)
g_order = g_order + 1

NewBtn(gTab,"SİLENT AIM: KAPALI",function(btn)
    silentAim = not silentAim
    btn.Text = "SİLENT AIM: "..(silentAim and "AÇIK" or "KAPALI")
end,g_order)
g_order = g_order + 1

local oldFire
local function doSilentAim()
    if not silentAim then
        if oldFire and onGun() and onGun():FindFirstChild("GunScript_Client") and onGun().GunScript_Client:FindFirstChild("ShootGun") then
            onGun().GunScript_Client.ShootGun.FireServer = oldFire
            oldFire=nil
        end
        return
    end
    local murder = findMurder()
    local gun = onGun()
    if not murder or not gun or not gun:FindFirstChild("GunScript_Client") then return end
    local gs = gun.GunScript_Client
    if gs:FindFirstChild("ShootGun") and not oldFire then
        oldFire=gs.ShootGun.FireServer
        gs.ShootGun.FireServer = function(self,...)
            local pos = murder.Character and murder.Character:FindFirstChild("Head") and murder.Character.Head.Position or Vector3.zero
            return oldFire(self, pos, murder.Character and murder.Character.Head)
        end
    end
end
RunService.RenderStepped:Connect(doSilentAim)

NewBtn(gTab,"FOV: 70",function(btn)
    fovVal = fovVal+30
    if fovVal>120 then fovVal=70 end
    Camera.FieldOfView = fovVal
    btn.Text = "FOV: "..fovVal
    notify("FOV değişti: "..fovVal,1)
end,g_order)
g_order = g_order + 1

NewBtn(gTab, "SPINBOT: KAPALI", function(btn)
    spinbot = not spinbot
    btn.Text = "SPINBOT: "..(spinbot and "AÇIK" or "KAPALI")
    if not spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.RotVelocity = Vector3.zero
    end
end, g_order)
RunService.Heartbeat:Connect(function()
    if spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.RotVelocity = Vector3.new(0,180,0)
    end
end)

--------- TAB 2 ROL ---------
local rTab = TabPages[2]
local r_order = 1
local roleWish = nil

NewBtn(rTab,"KATİLİ ÖLDÜR (Sheriff)",function(btn)
    if getRole(LocalPlayer) ~= "Sheriff" then notify("Sheriff rolünde değilsin!",1) return end
    local murderer = findMurder()
    if not murderer or not murderer.Character or not murderer.Character:FindFirstChild("Head") then return notify("Katil bulunamadı!",1.4) end
    local args = {murderer.Character.Head.Position, murderer.Character.Head}
    local gun = onGun()
    if gun and gun:FindFirstChild("GunScript_Client") and gun.GunScript_Client:FindFirstChild("ShootGun") then
        gun.GunScript_Client.ShootGun:FireServer(unpack(args))
        notify("Katil otomatik öldürüldü!",1.1)
    end
end,r_order)
r_order = r_order + 1

NewBtn(rTab,"KATİL OL (Başlamadan)",function(btn)
    roleWish = "Murderer"
    notify("Sonraki tur KATİL olmayı seçtin!",1.1)
end,r_order)
r_order = r_order + 1

NewBtn(rTab,"SHERIFF OL (Başlamadan)",function(btn)
    roleWish = "Sheriff"
    notify("Sonraki tur SHERIFF olmayı seçtin!",1.1)
end,r_order)
r_order = r_order + 1

local function tryForceRole()
    local remote = game.ReplicatedStorage:FindFirstChild("GetRole")
    if remote and remote:IsA("RemoteEvent") then
        remote:FireServer(roleWish)
    else
        local mod = (LocalPlayer.PlayerGui:FindFirstChild("Main") and require(LocalPlayer.PlayerGui.Main:FindFirstChild("Framework")))
        if mod and mod.SetRole then
            pcall(function() mod.SetRole(roleWish) end)
        end
    end
end
workspace.ChildAdded:Connect(function(child)
    if tostring(child) == "Map" and roleWish then
        pcall(function()
            tryForceRole()
            notify("Rol denendi: "..tostring(roleWish), 1.1)
            roleWish = nil
        end)
    end
end)

local killAllActive = false
NewBtn(rTab,"KİLL ALL (Katil)",function(btn)
    if getRole(LocalPlayer)~="Murder" then notify("Önce katil olmalısın!",1) return end
    if killAllActive then return end; killAllActive=true
    local targets = {}
    for _,plr in ipairs(getPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(targets, plr)
        end
    end
    local myKnife = onKnife()
    if not myKnife then notify("Knife bulunamadı!",1.15) killAllActive=false return end
    lastPos = LocalPlayer.Character.HumanoidRootPart.CFrame
    for _,victim in ipairs(targets) do
        if killAllActive and victim.Character and victim.Character:FindFirstChild("HumanoidRootPart") then
            teleportTo(victim.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,2))
            wait(0.18)
            local stab = myKnife:FindFirstChild("KnifeScript_Client") or myKnife:FindFirstChildWhichIsA('LocalScript')
            if stab and stab:FindFirstChild("Slash") then
                for _=1,2 do stab.Slash:FireServer() wait(0.07) end
            end
        end
    end
    teleportTo(lastPos) killAllActive=false
    notify("Bütün oyuncular öldürüldü!",1.18)
end,r_order)

--------- TAB 3 HAREKET ---------
local mTab = TabPages[3]
local m_order = 1
local flyOn, velObj, noclipOn = false, nil, false

NewBtn(mTab,"FLY: KAPALI",function(btn)
    flyOn = not flyOn
    btn.Text = "FLY: "..(flyOn and "AÇIK" or "KAPALI")
    if not flyOn and velObj then velObj:Destroy() velObj=nil end
end,m_order)
m_order = m_order + 1

RunService.RenderStepped:Connect(function()
    if flyOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if not velObj then
            velObj = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
            velObj.MaxForce = Vector3.new(1e5,1e5,1e5)
            velObj.P = 17500
        end
        local moveVec = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec = moveVec - Vector3.new(0,1,0) end
        velObj.Velocity = moveVec.Magnitude>0 and moveVec.Unit*58 or Vector3.zero
    elseif velObj then velObj:Destroy() velObj=nil end
end)

NewBtn(mTab,"NOCLIP: KAPALI",function(btn)
    noclipOn = not noclipOn
    btn.Text = "NOCLIP: "..(noclipOn and "AÇIK" or "KAPALI")
end,m_order)
RunService.Stepped:Connect(function()
    if noclipOn and LocalPlayer.Character then
        for _,v in ipairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide=false end
        end
    end
end)

--------- TAB 4 ITEM ---------
local iTab = TabPages[4]
local i_order = 1

NewBtn(iTab,"DÜŞEN SİLAHI AL",function(btn)
    local gun = findGunDrop()
    if not gun then return notify("Yerde silah yok!",1.22) end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        notify("Karakter bulunamadı!",1.13) return
    end
    lastPos = LocalPlayer.Character.HumanoidRootPart.CFrame
    LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame + Vector3.new(0,2,0)
    wait(0.13)
    pcall(function()
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, gun.Handle, 0)
        wait(0.05)
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, gun.Handle, 1)
    end)
    wait(0.07)
    LocalPlayer.Character.HumanoidRootPart.CFrame = lastPos
    notify("Silah taşındı!",1.1)
end,i_order)












local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Eski menüler varsa temizle
for _, obj in ipairs({"HileMenuV3", "HileMenuV4", "ProV5HackMenu", "RobloxHileMenuUI"}) do
    if game.CoreGui:FindFirstChild(obj) then
        game.CoreGui[obj]:Destroy()
    end
end

local MENU_HOTKEY = Enum.KeyCode.F4
local MENU_NAME   = "ProV5HackMenu"

-----------------------------------------------------------------
-- ## UI SYSTEM (Popup & Drag Support) ##
-----------------------------------------------------------------
local sg = Instance.new("ScreenGui")
sg.Name = MENU_NAME
sg.IgnoreGuiInset = true
pcall(function() sg.Parent = game:GetService("CoreGui") end)
sg.ResetOnSpawn = false

-- Ana gövde
local frame = Instance.new("Frame", sg)
frame.Name = "AnaPanel"
frame.Size = UDim2.fromOffset(540,384)
frame.Position = UDim2.fromOffset(120,88)
frame.BackgroundColor3 = Color3.fromRGB(24,32,44)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0
local topbar = Instance.new("Frame", frame)
topbar.Name = "Bar"
topbar.Size = UDim2.new(1,0,0,48)
topbar.BackgroundColor3 = Color3.fromRGB(36,106,154)
topbar.BorderSizePixel = 0

local title = Instance.new("TextLabel", topbar)
title.Size = UDim2.new(1, -64, 1, 0)
title.Position = UDim2.new(0,16,0,0)
title.BackgroundTransparency = 1
title.Text = "ROBLOX GTA LOADER V5"
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 25
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", topbar)
close.Size = UDim2.new(0,40,0,40)
close.Position = UDim2.new(1,-44,0,4)
close.BackgroundColor3 = Color3.fromRGB(90,60,60)
close.Font = Enum.Font.GothamBlack
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255,90,90)
close.TextSize = 23
close.BorderSizePixel = 0
close.MouseButton1Click:Connect(function()
    frame.Visible = false
end)
frame.Visible = true
sg.Enabled = true

-- MENUYÜ GÖSTER/GİZLE HOTKEY (F4)
UserInputService.InputBegan:Connect(function(input, _gp)
    if input.KeyCode == MENU_HOTKEY and not _gp then
        frame.Visible = not frame.Visible
    end
end)

-- Tab Sistemi
local tabSelec = "Hileler"
local tabs, tabBtns, TABS = {}, {}, {"Hileler","Oyuncu"}
for i, name in ipairs(TABS) do
    local btn = Instance.new("TextButton", frame)
    btn.Name = "TabBtn_"..name
    btn.Size = UDim2.new(0,112,0,36)
    btn.Position = UDim2.new(0, 16 + ((i-1)*122), 0, 54)
    btn.BackgroundColor3 = Color3.fromRGB(i == 1 and 102 or 47, 152, 199)
    btn.Font = Enum.Font.GothamBold
    btn.Text = name:upper()
    btn.TextSize = 17
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BorderSizePixel = 0
    tabBtns[name] = btn
    local pane = Instance.new("Frame", frame)
    pane.Name = "Tab_"..name
    pane.BackgroundTransparency = 1
    pane.Size = UDim2.new(1, -36, 1, -116)
    pane.Position = UDim2.new(0,18,0, 100)
    pane.Visible = (i==1)
    tabs[name] = pane
    btn.MouseButton1Click:Connect(function()
        for t, f in pairs(tabs) do
            f.Visible = (t==name)
            tabBtns[t].BackgroundColor3 = Color3.fromRGB(t==name and 102 or 47, 152, 199)
        end
        tabSelec = name
    end)
end

----------------------------------------------------------
-- [Hileler Tab: Aktif/Deaktif ve Slider] ---------------
----------------------------------------------------------
local hackEnabled = {
    Aimbot=false, SilentAim=false, ESP=false, Noclip=false, Fly=false,
    Spinbot=false, Godmode=false, TeamCheck=true, NoReload=false
}
local config = { FOV = 120 }

do
    local T = tabs["Hileler"]
    -- Seçenek tuşları
    local hiles = {
        {"Aimbot",     "Aimbot"},
        {"SilentAim",  "Silent Aim"},
        {"ESP",        "ESP"},
        {"Noclip",     "Noclip"},
        {"Fly",        "Fly"},
        {"Spinbot",    "Spinbot"},
        {"Godmode",    "Godmode"},
        {"TeamCheck",  "Takım Kontrolü"},
        {"NoReload",   "No Reload"},
    }
    local BUTTONS = {}
    for i, hile in ipairs(hiles) do
        local btn = Instance.new("TextButton", T)
        btn.Size = UDim2.new(.23,0,0,32)
        btn.Position = UDim2.new(0, 10 + (((i-1)%4)*126), 0, 12 + math.floor((i-1)/4)*50)
        btn.BackgroundColor3 = Color3.fromRGB(53,83,130)
        btn.Text = hile[2].." ["..(hackEnabled[hile[1]] and "Açık" or "Kapalı").."]"
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = hackEnabled[hile[1]] and Color3.fromRGB(0,255,128) or Color3.fromRGB(232,232,232)
        btn.TextSize = 15
        btn.BorderSizePixel = 0
        BUTTONS[hile[1]] = btn
        btn.MouseButton1Click:Connect(function()
            hackEnabled[hile[1]] = not hackEnabled[hile[1]]
            btn.Text = hile[2].." ["..(hackEnabled[hile[1]] and "Açık" or "Kapalı").."]"
            btn.TextColor3 = hackEnabled[hile[1]] and Color3.fromRGB(0,255,128) or Color3.fromRGB(232,232,232)
        end)
    end

    -- FOV CHANGER
    local fovLbl = Instance.new("TextLabel", T)
    fovLbl.Text = "Aimbot/Silent FOV:"
    fovLbl.Font = Enum.Font.GothamBold
    fovLbl.TextColor3 = Color3.fromRGB(100,255,190)
    fovLbl.BackgroundTransparency = 1
    fovLbl.TextSize = 15
    fovLbl.Position = UDim2.new(0,15,1,-54)
    fovLbl.Size = UDim2.new(0,130,0,22)
    local fovBox = Instance.new("TextBox", T)
    fovBox.Position = UDim2.new(0,152,1,-58)
    fovBox.Size = UDim2.new(0,64,0,26)
    fovBox.Font = Enum.Font.GothamBold
    fovBox.BackgroundColor3 = Color3.fromRGB(30,55,90)
    fovBox.TextSize = 14
    fovBox.TextColor3 = Color3.fromRGB(35,255,255)
    fovBox.Text = tostring(config.FOV)
    fovBox.BorderSizePixel = 0
    fovBox.FocusLost:Connect(function()
        local v = tonumber(fovBox.Text)
        if v and v>=10 then config.FOV = math.clamp(math.floor(v),10,900)
        else fovBox.Text = tostring(config.FOV) end
    end)
    -- FOV Bar (Slider)
    local slid = Instance.new("TextButton", T)
    slid.Size = UDim2.new(0,100,0,8)
    slid.Position = UDim2.new(0,240,1,-47)
    slid.BackgroundColor3 = Color3.fromRGB(115,190,230)
    slid.BorderSizePixel = 0
    slid.Text = ""
    local drag = false
    slid.MouseButton1Down:Connect(function() drag = true end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
    RunService.RenderStepped:Connect(function()
        if drag then
            local mx = UserInputService:GetMouseLocation().X
            local rel = math.clamp((mx - slid.AbsolutePosition.X) / slid.AbsoluteSize.X, 0,1)
            config.FOV = math.floor(30 + rel * 400)
            fovBox.Text = tostring(config.FOV)
        end
    end)
end

-----------------------------------------------------------------
---- Oyuncu Tab: Player Eylemleri ---------------------------------
-----------------------------------------------------------------
local secilenOyuncu = nil
do
    local T = tabs["Oyuncu"]
    local oyuncuSec = Instance.new("TextButton", T)
    oyuncuSec.Text = "Oyuncu Seç"
    oyuncuSec.Font = Enum.Font.GothamBold
    oyuncuSec.TextColor3 = Color3.fromRGB(0,220,255)
    oyuncuSec.Size = UDim2.new(0,128,0,30)
    oyuncuSec.Position = UDim2.new(0, 8, 0, 12)
    oyuncuSec.BorderSizePixel = 0
    oyuncuSec.BackgroundColor3 = Color3.fromRGB(42,76,110)

    local oyuncuLbl = Instance.new("TextLabel", T)
    oyuncuLbl.Size = UDim2.new(0,170,0,26)
    oyuncuLbl.Position = UDim2.new(0,148,0,13)
    oyuncuLbl.BackgroundTransparency = 1
    oyuncuLbl.TextColor3 = Color3.fromRGB(199,255,255)
    oyuncuLbl.Font = Enum.Font.GothamBold
    oyuncuLbl.TextSize = 15
    oyuncuLbl.Text = "Seçili: [YOK]"

    -- Dropdown Player Picker
    local scroller = Instance.new("ScrollingFrame",T)
    scroller.Size = UDim2.new(0,200,0,100)
    scroller.Position = UDim2.new(0,8,0,48)
    scroller.BackgroundColor3 = Color3.fromRGB(48,65,120)
    scroller.BorderSizePixel = 0
    scroller.Visible = false
    scroller.CanvasSize = UDim2.new(0,0,0,0)
    scroller.ScrollBarThickness = 4
    local function loadPlayers()
        scroller:ClearAllChildren()
        local y = 0
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer then
                local pbtn = Instance.new("TextButton",scroller)
                pbtn.Size = UDim2.new(1,-8,0,24)
                pbtn.Position = UDim2.new(0,4,0,4+y*28)
                pbtn.Text = pl.Name
                pbtn.Font = Enum.Font.Gotham
                pbtn.TextSize = 13
                pbtn.TextColor3 = Color3.fromRGB(0,255,255)
                pbtn.BackgroundColor3 = Color3.fromRGB(40,55,85)
                pbtn.BorderSizePixel = 0
                pbtn.MouseButton1Click:Connect(function()
                    secilenOyuncu = pl
                    oyuncuLbl.Text = "Seçili: "..pl.Name
                    scroller.Visible = false
                end)
                y = y+1
            end
        end
        scroller.CanvasSize = UDim2.new(0,0,0, y*28)
    end
    oyuncuSec.MouseButton1Click:Connect(function()
        scroller.Visible = not scroller.Visible
        if scroller.Visible then loadPlayers() end
    end)

    -- Player Actions
    local actions = {
        {"Işınlan", function()
            if secilenOyuncu and secilenOyuncu.Character and secilenOyuncu.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = secilenOyuncu.Character.HumanoidRootPart.CFrame * CFrame.new(2,0,0)
            end
        end},
        {"Yanına Çek", function()
            if secilenOyuncu and secilenOyuncu.Character and secilenOyuncu.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                secilenOyuncu.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(2,0,0)
            end
        end},
        {"Dondur", function()
            if secilenOyuncu and secilenOyuncu.Character then
                for _,v in ipairs(secilenOyuncu.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.Anchored = true end
                end
                local hum = secilenOyuncu.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed=0 hum.JumpPower=0 hum.PlatformStand=true end
            end
        end},
        {"Patlat", function()
            if secilenOyuncu and secilenOyuncu.Character and secilenOyuncu.Character:FindFirstChild("HumanoidRootPart") then
                local boom = Instance.new("Explosion")
                boom.BlastRadius = 12
                boom.BlastPressure = 1e8
                boom.Position = secilenOyuncu.Character.HumanoidRootPart.Position
                boom.Parent = workspace
            end
        end},
        {"Yak", function()
            if secilenOyuncu and secilenOyuncu.Character then
                for _,bp in ipairs(secilenOyuncu.Character:GetChildren()) do
                    if bp:IsA("BasePart") and not bp:FindFirstChild("ONFIRE") then
                        local fire = Instance.new("Fire")
                        fire.Name = "ONFIRE"; fire.Size = 9; fire.Heat = 25; fire.Parent = bp
                    end
                end
                local hum = secilenOyuncu.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.Health = hum.Health - math.random(25,40) end
            end
        end},
    }
    for i, act in ipairs(actions) do
        local abtn = Instance.new("TextButton", T)
        abtn.Size = UDim2.new(0,98,0,26)
        abtn.Position = UDim2.new(0,8+((i-1)%3)*108,0,180+math.floor((i-1)/3)*36)
        abtn.BackgroundColor3 = Color3.fromRGB(60,110,180)
        abtn.Text = act[1]
        abtn.Font = Enum.Font.GothamBold
        abtn.TextSize = 14
        abtn.TextColor3 = Color3.fromRGB(255,255,240)
        abtn.BorderSizePixel = 0
        abtn.MouseButton1Click:Connect(act[2])
    end

    -- Spectate (toggle)
    local isSpec = false
    local spectateBtn = Instance.new("TextButton", T)
    spectateBtn.Size = UDim2.new(0,123,0,26)
    spectateBtn.Position = UDim2.new(1,-135,0,180)
    spectateBtn.Text = "Spectate"
    spectateBtn.BackgroundColor3 = Color3.fromRGB(110,90,210)
    spectateBtn.Font = Enum.Font.GothamBold
    spectateBtn.TextSize = 14
    spectateBtn.TextColor3 = Color3.fromRGB(241,241,255)
    spectateBtn.BorderSizePixel = 0
    spectateBtn.MouseButton1Click:Connect(function()
        if isSpec then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            end
            spectateBtn.Text = "Spectate"
            isSpec = false
        elseif secilenOyuncu and secilenOyuncu.Character and secilenOyuncu.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = secilenOyuncu.Character:FindFirstChildOfClass("Humanoid")
            spectateBtn.Text = "Spectate Kapat"
            isSpec = true
        end
    end)
end -- OyuncuTab

----------------------------------------------------------------------
---- Hile Fonksiyonları (TAM) -----------------------------------------
----------------------------------------------------------------------

local function isEnemy(ply)
    if hackEnabled.TeamCheck and ply.Team and LocalPlayer.Team and ply.Team==LocalPlayer.Team then
        return false
    end
    return true
end

local function SetNoClipOnChar(state)
    local char = LocalPlayer.Character
    if not char then return end
    for _,v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state
            v.Anchored = false
        end
    end
end

local NoclipConn, NoclipLastEn = nil, false
if NoclipConn then NoclipConn:Disconnect() end
NoclipConn = RunService.Stepped:Connect(function()
    if hackEnabled.Noclip and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        SetNoClipOnChar(true)
        pcall(function() LocalPlayer.Character.Humanoid:ChangeState(11) end)
        NoclipLastEn = true
    elseif NoclipLastEn then
        SetNoClipOnChar(false)
        NoclipLastEn = false
    end
end)

local flyBV, flyBG
RunService.RenderStepped:Connect(function()
    if hackEnabled.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if not flyBV or flyBV.Parent ~= hrp then
            if flyBV then pcall(function() flyBV:Destroy() end) end
            flyBV = Instance.new("BodyVelocity"); flyBV.Name = "___FlyBV"
            flyBV.MaxForce = Vector3.new(1e9,1e9,1e9); flyBV.Velocity=Vector3.new(); flyBV.Parent=hrp
            flyBG = Instance.new("BodyGyro"); flyBG.Name = "___FlyBG"
            flyBG.MaxTorque = Vector3.new(1e9,1e9,1e9); flyBG.CFrame = Camera.CFrame; flyBG.Parent=hrp
        end
        local camCF = Camera.CFrame; flyBG.CFrame = camCF
        local movevec = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then movevec = movevec + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then movevec = movevec - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then movevec = movevec - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then movevec = movevec + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then movevec = movevec + camCF.UpVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then movevec = movevec - camCF.UpVector end
        if movevec.Magnitude > 0 then movevec = movevec.Unit * 75 end
        flyBV.Velocity = movevec
    else
        if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
        if flyBG then pcall(function() flyBG:Destroy() end) flyBG = nil end
    end
end)

RunService.Heartbeat:Connect(function()
    if hackEnabled.Godmode then
        local chr = LocalPlayer.Character
        if chr and chr:FindFirstChildOfClass("Humanoid") then
            local hum = chr:FindFirstChildOfClass("Humanoid")
            pcall(function()
                hum.Health = hum.MaxHealth
                hum.MaxHealth = 9999999
                hum.WalkSpeed = 16
                hum.JumpPower = 50
                hum.PlatformStand = false
                hum.BreakJointsOnDeath = false
            end)
            for _, v in ipairs(chr:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
    end
end)

local function tryRemoveReloadGuns()
    if hackEnabled.NoReload then
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        local char = LocalPlayer.Character
        local function patchGun(obj)
            for _,desc in ipairs(obj:GetDescendants()) do
                if desc:IsA("Script") or desc:IsA("LocalScript") then
                    local n = (desc.Name..""):lower()
                    if n:find("ammo") or n:find("reload") or n:find("mag") then
                        desc.Disabled = true
                    end
                end
            end
        end
        if backpack then for _,v in ipairs(backpack:GetChildren()) do patchGun(v) end end
        if char then for _,v in ipairs(char:GetChildren()) do patchGun(v) end end
    end
end
RunService.Heartbeat:Connect(tryRemoveReloadGuns)

RunService.RenderStepped:Connect(function()
    if hackEnabled.Spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(30),0) end
    end
end)

-- Aimbot / SilentAim algoritması
local function getClosestHead()
    local closest, minDist = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()
    for _, ply in pairs(Players:GetPlayers()) do
        if ply ~= LocalPlayer and ply.Character and ply.Character:FindFirstChild("Head")
            and ply.Character:FindFirstChildOfClass("Humanoid")
            and ply.Character:FindFirstChildOfClass("Humanoid").Health > 0
            and isEnemy(ply) then
            local head = ply.Character.Head
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(head.Position)
            if OnScreen then
                local dist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                if dist < config.FOV and dist < minDist then
                    minDist = dist
                    closest = head
                end
            end
        end
    end
    return closest
end

-- Aimbot (Camera Snap)
RunService.RenderStepped:Connect(function()
    if hackEnabled.Aimbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local head = getClosestHead()
        if head then
            local direction = (head.Position - Camera.CFrame.Position).Unit
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
        end
    end
end)

-- SilentAim
do
    local ok, gmt = pcall(getrawmetatable, game)
    if ok then
        local old_namecall = gmt.__namecall
        setreadonly(gmt, false)
        gmt.__namecall = newcclosure(function(self, ...)
            if not hackEnabled.SilentAim then return old_namecall(self, ...) end
            local args = {...}
            local method = getnamecallmethod()
            if tostring(method):lower():find("fire") and getClosestHead() then
                if typeof(args[1])=="Vector3" then
                    args[1]=getClosestHead().Position
                end
                return old_namecall(self, unpack(args))
            end
            return old_namecall(self,...)
        end)
        setreadonly(gmt,true)
    end
end

-- ESP (TAM, FOV çemberi de göster)
local espDrawn = {}
local function removeESP()
    for _, obj in pairs(espDrawn) do
        if obj.Remove then pcall(function() obj:Remove() end) end
        if typeof(obj) == "table" then for _, o in ipairs(obj) do if o.Remove then pcall(function() o:Remove() end) end end end
    end
    espDrawn = {}
end
local function DrawLine(from,to,c)
    local line = Drawing.new("Line")
    line.From = from
    line.To = to
    line.Color = c or Color3.new(1, 1, 1)
    line.Thickness = 2
    line.Transparency = 1
    return line
end
local function DrawBox(minX,minY,maxX,maxY,c)
    local box = {}
    table.insert(box, DrawLine(Vector2.new(minX,minY), Vector2.new(maxX,minY),c))
    table.insert(box, DrawLine(Vector2.new(maxX,minY), Vector2.new(maxX,maxY),c))
    table.insert(box, DrawLine(Vector2.new(maxX,maxY), Vector2.new(minX,maxY),c))
    table.insert(box, DrawLine(Vector2.new(minX,maxY), Vector2.new(minX,minY),c))
    return box
end
local function DrawCircle(center, radius, c)
    local circ = Drawing.new("Circle")
    circ.Position = center
    circ.Radius = radius
    circ.Color = c or Color3.new(1,1,1)
    circ.Thickness = 2
    circ.Transparency = 1
    circ.NumSides = 40
    circ.Filled = false
    return circ
end

RunService:BindToRenderStep("PROESPV3",201,function()
    if not hackEnabled.ESP then removeESP() return end
    removeESP()
    -- FOV çemberi
    if hackEnabled.Aimbot or hackEnabled.SilentAim then
        local mloc = UserInputService:GetMouseLocation()
        table.insert(espDrawn, DrawCircle(Vector2.new(mloc.X,mloc.Y), config.FOV, Color3.fromRGB(0,255,200)))
    end
    for _,ply in ipairs(Players:GetPlayers()) do
        if ply ~= LocalPlayer and ply.Character and ply.Character:FindFirstChild("HumanoidRootPart")
            and ply.Character:FindFirstChild("Head")
            and ply.Character:FindFirstChildOfClass("Humanoid")
            and ply.Character:FindFirstChildOfClass("Humanoid").Health > 0 and isEnemy(ply) then
            local hrp = ply.Character.HumanoidRootPart
            local head = ply.Character.Head
            local dist = (hrp.Position - Camera.CFrame.Position).Magnitude
            if dist < 400 then
                -- Kutu/Skeleton/Headbox
                local parts = {}
                for _,p in ipairs({"Head","UpperTorso","LowerTorso","Torso","LeftLeg","LeftFoot","LeftLowerLeg","LeftUpperLeg","RightLeg","RightFoot","RightLowerLeg","RightUpperLeg"}) do
                    if ply.Character:FindFirstChild(p) then table.insert(parts, ply.Character:FindFirstChild(p)) end
                end
                local min, max = Vector3.new(math.huge,math.huge,math.huge), Vector3.new(-math.huge,-math.huge,-math.huge)
                for _,part in ipairs(parts) do
                    local pos = part.Position
                    min = Vector3.new(math.min(min.X,pos.X),math.min(min.Y,pos.Y),math.min(min.Z,pos.Z))
                    max = Vector3.new(math.max(max.X,pos.X),math.max(max.Y,pos.Y),math.max(max.Z,pos.Z))
                end
                local corners = {
                    Vector3.new(min.X,min.Y,min.Z),
                    Vector3.new(min.X,max.Y,min.Z),
                    Vector3.new(max.X,max.Y,max.Z),
                    Vector3.new(max.X,min.Y,max.Z)
                }
                local vecs = {}
                for i,v in ipairs(corners) do
                    local vp,onsc = Camera:WorldToViewportPoint(v)
                    if onsc and vp.Z > 0 then table.insert(vecs,Vector2.new(vp.X,vp.Y)) end
                end
                if #vecs > 0 then
                    local pminX,pminY,pmaxX,pmaxY = vecs[1].X,vecs[1].Y,vecs[1].X,vecs[1].Y
                    for _,v in ipairs(vecs) do
                        if v.X < pminX then pminX = v.X end
                        if v.X > pmaxX then pmaxX = v.X end
                        if v.Y < pminY then pminY = v.Y end
                        if v.Y > pmaxY then pmaxY = v.Y end
                    end
                    local box = DrawBox(pminX,pminY,pmaxX,pmaxY,Color3.new(1,1,1))
                    for _,l in ipairs(box) do table.insert(espDrawn,l) end
                end
                local headVP,headOn = Camera:WorldToViewportPoint(head.Position)
                if headOn and headVP.Z > 0 then
                    local r = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,head.Size.Y/1.33,0))
                    local rad = math.min(36, math.max(12, math.abs((Vector2.new(r.X,r.Y)-Vector2.new(headVP.X,headVP.Y)).Magnitude)))
                    local circ = DrawCircle(Vector2.new(headVP.X, headVP.Y), rad, Color3.new(1,1,1))
                    table.insert(espDrawn, circ)
                end
                -- Skeleton çizimi (omurga, kollar, bacaklar, baş)
                local function W2V(pos)
                    local vp,ons = Camera:WorldToViewportPoint(pos)
                    return Vector2.new(vp.X,vp.Y),ons and vp.Z>0
                end
                local utorso = ply.Character:FindFirstChild("UpperTorso") or ply.Character:FindFirstChild("Torso")
                local ltorso = ply.Character:FindFirstChild("LowerTorso")
                if utorso and ltorso then
                    local p1,on1 = W2V(utorso.Position)
                    local p2,on2 = W2V(ltorso.Position)
                    if on1 and on2 then table.insert(espDrawn, DrawLine(p1,p2,Color3.new(1,1,1))) end
                end
                if head and utorso then
                    local p1,on1 = W2V(head.Position)
                    local p2,on2 = W2V(utorso.Position)
                    if on1 and on2 then table.insert(espDrawn, DrawLine(p1,p2,Color3.new(1,1,1))) end
                end
                local rsh = ply.Character:FindFirstChild("RightUpperArm") or ply.Character:FindFirstChild("Right Arm")
                local rlow = ply.Character:FindFirstChild("RightLowerArm")
                local rhand = ply.Character:FindFirstChild("RightHand") or ply.Character:FindFirstChild("Right Arm")
                local lsh = ply.Character:FindFirstChild("LeftUpperArm") or ply.Character:FindFirstChild("Left Arm")
                local llow = ply.Character:FindFirstChild("LeftLowerArm")
                local lhand = ply.Character:FindFirstChild("LeftHand") or ply.Character:FindFirstChild("Left Arm")
                if utorso and rsh then
                    local p1,on1 = W2V(utorso.Position)
                    local p2,on2 = W2V(rsh.Position)
                    if on1 and on2 then table.insert(espDrawn, DrawLine(p1,p2,Color3.new(1,1,1))) end
                    if rlow then
                        local p3,on3 = W2V(rlow.Position)
                        if on2 and on3 then table.insert(espDrawn, DrawLine(p2,p3,Color3.new(1,1,1))) end
                        if rhand then
                            local p4,on4 = W2V(rhand.Position)
                            if on3 and on4 then table.insert(espDrawn, DrawLine(p3,p4,Color3.new(1,1,1))) end
                        end
                    end
                end
                if utorso and lsh then
                    local p1,on1 = W2V(utorso.Position)
                    local p2,on2 = W2V(lsh.Position)
                    if on1 and on2 then table.insert(espDrawn, DrawLine(p1,p2,Color3.new(1,1,1))) end
                    if llow then
                        local p3,on3 = W2V(llow.Position)
                        if on2 and on3 then table.insert(espDrawn, DrawLine(p2,p3,Color3.new(1,1,1))) end
                        if lhand then
                            local p4,on4 = W2V(lhand.Position)
                            if on3 and on4 then table.insert(espDrawn, DrawLine(p3,p4,Color3.new(1,1,1))) end
                        end
                    end
                end
                local rupper = ply.Character:FindFirstChild("RightUpperLeg") or ply.Character:FindFirstChild("Right Leg")
                local rlower = ply.Character:FindFirstChild("RightLowerLeg")
                local rfoot = ply.Character:FindFirstChild("RightFoot") or ply.Character:FindFirstChild("Right Leg")
                local lupper = ply.Character:FindFirstChild("LeftUpperLeg") or ply.Character:FindFirstChild("Left Leg")
                local llower = ply.Character:FindFirstChild("LeftLowerLeg")
                local lfoot = ply.Character:FindFirstChild("LeftFoot") or ply.Character:FindFirstChild("Left Leg")
                if ltorso and rupper then
                    local p1,on1 = W2V(ltorso.Position)
                    local p2,on2 = W2V(rupper.Position)
                    if on1 and on2 then table.insert(espDrawn, DrawLine(p1,p2,Color3.new(1,1,1))) end
                    if rlower then
                        local p3,on3 = W2V(rlower.Position)
                        if on2 and on3 then table.insert(espDrawn, DrawLine(p2,p3,Color3.new(1,1,1))) end
                        if rfoot then
                            local p4,on4 = W2V(rfoot.Position)
                            if on3 and on4 then table.insert(espDrawn, DrawLine(p3,p4,Color3.new(1,1,1))) end
                        end
                    end
                end
                if ltorso and lupper then
                    local p1,on1 = W2V(ltorso.Position)
                    local p2,on2 = W2V(lupper.Position)
                    if on1 and on2 then table.insert(espDrawn, DrawLine(p1,p2,Color3.new(1,1,1))) end
                    if llower then
                        local p3,on3 = W2V(llower.Position)
                        if on2 and on3 then table.insert(espDrawn, DrawLine(p2,p3,Color3.new(1,1,1))) end
                        if lfoot then
                            local p4,on4 = W2V(lfoot.Position)
                            if on3 and on4 then table.insert(espDrawn, DrawLine(p3,p4,Color3.new(1,1,1))) end
                        end
                    end
                end
            end
        end
    end
end)
