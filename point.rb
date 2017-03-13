class Point

	attr_accessor :x, :y, :location, :mass, :origin, :tether

# Initialize Functions
	
	def initialize(x, y, mass = 1)

		@x = x.to_f
		@y = y.to_f
		@mass = mass

		@location = Vector.new(x, y)
		@origin = Vector.new(x, y)
		@tether = Vector.new(x, y)

	end

	def set_tether(location = @location)

		@tether = Vector.sub(location, location)

	end

# Update Functions

	def move(location = @location)

		@location = Vector.add(location, tether)
		update

	end

	def update

		@x = location.x
		@y = location.y

	end

# Movement Functions

	def add(velocity)

		location.add(velocity)
		update

	end

	def sub(velocity)

		location.sub(velocity)
		update

	end

	def mult(velocity)

		location.mult(velocity)
		update

	end
	
	def rotate(degree)
		
		tether.rotate(degree)
		
	end

# Draw Functions

	def draw(color = 0xff_ffffff, radius = 2)

		axis1 = Vector.new(radius, 0)
		axis2 = Vector.new(radius, 0)
		
		60.times do

			axis2.rotate(6)

			x1 = axis1.x + x
			y1 = axis1.y + y
			x2 = axis2.x + x
			y2 = axis2.y + y

			Gosu.draw_line(x1, y1, color, x2, y2, color, 2)

			axis1.rotate(6)
		
		end

	end

end