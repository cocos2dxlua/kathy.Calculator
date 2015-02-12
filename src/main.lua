cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")

require "cocos.init"
require "Btn"
require "Result"

function Main()
    local self = cc.Scene:create()
    local layer
    local allBtns = {}

    local spriteFirst
    local spriteOper
    local spriteSecond
    local spriteResult

    local firstNumStr = ""
    local secondNumStr = ""
    local operStr = ""

    local firstNum = 0
    local secondNum = 0

    local firstActive = true


    -- 重置计算器
    local function resetCal()
        layer:removeChild(spriteOper, true)
        layer:removeChild(spriteFirst, true)
        layer:removeChild(spriteSecond, true)
        layer:removeChild(spriteResult, true)
        firstNumStr = ""
        secondNumStr = ""
        operStr = ""
        firstNum = ""
        secondNum = ""
        firstActive = true
    end


    -- ui布局
    -- 计算器上所有的btn都添加到 allBtns map中
    local function addBtns()
        local btn

        for var=0,8 do
            btn = Btn(var+1)
            layer:addChild(btn)
            btn:setPosition(90+(var%3)*90, 180+math.floor(var/3)*90)
            table.insert(allBtns, 1, btn)
        end
        
        btn = Btn(0)
        btn:setPosition(90, 90)
        layer:addChild(btn)
        table.insert(allBtns, 1, btn)

        btn = Btn(".")
        btn:setPosition(90*2, 90)
        layer:addChild(btn)
        table.insert(allBtns, 1, btn)

        btn = Btn("+")
        btn:setPosition(90*3, 90)
        layer:addChild(btn)
        table.insert(allBtns, 1, btn)

        btn = Btn("-")
        btn:setPosition(90*4, 90*4)
        layer:addChild(btn)
        table.insert(allBtns, 1, btn)

        btn = Btn("*")
        btn:setPosition(90*4, 90*3)
        layer:addChild(btn)
        table.insert(allBtns, 1, btn)

        btn = Btn("÷")
        btn:setPosition(90*4, 90*2)
        layer:addChild(btn)
        table.insert(allBtns, 1, btn)

        btn = Btn("=")
        btn:setPosition(90*4, 90)
        layer:addChild(btn)
        table.insert(allBtns, 1, btn)

        btn = Btn("c")
        btn:setPosition(0, 0)
        layer:addChild(btn)
        table.insert(allBtns, 1, btn)
    end


    -- 处理计算结果
    local function showResult(num, inputType)

        -- [ 0-9 . ]
        if inputType == 0 or inputType == 1 then

            if firstActive then
                print("11111111")
                print(firstActive)
                -- remove
                layer:removeChild(spriteFirst, true)
                -- add
                firstNumStr = firstNumStr..tostring(num)
                spriteFirst = Result(firstNumStr)
                spriteFirst:setPosition(90*5, 90*4)
                layer:addChild(spriteFirst)
            else
                print("222222222")
                print(firstActive)
                -- remove
                layer:removeChild(spriteSecond, true)
                -- add
                secondNumStr = secondNumStr..tostring(num)
                spriteSecond = Result(secondNumStr)
                spriteSecond:setPosition(90*5, 90*2)
                layer:addChild(spriteSecond)
            end

        -- [ + - *  ÷ ]
        elseif inputType == 2 then
            firstActive = false
            firstNum = tonumber(firstNumStr)
            print("firstNum: "..firstNum)
            -- remove
            layer:removeChild(spriteOper, true)
            -- add
            spriteOper = Result(num)
            spriteOper:setPosition(90*5, 90*3)
            layer:addChild(spriteOper)
            operStr = num

        -- [ = ]    
        elseif inputType == 3 then
            secondNum = tonumber(secondNumStr)
            print("secondNum: "..secondNum)
            firstActive = true
            -- remove
            layer:removeChild(spriteResult, true)
            -- add
            local resultNum
            if operStr == "+" then
                resultNum = firstNum + secondNum
            elseif operStr == "-" then
                resultNum = firstNum - secondNum
            elseif operStr == "*" then
                resultNum = firstNum * secondNum
            elseif operStr == "÷" then
                resultNum = firstNum / secondNum
            end
            spriteResult = Result(resultNum)
            spriteResult:setPosition(90*5, 90*1)
            layer:addChild(spriteResult)

        -- [ c ]  重置
        elseif inputType == 4 then
            resetCal()
        end        
    end



    -- 触碰事件
    local function onTouch( type, x, y )
        -- inputType的定义如下：
        -- 0 : 0-9
        -- 1 : .
        -- 2 : +-*÷
        -- 3 : =
        -- 4 : c

        -- 每一次触碰都要遍历 allBtns 里所有btn（for in）
        -- 如果触碰的位置在其中的一个btn里，此次循环结束（break）

        -- 关键方法：
        -- 判断触摸点p是否在sprite的图像像素内
        -- cc.rectContainsPoint(sprite.getBoundingBox(),p);
        local inputType = 0
        local p = cc.p(x, y)
        for key,var in pairs(allBtns) do
            if cc.rectContainsPoint(var:getBoundingBox(), p) then
                if var.num == "." then
                    inputType = 1
                elseif var.num == "+" or var.num == "-" or var.num == "*" or var.num == "÷" then
                    inputType = 2
                elseif var.num == "=" then
                    inputType = 3
                elseif var.num == "c" then
                    inputType = 4
                end
                print(var.num)
                print(inputType)
                showResult(var.num, inputType)
                break
            end
        end  
    end



    local function init()
        -- 新建一个layer，添加到当前scene中
        layer = cc.Layer:create()
        self:addChild(layer)
        -- 设置layer的触摸响应为true
        layer:setTouchEnabled(true)
        -- 注册layer的触碰事件
        layer:registerScriptTouchHandler(onTouch)
        -- ui布局
        addBtns()
    end


    init()
    return self
end



local function __main()
    local director = cc.Director:getInstance()
    local glview = director:getOpenGLView()
    glview:setDesignResolutionSize(800, 480, cc.ResolutionPolicy.NO_BORDER)
    director:runWithScene(Main())
end


__main()




-- cc.FileUtils:getInstance():addSearchPath("src")
-- cc.FileUtils:getInstance():addSearchPath("res")

-- -- CC_USE_DEPRECATED_API = true
-- require "cocos.init"

-- -- cclog
-- cclog = function(...)
--     print(string.format(...))
-- end

-- -- for CCLuaEngine traceback
-- function __G__TRACKBACK__(msg)
--     cclog("----------------------------------------")
--     cclog("LUA ERROR: " .. tostring(msg) .. "\n")
--     cclog(debug.traceback())
--     cclog("----------------------------------------")
--     return msg
-- end

-- local function main()
--     collectgarbage("collect")
--     -- avoid memory leak
--     collectgarbage("setpause", 100)
--     collectgarbage("setstepmul", 5000)

--     -- initialize director
--     local director = cc.Director:getInstance()
--     local glview = director:getOpenGLView()
--     if nil == glview then
--         glview = cc.GLViewImpl:createWithRect("HelloLua", cc.rect(0,0,900,640))
--         director:setOpenGLView(glview)
--     end

--     glview:setDesignResolutionSize(480, 320, cc.ResolutionPolicy.NO_BORDER)

--     --turn on display FPS
--     director:setDisplayStats(true)

--     --set FPS. the default value is 1.0/60 if you don't call this
--     director:setAnimationInterval(1.0 / 60)

--     local schedulerID = 0
--     --support debug
--     local targetPlatform = cc.Application:getInstance():getTargetPlatform()
--     if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or
--        (cc.PLATFORM_OS_ANDROID == targetPlatform) or (cc.PLATFORM_OS_WINDOWS == targetPlatform) or
--        (cc.PLATFORM_OS_MAC == targetPlatform) then
--         cclog("result is ")
--         --require('debugger')()

--     end
--     require "hello2"
--     cclog("result is " .. myadd(1, 1))

--     ---------------

--     local visibleSize = cc.Director:getInstance():getVisibleSize()
--     local origin = cc.Director:getInstance():getVisibleOrigin()

--     -- add the moving dog
--     local function createDog()
--         local frameWidth = 105
--         local frameHeight = 95

--         -- create dog animate
--         local textureDog = cc.Director:getInstance():getTextureCache():addImage("dog.png")
--         local rect = cc.rect(0, 0, frameWidth, frameHeight)
--         local frame0 = cc.SpriteFrame:createWithTexture(textureDog, rect)
--         rect = cc.rect(frameWidth, 0, frameWidth, frameHeight)
--         local frame1 = cc.SpriteFrame:createWithTexture(textureDog, rect)

--         local spriteDog = cc.Sprite:createWithSpriteFrame(frame0)
--         spriteDog.isPaused = false
--         spriteDog:setPosition(origin.x, origin.y + visibleSize.height / 4 * 3)
-- --[[
--         local animFrames = CCArray:create()

--         animFrames:addObject(frame0)
--         animFrames:addObject(frame1)
-- ]]--

--         local animation = cc.Animation:createWithSpriteFrames({frame0,frame1}, 0.5)
--         local animate = cc.Animate:create(animation);
--         spriteDog:runAction(cc.RepeatForever:create(animate))

--         -- moving dog at every frame
--         local function tick()
--             if spriteDog.isPaused then return end
--             local x, y = spriteDog:getPosition()
--             if x > origin.x + visibleSize.width then
--                 x = origin.x
--             else
--                 x = x + 1
--             end

--             spriteDog:setPositionX(x)
--         end

--         schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false)

--         return spriteDog
--     end

--     -- create farm
--     local function createLayerFarm()
--         local layerFarm = cc.Layer:create()

--         -- add in farm background
--         local bg = cc.Sprite:create("farm.jpg")
--         bg:setPosition(origin.x + visibleSize.width / 2 + 80, origin.y + visibleSize.height / 2)
--         layerFarm:addChild(bg)

--         -- add land sprite
--         for i = 0, 3 do
--             for j = 0, 1 do
--                 local spriteLand = cc.Sprite:create("land.png")
--                 spriteLand:setPosition(200 + j * 180 - i % 2 * 90, 10 + i * 95 / 2)
--                 layerFarm:addChild(spriteLand)
--             end
--         end

--         -- add crop
--         local frameCrop = cc.SpriteFrame:create("crop.png", cc.rect(0, 0, 105, 95))
--         for i = 0, 3 do
--             for j = 0, 1 do
--                 local spriteCrop = cc.Sprite:createWithSpriteFrame(frameCrop);
--                 spriteCrop:setPosition(10 + 200 + j * 180 - i % 2 * 90, 30 + 10 + i * 95 / 2)
--                 layerFarm:addChild(spriteCrop)
--             end
--         end

--         -- add moving dog
--         local spriteDog = createDog()
--         layerFarm:addChild(spriteDog)

--         -- handing touch events
--         local touchBeginPoint = nil
--         local function onTouchBegan(touch, event)
--             local location = touch:getLocation()
--             cclog("onTouchBegan: %0.2f, %0.2f", location.x, location.y)
--             touchBeginPoint = {x = location.x, y = location.y}
--             spriteDog.isPaused = true
--             -- CCTOUCHBEGAN event must return true
--             return true
--         end

--         local function onTouchMoved(touch, event)
--             local location = touch:getLocation()
--             cclog("onTouchMoved: %0.2f, %0.2f", location.x, location.y)
--             if touchBeginPoint then
--                 local cx, cy = layerFarm:getPosition()
--                 layerFarm:setPosition(cx + location.x - touchBeginPoint.x,
--                                       cy + location.y - touchBeginPoint.y)
--                 touchBeginPoint = {x = location.x, y = location.y}
--             end
--         end

--         local function onTouchEnded(touch, event)
--             local location = touch:getLocation()
--             cclog("onTouchEnded: %0.2f, %0.2f", location.x, location.y)
--             touchBeginPoint = nil
--             spriteDog.isPaused = false
--         end

--         local listener = cc.EventListenerTouchOneByOne:create()
--         listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
--         listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
--         listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
--         local eventDispatcher = layerFarm:getEventDispatcher()
--         eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layerFarm)

--         local function onNodeEvent(event)
--            if "exit" == event then
--                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID)
--            end
--         end
--         layerFarm:registerScriptHandler(onNodeEvent)

--         return layerFarm
--     end


--     -- create menu
--     local function createLayerMenu()
--         local layerMenu = cc.Layer:create()

--         local menuPopup, menuTools, effectID

--         local function menuCallbackClosePopup()
--             -- stop test sound effect
--             cc.SimpleAudioEngine:getInstance():stopEffect(effectID)
--             menuPopup:setVisible(false)
--         end

--         local function menuCallbackOpenPopup()
--             -- loop test sound effect
--             local effectPath = cc.FileUtils:getInstance():fullPathForFilename("effect1.wav")
--             effectID = cc.SimpleAudioEngine:getInstance():playEffect(effectPath)
--             menuPopup:setVisible(true)
--         end

--         -- add a popup menu
--         local menuPopupItem = cc.MenuItemImage:create("menu2.png", "menu2.png")
--         menuPopupItem:setPosition(0, 0)
--         menuPopupItem:registerScriptTapHandler(menuCallbackClosePopup)
--         menuPopup = cc.Menu:create(menuPopupItem)
--         menuPopup:setPosition(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 2)
--         menuPopup:setVisible(false)
--         layerMenu:addChild(menuPopup)

--         -- add the left-bottom "tools" menu to invoke menuPopup
--         local menuToolsItem = cc.MenuItemImage:create("menu1.png", "menu1.png")
--         menuToolsItem:setPosition(0, 0)
--         menuToolsItem:registerScriptTapHandler(menuCallbackOpenPopup)
--         menuTools = cc.Menu:create(menuToolsItem)
--         local itemWidth = menuToolsItem:getContentSize().width
--         local itemHeight = menuToolsItem:getContentSize().height
--         menuTools:setPosition(origin.x + itemWidth/2, origin.y + itemHeight/2)
--         layerMenu:addChild(menuTools)

--         return layerMenu
--     end

--     -- play background music, preload effect
--     local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename("background.mp3")
--     cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, true)
--     local effectPath = cc.FileUtils:getInstance():fullPathForFilename("effect1.wav")
--     cc.SimpleAudioEngine:getInstance():preloadEffect(effectPath)

--     -- run
--     local sceneGame = cc.Scene:create()
--     sceneGame:addChild(createLayerFarm())
--     sceneGame:addChild(createLayerMenu())

--     if cc.Director:getInstance():getRunningScene() then
--         cc.Director:getInstance():replaceScene(sceneGame)
--     else
--         cc.Director:getInstance():runWithScene(sceneGame)
--     end

-- end


-- local status, msg = xpcall(main, __G__TRACKBACK__)
-- if not status then
--     error(msg)
-- end
