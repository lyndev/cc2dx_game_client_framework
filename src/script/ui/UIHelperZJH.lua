-- =========================================================================
-- 文 件 名: UIHelperZJH.lua
-- 作    者: lyn
-- 版    本: V1.0.0
-- 创建日期: 2017-06-04
-- 完成日期:  
-- 功能描述: 炸金花辅助类
-- 其它相关:  
-- 修改记录: 
-- =========================================================================

-- 日志文件名
local LOG_FILE_NAME = 'UIHelperZJH.lua.log'
UIHelperZJH = {}
PokerType = 
{
	HongTao  = 0,
	HeiTao   = 1,
	MeiHua   = 2,
	FangKuai = 3,
}
function UIHelperZJH.GetPoker( poker_type, poker_value )
	local p_node_poker = cc.Node:create()
	if p_node_poker then
		local bg_sprite_name = nil
		local num_sprite_name = nil
		if poker_type == PokerType.HongTao then
			if poker_value == 11 then
				bg_sprite_name = "hongtao_j.png"
			elseif poker_value == 12 then
				bg_sprite_name = "hongtao_q.png"
			elseif poker_value == 13 then
				bg_sprite_name = "hongtao_k.png"
			else
				bg_sprite_name = "hongtao_num.png"
			end
			num_sprite_name = "pred_"
		elseif poker_type == PokerType.HeiTao then
			if poker_value == 11 then
				bg_sprite_name = "heitao_j.png"
			elseif poker_value == 12 then
				bg_sprite_name = "heitao_q.png"
			elseif poker_value == 13 then
				bg_sprite_name = "heitao_k.png"
			else
				bg_sprite_name = "heitao_num.png"
			end
			num_sprite_name = "pblack_"
		elseif poker_type == PokerType.FangKuai then
			if poker_value == 11 then
				bg_sprite_name = "fangkuai_j.png"
			elseif poker_value == 12 then
				bg_sprite_name = "fangkuai_q.png"
			elseif poker_value == 13 then
				bg_sprite_name = "fangkuai_k.png"
			else
				bg_sprite_name = "fangkuai_num.png"
			end
			num_sprite_name = "pred_"
		elseif poker_type == PokerType.MeiHua then
			if poker_value == 11 then
				bg_sprite_name = "meihua_j.png"
			elseif poker_value == 12 then
				bg_sprite_name = "meihua_q.png"
			elseif poker_value == 13 then
				bg_sprite_name = "meihua_k.png"
			else
				bg_sprite_name = "meihua_num.png"
			end
			num_sprite_name = "pblack_"
		end
		if bg_sprite_name then
			
			local back_sprite = self:GetPokerBack()
			local bg_sprite = display.newSprite(bg_sprite_name)
			local num_sprite = display.newSprite(num_sprite_name .. poker_value .. ".png")
			local highlight_sprite = display.newSprite("highlight_poker.png")
			if back_sprite and bg_sprite and num_sprite and highlight_sprite then
				num_sprite:setPosition(-25, 36)
				back_sprite:addTo(p_node_poker)
				back_sprite:setTag(100)

				bg_sprite:addTo(p_node_poker)
				bg_sprite:setTag(101)

				num_sprite:addTo(p_node_poker)
				num_sprite:setTag(102)

				highlight_sprite:addTo(p_node_poker)
				highlight_sprite:setTag(103)
				highlight_sprite:setVisible(false)
			end

		end
		p_node_poker:setAnchorPoint(0,0)
		p_node_poker.poker_type = poker_type
		p_node_poker.poker_value = poker_value
	end
	return p_node_poker
end

--获取牌的背面
function  UIHelperZJH.GetPokerBack(  )
	return display.newSprite("poker_bg.png")
end

--获取牌的背面
function  UIHelperZJH.GetPokerBackSmall(  )
	local p_poker = display.newSprite("poker_bg.png")
	p_poker:setScale(0.7)
	return p_poker
end