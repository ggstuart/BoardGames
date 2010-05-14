module BoardGames
  module GameOfLife
    #A class for drawing objects
    class ShapeWriter < Writer
      include Orientation#
#  |   NE   |   SW   |    SE   |    NW  |
#  |   # #  |  #     |      #  |  # #   |
#  | #   #  |  #   # |  #   #  |  #   # |
#  |     #  |  # #   |    # #  |  #     |
      def glider(origin, orientation = nil)
        orientation ||= Diagonals[rand(4)]
        raise InvalidOrientation, "Walkers can only go diagonally" if !Diagonals.include?(orientation)
        vert(origin, 3)
        case orientation
        when SW
          origin.down.right.right.wake!
          origin.down.down.right.wake!
        when NW
          origin.down.right.right.wake!
          origin.right.wake!
        when SE
          origin.down.left.left.wake!
          origin.down.down.left.wake!
        when NE
          origin.down.left.left.wake!
          origin.left.wake!
        end
      end

      def spaceShip(origin)
        horiz(origin.left.left.left, 4)
        vert(origin.up.up, 2)
        pattern_x(origin.up.up.up.left.left.left.left, "XOOX")
        origin.up.left.left.left.left.wake!
      end
      
      def dieHard(origin)
        horiz(origin.left.left.left, 2)
        origin.left.left.down.wake!
        horiz(origin.right.right.down, 3)
        origin.right.right.right.up.wake!
      end

      def acorn(origin)
        pattern_x(origin.down.left.left.left, "XXOOXXX")
        origin.wake!
        origin.left.left.up.wake!
      end

      def f_pentomino(origin)
        vert(origin.up, 3)
        origin.up.right.wake!
        origin.left.wake!
      end
      
      def gun(origin)
        vert(origin.up.left.left.left.left.left.left.left.left.left.left.left.left.left.left, 2)
        vert(origin.up.left.left.left.left.left.left.left.left.left.left.left.left.left, 2)
        vert(origin.up.left.left.left.left, 3)
        pattern_y(origin.up.up.left.left.left, "XOOOX")
        horiz(origin.up.up.up.left.left, 2)
        horiz(origin.down.down.down.left.left, 2)
        origin.wake!
        pattern_y(origin.up.up.right, "XOOOX")
        vert(origin.up.right.right, 3)
        origin.right.right.right.wake!
        origin = origin.right.right.right.right.right.right.up.up.up
        vert(origin, 3)
        vert(origin.right, 3)
        pattern_y(origin.right.right.up, "XOOOX")
        pattern_y(origin.right.right.up.right.right.up, "XXOOOXX")
        vert(origin.right.right.right.right.right.right.right.right.right.right.right.right.right.right, 2)
        vert(origin.right.right.right.right.right.right.right.right.right.right.right.right.right.right.right, 2)
      end
      
      def infinite1(origin)
        origin.left.left.left.left.down.down.wake!
        vert(origin.left.left.down, 2)
        vert(origin.up.up, 3)
        vert(origin.right.right.up.up.up, 3)
        origin.right.right.right.up.up.wake!
      end

      def infinite2(origin)
        pattern_x(origin.up.up.left.left, "XXXOX")
        origin.up.left.left.wake!
        horiz(origin.right, 2)
        pattern_x(origin.down.left, "XXOX")
        pattern_x(origin.down.down.left.left, "XOXOX")
      end
      
      def flat(start, orientation = nil)
        orientation ||= Majors[rand(4)]
#        pattern = "XXXXXXXOXXXOXOOOXXXOXOXXXOOOXO"
#        pattern = "XXXXXXXOXXX"
        pattern = "#{"X"*8}0#XXXXXOOOXXXOOOOOO#{"X"*7}OXXXXX"
#        pattern = "XXXOOOOOOOXXXXXXXOXXXOOOOOXXX"
        pattern.reverse! if [N, W].include?(orientation)
        case orientation
        when N, S
          5.times { start = start.up }
          pattern_y(start, pattern)
        when W, E
          5.times { start = start.left }
          pattern_x(start, pattern)
        end        
      end
       
      def randomBlock(origin, size_x, size_y = size_x)
        start = origin
        size_y.times do
          str = size_x.times.collect{ rand(2)==1 ? 'X' : 'O' }.to_s
          puts str
          pattern_x(start, str)
          start = start.down
        end
      end
    end
  end
end
