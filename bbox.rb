# Creates an axis aligned bounding box

class BBox

	attr_reader :top, :bot, :left, :right, :center

	def initialize(points)

		find_sides(points)
		find_center

	end

	def find_sides(points)

		x = []
		y = []

		points.each { |point| x << point.x ; y << point.y }

		@top = y.min
		@bot = y.max
		@left = x.min
		@right = x.max

	end

	def find_center

		x = ((right - left)/2)+left
		y = ((bot - top)/2)+top

		@center = Point.new(x, y)

	end

	def draw

		Gosu.draw_line(left, top, 0x99_ff0000, right, top, 0x99_ffffff)
		Gosu.draw_line(right, top, 0x99_00ff00, right, bot, 0x99_ffffff)
		Gosu.draw_line(right, bot, 0x99_0000ff, left, bot, 0x99_ffffff)
		Gosu.draw_line(left, bot, 0x99_ffff00, left, top, 0x99_ffffff)

	end

end