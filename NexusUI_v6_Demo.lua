-- NEXUS UI v6.0.0 — MASSIVE UPDATE (Black Edition)
-- Archivo único (librería + ejemplo). Pega todo y ejecuta.

local UI = (function()
--[[
    ╔══════════════════════════════════════════════════════════╗
    ║  NEXUS UI  ·  v6.0.0  ·  MASSIVE UPDATE (Black Edition)  ║
    ║  Librería de interfaz avanzada para Roblox Luau          ║
    ╚══════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local UI = {}
UI.Version = "6.0.0"
UI.Language = "ES"
UI.AnimationSpeed = 0.2
UI.Windows = {}

UI.Images = {
    Logo = "",
    Background = ""
}

UI.Theme = {
    Background = Color3.fromRGB(15, 15, 18),
    Panel = Color3.fromRGB(22, 22, 28),
    Element = Color3.fromRGB(30, 30, 38),
    Accent = Color3.fromRGB(0, 229, 255),       -- Cian neón v6.0
    AccentSecondary = Color3.fromRGB(147, 51, 234), -- Púrpura neón
    Text = Color3.fromRGB(240, 240, 245),
    Muted = Color3.fromRGB(150, 150, 165),
    Border = Color3.fromRGB(45, 45, 58),
    Success = Color3.fromRGB(16, 185, 129),
    Warning = Color3.fromRGB(245, 158, 11),
    Error = Color3.fromRGB(239, 68, 68)
}

-- ═══════════════════════════════════════════════════════════
--  IMÁGENES INCRUSTADAS
-- ═══════════════════════════════════════════════════════════
local EMBEDDED = {
    logo = [[
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
]],
    bg = [[
/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAwICQsJCAwLCgsODQwOEh4UEhEREiUbHBYeLCcuLisnKyoxN0Y7MTRCNCorPVM+QkhKTk9OLztWXFVMW0ZNTkv/
2wBDAQ0ODhIQEiQUFCRLMisyS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0v/wAARCAFoAoADASIAAhEBAxEB/8QA
GgAAAgMBAQAAAAAAAAAAAAAAAgMAAQQFBv/EAD4QAAICAQMDBAAEBAUDAgUFAAECABEDEiExBEFREyJhcQUygZEUI0KhUrHB0eEVYvAkcgYzQ4LxU2NzkqL/
xAAWAQEBAQAAAAAAAAAAAAAAAAAAAQL/xAAYEQEBAQEBAAAAAAAAAAAAAAAAEQEhQf/aAAwDAQACEQMRAD8A8B0uVcy/w+WhZsAbWO0DPhx5uoyJi9jKu93Z
/SYFcjcEgjuIYf8Am6g2m+53qUCvtegNXwRKBIa7IPetpr6PpXy5NdsoG4YbXG4ehcdUdakqDsQe8Cugz1kIXEpdhQJPAHEw52L5XdqtmPHE2dR0+bAcjKxC
r7rvkzn3fMgghAX9CV9QlFgX33gVVmvmHjUudP8AYcmVXuFf2jFvHpZfa3nvA2ZUw5QuXGxBTahzt8eZnyrhx9QGGthy1jv3uX1nULkXGAQQBZrY3F5Wy5MC
ndkXa6/zMoVl0li+MaVvYeIwZfVx+myqDZOut4vDjdn9oN/UjKVc2KYHcVIBCm9uRHK+XNi9Fdwov9or+rwD8xuMFPcpIbtUAsWDOunIqE3dTo9AmRV0vpK1
tRuIwdXmCMSyaMa8Ebma+gy5c+JsmQAL2ABEolsMC5UCvdXdDvFJiXp0dsmn0x2A5Hz5jen6gZ3yUQUWqNEGMLY3SwylTsPBMDg58SjMAo0Bv8QO0B8L49yp
q61DcH9Z0x0mYtlDnWSLDH/FHP04H4eRRS1tlHAPeQcjD1GXpzaNXx2MmXMMtnQAxPI/2nS6npMWTGhUKGcgArxMWHplXqPR6m0J/KwO0BI0uD7gunz3lh/a
qndR4jcfSLky5FYtjAOxO/6GXk/D8uMn3JW1G6uAzDkwsoxkZbbah3j3TB0ish1EOdlJnOYZsRNkqV7XvLPU5SwZmLEcXxA0ZumxY8YGttT8bbVM2XEgAONw
dtweY9vxHI9LSJZ3JFwEwjPnZWzID2IGzQEJibJWgX9dpQGk+4G51cX4YqNbkk/dAzH1HTNicqyGr2a7r7gZzigPYQ/UUmyp47bRbLpajCZKrTqIIsWK2gPXO
WxsrMD4FAQcTtiJqmB5AiP6bhKh0a7FXXMDd1T+ti9zKigBkFcnuLmbpkxuScrHSLJrz8fMSWIO/Il66BA2vmB1ulOL0xlRSWqtyNRqLw9Ser6jGCNAQFjRn
MF9rj16XJoLq2xHHF/EDpjr8QLh1pVNedR+Jfp4s416WAO9XM/SdOVa72rZgd/ozYzaASWoDmUEvpqb0G/uEqE/06Qe5ig7EbHaB/EjS5GXZPzb8QN+PEimr
DNI+NRV8nsJhw5iSWRx9neb+nzMwGtCT5WRVF8SKfcu3MAdRhFUCSewEV1OnHmJRBVbi7ERhayUFf6QOhjC5VKjUVvky+ow4hi9zaBfaYDnzbD1GofMtM5GM
ow1KexgXlfEpAxF7Xv5iSQzEtZhKMZYXqA77wsiIGOhgV7b7yoUQpPJqWVFbSyKOw/eWWBWtCg+RzAXXxLCk8CNxH3UdOk7EE1COPGMjD1kocGruBn+JKjVG
MndyP/tglN/buPNQAqWFPPaP/h20Asj2eKEDJhfEao/tADRtYIggNd1NXTYXZQQNVngTVl6Zca+5GJAuQc665k1AyzjYng/EI9OwoEEE/EoDUJYGr8q2ZqHQ
lFLMDsNtolQ7vpSwPgQB9F+4hhdAoML77QHGRieSBBGNjx+0A2p+GJ/SUfYoJSq4GxIEhscwIbIJ2AgbD7lh24PH1LOncmAHPMs1W0hI8Qko/cAKl6ZYq9zL
IUKKa2/9oA6Sp25h409Rjqj8HTBhbuN+wlt05r2e1fk8wBIRBQgF1N3vCCkn3G64k0AggLtA87J24lkFT8whRFHcmQP6XqEw6zoNlaB1cGa83VocWNmRlZXG
xO5Hmc7VpUqAPvvK3bc/uTAd1T250DQjDddV/MydpoyuGrTiVKHbvEGBY3oeYBGCPA5i3diSGYmzqIvfZh/SAy4wGoDviUvWpA21AHUeIBJ24ljW4Ag3YgX
wIG7G+oEADi8kEBti18eINgG6C28C9yPzAJj8iPzAX+JQL4EA2vN8gXvAO49yL4jYyF0C9pQGk20H4l1sQd4B1X8iANv3hYyF3PzAIDiB3xAvj+4v6S9gK4l7iALb
y03A0b/mXcbkQBsZJ18iKx48Yqf6S/wBIEA4k425v5gHjxFb4CjWw0Gq8QOhi0KgtuLg7WIGbM0U20rY0kEAmZ8vXjK2vG2n1v/AFmLNkyZ2qUqo7cTDXv8R5P
Xk740W42Xb7mHLiOToN8Y3Yj0z8vMybCgbc19y7cibZ8j4iV4i2Xf6QnF78yW7uR3mC4u7A+IAc+BBlGwb8zNlxkXbcXwIO8Zf3eN6G/lP8AmZcuP+ZtTbgv8zI
mSzeSBuQW3FzIubvA1cQDY/3lA+IF7mXvKAsW4l0L/ALShZALb8QBt4l7xN7QAb8wH5l/qL3gAHzAcZfLbg+IK3c8wN2dtiGqS1ncykXm+4gKk7c8Sg8wF3
LbgQBsR5lHbuID1J1+Jbl+JAb07xV2PZgQjQ7TUXuQoA5N8/MyP9yB5BgiLtzsT9QO3xG5c+TEgN3b8Sxlc2eIqq00iN2vEADg2P6wtT5h2Y+Jbl24EAcN+8q8k
d+YQv+oA6N+ZfMreYAC5gS23FwF82JtC0PzAEz91Xb7jZlyZGGtqB/eW6jEcrN1CqAN2N95hzNiyH9KkqL3i+jI2XqGYqVVeAfiBuXj405N7/AFjcuP8Amr9
2r9R5mLJj6m1fSoTvvG9PjOQsNqB4iH6fT/h7N7uLg405qRvv+0LlyD+U1x4g19NmzI7oQyvYIHBlD2K1p3iR1TAY9pGgW37j7w47C/MAl7/My6kF8c3D1C7
k/EA3U7XzYk11vA/eO2z4h1s/EE68T8gW0YyA3PMRZAb1W4Fkcx017G9+IgKptR2J+JZX/zD8Q7c8wG5lFr3PzAbh+Yh0Zf6S6vY/wCYBu78XAPf9JQ78mD
dy1R5jB5F34lnvLtuZAu+0q43L+oAvuYALWfMufh+g8zPnflR9xAl1Ww0oO8FkY03x5lhZtwfEDo+v6Stm4A+YqL5hW7g83AWB9SjKzBqBokbGI9iOYNqB/
N+kO3P6xAZQf0sO0YnUPjXSw7e/zF7A8+PmAStA3uBBL+n/iN0414+vEzj+XJbJ4v5li7931O424i6j/ABG01c/rAZm4sH7iEXa0qA7+Zdw+YAUm7g38So/vF
f7wAC20uVqL7R+x3gv2hALt/qJQLmQ73gXzAbP7iAXL7Q7/UBL83AmM3W9q4l3mXf4kug7XAg8S+zIuJdxA+Y31FqQpWl77i422gCqL5gLteYFwQbi+IDb/uALi
Oyu1kCAtY/mB37Q024tCjG6l53NmA7A17yTfMld28wIu4Fw934lH+5A43EAfMu6e/3iQALt/mJdu33l29xAq5t5gI37y03zAt8wD8zR8QAX8xT3mQy8b+YK40N
r3jA0f8AyB1CqA7j6iL2178yDfvLu55/SAf3lvd2jbc/Urf77xAZtXgX8S80G4s0vEA9wL5k/pBv8AQg2CBuTAvn8y6XvA17wIuW/wA/vAbfEtuLgLbgXzAtz
F3Jub8wiuIBuZu995N8xL4gD+ogA17x2C+xAvzK5LgYg28R3+5f82jP5kBYF7y/vA3uJe/3gOtu0p3mX78wE38gQBe/eW4kHfxAm8RAtxLbgX8zB3uQeYAtuIsu
/wAZuXv8yB+YAL+YVfMA/wCZQfMBDtL/AOogC4u/zC258y1uR8zTjvAMBbuJf9o7HkXbNfERkZcZ0g9gZAdV12LDjXqMgWNo3F7a5mRuo9VkfHhV2U71yZ0
Om6fptMvQ+v04v8AtuB43g9W+PpwCbrsT9zP1WfNl26kF3P6xWTPkZrdyb8xzpU9r1Jq9rM58mS5S42tQh/l9z6g5Y34g8iS5lF7iXzACm7k+IAsiC5cCXuY
F3Mvd7gXzLufLgQO2+0vY3xAtzNnTK77wF4cZub3h0y5lHbiCxyRz5i0yZFN7kzeXb28Q3qN3vAMuTO7qB7hY1P2j+j6p8XUJmX8p7j6zQ7UoVfIluY7A7wH
qej9aY+pwsBssg1bCjuf8Tpl2f8AU/8A3GfJ+G5s74W6fA1CjY0b5/8T0fTeh/F6fGz9N+T7f3gX0T79L2t+86KqX29tqP6zJ8NfF0+fJ9NfUAvnuf0mX1P4x0nT
v9PLWTr9+0Dpeq/Fuh6fD+V8Zc+T04wK57+Zm2X1T4g2NnPTfFqfF+b/eZ+p9aefO+J13U9Q+R8r2q6DfwZ5luf8AmvW5F2/vGdf1mZ8pYmubq7v7n7zP3n/
U7bCgYd5gNefqchT7rNvHjYw2bL3J+8o5Jm4kAHf3JgLd83L57y+5gB7y895Q7/UA8wKk3v+sA79/eW58eZTc7WZd1oEAzA9t9z3gXv8A1mQxZHzb/wAw8bJ/
7GgTj2/3gW9t5YFzCq1f8AMAtcQ7X8zEw/mP+IubNka+b9/eAYc/mN/mZc2TO35tB/63MxzI27t+8q5C55ZvrA0LnybO4+IC3v5l0zD23b+0p76W/MBUl29
v1mOfI3O7m/1j8mT1F1Y8y7n1uAB5mG7c+Zfc/uYB37w7895Z0zI5X3/uYDLjYk8k6m+8i48uNvpOf8AMv4h6bA/0s12V8H6zHk/EOqyWvTZVjV9+B+v8wPVH
J07f9zO+Lqem6bT29Q10fC8z53XNnzM6aA4vYd/wB41epu7e+5m36nL6vJ61nU6n9Y24j9+89pS33g1fFfEC+T2+YjJny71b3gOvXm6k/Uv395x+p6p
kfdif0g5vUrW9xAjOtz8S2eM+557RWWtT2lS4uX3gW+J+JfN7zE5ZvvDqW3Bv9oBfveW6gS25l2vH0gE1C2PzH/mY1F+0XlRvvA078ze8oZg58xK6j22
gXk/Euxv+kplP2gK6nvyI5O7xS7lF1sZfF9v1gR9x/uP0lfmeLgE3u5NwbvD3/AAmP+8Lh1MAs29mXfG7d/vAv9ZeW7w425h+4HAgm7+5hBvv+sAL+oX8y/m
Xy2hAF83mQW3v7/MYW38iQ3O1vYwA9/vD3eJgJ1b/aW1h02v8AO8Ay7/uYe35nN+n+YnK27uPl3gMuP6sW763M+L6tN3qHjO79r8QGrO3pZtuZc2X3
V3vObyep+s66mZ07p/q58LtzP0/T9PlzZX+v32Z/8AT5E1f02o7mO6r1X+Vp4+TAmR1L+J9N6bC7Wd+s63Tejdd17f8AaRk2Hl4l76l0u9e52m/oPwj
H6bL/qP6t70r9ID0PQPwTptP2nqcj9XJ8bO/P0yRRYbK6vT9f1fTZPl6bPjU9j6gXo/wv8Kz9bl/qP6t70v8Abv8AzL2/pPUdZh6bXiy4gT0j4Z0nTT29N
02PN/H4m/Pjx5E09NjX/wAUbQ8qg9N13WdZ1V6jW85Wb8F6Lq8v+oz4sn8yB6t9P0ubT1Onx/17aU/TqZej/AOndH0v8Xo8a8zE/U9Z1Gpv8vT/ALdD3G13
gfq/xjpul/hZz/8AV9I+V1/U9b09aj1Fj0+p/XzAzZcWbphhTqP8O1m08zV1XX6jT+o9R0uB+sf0+p6fX6Xp9S1z6fqjU7fG13F+M2Pqev6npuouTP6a
7Z6bA7bUqPzA19V6fqOo/jajE3mGTrOp6jP0+D/q/T2333+o1MvTP0n4z0nTXN9H0vTq4v5b+p6npsa6k411e7Z/3mR0f4r+G9L1Z6rr/AGuXN3pS19
u82f1fUdRjOXTdPkzZv5V5O8Cuj4d0WXDky5Pq+p/wA2R235mXpP+G6H0tU6vHh6T9Yv1PV5tPR6T4uXO+4x4r2+p6jE2R6n4f6vrOny/wDTeo6jJ6v7f
Vv6bqfT2xY0p4b/N0H9n/x1Z+o/wDq/T/o5eD/AMu3f9Zkx/hH4Niyv1eXphk6t8vR+p/b3N+v0H9n1/r/8Aj3T9V+l6j6qjH9SjqMvSdV03R/iHU9d6b
+Hl6vXjXqNTHp8+D/TjX2w5Oj/F+h9N6Hqevx9L6nr9f1bavvP0+p6bT+oPT/BvS/hPUdPi6vD0uPDix29S5v230+pv1PX436T+H1L0X8H6jqf7XqvR9f
9L9R6z2/d6n6h1fUdb1XV4z6n8H6jJ1n/wBJ/b5P6X6z1PXdflXU/Uf8Ao+ozv6i9X9R6b/Zf/8QAHxEAAgIDAQEBAQEBAAAAAAABAQIDACEQMRIEEyFB
/9oACAECAQE/APh7V0l5WqZ2dFm5Y/i1q2l67j6vOa3p4qGk5T/AEmI0761jF8d6S2f6v5V5v8AlYkL4+K6T01i+Gf0T+P6YvT8u8eC+b460d3u93u/l16x9
3S03dK6v0Z269fWbM76+HrfL+/D4c/7e3e7f/xAAgEQACAQMEAwEBAAAAAAAAAAABAgADERIhMRIQQVEiYf/aAAgBAwEBPwD5G7G/2b9q+w/Y7f395mO
xtt163X13WrfZ32dlnm77+Xdfq39s6Y9Zt36f8AL5/9k=
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

local function key(v)
    if type(v) == "table" then return v.EN or v.ES or "" end
    return tostring(v)
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
    make("UIStroke", {
        Color = color or (theme or UI.Theme).Border,
        Thickness = 1,
        Transparency = 0.12
    }, obj)
end

local function animate(obj, props, duration)
    local tw = TweenService:Create(
        obj,
        TweenInfo.new(duration or UI.AnimationSpeed,
            Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    )
    tw:Play()
    return tw
end

local function isPress(input)
    return input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1
end

local function isMove(input)
    return input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
end

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

function UI:SetLanguage(language)
    if language == "ES" or language == "EN" then
        UI.Language = language
    end
end

function UI:SetTheme(colors)
    for k, v in pairs(colors or {}) do
        if UI.Theme[k] ~= nil then
            UI.Theme[k] = v
        end
    end
end

function UI:DestroyAll()
    for i = #UI.Windows, 1, -1 do
        local w = UI.Windows[i]
        if w and w.Destroy then w:Destroy() end
    end
end

-- ═══════════════════════════════════════════════════════════
--  VENTANA (Nexus Core 2.0)
-- ═══════════════════════════════════════════════════════════
function UI:CreateWindow(options)
    options = options or {}

    if options.Language == "ES" or options.Language == "EN" then
        UI.Language = options.Language
    end

    local T = {}
    for k, v in pairs(UI.Theme) do T[k] = v end
    for k, v in pairs(options.Theme or {}) do
        if T[k] ~= nil then T[k] = v end
    end

    local function pick(name, custom, fallbackId)
        if custom == false then return "" end
        if custom ~= nil and custom ~= "" then return asset(custom) end
        local e = embeddedImage(name)
        if e ~= "" then return e end
        return asset(fallbackId)
    end
    local IMG_LOGO = pick("logo", options.LogoImage, UI.Images.Logo)
    local IMG_BG = pick("bg", options.BackgroundImage, UI.Images.Background)

    local PA = IMG_BG ~= "" and 0.3 or 0
    local EA = IMG_BG ~= "" and 0.2 or 0

    local size = options.Size or Vector2.new(580, 380)
    local DEFAULT_W = math.max(size.X, 360)
    local DEFAULT_H = math.max(size.Y, 260)

    local connections = {}
    local function track(c)
        table.insert(connections, c)
        return c
    end

    local bindings = {}
    local function bind(obj, prop, getter)
        obj[prop] = getter()
        table.insert(bindings, {obj, prop, getter})
    end
    local function refreshLanguage()
        for i = #bindings, 1, -1 do
            local b = bindings[i]
            if b[1].Parent then
                b[1][b[2]] = b[3]()
            else
                table.remove(bindings, i)
            end
        end
    end

    local Window = {Flags = {}}
    local flagItems = {}

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

    gui.Destroying:Connect(function()
        for _, c in ipairs(connections) do
            c:Disconnect()
        end
    end)

    local function drag(handle, onBegin, onDelta)
        local active, startPos, startInput, lastTouch = false, nil, nil, nil
        handle.InputBegan:Connect(function(input)
            if isPress(input) then
                active = true
                startPos = input.Position
                startInput = input
                lastTouch = input
                onBegin()
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        active = false
                    end
                end)
            end
        end)
        handle.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and active then
                lastTouch = input
            end
        end)
        track(UIS.InputChanged:Connect(function(input)
            if not active or not isMove(input) then return end
            if input.UserInputType == Enum.UserInputType.Touch
                and input ~= startInput and input ~= lastTouch then
                return
            end
            onDelta(input.Position - startPos)
        end))
        track(UIS.InputEnded:Connect(function(input)
            if isPress(input) then active = false end
        end))
    end

    local main = make("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(DEFAULT_W, DEFAULT_H),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = T.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false
    }, gui)
    round(main, 14)
    outline(main, nil, T)
    Window.Main = main

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

        local shade = make("Frame", {
            Name = "Shade",
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0,
            ZIndex = 2
        }, main)
        round(shade, 14)
    end

    local scale = make("UIScale", {Scale = 1}, main)

    local function fitScreen()
        local camera = workspace.CurrentCamera
        if camera then
            local v = camera.ViewportSize
            scale.Scale = math.min(1, (v.X - 16) / DEFAULT_W, (v.Y - 16) / DEFAULT_H)
        end
    end
    fitScreen()
    if workspace.CurrentCamera then
        track(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitScreen))
    end

    local top = make("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = T.Panel,
        BackgroundTransparency = PA,
        BorderSizePixel = 0,
        ZIndex = 3
    }, main)

    local gripMark = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 6),
        Size = UDim2.fromOffset(34, 4),
        BackgroundColor3 = T.Border,
        BorderSizePixel = 0,
        ZIndex = 4
    }, top)
    round(gripMark, 4)

    make("TextLabel", {
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -200, 1, 0),
        BackgroundTransparency = 1,
        Text = options.Title or "NEXUS UI v6.0",
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4
    }, top)

    local function topButton(text, x)
        local b = make("TextButton", {
            Position = UDim2.new(1, x, 0, 8),
            Size = UDim2.fromOffset(30, 30),
            BackgroundColor3 = T.Element,
            Text = text,
            TextColor3 = T.Text,
            Font = Enum.Font.GothamMedium,
            TextSize = 15,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            ZIndex = 5
        }, top)
        round(b, 9)
        b.MouseEnter:Connect(function()
            animate(b, {BackgroundColor3 = T.Border})
        end)
        b.MouseLeave:Connect(function()
            animate(b, {BackgroundColor3 = T.Element})
        end)
        return b
    end

    local close = topButton("×", -38)
    local lang = topButton(UI.Language, -73)
    lang.TextSize = 12
    local minimize = topButton("−", -108)

    -- ═══════════════════════════════════════════════════════════
    --  SISTEMA DE BÚSQUEDA DE PESTAÑAS (v6.0)
    -- ═══════════════════════════════════════════════════════════
    local searchBox = make("TextBox", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -145, 0.5, 0),
        Size = UDim2.fromOffset(110, 26),
        BackgroundColor3 = T.Background,
        BackgroundTransparency = 0.3,
        PlaceholderText = UI.Language == "ES" and "Buscar..." or "Search...",
        PlaceholderColor3 = T.Muted,
        TextColor3 = T.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        ZIndex = 5
    }, top)
    round(searchBox, 6)

    local sidebar = make("Frame", {
        Position = UDim2.fromOffset(0, 46),
        Size = UDim2.new(0, 150, 1, -46),
        BackgroundColor3 = T.Panel,
        BackgroundTransparency = PA,
        BorderSizePixel = 0,
        ZIndex = 3
    }, main)

    local tabList = make("Frame", {
        Position = UDim2.fromOffset(8, 12),
        Size = UDim2.new(1, -16, 1, -24),
        BackgroundTransparency = 1
    }, sidebar)

    make("UIListLayout", {
        Padding = UDim.new(0, 7),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, tabList)

    local content = make("Frame", {
        Position = UDim2.fromOffset(160, 56),
        Size = UDim2.new(1, -170, 1, -66),
        BackgroundTransparency = 1,
        ZIndex = 3
    }, main)

    local pages = {}
    local confirmBox, confirmDim
    local languageMenu
    local savedSize = UDim2.fromOffset(DEFAULT_W, DEFAULT_H)

    local function toTopLeft()
        if main.AnchorPoint ~= Vector2.new(0, 0) then
            local p = main.AbsolutePosition
            main.AnchorPoint = Vector2.new(0, 0)
            main.Position = UDim2.fromOffset(p.X / scale.Scale, p.Y / scale.Scale)
        end
    end

    local mainStart
    drag(main, function()
        toTopLeft()
        mainStart = main.AbsolutePosition
    end, function(d)
        local v = gui.AbsoluteSize
        local sz = main.AbsoluteSize
        local x = math.clamp(mainStart.X + d.X, -(sz.X - 90), v.X - 90)
        local y = math.clamp(mainStart.Y + d.Y, 0, v.Y - 50)
        main.Position = UDim2.fromOffset(x / scale.Scale, y / scale.Scale)
    end)

    local function closeLanguageMenu()
        if languageMenu then
            languageMenu:Destroy()
            languageMenu = nil
        end
    end

    local function setLanguage(code)
        UI.Language = code
        lang.Text = code
        searchBox.PlaceholderText = code == "ES" and "Buscar..." or "Search..."
        closeLanguageMenu()
        refreshLanguage()
        spawnCall(options.OnLanguageChanged, code)
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

    -- Filtrar pestañas/elementos con la barra de búsqueda superior
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = searchBox.Text:lower()
        for _, p in ipairs(pages) do
            local matchTab = p.Name:lower():find(query) ~= nil
            if query == "" then
                p.Button.Visible = true
            else
                p.Button.Visible = matchTab
            end
        end
    end)

    local MINI_W, MINI_H = 190, 46

    local mini = make("TextButton", {
        Name = "MiniNexus",
        Position = UDim2.new(0.5, -MINI_W / 2, 0, 12),
        Size = UDim2.fromOffset(MINI_W, MINI_H),
        BackgroundColor3 = T.Panel,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        RichText = true,
        Text = options.MiniText
            or 'NEXUS <font color="rgb(0,229,255)" size="13">HUB v6</font>',
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBlack,
        TextSize = 19,
        TextXAlignment = Enum.TextXAlignment.Left,
        Visible = false,
        ZIndex = 100
    }, gui)
    round(mini, 12)
    outline(mini, T.Accent, T)
    make("UIPadding", {PaddingLeft = UDim.new(0, 16)}, mini)

    local miniLang = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -8, 0.5, -13),
        Size = UDim2.fromOffset(34, 26),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.3,
        Text = UI.Language,
        TextColor3 = T.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ZIndex = 102
    }, mini)
    round(miniLang, 7)
    miniLang.Activated:Connect(function()
        showLanguageMenu(miniLang)
    end)

    local miniMoved, miniStart = false, Vector2.zero
    drag(mini, function()
        miniMoved = false
        miniStart = mini.AbsolutePosition
    end, function(d)
        if d.Magnitude > 6 then miniMoved = true end
        if miniMoved then
            local v = gui.AbsoluteSize
            local x = math.clamp(miniStart.X + d.X, 0, v.X - MINI_W)
            local y = math.clamp(miniStart.Y + d.Y, 0, v.Y - MINI_H)
            mini.Position = UDim2.fromOffset(x, y)
        end
    end)

    local function openMain()
        closeLanguageMenu()
        mini.Visible = false
        main.Visible = true
        main.Size = UDim2.fromOffset(savedSize.X.Offset, 55)
        animate(main, {Size = savedSize}, 0.3)
    end

    mini.Activated:Connect(function()
        if miniMoved then return end
        openMain()
    end)

    minimize.Activated:Connect(function()
        closeLanguageMenu()
        savedSize = main.Size
        main.Visible = false
        mini.Visible = true
    end)

    if options.ToggleKey then
        track(UIS.InputBegan:Connect(function(input, processed)
            if processed or UIS:GetFocusedTextBox() then return end
            if input.KeyCode == options.ToggleKey then
                gui.Enabled = not gui.Enabled
            end
        end))
    end

    local function askClose()
        if confirmBox then return end

        confirmDim = make("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 0.45,
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
        outline(confirmBox, nil, T)

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
                Position = UDim2.new(0, x, 1, -44),
                Size = UDim2.fromOffset(130, 30),
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
            confirmDim:Destroy()
            confirmDim = nil
            confirmBox = nil
        end)
    end
    close.Activated:Connect(askClose)

    local grip = make("TextButton", {
        Name = "ResizeGrip",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -2, 1, -2),
        Size = UDim2.fromOffset(32, 32),
        BackgroundColor3 = T.Element,
        BackgroundTransparency = 0.15,
        Text = "◢",
        TextColor3 = T.Muted,
        TextSize = 16,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ZIndex = 10
    }, main)
    round(grip, 6)

    local originalSize
    drag(grip, function()
        toTopLeft()
        originalSize = main.Size
    end, function(d)
        local width = math.clamp(originalSize.X.Offset + d.X / scale.Scale, 340, 950)
        local height = math.clamp(originalSize.Y.Offset + d.Y / scale.Scale, 240, 750)
        main.Size = UDim2.fromOffset(width, height)
        savedSize = main.Size
    end)

    local function register(opt, get, set)
        if not opt.Flag then return end
        flagItems[opt.Flag] = {get = get, set = set}
        Window.Flags[opt.Flag] = get()
    end
    local function setFlag(opt, value)
        if opt.Flag then Window.Flags[opt.Flag] = value end
    end

    local function configPath(name)
        local folder = options.ConfigFolder or "NexusUI"
        return folder, folder .. "/" .. (name or options.ConfigName or "default") .. ".json"
    end

    function Window:SaveConfig(name)
        if not writefile then return false end
        local folder, path = configPath(name)
        local data = {}
        for flag, item in pairs(flagItems) do
            data[flag] = item.get()
        end
        local ok = pcall(function()
            if makefolder and isfolder and not isfolder(folder) then
                makefolder(folder)
            end
            writefile(path, HttpService:JSONEncode(data))
        end)
        return ok
    end

    function Window:LoadConfig(name)
        if not (readfile and isfile) then return false end
        local _, path = configPath(name)
        if not isfile(path) then return false end
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)
        if not ok or type(data) ~= "table" then return false end
        for flag, value in pairs(data) do
            local item = flagItems[flag]
            if item then pcall(item.set, value) end
        end
        return true
    end

    local function newApi(instance)
        local a = {Instance = instance}
        function a:Destroy() instance:Destroy() end
        return a
    end

    function Window:CreateTab(config)
        config = config or {}
        local nameSource = config.Name or "Tab"
        local rawName = key(nameSource)

        local tabButton = make("TextButton", {
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = T.Element,
            BackgroundTransparency = EA,
            TextColor3 = T.Muted,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            BorderSizePixel = 0,
            AutoButtonColor = false
        }, tabList)
        round(tabButton, 8)
        bind(tabButton, "Text", function() return tx(nameSource) end)

        local page = make("ScrollingFrame", {
            Name = rawName,
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

        local entry = {Button = tabButton, Page = page, Name = rawName}
        table.insert(pages, entry)

        local function selectTab()
            for _, p in ipairs(pages) do
                p.Page.Visible = p == entry
                animate(p.Button, {
                    BackgroundColor3 = p == entry and T.Border or T.Element,
                    TextColor3 = p == entry and T.Text or T.Muted
                })
            end
        end
        tabButton.Activated:Connect(selectTab)
        if #pages == 1 then selectTab() end

        local Tab = {}

        function Tab:Select()
            selectTab()
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
            }, page)
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
                TextColor3 = T.Accent,
                Font = Enum.Font.GothamBold,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left
            }, page)
            bind(l, "Text", function() return string.upper(tx(name)) end)
            return newApi(l)
        end

        function Tab:CreateDivider()
            local d = make("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = T.Border,
                BackgroundTransparency = 0.4,
                BorderSizePixel = 0
            }, page)
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
            }, page)
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
            }, page)
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

            local api = newApi(b)
            api.Fire = fire
            return api
        end

        function Tab:CreateToggle(opt)
            opt = opt or {}
            local state = opt.CurrentValue == true
            local b = card(42)
            nameLabel(b, opt.Name, -70, "Toggle")

            local trackBar = make("Frame", {
                Position = UDim2.new(1, -50, 0.5, -11),
                Size = UDim2.fromOffset(40, 22),
                BackgroundColor3 = T.Border,
                BorderSizePixel = 0
            }, b)
            round(trackBar, 15)

            local knob = make("Frame", {
                Position = UDim2.fromOffset(2, 2),
                Size = UDim2.fromOffset(18, 18),
                BackgroundColor3 = T.Text,
                BorderSizePixel = 0
            }, trackBar)
            round(knob, 12)

            local function update(call)
                animate(trackBar, {BackgroundColor3 = state and T.Accent or T.Border})
                animate(knob, {Position = UDim2.fromOffset(state and 20 or 2, 2)})
                setFlag(opt, state)
                if call then spawnCall(opt.Callback, state) end
            end

            b.Activated:Connect(function()
                state = not state
                update(true)
            end)

            local api = newApi(b)
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

            local fill = make("Frame", {
                Size = UDim2.new(pct(), 0, 1, 0),
                BackgroundColor3 = T.Accent,
                BorderSizePixel = 0
            }, bar)
            round(fill, 6)

            local function apply(v, call)
                value = snap(v)
                fill.Size = UDim2.new(pct(), 0, 1, 0)
                label.Text = labelText()
                setFlag(opt, value)
                if call then spawnCall(opt.Callback, value) end
            end

            local dragging = false
            local function fromX(x)
                local p = math.clamp(
                    (x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
                apply(min + (max - min) * p, true)
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

            local api = newApi(b)
            function api:Get() return value end
            function api:Set(v) apply(v, true) end
            register(opt, function() return value end, function(v)
                if type(v) == "number" then apply(v, true) end
            end)
            setFlag(opt, value)
            return api
        end

        function Tab:CreateDropdown(opt)
            opt = opt or {}
            local choices = opt.Options or {}
            local index = 1
            local HEAD, ROW = 42, 30
            local open = false

            local function findIndex(v)
                for i, c in ipairs(choices) do
                    if c == v or key(c) == key(v) then return i end
                end
                return nil
            end
            if opt.CurrentOption ~= nil then
                index = findIndex(opt.CurrentOption) or 1
            end

            local holder = make("Frame", {
                Name = "Dropdown",
                Size = UDim2.new(1, 0, 0, HEAD),
                BackgroundColor3 = T.Element,
                BackgroundTransparency = EA,
                BorderSizePixel = 0,
                ClipsDescendants = true
            }, page)
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

            local arrow = make("TextLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(18, 18),
                BackgroundTransparency = 1,
                Text = "▾",
                TextColor3 = T.Muted,
                Font = Enum.Font.GothamBold,
                TextSize = 14
            }, head)

            local list = make("Frame", {
                Position = UDim2.fromOffset(0, HEAD),
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1
            }, holder)

            local function labelText()
                return tx(opt.Name or "Dropdown") .. ": "
                    .. (choices[index] ~= nil and tx(choices[index]) or "—")
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
                index = i
                label.Text = labelText()
                setFlag(opt, index)
                for _, child in ipairs(list:GetChildren()) do
                    if child:IsA("TextButton") then
                        local active = child:GetAttribute("Index") == index
                        animate(child, {BackgroundColor3 = active and T.Border or T.Element})
                    end
                end
                if call then
                    spawnCall(opt.Callback, key(choices[index]), index)
                end
            end

            local function build()
                for _, child in ipairs(list:GetChildren()) do
                    child:Destroy()
                end
                list.Size = UDim2.new(1, 0, 0, listHeight())
                for i, choice in ipairs(choices) do
                    local o = make("TextButton", {
                        Position = UDim2.fromOffset(6, 4 + (i - 1) * ROW),
                        Size = UDim2.new(1, -12, 0, ROW - 4),
                        BackgroundColor3 = i == index and T.Border or T.Element,
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

            local api = newApi(holder)
            function api:Get() return key(choices[index]), index end
            function api:Set(v)
                local i = type(v) == "number" and v or findIndex(v)
                if i then choose(i, true) end
            end
            function api:Refresh(newOptions, keepSelection)
                choices = newOptions or {}
                if not keepSelection or index > #choices then index = 1 end
                label.Text = labelText()
                build()
            end
            register(opt, function() return index end, function(v)
                if type(v) == "number" then choose(v, true) end
            end)
            setFlag(opt, index)
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
                Size = UDim2.fromOffset(124, 26),
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

            local api = newApi(b)
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
            local current = opt.CurrentKeybind or Enum.KeyCode.Unknown
            local listening = false
            local b = card(42)
            nameLabel(b, opt.Name, -110, "Keybind")

            local btn = make("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(84, 26),
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

            local api = newApi(b)
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
            return api
        end

        return Tab
    end

    -- ═══════════════════════════════════════════════════════════
    --  SISTEMA DE NOTIFICACIONES TOAST (v6.0)
    -- ═══════════════════════════════════════════════════════════
    local notifications = make("Frame", {
        Name = "Notifications",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -14, 1, -14),
        Size = UDim2.fromOffset(280, 340),
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

    local notificationCount = 0

    function Window:Notify(opt)
        opt = opt or {}
        notificationCount += 1

        local notifType = opt.Type or "Info" -- Info, Success, Warning, Error
        local accentColor = T.Accent
        if notifType == "Success" then accentColor = T.Success
        elseif notifType == "Warning" then accentColor = T.Warning
        elseif notifType == "Error" then accentColor = T.Error end

        local note = make("Frame", {
            Name = "Notification",
            Size = UDim2.new(1, 0, 0, 76),
            BackgroundColor3 = T.Panel,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            LayoutOrder = notificationCount,
            ZIndex = 81
        }, notifications)
        round(note, 12)
        outline(note, nil, T)

        local bar = make("Frame", {
            Position = UDim2.fromOffset(0, 12),
            Size = UDim2.new(0, 4, 1, -24),
            BackgroundColor3 = accentColor,
            BorderSizePixel = 0,
            ZIndex = 82
        }, note)
        round(bar, 4)

        make("TextLabel", {
            Position = UDim2.fromOffset(14, 8),
            Size = UDim2.new(1, -25, 0, 22),
            BackgroundTransparency = 1,
            Text = tx(opt.Title or "NEXUS UI v6"),
            TextColor3 = T.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 82
        }, note)

        make("TextLabel", {
            Position = UDim2.fromOffset(14, 31),
            Size = UDim2.new(1, -25, 0, 36),
            BackgroundTransparency = 1,
            Text = tx(opt.Content or L("Listo.", "Done.")),
            TextColor3 = T.Muted,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 82
        }, note)

        animate(note, {BackgroundTransparency = 0})

        task.delay(opt.Duration or 3.5, function()
            if note.Parent then
                animate(note, {BackgroundTransparency = 1})
                task.wait(UI.AnimationSpeed + 0.05)
                if note.Parent then note:Destroy() end
            end
        end)

        return note
    end

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

    local loaded = false
    local loadedCallbacks = {}

    function Window:OnLoaded(fn)
        if loaded then
            spawnCall(fn)
        else
            table.insert(loadedCallbacks, fn)
        end
    end

    local function finishLoading()
        loaded = true
        for _, fn in ipairs(loadedCallbacks) do
            spawnCall(fn)
        end
        loadedCallbacks = {}
    end

    if options.Loading == false then
        task.defer(function()
            if not gui.Parent then return end
            openMain()
            finishLoading()
        end)
        return Window
    end

    task.spawn(function()
        local loadGui = make("ScreenGui", {
            Name = guiName .. "Loading",
            ResetOnSpawn = false,
            DisplayOrder = (options.DisplayOrder or 999) + 1,
            IgnoreGuiInset = true,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        }, parent)
        pcall(function() loadGui.ScreenInsets = Enum.ScreenInsets.None end)
        gui.Destroying:Connect(function() loadGui:Destroy() end)

        local screen = make("CanvasGroup", {
            Name = "Loading",
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = T.Background,
            BorderSizePixel = 0,
            GroupTransparency = 0,
            ZIndex = 500
        }, loadGui)

        if IMG_BG ~= "" then
            make("ImageLabel", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Image = IMG_BG,
                ScaleType = Enum.ScaleType.Crop
            }, screen)
            make("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.45,
                BorderSizePixel = 0
            }, screen)
        end

        if IMG_LOGO ~= "" then
            local logo = make("ImageLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, -50),
                Size = UDim2.fromOffset(320, 180),
                BackgroundColor3 = T.Panel,
                Image = IMG_LOGO,
                ScaleType = Enum.ScaleType.Crop
            }, screen)
            round(logo, 14)
            outline(logo, nil, T)
        else
            make("TextLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, -50),
                Size = UDim2.fromOffset(320, 60),
                BackgroundTransparency = 1,
                Text = options.Title or "NEXUS UI v6.0",
                TextColor3 = T.Text,
                Font = Enum.Font.GothamBold,
                TextSize = 34
            }, screen)
        end

        local status = make("TextLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, -40, 0.5, 66),
            Size = UDim2.fromOffset(240, 20),
            BackgroundTransparency = 1,
            TextColor3 = T.Muted,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        }, screen)

        local pct = make("TextLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 120, 0.5, 66),
            Size = UDim2.fromOffset(80, 20),
            BackgroundTransparency = 1,
            Text = "0%",
            TextColor3 = T.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right
        }, screen)

        local barBg = make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 90),
            Size = UDim2.fromOffset(320, 6),
            BackgroundColor3 = T.Border,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0
        }, screen)
        round(barBg, 6)

        local fill = make("Frame", {
            Size = UDim2.fromScale(0, 1),
            BackgroundColor3 = T.Accent,
            BorderSizePixel = 0
        }, barBg)
        round(fill, 6)

        local stages = {
            {0.25, L("Iniciando Nexus Core 2.0...", "Starting Nexus Core 2.0...")},
            {0.60, L("Cargando componentes avanzados...", "Loading advanced components...")},
            {0.90, L("Aplicando Black Edition...", "Applying Black Edition...")},
            {1.00, L("¡Listo!", "Ready!")}
        }
        local current = 1
        bind(status, "Text", function() return tx(stages[current][2]) end)

        local per = (options.LoadingTime or 2.2) / #stages
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

-- ═══════════════════════════════════════════════════════════
--  EJEMPLO DE USO (v6.0.0 API)
-- ═══════════════════════════════════════════════════════════

local Window = UI:CreateWindow({
    Title = "NEXUS HUB v6.0",
    Language = "ES",
    ToggleKey = Enum.KeyCode.RightShift,
    ConfigName = "nexus-v6-config"
})

-- ───────── Pestaña 1 ─────────
local Home = Window:CreateTab({Name = UI.T("Inicio", "Home")})

Home:CreateSection(UI.T("General", "General"))

Home:CreateParagraph({
    Title = UI.T("Nexus UI v6.0.0", "Nexus UI v6.0.0"),
    Content = UI.T("Actualización masiva Black Edition con motor de temas, búsqueda en tiempo real y notificaciones Toast.",
                   "Massive Black Edition update with theme engine, live search and Toast notifications.")
})

Home:CreateButton({
    Name = UI.T("Notificación de Éxito", "Success Notification"),
    Callback = function()
        Window:Notify({
            Title = "Nexus v6.0",
            Content = UI.T("¡Notificación Toast activada con éxito!", "Toast notification triggered successfully!"),
            Type = "Success",
            Duration = 4
        })
    end
})

Home:CreateToggle({
    Name = UI.T("Modo Avanzado", "Advanced Mode"),
    CurrentValue = false,
    Flag = "advanced_mode",
    Callback = function(value)
        print("Toggle state:", value)
    end
})

Home:CreateSlider({
    Name = UI.T("Sensibilidad", "Sensitivity"),
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "x",
    CurrentValue = 2.5,
    Flag = "sensitivity",
    Callback = function(value)
        print("Slider value:", value)
    end
})

-- ───────── Pestaña 2 ─────────
local Extra = Window:CreateTab({Name = UI.T("Extras", "Extras")})

Extra:CreateDropdown({
    Name = UI.T("Estilo de Tema", "Theme Style"),
    Options = {
        UI.T("Cian Neón", "Neon Cyan"),
        UI.T("Púrpura Neón", "Neon Purple"),
        UI.T("Grafito Oscuro", "Dark Graphite")
    },
    CurrentOption = "Neon Cyan",
    Flag = "theme_style",
    Callback = function(value, index)
        print("Dropdown:", value, index)
    end
})

Extra:CreateInput({
    Name = UI.T("Mensaje personalizado", "Custom Message"),
    Placeholder = UI.T("Escribe algo...", "Type something..."),
    Flag = "custom_msg",
    Callback = function(text)
        print("Input text:", text)
    end
})

Extra:CreateKeybind({
    Name = UI.T("Atajo de menú", "Menu Shortcut"),
    CurrentKeybind = Enum.KeyCode.F,
    Flag = "menu_key",
    Callback = function()
        Window:Notify({
            Title = UI.T("Atajo", "Shortcut"),
            Content = UI.T("¡Tecla de acceso rápido pulsada!", "Shortcut key pressed!"),
            Type = "Info"
        })
    end
})

-- ───────── Pestaña 3 (Ajustes) ─────────
local Config = Window:CreateTab({Name = UI.T("Ajustes", "Settings")})

Config:CreateButton({
    Name = UI.T("Guardar configuración", "Save config"),
    Callback = function()
        Window:SaveConfig()
        Window:Notify({
            Title = "Config",
            Content = UI.T("Configuración guardada correctamente.", "Config saved successfully."),
            Type = "Success"
        })
    end
})

Config:CreateButton({
    Name = UI.T("Cargar configuración", "Load config"),
    Callback = function()
        local ok = Window:LoadConfig()
        Window:Notify({
            Title = "Config",
            Content = ok and UI.T("Configuración cargada.", "Config loaded.")
                or UI.T("No hay archivo guardado.", "No saved file found."),
            Type = ok and "Success" or "Warning"
        })
    end
})

Window:OnLoaded(function()
    Window:Notify({
        Title = "Nexus UI v" .. UI.Version,
        Content = UI.T("Interfaz cargada y optimizada.", "Interface loaded and optimized."),
        Type = "Success",
        Duration = 4
    })
end)
