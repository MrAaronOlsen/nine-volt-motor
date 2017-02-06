require 'gosu'
require './nine_volt'

class Window < Gosu::Window

	def initialize
  
	  	$window_width = 1200
	  	$window_height = 1200

	   	super($window_width, $window_height, false)
	   	self.caption = "Test Environment"

		boxes = Body.new(600, 600)
			boxes.add_part(Part.rect(0, 0, 500, 50, 0x55_777777))
			boxes.add_part(Part.rect(0, 0, 50, 500, 0x55_777777))

		boxes.center
		#boxes.movement.rotation = 0.2

		walls = Body.new(0, 0)
			walls.add_part(Part.seg(50, 50, 50, 1150, 0x55_777777))
			walls.add_part(Part.seg(50, 1150, 1150, 1150, 0x55_777777))
			walls.add_part(Part.seg(1150, 1150, 1150, 50, 0x55_777777))
			walls.add_part(Part.seg(1150, 50, 50, 50, 0x55_777777))

		walls.update

		balls = []

			2.times {
				mover = Body.new(rand(100..300), rand(100..300)) 
					mover.add_part(Part.ball(0, 0, 50, 0xff_ffffff))
			
				mover.movement.velocity = Vector.new(rand(0.1..1.5), rand(0.1..1.5))
				mover.movement.acceleration = 1.01
				mover.movement.max = 15

				mover.update
				
				balls << mover
			}
		
		@background = Part.rect(0, 0, 1200, 1200, 0xff_999999, 0)

		@space = Space.new
			@space.add_body(boxes)
			@space.add_body(walls)
			@space.add_body(balls)

		@tests = []

 	end

	def update

		if Gosu.button_down?(Gosu::KbSpace)
			$test = Test.new

			@space.update
		
			@tests << $test
			
			if @tests.length > 10 then @tests.shift end
			
			$test.run
		end

	end

	def draw

		@space.draw
		#@tests.each { |test| test.draw }
		@background.draw

	end

	def button_down(id)
    
    	if id == Gosu::KbEscape then close end

    end

end

Window.new.show
