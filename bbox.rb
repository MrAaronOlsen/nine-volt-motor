# Creates an axis aligned bounding box

class BBox

	attr_reader :side, :top, :bot, :left, :right, :center

	def initialize(points)

		@side = find_sides(points)
		@center = find_center(@side)

	end

	def find_sides(points)

	x = []
	y = []

		points.each { |point|

			x << point.x
			y << point.y
		}

		@top = y.min
		@bot = y.max
		@left = x.min
		@right = x.max

	return { "top" => @top,
			 "bot" => @bot,
 	   		 "left" => @left,
			 "right" => @right }

	end

	def find_center(side)

		x = ((side["right"] - side["left"])/2)+side["left"]
		y = ((side["bot"] - side["top"])/2)+side["top"]

		return Point.new(x, y)

	end

	def draw

		Gosu.draw_line(@side["left"], @side["top"], 0x99_ff0000, @side["right"], @side["top"], 0x99_ffffff)
		Gosu.draw_line(@side["right"], @side["top"], 0x99_00ff00, @side["right"], @side["bot"], 0x99_ffffff)
		Gosu.draw_line(@side["right"], @side["bot"], 0x99_0000ff, @side["left"], @side["bot"], 0x99_ffffff)
		Gosu.draw_line(@side["left"], @side["bot"], 0x99_ffff00, @side["left"], @side["top"], 0x99_ffffff)

	end

end