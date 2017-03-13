require "./physics"

class Body

	include Physics

	attr_reader :points, :parts, :forces, :events, :history,
						  :bbox, :centroid
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

		@points = []
		@parts = []
		@forces = []
		
		@events = []
		@history = []

		@type = "static"
		@name = ""

	end

	def set

		parts.each { |part| part.location.move(location) }
		parts.each { |part| part.update }

		update_centroid
		update_bbox
	
	end

	def i_mass

		mass == 0 ? 0 : 1/mass.to_f
	
	end	 

# Build Functions

	def add_part(part)

		parts << part
		add_points

	end

	def add_binding(binding)

		bindings = binding

	end

	def add_material(material)

		parts.each { |part| part.add_material(material) }

	end

	def add_points

		parts.each { |part| part.points.each { |point| points << point }}

	end

# Update Functions

	def update(environment)

		add_history

		if type == "mover"

			respond?
			
			add_env_forces(environment)
			apply_forces

			move

			parts.each { |part| part.location.move(location) }
			parts.each { |part| part.update }

		end

		update_centroid
		update_bbox
		
		acceleration.mult(0)
		@events = []
		@forces = []

	end

	def move

		velocity.add(acceleration)		
		velocity.max(max_v)
		
		location.add(velocity)
		
		rotate(rotation)

	end

	def update_centroid
		
		x = 0
		y = 0

		mass = 0

		parts.each { |part| mass+=part.centroid_mass }

		parts.each do |part|
			
			x = x + part.centroid.x * part.centroid_mass
			y = y + part.centroid.y * part.centroid_mass

		end
		
		@centroid = Point.new(x/mass, y/mass)

	end

	def update_bbox

		@bbox = BBox.new(points)

	end

# Location Reference Functions

	def center

		parts.each { |part| part.center }

	end

	def origin

		parts.each { |part| part.origin }

	end

#  Movement Functions

	def rotate(degree)

		parts.each { |part| part.rotate(degree) }
		
	end

	def add_force(force)

		forces << force

	end

	def add_env_forces(environment)

		add_force(environment.drag(velocity))
		
		if in_constant_contact?
			
			gravity = environment.gravity.copy
			
			gravity_scalar = [history.first.gravity_scalar-$RESTING, 0].max
			
			history[$HISTORY-1].gravity_scalar = gravity_scalar

			gravity.mult(gravity_scalar)
			add_force(gravity)
		
		else
			add_force(environment.gravity)
		end
		
	end

	def apply_force(force)

		force = Vector.mult(force, i_mass.to_f)	
		acceleration.add(force)
	
	end

	def apply_forces

		forces.each { |force| apply_force(force) }
	
	end

	def in_constant_contact?

		if history.first != nil && history[$HISTORY-1] != nil 
			return true
		else return false end 

	end

# Collision Responce Functions

	def add_event(event)

		events << event
	
	end

	def add_history

		history.shift if history.length >= $HISTORY
		history << nil

	end

	def replace_history(manifold)

		history.pop
		history << manifold

	end
	
	def respond?

		events.sort_by!(&:penetration)
		respond(events.last) if events.last != nil		

	end

	def respond(event)
		
		impulse = get_impulse(event.check_body_v, i_mass, event.against_body_v, event.against_body.i_mass, event.face, event.penetration)
		mtv = get_mtv(event.penetration, event.face)

		resolve_impulse(impulse, mtv)
		
		add_force(event.against_part.material.friction(velocity, event.face))
		add_force(event.check_part.material.bounce(velocity))
		
	end

	def resolve_impulse(impulse, mtv)

		replace_history(Manifold.new(impulse, mtv))

		@velocity = impulse
		location.add(mtv)			
		
	end

# Draw Functions

	def draw

		parts.each { |part| part.draw } 
		
	# Extra Draws

		#location.draw(0xff_ffff00, 20)
		#centroid.draw(0xff_ffffff, 8)
		#bbox.draw
		#bbox.center.draw(0xff_ffff00, 8)

	end

end