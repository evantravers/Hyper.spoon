# Hyper

A "hyper" style modal spoon. I use karabiner-elements.app on my laptop and QMK
on my mech keyboards to bind a single key to `F19`, which fires all this
Hammerspoon-powered OSX automation.

I chiefly use it to launch applications quickly from a single press, although I
also use it to create "universal" local bindings inspired by [Shawn Blanc's
OopsieThings](https://thesweetsetup.com/oopsiethings-applescript-for-things-on-mac/).

```lua
Config = {
  applications = {
    ['com.culturedcode.ThingsMac'] = {
      bundleID = 'com.culturedcode.ThingsMac',
      hyperKey = 't',
      localBindings = {',', '.'},
    }
  }
}

hs.loadSpoon('Hyper')
Hyper = spoon.Hyper
             :start(Config)
             :setHyperKey('F19')

Hyper:bind({}, 'return', nil, autolayout.autoLayout)
```

[Original Blog Post](http://evantravers.com/articles/2020/06/08/hammerspoon-a-better-better-hyper-key/)
