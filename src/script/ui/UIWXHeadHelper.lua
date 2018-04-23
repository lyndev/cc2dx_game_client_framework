UIWXHeadHelper = {
	HeadList = {},
	DefaultBoy = nil,
	DefaultGirl = nil,
}

function UIWXHeadHelper:AddHeadImg( tag, sp_head )
	self.HeadList[tag] = sp_head
end

function UIWXHeadHelper:GetDefaultBoyHead(  )
	if not DefaultBoy then
		DefaultBoy = cc.Sprite:create("res/res_main/image/com_head_boy.png")
		DefaultBoy:retain()
	end
	return DefaultBoy
end

function UIWXHeadHelper:GetDefaultGirlHead(  )
	if not DefaultGirl then
		DefaultGirl = cc.Sprite:create("res/res_main/image/com_head_girl.png")
		DefaultGirl:retain()
	end
	return DefaultGirl
end

function UIWXHeadHelper:GetDefaultHead( sex )
	if sex == 0 then
		return self:GetDefaultBoyHead()
	else
		return self:GetDefaultGirlHead()
	end
end

function UIWXHeadHelper:GetCircleHeadImg( tag, head_url, sex)
	if head_url == -1 then
		local sp_head = self.HeadList[tag]
		if sp_head then
			return GetCircleHeadImg(sp_head)
		end
	end
	if head_url and head_url ~= "" then
		local sp_head = self.HeadList[tag]
		if sp_head then
			return GetCircleHeadImg(sp_head)
		else
			WX.WeChatSDKAPIDelegate:ReqestHeadImg(head_url,tag)
			return GetCircleHeadImg(self:GetDefaultHead(sex))
		end
	else
		return GetCircleHeadImg(self:GetDefaultHead(sex))
	end
	
end

function UIWXHeadHelper:GetRectHeadImg( tag, head_url, sex)
	if head_url == -1 then
		local sp_head = self.HeadList[tag]
		if sp_head then
			return GetRectHeadImg(sp_head)
		end
	end
	if head_url and head_url ~= "" then
		local sp_head = self.HeadList[tag]
		if sp_head then
			return GetRectHeadImg(sp_head)
		else
			WX.WeChatSDKAPIDelegate:ReqestHeadImg(head_url,tag)
			return GetRectHeadImg(self:GetDefaultHead(sex))
		end
	else
		return GetRectHeadImg(self:GetDefaultHead(sex))
	end
	
end