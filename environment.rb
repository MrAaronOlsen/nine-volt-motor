class Environment

    attr_accessor :gravity, :drag

    def initialize(gravity = 0.0, drag = 0.0)

        @gravity = Vector.new(0, gravity.to_f)
        @drag = drag.to_f

    end

    def drag(velocity)

        drag_magnitude = @drag

        drag = velocity.unit
        drag.mult(-1)
        drag.mult(drag_magnitude)

        return drag

    end

end