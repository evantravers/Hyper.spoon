--- === Hyper ===
---
--- Hammerspoon has a module for custom keyboard shortcuts called
--- [hs.hotkey.modal](https://www.hammerspoon.org/docs/hs.hotkey.modal). Hyper
--- is a [modern space cadet](https://stevelosh.com/blog/2012/10/a-modern-space-cadet/)
--- inspired wrapper on `hs.hotkey.modal` that changes one feature and adds
--- another:
---
--- - changes the "toggle" style of `hs.hotkey.modal` to a "momentary hold" style
--- - adds an optional `bindPassThrough` that drops out of Lua to send a "Hyper chord" to an OSX application.
---
--- I chiefly use it to launch applications quickly from a single press, although I
--- also use it to create "universal" local bindings inspired by [Shawn Blanc's
--- OopsieThings](https://thesweetsetup.com/oopsiethings-applescript-for-things-on-mac/).

local m = hs.hotkey.modal.new({}, nil)

m.name = "Hyper"
m.version = "2.2"
m.author = "Evan Travers <evantravers@gmail.com>"
m.license = "MIT <https://opensource.org/licenses/MIT>"
m.homepage = "https://github.com/evantravers/Hyper.spoon"

--- Hyper:bindHotKeys(table) -> hs.hotkey.modal
--- Method
--- Expects a config table in the form of {"hyperKey" = {mods, key}}.
---
--- Returns:
---  * self
function m:bindHotKeys(mapping)
  local mods, key = table.unpack(mapping["hyperKey"])
  hs.hotkey.bind(mods, key, function() m:enter() end, function() m:exit() end)

  return self
end

--- Hyper:bindPassThrough(key, bundleId) -> hs.hotkey.modal
--- Method
--- Ensures the bundleId's application is running, then sends the "hyper-chord"
--- (⌘+⌥+⌃+⇧) plus whatever you set as `key`.
---
--- Returns:
---  * self
function m:bindPassThrough(key, app)
  m:bind({}, key, nil, function()
    if hs.application.get(app) then
      hs.eventtap.keyStroke({'cmd','alt','shift','ctrl'}, key)
    else
      hs.application.launchOrFocusByBundleID(app)
      hs.timer.waitWhile(
        function()
          return not hs.application.get(app):isFrontmost()
        end,
        function()
          hs.eventtap.keyStroke({'cmd','alt','shift','ctrl'}, key)
        end
      )
    end
  end)

  return self
end

return m
