class Body

	attr_reader :points, :groups, :bbox
	attr_accessor :location

# Initialize Functions

	def initialize(x,y)

		@location = Point.new(x, y)
		@groups = []
		@points = []

	end

	def add_group(group)

		@groups << group
		update_points
		update_bbox

	end

# Update Functions

	def update(location = @location)

		@groups.each { |group| group.location.move(location) }
		@groups.each { |group| group.update }
		update_bbox

	end

	def update_points

		@groups.each { |group| group.points.each { |point| @points << point }}

	end

	def update_bbox

		@bbox = BBox.new(@points)

	end

	def center

		@groups.each { |group| group.center }

		update

	end

	def origin

		@groups.each { |group| group.origin }

		update

	end

# Movement Functions

	def rotate(degree)

		rotate_groups(degree)
		rotate_parts(degree)

	end

	def rotate_groups(degree)

		@groups.each { |group| group.rotate(degree) }

	end

	def rotate_parts(degree)

		@groups.each { |group|
			group.parts.each { |part| 
				part.rotate(degree)
			}
		}

	end

# Draw

	def draw

		@groups.each { |group| group.draw } 
		
	# Extra Draws

		#@location.draw(0xff_ffff00, 20)
		#@bbox.draw
		#@bbox.center.draw(0xff_ffff00, 8)

	end

end