module BoardGames

  module Base
    #A Boardable object can be placed in a board
    #It is given a fixed position in the board
    #It can find its neighbours by asking the board
    module Boardable
      #MUST have a @board instance variable
      def coordinates
        @coordinates ||= @board.coordinates(self)
      end
      def up
        @up ||= @board.up(self)
      end
      def down
        @down ||= @board.down(self)
      end
      def left
        @left ||= @board.left(self)
      end
      def right    #trivial example, copy don't inherit
        @right ||= @board.right(self)
      end
      #cacheing means changes to cell location are ignored
      def neighbours
        @neighbours ||= [up.left, up, up.right, left, right, down.left, down, down.right]
      end
    end #of module Boardable


    #Example of a board
    #It is a lovely collection of boardable objects
    #It maintains @data
    #Critically, it provides the stuff boardable objects need
    class Board
      def initialize(x, y)
        @x = x
        @y = y
        clear
      end
      
      def clear
        @data = (0..size).collect{Cell.new(self)}
      end
    
      def size
        @x*@y
      end

      def [](x, y)
        @data[(y % @y)*@x+(x % @x)]
      end

      def randomCell
        self[rand(@x), rand(@y)]
      end

      def coordinates(cell)
        i = @data.index(cell)
        raise  CantFindCell, 'The cell you are looking for is not in this arena.' if i.nil?
        x = i % @x
        y = (i-x)/@x
        [x, y]
      end

      def up(cell)
        x, y = cell.coordinates
        self[x,y+1]
      end

      def down(cell)
        x, y = cell.coordinates
        self[x,y-1]
      end

      def left(cell)
        x, y = cell.coordinates
        self[x-1,y]
      end

      def right(cell)
        x, y = cell.coordinates
        self[x+1,y]
      end  
      
      class CantFindCell < StandardError
      end
      
      #trivial example, copy don't inherit
      class Cell
        include Boardable
        def initialize(board)
          @board = board
        end
      end

    end 
  end #of module Base
end #of module BoardGames

