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

		events.each { |event|

			if event.test
			puts ""
			puts "Event Num: #{count}"
			puts "Number of Events: #{events.length}"
			puts "Check Part: #{event.check_part.type}"
			puts "Against Part: #{event.against_part.type}"
			puts "MTV Ratio: #{event.mtv_ratio}"
			end
		
			count+=1
			
		}

		if events.length > 0
			
			events.each { |event|	

				if event.is_a? Collision

					if event.test == true
						
						puts "HIT"
						
						mtv = @movement.velocity.copy
						mtv.mult(event.mtv_ratio)

						reflected_mtv = reflect_vector(mtv, event.face)
						mtv.add(reflected_mtv)

						@movement.location.add(mtv)
						@movement.reflect(event.face)
						
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
		@bbox.draw
		#@bbox.center.draw(0xff_ffff00, 8)

	end

end