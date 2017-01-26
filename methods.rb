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

def project(v1, v2) #project v1 onto v2

	return Vector.mult(v2, dot(v1, v2)/dot(v2, v2))

end

# Collision Methods

def collide(obj1, obj2)

	if aabb(obj1.bbox, obj2.bbox)

		obj2.groups.each { |group| 

			if aabb(obj1.bbox, group.bbox)

				group.parts.each { |part| 

					if aabb(obj1.bbox, part.bbox)	
						
						if obj1.type == "ball" && part.type == "rect" 
							
							event = ballvspoly(obj1, part.points)
							
							if event != false then return  event end

						end
					
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

# Takes a Shape "ball" and a Poly's points Array. Returns the magnitude Vector of the face of collision if true

def ballvspoly(ball, poly) 

	f_start = 0
	f_end = 1

	until f_end == poly.length do

		c = Vector.sub(ball.location.location, poly[f_start].location)
		face = Vector.sub(poly[f_end].location, poly[f_start].location)

		face_dot = dot(face.unit, c)
		face_normal_dot = dot(face.normal_unit, c)
			
		if face_dot >= 0 && face_dot < face.length && face_normal_dot > 0 &&  face_normal_dot < ball.radius
			return face
		elsif c.mag < ball.radius
			return face
		end

		f_start+=1
		f_end+=1

	end

	return false

end

# Takes a mover's velocity Vector and a face's magnitude Vector. Returns the mover's velocity Vector
# as a reflection off face's magnitude Vector

def reflect(velocity, mag) 

	n = mag.normal_unit
   
   	dot = dot(n, velocity)
   	reflect = Vector.mult(n, dot)

   	reflect.mult(-2)
   	reflect.add(velocity)

	return reflect

end

# Testing Methods

def collide_long(obj1, obj2)

	if aabb(obj1.bbox, obj2.bbox)

		obj2.groups.each { |group| 

			if aabb(obj1.bbox, group.bbox)

				group.parts.each { |part| 

					if aabb(obj1.bbox, part.bbox)	
						
						if obj1.type == "ball" && part.type == "rect" 
							
							return ballvspoly_long(obj1, part.points)

						end
					
					end
				}
			end
		}

	end

	return []

end

def ballvspoly_long(ball, poly)

	f_start = 0
	f_end = 1
	segs = []
	loops = poly.length-1

	loops.times {

		c = Vector.sub(ball.location.location, poly[f_start].location)
			c_seg = Part.seg(poly[f_start].x, poly[f_start].y, poly[f_start].x + c.x, poly[f_start].y + c.y, 0xff_ff0000)
		
		face = Vector.sub(poly[f_end].location, poly[f_start].location)
		face_mag = face.mag
		face_norm = face.normal

		face.make_unit
		face_norm.make_unit
			face_adj = face.copy
			face_normal_adj = face_norm.copy

		c_face_dot = dot(face, c)
		c_face_normal_dot = dot(face_norm, c)
		
		face.set_mag(c_face_dot)
		face_normal_adj.set_mag(c_face_normal_dot - ball.radius)
			
			c_face_seg = Part.seg(poly[f_start].x, poly[f_start].y, poly[f_start].x + face.x, poly[f_start].y + face.y, 0xff_770000)
			c_face_normal_seg_adj = Part.seg(poly[f_start].x, poly[f_start].y, poly[f_start].x + face_normal_adj.x, poly[f_start].y + face_normal_adj.y, 0xff_ff7700)

		if c_face_dot >= 0 && c_face_dot < face_mag && c_face_normal_dot > 0 &&  c_face_normal_dot < ball.radius*2

			segs << c_seg
			segs << c_face_seg
			segs << c_face_normal_seg_adj

			return segs

		elsif c.mag < ball.radius

			segs << c_seg

			return segs

		end

		f_start+=1
		f_end+=1

	}

	return segs

end