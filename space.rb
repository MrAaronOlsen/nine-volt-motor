class Space

  attr_reader :bodies

  def initialize

    @bodies = []

  end

  def add_body(body)

    if body.is_a? Array
      body.each { |thing| bodies << thing }
    else
      bodies << body
    end
    
  end

  def update

    bodies.each { |body| body.update }
    test_body_bbox
    
  end

  def draw

    bodies.each { |body| body.draw }

  end

  def test_body_bbox

    check = 0

    while check < bodies.length
      
      against = check+1
      
      until against == bodies.length

        if test_aabb(bodies[check].bbox, bodies[against].bbox)
          
          test_part_bbox(bodies[check], bodies[against])
        
        end
        against+=1
      end
      check+=1
    end
  end

  def test_part_bbox(body1, body2)

    body1.parts.each { |part1| 
    
      body2.parts.each { |part2| 
    
        if test_aabb(part1.bbox, part2.bbox)
           
          body1.add_event(Collision.new(part1, part2))
          body2.add_event(Collision.new(part2, part1))

        end
      }
    }
  end

end