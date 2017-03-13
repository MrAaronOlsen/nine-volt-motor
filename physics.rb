module Physics

  def get_impulse(a_vel, a_i_mass, b_vel, b_i_mass, face, penetration) 

		face_norm = face.normal_unit
		rel_vel = Vector.sub(a_vel, b_vel)
		vel_along_normal = dot(rel_vel, face.normal)	
		
		return a_vel if vel_along_normal > 0
		return Vector.new(0,0) if a_vel.mag < 0.01
		
		restitution = 1 + $RESTITUTION

		j = dot((Vector.mult(rel_vel, -restitution)), face_norm)/(a_i_mass+1*b_i_mass)
		j = Vector.mult(face_norm, j)
		j.mult(-a_i_mass*$IMPULSE)

		impulse = Vector.sub(a_vel, j)		
			
		return impulse

  end

	def get_mtv(penetration, face)

		Vector.mult(face.normal_unit, [penetration-$SLOP, 0].max)
		
	end

end