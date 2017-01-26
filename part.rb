class Part

	attr_reader :points, :bbox, :type
	attr_accessor :location, :radius, :color, :z, :velocity, :acceleration

# Initialize Functions

	def initialize(type, x, y, points, color, z = 1)

		@type = type
		@location = Point.new(x, y)
		@points = points

		@velocity = Vector.new(0, 0)
		@acceleration = Vector.new(0, 0)


		if type == "ball"
			@radius = @points[2].x
		else @radius = nil end

		update_bbox

		@color = color
		@z = z

	end

	def self.seg(x1, y1, x2, y2, color, z = 1)

		points = [ Point.new(x1, y1),
				    Point.new(x2, y2) ]

		return Part.new("seg", x1, x2, points, color, z)

	end 

	def self.rect(x, y, width, height, color, z = 1)

		points = [ Point.new(0, 0),
				    Point.new(width, 0),
				    Point.new(width, height),
				    Point.new(0, height), 
				    Point.new(0, 0) ]

		return Part.new("rect", x, y, points, color, z)

	end

	def self.ball(x, y, radius, color, z = 1)

		points = [ Point.new(0, 0),
				    Point.new(radius*-1, radius*-1), 
				    Point.new(radius, radius*-1),
				    Point.new(radius, radius),
				    Point.new(radius*-1, radius) ]

		return Part.new("ball", x, y, points, color, z)

	end

# Update Functions

	def update(location = @location)

		@velocity.mult(@acceleration)
		@velocity.max(5)
		@location.add(@velocity)

		@points.each { |point| point.move(location) }
		update_bbox
		
	end

	def update_bbox

		@bbox = BBox.new(@points)

	end

	def center

		@points.each { |point| point.set_tether(@bbox.center.location) }

	end

	def origin

		@points.each { |point| point.tether = point.origin }

	end

# Movement Functions

	def rotate(degree)

		points.each { |point| point.rotate(degree) }

	end

# Draw

	def draw
		
		if @type == "ball"

			@location.draw(@color, @radius)

		elsif @type == "seg"

			Gosu.draw_line( @points[0].x, @points[0].y, @color,
							 @points[1].x, @points[1].y, @color, @z )

		elsif @type == "rect"

			Gosu.draw_quad( @points[0].x, @points[0].y, @color,
							   @points[1].x, @points[1].y, @color,
						   	   @points[2].x, @points[2].y, @color,
							   @points[3].x, @points[3].y, @color, @z )
		end

	# Extra Draws

		#@points.each { |point| point.draw}

		#@location.draw(0xff_00ff00, 10)
		#@bbox.draw
		#@bbox.center.draw(0xff_00ff00, 4)

	end

end