class Material

    attr_accessor :mu

    def initialize(mu = 0, bounce = 0)

        @mu = mu
        @bounce = bounce

    end

    def friction(velocity, face)
        
        friction_mag = Vector.mult(face.normal_unit, @mu)
        
        friction = velocity.unit
        friction.mult(friction_mag)
        friction.mult(-1)

        return friction

    end

    def bounce(velocity)

        bounce_mag = Vector.mult(velocity.unit, @bounce)

        return bounce_mag

    end

end