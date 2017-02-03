require 'gosu'
require './nine_volt'

class Window < Gosu::Window

	def initialize
  
	  	$window_width = 1200
	  	$window_height = 1200

	   	super($window_width, $window_height, false)
	   	self.caption = "Test Environment"

		boxes = Body.new(600, 600)
			boxes.add_part(Part.rect(0, 0, 500, 50, 0x55_bcbcff))
			boxes.add_part(Part.rect(0, 0, 50, 500, 0x55_bcbcff))

		boxes.center
		boxes.movement.rotation = 0.2

		walls = Body.new(0, 0)
			walls.add_part(Part.seg(50, 50, 50, 1150, 0xff_bcbcff))
			walls.add_part(Part.seg(50, 1150, 1150, 1150, 0x55_bcbcff))
			walls.add_part(Part.seg(1150, 1150, 1150, 50, 0x55_bcbcff))
			walls.add_part(Part.seg(1150, 50, 50, 50, 0x55_bcbcff))

		mover = Body.new(100, 100) 
			mover.add_part(Part.ball(100, 100, 20, 0xff_eca912))

		mover.movement.velocity = Vector.new(1, 1.1)
		mover.movement.acceleration = 1.1
		mover.movement.max = 10

		@space = Space.new
			@space.add_body(boxes)
			@space.add_body(walls)
			@space.add_body(mover)

 	end

	def update
		
		@space.update
	
	end

	def draw

		@space.draw

	end

	def button_down(id)
    
    		if id == Gosu::KbEscape then close end
   
    	end

end

Window.new.show
