require "./physics"

class Body

	include Physics

	attr_reader :points, :parts, :centroid, :events, :touching, :bbox, :report
	attr_accessor :location, :velocity, :max_v, :min_v, :acceleration, :rotation,
				  :mass, :bindings, :type, :name

# Initialize Functions

	def initialize(x,y)

		@location = Point.new(x, y)
		@velocity = Vector.new(0 ,0)
		@max_v = 0
		@min_v = 0.05
		@acceleration = Vector.new(0, 0)
		@rotation = 0

		@mass = 0

		@bindings = Bindings.new

		@points = []
		@parts = []
		@forces = []
		
		@events = []
		@touching = 0
		@history = []
		@step = []
		@report = []

		@type = "static"
		@name = ""

	end

	def set

		@parts.each { |part| part.location.move(@location) }
		@parts.each { |part| part.update }

		update_centroid
		update_bbox
	
	end

	def i_mass

		if @mass == 0 
			return 0
		else
			return 1/@mass.to_f
		end
	
	end	 

# Build Functions

	def add_part(part)

		@parts << part
		add_points

	end

	def add_binding(binding)

		@bindings = binding

	end

	def add_material(material)

		@parts.each { |part| part.add_material(material) }

	end

	def add_points

		@parts.each { |part| part.points.each { |point| @points << point }}

	end

# Update Functions

	def update(environment)

		@step = []
		@report = []

		if @type == "mover"

			respond?(@events)
			
			check_bindings
			add_env_forces(environment)
			apply_forces

			step

			add_step(@velocity.copy)
			
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

	def step

		@velocity.add(@acceleration)		
		@velocity.max(@max_v)
		
		resting_query

		if resting? then @velocity.mult(0) end
		
		@location.add(@velocity)
		
		rotate(@rotation)

	end

	def check_bindings

		@bindings.check_controls(self)

	end

	def update_centroid
		
		x = 0
		y = 0

		mass = 0

		@parts.each { |part| mass+=part.centroid_mass }

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

# Location Reference Functions

	def center

		@parts.each { |part| part.center }

	end

	def origin

		@parts.each { |part| part.origin }

	end

#  Movement Functions

	def rotate(degree)

		@parts.each { |part| part.rotate(degree) }
		
	end

	def add_force(force)

		@forces << force

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

	def add_env_forces(environment)

		add_force(environment.gravity)
		add_force(environment.drag(@velocity))

	end

# Collision Responce Functions

	def add_event(event)

		@events << event
	
	end
	
	def respond?(events)

		priority_event = nil
		faces = []
		averaged_face = Vector.new(0, 0)

		if events.length > 0

			true_querys = []
			
			events.each{ |event| 
				
				if event.query then true_querys << event end 
			}

			if true_querys.length > 0

				greatest_penetration = 0
		
				true_querys.each { |event|

					faces << event.face.unit

					if event.penetration >= greatest_penetration
						greatest_penetration = event.penetration
						priority_event = event
					end
				}

				@touching = true_querys.length

				#faces.each{ |face| 
				#	averaged_face.add(face)
				#}

				#priority_event.face = averaged_face

				respond(priority_event)
			
			end
			
		end

	end

	def respond(event)

		add_step("collision")
		add_report("#{event.check_body.name} hit #{event.against_body.name}")
			
		@velocity = impulse_vector(event.check_body_v, i_mass, event.against_body_v, event.against_body.i_mass, event.face)
		@location.add(event.mtv)
		
		add_force(event.against_part.material.friction(@velocity, event.face))
		add_force(event.check_part.material.bounce(@velocity))
		
	end

# History Functions

	def add_step(step)

		@step << step

	end

	def add_history(step)

		if @history.length == $HISTORY
			@history.shift
			@history << step
		else
			@history << step
		end

	end

	def add_report(report)

		@report << report
	
	end

# Rules

	def grounded?
		
		touched = 0.0

		@history.each { |step| 
			step.each { |event|

				if event == "collision"
					touched+=1
				end
			}
		}

		if touched/$HISTORY >= $GROUNDED
			return true
		else
			return false
		end

	end

	def resting?

		resting = 0.0

		@history.each { |step| 
			step.each { |event|

				if event == "resting"
					resting+=1
				end
			}
		}

		if resting/$HISTORY >= $RESTING
			return true
		else
			return false
		end
	
	end

	def resting_query

		velocities = []

		@history.each { |step|
			step.each { |event|
				if event.is_a? Vector
					velocities << event.mag.to_i
				end 
			}
		}		

		if velocities.length != 0
			
			average_v = velocities.sum / velocities.length

			if grounded? && @touching >= $TOUCHING && average_v <= $AVERAGE_V
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