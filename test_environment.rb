require 'gosu'
require './a_motor'

def movement

	if button_down?(Gosu::KbC)
			@boxes.center
		end

		if button_down?(Gosu::KbO)
			@boxes.origin
		end

		if button_down?(Gosu::KbLeft)

			@boxes.rotate(0.1)
			
			@boxes.groups.each { |group|

				group.rotate(0.3) 

				group.parts.each { |part| part.rotate(1) }
			}

		elsif button_down?(Gosu::KbRight)

			@boxes.rotate(-0.1)
			
			@boxes.groups.each { |group|

				group.rotate(-0.3) 

				group.parts.each { |part| part.rotate(-1) }
			}

		end

		if button_down?(Gosu::KbA)
			@ball.location.add(Vector.new(-5,0))
		end
		if button_down?(Gosu::KbD)
			@ball.location.add(Vector.new(5,0))
		end
		if button_down?(Gosu::KbW)
			@ball.location.add(Vector.new(0,-5))
		end
		if button_down?(Gosu::KbS)
			@ball.location.add(Vector.new(0,5))
		end

end

def wall(ball)

	if ball.location.x > $window_width - ball.radius || ball.location.x < ball.radius
		ball.velocity.x*=-1
		return ball.velocity

	elsif @ball.location.y > $window_height - @ball.radius || @ball.location.y < @ball.radius

		ball.velocity.y*=-1
		return ball.velocity

	else

		return ball.velocity

	end

end

class Window < Gosu::Window

	def initialize
  
	  	$window_width = 1200
	  	$window_height = 1200

	   	super($window_width, $window_height, false)
	   	self.caption = "Test Environment"

		@static = Body.new(600, 600)
			group = Group.new(0, 0)
			group.add_part(Part.rect(0, 0, 50, 500, 0x55_bcbcff))
			group.add_part(Part.rect(0, 0, 1200, 1200, 0x22_ffffff))
		@static.add_group(group)

		@movers = [] 

		50.times { @movers << Part.ball(100, 600, 20, 0xff_eca912) }

		@movers.each { |mover|
			mover.velocity = Vector.new(rand(1..10), rand(1..10))
			mover.acceleration = rand(1.1..1.5)
		}

		@static.center

 	end

	def update

		@movers.each { |mover| mover.update }
		@static.rotate_parts(0.05)
		@static.update

		@movers.each { |mover|

			part = bbox_collide(mover, @static)

			if part != false

				event = Collision.new(mover, part)

				if event.collision == true

					mover.location.location.sub(event.mtv)

					event.mtv = reflect(event.mtv, event.collision_face)
					mover.location.location.add(event.mtv)

					mover.velocity = reflect(mover.velocity, event.collision_face)
			
				end

			end

		}

	end

	def draw

		@static.draw
		@movers.each { |mover| mover.draw }

	end

	def button_down(id)
    
    		if id == Gosu::KbEscape then close end
   
    	end

end

Window.new.show