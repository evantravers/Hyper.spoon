--- === Hyper ===
---
--- Hyper is a hyper shortcut modal.
---
--- Feel free to modify... I use karabiner-elements.app on my laptop and QMK on
--- my mech keyboards to bind a single key to `F19`, which fires all this
--- Hammerspoon-powered OSX automation.
---
--- I chiefly use it to launch applications quickly from a single press,
--- although I also use it to create "universal" local bindings inspired by
--- Shawn Blanc's OopsieThings.
--- https://thesweetsetup.com/oopsiethings-applescript-for-things-on-mac/

local m = {
  name = "Hyper",
  version = "1.0",
  author = "Evan Travers <evantravers@gmail.com>",
  license = "MIT <https://opensource.org/licenses/MIT>",
  homepage = "https://github.com/evantravers/Hyper.spoon",
}

m.modal = hs.hotkey.modal.new({}, nil)

local pressed  = function() m.modal:enter() end
local released = function() m.modal:exit() end

local launch = function(app)
  hs.application.launchOrFocusByBundleID(app.bundleID)
end

--- Hyper:setHyperKey(string) -> table
--- Method
--- Sets the key for triggering the hyper modal. (e.g. F19)
---
--- Parameters:
---  * key - A string containing a valid keycode of a keyboard key (as found in hs.keycodes.map)
---
--- Returns:
---  * self
function m:setHyperKey(key)
  hs.hotkey.bind({}, key, pressed, released)

  return self
end

--- Hyper:start(configTable) -> table
--- Method
--- Expects a configuration table with an applications key that has the
--- following form:
--- configTable.applications = {
---   ['com.culturedcode.ThingsMac'] = {
---     bundleID = 'com.culturedcode.ThingsMac',
---     hyperKey = 't',
---     localBindings = {',', '.'}
---   },
--- }
---
--- Parameters:
---  * configTable - A table containing applications.
---
--- Returns:
---  * self
function m:start(configTable)
  -- Use the hyper key with the application config to use the `hyperKey`
  hs.fnutils.map(configTable.applications, function(app)
    -- Apps that I want to jump to
    if app.hyperKey then
      m.modal:bind({}, app.hyperKey, function() launch(app); end)
    end

    -- I use hyper to power some shortcuts in different apps If the app is closed
    -- and I press the shortcut, open the app and send the shortcut, otherwise
    -- just send the shortcut.
    if app.localBindings then
      hs.fnutils.map(app.localBindings, function(key)
        m.modal:bind({}, key, nil, function()
          if hs.application.get(app.bundleID) then
            hs.eventtap.keyStroke({'cmd','alt','shift','ctrl'}, key)
          else
            launch(app)
            hs.timer.waitWhile(
              function()
                return not hs.application.get(app.bundleID):isFrontmost()
              end,
              function()
                hs.eventtap.keyStroke({'cmd','alt','shift','ctrl'}, key)
              end
            )
          end
        end)
      end)
    end
  end)

  return self
end

--- Hyper:bind(args) -> table
--- Method
--- Passes on a binding to the Spoon's internal hs.hotkey.modal, same
--- arguments as `hs.hotkey.modal:bind()`
---
--- Parameters:
---  * mods - A table or a string containing (as elements, or as substrings with any separator) the keyboard modifiers required,
---    which should be zero or more of the following:
---    * "cmd", "command" or "⌘"
---    * "ctrl", "control" or "⌃"
---    * "alt", "option" or "⌥"
---    * "shift" or "⇧"
---  * key - A string containing the name of a keyboard key (as found in [hs.keycodes.map](hs.keycodes.html#map) ), or a raw keycode number
---  * message - A string containing a message to be displayed via `hs.alert()` when the hotkey has been triggered, or nil for no alert
---  * pressedfn - A function that will be called when the hotkey has been pressed, or nil
---  * releasedfn - A function that will be called when the hotkey has been released, or nil
---  * repeatfn - A function that will be called when a pressed hotkey is repeating, or nil
---
--- Returns:
---  * self
function m:bind(...)
  m.modal:bind(...)

  return self
end

return m
