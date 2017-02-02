require 'gosu'
require './nine_volt'

class Window < Gosu::Window

	def initialize
  
	  	$window_width = 1200
	  	$window_height = 1200

	   	super($window_width, $window_height, false)
	   	self.caption = "Test Environment"

		@static = []

		boxs = Body.new(600, 600)
			group1 = Group.new(0, 0)
				group1.add_part(Part.rect(0, 0, 500, 50, 0x55_bcbcff))
				group1.add_part(Part.rect(0, 0, 50, 500, 0x55_bcbcff))
			boxs.add_group(group1)

			boxs.update
			boxs.center

		walls = Body.new(600, 600)
			group2 = Group.new(0, 0)
				group2.add_part(Part.rect(600, 600, 1200, 1200, 0x22_bcbcff))
			walls.add_group(group2)

			walls.update
			walls.center

		@static << boxs << walls

		@movers = [] 

		100.times { @movers << Part.ball(100, 600, 20, 0xff_eca912) }

		@movers.each { |mover|
			mover.velocity = Vector.new(rand(1..30), rand(1..30))
			mover.acceleration = rand(1.1..3)
		}

 	end

	def update
		
		@static[0].rotate(0.5)
		@static.each { |static| static.update }

		@static.each { |static|

			@movers.each { |mover|

				group = bbox_collide(mover, static)

				if group != false

					group.parts.each { |part|

						event = Collision.new(mover, part)

						if event.collision == true

							mover.location.location.sub(event.mtv)

							event.mtv = reflect(event.mtv, event.collision_face)
							mover.location.location.add(event.mtv)

							mover.velocity = reflect(mover.velocity, event.collision_face)
					
						end

					}

				end
			}
		}

		@movers.each { |mover| mover.update }

	end

	def draw

		@static.each { |static| static.draw }
		@movers.each { |mover| mover.draw }

	end

	def button_down(id)
    
    		if id == Gosu::KbEscape then close end
   
    	end

end

Window.new.show