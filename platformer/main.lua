require("objects/Platform")

-- init game state
function love.load()
    platform = Platform:new()

	platform.width = love.graphics.getWidth() -- whole window width
	platform.height = love.graphics.getHeight() -- as tall as the window, but it'll be repositioned

	platform.x = 0
	platform.y = platform.height / 2 -- platform halfway down the screen

	plat2 = Platform:new({x = 50, y = 50, width = 100, height = 100})
end

function love.update(dt)
end

function love.draw()
	love.graphics.setColor(255, 255, 255)

	platform:draw()--love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)
	plat2:draw()
end
