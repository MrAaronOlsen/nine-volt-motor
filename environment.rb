class Environment

    attr_accessor :gravity, :drag_scaler

    def initialize(gravity = 0.0, drag = 0.0)

        @gravity = Vector.new(0, gravity.to_f)
        @drag_scaler = drag.to_f

    end

    def drag(velocity)

        drag = velocity.unit
        drag.mult(-1)
        drag.mult(drag_scaler)

        drag.mult(0) if drag.mag < 0.01
        
        return drag

    end

end