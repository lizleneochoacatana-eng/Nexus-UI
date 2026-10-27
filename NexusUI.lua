-- NEXUS UI v6.0.0 · ARCHIVO ÚNICO (librería + interfaz de ejemplo)
-- Pega TODO este archivo en tu ejecutor y ejecútalo. No necesitas nada más.

local UI = (function()
--[[
    ╔══════════════════════════════════════════════════════════╗
    ║  NEXUS UI  ·  v6.0.0  ·  Black Edition                   ║
    ║  Librería de interfaz para proyectos propios de Roblox   ║
    ╚══════════════════════════════════════════════════════════╝

    USO RÁPIDO
        local UI = loadstring(game:HttpGet("URL_RAW_DE_NexusUI.lua"))()
        local Window = UI:CreateWindow({ Title = "Mi Hub" })
        local Tab = Window:CreateTab({ Name = UI.T("Inicio", "Home") })
        Tab:CreateButton({ Name = "Hola", Callback = function() print("hi") end })

    Todo texto puede ser string o UI.T("español", "english") y se traduce solo.

    ─── UI (módulo) ───────────────────────────────────────────
        UI.Version, UI.Language, UI.ReduceMotion, UI.Themes, UI.Windows
        UI.T(es, en)                 texto bilingüe
        UI:CreateWindow(opciones)    -> Window
        UI:SetLanguage("ES"|"EN")    idioma por defecto
        UI:SetTheme(colores)         (v5) cambia los colores por defecto de ventanas nuevas
        UI:RegisterTheme(nombre, colores)   registra un tema nuevo
        UI:DestroyAll()

    ─── UI:CreateWindow(opciones) ─────────────────────────────
        Title, Name, Language, Size(Vector2), Scale(0.6-1.4), ToggleKey(Enum.KeyCode),
        Theme(string de UI.Themes | tabla de colores), Loading(bool), LoadingTime,
        LogoImage, BackgroundImage(false = sin fondo), MiniText, Parent, DisplayOrder,
        ConfirmClose(bool), MaxNotifications, ReduceMotion(bool),
        ConfigFolder, ConfigName, AutoSave(bool), RestoreLayout(bool), Storage(adaptador),
        KeySystem({Keys, Title, Note, SaveKey, FileName}),
        OnClose(fn), OnLanguageChanged(fn)

    ─── Window ────────────────────────────────────────────────
        :CreateTab({Name, Category})     :SelectTab(nombre|indice)
        :SetCategoryOpen(categoria, bool)   (las categorías se pliegan con su flecha)
        :Notify({Type, Title, Content, Duration})   :ClearNotifications()
        :SetTheme(nombre|tabla)  :GetTheme()  :SetAccent(color, color2)
        :SetLanguage("ES"|"EN")  :GetLanguage()
        :SetUIScale(n)  :SetReduceMotion(bool)
        :Minimize() :Restore() :Maximize() :SetVisible(bool) :Destroy()
        :OnLoaded(fn)  :OnChanged(flag, fn)
        :SaveConfig(n) :LoadConfig(n) :DeleteConfig(n) :ListConfigs()
        :ExportConfig() :ImportConfig(json) :CanPersist()
        .Flags  .Gui  .Main  .Storage

    ─── Tab / Group (mismos componentes) ──────────────────────
        :CreateSection(nombre)   :CreateDivider()   :CreateLabel(texto)
        :CreateParagraph({Title, Content})
        :CreateButton({Name, Callback})
        :CreateToggle({Name, CurrentValue, Flag, Callback})
        :CreateSlider({Name, Range, Increment, Suffix, CurrentValue, Flag, Callback})
        :CreateDropdown({Name, Options, CurrentOption, Flag, Callback})
        :CreateMultiDropdown({Name, Options, CurrentOptions, Flag, Callback})
        :CreateInput({Name, Placeholder, CurrentValue, Numeric, Flag, Callback})
        :CreateKeybind({Name, CurrentKeybind, Flag, Callback, OnChanged})
        :CreateColorPicker({Name, CurrentValue, Flag, Callback})
        :CreateProgressBar({Name, CurrentValue(0-1)})
        :CreateGroup({Name, Open})  -> grupo plegable con los mismos métodos
        Todos devuelven api con :Destroy() y :SetVisible(bool); la mayoría :Get() / :Set().

    Documentación completa: README.md y docs/API.md del repositorio.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local UI = {}
UI.Version = "6.0.0"
UI.Language = "ES"
UI.AnimationSpeed = 0.2
UI.ReduceMotion = false
UI.Windows = {}

-- IDs de respaldo (solo se usan si el entorno no soporta imágenes incrustadas)
UI.Images = {
    Logo = "",
    Background = ""
}

-- ═══════════════════════════════════════════════════════════
--  TEMAS
--  Los colores de un mismo tema deben ser distintos entre sí
--  (el cambio de tema en caliente reconoce los colores por valor).
-- ═══════════════════════════════════════════════════════════
local function copyTable(t)
    local c = {}
    for k, v in pairs(t) do c[k] = v end
    return c
end

local BLACK = {
    Background = Color3.fromRGB(7, 7, 12),
    Panel = Color3.fromRGB(13, 13, 21),
    Element = Color3.fromRGB(21, 21, 33),
    Accent = Color3.fromRGB(124, 108, 255),
    Accent2 = Color3.fromRGB(70, 150, 255),
    Text = Color3.fromRGB(240, 240, 250),
    Muted = Color3.fromRGB(150, 152, 172),
    Border = Color3.fromRGB(42, 42, 64),
    Success = Color3.fromRGB(80, 200, 140),
    Warning = Color3.fromRGB(240, 190, 80),
    Error = Color3.fromRGB(235, 95, 110),
    Shade = Color3.fromRGB(2, 2, 6),
    ShadeAlpha = 0.45,
    Light = false
}

local function extend(base, overrides)
    local t = copyTable(base)
    for k, v in pairs(overrides) do
        if t[k] ~= nil then t[k] = v end
    end
    return t
end

UI.Themes = {
    Black = BLACK,
    Midnight = extend(BLACK, {
        Background = Color3.fromRGB(6, 10, 20),
        Panel = Color3.fromRGB(11, 17, 32),
        Element = Color3.fromRGB(18, 27, 48),
        Accent = Color3.fromRGB(80, 160, 255),
        Accent2 = Color3.fromRGB(140, 110, 255),
        Text = Color3.fromRGB(235, 242, 255),
        Muted = Color3.fromRGB(140, 158, 190),
        Border = Color3.fromRGB(36, 52, 86),
        Shade = Color3.fromRGB(2, 4, 10)
    }),
    Light = extend(BLACK, {
        Background = Color3.fromRGB(238, 240, 248),
        Panel = Color3.fromRGB(250, 250, 255),
        Element = Color3.fromRGB(226, 229, 242),
        Accent = Color3.fromRGB(98, 84, 235),
        Accent2 = Color3.fromRGB(50, 130, 240),
        Text = Color3.fromRGB(22, 22, 34),
        Muted = Color3.fromRGB(96, 100, 124),
        Border = Color3.fromRGB(196, 200, 220),
        Success = Color3.fromRGB(30, 150, 95),
        Warning = Color3.fromRGB(200, 140, 20),
        Error = Color3.fromRGB(205, 60, 80),
        Shade = Color3.fromRGB(248, 248, 254),
        ShadeAlpha = 0.3,
        Light = true
    }),
    HighContrast = extend(BLACK, {
        Background = Color3.fromRGB(0, 0, 0),
        Panel = Color3.fromRGB(12, 12, 12),
        Element = Color3.fromRGB(26, 26, 26),
        Accent = Color3.fromRGB(255, 214, 0),
        Accent2 = Color3.fromRGB(0, 220, 255),
        Text = Color3.fromRGB(254, 254, 254),
        Muted = Color3.fromRGB(205, 205, 205),
        Border = Color3.fromRGB(150, 150, 150),
        Success = Color3.fromRGB(0, 230, 120),
        Warning = Color3.fromRGB(255, 170, 0),
        Error = Color3.fromRGB(255, 70, 70),
        Shade = Color3.fromRGB(3, 3, 3),
        ShadeAlpha = 0.2
    })
}
UI.DefaultTheme = "Black"
UI.Theme = copyTable(BLACK)   -- colores por defecto de ventanas nuevas (compatible con v5)

function UI:SetTheme(colors)
    for k, v in pairs(colors or {}) do
        if UI.Theme[k] ~= nil then
            UI.Theme[k] = v
        end
    end
end

function UI:RegisterTheme(name, colors)
    if type(name) ~= "string" or type(colors) ~= "table" then return false end
    UI.Themes[name] = extend(BLACK, colors)
    return true
end

function UI:SetLanguage(language)
    if language == "ES" or language == "EN" then
        UI.Language = language
    end
end

function UI:DestroyAll()
    for i = #UI.Windows, 1, -1 do
        local w = UI.Windows[i]
        if w and w.Destroy then w:Destroy() end
    end
end

-- ═══════════════════════════════════════════════════════════
--  IMÁGENES INCRUSTADAS (sin IDs)
--  Requieren writefile + getcustomasset (algunos ejecutores).
-- ═══════════════════════════════════════════════════════════
local EMBEDDED = {
    logo = [[
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
]],
    bg = [[
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
]]
}

local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local B64LOOK = {}
for i = 1, 64 do B64LOOK[B64:byte(i)] = i - 1 end

local function b64decode(data)
    data = (data:gsub("[^%w%+/=]", ""))
    local out, n = {}, 0
    for i = 1, #data, 4 do
        local a, b, c, d = data:byte(i, i + 3)
        local v = (B64LOOK[a] or 0) * 262144 + (B64LOOK[b] or 0) * 4096
            + (B64LOOK[c] or 0) * 64 + (B64LOOK[d] or 0)
        local s = string.char(math.floor(v / 65536) % 256)
        if c ~= 61 then s = s .. string.char(math.floor(v / 256) % 256) end
        if d ~= 61 then s = s .. string.char(v % 256) end
        n += 1
        out[n] = s
    end
    return table.concat(out)
end

local localAssets = {}
local function embeddedImage(name)
    if localAssets[name] ~= nil then return localAssets[name] end
    local result = ""
    local getAsset = getcustomasset or getsynasset
    if writefile and getAsset and EMBEDDED[name] then
        local ok = pcall(function()
            if makefolder and isfolder and not isfolder("NexusUI") then
                makefolder("NexusUI")
            end
            local path = "NexusUI/" .. name .. ".jpg"
            writefile(path, b64decode(EMBEDDED[name]))
            result = getAsset(path)
        end)
        if not ok then result = "" end
    end
    localAssets[name] = result
    return result
end

-- ═══════════════════════════════════════════════════════════
--  UTILIDADES
-- ═══════════════════════════════════════════════════════════
local function L(es, en)
    return {ES = es, EN = en}
end
UI.T = L

local function tx(v)
    if type(v) == "table" then
        return v[UI.Language] or v.EN or v.ES or ""
    end
    return tostring(v == nil and "" or v)
end

-- Valor estable (independiente del idioma) de un texto bilingüe
local function key(v)
    if type(v) == "table" then return v.EN or v.ES or "" end
    return tostring(v)
end

local function trim(s)
    return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function asset(id)
    id = tostring(id or "")
    if id == "" or id == "0" then return "" end
    if id:match("^%d+$") then return "rbxassetid://" .. id end
    return id
end

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, obj)
end

local function outline(obj, color, theme)
    return make("UIStroke", {
        Color = color or (theme or UI.Theme).Border,
        Thickness = 1,
        Transparency = 0.12
    }, obj)
end

local function animate(obj, props, duration)
    local d = duration or UI.AnimationSpeed
    if UI.ReduceMotion then d = 0 end
    local tw = TweenService:Create(
        obj,
        TweenInfo.new(d, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    )
    tw:Play()
    return tw
end

-- Flecha "V" dibujada con dos barras (no depende de la fuente del texto).
-- Rotation 0 = apunta abajo, 180 = arriba, 90 = izquierda, -90 = derecha.
local function makeChevron(parentObj, color, arm, thick, z)
    local a = arm / math.sqrt(2)
    local box = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(arm * 2, arm * 2),
        BackgroundTransparency = 1,
        ZIndex = z or 1
    }, parentObj)
    local function bar(x, rot)
        local f = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, x, 0.5, 0),
            Size = UDim2.fromOffset(arm, thick or 2),
            Rotation = rot,
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            ZIndex = z or 1
        }, box)
        round(f, 1)
    end
    bar(-a / 2, 45)
    bar(a / 2, -45)
    return box
end

local function isPress(input)
    return input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1
end

local function isMove(input)
    return input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
end

-- Ejecuta un callback del usuario sin romper la interfaz si falla
local function spawnCall(fn, ...)
    if type(fn) ~= "function" then return end
    local args = table.pack(...)
    task.spawn(function()
        local ok, err = pcall(fn, table.unpack(args, 1, args.n))
        if not ok then
            warn("[NexusUI] " .. tostring(err))
        end
    end)
end

local function formatNumber(n)
    return tostring(math.floor(n * 1000 + 0.5) / 1000)
end

-- Identificador numérico de un Color3 (para el cambio de tema en caliente)
local function cid(c)
    return math.floor(c.R * 255 + 0.5) * 65536
        + math.floor(c.G * 255 + 0.5) * 256
        + math.floor(c.B * 255 + 0.5)
end

-- Sustituye colores antiguos por nuevos en todos los descendientes de root
local function recolor(root, map)
    local function swap(obj, prop)
        local n = map[cid(obj[prop])]
        if n then obj[prop] = n end
    end
    for _, obj in ipairs(root:GetDescendants()) do
        if not obj:GetAttribute("NoTheme") then
            if obj:IsA("GuiObject") then
                swap(obj, "BackgroundColor3")
                if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                    swap(obj, "TextColor3")
                    if obj:IsA("TextBox") then swap(obj, "PlaceholderColor3") end
                elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                    swap(obj, "ImageColor3")
                elseif obj:IsA("ScrollingFrame") then
                    swap(obj, "ScrollBarImageColor3")
                end
            elseif obj:IsA("UIStroke") then
                swap(obj, "Color")
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════
--  ALMACENAMIENTO
--  Adaptador por defecto: archivos del ejecutor si existen
--  (writefile/readfile/isfile); si no, memoria de la sesión.
--  Se puede sustituir con options.Storage = {Save, Load, Delete, List, Persistent}.
-- ═══════════════════════════════════════════════════════════
local sessionMemory = {}

local function makeStorage(options)
    if type(options.Storage) == "table" and options.Storage.Save and options.Storage.Load then
        return options.Storage
    end

    local folder = options.ConfigFolder or "NexusUI"
    local hasFS = (writefile and readfile and isfile) and true or false
    local store = {Persistent = hasFS}

    local function path(name) return folder .. "/" .. name .. ".json" end
    local function memKey(name) return folder .. "/" .. name end

    function store.Save(name, text)
        if hasFS then
            return (pcall(function()
                if makefolder and isfolder and not isfolder(folder) then
                    makefolder(folder)
                end
                writefile(path(name), text)
            end))
        end
        sessionMemory[memKey(name)] = text
        return true
    end

    function store.Load(name)
        if hasFS then
            local ok, res = pcall(function()
                if isfile(path(name)) then return readfile(path(name)) end
                return nil
            end)
            if ok then return res end
            return nil
        end
        return sessionMemory[memKey(name)]
    end

    function store.Delete(name)
        if hasFS then
            if delfile and isfile(path(name)) then
                return (pcall(delfile, path(name)))
            end
            return false
        end
        local had = sessionMemory[memKey(name)] ~= nil
        sessionMemory[memKey(name)] = nil
        return had
    end

    function store.List()
        local names = {}
        if hasFS then
            if listfiles and isfolder and isfolder(folder) then
                local ok, files = pcall(listfiles, folder)
                if ok and type(files) == "table" then
                    for _, f in ipairs(files) do
                        local n = tostring(f):match("([^/\\]+)%.json$")
                        if n then table.insert(names, n) end
                    end
                end
            end
        else
            local prefix = folder .. "/"
            for k in pairs(sessionMemory) do
                if k:sub(1, #prefix) == prefix then
                    table.insert(names, k:sub(#prefix + 1))
                end
            end
        end
        table.sort(names)
        return names
    end

    return store
end

-- ═══════════════════════════════════════════════════════════
--  VENTANA
-- ═══════════════════════════════════════════════════════════
local NOTE_TYPES = {
    Info = {Color = "Accent", Tag = L("INFO", "INFO")},
    Success = {Color = "Success", Tag = L("LISTO", "SUCCESS")},
    Warning = {Color = "Warning", Tag = L("AVISO", "WARNING")},
    Error = {Color = "Error", Tag = L("ERROR", "ERROR")}
}

function UI:CreateWindow(options)
    options = options or {}

    if options.Language == "ES" or options.Language == "EN" then
        UI.Language = options.Language
    end
    if options.ReduceMotion ~= nil then
        UI.ReduceMotion = options.ReduceMotion == true
    end

    -- Tema propio de esta ventana
    local T = copyTable(UI.Theme)
    local themeName = UI.DefaultTheme
    if type(options.Theme) == "string" then
        if UI.Themes[options.Theme] then
            T = copyTable(UI.Themes[options.Theme])
            themeName = options.Theme
        else
            warn("[NexusUI] Tema desconocido: " .. options.Theme)
        end
    elseif type(options.Theme) == "table" then
        for k, v in pairs(options.Theme) do
            if T[k] ~= nil then T[k] = v end
        end
        themeName = "Custom"
    end

    local store = makeStorage(options)

    -- Imágenes: opción propia > incrustada > ID de respaldo
    local function pick(name, custom, fallbackId)
        if custom == false then return "" end
        if custom ~= nil and custom ~= "" then return asset(custom) end
        local e = embeddedImage(name)
        if e ~= "" then return e end
        return asset(fallbackId)
    end
    local IMG_LOGO = pick("logo", options.LogoImage, UI.Images.Logo)
    local IMG_BG = pick("bg", options.BackgroundImage, UI.Images.Background)

    local PA = IMG_BG ~= "" and 0.3 or 0   -- transparencia de paneles
    local EA = IMG_BG ~= "" and 0.2 or 0   -- transparencia de elementos

    local size = options.Size or Vector2.new(540, 365)
    local DEFAULT_W = math.max(size.X, 340)
    local DEFAULT_H = math.max(size.Y, 240)
    local userScale = math.clamp(options.Scale or 1, 0.6, 1.4)
    local TOUCH = UIS.TouchEnabled

    local connections = {}
    local function track(c)
        table.insert(connections, c)
        return c
    end

    -- Traducción automática de textos enlazados
    local bindings = {}
    local function bind(obj, prop, getter)
        obj[prop] = getter()
        table.insert(bindings, {obj, prop, getter})
    end
    local function unbind(instance)
        for i = #bindings, 1, -1 do
            local o = bindings[i][1]
            if o == instance or o:IsDescendantOf(instance) then
                table.remove(bindings, i)
            end
        end
    end

    local Window = {Flags = {}}
    local flagItems = {}
    local flagHandlers = {}
    local searchIndex = {}
    local gradients = {}
    local refreshExtras   -- se asigna más abajo (búsqueda)

    local function refreshLanguage()
        for i = #bindings, 1, -1 do
            local b = bindings[i]
            if b[1].Parent then
                b[1][b[2]] = b[3]()
            else
                table.remove(bindings, i)
            end
        end
        if refreshExtras then refreshExtras() end
    end

    local parent = options.Parent or playerGui
    local guiName = options.Name or "NexusUI"
    local old = parent:FindFirstChild(guiName)
    if old then old:Destroy() end

    local gui = make("ScreenGui", {
        Name = guiName,
        ResetOnSpawn = false,
        DisplayOrder = options.DisplayOrder or 999,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, parent)
    pcall(function() gui.ScreenInsets = Enum.ScreenInsets.None end)

    Window.Gui = gui
    Window.Storage = store

    gui.Destroying:Connect(function()
        for _, c in ipairs(connections) do
            c:Disconnect()
        end
        connections = {}
    end)

    -- Degradado de acento (se actualiza con el tema)
    local function addGradient(target, rotation)
        local g = make("UIGradient", {
            Color = ColorSequence.new(T.Accent, T.Accent2),
            Rotation = rotation or 0
        }, target)
        table.insert(gradients, g)
        return g
    end

    -- Rectángulo blanco que solo sirve de base para un degradado
    local function gradientFrame(props, parentObj, rotation)
        props.BackgroundColor3 = Color3.new(1, 1, 1)
        props.BorderSizePixel = 0
        local f = make("Frame", props, parentObj)
        f:SetAttribute("NoTheme", true)
        addGradient(f, rotation)
        return f
    end

    -- ───────────── Arrastre (mouse y touch) ─────────────
    -- La posición se lee en cada frame (RenderStepped): responde al instante
    -- y no depende de eventos InputChanged. onBegin puede devolver false.
    local function drag(handle, onBegin, onDelta)
        local active, pending, startInput = false, false, nil
        local startPos = Vector2.zero

        local function current()
            if startInput.UserInputType == Enum.UserInputType.Touch then
                return Vector2.new(startInput.Position.X, startInput.Position.Y)
            end
            return UIS:GetMouseLocation()
        end

        handle.InputBegan:Connect(function(input)
            if isPress(input) then
                if onBegin(input) == false then return end
                active = true
                pending = true
                startInput = input
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        active = false
                    end
                end)
            end
        end)

        track(RunService.RenderStepped:Connect(function()
            if not active then return end
            local cur = current()
            if pending then
                -- El punto de partida se toma ya con la posición actualizada
                -- (evita el salto al agarrar).
                startPos = cur
                pending = false
                return
            end
            onDelta(cur - startPos)
        end))

        track(UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                active = false
            end
        end))
    end

    -- ───────────── Ventana principal ─────────────
    local main = make("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(DEFAULT_W, DEFAULT_H),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = T.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true,
        Visible = false
    }, gui)
    round(main, 14)
    Window.Main = main

    -- Borde con degradado azul-violeta
    local mainStroke = make("UIStroke", {
        Color = Color3.new(1, 1, 1),
        Thickness = 1.5,
        Transparency = 0.3
    }, main)
    mainStroke:SetAttribute("NoTheme", true)
    addGradient(mainStroke, 45)

    local shadeFrame
    if IMG_BG ~= "" then
        local bg = make("ImageLabel", {
            Name = "Background",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Image = IMG_BG,
            ScaleType = Enum.ScaleType.Crop,
            ZIndex = 1
        }, main)
        round(bg, 14)

        shadeFrame = make("Frame", {
            Name = "Shade",
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = T.Shade,
            BackgroundTransparency = T.ShadeAlpha,
            BorderSizePixel = 0,
            ZIndex = 2
        }, main)
        round(shadeFrame, 14)
        make("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.25),
                NumberSequenceKeypoint.new(1, 0.12)
            }),
            Rotation = 90
        }, shadeFrame)
    end

    local scale = make("UIScale", {Scale = 1}, main)
    local maximized = false
    local applyMaximize   -- se define más abajo

    local function fitScreen()
        local camera = workspace.CurrentCamera
        if camera then
            local v = camera.ViewportSize
            scale.Scale = math.min(userScale, (v.X - 16) / DEFAULT_W, (v.Y - 16) / DEFAULT_H)
        end
        if maximized and applyMaximize then applyMaximize(true) end
    end

    -- Barra superior transparente (título + subtítulo + botones planos)
    local top = make("Frame", {
        Name = "TopBar",
        Active = true,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundTransparency = 1,
        ZIndex = 3
    }, main)

    make("TextLabel", {
        Position = UDim2.fromOffset(18, 8),
        Size = UDim2.new(1, -220, 0, 20),
        BackgroundTransparency = 1,
        Text = options.Title or "NEXUS UI",
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4
    }, top)

    make("TextLabel", {
        Position = UDim2.fromOffset(18, 29),
        Size = UDim2.new(1, -220, 0, 14),
        BackgroundTransparency = 1,
        Text = options.Subtitle or ("NEXUS UI  v" .. UI.Version),
        TextColor3 = T.Muted,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4
    }, top)

    local function topButton(text, x)
        local b = make("TextButton", {
            Position = UDim2.new(1, x, 0, 10),
            Size = UDim2.fromOffset(34, 34),
            BackgroundColor3 = T.Border,
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = T.Muted,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            ZIndex = 5
        }, top)
        round(b, 9)
        b.MouseEnter:Connect(function()
            animate(b, {BackgroundTransparency = 0.55}, 0.12)
        end)
        b.MouseLeave:Connect(function()
            animate(b, {BackgroundTransparency = 1}, 0.12)
        end)
        return b
    end

    -- Iconos dibujados con barras (no dependen de la fuente)
    local function iconBar(btn, w, h, rot)
        local f = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(w, h),
            Rotation = rot or 0,
            BackgroundColor3 = T.Muted,
            BorderSizePixel = 0,
            ZIndex = 6
        }, btn)
        round(f, 1)
        return f
    end

    local close = topButton("", -44)
    iconBar(close, 15, 2, 45)
    iconBar(close, 15, 2, -45)

    local maxButton = topButton("", -82)
    local maxIcon = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(12, 12),
        BackgroundTransparency = 1,
        ZIndex = 6
    }, maxButton)
    round(maxIcon, 2)
    make("UIStroke", {Color = T.Muted, Thickness = 1.5}, maxIcon)

    local lang = topButton(UI.Language, -120)

    local minimize = topButton("", -158)
    iconBar(minimize, 13, 2, 0)

    -- Barra lateral transparente (se ve el fondo)
    local sidebar = make("Frame", {
        Position = UDim2.fromOffset(0, 54),
        Size = UDim2.new(0, 140, 1, -54),
        BackgroundTransparency = 1,
        ZIndex = 3
    }, main)

    -- Búsqueda con lupa
    local searchBox = make("TextBox", {
        Position = UDim2.fromOffset(10, 2),
        Size = UDim2.new(1, -20, 0, 34),
        BackgroundColor3 = T.Element,
        BackgroundTransparency = 0.35,
        Text = "",
        TextColor3 = T.Text,
        PlaceholderColor3 = T.Muted,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        ClearTextOnFocus = false,
        ClipsDescendants = true,
        BorderSizePixel = 0,
        TextXAlignment = Enum.TextXAlignment.Left
    }, sidebar)
    round(searchBox, 10)
    make("UIPadding", {PaddingLeft = UDim.new(0, 36), PaddingRight = UDim.new(0, 8)}, searchBox)
    bind(searchBox, "PlaceholderText", function()
        return tx(L("Buscar...", "Search..."))
    end)

    local searchIcon = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(27, 19),
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        ZIndex = 2
    }, sidebar)
    local lens = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, -2, 0.5, -2),
        Size = UDim2.fromOffset(10, 10),
        BackgroundTransparency = 1,
        ZIndex = 2
    }, searchIcon)
    round(lens, 5)
    make("UIStroke", {Color = T.Muted, Thickness = 1.5}, lens)
    local handleBar = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 5, 0.5, 5),
        Size = UDim2.fromOffset(6, 2),
        Rotation = 45,
        BackgroundColor3 = T.Muted,
        BorderSizePixel = 0,
        ZIndex = 2
    }, searchIcon)
    round(handleBar, 1)

    local tabList = make("ScrollingFrame", {
        Position = UDim2.fromOffset(6, 44),
        Size = UDim2.new(1, -12, 1, -50),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = T.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        Active = true
    }, sidebar)

    make("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, tabList)

    -- Panel translúcido del contenido (a la derecha)
    local contentPanel = make("Frame", {
        Position = UDim2.fromOffset(148, 54),
        Size = UDim2.new(1, -156, 1, -62),
        BackgroundColor3 = T.Panel,
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        ZIndex = 3
    }, main)
    round(contentPanel, 12)

    local content = make("Frame", {
        Position = UDim2.fromOffset(156, 62),
        Size = UDim2.new(1, -172, 1, -78),
        BackgroundTransparency = 1,
        ZIndex = 3
    }, main)

    local pages = {}
    local currentEntry
    local searching = false
    local confirmBox, confirmDim
    local languageMenu
    local savedSize = UDim2.fromOffset(DEFAULT_W, DEFAULT_H)
    local prevPos, prevSize

    local function toTopLeft()
        if main.AnchorPoint ~= Vector2.new(0, 0) then
            local p = main.AbsolutePosition
            main.AnchorPoint = Vector2.new(0, 0)
            main.Position = UDim2.fromOffset(p.X / scale.Scale, p.Y / scale.Scale)
        end
    end

    -- La ventana solo se mueve agarrando la barra superior,
    -- así no se desplaza por accidente al usar los controles.
    local mainStart
    drag(top, function()
        if maximized then return false end
        toTopLeft()
        mainStart = main.AbsolutePosition
    end, function(d)
        local v = gui.AbsoluteSize
        local sz = main.AbsoluteSize
        local x = math.clamp(mainStart.X + d.X, -(sz.X - 90), v.X - 90)
        local y = math.clamp(mainStart.Y + d.Y, 0, v.Y - 50)
        main.Position = UDim2.fromOffset(x / scale.Scale, y / scale.Scale)
    end)

    -- Mantiene todo dentro de la pantalla al cambiar su tamaño
    local mini, miniLang
    local MINI_W, MINI_H = 236, 44

    local function clampToScreen()
        local v = gui.AbsoluteSize
        if mini then
            local p = mini.AbsolutePosition
            mini.Position = UDim2.fromOffset(
                math.clamp(p.X, 0, math.max(0, v.X - MINI_W)),
                math.clamp(p.Y, 0, math.max(0, v.Y - MINI_H)))
        end
        if main.Visible and not maximized then
            local p, sz = main.AbsolutePosition, main.AbsoluteSize
            local nx = math.clamp(p.X, -(sz.X - 90), math.max(-(sz.X - 90), v.X - 90))
            local ny = math.clamp(p.Y, 0, math.max(0, v.Y - 50))
            if nx ~= p.X or ny ~= p.Y then
                toTopLeft()
                main.Position = UDim2.fromOffset(nx / scale.Scale, ny / scale.Scale)
            end
        end
    end

    fitScreen()
    if workspace.CurrentCamera then
        track(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            fitScreen()
            task.defer(clampToScreen)
        end))
    end

    -- ───────────── Selección de pestañas y búsqueda ─────────────
    local resultsPage = make("ScrollingFrame", {
        Name = "SearchResults",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Active = true,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = T.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        Visible = false
    }, content)
    make("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, resultsPage)
    make("UIPadding", {PaddingRight = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)}, resultsPage)

    local function selectEntry(entry)
        currentEntry = entry
        for _, p in ipairs(pages) do
            local on = p == entry
            p.Page.Visible = on and not searching
            animate(p.Button, {BackgroundTransparency = on and 0.35 or 1}, 0.15)
            animate(p.Label, {TextTransparency = on and 0 or 0.25}, 0.15)
            animate(p.Indicator, {BackgroundTransparency = on and 0 or 1}, 0.15)
        end
    end

    local function textsOf(source)
        if type(source) == "table" then
            return {source.ES or "", source.EN or ""}
        end
        return {tostring(source or "")}
    end

    local function matches(source, q)
        for _, t in ipairs(textsOf(source)) do
            if string.find(string.lower(t), q, 1, true) then return true end
        end
        return false
    end

    local function flash(inst)
        local stroke = inst:FindFirstChildOfClass("UIStroke")
        if stroke then
            local oldColor, oldThickness = stroke.Color, stroke.Thickness
            stroke.Color = T.Accent
            stroke.Thickness = 2
            task.delay(1.1, function()
                if stroke.Parent then
                    animate(stroke, {Color = oldColor, Thickness = oldThickness}, 0.3)
                end
            end)
        end
    end

    local function goTo(rec)
        searchBox.Text = ""
        if rec.Reveal then rec.Reveal() end
        selectEntry(rec.Entry)
        task.spawn(function()
            task.wait(0.06)
            local page = rec.Entry.Page
            if page.Parent and rec.Inst.Parent then
                local y = (rec.Inst.AbsolutePosition.Y - page.AbsolutePosition.Y) / scale.Scale
                    + page.CanvasPosition.Y - 10
                page.CanvasPosition = Vector2.new(0, math.max(0, y))
                flash(rec.Inst)
            end
        end)
    end

    local function runSearch()
        local q = string.lower(trim(searchBox.Text))
        for _, c in ipairs(resultsPage:GetChildren()) do
            if c:IsA("GuiObject") then c:Destroy() end
        end
        if q == "" then
            searching = false
            resultsPage.Visible = false
            selectEntry(currentEntry)
            return
        end
        searching = true
        for _, p in ipairs(pages) do p.Page.Visible = false end
        resultsPage.Visible = true

        local shown = 0
        for _, rec in ipairs(searchIndex) do
            if rec.Inst.Parent and matches(rec.Name, q) then
                shown += 1
                if shown > 40 then break end
                local r = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 44),
                    BackgroundColor3 = T.Element,
                    BackgroundTransparency = EA,
                    Text = "",
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    LayoutOrder = shown
                }, resultsPage)
                round(r, 9)
                outline(r, nil, T)
                make("TextLabel", {
                    Position = UDim2.fromOffset(12, 4),
                    Size = UDim2.new(1, -24, 0, 20),
                    BackgroundTransparency = 1,
                    Text = tx(rec.Name),
                    TextColor3 = T.Text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, r)
                make("TextLabel", {
                    Position = UDim2.fromOffset(12, 23),
                    Size = UDim2.new(1, -24, 0, 16),
                    BackgroundTransparency = 1,
                    Text = tx(rec.Entry.Name) .. "  ›  " .. tx(rec.Kind),
                    TextColor3 = T.Muted,
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, r)
                r.Activated:Connect(function() goTo(rec) end)
            end
        end
        if shown == 0 then
            local empty = make("TextLabel", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundTransparency = 1,
                Text = tx(L("Sin resultados.", "No results.")),
                TextColor3 = T.Muted,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            }, resultsPage)
        end
    end
    searchBox:GetPropertyChangedSignal("Text"):Connect(runSearch)
    refreshExtras = function()
        if searching then runSearch() end
    end

    local function unindex(instance)
        for i = #searchIndex, 1, -1 do
            local inst = searchIndex[i].Inst
            if inst == instance or inst:IsDescendantOf(instance) then
                table.remove(searchIndex, i)
            end
        end
    end

    -- ═══════════ Estado, flags y autoguardado ═══════════
    local loaded = false
    local applyingConfig = false
    local saveQueued = false

    local function scheduleSave()
        if not options.AutoSave or not loaded or applyingConfig or saveQueued then
            return
        end
        saveQueued = true
        task.delay(1, function()
            saveQueued = false
            if gui.Parent then Window:SaveConfig() end
        end)
    end

    local function register(opt, get, set)
        if not opt.Flag then return end
        flagItems[opt.Flag] = {get = get, set = set}
        Window.Flags[opt.Flag] = get()
    end

    local function setFlag(opt, value)
        if not opt.Flag then return end
        Window.Flags[opt.Flag] = value
        local list = flagHandlers[opt.Flag]
        if list then
            for _, h in ipairs(list) do spawnCall(h, value) end
        end
        scheduleSave()
    end

    function Window:OnChanged(flag, fn)
        flagHandlers[flag] = flagHandlers[flag] or {}
        table.insert(flagHandlers[flag], fn)
        return function()
            local list = flagHandlers[flag]
            if not list then return end
            for i, f in ipairs(list) do
                if f == fn then
                    table.remove(list, i)
                    break
                end
            end
        end
    end

    -- ───────────── Menú de idioma (dentro de la ventana) ─────────────
    local function closeLanguageMenu()
        if languageMenu then
            languageMenu:Destroy()
            languageMenu = nil
        end
    end

    local function setLanguage(code)
        UI.Language = code
        lang.Text = code
        if miniLang then miniLang.Text = code end
        closeLanguageMenu()
        refreshLanguage()
        spawnCall(options.OnLanguageChanged, code)
        scheduleSave()
    end

    local function showLanguageMenu(anchor)
        if languageMenu then
            closeLanguageMenu()
            return
        end

        local inMain = main.Visible and anchor:IsDescendantOf(main)
        local blocker = make("TextButton", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 199
        }, inMain and main or gui)
        languageMenu = blocker
        blocker.Activated:Connect(closeLanguageMenu)

        local W, H = 150, 94
        local ap, as = anchor.AbsolutePosition, anchor.AbsoluteSize
        local x, y
        if inMain then
            local sc = scale.Scale
            local mp, ms = main.AbsolutePosition, main.AbsoluteSize
            local rx, ry = (ap.X - mp.X) / sc, (ap.Y - mp.Y) / sc
            local aw, ah = as.X / sc, as.Y / sc
            local mw, mh = ms.X / sc, ms.Y / sc
            x = math.clamp(rx + aw - W, 8, math.max(8, mw - W - 8))
            y = ry + ah + 6
            if y + H > mh - 8 then
                y = math.max(8, ry - H - 6)
            end
        else
            local v = gui.AbsoluteSize
            x = math.clamp(ap.X + as.X - W, 8, math.max(8, v.X - W - 8))
            y = ap.Y + as.Y + 6
            if y + H > v.Y - 8 then
                y = math.max(8, ap.Y - H - 6)
            end
        end

        local menu = make("Frame", {
            Position = UDim2.fromOffset(x, y),
            Size = UDim2.fromOffset(W, H),
            BackgroundColor3 = T.Panel,
            BorderSizePixel = 0,
            Active = true,
            ZIndex = 200
        }, blocker)
        round(menu, 10)
        outline(menu, nil, T)

        make("TextLabel", {
            Position = UDim2.fromOffset(10, 4),
            Size = UDim2.new(1, -20, 0, 22),
            BackgroundTransparency = 1,
            Text = UI.Language == "ES" and "IDIOMA" or "LANGUAGE",
            TextColor3 = T.Muted,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 201
        }, menu)

        local function option(text, code, yy)
            local b = make("TextButton", {
                Position = UDim2.fromOffset(6, yy),
                Size = UDim2.new(1, -12, 0, 29),
                BackgroundColor3 = UI.Language == code and T.Border or T.Element,
                Text = text,
                TextColor3 = T.Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                ZIndex = 201
            }, menu)
            round(b, 7)
            b.Activated:Connect(function()
                setLanguage(code)
            end)
        end

        option("Español", "ES", 28)
        option("English", "EN", 60)
    end

    lang.Activated:Connect(function()
        showLanguageMenu(lang)
    end)

    -- ───────────── Barra flotante (NEXUS HUB) ─────────────
    -- Izquierda: flechas para MOVER. Derecha: toca para ABRIR la interfaz.
    mini = make("Frame", {
        Name = "MiniNexus",
        Position = UDim2.new(0.5, -MINI_W / 2, 0, 12),
        Size = UDim2.fromOffset(MINI_W, MINI_H),
        BackgroundColor3 = T.Background,
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 100
    }, gui)
    round(mini, MINI_H / 2)
    local miniStroke = outline(mini, Color3.new(1, 1, 1), T)
    miniStroke.Thickness = 1.5
    miniStroke.Transparency = 0.1
    miniStroke:SetAttribute("NoTheme", true)
    addGradient(miniStroke, 0)

    local miniMove = make("TextButton", {
        Name = "Move",
        Size = UDim2.fromOffset(48, MINI_H),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 101
    }, mini)

    -- Icono de mover: cruz con cuatro flechas (dibujado, sin fuentes)
    local function moveLine(w, h)
        local f = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(w, h),
            BackgroundColor3 = T.Muted,
            BorderSizePixel = 0,
            ZIndex = 102
        }, miniMove)
        round(f, 1)
    end
    moveLine(18, 2)
    moveLine(2, 18)
    local function moveArrow(rot, x, y)
        local holder = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, x, 0.5, y),
            Size = UDim2.fromOffset(10, 10),
            BackgroundTransparency = 1,
            Rotation = rot,
            ZIndex = 102
        }, miniMove)
        makeChevron(holder, T.Muted, 4, 2, 102)
    end
    moveArrow(180, 0, -11)
    moveArrow(0, 0, 11)
    moveArrow(90, -11, 0)
    moveArrow(-90, 11, 0)

    make("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 48, 0.5, 0),
        Size = UDim2.fromOffset(1, MINI_H - 18),
        BackgroundColor3 = T.Border,
        BorderSizePixel = 0,
        ZIndex = 101
    }, mini)

    local miniOpen = make("TextButton", {
        Name = "Open",
        Position = UDim2.fromOffset(49, 0),
        Size = UDim2.new(1, -49, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 101
    }, mini)

    -- Icono circular con figuras de personas (dibujado)
    local miniIcon = make("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 10, 0.5, 0),
        Size = UDim2.fromOffset(30, 30),
        BackgroundColor3 = T.Element,
        BorderSizePixel = 0,
        ZIndex = 102
    }, miniOpen)
    round(miniIcon, 15)
    outline(miniIcon, nil, T)
    local function person(x, y, s, transp)
        local head = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, x, 0.5, y - 5 * s),
            Size = UDim2.fromOffset(6 * s, 6 * s),
            BackgroundColor3 = T.Text,
            BackgroundTransparency = transp,
            BorderSizePixel = 0,
            ZIndex = 103
        }, miniIcon)
        round(head, 6 * s)
        local body = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, x, 0.5, y + 4 * s),
            Size = UDim2.fromOffset(12 * s, 6 * s),
            BackgroundColor3 = T.Text,
            BackgroundTransparency = transp,
            BorderSizePixel = 0,
            ZIndex = 103
        }, miniIcon)
        round(body, 4)
    end
    person(-8, 2, 0.7, 0.4)
    person(8, 2, 0.7, 0.4)
    person(0, 1, 1, 0)

    make("TextLabel", {
        Position = UDim2.fromOffset(48, 0),
        Size = UDim2.new(1, -96, 1, 0),
        BackgroundTransparency = 1,
        RichText = true,
        Text = options.MiniText or "NEXUS HUB",
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 102
    }, miniOpen)

    miniLang = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(36, 28),
        BackgroundColor3 = T.Element,
        Text = UI.Language,
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ZIndex = 103
    }, mini)
    round(miniLang, 14)
    miniLang.Activated:Connect(function()
        showLanguageMenu(miniLang)
    end)

    -- Mover la barra: solo desde las flechas de la izquierda, sin retraso
    local miniStart = Vector2.zero
    drag(miniMove, function()
        miniStart = mini.AbsolutePosition
    end, function(d)
        local v = gui.AbsoluteSize
        local x = math.clamp(miniStart.X + d.X, 0, math.max(0, v.X - MINI_W))
        local y = math.clamp(miniStart.Y + d.Y, 0, math.max(0, v.Y - MINI_H))
        mini.Position = UDim2.fromOffset(x, y)
    end)

    -- ───────────── Redimensionar ─────────────
    local GRIP = TOUCH and 40 or 32
    local grip = make("TextButton", {
        Name = "ResizeGrip",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -4, 1, -4),
        Size = UDim2.fromOffset(GRIP, GRIP),
        BackgroundTransparency = 1,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ZIndex = 10
    }, main)
    local function gripLine(len, off)
        local f = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(1, -off, 1, -off),
            Size = UDim2.fromOffset(len, 2),
            Rotation = -45,
            BackgroundColor3 = T.Muted,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
            ZIndex = 11
        }, grip)
        round(f, 1)
    end
    gripLine(8, 9)
    gripLine(14, 15)

    local originalSize
    drag(grip, function()
        if maximized then return false end
        toTopLeft()
        originalSize = main.Size
    end, function(d)
        local width = math.clamp(originalSize.X.Offset + d.X / scale.Scale, 320, 900)
        local height = math.clamp(originalSize.Y.Offset + d.Y / scale.Scale, 230, 700)
        main.Size = UDim2.fromOffset(width, height)
        savedSize = main.Size
    end)

    -- ───────────── Maximizar / minimizar / restaurar ─────────────
    applyMaximize = function(instant)
        local v, s = gui.AbsoluteSize, scale.Scale
        local pos = UDim2.fromOffset(8 / s, 8 / s)
        local sz = UDim2.fromOffset((v.X - 16) / s, (v.Y - 16) / s)
        if instant then
            main.Position = pos
            main.Size = sz
        else
            animate(main, {Position = pos, Size = sz}, 0.25)
        end
    end

    local function setMaximized(on, instant)
        on = on == true
        if on == maximized then return end
        toTopLeft()
        if on then
            prevPos, prevSize = main.Position, main.Size
            maximized = true
            applyMaximize(instant)
            grip.Visible = false
            maxIcon.Size = UDim2.fromOffset(9, 9)
        else
            maximized = false
            local pos = prevPos or main.Position
            local sz = prevSize or savedSize
            if instant then
                main.Position = pos
                main.Size = sz
            else
                animate(main, {Position = pos, Size = sz}, 0.25)
            end
            savedSize = sz
            grip.Visible = true
            maxIcon.Size = UDim2.fromOffset(12, 12)
        end
    end

    maxButton.Activated:Connect(function()
        closeLanguageMenu()
        setMaximized(not maximized)
    end)

    local function openMain()
        closeLanguageMenu()
        mini.Visible = false
        main.Visible = true
        if maximized then
            applyMaximize(true)
        else
            main.Size = UDim2.fromOffset(savedSize.X.Offset, 55)
            animate(main, {Size = savedSize}, 0.3)
        end
    end

    local function doMinimize()
        closeLanguageMenu()
        if maximized then setMaximized(false, true) end
        savedSize = main.Size
        main.Visible = false
        mini.Visible = true
    end

    miniOpen.Activated:Connect(function()
        openMain()
    end)
    minimize.Activated:Connect(doMinimize)

    -- Tecla para mostrar/ocultar toda la interfaz
    if options.ToggleKey then
        track(UIS.InputBegan:Connect(function(input, processed)
            if processed or UIS:GetFocusedTextBox() then return end
            if input.KeyCode == options.ToggleKey then
                gui.Enabled = not gui.Enabled
            end
        end))
    end

    -- ───────────── Confirmación al cerrar (dentro de la ventana) ─────────────
    local function askClose()
        if options.ConfirmClose == false then
            spawnCall(options.OnClose)
            Window:Destroy()
            return
        end
        if confirmBox then return end

        confirmDim = make("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = T.Shade,
            BackgroundTransparency = 0.35,
            BorderSizePixel = 0,
            Active = true,
            ZIndex = 59
        }, main)
        round(confirmDim, 14)

        confirmBox = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(300, 132),
            BackgroundColor3 = T.Panel,
            BorderSizePixel = 0,
            Active = true,
            ZIndex = 60
        }, confirmDim)
        round(confirmBox, 12)
        outline(confirmBox, T.Accent, T)

        local msg = make("TextLabel", {
            Position = UDim2.fromOffset(14, 12),
            Size = UDim2.new(1, -28, 0, 48),
            BackgroundTransparency = 1,
            TextColor3 = T.Text,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            TextWrapped = true,
            ZIndex = 61
        }, confirmBox)
        bind(msg, "Text", function()
            return UI.Language == "ES"
                and "¿Seguro que quieres cerrar la interfaz?"
                or "Are you sure you want to close the interface?"
        end)

        local function button(es, en, x)
            local b = make("TextButton", {
                Position = UDim2.new(0, x, 1, -46),
                Size = UDim2.fromOffset(130, 34),
                BackgroundColor3 = T.Element,
                TextColor3 = T.Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                ZIndex = 61
            }, confirmBox)
            bind(b, "Text", function() return tx(L(es, en)) end)
            round(b, 8)
            return b
        end

        local yes = button("Sí, cerrar", "Yes, close", 12)
        local no = button("Cancelar", "Cancel", 158)

        yes.Activated:Connect(function()
            spawnCall(options.OnClose)
            Window:Destroy()
        end)
        no.Activated:Connect(function()
            unbind(confirmDim)
            confirmDim:Destroy()
            confirmDim = nil
            confirmBox = nil
        end)
    end
    close.Activated:Connect(askClose)

    -- ═══════════ Configuración y estado ═══════════
    local function windowGeometry()
        if maximized then return nil end
        local p = main.AbsolutePosition
        return {
            x = math.floor(p.X), y = math.floor(p.Y),
            w = math.floor(savedSize.X.Offset), h = math.floor(savedSize.Y.Offset)
        }
    end

    local function applyGeometry(g)
        if type(g) ~= "table" or maximized then return end
        if type(g.w) == "number" and type(g.h) == "number" then
            toTopLeft()
            main.Size = UDim2.fromOffset(math.clamp(g.w, 320, 900), math.clamp(g.h, 230, 700))
            savedSize = main.Size
        end
        if type(g.x) == "number" and type(g.y) == "number" then
            toTopLeft()
            main.Position = UDim2.fromOffset(g.x / scale.Scale, g.y / scale.Scale)
            task.defer(clampToScreen)
        end
    end

    function Window:CanPersist()
        return store.Persistent ~= false
    end

    function Window:ExportConfig()
        local flags = {}
        for flag, item in pairs(flagItems) do
            flags[flag] = item.get()
        end
        local data = {
            version = 6,
            flags = flags,
            meta = {
                theme = themeName,
                language = UI.Language,
                scale = userScale,
                window = windowGeometry()
            }
        }
        local ok, json = pcall(function()
            return HttpService:JSONEncode(data)
        end)
        if ok then return json end
        return nil
    end

    function Window:ImportConfig(json)
        if type(json) ~= "string" then return false end
        local ok, data = pcall(function()
            return HttpService:JSONDecode(json)
        end)
        if not ok or type(data) ~= "table" then return false end

        local flags, meta = data.flags, data.meta
        if flags == nil then flags = data end   -- formato plano de v5.x

        applyingConfig = true
        for flag, value in pairs(flags) do
            local item = flagItems[flag]
            if item then pcall(item.set, value) end
        end
        if type(meta) == "table" and options.RestoreLayout ~= false then
            if type(meta.theme) == "string" and UI.Themes[meta.theme] then
                Window:SetTheme(meta.theme)
            end
            if meta.language == "ES" or meta.language == "EN" then
                setLanguage(meta.language)
            end
            if type(meta.scale) == "number" then
                Window:SetUIScale(meta.scale)
            end
            applyGeometry(meta.window)
        end
        applyingConfig = false
        return true
    end

    function Window:SaveConfig(name)
        local json = Window:ExportConfig()
        if not json then return false end
        return store.Save(name or options.ConfigName or "default", json) == true
    end

    function Window:LoadConfig(name)
        local json = store.Load(name or options.ConfigName or "default")
        if not json then return false end
        return Window:ImportConfig(json)
    end

    function Window:DeleteConfig(name)
        if not store.Delete then return false end
        return store.Delete(name or options.ConfigName or "default") == true
    end

    function Window:ListConfigs()
        if not store.List then return {} end
        local out = {}
        for _, n in ipairs(store.List()) do
            if string.sub(n, 1, 1) ~= "_" then table.insert(out, n) end
        end
        return out
    end

    -- ═══════════ Temas en caliente ═══════════
    local function applyTheme(newColors, name)
        local map = {}
        for k, v in pairs(T) do
            if typeof(v) == "Color3" and typeof(newColors[k]) == "Color3" then
                local id = cid(v)
                if map[id] == nil then map[id] = newColors[k] end
            end
        end
        for k, v in pairs(newColors) do
            if T[k] ~= nil then T[k] = v end
        end
        recolor(gui, map)
        for i = #gradients, 1, -1 do
            local g = gradients[i]
            if g.Parent then
                g.Color = ColorSequence.new(T.Accent, T.Accent2)
            else
                table.remove(gradients, i)
            end
        end
        if shadeFrame then shadeFrame.BackgroundTransparency = T.ShadeAlpha end
        themeName = name
        scheduleSave()
    end

    function Window:SetTheme(theme)
        if type(theme) == "string" then
            local def = UI.Themes[theme]
            if not def then
                warn("[NexusUI] Tema desconocido: " .. theme)
                return false
            end
            applyTheme(def, theme)
            return true
        elseif type(theme) == "table" then
            applyTheme(theme, "Custom")
            return true
        end
        return false
    end

    function Window:GetTheme()
        return themeName, copyTable(T)
    end

    function Window:SetAccent(color, color2)
        if typeof(color) ~= "Color3" then return false end
        applyTheme({Accent = color, Accent2 = typeof(color2) == "Color3" and color2 or color}, "Custom")
        return true
    end

    function Window:SetUIScale(n)
        if type(n) ~= "number" then return false end
        userScale = math.clamp(n, 0.6, 1.4)
        fitScreen()
        task.defer(clampToScreen)
        scheduleSave()
        return true
    end

    function Window:SetReduceMotion(on)
        UI.ReduceMotion = on == true
    end

    -- ═══════════ API de componentes ═══════════
    local function newApi(instance, cleanup, opt)
        local a = {Instance = instance}
        function a:Destroy()
            if cleanup then cleanup() end
            unbind(instance)
            unindex(instance)
            if opt and opt.Flag then
                flagItems[opt.Flag] = nil
                Window.Flags[opt.Flag] = nil
            end
            instance:Destroy()
        end
        function a:SetVisible(v)
            instance.Visible = v == true
        end
        return a
    end

    local categories, categoryCount, tabCount = {}, 0, 0

    function Window:CreateTab(config)
        config = config or {}
        local nameSource = config.Name or "Tab"

        tabCount += 1
        local order = tabCount

        -- Categorías en la barra lateral (se pliegan con su flecha)
        local cat
        if config.Category ~= nil then
            local ck = key(config.Category)
            cat = categories[ck]
            if not cat then
                categoryCount += 1
                cat = {Index = categoryCount, Tabs = {}, Open = true}
                categories[ck] = cat
                local current = cat
                local src = config.Category

                local header = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    LayoutOrder = categoryCount * 1000
                }, tabList)
                local lbl = make("TextLabel", {
                    Position = UDim2.fromOffset(6, 0),
                    Size = UDim2.new(1, -30, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = T.Muted,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, header)
                bind(lbl, "Text", function() return tx(src) end)
                local arrow = make("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -4, 0.5, 0),
                    Size = UDim2.fromOffset(18, 18),
                    BackgroundTransparency = 1,
                    Rotation = 180
                }, header)
                makeChevron(arrow, T.Muted, 6, 2, 1)

                function current.SetOpen(v)
                    v = v == true
                    current.Open = v
                    animate(arrow, {Rotation = v and 180 or 0}, 0.18)
                    for _, tb in ipairs(current.Tabs) do
                        if v then
                            tb.Visible = true
                            animate(tb, {Size = UDim2.new(1, 0, 0, 34)}, 0.18)
                        else
                            animate(tb, {Size = UDim2.new(1, 0, 0, 0)}, 0.18)
                            task.delay(0.2, function()
                                if tb.Parent and not current.Open then
                                    tb.Visible = false
                                end
                            end)
                        end
                    end
                end
                header.Activated:Connect(function()
                    current.SetOpen(not current.Open)
                end)
            end
            order = cat.Index * 1000 + tabCount
        end

        local tabButton = make("TextButton", {
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = T.Border,
            BackgroundTransparency = 1,
            Text = "",
            BorderSizePixel = 0,
            AutoButtonColor = false,
            ClipsDescendants = true,
            LayoutOrder = order
        }, tabList)
        round(tabButton, 9)

        local tabLabel = make("TextLabel", {
            Position = UDim2.fromOffset(34, 0),
            Size = UDim2.new(1, -40, 1, 0),
            BackgroundTransparency = 1,
            TextColor3 = T.Text,
            TextTransparency = 0.25,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left
        }, tabButton)
        bind(tabLabel, "Text", function() return tx(nameSource) end)

        -- Icono: imagen propia (config.Icon) o un punto de acento
        local tabIconId = asset(config.Icon)
        if tabIconId ~= "" then
            make("ImageLabel", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 12, 0.5, 0),
                Size = UDim2.fromOffset(16, 16),
                BackgroundTransparency = 1,
                Image = tabIconId,
                ImageColor3 = T.Text
            }, tabButton)
        else
            local dot = make("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0, 20, 0.5, 0),
                Size = UDim2.fromOffset(6, 6),
                BackgroundColor3 = T.Accent,
                BorderSizePixel = 0
            }, tabButton)
            round(dot, 3)
        end
        if cat then
            table.insert(cat.Tabs, tabButton)
            if not cat.Open then
                tabButton.Visible = false
                tabButton.Size = UDim2.new(1, 0, 0, 0)
            end
        end

        local indicator = gradientFrame({
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 2, 0.5, 0),
            Size = UDim2.new(0, 3, 0.5, 0),
            BackgroundTransparency = 1
        }, tabButton, 90)
        round(indicator, 3)

        local page = make("ScrollingFrame", {
            Name = key(nameSource),
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Active = true,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = T.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            Visible = false
        }, content)

        make("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, page)

        make("UIPadding", {
            PaddingRight = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5)
        }, page)

        local entry = {Name = nameSource, Button = tabButton, Label = tabLabel, Page = page, Indicator = indicator}
        table.insert(pages, entry)

        tabButton.Activated:Connect(function()
            if searching then searchBox.Text = "" end
            selectEntry(entry)
        end)
        if #pages == 1 then selectEntry(entry) end

        -- ───────────── Constructor de componentes ─────────────
        -- Se usa para la pestaña y para cada grupo plegable.
        local function buildComponents(container, ctx)
            local Tab = {}

            -- Conexiones propias de cada componente (se liberan en :Destroy())
            local function scoped()
                local mine = {}
                local function t(c)
                    mine[#mine + 1] = c
                    return track(c)
                end
                local function cleanup()
                    for _, c in ipairs(mine) do c:Disconnect() end
                    mine = {}
                end
                return t, cleanup
            end

            local function index(inst, nameSource_, kindEs, kindEn)
                table.insert(searchIndex, {
                    Inst = inst, Name = nameSource_, Kind = L(kindEs, kindEn),
                    Entry = ctx.entry, Reveal = ctx.reveal
                })
            end

            local function card(height)
                local b = make("TextButton", {
                    Name = "Element",
                    Size = UDim2.new(1, 0, 0, height),
                    BackgroundColor3 = T.Element,
                    BackgroundTransparency = EA,
                    Text = "",
                    BorderSizePixel = 0,
                    AutoButtonColor = false
                }, container)
                round(b, 9)
                outline(b, nil, T)
                return b
            end

            local function nameLabel(parentObj, source, width, defaultName)
                local l = make("TextLabel", {
                    Position = UDim2.fromOffset(12, 0),
                    Size = UDim2.new(1, width, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = T.Text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, parentObj)
                bind(l, "Text", function() return tx(source or defaultName) end)
                return l
            end

            function Tab:CreateSection(name)
                local l = make("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 22),
                    BackgroundTransparency = 1,
                    TextColor3 = T.Muted,
                    Font = Enum.Font.GothamBold,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, container)
                bind(l, "Text", function() return string.upper(tx(name)) end)
                return newApi(l)
            end

            function Tab:CreateDivider()
                local d = make("Frame", {
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = T.Border,
                    BackgroundTransparency = 0.4,
                    BorderSizePixel = 0
                }, container)
                return newApi(d)
            end

            function Tab:CreateLabel(text)
                local l = make("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundTransparency = 1,
                    TextColor3 = T.Muted,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, container)
                bind(l, "Text", function() return tx(text) end)
                local api = newApi(l)
                function api:Set(newText)
                    text = newText
                    l.Text = tx(text)
                end
                return api
            end

            function Tab:CreateParagraph(opt)
                opt = opt or {}
                local f = make("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = T.Element,
                    BackgroundTransparency = EA,
                    BorderSizePixel = 0
                }, container)
                round(f, 9)
                outline(f, nil, T)
                make("UIPadding", {
                    PaddingTop = UDim.new(0, 9), PaddingBottom = UDim.new(0, 9),
                    PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)
                }, f)
                make("UIListLayout", {
                    Padding = UDim.new(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }, f)

                local title = make("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    TextColor3 = T.Text,
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    LayoutOrder = 1
                }, f)
                bind(title, "Text", function() return tx(opt.Title or "") end)

                local body = make("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    TextColor3 = T.Muted,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    LayoutOrder = 2
                }, f)
                bind(body, "Text", function() return tx(opt.Content or "") end)

                if opt.Title ~= nil then
                    index(f, opt.Title, "Párrafo", "Paragraph")
                end

                local api = newApi(f)
                function api:Set(data)
                    data = data or {}
                    if data.Title ~= nil then opt.Title = data.Title end
                    if data.Content ~= nil then opt.Content = data.Content end
                    title.Text = tx(opt.Title or "")
                    body.Text = tx(opt.Content or "")
                end
                return api
            end

            function Tab:CreateButton(opt)
                opt = opt or {}
                local b = card(42)
                nameLabel(b, opt.Name, -24, "Button")

                local function fire()
                    animate(b, {BackgroundColor3 = T.Border}, 0.08)
                    task.delay(0.12, function()
                        if b.Parent then animate(b, {BackgroundColor3 = T.Element}) end
                    end)
                    spawnCall(opt.Callback)
                end
                b.Activated:Connect(fire)

                index(b, opt.Name or "Button", "Botón", "Button")
                local api = newApi(b, nil, opt)
                api.Fire = fire
                return api
            end

            function Tab:CreateToggle(opt)
                opt = opt or {}
                local state = opt.CurrentValue == true
                local b = card(42)
                nameLabel(b, opt.Name, -70, "Toggle")

                local trackBar = make("Frame", {
                    Position = UDim2.new(1, -50, 0.5, -9),
                    Size = UDim2.fromOffset(38, 18),
                    BackgroundColor3 = T.Border,
                    BorderSizePixel = 0
                }, b)
                round(trackBar, 15)

                local knob = make("Frame", {
                    Position = UDim2.fromOffset(2, 2),
                    Size = UDim2.fromOffset(14, 14),
                    BackgroundColor3 = T.Text,
                    BorderSizePixel = 0
                }, trackBar)
                round(knob, 12)

                local function update(call)
                    animate(trackBar, {BackgroundColor3 = state and T.Accent or T.Border})
                    animate(knob, {Position = UDim2.fromOffset(state and 22 or 2, 2)})
                    setFlag(opt, state)
                    if call then spawnCall(opt.Callback, state) end
                end

                b.Activated:Connect(function()
                    state = not state
                    update(true)
                end)

                index(b, opt.Name or "Toggle", "Interruptor", "Toggle")
                local api = newApi(b, nil, opt)
                function api:Set(v) state = v == true; update(true) end
                function api:Get() return state end
                register(opt, function() return state end, function(v)
                    state = v == true
                    update(true)
                end)
                update(false)
                return api
            end

            function Tab:CreateSlider(opt)
                opt = opt or {}
                local track, cleanup = scoped()
                local min = opt.Range and opt.Range[1] or 0
                local max = opt.Range and opt.Range[2] or 100
                local inc = opt.Increment or 1
                local suffix = opt.Suffix or ""

                local function snap(v)
                    v = math.clamp(v, min, max)
                    return math.clamp(math.floor((v - min) / inc + 0.5) * inc + min, min, max)
                end
                local value = snap(opt.CurrentValue or min)

                local b = card(60)
                local label = make("TextLabel", {
                    Position = UDim2.fromOffset(12, 4),
                    Size = UDim2.new(1, -24, 0, 23),
                    BackgroundTransparency = 1,
                    TextColor3 = T.Text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, b)
                local function labelText()
                    return tx(opt.Name or "Slider") .. ": " .. formatNumber(value) .. suffix
                end
                bind(label, "Text", labelText)

                local bar = make("Frame", {
                    Position = UDim2.new(0, 12, 0, 38),
                    Size = UDim2.new(1, -24, 0, 6),
                    BackgroundColor3 = T.Border,
                    BorderSizePixel = 0,
                    Active = true
                }, b)
                round(bar, 6)

                local function pct()
                    return (value - min) / math.max(max - min, 0.0001)
                end

                local fill = gradientFrame({Size = UDim2.new(pct(), 0, 1, 0)}, bar, 0)
                round(fill, 6)

                local function apply(v, call, force)
                    local nv = snap(v)
                    local changed = nv ~= value
                    value = nv
                    fill.Size = UDim2.new(pct(), 0, 1, 0)
                    label.Text = labelText()
                    setFlag(opt, value)
                    if call and (changed or force) then
                        spawnCall(opt.Callback, value)
                    end
                end

                local dragging = false
                local function fromX(x)
                    local p = math.clamp(
                        (x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
                    apply(min + (max - min) * p, true, false)
                end

                bar.InputBegan:Connect(function(input)
                    if isPress(input) then
                        dragging = true
                        fromX(input.Position.X)
                    end
                end)
                track(UIS.InputChanged:Connect(function(input)
                    if dragging and isMove(input) then
                        fromX(input.Position.X)
                    end
                end))
                track(UIS.InputEnded:Connect(function(input)
                    if isPress(input) then dragging = false end
                end))

                index(b, opt.Name or "Slider", "Deslizador", "Slider")
                local api = newApi(b, cleanup, opt)
                function api:Get() return value end
                function api:Set(v) apply(v, true, true) end
                register(opt, function() return value end, function(v)
                    if type(v) == "number" then apply(v, true, true) end
                end)
                setFlag(opt, value)
                return api
            end

            -- Dropdown desplegable (se expande dentro de la página)
            function Tab:CreateDropdown(opt)
                opt = opt or {}
                local choices = opt.Options or {}
                local idx = 1
                local HEAD, ROW = 42, 30
                local open = false

                local function findIndex(v)
                    for i, c in ipairs(choices) do
                        if c == v or key(c) == key(v) then return i end
                    end
                    return nil
                end
                if opt.CurrentOption ~= nil then
                    idx = findIndex(opt.CurrentOption) or 1
                end

                local holder = make("Frame", {
                    Name = "Dropdown",
                    Size = UDim2.new(1, 0, 0, HEAD),
                    BackgroundColor3 = T.Element,
                    BackgroundTransparency = EA,
                    BorderSizePixel = 0,
                    ClipsDescendants = true
                }, container)
                round(holder, 9)
                outline(holder, nil, T)

                local head = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, HEAD),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false
                }, holder)

                local label = make("TextLabel", {
                    Position = UDim2.fromOffset(12, 0),
                    Size = UDim2.new(1, -44, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = T.Text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, head)

                local arrow = make("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -12, 0.5, 0),
                    Size = UDim2.fromOffset(18, 18),
                    BackgroundTransparency = 1
                }, head)
                makeChevron(arrow, T.Muted, 6, 2, 1)

                local list = make("Frame", {
                    Position = UDim2.fromOffset(0, HEAD),
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1
                }, holder)

                local function labelText()
                    return tx(opt.Name or "Dropdown") .. ": "
                        .. (choices[idx] ~= nil and tx(choices[idx]) or "—")
                end
                bind(label, "Text", labelText)

                local function listHeight()
                    return #choices * ROW + 8
                end

                local function setOpen(v)
                    open = v
                    animate(holder, {
                        Size = UDim2.new(1, 0, 0, open and (HEAD + listHeight()) or HEAD)
                    }, 0.18)
                    animate(arrow, {Rotation = open and 180 or 0}, 0.18)
                end

                local function choose(i, call)
                    if not choices[i] then return end
                    idx = i
                    label.Text = labelText()
                    setFlag(opt, idx)
                    for _, child in ipairs(list:GetChildren()) do
                        if child:IsA("TextButton") then
                            local active = child:GetAttribute("Index") == idx
                            animate(child, {BackgroundColor3 = active and T.Border or T.Element})
                        end
                    end
                    if call then
                        spawnCall(opt.Callback, key(choices[idx]), idx)
                    end
                end

                local function build()
                    unbind(list)
                    for _, child in ipairs(list:GetChildren()) do
                        child:Destroy()
                    end
                    list.Size = UDim2.new(1, 0, 0, listHeight())
                    for i, choice in ipairs(choices) do
                        local o = make("TextButton", {
                            Position = UDim2.fromOffset(6, 4 + (i - 1) * ROW),
                            Size = UDim2.new(1, -12, 0, ROW - 4),
                            BackgroundColor3 = i == idx and T.Border or T.Element,
                            TextColor3 = T.Text,
                            Font = Enum.Font.GothamMedium,
                            TextSize = 11,
                            BorderSizePixel = 0,
                            AutoButtonColor = false
                        }, list)
                        o:SetAttribute("Index", i)
                        round(o, 7)
                        bind(o, "Text", function() return tx(choice) end)
                        o.Activated:Connect(function()
                            choose(i, true)
                            setOpen(false)
                        end)
                    end
                    if open then
                        holder.Size = UDim2.new(1, 0, 0, HEAD + listHeight())
                    end
                end
                build()

                head.Activated:Connect(function()
                    setOpen(not open)
                end)

                index(holder, opt.Name or "Dropdown", "Lista", "Dropdown")
                local api = newApi(holder, nil, opt)
                function api:Get() return key(choices[idx]), idx end
                function api:Set(v)
                    local i = type(v) == "number" and v or findIndex(v)
                    if i then choose(i, true) end
                end
                function api:Refresh(newOptions, keepSelection)
                    choices = newOptions or {}
                    if not keepSelection or idx > #choices then idx = 1 end
                    label.Text = labelText()
                    build()
                end
                register(opt, function() return idx end, function(v)
                    if type(v) == "number" then choose(v, true) end
                end)
                setFlag(opt, idx)
                return api
            end

            -- Dropdown de selección múltiple
            function Tab:CreateMultiDropdown(opt)
                opt = opt or {}
                local choices = opt.Options or {}
                local selected = {}
                for _, k in ipairs(opt.CurrentOptions or {}) do
                    selected[key(k)] = true
                end
                local HEAD, ROW = 42, 30
                local open = false

                local holder = make("Frame", {
                    Name = "MultiDropdown",
                    Size = UDim2.new(1, 0, 0, HEAD),
                    BackgroundColor3 = T.Element,
                    BackgroundTransparency = EA,
                    BorderSizePixel = 0,
                    ClipsDescendants = true
                }, container)
                round(holder, 9)
                outline(holder, nil, T)

                local head = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, HEAD),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false
                }, holder)

                local label = make("TextLabel", {
                    Position = UDim2.fromOffset(12, 0),
                    Size = UDim2.new(1, -44, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = T.Text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, head)

                local arrow = make("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -12, 0.5, 0),
                    Size = UDim2.fromOffset(18, 18),
                    BackgroundTransparency = 1
                }, head)
                makeChevron(arrow, T.Muted, 6, 2, 1)

                local list = make("Frame", {
                    Position = UDim2.fromOffset(0, HEAD),
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1
                }, holder)

                local function summary()
                    local names = {}
                    for _, c in ipairs(choices) do
                        if selected[key(c)] then table.insert(names, tx(c)) end
                    end
                    if #names == 0 then return "—" end
                    return table.concat(names, ", ")
                end
                local function labelText()
                    return tx(opt.Name or "Dropdown") .. ": " .. summary()
                end
                bind(label, "Text", labelText)

                local function getList()
                    local out = {}
                    for _, c in ipairs(choices) do
                        if selected[key(c)] then table.insert(out, key(c)) end
                    end
                    return out
                end

                local function listHeight()
                    return #choices * ROW + 8
                end

                local function setOpen(value)
                    open = value
                    animate(holder, {
                        Size = UDim2.new(1, 0, 0, open and (HEAD + listHeight()) or HEAD)
                    }, 0.18)
                    animate(arrow, {Rotation = open and 180 or 0}, 0.18)
                end

                local function paint()
                    for _, child in ipairs(list:GetChildren()) do
                        if child:IsA("TextButton") then
                            local c = choices[child:GetAttribute("Index")]
                            local on = c ~= nil and selected[key(c)] == true
                            animate(child, {BackgroundColor3 = on and T.Border or T.Element})
                        end
                    end
                end

                local function changed(call)
                    label.Text = labelText()
                    paint()
                    local result = getList()
                    setFlag(opt, result)
                    if call then spawnCall(opt.Callback, result) end
                end

                local function build()
                    unbind(list)
                    for _, child in ipairs(list:GetChildren()) do
                        child:Destroy()
                    end
                    list.Size = UDim2.new(1, 0, 0, listHeight())
                    for i, choice in ipairs(choices) do
                        local o = make("TextButton", {
                            Position = UDim2.fromOffset(6, 4 + (i - 1) * ROW),
                            Size = UDim2.new(1, -12, 0, ROW - 4),
                            BackgroundColor3 = selected[key(choice)] and T.Border or T.Element,
                            TextColor3 = T.Text,
                            Font = Enum.Font.GothamMedium,
                            TextSize = 11,
                            BorderSizePixel = 0,
                            AutoButtonColor = false
                        }, list)
                        o:SetAttribute("Index", i)
                        round(o, 7)
                        bind(o, "Text", function() return tx(choice) end)
                        o.Activated:Connect(function()
                            local k = key(choice)
                            if selected[k] then
                                selected[k] = nil
                            else
                                selected[k] = true
                            end
                            changed(true)
                        end)
                    end
                    if open then
                        holder.Size = UDim2.new(1, 0, 0, HEAD + listHeight())
                    end
                end
                build()

                head.Activated:Connect(function()
                    setOpen(not open)
                end)

                index(holder, opt.Name or "Dropdown", "Selección múltiple", "Multi-select")
                local api = newApi(holder, nil, opt)
                function api:Get() return getList() end
                function api:Set(values)
                    selected = {}
                    for _, k in ipairs(values or {}) do
                        selected[key(k)] = true
                    end
                    changed(true)
                end
                function api:Refresh(newOptions)
                    choices = newOptions or {}
                    build()
                    changed(false)
                end
                register(opt, getList, function(value)
                    if type(value) == "table" then api:Set(value) end
                end)
                setFlag(opt, getList())
                return api
            end

            function Tab:CreateInput(opt)
                opt = opt or {}
                local value = tostring(opt.CurrentValue or "")
                local b = card(42)
                nameLabel(b, opt.Name, -150, "Input")

                local box = make("TextBox", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.fromOffset(124, 28),
                    BackgroundColor3 = T.Background,
                    BackgroundTransparency = 0.2,
                    Text = value,
                    PlaceholderColor3 = T.Muted,
                    TextColor3 = T.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    ClearTextOnFocus = false,
                    ClipsDescendants = true,
                    BorderSizePixel = 0
                }, b)
                round(box, 6)
                bind(box, "PlaceholderText", function()
                    return tx(opt.Placeholder or "...")
                end)

                local function commit(text, call)
                    if opt.Numeric then
                        local n = tonumber(text)
                        if n == nil then
                            box.Text = value
                            return
                        end
                        text = tostring(n)
                    end
                    value = text
                    box.Text = value
                    setFlag(opt, value)
                    if call then
                        spawnCall(opt.Callback, opt.Numeric and tonumber(value) or value)
                    end
                end

                box.FocusLost:Connect(function()
                    commit(box.Text, true)
                end)

                index(b, opt.Name or "Input", "Campo de texto", "Input")
                local api = newApi(b, nil, opt)
                function api:Get() return opt.Numeric and tonumber(value) or value end
                function api:Set(v) commit(tostring(v), true) end
                register(opt, function() return value end, function(v)
                    commit(tostring(v), true)
                end)
                setFlag(opt, value)
                return api
            end

            function Tab:CreateKeybind(opt)
                opt = opt or {}
                local track, cleanup = scoped()
                local current = opt.CurrentKeybind or Enum.KeyCode.Unknown
                local listening = false
                local b = card(42)
                nameLabel(b, opt.Name, -110, "Keybind")

                local btn = make("TextButton", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.fromOffset(84, 28),
                    BackgroundColor3 = T.Background,
                    BackgroundTransparency = 0.2,
                    TextColor3 = T.Text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,
                    BorderSizePixel = 0,
                    AutoButtonColor = false
                }, b)
                round(btn, 6)

                local function render()
                    if listening then
                        btn.Text = "..."
                    elseif current == Enum.KeyCode.Unknown then
                        btn.Text = "—"
                    else
                        btn.Text = current.Name
                    end
                end
                render()

                btn.Activated:Connect(function()
                    listening = true
                    render()
                end)

                track(UIS.InputBegan:Connect(function(input, processed)
                    if listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            listening = false
                            if input.KeyCode ~= Enum.KeyCode.Escape then
                                current = input.KeyCode
                                setFlag(opt, current.Name)
                                spawnCall(opt.OnChanged, current)
                            end
                            render()
                        end
                        return
                    end
                    if processed then return end
                    if current ~= Enum.KeyCode.Unknown and input.KeyCode == current then
                        spawnCall(opt.Callback, current)
                    end
                end))

                index(b, opt.Name or "Keybind", "Atajo de teclado", "Keybind")
                local api = newApi(b, cleanup, opt)
                function api:Get() return current end
                function api:Set(k)
                    if typeof(k) == "EnumItem" then
                        current = k
                        setFlag(opt, current.Name)
                        render()
                    end
                end
                register(opt, function() return current.Name end, function(v)
                    local ok, kc = pcall(function() return Enum.KeyCode[v] end)
                    if ok and kc then
                        current = kc
                        render()
                    end
                end)
                setFlag(opt, current.Name)
                return api
            end

            -- Selector de color (tono / saturación / brillo)
            function Tab:CreateColorPicker(opt)
                opt = opt or {}
                local track, cleanup = scoped()
                local color = typeof(opt.CurrentValue) == "Color3"
                    and opt.CurrentValue or Color3.fromRGB(255, 255, 255)
                local h, s, v = color:ToHSV()
                local HEAD, BODY = 42, 104
                local open = false

                local holder = make("Frame", {
                    Name = "ColorPicker",
                    Size = UDim2.new(1, 0, 0, HEAD),
                    BackgroundColor3 = T.Element,
                    BackgroundTransparency = EA,
                    BorderSizePixel = 0,
                    ClipsDescendants = true
                }, container)
                round(holder, 9)
                outline(holder, nil, T)

                local head = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, HEAD),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false
                }, holder)
                nameLabel(head, opt.Name, -130, "Color")

                local hexLabel = make("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -56, 0.5, 0),
                    Size = UDim2.fromOffset(62, 18),
                    BackgroundTransparency = 1,
                    TextColor3 = T.Muted,
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Right
                }, head)

                local swatch = make("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -12, 0.5, 0),
                    Size = UDim2.fromOffset(34, 20),
                    BackgroundColor3 = color,
                    BorderSizePixel = 0
                }, head)
                swatch:SetAttribute("NoTheme", true)
                round(swatch, 6)
                outline(swatch, nil, T)

                local body = make("Frame", {
                    Position = UDim2.fromOffset(0, HEAD),
                    Size = UDim2.new(1, 0, 0, BODY),
                    BackgroundTransparency = 1
                }, holder)

                local function toHex(c)
                    return string.format("#%02X%02X%02X",
                        math.floor(c.R * 255 + 0.5),
                        math.floor(c.G * 255 + 0.5),
                        math.floor(c.B * 255 + 0.5))
                end

                local hueBar, satBar, valBar

                local function refresh(call)
                    color = Color3.fromHSV(h, s, v)
                    swatch.BackgroundColor3 = color
                    hexLabel.Text = toHex(color)
                    hueBar.Knob.Position = UDim2.new(h, 0, 0.5, 0)
                    satBar.Knob.Position = UDim2.new(s, 0, 0.5, 0)
                    valBar.Knob.Position = UDim2.new(v, 0, 0.5, 0)
                    satBar.Grad.Color = ColorSequence.new(
                        Color3.fromHSV(h, 0, v), Color3.fromHSV(h, 1, v))
                    valBar.Grad.Color = ColorSequence.new(
                        Color3.new(0, 0, 0), Color3.fromHSV(h, s, 1))
                    setFlag(opt, toHex(color))
                    if call then spawnCall(opt.Callback, color) end
                end

                local function makeBar(y, onPct)
                    local bar = make("Frame", {
                        Position = UDim2.new(0, 14, 0, y),
                        Size = UDim2.new(1, -28, 0, 12),
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        BorderSizePixel = 0,
                        Active = true
                    }, body)
                    bar:SetAttribute("NoTheme", true)
                    round(bar, 6)
                    local grad = make("UIGradient", {}, bar)
                    local knob = make("Frame", {
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0, 0, 0.5, 0),
                        Size = UDim2.fromOffset(16, 16),
                        BackgroundColor3 = T.Text,
                        BorderSizePixel = 0,
                        ZIndex = 2
                    }, bar)
                    round(knob, 8)
                    outline(knob, T.Background, T)

                    local dragging = false
                    local function fromX(x)
                        onPct(math.clamp(
                            (x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1))
                    end
                    bar.InputBegan:Connect(function(input)
                        if isPress(input) then
                            dragging = true
                            fromX(input.Position.X)
                        end
                    end)
                    track(UIS.InputChanged:Connect(function(input)
                        if dragging and isMove(input) then
                            fromX(input.Position.X)
                        end
                    end))
                    track(UIS.InputEnded:Connect(function(input)
                        if isPress(input) then dragging = false end
                    end))
                    return {Bar = bar, Grad = grad, Knob = knob}
                end

                hueBar = makeBar(16, function(p) h = p; refresh(true) end)
                satBar = makeBar(48, function(p) s = p; refresh(true) end)
                valBar = makeBar(80, function(p) v = p; refresh(true) end)

                hueBar.Grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(1 / 6, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(2 / 6, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(3 / 6, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(4 / 6, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(5 / 6, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                })

                head.Activated:Connect(function()
                    open = not open
                    animate(holder, {
                        Size = UDim2.new(1, 0, 0, open and (HEAD + BODY) or HEAD)
                    }, 0.18)
                end)

                index(holder, opt.Name or "Color", "Selector de color", "Color picker")
                local api = newApi(holder, cleanup, opt)
                function api:Get() return color end
                function api:Set(c)
                    if typeof(c) == "Color3" then
                        h, s, v = c:ToHSV()
                        refresh(true)
                    end
                end
                register(opt, function() return toHex(color) end, function(value)
                    local ok, c = pcall(function() return Color3.fromHex(value) end)
                    if ok and c then api:Set(c) end
                end)
                refresh(false)
                return api
            end

            -- Barra de progreso
            function Tab:CreateProgressBar(opt)
                opt = opt or {}
                local value = math.clamp(tonumber(opt.CurrentValue) or 0, 0, 1)
                local b = card(54)

                local label = make("TextLabel", {
                    Position = UDim2.fromOffset(12, 4),
                    Size = UDim2.new(1, -90, 0, 24),
                    BackgroundTransparency = 1,
                    TextColor3 = T.Text,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 12,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, b)
                bind(label, "Text", function() return tx(opt.Name or "Progress") end)

                local valueLabel = make("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -12, 0, 4),
                    Size = UDim2.fromOffset(70, 24),
                    BackgroundTransparency = 1,
                    TextColor3 = T.Muted,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Right
                }, b)

                local bar = make("Frame", {
                    Position = UDim2.new(0, 12, 0, 36),
                    Size = UDim2.new(1, -24, 0, 6),
                    BackgroundColor3 = T.Border,
                    BorderSizePixel = 0
                }, b)
                round(bar, 6)
                local fill = gradientFrame({Size = UDim2.new(value, 0, 1, 0)}, bar, 0)
                round(fill, 6)

                local function render(text)
                    animate(fill, {Size = UDim2.new(value, 0, 1, 0)}, 0.2)
                    valueLabel.Text = text or (math.floor(value * 100 + 0.5) .. "%")
                end
                render()

                index(b, opt.Name or "Progress", "Progreso", "Progress")
                local api = newApi(b, nil, opt)
                function api:Set(v, text)
                    value = math.clamp(tonumber(v) or 0, 0, 1)
                    render(text)
                end
                function api:Get() return value end
                return api
            end

            -- Grupo plegable: contiene los mismos componentes
            function Tab:CreateGroup(opt)
                opt = opt or {}
                local open = opt.Open ~= false

                local holder = make("Frame", {
                    Name = "Group",
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = T.Element,
                    BackgroundTransparency = EA,
                    BorderSizePixel = 0
                }, container)
                round(holder, 9)
                outline(holder, nil, T)
                make("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, holder)

                local head = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    LayoutOrder = 1
                }, holder)
                local title = nameLabel(head, opt.Name, -44, "Group")
                title.Font = Enum.Font.GothamBold

                local arrow = make("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -12, 0.5, 0),
                    Size = UDim2.fromOffset(18, 18),
                    BackgroundTransparency = 1,
                    Rotation = open and 180 or 0
                }, head)
                makeChevron(arrow, T.Muted, 6, 2, 1)

                local body = make("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Visible = open,
                    LayoutOrder = 2
                }, holder)
                make("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }, body)
                make("UIPadding", {
                    PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8)
                }, body)

                local function setOpen(v)
                    open = v == true
                    body.Visible = open
                    animate(arrow, {Rotation = open and 180 or 0}, 0.15)
                end
                head.Activated:Connect(function()
                    setOpen(not open)
                end)

                index(holder, opt.Name or "Group", "Grupo", "Group")

                local inner = buildComponents(body, {
                    entry = ctx.entry,
                    reveal = function()
                        if not open then setOpen(true) end
                        if ctx.reveal then ctx.reveal() end
                    end
                })
                inner.Instance = holder
                function inner:SetOpen(v) setOpen(v) end
                function inner:IsOpen() return open end
                function inner:SetVisible(v) holder.Visible = v == true end
                function inner:Destroy()
                    unbind(holder)
                    unindex(holder)
                    holder:Destroy()
                end
                return inner
            end

            return Tab
        end

        local Tab = buildComponents(page, {entry = entry})

        function Tab:Select()
            if searching then searchBox.Text = "" end
            selectEntry(entry)
        end

        return Tab
    end

    function Window:SetCategoryOpen(category, open)
        local c = categories[key(category)]
        if not c then return false end
        c.SetOpen(open ~= false)
        return true
    end

    function Window:SelectTab(nameOrIndex)
        for i, p in ipairs(pages) do
            local hit = (type(nameOrIndex) == "number" and nameOrIndex == i)
                or (type(nameOrIndex) ~= "number" and key(p.Name) == key(nameOrIndex))
            if hit then
                if searching then searchBox.Text = "" end
                selectEntry(p)
                return true
            end
        end
        return false
    end

    -- ═══════════ Notificaciones (niveles, cola y apilamiento) ═══════════
    local NOTE_W = 290
    local notifications = make("Frame", {
        Name = "Notifications",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -14, 1, -14),
        Size = UDim2.new(0, NOTE_W, 1, -28),
        BackgroundTransparency = 1,
        ZIndex = 80
    }, gui)

    make("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, notifications)

    local MAX_NOTES = math.clamp(options.MaxNotifications or 4, 1, 8)
    local noteActive, noteCount = 0, 0
    local noteQueue = {}
    local activeDismiss = {}
    local showNext

    local function spawnNote(opt, handle)
        noteActive += 1
        noteCount += 1

        local kind = NOTE_TYPES[opt.Type or "Info"] or NOTE_TYPES.Info
        local color = T[kind.Color]
        local title = tx(opt.Title or "NEXUS UI")
        local body = tx(opt.Content or L("Listo.", "Done."))
        local measured = TextService:GetTextSize(body, 11, Enum.Font.Gotham, Vector2.new(NOTE_W - 28, 1000))
        local height = math.clamp(46 + measured.Y, 64, 160)

        local holder = make("Frame", {
            Name = "NotificationHolder",
            Size = UDim2.new(1, 0, 0, height),
            BackgroundTransparency = 1,
            LayoutOrder = noteCount
        }, notifications)

        local inner = make("CanvasGroup", {
            Name = "Notification",
            Position = UDim2.fromOffset(40, 0),
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = T.Panel,
            BorderSizePixel = 0,
            GroupTransparency = 1
        }, holder)
        round(inner, 11)
        outline(inner, nil, T)

        local bar = make("Frame", {
            Position = UDim2.fromOffset(0, 10),
            Size = UDim2.new(0, 3, 1, -20),
            BackgroundColor3 = color,
            BorderSizePixel = 0
        }, inner)
        round(bar, 3)

        make("TextLabel", {
            Position = UDim2.fromOffset(14, 6),
            Size = UDim2.new(1, -90, 0, 20),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = T.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left
        }, inner)

        make("TextLabel", {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -10, 0, 6),
            Size = UDim2.fromOffset(64, 20),
            BackgroundTransparency = 1,
            Text = tx(kind.Tag),
            TextColor3 = color,
            Font = Enum.Font.GothamBold,
            TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Right
        }, inner)

        make("TextLabel", {
            Position = UDim2.fromOffset(14, 26),
            Size = UDim2.new(1, -28, 1, -36),
            BackgroundTransparency = 1,
            Text = body,
            TextColor3 = T.Muted,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        }, inner)

        local progress = make("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 14, 1, -5),
            Size = UDim2.new(1, -28, 0, 2),
            BackgroundColor3 = color,
            BackgroundTransparency = 0.35,
            BorderSizePixel = 0
        }, inner)
        round(progress, 2)

        local click = make("TextButton", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 5
        }, inner)

        local dismissed = false
        local function dismiss()
            if dismissed then return end
            dismissed = true
            activeDismiss[holder] = nil
            animate(inner, {Position = UDim2.fromOffset(40, 0), GroupTransparency = 1}, 0.2)
            task.delay(0.22, function()
                if holder.Parent then holder:Destroy() end
                noteActive -= 1
                if showNext and gui.Parent then showNext() end
            end)
        end
        activeDismiss[holder] = dismiss
        handle.Close = dismiss

        animate(inner, {Position = UDim2.fromOffset(0, 0), GroupTransparency = 0}, 0.25)
        click.Activated:Connect(dismiss)

        local duration = opt.Duration
        if duration == nil then duration = 4 end
        if duration > 0 then
            if not UI.ReduceMotion then
                TweenService:Create(
                    progress,
                    TweenInfo.new(duration, Enum.EasingStyle.Linear),
                    {Size = UDim2.new(0, 0, 0, 2)}
                ):Play()
            end
            task.delay(duration, dismiss)
        else
            progress.Visible = false
        end
    end

    showNext = function()
        while noteActive < MAX_NOTES and #noteQueue > 0 do
            local item = table.remove(noteQueue, 1)
            if not item.handle.cancelled then
                spawnNote(item.opt, item.handle)
            end
        end
    end

    function Window:Notify(opt)
        opt = opt or {}
        local handle = {cancelled = false}
        function handle.Close()
            handle.cancelled = true
        end
        table.insert(noteQueue, {opt = opt, handle = handle})
        showNext()
        return handle
    end

    function Window:ClearNotifications()
        noteQueue = {}
        local list = {}
        for _, fn in pairs(activeDismiss) do table.insert(list, fn) end
        for _, fn in ipairs(list) do fn() end
    end

    -- ───────────── Métodos generales de la ventana ─────────────
    function Window:SetLanguage(code)
        if code == "ES" or code == "EN" then
            setLanguage(code)
        end
    end

    function Window:GetLanguage()
        return UI.Language
    end

    function Window:SetVisible(visible)
        gui.Enabled = visible == true
    end

    function Window:Minimize()
        if main.Visible then doMinimize() end
    end

    function Window:Restore()
        if mini.Visible then
            openMain()
        elseif maximized then
            setMaximized(false)
        end
    end

    function Window:Maximize(on)
        if main.Visible then setMaximized(on ~= false) end
    end

    function Window:Destroy()
        for i, w in ipairs(UI.Windows) do
            if w == Window then
                table.remove(UI.Windows, i)
                break
            end
        end
        gui:Destroy()
    end

    table.insert(UI.Windows, Window)

    -- ───────────── Sistema de llaves ─────────────
    local function runKeySystem()
        local ks = options.KeySystem
        if type(ks) ~= "table" then return true end

        local function valid(input)
            input = trim(input)
            if input == "" then return false end
            if type(ks.Keys) == "function" then
                local ok, res = pcall(ks.Keys, input)
                return ok and res == true
            end
            for _, k in ipairs(ks.Keys or {}) do
                if input == tostring(k) then return true end
            end
            return false
        end

        local fileName = ks.FileName or "_key"
        local saveKey = ks.SaveKey ~= false

        -- Llave guardada de una sesión anterior
        if saveKey then
            local ok, saved = pcall(store.Load, fileName)
            if ok and saved and valid(saved) then return true end
        end

        local keyGui = make("ScreenGui", {
            Name = guiName .. "Key",
            ResetOnSpawn = false,
            DisplayOrder = (options.DisplayOrder or 999) + 2,
            IgnoreGuiInset = true,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        }, parent)
        pcall(function() keyGui.ScreenInsets = Enum.ScreenInsets.None end)
        gui.Destroying:Connect(function() keyGui:Destroy() end)

        local screen = make("CanvasGroup", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = T.Background,
            BorderSizePixel = 0,
            GroupTransparency = 0,
            ZIndex = 500
        }, keyGui)

        if IMG_BG ~= "" then
            make("ImageLabel", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Image = IMG_BG,
                ScaleType = Enum.ScaleType.Crop
            }, screen)
            make("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = T.Shade,
                BackgroundTransparency = T.ShadeAlpha,
                BorderSizePixel = 0
            }, screen)
        end

        local box = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(330, 210),
            BackgroundColor3 = T.Panel,
            BackgroundTransparency = PA,
            BorderSizePixel = 0,
            Active = true
        }, screen)
        round(box, 14)
        outline(box, T.Accent, T)

        local boxScale = make("UIScale", {Scale = 1}, box)
        do
            local v = keyGui.AbsoluteSize
            boxScale.Scale = math.clamp(math.min((v.Y - 24) / 210, (v.X - 24) / 330), 0.4, 1)
        end

        local titleLabel = make("TextLabel", {
            Position = UDim2.fromOffset(16, 14),
            Size = UDim2.new(1, -32, 0, 24),
            BackgroundTransparency = 1,
            TextColor3 = T.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left
        }, box)
        bind(titleLabel, "Text", function()
            return tx(ks.Title or L("Sistema de llaves", "Key system"))
        end)

        local noteLabel = make("TextLabel", {
            Position = UDim2.fromOffset(16, 42),
            Size = UDim2.new(1, -32, 0, 34),
            BackgroundTransparency = 1,
            TextColor3 = T.Muted,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        }, box)
        bind(noteLabel, "Text", function()
            return tx(ks.Note or L("Introduce tu llave para continuar.",
                                   "Enter your key to continue."))
        end)

        local input = make("TextBox", {
            Position = UDim2.fromOffset(16, 84),
            Size = UDim2.new(1, -32, 0, 34),
            BackgroundColor3 = T.Element,
            Text = "",
            TextColor3 = T.Text,
            PlaceholderColor3 = T.Muted,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            ClearTextOnFocus = false,
            ClipsDescendants = true,
            BorderSizePixel = 0
        }, box)
        round(input, 8)
        outline(input, nil, T)
        bind(input, "PlaceholderText", function()
            return tx(L("Pega tu llave aquí", "Paste your key here"))
        end)

        local invalid = false
        local status = make("TextLabel", {
            Position = UDim2.fromOffset(16, 122),
            Size = UDim2.new(1, -32, 0, 18),
            BackgroundTransparency = 1,
            TextColor3 = T.Error,
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        }, box)
        bind(status, "Text", function()
            return invalid and tx(L("Llave incorrecta.", "Invalid key.")) or ""
        end)

        local passed = nil

        local function keyButton(es, en, x)
            local b = make("TextButton", {
                Position = UDim2.fromOffset(x, 154),
                Size = UDim2.fromOffset(142, 34),
                BackgroundColor3 = T.Element,
                TextColor3 = T.Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                BorderSizePixel = 0,
                AutoButtonColor = false
            }, box)
            round(b, 8)
            bind(b, "Text", function() return tx(L(es, en)) end)
            return b
        end

        local verify = keyButton("Verificar", "Verify", 16)
        local cancel = keyButton("Cancelar", "Cancel", 172)

        local function submit()
            if valid(input.Text) then
                if saveKey then pcall(store.Save, fileName, trim(input.Text)) end
                passed = true
            else
                invalid = true
                status.Text = tx(L("Llave incorrecta.", "Invalid key."))
            end
        end

        verify.Activated:Connect(submit)
        input.FocusLost:Connect(function(enter)
            if enter then submit() end
        end)
        cancel.Activated:Connect(function()
            passed = false
            Window:Destroy()
        end)

        while passed == nil do
            if not gui.Parent then return false end
            task.wait(0.1)
        end

        if passed then
            animate(screen, {GroupTransparency = 1}, 0.3)
            task.wait(0.35)
            keyGui:Destroy()
        end
        return passed
    end

    -- ───────────── Pantalla de carga ─────────────
    local loadedCallbacks = {}

    function Window:OnLoaded(fn)
        if loaded then
            spawnCall(fn)
        else
            table.insert(loadedCallbacks, fn)
        end
    end

    local function finishLoading()
        if options.AutoSave then
            Window:LoadConfig()
        end
        loaded = true
        for _, fn in ipairs(loadedCallbacks) do
            spawnCall(fn)
        end
        loadedCallbacks = {}
    end

    if options.Loading == false then
        task.defer(function()
            if not gui.Parent then return end
            if not runKeySystem() then return end
            openMain()
            finishLoading()
        end)
        return Window
    end

    task.spawn(function()
        if not runKeySystem() then return end
        if not gui.Parent then return end

        local loadGui = make("ScreenGui", {
            Name = guiName .. "Loading",
            ResetOnSpawn = false,
            DisplayOrder = (options.DisplayOrder or 999) + 1,
            IgnoreGuiInset = true,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        }, parent)
        pcall(function() loadGui.ScreenInsets = Enum.ScreenInsets.None end)
        gui.Destroying:Connect(function() loadGui:Destroy() end)

        -- Fondo negro puro: la única imagen es la del centro
        local screen = make("CanvasGroup", {
            Name = "Loading",
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            GroupTransparency = 0,
            ZIndex = 500
        }, loadGui)

        -- Contenedor que se reduce en pantallas pequeñas
        local box = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(340, 250),
            BackgroundTransparency = 1
        }, screen)
        local boxScale = make("UIScale", {Scale = 1}, box)
        do
            local v = loadGui.AbsoluteSize
            boxScale.Scale = math.clamp(math.min((v.Y - 24) / 250, (v.X - 24) / 340), 0.4, 1)
        end

        if IMG_LOGO ~= "" then
            local logo = make("ImageLabel", {
                Position = UDim2.fromOffset(10, 0),
                Size = UDim2.fromOffset(320, 180),
                BackgroundColor3 = T.Panel,
                Image = IMG_LOGO,
                ScaleType = Enum.ScaleType.Crop
            }, box)
            round(logo, 14)
            outline(logo, T.Accent, T)
        else
            make("TextLabel", {
                Position = UDim2.fromOffset(10, 50),
                Size = UDim2.fromOffset(320, 70),
                BackgroundTransparency = 1,
                Text = options.Title or "NEXUS UI",
                TextColor3 = Color3.fromRGB(240, 240, 250),
                Font = Enum.Font.GothamBlack,
                TextSize = 34
            }, box)
        end

        local status = make("TextLabel", {
            Position = UDim2.fromOffset(10, 196),
            Size = UDim2.fromOffset(240, 20),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(170, 172, 190),
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        }, box)

        local pct = make("TextLabel", {
            Position = UDim2.fromOffset(250, 196),
            Size = UDim2.fromOffset(80, 20),
            BackgroundTransparency = 1,
            Text = "0%",
            TextColor3 = Color3.fromRGB(240, 240, 250),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right
        }, box)

        local barBg = make("Frame", {
            Position = UDim2.fromOffset(10, 224),
            Size = UDim2.fromOffset(320, 6),
            BackgroundColor3 = Color3.fromRGB(42, 42, 64),
            BorderSizePixel = 0
        }, box)
        round(barBg, 6)

        local fill = gradientFrame({Size = UDim2.fromScale(0, 1)}, barBg, 0)
        round(fill, 6)

        local stages = {
            {0.20, L("Iniciando interfaz...", "Starting interface...")},
            {0.50, L("Cargando componentes...", "Loading components...")},
            {0.80, L("Aplicando tema...", "Applying theme...")},
            {1.00, L("¡Listo!", "Ready!")}
        }
        local current = 1
        bind(status, "Text", function() return tx(stages[current][2]) end)

        local per = (options.LoadingTime or 2.4) / #stages
        for i, st in ipairs(stages) do
            if not gui.Parent then return end
            current = i
            status.Text = tx(st[2])
            pct.Text = math.floor(st[1] * 100) .. "%"
            animate(fill, {Size = UDim2.fromScale(st[1], 1)}, per * 0.9)
            task.wait(per)
        end

        task.wait(0.15)
        if not gui.Parent then return end
        animate(screen, {GroupTransparency = 1}, 0.4)
        openMain()
        task.wait(0.45)
        loadGui:Destroy()

        finishLoading()
    end)

    return Window
end

pcall(function()
    if getgenv then getgenv().NexusUI = UI end
end)

return UI

end)()

-- ═════════ TU INTERFAZ (edita desde aquí) ═════════

local Window = UI:CreateWindow({
    Title = "NEXUS HUB",
    Language = "ES",
    Theme = "Black",                      -- Black | Midnight | Light | HighContrast
    ToggleKey = Enum.KeyCode.RightShift,  -- mostrar/ocultar todo
    ConfigName = "demo",
    AutoSave = true,                      -- guarda y restaura Flags solo
    MaxNotifications = 4

    -- Sistema de llaves (quita los "--" para activarlo):
    -- , KeySystem = {
    --     Keys = {"MI-LLAVE-123"},       -- o function(texto) return texto == "x" end
    --     Title = UI.T("Acceso", "Access"),
    --     Note = UI.T("Pide tu llave al creador.", "Ask the creator for your key."),
    -- }
})

-- ───────── Inicio ─────────
local Home = Window:CreateTab({Name = UI.T("Inicio", "Home"), Category = UI.T("Principal", "Main")})

Home:CreateSection(UI.T("General", "General"))

Home:CreateParagraph({
    Title = UI.T("Bienvenido a Nexus UI 6", "Welcome to Nexus UI 6"),
    Content = UI.T("Usa la búsqueda de la izquierda para encontrar cualquier control.",
                   "Use the search box on the left to find any control.")
})

Home:CreateButton({
    Name = UI.T("Notificación de información", "Info notification"),
    Callback = function()
        Window:Notify({Type = "Info", Title = "NEXUS UI",
            Content = UI.T("Esto es una notificación informativa.", "This is an info notification.")})
    end
})

Home:CreateButton({
    Name = UI.T("Notificaciones de todos los niveles", "Notifications of every level"),
    Callback = function()
        for _, level in ipairs({"Info", "Success", "Warning", "Error"}) do
            Window:Notify({
                Type = level,
                Title = level,
                Content = UI.T("Nivel: ", "Level: ") .. level,
                Duration = 5
            })
        end
    end
})

Home:CreateToggle({
    Name = UI.T("Interruptor", "Toggle"),
    CurrentValue = false,
    Flag = "demo_toggle",
    Callback = function(value) print("Toggle:", value) end
})

Home:CreateSlider({
    Name = UI.T("Velocidad", "Speed"),
    Range = {0, 100}, Increment = 5, Suffix = "%", CurrentValue = 50,
    Flag = "demo_speed",
    Callback = function(value) print("Slider:", value) end
})

-- Barra de progreso con actualización real
local progress = Home:CreateProgressBar({Name = UI.T("Progreso", "Progress"), CurrentValue = 0})
Home:CreateButton({
    Name = UI.T("Simular carga", "Simulate loading"),
    Callback = function()
        for i = 0, 10 do
            progress:Set(i / 10)
            task.wait(0.15)
        end
        Window:Notify({Type = "Success", Content = UI.T("Carga completada.", "Loading complete.")})
    end
})

-- ───────── Controles ─────────
local Controls = Window:CreateTab({Name = UI.T("Controles", "Controls"), Category = UI.T("Principal", "Main")})

Controls:CreateDropdown({
    Name = UI.T("Lista", "Dropdown"),
    Options = {UI.T("Negro", "Black"), UI.T("Grafito", "Graphite"), UI.T("Plata", "Silver")},
    CurrentOption = "Black",
    Flag = "demo_dropdown",
    Callback = function(value, index) print("Dropdown:", value, index) end   -- value llega en inglés
})

Controls:CreateMultiDropdown({
    Name = UI.T("Selección múltiple", "Multi-select"),
    Options = {UI.T("Uno", "One"), UI.T("Dos", "Two"), UI.T("Tres", "Three")},
    CurrentOptions = {"One"},
    Flag = "demo_multi",
    Callback = function(list) print("Multi:", table.concat(list, ", ")) end
})

Controls:CreateInput({
    Name = UI.T("Nombre", "Name"),
    Placeholder = UI.T("Escribe aquí", "Type here"),
    Flag = "demo_name",
    Callback = function(text) print("Input:", text) end
})

Controls:CreateInput({
    Name = UI.T("Número", "Number"),
    Numeric = true, CurrentValue = 10,
    Flag = "demo_number",
    Callback = function(n) print("Número:", n) end
})

Controls:CreateKeybind({
    Name = UI.T("Atajo", "Shortcut"),
    CurrentKeybind = Enum.KeyCode.F,
    Flag = "demo_key",
    Callback = function() print("Atajo pulsado") end
})

Controls:CreateColorPicker({
    Name = UI.T("Color", "Color"),
    CurrentValue = Color3.fromRGB(124, 108, 255),
    Flag = "demo_color",
    Callback = function(color) print("Color:", color) end
})

-- Grupo plegable: contiene los mismos componentes
local Group = Controls:CreateGroup({Name = UI.T("Opciones avanzadas", "Advanced options"), Open = false})
Group:CreateToggle({Name = UI.T("Modo avanzado", "Advanced mode"), Flag = "demo_adv"})
Group:CreateSlider({Name = UI.T("Intensidad", "Intensity"), Range = {1, 10}, CurrentValue = 5, Flag = "demo_intensity"})

-- ───────── Ajustes ─────────
local Settings = Window:CreateTab({Name = UI.T("Interfaz", "Interface"), Category = UI.T("Sistema", "System")})

Settings:CreateSection(UI.T("Apariencia", "Appearance"))

Settings:CreateDropdown({
    Name = UI.T("Tema", "Theme"),
    Options = {"Black", "Midnight", "Light", "HighContrast"},
    CurrentOption = "Black",
    Callback = function(theme) Window:SetTheme(theme) end   -- cambio en caliente
})

Settings:CreateColorPicker({
    Name = UI.T("Color de acento", "Accent color"),
    CurrentValue = Color3.fromRGB(124, 108, 255),
    Callback = function(color) Window:SetAccent(color) end
})

Settings:CreateSlider({
    Name = UI.T("Escala de la interfaz", "Interface scale"),
    Range = {0.7, 1.3}, Increment = 0.1, CurrentValue = 1,
    Callback = function(value) Window:SetUIScale(value) end
})

Settings:CreateToggle({
    Name = UI.T("Reducir animaciones", "Reduce motion"),
    CurrentValue = false,
    Callback = function(value) Window:SetReduceMotion(value) end
})

Settings:CreateSection(UI.T("Configuración", "Configuration"))

Settings:CreateLabel(UI.T(
    Window:CanPersist() and "Se guarda en archivos del ejecutor."
        or "Sin archivos: solo se guarda durante esta sesión.",
    Window:CanPersist() and "Saved to executor files."
        or "No file access: saved for this session only."))

Settings:CreateButton({
    Name = UI.T("Guardar configuración", "Save config"),
    Callback = function()
        local ok = Window:SaveConfig()
        Window:Notify({
            Type = ok and "Success" or "Error",
            Content = ok and UI.T("Configuración guardada.", "Config saved.")
                or UI.T("No se pudo guardar.", "Could not save.")
        })
    end
})

Settings:CreateButton({
    Name = UI.T("Cargar configuración", "Load config"),
    Callback = function()
        local ok = Window:LoadConfig()
        Window:Notify({
            Type = ok and "Success" or "Warning",
            Content = ok and UI.T("Configuración cargada.", "Config loaded.")
                or UI.T("No hay configuración guardada.", "No saved config.")
        })
    end
})

Window:OnLoaded(function()
    Window:Notify({
        Type = "Success",
        Title = "NEXUS UI v" .. UI.Version,
        Content = UI.T("Interfaz lista.", "Interface ready.")
    })
end)
