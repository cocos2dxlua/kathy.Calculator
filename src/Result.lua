function Result(num)
	local self = cc.Sprite:create()
	local txt, bg

	local function init()
		self.num = num
		self:setContentSize(cc.size(200,80))
		self:setAnchorPoint(cc.p(0,0))
		

		-- bg = cc.Sprite:create()
		-- bg:setTextureRect(cc.rect(0,0,100,80))
		-- bg:setAnchorPoint(cc.p(0,0))
		-- bg:setColor(cc.c3b(255,255,255))
		-- self:addChild(bg)


		txt = cc.LabelTTF:create(num, "Courier", 50)
		txt:setPosition(180,40)
        txt:setColor(cc.c3b(255,0,0))
		self:addChild(txt)
		
	end


	init()
	return self
end