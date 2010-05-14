module BoardGames

  #Snake is simple but needs careful thought
  #A snake is a list of cells
  #the snake cell must be different when it's part of a snake
  #So the cell should know about any snake they are part of.
  #The cell detects collisions and tells the snake to lose a life
  #control via keypress stuff is handled in the interface

  module Snake
    LEFT = 1
    RIGHT = 2
    UP = 3
    DOWN = 4
    
    #a snake is implemented as an array of cells acting as a filo stack
    #Snakes know about each other in class veriables
    
    class Snake
      def initialize(head, length = 4, direction = UP)
        @length = length
        head.snake = self
        @snake = [head]
        @direction = direction
      end
      
      def move
        head = next_head
        head.snake = self
        @length += head.food
        head.food = 0
        @snake = [head, @snake].flatten
        while @snake.length > @length
          @snake.pop.snake = false
        end
      end

      def includes?(cell)
        @snake.includes?(cell)
      end
            
      def turn(direction = nil)
        @direction = direction || [LEFT, RIGHT, UP, DOWN].delete_if{|dir| dir == back}[rand(3)]
      end

      def grow
        @length += rand(1)
      end

      def to_s
        "0#{(@length-1)*'#'}"
      end

      def head
        @snake[0]
      end
      
      private
            
      def next_head
        h = @snake[0]
        case @direction
        when LEFT
          h.left
        when RIGHT
          h.right
        when UP
          h.up
        when DOWN
          h.down
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
        h = @snake[0]
        [h.left, h.up, h.right, h.down]
      end
      
      def random
        options[rand(4)]
      end
    end

    class Session
      attr :x
      attr :y
      def initialize(x = 25, y = 15, snake_count = 1)
        @x = x
        @y = y
        @snake_count = snake_count
        refresh
      end

      def [](x, y)
        @board[x, y]
      end

      def refresh
        @board = Board.new(@x,@y)
        @snakes = []
        @snake_count.times do
          @snakes << Snake.new(@board[0, 0], 10)
        end
      end

      def size
        @board.size
      end

      def size=(size)
        @x = size[0]
        @y = size[1]
        refresh
      end

      def iterate!
        @snakes.each do |snake|
          snake.move
        end
      end

      def turn(direction = nil)
        @snakes[0].turn(direction)
      end

      def iterate
        while true
          @snakes.each do |snake|
            snake.move
            yield @board.to_s
          end
        end
      end
      
      def to_s
        @board.to_s
      end
    end

    class Board < Base::Board
      
      def clear
        @data = (0..size).collect{Cell.new(self)}
        addFood(10)
      end

      def addFood(n)
        while n > 0
          if (i = rand(n+1)) > 0
            i = i<=2 ? i : 2
            c = randomCell
            c.food = c.food + i
            n -= i
          end
        end
      end

      def to_s
        [(0...@y).collect{|r| "#{@data[r*@x, @x].join(" ")}"}, '', ''].join("\n")
      end
      
      class Cell
        include Base::Boardable
        attr :food, true
        attr :snake, true
        def initialize(board)
          @board = board
          @food = 0
          @snake = false
        end
        
        def to_s
          if !@snake 
            (@food > 0 ? @food.to_s : '.')
          else
            (@snake.head == self ? '0' : '#')
          end
        end
        
        def occupied?
          @snake != false
        end
      end
      
    end 
    
  end #of module Snake
end #of module BoardGames
