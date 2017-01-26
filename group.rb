class Group

	attr_reader :points, :parts, :bbox
	attr_accessor :location

# Initialize Functions

	def initialize(x,y)

		@location = Point.new(x, y)
		@parts = []
		@points = []

	end

	def add_part(part)

		@parts << part
		update_points
		update_bbox

	end

# Update Functions

	def update(location = @location)

		@parts.each { |part| part.location.move(location) }
		@parts.each { |part| part.update }

		update_bbox

	end

	def update_points

		@parts.each { |part| part.points.each { |point| @points << point }}

	end

	def update_bbox

		@bbox = BBox.new(@points)

	end

	def center

		@parts.each { |part|

			part.center
			update

		}

		@parts.each { |part|  part.location.set_tether(@bbox.center.location) }

	end

	def origin

		@parts.each { |part|  

			part.location.tether = part.location.origin
			part.origin

		}
		
	end

# Movement Functions
	
	def rotate(degree)

		@parts.each { |part| part.location.rotate(degree) }

	end

# Draw

	def draw

		@parts.each { |part| part.draw } 
		
	# Extra Draws

		#@location.draw(0xff_990000, 15)
		#@bbox.draw
		#@bbox.center.draw(0xff_990000, 6)

	end

end