module Physics

    def impulse_vector(a_velocity, a_mass, b_velocity, b_mass, face) 

		direction = dot(a_velocity, b_velocity)
		
		face_norm = face.normal_unit
		rel_vel = Vector.sub(a_velocity, b_velocity)
		
		restitution = 1 + $RESTITUTION

		j = dot((Vector.mult(rel_vel, -restitution)), face_norm)/(a_mass+b_mass)

		j = Vector.mult(face_norm, j)

		j.mult(a_mass)
		j.mult(-1)

		reflection = Vector.sub(a_velocity, j)

		reflection.mult($IMPULSE)
		 		
	    return reflection

    end

end