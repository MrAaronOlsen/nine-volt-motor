class Point

	attr_accessor :x, :y, :location, :origin, :tether

# Initialize Functions
	
	def initialize(x , y)

		@x = x
		@y = y

		@location = Vector.new(@x, @y)
		@origin = Vector.new(@x, @y)
		@tether = Vector.new(@x, @y)

	end

# Update Functions

	def set_tether(location = @location)

		@tether = Vector.sub(@location, location)

	end

# Movement Functions

	def move(location)

		@location = Vector.add(location, @tether)
		@x = @location.x
		@y = @location.y

	end

	def add(velocity)

		@location.add(velocity)

		@x = @location.x
		@y = @location.y

	end
	
	def rotate(degree)
		
		@tether.rotate(degree)

	end

# Draw

	def draw(color = 0xff_ffffff, radius = 2)

		axis1 = Vector.new(radius, 0)
		axis2 = Vector.new(radius, 0)
		
		15.times {

			axis2.rotate(24)

			x1 = axis1.x+@x
			y1 = axis1.y+@y
			x2 = axis2.x+@x
			y2 = axis2.y+@y

			Gosu.draw_line(x1, y1, color, x2, y2, color, 2)

			axis1.rotate(24)
		
		}


	end

end