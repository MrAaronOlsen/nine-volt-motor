class Movement

    attr_accessor :location, :velocity, :acceleration, :max, :rotation

    def initialize(point)

        @location = point.location
        @velocity = Vector.new(0,0)
        @acceleration = 0
        @max = 5
        @rotation = 0

    end

    def update

        @velocity.mult(@acceleration)
        @velocity.max(@max)
        @location.add(@velocity)

    end

    def reflect(face) 

        @velocity = reflect_vector(@velocity, face)

    end

end
