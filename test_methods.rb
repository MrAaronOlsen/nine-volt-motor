
def world

    world = Space.new
        world.add_body(scene)
	    world.add_body(walls)
	    world.add_body(balls)
        world.add_binding(player_binding)
		
	environment = Environment.new
		environment.gravity = Vector.new(0, 10.0)
		environment.drag = 1.0

	    world.add_environment(environment)

        return world
end

def player_binding

    player_binding = Bindings.new
        player_binding.add_name("player")
        player_binding.add_control(Gosu::KbLeft, Vector.new(-5, 0), "grounded?")
        player_binding.add_control(Gosu::KbRight, Vector.new(5, 0), "grounded?")
        player_binding.add_control(Gosu::KbUp, Vector.new(0, -100), "grounded?")

    return player_binding

end

def walls

    walls = Body.new(0, 0)
        walls.add_part(Part.seg(1150, 50, 50, 50, 0x77_777777))
        walls.add_part(Part.seg(1150, 1150, 1150, 50, 0x77_777777))
        walls.add_part(Part.seg(50, 1150, 1150, 1150, 0x77_777777))
        walls.add_part(Part.seg(50, 50, 50, 1150, 0x77_777777))

    walls.set_body

    return walls

end

def scene

    scene = Body.new(0, 0)
	
	scene.add_part(Part.tri(50, 1000, 850, 1150, 50, 1150, 0x77_777777))
	scene.add_part(Part.tri(850, 1150, 1150, 1000, 1150, 1150, 0x77_777777))
	scene.add_part(Part.tri(600, 600, 800, 800, 400, 800, 0x77_777777))
    scene.add_part(Part.rect(50, 700, 300, 50, 0x77_777777))

	scene.set_body

    return scene
    
end

def balls 
    
    balls = []

    balls << make_ball(600, 500, "player", 50, 50, 0xff_00ff00, Vector.new(0, 0))
	balls << make_ball(1100, 600, "Orange Ball", 30, 30, 0xff_ffa000, Vector.new(-10,-6))
	balls << make_ball(100, 100, "Blue Ball", 20, 20, 0xff_0000ff, Vector.new(-10, 0))
	balls << make_ball(1000, 150, "Red Ball", 70, 70, 0xff_ff0000, Vector.new(-10, 0))
	balls << make_ball(400, 300, "Yellow Ball", 200, 200, 0xff_ffff00, Vector.new(10, 0))
	balls << make_ball(150, 200, "Purple Ball", 40, 40, 0xff_ff00ff, Vector.new(-10, -5))

    return balls

end

def make_ball(x, y, name, radius, mass, color, velocity)

    ball = Body.new(x, y) 
        ball.add_part(Part.ball(0, 0, radius, color))

    ball.velocity = velocity
    ball.max_v = 20.0
    ball.mass = mass
    ball.type = "mover"
    ball.name = name

    ball.set_body

    return ball

end