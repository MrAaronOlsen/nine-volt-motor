class Collision

	attr_reader :type, :face, :face_normal_dot, :mtv, :test, :check_part, :against_part

	def initialize(check_part, against_part)

		@check_part = check_part
		
		@against_part = against_part
		
		if check_part.type == "ball" && against_part.type != "ball"

			@check_part_half_width = check_part.radius
			@against_part_points = against_part.points

			@test = ballvspoly
		
		elsif check_part.type == "ball" && against_part.type == "ball"

			@check_part_half_width = check_part.radius
			@against_part_half_width = against_part.radius

			@test = ballvsball

		else @test = false end

	end

	def ballvspoly

		f_start = 0
		f_end = 1

		until f_end == @against_part_points.length do

			c = Vector.sub(@check_part.location.location, @against_part_points[f_start].location)

			@face = Vector.sub(@against_part_points[f_end].location, @against_part_points[f_start].location)
			@face_dot = dot(@face.unit, c)
			@face_normal_dot = dot(@face.normal_unit, c)

			if @face_dot > 0 && @face_dot < @face.length && @face_normal_dot > 0 && @face_normal_dot < @check_part_half_width
			
				@type = "Face"
	
					$test.add(Part.seg(@against_part_points[f_end].location.x, @against_part_points[f_end].location.y, @against_part_points[f_start].location.x, @against_part_points[f_start].location.y, 0x77_00ff00))
					$test.add(Part.seg(@check_part.location.x, @check_part.location.y, @against_part_points[f_start].location.x, @against_part_points[f_start].location.y, 0xff_ff0000))
					$test.add(Part.seg(@check_part.location.x, @check_part.location.y, @check_part.location.x - (@face.normal_unit.x * @face_normal_dot), @check_part.location.y - (@face.normal_unit.y * @face_normal_dot), 0x77_ff00ff))
				
				@penetration = (@check_part_half_width - @face_normal_dot)
				@penetration_point = Vector.new((@check_part.location.x - (@face.normal_unit.x * @face_normal_dot)) - (@face.normal_unit.x * @penetration),
												(@check_part.location.y - (@face.normal_unit.y * @face_normal_dot)) - (@face.normal_unit.y * @penetration))

					$test.add(Part.seg(@check_part.location.x - (@face.normal_unit.x * @face_normal_dot),
									   @check_part.location.y - (@face.normal_unit.y * @face_normal_dot),
									   @penetration_point.x, @penetration_point.y, 0xff_ffff00))
				
				@mtv = get_mtv
				
				return true

			elsif c.mag < @check_part_half_width

				@type = "Corner"

				@face = c.normal_r
				@face_dot = dot(@face.unit, c)
				@face_normal_dot = dot(@face.normal_unit, c)
				
					$test.add(Part.seg(@against_part_points[f_start].location.x, @against_part_points[f_start].location.y,
									   @against_part_points[f_start].location.x+(@face.x*5),
									   @against_part_points[f_start].location.y+(@face.y*5), 0x77_00ffff))
					$test.add(Part.seg(@check_part.location.x, @check_part.location.y,
									   @against_part_points[f_start].location.x, @against_part_points[f_start].location.y, 0xff_ffff00))
				
				@penetration = @check_part_half_width - c.mag
				@penetration_point = Vector.new((@check_part.location.x - (@face.normal_unit.x * @face_normal_dot)) - (@face.normal_unit.x * @penetration),
												(@check_part.location.y - (@face.normal_unit.y * @face_normal_dot)) - (@face.normal_unit.y * @penetration))

					$test.add(Part.seg(@check_part.location.x - (@face.normal_unit.x * @face_normal_dot),
									   @check_part.location.y - (@face.normal_unit.y * @face_normal_dot),
									   @penetration_point.x, @penetration_point.y, 0xff_ffff00))

				@mtv = get_mtv

				return true

			end

			f_start+=1
			f_end+=1

		end

		return false

	end

	def ballvsball

		c = Vector.sub(@check_part.location.location, @against_part.location.location)

		if c.mag < @check_part_half_width + @against_part_half_width 
			
			@face = c.normal_r
			@penetration = (@check_part_half_width + @against_part_half_width) - c.mag
			@face_normal_dot = @check_part_half_width - @penetration
			@penetration_point = Vector.new(@check_part.location.x - (@face.normal_unit.x * @face_normal_dot),
											@check_part.location.y - (@face.normal_unit.y * @face_normal_dot))
			@mtv = get_mtv

			$test.add(Part.seg(@check_part.location.x, @check_part.location.y,
							   @against_part.location.x, @against_part.location.y, 0x77_ff0000))
			$test.add(Part.seg(@penetration_point.x, @penetration_point.y,
							   @penetration_point.x + @mtv.x, @penetration_point.y + @mtv.y, 0xff_ffff00))
			$test.add(Part.seg(@penetration_point.x + @mtv.x, @penetration_point.y + @mtv.y,
							   (@penetration_point.x + @mtv.x) - (@face.x * 5),
							   (@penetration_point.y + @mtv.y) - (@face.y * 5), 0x77_00ffff))

			return true
		end

		return false

	end

	def get_mtv

		return Vector.mult(@face.normal_unit, @penetration)
	
	end

end