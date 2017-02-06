class Test

    attr_accessor :clipboard, :to_draw

    def initialize

        @clipboard = []
        @to_draw = []

    end

    def add(test)

        clipboard << test

    end

    def run

        clipboard.each { |test| 
    
            if test.is_a? String
                puts test
            elsif test.is_a? Part
                to_draw << test
            else
                puts "Invalid Test"
            end
        }

    end

    def draw

        to_draw.each { |test| 
            test.update
            test.draw }

    end

end