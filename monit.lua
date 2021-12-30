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
local modem = peripheral.wrap("bottom")
monit.setTextScale(1)
monit.clear()

modem.open(12864)

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
        print(i .. ":", v)
    end
end

local function setControllRod(power)

end

local function none()

end

local function getData()
    local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("")

    if event == "modem_message" then
        updateData(message)
    end

end

local function handleTouch()
    local event, side, x, y
    event, side, x, y = os.pullEvent("")

    if event == "monitor_touch" then
        gui.checkxy(x, y)
    end
end

local function eventLoop()
    handleTouch()
    getData()
end

-- Set the heading
gui.label(10, 4, "Reactor Control Panel", 1)

-- Set data lables
gui.label(4, 10, "Power Generation:", 0, colors.lightGray)
gui.label(4, 12, "Power Draw:", 0, colors.lightGray)
gui.label(4, 14, "Fuel Consumption:", 0, colors.lightGray)
gui.label(4, 16, "Fuel Percentage:", 0, colors.lightGray)
gui.label(4, 18, "Casting Temperature:", 0, colors.lightGray)

-- place buttons
gui.addButton("status", "OFF", toggelOnState, 4, 12, 22, 24)
gui.addButton("max", "MAX", maxPower, 14, 22, 22, 24, colors.orange, colors.yellow)
gui.addButton("eff", "EFF", efficiency, 24, 32, 22, 24, colors.blue, colors.lightBlue)

-- place data boxes
gui.addButton("power_gen", "0 kRF/t", none, 22, 29, 10, 11, colors.black, colors.black, colors.red)
gui.addButton("power_draw", "69.0 kRF/t", none, 16, 23, 12, 13, colors.black, colors.black, colors.yellow)
gui.addButton("fuel_con", "0 mB/t", none, 22, 29, 14, 15, colors.black, colors.black, colors.green)
gui.addButton("fuel_temp", "20 °C", none, 22, 29, 16, 17, colors.black, colors.black, colors.green)
gui.addButton("cast_temp", "20 °C", none, 25, 32, 18, 19, colors.black, colors.black, colors.green)

while true do
    gui.screenButton()
    eventLoop()
end
