class Collision

	attr_reader :face, :mtv_ratio, :test, :check_part, :against_part

	def initialize(check_part, against_part)

		@check_part = check_part
		
		@against_part = against_part
		@against_part_points = against_part.points

		if check_part.type == "ball"
			@half_width = check_part.radius
			@test = ballvspoly
		else @test = false end

	end

	def ballvspoly

		f_start = 0
		f_end = 1

		until f_end == @against_part_points.length do

			c = Vector.sub(@check_part.location.location, @against_part_points[f_start].location)
			@face = Vector.sub(@against_part_points[f_end].location, @against_part_points[f_start].location)

			face_dot = dot(@face.unit, c)
			face_normal_dot = dot(face.normal_unit, c)
			
			if c.mag <= @half_width && c.mag < face_normal_dot # corner
			
				@face = c.normal

				penetration = @half_width - c.mag
				@mtv_ratio = get_mtv_ratio(penetration, c.mag)
	
				return true
			
			elsif face_dot >= 0 && face_dot <= face.length && face_normal_dot >= 0 && face_normal_dot <= @half_width
			
				penetration = (@half_width - face_normal_dot)/face_normal_dot
				@mtv_ratio = get_mtv_ratio(penetration, face_normal_dot)
				
				return true

			end

			f_start+=1
			f_end+=1

		end

		return false

	end

	def get_mtv_ratio(penetration, face_normal_dot)

		return penetration/face_normal_dot

	end

end