Platform = {}
function Platform:new (o)
	o = o or {}
    o.x = o.x or 0
    o.y = o.y or 0
    o.width = o.width or 0
    o.height = o.height or 0

	setmetatable(o, self)
	self.__index = self
	return o
end

function Platform:draw()
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
