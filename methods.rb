# Vector related methods

def distance(v1, v2) #distance between v1 and v2

	return Math.sqrt(((v1.x-v2.x)**2) + ((v1.y-v2.y)**2) + ((v1.mag-v2.mag)**2))

end

def angle_between(v1, v2) #find the angle between two vectors in degrees

	if v1.x == 0 && v1.y == 0 then return 0 end
	if v2.x == 0 && v2.y == 0 then return 0 end

	dot = v1.x * v2.x + v1.y * v2.y

	v1mag = Math.sqrt(v1.x * v1.x + v1.y * v1.y)
	v2mag = Math.sqrt(v2.x * v2.x + v2.y * v2.y)

	amt = dot / (v1mag * v2mag)

	if amt <= -1
		return Math::PI
 	elsif amt >= 1
		return 0
	end

	return (Math.acos(amt))*(180/Math::PI)

end

def radian(degree) #convert a degree to a radian

		return degree*(Math::PI/180)

end

def degree(radian) #convert a radian to a degree

	return radian*(180/Math::PI)

end

def dot(v1, v2) #the dot product of two vectors

	return v1.x*v2.x + v1.y*v2.y

end

# Collision Related Methods

def bbox_collide(obj1, obj2)

	if aabb(obj1.bbox, obj2.bbox)

		obj2.groups.each { |group| 

			if aabb(obj1.bbox, group.bbox)

				group.parts.each { |part| 

					if aabb(obj1.bbox, part.bbox)	
						
						return part
					
					end
				}
			end
		}

	end

	return false

end

def aabb(bbox1, bbox2)

	if bbox1.right < bbox2.left || bbox1.left > bbox2.right || bbox1.bot < bbox2.top || bbox1.top> bbox2.bot
		return false
	else 
		return true
	end

end

def reflect(velocity, mag) 

	n = mag.normal_unit
   
   	dot = dot(n, velocity)
   	reflect = Vector.mult(n, dot)

   	reflect.mult(-2)
   	reflect.add(velocity)

	return reflect

end