class Part

	attr_reader  :type, :points, :bbox
	attr_accessor :location, :centroid, :centroid_mass, 
				  :material, :radius, :color, :z

# Initialize Functions

	def initialize(type, x, y, points, color, z = 1)

		@type = type
		@location = Point.new(x, y)
		@points = points
		@centroid_mass = update_centroid_mass
		update_centroid

		@material = Material.new

		type == "ball" ? @radius = @points[2].x : @radius = nil

		update_bbox

		@color = color
		@z = z

	end

	def self.ball(x, y, radius, color, z = 1)

		points = [ Point.new(0, 0),
				   Point.new(radius*-1, radius*-1, 0), 
				   Point.new(radius, radius*-1, 0),
				   Point.new(radius, radius, 0),
				   Point.new(radius*-1, radius, 0) ]

		return Part.new("ball", x, y, points, color, z)

	end

	def self.seg(x1, y1, x2, y2, color, z = 1)

		points = [ Point.new(0, 0),
				   		 Point.new(x2-x1, y2-y1) ]

		return Part.new("seg", x1, y1, points, color, z)

	end

	def self.tri(x1, y1, x2, y2, x3, y3, color, z = 1)

		points = [ Point.new(0, 0),
				   	   Point.new(x2-x1, y2-y1),
				   		 Point.new(x3-x1, y3-y1),
				   		 Point.new(0, 0, 0) ]

		return Part.new("tri", x1, y1, points, color, z)
	
	end

	def self.rect(x, y, width, height, color, z = 1)

		points = [ Point.new(0, 0),
				   		 Point.new(width, 0),
				  		 Point.new(width, height),
				  		 Point.new(0, height), 
				  		 Point.new(0, 0, 0) ]

		return Part.new("rect", x, y, points, color, z)

	end

# Build functions

	def add_material(material)

		@material = material

	end
	
# Update Functions

	def update(location = @location)

		points.each { |point| point.move(location) }
		update_centroid
		update_bbox

	end
	
	def update_centroid
		
		x = 0
		y = 0

		corner = 0

		centroid_mass.times do 
			
			x = x + points[corner].x * points[corner].mass
			y = y + points[corner].y * points[corner].mass
		
			corner+=1

		end
		
		x = x/centroid_mass
		y = y/centroid_mass
		
		@centroid = Point.new(x, y)

	end

	def update_centroid_mass
		
		mass = 0

		@points.each { |point| mass+=point.mass }
		
		return mass

	end


	def update_bbox

		@bbox = BBox.new(@points)

	end

# Reference Functions

	def center

		@points.each { |point| point.set_tether(@centroid.location) }

	end

	def origin

		@points.each { |point| point.tether = point.origin }

	end

# Movement Functions

	def rotate(degree)

		points.each { |point| point.rotate(degree) }

	end

# Draw Functions

	def draw
		
		case type

			when "ball"

				axis1 = Vector.new(radius, 0)
				axis2 = Vector.new(radius, 0)
				
				60.times do

					axis2.rotate(6)

					x1 = axis1.x+location.x
					y1 = axis1.y+location.y
					x2 = axis2.x+location.x
					y2 = axis2.y+location.y

					Gosu.draw_triangle(location.x, location.y, color, x1, y1, color, x2, y2, color, z)

					axis1.rotate(6)
				
				end

			when "seg"

				Gosu.draw_line(points[0].x, points[0].y, color,
						   				 points[1].x, points[1].y, color, z)
		
			when "tri"

				Gosu.draw_triangle(points[0].x, points[0].y, color,
							   					 points[1].x, points[1].y, color,
							   					 points[2].x, points[2].y, color, z)

			when "rect"

				Gosu.draw_quad(points[0].x, points[0].y, color,
						   				 points[1].x, points[1].y, color,
											 points[2].x, points[2].y, color,
											 points[3].x, points[3].y, color, z)
		end

	# Extra Draws

		#points.each { |point| point.draw}

		#location.draw(0xff_00ff00, 10)
		#centroid.draw(0xff_00ff00, 4)
		#bbox.draw
		#bbox.center.draw(0xff_00ff00, 4)

	end

end