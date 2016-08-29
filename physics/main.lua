-- init game state
function love.load()
	--Store the new world in a variable
	world = love.physics.newWorld(0, 200, true) --XGravity,YGravity = 0,200
	  world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    
    circlePattern = "line"
	text = "" -- placeholder for screen text
	persisting = 0 -- state for repeated callbacks

	ball = {}
	  ball.b = love.physics.newBody(world, 400, 200, "dynamic") -- set x,y position at 400,200 and allowed to be acted on
	  ball.b:setMass(10)
	  ball.s = love.physics.newCircleShape(50) -- radius 50
	  ball.f = love.physics.newFixture(ball.b, ball.s) -- connect body to shape
	  ball.f:setRestitution(0.99) -- bouncy
	  ball.f:setUserData("Ball") -- accessible name

	static = {}
	  static.b = love.physics.newBody(world, 400, 400, "static") -- cannot be acted on
	  static.s = love.physics.newRectangleShape(200, 50) -- size
	  static.f = love.physics.newFixture(static.b, static.s)
	  static.f:setUserData("Block")

    ropeJoint = love.physics.newRopeJoint(ball.b, static.b, 0, 0, 0, 0, 10, true)

end

function love.update(dt)
	world:update(dt)

    -- Break into separate control module
	if love.keyboard.isDown("right") then
		ball.b:applyForce(1000, 0)
	elseif love.keyboard.isDown("left") then
		ball.b:applyForce(-1000, 0)
	end
	if love.keyboard.isDown("up") then
		ball.b:applyForce(0, -5000)
	elseif love.keyboard.isDown("down") then
		ball.b:applyForce(0, 1000)
	end
	-- end control module

	if string.len(text) > 768 then
		text = ""
	end
end

function love.draw()
	love.graphics.circle(circlePattern, ball.b:getX(), ball.b:getY(), ball.s:getRadius(), 20)
	love.graphics.polygon("line", static.b:getWorldPoints(static.s:getPoints()))

	love.graphics.print(text, 10, 10)
end


-- Break into separate physics utility collection
-- a,b are fixtures
-- coll is the contact object
-- normalimpulse is the amount of impulse applied normal to the first point of collision
-- tangentimpulse is likewise applied tangent to the first point of collision
function beginContact(a, b, coll)
	circlePattern = "fill"
	x,y = coll:getNormal()
	text = text.."\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "..x..", "..y
end

function endContact(a, b, coll)
    circlePattern = "line"
	persisting = 0 -- reset since they're no longer touching
	text = text.."\n"..a:getUserData().." uncolliding with "..b:getUserData()
end

function preSolve(a, b, coll)
	if persisting == 0 then -- only say this when they first collide
		text = text.."\n"..a:getUserData().." touching "..b:getUserData()
	elseif persisting < 20 then -- start counting
		text = text.." "..persisting
	end
	persisting = persisting + 1 -- keep track of how many updates they've been touching for
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
	-- Do nothing
end

