local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local lain = require("lain")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local config = {}

function config.init(context)

    local modkey      = context.keys.modkey
    local altkey      = context.keys.altkey
    local ctrlkey     = context.keys.ctrlkey
    local shiftkey    = context.keys.shiftkey
    local leftkey     = context.keys.leftkey
    local rightkey    = context.keys.rightkey
    local upkey       = context.keys.upkey
    local downkey     = context.keys.downkey

    local terminal    = context.terminal
    local browser     = context.browser

    -- Mouse bindings
    root.buttons(awful.util.table.join(
        awful.button({ }, 3, function() awful.util._mainmenu:toggle() end)
        -- awful.button({ }, 4, awful.tag.viewnext),
        -- awful.button({ }, 5, awful.tag.viewprev)
    ))

    -- Exit mode
    context.keys.escape =
        awful.key({                           }, "Escape", context.exit_keys_mode,
                  {description = "exit mode", group = "awesome"})

    -- Key bindings
    context.keys.global = awful.util.table.join(
        -- Awesome Hotkeys
        awful.key({ modkey, ctrlkey           }, "s", hotkeys_popup.show_help,
                  {description = "show help", group = "awesome"}),
        awful.key({ modkey, ctrlkey           }, "w", function() awful.util._mainmenu:show() end,
                  {description = "show main menu", group = "awesome"}),
        awful.key({ modkey, ctrlkey           }, "r", awesome.restart,
                  {description = "reload awesome", group = "awesome"}),
        awful.key({ modkey, ctrlkey           }, "q", awesome.quit,
                  {description = "quit awesome", group = "awesome"}),
        awful.key({ modkey, ctrlkey           }, "z", function() awful.spawn("sync"); awful.spawn("xautolock -locknow") end,
                  {description = "lock screen", group = "awesome"}),

        -- Hotkeys
        awful.key({ modkey                    }, "Return", function() awful.spawn(terminal) end,
                  {description = "open a terminal", group = "launcher"}),
        awful.key({ modkey, ctrlkey           }, "Return", function() awful.spawn(terminal, {floating = true, placement = awful.placement.centered}) end,
                  {description = "open a floating terminal", group = "launcher"}),
        awful.key({ modkey                    }, "b", function() awful.spawn(browser) end,
                  {description = "open browser", group = "launcher"}),
        awful.key({ modkey                    }, "e", function() awful.spawn("thunderbird") end,
                  {description = "open email client", group = "launcher"}),
        awful.key({ modkey                    }, "w", function() awful.spawn("Whatsapp") end,
                  {description = "open whatsapp", group = "launcher"}),

        -- Scteenshot
        awful.key({                           }, "Print", function()
            awful.spawn(awful.util.scripts_dir .. "/make-screenshot")
        end,
                  {description = "take screenshot", group = "screenshot"}),
        awful.key({ shiftkey                  }, "Print", function()
            awful.spawn(awful.util.scripts_dir .. "/make-screenshot -s")
        end,
                  {description = "take screenshot, select area", group = "screenshot"}),
        awful.key({ ctrlkey                   }, "Print", function()
            awful.spawn(awful.util.scripts_dir .. "/make-screenshot -h")
        end,
                  {description = "take screenshot, hide mouse", group = "screenshot"}),
        awful.key({ ctrlkey, shiftkey         }, "Print", function()
            awful.spawn(awful.util.scripts_dir .. "/make-screenshot -h -s")
        end,
                  {description = "take screenshot, hide mouse, select area", group = "screenshot"}),
        awful.key({ modkey                    }, "Print", function()
            awful.spawn(awful.util.scripts_dir .. "/make-screenshot -w")
        end,
                  {description = "wait 5s, take screenshot", group = "screenshot"}),
        awful.key({ modkey, ctrlkey           }, "Print", function()
            awful.spawn(awful.util.scripts_dir .. "/make-screenshot -w -h")
        end,
                  {description = "wait 5s, take screenshot, hide mouse", group = "screenshot"}),
        awful.key({ altkey                    }, "Print", function()
            awful.spawn(awful.util.scripts_dir .. "/upload-to-imgur")
        end,
                  {description = "upload last screenshot to Imgur", group = "screenshot"}),

        -- -- Copy primary to clipboard (terminals to gtk)
        -- awful.key({ modkey }, "c", function() awful.spawn("xsel | xsel -i -b") end),
        -- -- Copy clipboard to primary (gtk to terminals)
        -- awful.key({ modkey }, "v", function() awful.spawn("xsel -b | xsel") end),

        -- Prompt
        awful.key({ modkey                    }, "r", function() awful.screen.focused()._promptbox:run() end,
                  {description = "run prompt", group = "launcher"}),
        awful.key({ modkey                    }, "p", function() menubar.show() end,
                  {description = "show the menubar", group = "launcher"}),
        awful.key({ modkey                    }, "-", function()
            context.easy_async_with_unfocus("rofi -show drun")
            -- awful.spawn("dmenu_run")
            -- awful.spawn(string.format("dmenu_run -i -t -dim 0.5 -p 'Run: ' -h 21 -fn 'Meslo LG S for Powerline-10' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
            -- beautiful.tasklist_bg_normal, beautiful.fg_normal, beautiful.tasklist_bg_urgent, beautiful.tasklist_fg_urgent))
        end,
                  {description = "show application menu (rofi)", group = "launcher"}),
        awful.key({ modkey                    }, ".", function()
            context.easy_async_with_unfocus("rofi -show run")
        end,
                  {description = "show commands menu (rofi)", group = "launcher"}),
        awful.key({ modkey                    }, "$", function()
            context.easy_async_with_unfocus(awful.util.scripts_dir .. "/rofi-session")
        end,
                  {description = "show session menu (rofi)", group = "launcher"}),
        -- awful.key({ altkey            }, "space", function()
        --     -- awful.spawn(string.format("dmenu_run -i -fn 'Meslo LG S for Powerline' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
        --     awful.spawn(string.format("rofi -show run -width 100 -location 1 -lines 5 -bw 2 -yoffset -2",
        --     beautiful.tasklist_bg_normal, beautiful.tasklist_fg_normal, beautiful.tasklist_bg_urgent, beautiful.tasklist_fg_urgent))
        -- end),
        awful.key({ modkey                    }, "x", function()
                      awful.prompt.run {
                          prompt       = "Run Lua code: ",
                          textbox      = awful.screen.focused()._promptbox.widget,
                          exe_callback = awful.util.eval,
                          history_path = awful.util.get_cache_dir() .. "/history_eval",
                      }
                  end,
                  {description = "lua execute prompt", group = "awesome"}),

        -- Dropdown application
        awful.key({ modkey                    }, "y", function() awful.screen.focused().quake:toggle() end,
                  {description = "open quake application", group = "screen"}),

        -- Screen browsing
        awful.key({ ctrlkey, altkey           }, leftkey, function() awful.screen.focus_relative(-1) end,
                  {description = "focus the previous screen", group = "screen"}),
        awful.key({ ctrlkey, altkey           }, rightkey, function() awful.screen.focus_relative(1) end,
                  {description = "focus the next screen", group = "screen"}),

        -- -- Tag browsing
        -- awful.key({ ctrlkey, altkey           }, leftkey, awful.tag.viewprev,
        --           {description = "view previous", group = "tag"}),
        -- awful.key({ ctrlkey, altkey           }, rightkey, awful.tag.viewnext,
        --           {description = "view next", group = "tag"}),
        -- awful.key({ ctrlkey, altkey           }, "Escape", awful.tag.history.restore,
        --           {description = "go back", group = "tag"}),

        -- Dynamic tagging
        awful.key({ modkey, altkey, shiftkey  }, leftkey, function() lain.util.move_tag(-1) end,
                  {description = "move tag backward", group = "tag"}),
        awful.key({ modkey, altkey, shiftkey  }, rightkey, function() lain.util.move_tag(1) end,
                  {description = "move tag forward", group = "tag"}),
        awful.key({ modkey, altkey            }, "n", function() lain.util.add_tag() end,
                  {description = "new tag", group = "tag"}),
        awful.key({ modkey, altkey            }, "r", function() lain.util.rename_tag() end,
                  {description = "rename tag", group = "tag"}),
        awful.key({ modkey, altkey            }, "d", function() lain.util.delete_tag() end,
                  {description = "delete tag", group = "tag"}),
        awful.key({ modkey, altkey            }, "a", function()
                for i = 1, 9 do
                    awful.tag.add(tostring(i), {
                        screen = awful.screen.focused(),
                        layout = layout or awful.layout.suit.tile,
                    })
                end
            end,
                  {description = "add row of tags", group = "tag"}),
        awful.key({ modkey, altkey            }, "BackSpace", awful.tag.history.restore,
                  {description = "go back", group = "tag"}),

        -- Non-empty tag browsing
        awful.key({ modkey, ctrlkey           }, leftkey, function() lain.util.tag_view_nonempty(-1) end,
                  {description = "view previous nonempty", group = "tag"}),
        awful.key({ modkey, ctrlkey           }, rightkey, function() lain.util.tag_view_nonempty(1) end,
                  {description = "view next nonempty", group = "tag"}),

        -- Select tag in grid
        awful.key({ modkey                    }, leftkey, function() context.select_tag_in_grid("l") end,
                  {description = "view previous", group = "tag"}),
        awful.key({ modkey                    }, rightkey, function() context.select_tag_in_grid("r") end,
                  {description = "view next", group = "tag"}),
        awful.key({ modkey, ctrlkey           }, upkey, function() context.select_tag_in_grid("u") end,
                  {description = "view above", group = "tag"}),
        awful.key({ modkey, ctrlkey           }, downkey, function() context.select_tag_in_grid("d") end,
                  {description = "view below", group = "tag"}),

        -- Move client to tag in grid
        awful.key({ modkey, ctrlkey, shiftkey }, leftkey, function() context.move_client_in_grid("l") end,
                  {description = "move to previous tag", group = "client"}),
        awful.key({ modkey, ctrlkey, shiftkey }, rightkey, function() context.move_client_in_grid("r") end,
                  {description = "move to next tag", group = "client"}),
        awful.key({ modkey, ctrlkey, shiftkey }, upkey, function() context.move_client_in_grid("u") end,
                  {description = "move to tag above", group = "client"}),
        awful.key({ modkey, ctrlkey, shiftkey }, downkey, function() context.move_client_in_grid("d") end,
                  {description = "move to tag below", group = "client"}),

        -- Client manipulation
        awful.key({ modkey                    }, upkey, function() awful.client.focus.byidx(-1) end,
                  {description = "focus previous client by index", group = "client"}),
        awful.key({ modkey                    }, downkey, function() awful.client.focus.byidx(1) end,
                  {description = "focus next client by index", group = "client"}),
        awful.key({ modkey, shiftkey          }, upkey, function() awful.client.swap.byidx(-1) end,
                  {description = "swap with previous client by index", group = "client"}),
        awful.key({ modkey, shiftkey          }, downkey, function() awful.client.swap.byidx(1) end,
                  {description = "swap with next client by index", group = "client"}),
        awful.key({ modkey                    }, "u", awful.client.urgent.jumpto,
                  {description = "jump to urgent client", group = "client"}),

        awful.key({ modkey,                   }, "Tab", function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
                  {description = "go back", group = "client"}),

        awful.key({ modkey, ctrlkey           }, "n", function()
            local c = awful.client.restore()
            if c then
                client.focus = c
                c:raise()
            end
        end,
                  {description = "restore minimized", group = "client"}),

        -- Layout manipulation
        awful.key({ modkey, shiftkey          }, rightkey, function() awful.tag.incmwfact(0.01) end,
                  {description = "increase master width factor", group = "layout"}),
        awful.key({ modkey, shiftkey          }, leftkey, function() awful.tag.incmwfact(-0.01) end,
                  {description = "decrease master width factor", group = "layout"}),
        awful.key({ modkey, altkey            }, rightkey, function() awful.tag.incnmaster(1, nil, true) end,
                  {description = "increase the number of master clients", group = "layout"}),
        awful.key({ modkey, altkey            }, leftkey, function() awful.tag.incnmaster(-1, nil, true) end,
                  {description = "decrease the number of master clients", group = "layout"}),
        awful.key({ modkey, altkey            }, upkey, function() awful.tag.incncol(1, nil, true) end,
                  {description = "increase the number of slave columns", group = "layout"}),
        awful.key({ modkey, altkey            }, downkey, function() awful.tag.incncol(-1, nil, true) end,
                  {description = "decrease the number of slave columns", group = "layout"}),
        awful.key({ modkey,                   }, "space", function() awful.layout.inc(1) end,
                  {description = "select next", group = "layout"}),
        awful.key({ modkey, shiftkey          }, "space", function() awful.layout.inc(-1) end,
                  {description = "select previous", group = "layout"}),

        -- Show/Hide Wibox
        awful.key({ modkey, ctrlkey           }, "b", function()
            for s in screen do
                s._wibox.visible = not s._wibox.visible
                if s._bottomwibox then
                    s._bottomwibox.visible = not s._bottomwibox.visible
                end
            end
        end),

        -- On the fly useless gaps change
        awful.key({ modkey, altkey, shiftkey  }, downkey, function() lain.util.useless_gaps_resize(beautiful.useless_gap/2) end,
                  {description = "increase useless gap", group = "layout"}),
        awful.key({ modkey, altkey, shiftkey  }, upkey, function() lain.util.useless_gaps_resize(-beautiful.useless_gap/2) end,
                  {description = "decrease useless gap", group = "layout"}),
        awful.key({ modkey, altkey, shiftkey, ctrlkey }, downkey, function() lain.util.useless_gaps_resize(1) end),
        awful.key({ modkey, altkey, shiftkey, ctrlkey }, upkey, function() lain.util.useless_gaps_resize(-1) end),

        -- ALSA volume control
        awful.key({                           }, "XF86AudioRaiseVolume", function()
            awful.spawn.easy_async(string.format("amixer -q set %s 1%%+", beautiful.volume.channel),
            function(stdout, stderr, reason, exit_code) --luacheck: no unused args
                beautiful.volume.manual = true
                beautiful.volume.update()
            end)
        end),
        awful.key({                           }, "XF86AudioLowerVolume", function()
            awful.spawn.easy_async(string.format("amixer -q set %s 1%%-", beautiful.volume.channel),
            function(stdout, stderr, reason, exit_code) --luacheck: no unused args
                beautiful.volume.manual = true
                beautiful.volume.update()
            end)
        end),
        awful.key({                           }, "XF86AudioMute", function()
            awful.spawn.easy_async(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel),
            function(stdout, stderr, reason, exit_code) --luacheck: no unused args
                beautiful.volume.manual = true
                beautiful.volume.update()
            end)
        end),
        awful.key({ ctrlkey                   }, "XF86AudioRaiseVolume", function()
            awful.spawn.easy_async(string.format("amixer -q set %s 100%%", beautiful.volume.channel),
            function(stdout, stderr, reason, exit_code) --luacheck: no unused args
                beautiful.volume.manual = true
                beautiful.volume.update()
            end)
        end),
        awful.key({ ctrlkey                   }, "XF86AudioLowerVolume", function()
            awful.spawn.easy_async(string.format("amixer -q set %s 0%%", beautiful.volume.channel),
            function(stdout, stderr, reason, exit_code) --luacheck: no unused args
                beautiful.volume.manual = true
                beautiful.volume.update()
            end)
        end),
        awful.key({ ctrlkey                   }, "XF86AudioMute", function()
            awful.spawn.easy_async(string.format("amixer -q set %s mute", beautiful.volume.togglechannel or beautiful.volume.channel),
            function(stdout, stderr, reason, exit_code) --luacheck: no unused args
                beautiful.volume.manual = true
                beautiful.volume.update()
            end)
        end),

        -- Backlight / Brightness
        awful.key({                           }, "XF86MonBrightnessUp", function()
            awful.spawn("light -A 2")
        end),
        awful.key({                           }, "XF86MonBrightnessDown", function()
            awful.spawn.easy_async_with_shell("light -G",
            function(stdout, stderr, reason, exit_code) --luacheck: no unused args
                if tonumber(stdout) > 2 then
                    awful.spawn("light -U 2")
                end
            end)
        end),
        awful.key({ ctrlkey                   }, "XF86MonBrightnessUp", function()
            awful.spawn("light -S 100")
        end),
        awful.key({ ctrlkey                   }, "XF86MonBrightnessDown", function()
            awful.spawn("light -S 1")
        end),

        -- -- Backlight / Brightness (using xbacklight)
        -- awful.key({   }, "XF86MonBrightnessUp",
        --     function()
        --         awful.spawn("xbacklight -inc 2 -time 1 -steps 1")
        --     end),
        -- awful.key({   }, "XF86MonBrightnessDown",
        --     function()
        --         awful.spawn.easy_async_with_shell("xbacklight -get | sed 's/\\..*//'",
        --         function(stdout, stderr, reason, exit_code)
        --             if tonumber(stdout) > 2 then
        --                 awful.spawn("xbacklight -dec 2 -time 1 -steps 1")
        --             end
        --         end)
        --     end),
        -- awful.key({ ctrlkey }, "XF86MonBrightnessUp",
        --     function()
        --         awful.spawn("xbacklight -set 100 -time 1 -steps 1")
        --     end),
        -- awful.key({ ctrlkey }, "XF86MonBrightnessDown",
        --     function()
        --         awful.spawn("xbacklight -set 1 -time 1 -steps 1")
        --     end),

        -- MPD control
        awful.key({                           }, "XF86AudioPlay", function()
            awful.spawn.with_shell("mpc toggle")
            beautiful.mpd.update()
        end),
        awful.key({ ctrlkey                   }, "XF86AudioPlay", function()
            awful.spawn.with_shell("mpc stop")
            beautiful.mpd.update()
        end),
        awful.key({                           }, "XF86AudioPrev", function()
            awful.spawn.with_shell("mpc prev")
            beautiful.mpd.update()
        end),
        awful.key({                           }, "XF86AudioNext", function()
            awful.spawn.with_shell("mpc next")
            beautiful.mpd.update()
        end),
        awful.key({ altkey                    }, "0", function()
            local common = { text = "MPD widget ", position = "top_middle", timeout = 2 }
            if beautiful.mpd.timer.started then
                beautiful.mpd.timer:stop()
                common.text = common.text .. lain.util.markup.bold("OFF")
            else
                beautiful.mpd.timer:start()
                common.text = common.text .. lain.util.markup.bold("ON")
            end
            naughty.notify(common)
        end)
    )

    -- Bind all key numbers to tags.
    -- Be careful: we use keycodes to make it works on any keyboard layout.
    -- This should map on the top row of your keyboard, usually 1 to 9.
    for i = 1, 10 do
        context.keys.global = awful.util.table.join(context.keys.global,
            -- View tag only.
            awful.key({ modkey }, "#" .. i + 9, function()
                local _screen = awful.screen.focused()
                local _tag = _screen.tags[i]
                if _tag then
                    _tag:view_only()
                end
            end,
            {description = "view tag #"..i, group = "tag-direct"}),
            -- Toggle tag display.
            awful.key({ modkey, ctrlkey }, "#" .. i + 9, function()
                local _screen = awful.screen.focused()
                local _tag = _screen.tags[i]
                if _tag then
                    awful.tag.viewtoggle(_tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag-direct"}),
            -- Move client to tag.
            awful.key({ modkey, shiftkey }, "#" .. i + 9, function()
                if client.focus then
                    local _tag = client.focus.screen.tags[i]
                    if _tag then
                        client.focus:move_to_tag(_tag)
                    end
                end
            end,
            {description = "move focused client to tag #"..i, group = "tag-direct"}),
            -- Toggle tag on focused client.
            awful.key({ modkey, altkey }, "#" .. i + 9, function()
                if client.focus then
                    local _tag = client.focus.screen.tags[i]
                    if _tag then
                        client.focus:toggle_tag(_tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag-direct"})
        )
    end

    -- Set keys
    root.keys(context.keys.global)

end

return config
