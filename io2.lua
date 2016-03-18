local module = {}



    local pin = 1
    local pin2 = 2
    gpio.mode(pin, gpio.INPUT)
    gpio.mode(pin2,gpio.INPUT)
    local opin1 = 0
    local  opin2 = 4
    
    gpio.mode(opin2,gpio.OUTPUT)
    gpio.mode(opin1,gpio.OUTPUT)
    gpio.write(opin1,gpio.LOW)
    gpio.write(opin2,gpio.LOW)
  
    button_pressed = false
    button_press_started = 0
    button2_pressed = false
    button2_press_started = 0
module.delay =10000
module.debounce =60000
function module.longrun1()
    if (gpio.read(opin2)==gpio.LOW)then
    gpio.write(opin1,gpio.HIGH)
       tmr.alarm(0,module.delay,0,function()
            gpio.write(opin1,gpio.LOW)
             
       end)
    end
end

function module.longrun2()
    if (gpio.read(opin1)==gpio.LOW) then
    gpio.write(opin2,gpio.HIGH)
       tmr.alarm(2,module.delay,0,function()
            gpio.write(opin2,gpio.LOW)
            
       end)
    end
end
function module.stoplongrun()
    gpio.write(opin1,gpio.LOW)
    gpio.write(opin2,gpio.LOW)
end

function module.startio()
tmr.alarm(1, 50, 1, function() 
        if (gpio.read(opin2)==gpio.LOW) then result = gpio.read(pin) end
        if (gpio.read(opin1)==gpio.LOW) then result2 = gpio.read(pin2) end
 
    if result == 1 then
        
        gpio.write(opin1,1)
        if not button_pressed then
            button_press_started = tmr.now()
        end
        button_pressed = true
        gpio.write(pin, 1)
        gpio.mode(pin, gpio.INPUT)
    else
        if button_pressed then
            length = tmr.now() - button_press_started
            
            if length > 600000 then
                print("Long press")
                module.longrun1()
            else
                print("Short press")
                
                gpio.write(opin1,0)
                
            end
            
            button_pressed = false
        end
    end

     if result2 == 1 then
     
        gpio.write(opin2,1)
        if not button2_pressed then
            button2_press_started = tmr.now()
        end
        button2_pressed = true
        gpio.write(pin2, 1)
        gpio.mode(pin2, gpio.INPUT)
    else
        if button2_pressed then
            length2 = tmr.now() - button2_press_started
            
            if length2 > 600000 then
                print("Long press")
                module.longrun2()
            else
                print("Short press")
                gpio.write(opin2,0)
                
            end
            
            button2_pressed = false
        end
    end
end) 
end

return module