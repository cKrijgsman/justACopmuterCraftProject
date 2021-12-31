mon = peripheral.find("monitor")

if not mon then
    error("Please attatch a monitor")
end

mon.setTextScale(1)
mon.setTextColor(colors.white)
mon.setBackgroundColor(colors.black)
button = {}
charts = {}

function clearAll()
    button = {}
    charts = {}
    mon.clear()
end

function addButton(name, text, func, xmin, xmax, ymin, ymax, color, activeColor, textColor)
    color = color or colors.red
    activeColor = activeColor or colors.lime
    textColor = textColor or colors.white
    button[name] = {}
    button[name]["text"] = text
    button[name]["func"] = func
    button[name]["active"] = false
    button[name]["xmin"] = xmin
    button[name]["ymin"] = ymin
    button[name]["xmax"] = xmax
    button[name]["ymax"] = ymax
    button[name]["color"] = color
    button[name]["activeColor"] = activeColor
    button[name]["textColor"] = textColor
end

function addChart(name, func, xmin, xmax, ymin, ymax, value, color, offColor, label)
    charts[name] = {}
    charts[name]["func"] = func
    charts[name]["xmin"] = xmin
    charts[name]["xmax"] = xmax
    charts[name]["ymin"] = ymin
    charts[name]["ymax"] = ymax
    charts[name]["value"] = value
    charts[name]["color"] = color
    charts[name]["offColor"] = offColor
    charts[name]["label"] = label
    -- where the values are percentages
end

function updateChart(name, value, color)
    charts[name]["value"] = value
    charts[name]["color"] = color
    screenChart()
end

function updateButton(name, text, color)
    color = color or button[name]["color"]
    button[name]["text"] = text
    button[name]["color"] = color
    screenButton()
end

function screenButton()
    local currcolor
    for name, data in pairs(button) do
        local active = data["active"]
        if active == true then
            currcolor = data["activeColor"]
        else
            currcolor = data["color"]
        end
        fillButton(data["text"], currcolor, data)
    end
end

function screenChart()
    for name, data in pairs(charts) do
        fillChart(name, data)
    end
end

function fillButton(text, color, bData)
    mon.setBackgroundColor(color)
    mon.setTextColor(bData["textColor"])
    local yspot = math.floor((bData["ymin"] + bData["ymax"]) / 2)
    local xspot = math.floor((bData["xmax"] - bData["xmin"] - string.len(text)) / 2) + 1
    for j = bData["ymin"], bData["ymax"] do
        mon.setCursorPos(bData["xmin"], j)
        if j == yspot then
            for k = 0, bData["xmax"] - bData["xmin"] - string.len(text) + 1 do
                if k == xspot then
                    mon.write(text)
                else
                    mon.write(" ")
                end
            end
        else
            for i = bData["xmin"], bData["xmax"] do
                mon.write(" ")
            end
        end
    end
    mon.setTextColor(colors.white)
    mon.setBackgroundColor(colors.black)
end

function fillChart(name, cData)
    local w = cData["xmax"] - cData["xmin"]
    local percentPerStep = math.floor(100 / w)
    local barWidth = math.floor(cData["value"] / percentPerStep)

    local xspot = math.floor((cData["xmax"] - cData["xmin"]) / 2) - 1
    local yspot = math.floor((cData["ymin"] + cData["ymax"]) / 2)
    local text = cData["value"] .. "%"

    if cData["label"] ~= nil then
        labelX = math.floor((cData["xmax"] - cData["xmin"] - string.len(cData["label"])) / 2)
        label(cData["xmin"] + labelX, cData["ymax"] + 1, cData["label"])
    end

    local emptyColor = 0
    if cData["color"] == colors.gray then
        emptyColor = colors.lightGray
    else
        emptyColor = colors.gray
    end

    if cData["color"] == colors.white then
        mon.setTextColor(colors.black)
    end

    for j = cData["ymin"], cData["ymax"] do
        mon.setCursorPos(cData["xmin"], j)
        if j == yspot then
            for k = 0, cData["xmax"] - cData["xmin"] - string.len(text) + 1 do
                if barWidth + cData["xmax"] >= cData["xmax"] + (cData["xmax"] - k) then
                    mon.setBackgroundColor(cData["color"])
                else
                    mon.setBackgroundColor(emptyColor)
                end
                if k == xspot then
                    mon.write(text)
                else
                    mon.write(" ")
                end
            end
        else
            for i = cData["xmin"], cData["xmax"] do
                if barWidth + cData["xmax"] >= cData["xmax"] + (cData["xmax"] - i) then
                    mon.setBackgroundColor(cData["color"])
                else
                    mon.setBackgroundColor(emptyColor)
                end
                mon.write(" ")
            end
        end
    end
    mon.setBackgroundColor(colors.black)
    mon.setTextColor(colors.white)
end

function toggleButton(name)
    button[name]["active"] = not button[name]["active"]
    screenButton()
end

function flash(name)
    toggleButton(name)
    sleep(0.15)
    toggleButton(name)
end

function checkxy(x, y)
    for name, data in pairs(button) do
        if y >= data["ymin"] and y <= data["ymax"] then
            if x >= data["xmin"] and x <= data["xmax"] then
                data["func"]()
                flash(name)
                return true
            end
        end
    end
    for name, data in pairs(charts) do
        if y >= data["ymin"] and y <= data["ymax"] then
            if x >= data["xmin"] and x <= data["xmax"] then
                data["func"](name,x,y)
                flash(name)
                return true
            end
        end
    end
    return false
end

function heading(text)
    w, h = mon.getSize()
    mon.setCursorPos((w - string.len(text)) / 2 + 1, 1)
    mon.write(text)
end

function label(x, y, text, sizeMultiplier, color)
    color = color or colors.white
    sizeMultiplier = sizeMultiplier or 0
    mon.setTextColor(color)
    mon.setCursorPos(x, y)
    if sizeMultiplier > 0 then
        bigfont.writeOn(mon, sizeMultiplier, text, mon.getCursorPos())
    else
        mon.write(text)
    end
    
    mon.setTextColor(colors.white)
end