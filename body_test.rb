require "./physics"

class Body

	include Physics

	attr_reader :points, :parts, :centroid, :events, :touching, :bbox
	attr_accessor :location, :velocity, :max_v, :min_v, :acceleration, :rotation,
				  :mass, :slop, :type, :name

# Initialize Functions

	def initialize(x,y)

		@location = Point.new(x, y)
		@velocity = Vector.new(0 ,0)
		@max_v = 0
		@min_v = 0.05
		@acceleration = Vector.new(0, 0)
		@rotation = 0

		@mass = 0
		@slop = 0.01

		@points = []
		@parts = []
		@forces = []
		
		@events = []
		@touching = 0
		@history = []
		@step = []
		
		@type = "static"
		@name = ""

	end

	def i_mass

		if @mass == 0
			return 0
		else
			return 1/@mass.to_f

		end
	
	end	 

	def add_part(part)

		@parts << part
		add_points

	end

	def add_points

		@parts.each { |part| part.points.each { |point| @points << point }}

	end

	def add_force(force)

		@forces << force

	end

	def add_event(event)

		@events << event
	
	end

	def add_step(step)

		@step << step

	end

	def add_history(step)

		if @history.length == 10
			@history.shift
			@history << step
		else
			@history << step
		end

	end

	def set_body

		@parts.each { |part| part.location.move(@location) }
		@parts.each { |part| part.update }

		update_centroid
		update_bbox
	
	end

# Update Functions

	def update(environment)

		puts "\n#{name}".green

		@step = []

		if @type == "mover"
				
			respond?(@events)
			
			update_env_forces(environment)
			apply_forces

			step

			add_step(@velocity.copy)
			update_resting

			@parts.each { |part| part.location.move(@location) }
			@parts.each { |part| part.update }

		end

		update_centroid
		update_bbox
		
		@acceleration.mult(0)
		@events = []
		@forces = []
		
		add_history(@step)

	end

	def update_env_forces(environment)

		add_force(environment.gravity)
		add_force(environment.drag(@velocity))

	end

	def update_centroid
		
		x = 0
		y = 0

		mass = 0

		@parts.each { |part|

			mass+=part.centroid_mass
		
		}

		@parts.each { |part| 
			
			x = x+part.centroid.x*part.centroid_mass
			y = y+part.centroid.y*part.centroid_mass

		}
		
		x = x/mass
		y = y/mass
		
		@centroid = Point.new(x, y)

	end

	def update_bbox

		@bbox = BBox.new(@points)

	end

# Reference Functions

	def center

		@parts.each { |part| part.center }

		set_body

	end

	def origin

		@parts.each { |part| part.origin }

		set_body

	end

#  Movement Functions

	def step

			@velocity.add(@acceleration)		
			@velocity.max(@max_v)
			
			if resting?
				puts "Resting".red
				@velocity.mult(0)
			end
			
			@location.add(@velocity)
			
			rotate(@rotation)

	end

	def rotate(degree)

		@parts.each { |part| part.rotate(degree) }
		
	end

	def apply_force(force)

		force = Vector.mult(force, i_mass.to_f)	
		@acceleration.add(force)
	
	end

	def apply_forces

		@forces.each { |force|
			apply_force(force)
		}
	
	end

# Behavior Functions
	
	def respond?(events)

		priority_event = nil
		faces = []
		averaged_face = Vector.new(0, 0)

		if events.length > 0

			true_querys = []
			
			events.each{ |event| 
				
				if event.query == true
					true_querys << event
				end 
			}

			if true_querys.length > 0

				priority_penetration = 0
		
				true_querys.each { |event|

					faces << event.face.unit

					if event.penetration >= priority_penetration
						priority_penetration = event.penetration
						priority_event = event
					end
				}

				@touching = true_querys.length

				faces.each{ |face| 
					averaged_face.add(face)
				}

				priority_event.face = averaged_face

				respond(priority_event)
			
			end
			
		end

	end

	def respond(event)

			add_step("collision")
			
			$test.add(Part.ball(@location.x, @location.y, 30, 0x33_ffff00))
			$test.add(Part.seg(@location.x, @location.y,
								@location.x+(@velocity.x*10),
								@location.y+(@velocity.y*10), 0xff_ffff00)) #velocity

			$test.add("\nCollision".green)
			$test.add("Body Name: #{name}")
			$test.add("Grounded: #{grounded?}")
			$test.add("Check Part Type: #{event.check_part.type}")
			$test.add("Against Part Type: #{event.against_part.type}")
			$test.add("Event Type: #{event.type}")

			$test.add("\nDirection: #{event.direction}")
			$test.add("Heading: #{@velocity.heading}")
			$test.add("Penetration: #{event.penetration}".blue)
			$test.add("Velocity: #{velocity.mag}".yellow)
			$test.add("Acceleration: #{acceleration.mag}".light_blue)
		
		@velocity = impulse_vector(event.check_body_v, i_mass, event.against_body_v, event.against_body.i_mass, event.face)
		@location.add(event.mtv)
		
		add_force(event.against_part.material.static_friction(@velocity, event.face))
		
			$test.add(Part.ball(@location.x, @location.y, 30, 0x33_00ff00))

		
			$test.add("\nFace Normal Dot: #{event.face_normal_dot}")
			$test.add("Event MTV: #{event.mtv.mag}")
			
			$test.add("\nNew Direction: #{dot(event.face.normal, @velocity)}")
			$test.add("New Heading: #{@velocity.heading}")
			$test.add("Velocity: #{@velocity.mag}")

			$test.add(Part.seg(@location.x, @location.y,
							   @location.x+(@velocity.x*10),
							   @location.y+(@velocity.y*10), 0xff_ffaa00)) #velocity reflected
	end

	def grounded?
		
		touching = 0

		@history.each { |step| 
			step.each { |event|

				if event == "collision"
					touching+=1
				end
			}
		}

		if touching > 5
			return true
		else
			return false
		end

	end

	def resting?

		resting = 0

		@history.each { |step| 
			step.each { |event|

				if event == "resting"
					resting+=1
				end
			}
		}

		if resting >= 3 
			return true
		else
			return false
		end
	
	end

	def update_resting

		velocities = []

		@history.each { |step|
			step.each { |event|

				if event.is_a? Vector
					velocities << event.mag.to_i
				end
			}
		}		

		if velocities.length > 9
			
			average_v = velocities.sum / velocities.length

			if grounded? && @touching > 1 && average_v < 0.1 
				add_step("resting")
			end
		end
	end

# Draw Functions

	def draw

		@parts.each { |part| part.draw } 
		
	# Extra Draws

		#@location.draw(0xff_ffff00, 20)
		#@centroid.draw(0xff_ffffff, 8)
		#@bbox.draw
		#@bbox.center.draw(0xff_ffff00, 8)

	end

end