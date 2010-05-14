module BoardGames
  module GameOfLife
    #general methods useful for building complex shapes
    class Writer
      private
      def horiz(start, n)
        n.times do
          start.wake!
          start = start.right
        end
      end
      def vert(start, n)
        n.times do
          start.wake!
          start = start.down
        end
      end      
      def pattern_x(start, str)
        str.each_char do |ch|
          start.wake! if ch == 'X'
          start = start.right
        end
      end
      def pattern_y(start, str)
        str.each_char do |ch|
          start.wake! if ch == 'X'
          start = start.down
        end
      end
    end
  end
end
