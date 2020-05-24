--------------------------------------------------
--
-- ユーティリティー
-- cmd  + alt   + ctrl  + f 現在フォーカスされているウィンドウのアプリケーション名表示
--
-- キーリマップ系
-- ctrl +                 [ エスケープ、IMEオフ
--
-- アプリケーション起動ショートカット系
-- alt                    z Chrome起動
-- alt  + ctrl  +         z Chromium起動
-- alt                    e iTerm起動
--
-- ウインドウ移動
-- alt  + shift +         h 左に10ポイントウィンドウを移動
-- alt  + shift +         j 下に10ポイントウィンドウを移動
-- alt  + shift +         k 上に10ポイントウィンドウを移動
-- alt  + shift +         l 右に10ポイントウィンドウを移動
--
-- ウインドウフォーカス
-- alt  + ctrl  +         h フォーカスを左に
-- alt  + ctrl  +         j フォーカスを下に
-- alt  + ctrl  +         k フォーカスを上に
-- alt  + ctrl  +         l フォーカスを右に
--
-- ウインドウリサイズ
-- alt  +                 k 画面横幅半分で左右ローテーション
-- alt  +                 t 4分の1サイズで左上
-- alt  +                 y 4分の1サイズで右上
-- alt  +                 b 4分の1サイズで左下
-- alt  +                 n 4分の1サイズで右下
-- alt  +                 c 画面半分横幅にし、真ん中へ移動
-- alft +                 m y位置を縦真ん中に揃える、ウィンドウ高さがはみ出る時はリサイズ
-- alt  +                 f フルサイズ
--
-- その他
-- 本ファイル保存時自動Reload
--------------------------------------------------

-- 英数キーコード
local eisuu = 0x66

local function keyStroke(mods, key)
    return function() hs.eventtap.keyStroke(mods, key, 0) end
end

local function escAndEisuu()
    hs.eventtap.keyStroke({}, "escape", 0)
    hs.eventtap.keyStroke({}, eisuu, 0)
end

-- alias of hs.hotkey.bind()
local function remap(mods, key, fn)
    return hs.hotkey.bind(mods, key, fn, nil, fn)
end

local function half(num)
  return num / 2
end

local function moveWin(point, to)
    local win = hs.window.focusedWindow()
    local f = win:frame()

    if point == 'x' then
        f.x = f.x + to
    elseif point == 'y' then
        f.y = f.y + to
    end

    win:setFrame(f)
end

local function resizeFrame(mods, key, fn)
  remap(mods, key, function()
          local win = hs.window.focusedWindow()
          local f = win:frame()
          local screen = win:screen()
          local max = screen:frame()

          fn(f, screen, max)

          win:setFrame(f)
  end)
end

----------------------------
-- global key remap
----------------------------
-- Hello World
-- remap({"cmd", "alt", "ctrl"}, "W", function()
--     hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
-- end)

-- display current application name
remap({"cmd", "alt", "ctrl"}, "F", function()
    hs.alert.show("Current App: " .. hs.window.focusedWindow():application():name())
end)

-- escape and eisuu
remap({"ctrl"}, '[', escAndEisuu)

---------------
-- Launch app
---------------
-- Launch Google Chrome
remap({"alt"}, "Z", function()
    hs.application.launchOrFocus("Google Chrome")
end)

-- Launch Chromium
remap({"alt", "ctrl"}, "Z", function()
    hs.application.launchOrFocus("Chromium")
end)

-- Launch iTerm
remap({"alt"}, "E", function()
    hs.application.launchOrFocus("iTerm")
end)


---------------
-- Move window
---------------
-- move current window to 10 point left.
remap({"alt", "shift"}, "H", function() moveWin('x', -10) end)
-- move current window to 10 point downwards
remap({"alt", "shift"}, "J", function() moveWin('y', 10) end)
-- move current window to 10 point above.
remap({"alt", "shift"}, "K", function() moveWin('y', -10) end)
-- move current window to 10 point right.
remap({"alt", "shift"}, "L", function() moveWin('x', 10) end)

-----------------------
-- Change focus
-----------------------
-- focus left side window.
remap({"alt", "ctrl"}, "H", function() hs.window.focusWindowWest() end)
-- focus lowner window.
remap({"alt", "ctrl"}, "J", function() hs.window.focusWindowSouth() end)
-- focus right window.
remap({"alt", "ctrl"}, "L", function() hs.window.focusWindowEast() end)
-- focus upper window.
remap({"alt", "ctrl"}, "K", function() hs.window.focusWindowNorth() end)

-----------------------
-- Change window size
-----------------------
-- half width, full height, left or right side(toggle)
resizeFrame({"alt"}, "K", function(f, screen, max)
    local halfWidth = half(max.w)
    if f.x ~= max.x and f.x <= halfWidth then
      f.x = max.x
    elseif f.x == max.x or f.x >= halfWidth then
      f.x = halfWidth
    end

    f.y = max.y
    f.w = halfWidth
    f.h = max.h
end)

-- alien window middle
resizeFrame({"alt"}, "M", function(f, screen, max)
    local halfHeight = half(max.h)
    f.y = halfHeight - half(halfHeight)

    if f.h > (max.h - f.y) then
      f.h = max.h - f.y
    end

end)

-- half width, full height, centering
resizeFrame({"alt"}, "C", function(f, screen, max)
    local screenCenter = half(max.w)

    f.x = screenCenter - half(screenCenter)
    f.y = 0
    f.w = half(max.w)
    f.h = max.h
end)

--
-- quater size
-- t  y
-- b  n
--
resizeFrame({"alt"}, "T", function(f, screen, max)
    f.x = max.x
    f.y = max.y
    f.w = half(max.w)
    f.h = half(max.h)
end)
-- resizeFrame({"alt"}, "Y", function(f, screen, max)
--     local frameCenter = f.w / 2
--     local screenCenter = max.w / 2
--
--     f.x = screenCenter - frameCenter
--     f.y = max.y
--     f.w = max.w / 2
--     f.h = max.h / 2
-- end)
resizeFrame({"alt"}, "Y", function(f, screen, max)
    f.x = half(max.w)
    f.y = max.y
    f.w = half(max.w)
    f.h = half(max.h)
end)
resizeFrame({"alt"}, "B", function(f, screen, max)
    f.x = max.x
    f.y = half(max.h)
    f.w = half(max.w)
    f.h = half(max.h)
end)
-- resizeFrame({"alt"}, "N", function(f, screen, max)
--     local frameCenter = f.w / 2
--     local screenCenter = max.w / 2
--
--     f.x = screenCenter - frameCenter
--     f.y = max.h / 2
--     f.w = max.w / 2
--     f.h = max.h / 2
-- end)
resizeFrame({"alt"}, "N", function(f, screen, max)
    f.x = half(max.w)
    f.y = half(max.h)
    f.w = half(max.w)
    f.h = half(max.h)
end)

-- full screen
resizeFrame({"alt"}, "F", function(f, screen, max)
    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
end)

-- utility function. reload config when init.lua saved.
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

