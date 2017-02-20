class Space

  attr_reader :bodies, :report

# Initialize Functions

  def initialize

    @bodies = []
    @environment = Environment.new

    @report = []

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

    @report = []

    bodies.each { |body| 
    
      body.update(@environment) 
    
      @report << body.report

  }
    
    check_bboxes

  end

  # Report Call Backs

  def post_report

    puts @report

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

    body1.parts.each { |part1| 
    
      body2.parts.each { |part2| 
    
        if bbox_query(part1.bbox, part2.bbox)
          
          body1.add_event(Collision.new(part1, body1, part2, body2))
          body2.add_event(Collision.new(part2, body2, part1, body1))

        end
      }
    }
  end

  def bbox_query(bbox1, bbox2)

	  if bbox1.right < bbox2.left || bbox1.left > bbox2.right || bbox1.bot < bbox2.top || bbox1.top> bbox2.bot
		  return false
	  else 
		  return true
	  end

  end

# Draw Functions

  def draw

    bodies.each { |body| body.draw }

  end

end
