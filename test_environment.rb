require 'gosu'
require './nine_volt'
require './test_methods'

class Window < Gosu::Window

	def initialize
  
	  	$window_width = 1200
	  	$window_height = 1200

	   	super($window_width, $window_height, false)
	   	self.caption = "Test Environment"
		
		@background = Part.rect(0, 0, 1200, 1200, 0xff_aaaaaa, 0)

		@world = world 

		@tests = []

 	end

	def update

		if Gosu.button_down?(Gosu::KbSpace)
			$test = Test.new

			@world.update
		
			#@tests << $test
			
			if @tests.length > 1 then @tests.shift end
			
			#$test.run
		end

	end

	def draw
		
		@world.draw
		#@tests.each { |test| test.draw }
		@background.draw

	end

	def button_down(id)
    
    	if id == Gosu::KbEscape then close end

    end

end

Window.new.show