# Vector Class
# 
# Defines a vector by components x, y
# Most methods reduntant to mutate self based on vectors or scalars
# Most methods also reduntant to mutate self or process other vectors or scalars

class Vector

	attr_accessor :x, :y

	def initialize(x, y) #creates a new vector given x and y components

		@x = x
	   	@y = y

	end

	def self.from_heading(degree) #creates a new unit vector at a specific heading

      		return Vector.new(Math.cos(radian(degree)), Math.sin(radian(degree)))

    	end

    	def self.from_length(length) #creates a new vector from a length at 0 heading

    		return Vector.new(length, 0)

    	end

    	def self.from_velocity(length, heading)

    		velocity = Vector.new(1,0)
    		velocity.rotate(heading)
    		velocity.set_mag(length)
    		
    		return velocity

    	end

# Vector Math

	def add(n) #add vector or scalar to self

		if n.is_a? Vector
			@x+=n.x
			@y+=n.y
		else
			@x+=n
			@y+=n
		end

	end

	def self.add(n1, n2) #returns a new vector that is the sum of two vectors or a vector and scalar

		if n2.is_a? Vector
			return Vector.new(n1.x + n2.x, n1.y + n2.y)
		else
			return Vector.new(n1.x + n2, n1.y + n2)
		end
	
	end

	def sub(n) #subtract vector or scalar from self
		
		if n.is_a? Vector
			@x-=n.x
			@y-=n.y
		else
			@x-=n
			@y-=n
		end

	end

	def self.sub(n1, n2) #returns a new vector that is the difference of two vectors or a vector and a scalar

		if n2.is_a? Vector
			return Vector.new(n1.x - n2.x, n1.y - n2.y)
		else
			return Vector.new(n1.x - n2, n1.y - n2)
		end

	end

	def mult(n) #multiply self with vector or scalar

		if n.is_a? Vector
			@x*=n.x
			@y*=n.y
		else
			@x*=n
			@y*=n
		end

	end

	def self.mult(n1, n2) #returns a new vector that is the product of two vectors or vector and scalar

		if n2.is_a? Vector
			return Vector.new(n1.x * n2.x, n1.y * n2.y)
		else
			return Vector.new(n1.x * n2, n1.y * n2)
		end

	end

	def div(n) #devide self with vector or scalar

		if n.is_a? Vector
			@x/=n.x
			@y/=n.y
		else
			@x/=n
			@y/=n
		end

	end

	def self.div(n1, n2) #returns a new vector that is the quotient of two vectors or a vector and scalar

		if n2.is_a? Vector
			return Vector.new(n1.x / n2.x, n1.y / n2.y)
		else	
			return Vector.new(n1.x / n2, n1.y / n2)
		end

	end

# Calculations and Mutations

	def mag #calculate the magnitude of self

		Math.sqrt(@x*@x + @y*@y)

	end

	alias_method :length, :mag

	def set_mag(scalar) #set the magnitude of a self

		make_unit
		mult(scalar)

	end

	alias_method :set_length, :set_mag

 	def unit #return unit vector of self

 		return Vector.unit(self)

 	end

 	def make_unit #makes self a unit vector 

 		m = mag()

		if m != 0 then div(m) end
 	
 	end

 	def self.unit(vector) #converts passed vector to unit

 		m = vector.mag

 		if m != 0 then return Vector.div(vector, m) end

 	end

 	def normal #return normal vector of self

 		return Vector.new(@y, @x*-1)

 	end

 	def normal_r

 		return Vector.new(@y*-1, @x)

 	end

 	def make_normal #make self the normal of self

    		@x*=-1

    	end

 	def self.normal(vector) #converts passed vector to a normal of itself

 		return vector.make_normal

 	end

 	def normal_unit #return normal unit vector of self

 		return Vector.unit(normal)

 	end

 	def normal_unit_r #return right normal unit vector of self

 		return Vector.unit(normal_r)

 	end

 	def make_normal_unit # make self a normal unit of self

 		make_unit
 		make_normal

 	end

    	def self.make_normal_unit(vector) #converts passed vector to a normal unit of itself

    		vector.make_normal
    		return vector.make_unit

    	end

    	def flip # flips vector

    		@x*-1
    		@y*-1

    	end

	def max(max) #set maximum magnitude of self

		if mag > max
			set_mag(max) 
			return true
		else
			return false
		end

	end

	def min(min) #set minimum magnitude of self

		if mag < min
			set_mag(min)
			return true
		else
			return false
		end	
	
	end

	def constrain(min, max) #constrain magnitude of self by min and max value

		if mag < min then set_mag(min) end
		if mag > max then set_mag(max) end

	end

	def heading_r #calculates radian of rotation for self

		return Math.atan2(@y, @x)
    		
	end

	def heading #calculates degree of rotation for self

		radian = Math.atan2(@y, @x)
    		
    		if degree(radian) < 0
    			return degree(radian)+360
    		elsif degree(radian) > 360
    			return degree(radian)-369
    		else
    			return degree(radian)
    		end

    	end

    	def set_heading(heading)

    		vector = Vector.new(1,0)
    		vector.rotate(heading)
    		vector.set_mag(mag)

    		return vector
    	
    	end

    	def rotate_r(radian) #rotate self by a radian

		theta = radian

		x = @x

		@x = x*Math.cos(theta) - @y*Math.sin(theta)
		@y = x*Math.sin(theta) + @y*Math.cos(theta)

	end

	def rotate_around_r(radian, location) #rotate self by a radian around a location

		theta = radian

		@x-=location.x
		@y-=location.y

		x = @x

		@x = x*Math.cos(theta) - @y*Math.sin(theta)
		@y = x*Math.sin(theta) + @y*Math.cos(theta)

		@x+=location.x
		@y+=location.y

	end

	def rotate(degree) #rotate self by some degree

		theta = radian(degree)

		x = @x

		@x = x*Math.cos(theta) - @y*Math.sin(theta)
		@y = x*Math.sin(theta) + @y*Math.cos(theta)

	end

	def rotate_around(location, degree) #rotate self by a degree around a location

		axis = Vector.sub(self, location)

		axis.rotate(degree)

		rotation = Vector.add(location, axis)

		@x = rotation.x
		@y = rotation.y

	end

	def angle_between(vector) #find the angle between self and a vector in degrees

		if @x == 0 && @y == 0 then return 0 end
		if vector.x == 0 && vector.y == 0 then return 0 end

		dot = @x * vector.x + @y * vector.y

		v1mag = Math.sqrt(@x * @x + @y * @y)
		v2mag = Math.sqrt(vector.x * vector.x + vector.y * vector.y)

		amt = dot / (v1mag * v2mag)

		if amt <= -1
			return Math::PI
	 	elsif amt >= 1
			return 0
		end

		return (Math.acos(amt))*(180/Math::PI)

	end

	def lerp #linear interpolate to another vector
	end

	def dot(vector) #the dot product of self and vector

		return @x*vector.x + @y*vector.y

	end

	def project(vector) #project v1 onto v2

		return Vector.mult(vector, dot(vector)/vector.dot(vector))

	end


	def distance(vector) #finds the Euclidean distance between self and a vector
	
		return Math.sqrt(((@x-vector.x)**2) + ((@y-vector.y)**2) + ((mag-vector.mag)**2))

	end

	def copy #returns copy of self as new Vector

		return Vector.new(@x, @y)

	end

	def copy_unit #returns copy of self as new Vector unit

		return Vector.unit(self)

	end

end