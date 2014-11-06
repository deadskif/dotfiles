-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")


require("os")

os.setlocale("LC_CTYPE=ru_RU.UTF-8;LC_NUMERIC=ru_RU.UTF-8;LC_TIME=ru_RU.UTF-8;LC_COLLATE=ru_RU.UTF-8;LC_MONETARY=ru_RU.UTF-8;LC_MESSAGES=ru_RU.UTF-8;LC_PAPER=ru_RU.UTF-8;LC_NAME=ru_RU.UTF-8;LC_ADDRESS=ru_RU.UTF-8;LC_TELEPHONE=ru_RU.UTF-8;LC_MEASUREMENT=ru_RU.UTF-8;LC_IDENTIFICATION=ru_RU.UTF-8")
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

function slog (msg)
    awful.util.spawn("/usr/bin/logger '"..msg.."'")
end

slog("logging starting")
-- local string = string
-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
--beautiful.init("~/.config/awesome/theme.lua")
slog("beautiful inited")
-- This is used later as the default terminal and editor to run.
terminal = "urxvt +sb"  -- -fg green"
xlock = "slock"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{   
    awful.layout.suit.floating,		-- 1
    awful.layout.suit.tile,		-- 2
    --awful.layout.suit.tile.left,	-- 3
    --awful.layout.suit.tile.bottom,	-- 4
    --awful.layout.suit.tile.top,		-- 5
    --awful.layout.suit.fair,		-- 6
    --awful.layout.suit.fair.horizontal,	-- 7
    --awful.layout.suit.spiral,		-- 8
    --awful.layout.suit.spiral.dwindle,	-- 9
    awful.layout.suit.max,		-- 3    -- 10
    --awful.layout.suit.max.fullscreen,	-- 11
    --awful.layout.suit.magnifier		-- 12
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
--#tags = {}
--#for s = 1, screen.count() do
--#    -- Each screen has its own tag table.
--#    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
--#end
tags = {	
	names  = { 	"term",		"www",		"im",		"net",		5,
			6,		7,		"offs",		"adm" },
	layout = {	layouts[2],	layouts[3],	layouts[2],	layouts[3],	layouts[2],
			layouts[2],	layouts[2],	layouts[2],	layouts[2]
}}
for s = 1, screen.count() do
	-- Each screen has its own tag table.
	tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

myinetmenu = {
	{ "Firefox", "firefox" },
	{ "Opera", "opera" },
	{ "Thunderbird", "thunderbird" },
	{ "EiskaltDC++-Gtk", "eiskaltdcpp-gtk" },
	{ "qBittorrent", "qbittorrent" },
	{ "QutIM", "qutim" }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
				    { "inet", myinetmenu },
				    { "ext env", "/home/skif/.bin/xinit_env.sh ext" },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" }, "%d %b %R")

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

mywidgetupdatetime = 3
slog("have set a lot of lists")
mybatwidget = widget({ type = "textbox" })

vicious.register(mybatwidget, vicious.widgets.bat,
	function(widget, args)
-- 		local col=""
-- 		if args[2]>=50 then
-- 			--return "<span color=\"#777777\">Battery: </span>".."<span color=\"#006800\">"..args[2].."</span>".."%"
-- 			col="#006800"
-- 		elseif args[2]>=25 and args[2]<50 then
-- 			--return "<span color=\"#777777\">Battery: </span>".."<span color=\"#686800\">"..args[2].."</span>".."%"
-- 			col="#686800"
-- 		elseif args[2]>=10 and args[2]<25 then
-- 			--return "<span color=\"#777777\">Battery: </span>".."<span color=\"#680000\">"..args[2].."</span>".."%"
-- 			col="#680000"
-- 		elseif args[2]<10 and args[1]=="-" then
-- 			naughty.notify({titte="Warning", text="Battery low!",timeout=3})
-- 			--return "<span color=\"#777777\">Battery: </span>".."<span color=\"#FF0000\">"..args[2].."</span>".."%"
-- 			col="#FF0000"
-- 		elseif args[2]<10 then
-- 			--return "<span color=\"#777777\">Battery: </span>".."<span color=\"#FF0000\">"..args[2].."</span>".."%"
-- 			col="#FF0000"
-- 		end
		local col = ""
		if args[1] == "-" then
			col = "#FF3030"
		else
			col = "#30FF30"
		end
--		if args[2] < 4 then
--			inotify("I will go sleep soon");
--		elseif args[2] < 3 then
--			inotify("I will go sleep now");
--			--awful.util.spawn("
--		end
		return "[<span color=\""..col.."\">"..args[2] .. "%" .. args[1].."</span>]"
 		end, mywidgetupdatetime, 'BAT0')
--myprogressbar =  widget({ type = "progressbar", align = "right" })
--myprogressbar.width = 28
--myprogressbar.height = 0.90
--myprogressbar.gap = 0
--myprogressbar.border_padding = 0
--myprogressbar.border_width = 1
--myprogressbar.ticks_count = 0
--myprogressbar.vertical = true
--myprogressbar:bar_properties_set("root", 
--{ 
--	["bg"] = beautiful.myprogressbar_root_bg,
--	["fg"] = beautiful.myprogressbar_root_fg,
--	["fg_center"] = beautiful.myprogressbar_root_fg_center,
--	["fg_end"] = beautiful.myprogressbar_root_fg_end,
--	["fg_off"] = beautiful.myprogressbar_root_fg_off,
--	["border_color"] = beautiful.myprogressbar_root_border_color,
--	["min_value"] = "0",
--	["max_value"] = "1600",
--	["reverse"] = false
--})
--vicious.register(myprogressbar, vicious.widgets.mem, "$2", mywidgetupdatetime)
mymemwidget = widget({type = "textbox"})
vicious.register(mymemwidget, vicious.widgets.mem, "$2Mb", mywidgetupdatetime)
--
mycpuf0widget = widget({type = "textbox"})
vicious.register(mycpuf0widget, vicious.widgets.cpufreq, "$2$5", mywidgetupdatetime, "cpu0")
mycpuf1widget = widget({type = "textbox"})
vicious.register(mycpuf1widget, vicious.widgets.cpufreq, "$2$5", mywidgetupdatetime, "cpu1")
mycpuf2widget = widget({type = "textbox"})
vicious.register(mycpuf2widget, vicious.widgets.cpufreq, "$2$5", mywidgetupdatetime, "cpu2")
mycpuf3widget = widget({type = "textbox"})
vicious.register(mycpuf3widget, vicious.widgets.cpufreq, "$2$5", mywidgetupdatetime, "cpu3")
--
mythermwidget = widget({type = "textbox" })
vicious.register(mythermwidget, --vicious.widgets.thermal, 
	--function(format, warg) return 
	function(format, warg)
		local thermals = {}
		local t_inp = "/sys/class/hwmon/hwmon0/temp1_input"
		--local bpath, inputs = "/sys/class/hwmon/hwmon0", { "temp1_input", "temp3_input", "temp7_input" }
		--thermals = inputs
		--for i,k in ipairs(inputs) do
		local f = io.open(t_inp)
		if f then
			local s = f:read("*all")
			f:close()
			table.insert(thermals, s / 1000)
		else
			table.insert(thermals, "-")
		end
		--end
		return thermals
	end,
	"$1°", mywidgetupdatetime)
mynetwidget = widget({ type = "textbox" })
vicious.register(mynetwidget,
	function(format, warg)
		local bpath = "/sys/class/net/"
		local states = {}
		for i,k in ipairs(warg) do
			local f = io.open(bpath .. k .. "/operstate")
			if f then
				local s = f:read("*all")
				f:close()
				states[k] = s or "fail"
			else
				states[k] = "fail"
		--		table.insert(states, "-")
			end
			--states[k] = i
			--table.insert(states, k)
		end
		return states
	end, function(widget, arg)
		local s = ""
		for k,v in pairs(arg) do
			local n = ""
			local tt = { eth0 = "E", wlp3s0 = "W", lo = "0", ppp0 = "P", usb0 = "U" }
			k = tt[k] or "?"
			if v == "up\n" then
				n = "<span color=\"#30FF30\">" .. k .. "</span>"
			elseif v == "down\n" then
			--else
				n = "<span color=\"#FF3030\">" .. k .. "</span>"
			--else
			--	n = "?"
			end
			s = s .. n 
		end
		return "[" .. s .. "]"
	end, mywidgetupdatetime, { "wlan0", "eth0", "usb0" });
----mywifiwidget = widget({type = "textbox" })
----vicious.register(mywifiwidget, vicious.widgets.wifi,
--	--function(widget, args)
--	--	return args[1];
--	--end, 
----	"WIFI:${link}${rate}${linp}${sign}|", mywidgetupdatetime, "wlan0")

slog("widgets done")
for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        s == 1 and mysystray or nil,
	mybatwidget,
	mythermwidget,
	mynetwidget,
	mymemwidget,
	mycpuf0widget,
	mycpuf1widget,
	mycpuf2widget,
	mycpuf3widget,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

slog("widgets added")
-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}
slog("mouse bindings done")
-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey, "Control", "Shift" }, "l",     function () awful.util.spawn(xlock)	end),
    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Skif's keys
    --awful.key( {}, "XF86MonBrightnessUp", function() awful.util.spawn("/home/skif/bin/lcd.sh inc") end),
    --awful.key( {}, "XF86MonBrightnessDown", function() awful.util.spawn("/home/skif/bin/lcd.sh dec") end),
    --awful.key( {}, "XF86Launch1", function() awful.util.spawn("/home/skif/bin/lcd.sh chg") end),
    --awful.key( {}, "XF86AudioMute", function() awful.util.spawn("amixer sset Master toggle") end),
    --awful.key( {}, "XF86AudioRaiseVolume", function() awful.util.spawn("amixer sset PCM 20+") end),
    --awful.key( {}, "XF86AudioLowerVolume", function() awful.util.spawn("amixer sset PCM 20-") end),
    awful.key({ modkey, "Control" }, "b", function()
      local c = client.focus
      local class
      local instance
      local role
      local type

      if not c then
        return
      end

      class = c.class
      instance = c.instance
      role = c.role
      name = c.name
      type = c.type

      if not class then class = "" end
      if not instance then instance = "" end
      if not role then role = "" end
      if not name then name = "" end
      if not type then type = "" end

      local t = "Class: " .. class .. "\n" ..
      "Instance: " .. instance .. "\n" ..
      "Role: " .. role .. "\n" ..
      "Name: " .. name .. "\n" ..
--      "C: " .. raw .. "\n" ..
      "Type: " .. type
      naughty.notify({
        text = t,
        timeout = 60,
        hover_timeout = 0.5
      })
    end)



)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = true               end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Opera" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Thunderbird" },
      properties = { tag = tags[1][4] } },
    { rule = { instance = "qbittorrent" },
      properties = { tag = tags[1][4] } },
    { rule = { instance = "eiskaltdcpp-gtk" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "Qutim" },
      properties = { tag = tags[1][3] } },
    { rule = { class = "Claws-mail" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "LibreOffice" },
      properties = { tag = tags[1][8] } },
    { rule = { class = "Xpdf" },
      properties = { tag = tags[1][8] } },
    { rule = { class = "Epdfview" },
      properties = { tag = tags[1][8] } },
    { rule = { class = "Wpa_gui" },
      properties = { floating = true } },
    { rule = { class = "Mytetra" },
      properties = { tag = tags[1][9], maximized_horizontal = true, maximized_vertical = true } },


}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
slog("now bf")
--awful.util.spawn("/home/skif/bin/bg.sh")
slog("bg done")
--awful.util.spawn("/bin/sleep 3")
-- }}}
