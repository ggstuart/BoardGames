module BoardGames

  #Snake is simple but needs careful thought
  #A snake is a list of cells
  #the snake cell must apear different when it's part of a snake
  #So the cell should know about any snake they are part of.

  module Snake
    
    #a snake is implemented as an array of cells acting as a filo stack
    #Snakes know about each other in class veriables
    
    class Snake

      LEFT = 1
      RIGHT = 2
      UP = 3
      DOWN = 4
      
      def initialize(head, symbol, direction = UP)
        @length = 4
        head.snake = self
        @snake = [head]
        @symbol = symbol
        @direction = direction
      end
      
      #to start with, just move it left
      def move
        head = next_head#random#@snake[0].left
        head.snake = self
        @snake = [head, @snake].flatten
        while @snake.length > @length
          i = @snake.pop
          i.snake = nil
        end
      end
            
      def includes?(cell)
        @snake.includes?(cell)
      end
      
      def to_s
        @symbol
      end
      
      def turn
        @direction = [LEFT, RIGHT, UP, DOWN].delete_if{|dir| dir == back}[rand(3)]
      end

      def grow
        @length += rand(1)
      end
      
      private
      
      def next_head
        head = @snake[0]
        case @direction
        when LEFT
          head.left
        when RIGHT
          head.right
        when UP
          head.up
        when DOWN
          head.down
        end
      end
            
      def back
        case @direction
        when LEFT
          RIGHT
        when RIGHT
          LEFT
        when UP
          DOWN
        when DOWN
          UP
        end
      end
         
      def options
        head = @snake[0]
        [head.left, head.up, head.right, head.down]
      end
      
      def random
        options[rand(4)]
      end
    end

    class Session
      def initialize(x,y)
        @board = Board.new(x,y)
        @snake = Snake.new(@board[9,5], 'S')
      end
      
      def run
        puts @board
        100.times do
          sleep 0.05
          @snake.turn
          @snake.move
          puts @board
        end
      end
    end

    class Board < Base::Board
      
      def clear
        @data = (0..size).collect{Cell.new(self)}
      end

      def to_s
        [(0...@y).collect{|r| "#{@data[r*@x, @x].join(" ")}"}, '', ''].join("\n")
      end
      
      class Cell
        include Base::Boardable
        attr :snake, true
        def initialize(board)
          @board = board
        end
        
        def to_s
          @snake.nil? ? '.' : @snake.to_s
        end
        
        def occupied?
          @snake.nil?
        end
      end
      
    end 



    
  end #of module Snake
end #of module BoardGames
