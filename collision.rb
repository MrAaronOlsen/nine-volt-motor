class Collision

	attr_accessor :mtv
	attr_reader :collision, :collision_face, :direction

	def initialize(check_part, against_part)

		@check_part = check_part
		@velocity = @check_part.velocity

		@against_part = @against_part
		@points = against_part.points

		if check_part.type == "ball"
			@radius = check_part.radius
			@collision = ballvspoly
		end

	end

	def ballvspoly

		f_start = 0
		f_end = 1

		until f_end == @points.length do

			c = Vector.sub(@check_part.location.location, @points[f_start].location)

			if c.mag < @radius # corner
				
				face = c.normal

				@penetration = @radius - c.mag
				@mtv = get_mtv(c.mag)
				@collision_face = face

				return true

			else # side

				face = Vector.sub(@points[f_end].location, @points[f_start].location)

				face_dot = dot(face.unit, c)
			
				if dot(@check_part.velocity, face.normal) > 0
					face_normal_dot = dot(face.normal_unit_r, c)
				else
					face_normal_dot = dot(face.normal_unit, c)
				end
				
				if face_dot >= 0 && face_dot < face.length && face_normal_dot > 0 &&  face_normal_dot < @radius
				
					@penetration = @radius - face_normal_dot
					@mtv = get_mtv(face_normal_dot)
					@collision_face = face
					
					return true

				end

			end

			f_start+=1
			f_end+=1

		end

		return false

	end

	def get_mtv(face_normal_dot)

		mtv_ratio = @penetration/face_normal_dot
	
		mtv_mag = @velocity.mag*mtv_ratio
		
		mtv = @velocity.unit
		mtv.set_mag(mtv_mag)
		
		return mtv

	end

end

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