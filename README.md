# kathy.Calculator

大体思路：

1、布局  
	生成计算机的按钮 — btn (sprite)， 放到layer中
	所有的按钮都添加到 allBtns 中


2、layer注册触碰事件


3、处理点击事件
	每次触碰，都要循环遍历allBtns，
	如果触碰的位置在其中的一个btn里，触碰“有效”！~   此次循环结束（break）
	处理触碰的结果 …  

	如果触碰的是数字 或 点  [ 0-9 . ]
	如果触碰的是运算符       [ + - * ÷ ]
	如果触碰的是等号	  [ = ]
	如果触碰的是重置	  [ c ]


说明：
如何判断输入的是第一个数字？ 
通过firstActive变量来判断，初始化为true， 用户一旦触碰运算符 [ + - * ÷ ]， firstActive设置为false
每次输入数字的时候通过firstActive来判断用户输入的是第一个数字还是第二个数字


注意：
这里Result sprite的实现，是每一次的“有效”触碰，都删除当前的Result sprite， 再重新生成新的Result sprite 添加到layer中


代码关键点：

-- 设置layer的触摸响应为true
    layer:setTouchEnabled(true)

-- 注册layer的触碰事件
    layer:registerScriptTouchHandler(onTouch)


-- 触碰事件
    local function onTouch( type, x, y )
        -- 每一次触碰都要遍历 allBtns 里所有btn（for in）
        -- 如果触碰的位置在其中的一个btn里，此次循环结束（break）

        -- 关键方法：
        -- 判断触摸点p是否在sprite的图像像素内
        -- cc.rectContainsPoint(sprite.getBoundingBox(),p);

        local p = cc.p(x, y)
        for key,var in pairs(allBtns) do
            if cc.rectContainsPoint(var:getBoundingBox(), p) then
                -- ...
                break
            end
        end  
    end


-- 精灵的移除和添加
layer:removeChild(spriteFirst, true)              
layer:addChild(spriteFirst)
	
