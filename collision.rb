class Collision

	attr_accessor :face
	attr_reader :query, :type, :direction, :side_of_face, :penetration, :mtv,
                :face_dot, :face_norm, :face_normal_dot,   
                :check_part, :check_part_half_width, :check_body, :check_body_v,
                :against_part, :against_part_half_width, :against_body, :against_body_v

	def initialize(check_part, check_body, against_part, against_body)

		@check_part = check_part
		@check_body = check_body
		@check_body_v = check_body.velocity.copy
        @against_part = against_part
		@against_body = against_body
		@against_body_v = against_body.velocity.copy

		@direction = dot(check_body_v, against_body_v)

		if check_part.type == "ball" && against_part.type != "ball"

			@check_part_half_width = check_part.radius
			@against_part_points = against_part.points

			@query = ballvspoly
		
		elsif check_part.type == "ball" && against_part.type == "ball"

			@check_part_half_width = check_part.radius
			@against_part_half_width = against_part.radius

			@query = ballvsball

		else @query = false end

	end

	def ballvspoly

		f_start = 0
		f_end = 1

		until f_end == @against_part_points.length do

			@c = Vector.sub(@check_part.location.location, @against_part_points[f_start].location)
			@face = Vector.sub(@against_part_points[f_end].location, @against_part_points[f_start].location)
			@face_dot = dot(@face.unit, @c)

            @side_of_face = dot(@face.normal, @check_body_v)

			if @side_of_face > 0
				@face_norm = @face.normal_unit_r
			else
				@face_norm = @face.normal_unit
			end

			@face_normal_dot = dot(@face_norm, @c)

			if collide_with_face

				@type = "face"
				@penetration = (@check_part_half_width - @face_normal_dot)
		
				@mtv = get_mtv(@face_norm, @penetration)
				
				return true

			elsif collide_with_corner

				@type = "corner"
                @penetration = (@check_part_half_width - @c.mag)
				
                @face = @c.normal_r
				@face_dot = dot(@face.unit, @c)
				@side_of_face = dot(@face.normal, @check_body_v)
				@face_norm = @face.normal_unit
				@face_normal_dot = dot(@face_norm, @c)

				@mtv = get_mtv(@face_norm, @penetration)

				return true

			end

			f_start+=1
			f_end+=1

		end

		return false

	end

	def ballvsball

		@type = "ball vs ball"

		@c = Vector.sub(@check_part.location.location, @against_part.location.location)

		if collide_with_ball
			
			@face = @c.normal_r
			@side_of_face = dot(@face.normal, @check_body_v)
			@face_norm = @face.normal_unit
			@penetration = ((@check_part_half_width + @against_part_half_width) - @c.mag)
			@face_normal_dot = @check_part_half_width - @penetration

			@mtv = get_mtv(@face_norm, @penetration)

			return true
		end

		return false

	end

	def get_mtv(face_norm, penetration)

		mtv = Vector.mult(face_norm, penetration)
		mtv.mult($SLOP)

		return mtv

	end

	def collide_with_face

        if @face_dot > 0 && @face_dot < @face.length && @face_normal_dot > 0 && @face_normal_dot < @check_part_half_width
            return true
        else
            return false
        end
    
    end

    def collide_with_corner

        if @c.mag < @check_part_half_width
            return true
        else
            return false
        end
    
    end

	def collide_with_ball

		if @c.mag < @check_part_half_width + @against_part_half_width
			return true
		else
			return false
		end
	
	end

end
