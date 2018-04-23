EntityView = class("EntityView", CEntity)

function EntityView:New( o )
	o = CEntity:New(o)
	setmetatable(o, EntityView)
	return o
end