-- YENİ NESİL HİLE MENÜSÜ [POPUP, DÜZENLİ, F4'le Aç/Kapat, UI Framework yok, tüm fonksiyonlar TAM] --

-- MM2 HİLESİ (Murder Mystery 2 Gelişmiş Menü)
-- TOOLBOX
local function notify(msg, t)
    local notif = Instance.new("TextLabel", sg)
    notif.Text = msg
    notif.TextColor3 = Color3.fromRGB(255,255,255)
    notif.BackgroundColor3 = Color3.fromRGB(36, 106, 154)
    notif.BackgroundTransparency = 0.2
    notif.Position = UDim2.new(0.5, -125, 0, 20)
    notif.Size = UDim2.new(0,250,0,36)
    notif.Font = Enum.Font.GothamBlack
    notif.TextSize = 18
    notif.BorderSizePixel = 0
    notif.ZIndex = 50
    notif.TextStrokeTransparency = 0.7
    task.spawn(function()
        wait(t or 2)
        notif:Destroy()
    end)
end

local function getPlayers() -- Diğer oyuncuları döndürür
    local t = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(t, p)
        end
    end
    return t
end

local function getRole(plr)
    local char = plr.Character
    if not char then return "Unknown" end
    for _,tool in ipairs(plr.Backpack:GetChildren()) do
        if tool.Name == "Knife" then
            return "Murder"
        elseif tool.Name == "Gun" then
            return "Sheriff"
        end
    end
    for _,itm in ipairs(char:GetChildren()) do
        if itm.Name == "Knife" then
            return "Murder"
        elseif itm.Name == "Gun" then
            return "Sheriff"
        end
    end
    return "Innocent"
end

local function findMurder()
    for _,plr in ipairs(getPlayers()) do
        if getRole(plr) == "Murder" then return plr end
    end
end

local function findSheriff()
    for _,plr in ipairs(getPlayers()) do
        if getRole(plr) == "Sheriff" then return plr end
    end
end

local function findGunDrop()
    for _,drop in ipairs(workspace:GetChildren()) do
        if drop.Name == "GunDrop" and drop:IsA("Tool") then
            return drop
        end
    end
end

local function onKnife()
    local bp = LocalPlayer.Backpack:FindFirstChild("Knife")
    local ch = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife")
    return bp or ch
end

local function onGun()
    local bp = LocalPlayer.Backpack:FindFirstChild("Gun")
    local ch = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")
    return bp or ch
end

local function teleportTo(cf)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = cf
    end
end

local lastPos = nil

------------------------------------------------------------------------
-- MENÜ SİSTEMİ (Tablı/Türlere Bölünmüş, Aç/Kapa Destekli)
------------------------------------------------------------------------
local isOpen = true
sg.Enabled = true

local tabFrame = Instance.new("Frame", frame)
tabFrame.Name = "TabFrame"
tabFrame.Size = UDim2.new(0,520,0,40)
tabFrame.Position = UDim2.new(0,10,0,53)
tabFrame.BackgroundColor3 = Color3.fromRGB(18,78,133)
tabFrame.BorderSizePixel = 0

local hotkeyBtn = Instance.new("TextButton", topbar)
hotkeyBtn.Text = "F4"
hotkeyBtn.Size = UDim2.new(0,48,1,0)
hotkeyBtn.Position = UDim2.new(1,-48,0,0)
hotkeyBtn.BackgroundColor3 = Color3.fromRGB(21,56,88)
hotkeyBtn.TextSize = 18
hotkeyBtn.Font = Enum.Font.GothamBlack
hotkeyBtn.TextColor3 = Color3.new(1,1,1)
hotkeyBtn.BorderSizePixel = 0

local tabs = {
    {Name="ANA",     Color=Color3.fromRGB(60,159,128)}, -- ESP, SilentAim, FOV, Spinbot
    {Name="ROL",     Color=Color3.fromRGB(199,53,93)},  -- Katili Öldür, Katil Ol, Sheriff Ol, KillAll
    {Name="HAREKET", Color=Color3.fromRGB(38,123,207)}, -- Fly, Noclip
    {Name="ITEM", Color=Color3.fromRGB(236,196,66)},    -- Düşen Silahı Al
}
local selectedTab = 1
local tabBtns = {}

for i,tab in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabFrame)
    btn.Text = tab.Name
    btn.Size = UDim2.new(0,120,1,0)
    btn.Position = UDim2.new(0,(i-1)*130,0,0)
    btn.BackgroundColor3 = tab.Color
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 16
    btn.BorderSizePixel = 0
    tabBtns[i] = btn
    btn.MouseButton1Click:Connect(function()
        selectedTab = i
        for j,ob in ipairs(btns) do
            ob.Visible = (btnTabMap[j] == selectedTab)
        end
    end)
end

-- Tüm butonları ana gövdede, doğru tab ile eşleştirerek listele
btns = {}
btnTabMap = {}

local yOffsets = {
    [1]=100,
    [2]=144,
    [3]=188,
    [4]=232,
    [5]=276,
    [6]=320,
}

local btnUIData = {
    --[text, color, function, tabIndex, posIndex]
    {"ESP", Color3.fromRGB(80,255,80), nil, 1, 1},
    {"SİLENT-AIM", Color3.fromRGB(153,102,255), nil, 1, 2},
    {"FOV CHANGER", Color3.fromRGB(77,231,255), nil, 1, 3},
    {"SPINBOT", Color3.fromRGB(255,89,204), nil, 1, 4},

    {"KATİLİ ÖLDÜR (Sheriff)", Color3.fromRGB(50,165,255), nil, 2, 1},
    {"KATİL OL (Raund Öncesi)", Color3.fromRGB(255,51,107), nil, 2, 2},
    {"SHERIFF OL (Raund Öncesi)", Color3.fromRGB(63,136,255), nil, 2, 3},
    {"KİLL ALL(Katil)", Color3.fromRGB(255,84,17), nil, 2, 4},

    {"FLY", Color3.fromRGB(245,156,69), nil, 3, 1},
    {"NOCLIP", Color3.fromRGB(190,110,65), nil, 3, 2},

    {"Düşen Silahı Al", Color3.fromRGB(226,237,110), nil, 4, 1},
}

-- Butonları oluştur
for i,data in ipairs(btnUIData) do
    local btn = Instance.new("TextButton", frame)
    btn.BackgroundColor3 = data[2]
    btn.Size = UDim2.new(0,200,0,34)
    btn.Position = UDim2.new(0,24 + ((data[5]-1)%2)*220, 0, yOffsets[data[4]] )
    btn.Text = data[1]
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 17
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BorderSizePixel = 0
    btn.Visible = (data[4] == selectedTab)
    btns[i] = btn
    btnTabMap[i] = data[4]
end

-- TAB GÖRSELLERİNİ GÜNCELLE
local function updateTabView()
    for i,btn in ipairs(tabBtns) do
        btn.BackgroundColor3 = (i == selectedTab) and tabs[i].Color:Lerp(Color3.new(1,1,1),0.34) or tabs[i].Color
    end
    for j,ob in ipairs(btns) do
        ob.Visible = (btnTabMap[j] == selectedTab)
    end
end

for i,btn in ipairs(tabBtns) do
    btn.MouseButton1Click:Connect(updateTabView)
end

-- Menü toggler
local function toggleMenu()
    isOpen = not isOpen
    sg.Enabled = isOpen
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == MENU_HOTKEY then
        toggleMenu()
    end
end)

hotkeyBtn.MouseButton1Click:Connect(toggleMenu)

-- FONKSİYONELLİKLER
-- ESP
local espToggled = false
local espBoxes = {}
local function removeESP()
    for _,v in ipairs(espBoxes) do v:Destroy() end
    espBoxes = {}
end

local function espLoop()
    removeESP()
    for _,plr in ipairs(getPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("Head") then
            local ab = Instance.new("BillboardGui", sg)
            ab.Adornee = plr.Character.Head
            ab.Size = UDim2.new(0,80,0,24)
            ab.AlwaysOnTop = true
            ab.Name = "EESP"
            local role = getRole(plr)
            local clr = role == "Murder" and Color3.fromRGB(255,80,80) or (role == "Sheriff" and Color3.fromRGB(80,80,255) or Color3.fromRGB(80,255,80))
            local lbl = Instance.new("TextLabel", ab)
            lbl.Size = UDim2.new(1,0,1,0)
            lbl.BackgroundTransparency = 1
            lbl.Text = plr.Name .. (role == "Murder" and " [KATİL]" or role == "Sheriff" and " [SHERIFF]" or "")
            lbl.TextColor3 = clr
            lbl.TextSize = 16
            lbl.TextStrokeTransparency = 0.7
            table.insert(espBoxes, ab)
        end
    end
end

btns[1].MouseButton1Click:Connect(function()
    espToggled = not espToggled
    btns[1].Text = "ESP: " .. (espToggled and "AÇIK" or "KAPALI")
    if not espToggled then removeESP() end
end)
RunService.RenderStepped:Connect(function() if espToggled then espLoop() end end)
-- Silent Aim
local silentAim = false
local oldFireServer
btns[2].MouseButton1Click:Connect(function()
    silentAim = not silentAim
    btns[2].Text = "SİLENT-AIM: "..(silentAim and "AÇIK" or "KAPALI")
end)
local function doSilentAim()
    if not silentAim then return end
    local murder = findMurder()
    if getRole(LocalPlayer) ~= "Sheriff" or not murder or not murder.Character then return end
    local gun = onGun()
    if not gun or not gun:FindFirstChild("GunScript_Client") then return end
    local gs = gun.GunScript_Client
    if gs:FindFirstChild("ShootGun") and not oldFireServer then
        oldFireServer = gs.ShootGun.FireServer
        gs.ShootGun.FireServer = function(self, ...)
            local pos = murder.Character.Head.Position
            local head = murder.Character.Head
            return oldFireServer(self, pos, head)
        end
    elseif not silentAim and oldFireServer and gs:FindFirstChild("ShootGun") then
        gs.ShootGun.FireServer = oldFireServer
        oldFireServer = nil
    end
end
RunService.RenderStepped:Connect(doSilentAim)
-- FOV
local FOV_VAL = 70
btns[3].MouseButton1Click:Connect(function()
    FOV_VAL = FOV_VAL + 25
    if FOV_VAL > 120 then FOV_VAL = 70 end
    Camera.FieldOfView = FOV_VAL
    notify("FOV: "..FOV_VAL, 1)
end)
Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if Camera.FieldOfView ~= FOV_VAL then FOV_VAL = Camera.FieldOfView end
end)
-- Spinbot
local spinbot = false
btns[4].MouseButton1Click:Connect(function()
    spinbot = not spinbot
    btns[4].Text = "SPINBOT: "..(spinbot and "AÇIK" or "KAPALI")
    if not spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.RotVelocity = Vector3.new(0,0,0)
    end
end)
RunService.Heartbeat:Connect(function()
    if spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.RotVelocity = Vector3.new(0,100,0)
    end
end)

-- Katili Öldür
btns[5].MouseButton1Click:Connect(function()
    if getRole(LocalPlayer) ~= "Sheriff" then return notify("Sheriff değilsin!", 1.5) end
    local murder = findMurder()
    if not murder or not murder.Character or not murder.Character:FindFirstChild("Head") then
        return notify("Katil bulunamadı!", 1.5)
    end
    local args = {
        [1] = murder.Character.Head.Position,
        [2] = murder.Character.Head
    }
    local gun = onGun()
    if gun and gun:FindFirstChild("GunScript_Client") and gun.GunScript_Client:FindFirstChild("ShootGun") then
        gun.GunScript_Client.ShootGun:FireServer(unpack(args))
        notify("Katil öldürülmeye çalışıldı!", 1.5)
    end
end)
-- Katil Ol + Şerif Ol exploit
local roleWish = nil
btns[6].MouseButton1Click:Connect(function()
    roleWish = "Murderer"
    notify("Raund başlayınca KATİL olacaksın (exploit)...", 1.5)
end)
btns[7].MouseButton1Click:Connect(function()
    roleWish = "Sheriff"
    notify("Raund başlayınca SHERIFF olacaksın (exploit)...", 1.5)
end)
local function tryForceRole()
    local mod = LocalPlayer.PlayerGui:FindFirstChild("Main") and require(LocalPlayer.PlayerGui.Main:FindFirstChild("Framework"))
    if mod and mod.SetRole then
        pcall(function() mod.SetRole(roleWish) end)
    else
        local remote = game.ReplicatedStorage:FindFirstChild("GetRole")
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(roleWish)
        else
            notify("Force role exploit mevcut değil!", 1.5)
        end
    end
end
workspace.ChildAdded:Connect(function(child)
    if tostring(child) == "Map" and roleWish then
        pcall(function()
            tryForceRole()
            notify("Raund başlat: " .. roleWish, 1.5)
            roleWish = nil
        end)
    end
end)
-- Kill All (Katilken Tüm Oyunculara Teleport Kes)
local killAllActive = false
btns[8].MouseButton1Click:Connect(function()
    if getRole(LocalPlayer) ~= "Murder" then
        notify("Katilsin, KillAll aktif!", 1.5)
        return
    end
    if killAllActive then return end
    killAllActive = true
    local targets = {}
    for _,plr in ipairs(getPlayers()) do
        if (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")) and plr ~= LocalPlayer then
            table.insert(targets, plr)
        end
    end
    local myKnife = onKnife()
    if not myKnife then
        notify("Knife yok!", 1.5) killAllActive = false return
    end
    lastPos = LocalPlayer.Character.HumanoidRootPart.CFrame
    for _,victim in ipairs(targets) do
        if killAllActive and victim.Character and victim.Character:FindFirstChild("HumanoidRootPart") then
            teleportTo(victim.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,2))
            wait(0.2)
            local stab = myKnife:FindFirstChild("KnifeScript_Client") or myKnife:FindFirstChildOfClass('LocalScript')
            if stab and stab:FindFirstChild("Slash") then
                for _=1,2 do
                    stab.Slash:FireServer()
                    wait(0.15)
                end
            end
        end
    end
    teleportTo(lastPos)
    killAllActive = false
    notify("KillAll tamamlandı", 2)
end)
-- Fly
local flyOn = false
local velObj = nil
btns[9].MouseButton1Click:Connect(function()
    flyOn = not flyOn
    btns[9].Text = "FLY: "..(flyOn and "AÇIK" or "KAPALI")
    if not flyOn and velObj then velObj:Destroy() velObj = nil end
end)
RunService.RenderStepped:Connect(function()
    if flyOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if not velObj then
            velObj = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
            velObj.MaxForce = Vector3.new(1e5,1e5,1e5)
            velObj.P = 1e4
        end
        local moveVec = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec= moveVec + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec= moveVec - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec= moveVec - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec= moveVec + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec= moveVec + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec= moveVec - Vector3.new(0,1,0) end
        velObj.Velocity = moveVec.Magnitude > 0 and moveVec.Unit*55 or Vector3.zero
    elseif velObj then velObj:Destroy() velObj = nil end
end)
-- Noclip
local noclipOn = false
btns[10].MouseButton1Click:Connect(function()
    noclipOn = not noclipOn
    btns[10].Text = "NOCLIP: "..(noclipOn and "AÇIK" or "KAPALI")
end)
RunService.Stepped:Connect(function()
    if noclipOn and LocalPlayer.Character then
        for _,v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
-- Düşen Silahı Al
btns[11].MouseButton1Click:Connect(function()
    local gun = findGunDrop()
    if not gun then return notify("Yerde silah yok!", 1.5) end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        return notify("Karakter bulunamadı!", 1.5)
    end
    lastPos = LocalPlayer.Character.HumanoidRootPart.CFrame
    LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame + Vector3.new(0,2,0)
    wait(0.25)
    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, gun.Handle, 0)
    wait(0.1)
    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, gun.Handle, 1)
    wait(0.1)
    if lastPos then
        LocalPlayer.Character.HumanoidRootPart.CFrame = lastPos
        lastPos = nil
    end
    notify("Silah çekildi!", 1.2)
end)

-- Tab view her açıldığında güncelle
updateTabView()




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
