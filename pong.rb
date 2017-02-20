require 'gosu'
require './nine_volt'
require './test_methods'

class Color

    class << self
 
        def tan
            0xff_BF9565
        end

        def blue
            0xff_3A8EB2
        end

        def light_blue
            0xff_87DBFF
        end

    end

end

def build_world

    world = Space.new
    
    world.add_body(level)
    
    world.add_body(paddle(200, $HEIGHT/2, "paddle_l"))
    world.add_body(paddle($WIDTH-200, $HEIGHT/2, "paddle_r"))
    world.add_body(ball)

	world.add_environment(Environment.new(0, 0))

    return world

end

def level

    level = Body.new(0, 0)
    level.add_part(Part.rect(0, 0, $WIDTH, 50, Color.tan, 1))
    level.add_part(Part.rect($WIDTH-50, 0, 50, $HEIGHT, Color.tan, 1))
    level.add_part(Part.rect(0, 0, 50, $HEIGHT, Color.tan, 1))
    level.add_part(Part.rect(0, $HEIGHT-50, $WIDTH, 50, Color.tan, 1))

    level.name = "wall"

    level.set

    return level

end

def ball

    ball = Body.new($WIDTH/2, $HEIGHT/2)

    ball.add_part(Part.ball(0, 0, 30, Color.light_blue))
    ball.name = "ball"
    ball.type = "mover"
    ball.mass = 5
    ball.max_v = 15
    ball.velocity = Vector.new(-10, 2)

    ball.add_material(Material.new(0, 20))

    ball.center
    ball.set

    return ball

end

def paddle(x, y, name)

    paddle = Body.new(x, y)
    paddle.add_part(Part.rect(0, 0, 50, 200, Color.blue, 1))
   
    paddle.name = name

    paddle.type = "mover"
    paddle.mass = 10
    paddle.max_v = 10
    
    if name == "paddle_l"
        paddle.add_binding(paddle_l_bindings)
    elsif name == "paddle_r"
        paddle.add_binding(paddle_r_bindings)
    end

    paddle.set

    return paddle

end

def paddle_l_bindings

    paddle = Bindings.new

    paddle.add_control(Gosu::KbW, Vector.new(0, -10))
    paddle.add_control(Gosu::KbS, Vector.new(0, 10))

    return paddle

end

def paddle_r_bindings 

    paddle = Bindings.new

    paddle.add_control(Gosu::KbUp, Vector.new(0, -10))
    paddle.add_control(Gosu::KbDown, Vector.new(0, 10))

    return paddle

end

def game_update

    #@world.post_report

    @world.report.each { |body_report|

        body_report.each{ |report|

            if report == "ball hit paddle_l"
                puts "Ball Hit Left Paddle"
            elsif report == "ball hit paddle_r"
                puts "Ball Hit Right Paddle"
            end
        }
    }

end

class Window < Gosu::Window

	def initialize
  
	  	$WIDTH = 1200
	  	$HEIGHT = 1200

        $IMPULSE = 1
        $RESTITUTION = 1

	   	super($WIDTH, $HEIGHT, false)
	   	self.caption = "Pong"

        @world = build_world

        @points = 0

 	end


	def update

        @world.update
        game_update

	end

	def draw

        @world.draw

	end

	def button_down(id)
    
    	if id == Gosu::KbEscape then close end

    end

end

Window.new.show