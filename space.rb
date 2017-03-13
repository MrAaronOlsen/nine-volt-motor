class Space

  attr_reader :bodies, :environment

# Initialize Functions

  def initialize(gravity = 5)

    @bodies = []
    @environment = Environment.new

  end

  # Build Functions

  def add_body(body)

    if body.is_a? Array
      body.each { |thing| bodies << thing }
    else
      bodies << body
    end
    
  end

  def add_environment(environment)

    @environment = environment

  end

  # Update Functions

  def update

    bodies.each { |body| body.update(environment) }
    
    check_bboxes
    
  end


  # Bounding Box Checks

  def check_bboxes

    check = 0
 
    while check < bodies.length
      
      against = check+1
      
      until against == bodies.length

        if bbox_query(bodies[check].bbox, bodies[against].bbox)
          
          check_part_bboxes(bodies[check], bodies[against])
        
        end
        against+=1
      end
      check+=1
    end
  end

  def check_part_bboxes(body1, body2)

    body1.parts.each do |part1| 
    
      body2.parts.each do |part2| 
    
        if bbox_query(part1.bbox, part2.bbox)
          
          body1_col = Collision.new(part1, body1, part2, body2)
          body2_col = Collision.new(part2, body2, part1, body1)

          body1.add_event(body1_col) if body1_col.query
          body2.add_event(body2_col) if body2_col.query

        end
        
      end
    end
  end

  def bbox_query(bbox1, bbox2)

	  if bbox1.right < bbox2.left || bbox1.left > bbox2.right || bbox1.bot < bbox2.top || bbox1.top> bbox2.bot
		  return false
	  else 
		  return true
	  end

  end

# Constraints

  def constrain(object, vector)

    bodies.each { |body| 
      if body == object 
        
        puts ""
        puts object.velocity.mag
        puts body.velocity.mag
        body.velocity.add(vector)
        puts body.velocity.mag
        puts ""

      end 
    }

  end

# Draw Functions

  def draw

    bodies.each { |body| body.draw }

  end

end
