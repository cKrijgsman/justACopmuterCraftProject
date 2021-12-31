-- 164 x 52
-- On/Off button
-- Controll rod slider
-- 0-100
-- Preset buttons
-- (Power/Efficent)
-- current generation rf/t
-- current temp c
-- current power draw
-- milibuckets per tick fuel consumtion
-- chanel 12864
os.loadAPI("bigfont")
os.loadAPI("gui")
local monit = peripheral.wrap("top")
-- local modem = peripheral.wrap("bottom")
monit.setTextScale(1)
monit.clear()

local timerCode

-- modem.open(12864)

-- Functions

local function toggelOnState()
    if gui.button["status"]["text"] == "ON" then
        gui.updateButton("status", "OFF", colors.red)
    else
        gui.updateButton("status", "ON", colors.lime)
    end
end

local function maxPower()
    if gui.button["max"]["color"] == colors.orange then
        gui.button["max"]["color"] = colors.yellow
    else
        gui.button["max"]["color"] = colors.orange
    end
end

local function efficiency()
    if gui.button["max"]["color"] == colors.blue then
        gui.button["max"]["color"] = colors.lightBlue
    else
        gui.button["max"]["color"] = colors.blue
    end
end

local function updateData(data)
    for k, v in pairs(data) do
        print(k .. ":", v)
    end
end

local function setControllRod(name, x, y)
    print("clicked on " .. name .. "at " .. x .. "," .. y)

    local value = x - gui.charts[name]["xmin"]
    local multiplier = (gui.charts[name]["xmax"] - gui.charts[name]["xmin"]) / 100
    value = x * multiplier

    gui.updateChart(name, value, gui.charts[name]["color"])
end

local function none()
    print("NONE!")
end

local function eventLoop()
    local event, side, x, y, message, senderDistance
    event, side, x, y, message, senderDistance = os.pullEvent("")

    print(event)

    if event == "monitor_touch" then
        gui.checkxy(x, y)
    end

    -- if event == "modem_message" then
    --    updateData(message)
    -- end

    os.sleep(0.1)
end

-- Set the heading
gui.label(10, 4, "Reactor Control Panel", 1)

-- Set data lables
gui.label(4, 10, "Power Generation:", 0, colors.lightGray)
gui.label(4, 12, "Power Change:", 0, colors.lightGray)
gui.label(4, 14, "Fuel Consumption:", 0, colors.lightGray)
gui.label(4, 16, "Fuel Percentage:", 0, colors.lightGray)
gui.label(4, 18, "Casting Temperature:", 0, colors.lightGray)

-- place buttons
gui.addButton("status", "OFF", toggelOnState, 4, 12, 22, 24)
gui.addButton("max", "MAX", maxPower, 14, 22, 22, 24, colors.orange, colors.yellow)
gui.addButton("eff", "EFF", efficiency, 24, 32, 22, 24, colors.blue, colors.lightBlue)

-- place data boxes
gui.addButton("power_gen", "0 kRF/t", none, 22, 29, 10, 11, colors.black, colors.black, colors.red)
gui.addButton("power_draw", "69.0 kRF/t", none, 16, 28, 12, 13, colors.black, colors.black, colors.yellow)
gui.addButton("fuel_con", "0 mB/t", none, 22, 29, 14, 15, colors.black, colors.black, colors.green)
gui.addButton("fuel_temp", "20 °C", none, 22, 29, 16, 17, colors.black, colors.black, colors.green)
gui.addButton("cast_temp", "20 °C", none, 25, 32, 18, 19, colors.black, colors.black, colors.green)

-- Slider
gui.addChart("slider", setControllRod, 36, 78, 22, 24, 50, colors.lime, colors.white, "Control Rod Insertion")

gui.screenButton()
gui.screenChart()

while true do
    timerCode = os.startTimer(1)
    local event, side, x, y, message
    repeat
        event, side, x, y = os.pullEvent()
        print(event)
        if event == "timer" then
            print(timerCode .. ":" .. side)
            if timerCode ~= side then
                print("Wrong Code")
            else
                print("Right Code")
            end
        end
    until event ~= "timer" or timerCode == side
    if event == "monitor_touch" then
        print(x .. ":" .. y)
        button.checkxy(x, y)
    end
    if event == "modem_message" then
        updateData(message)
    end
end
