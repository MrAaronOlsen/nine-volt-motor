require 'gosu'
require './nine_volt'

def world

  world = Space.new
    world.add_body(scene)
	  world.add_body(walls)
	  world.add_body(balls)
        
    world.add_environment(Environment.new(8, 0.5))

  return world

end

def walls

  walls = Body.new(0, 0)
    walls.add_part(Part.seg(1150, 50, 50, 50, 0x77_777777))
    walls.add_part(Part.seg(1150, 1150, 1150, 50, 0x77_777777))
    walls.add_part(Part.seg(50, 1150, 1150, 1150, 0x77_777777))
    walls.add_part(Part.seg(50, 50, 50, 1150, 0x77_777777))

  walls.name = "Wall"
  walls.set

  return walls

end

def scene

  scene = Body.new(0, 0)
	
    scene.add_part(Part.tri(50, 1000, 850, 1150, 50, 1150, 0x77_777777))
    scene.add_part(Part.tri(850, 1150, 1150, 1000, 1150, 1150, 0x77_777777))
    scene.add_part(Part.tri(600, 600, 800, 800, 400, 800, 0x77_777777))
    scene.add_part(Part.rect(50, 700, 300, 50, 0x77_777777))

  scene.name = "Scene"
  scene.set

  return scene
    
end

def balls 
    
  balls = []

  balls << make_ball(600, 500, "Green Ball", 50, 50, 0xff_00ff00, Vector.new(5, 15))
  balls << make_ball(1100, 600, "Orange Ball", 30, 30, 0xff_ffa000, Vector.new(-10,-6))
  balls << make_ball(159, 70, "Blue Ball", 20, 20, 0xff_0000ff, Vector.new(15, 15))
  balls << make_ball(100, 100, "Blue Ball", 20, 20, 0xff_0000ff, Vector.new(-15, 0))
  balls << make_ball(1000, 150, "Red Ball", 70, 70, 0xff_ff0000, Vector.new(-15, 0))
  balls << make_ball(400, 300, "Yellow Ball", 200, 200, 0xff_ffff00, Vector.new(15, 0))
  balls << make_ball(150, 200, "Purple Ball", 40, 40, 0xff_ff00ff, Vector.new(-15, -5))
  balls << make_ball(1000, 200, "Purple Ball", 40, 40, 0xff_ff00ff, Vector.new(15, -5))


  return balls

end


def make_ball(x, y, name, radius, mass, color, velocity)

  ball = Body.new(x, y) 
    ball.add_part(Part.ball(0, 0, radius, color))

  ball.velocity = velocity
  ball.max_v = 15.0
  ball.mass = mass
  ball.type = "mover"
  ball.name = name

  ball.set

  return ball

end

class Window < Gosu::Window

	def initialize
  
    $window_width = 1200
    $window_height = 1200

    super($window_width, $window_height, false)
    self.caption = "Example"
  
		@world = world 

 	end

	def update
    @world.update
  end

	def draw	
		@world.draw
	end

	def button_down(id)
    
    	if id == Gosu::KbEscape then close end

    end

end

Window.new.show