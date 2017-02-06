class Body

	attr_reader :points, :parts, :bbox
	attr_accessor :movement

# Initialize Functions

	def initialize(x,y)

		@movement = Movement.new(Point.new(x, y))
		@parts = []
		@points = []
		@events = []

	end

	def add_part(part)

		@parts << part
		update_points
		update_bbox

	end

# Update Functions

	def update

		respond(@events)
		@movement.update
		rotate(@movement.rotation)
		
		@parts.each { |part| part.location.move(@movement.location) }
		@parts.each { |part| part.update }
		update_bbox

		@events = []

	end

	def update_points

		@parts.each { |part| part.points.each { |point| @points << point }}

	end

	def update_bbox

		@bbox = BBox.new(@points)

	end

# Reference Functions

	def center

		@parts.each { |part| part.center }

		update

	end

	def origin

		@parts.each { |part| part.origin }

		update

	end

# Movement Functions

	def rotate(degree)

		@parts.each { |part| part.rotate(degree) }
		
	end

	def add_event(event)

		@events << event
	
	end

	def respond(events)
		
		count = 1

		if events.length > 0
			
			events.each { |event|	

				if event.is_a? Collision

					if event.test == true
						
							$test.add(Part.ball(@movement.location.x, @movement.location.y, 50, 0xff_ff0000))
							
							$test.add("\nCollision")
							$test.add("Check Part: #{event.check_part.type}")
							$test.add("Against Part: #{event.against_part.type}")
							$test.add("Type: #{event.type}")

							$test.add("\nDirection: #{dot(event.face.normal, @movement.velocity)}")
	
							$test.add("Face Normal Dot: #{event.face_normal_dot}")
							$test.add("Event MTV: #{event.mtv.mag}")
							
						@movement.location.add(event.mtv)
						
							$test.add(Part.ball(@movement.location.x, @movement.location.y, 50, 0xff_ffff00))
						
						@movement.location.add(event.mtv)
						
							$test.add(Part.ball(@movement.location.x, @movement.location.y, 50, 0xff_00ff00))
						
						@movement.reflect(event.face)

							$test.add("\nNew Direction: #{dot(event.face.normal, @movement.velocity)}")

					end
				end
			}
		end
	
end

# Draw Functions

	def draw

		@parts.each { |part| part.draw } 
		
	# Extra Draws

		#@location.draw(0xff_ffff00, 20)
		#@bbox.draw
		#@bbox.center.draw(0xff_ffff00, 8)

	end

end