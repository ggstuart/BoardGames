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
      
      def initialize(head, length = 4, symbol = '*', head_symbol = 'X', direction = UP)
        @length = length
        head.snake = self
        @snake = [head]
        @symbol = symbol
        @head_symbol = head_symbol
        @direction = direction
      end
      
      #to start with, just move it left
      def move
        head = next_head#random#@snake[0].left
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
      
      def to_s(cell)
        cell == head ? @head_symbol : @symbol
      end
      
      def turn
        @direction = [LEFT, RIGHT, UP, DOWN].delete_if{|dir| dir == back}[rand(3)]
      end

      def grow
        @length += rand(1)
      end
      
      private

      def head
        @snake[0]
      end
      
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
      def initialize(x = 25, y = 15, snake_count = 15)
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
          snake.turn if rand(10) >= 5
          snake.move
        end
      end

      def iterate
        while true
          @snakes.each do |snake|
            snake.turn if rand(10) >= 5
            snake.move
            yield @board.to_s
          end
        end
      end
      
#      def run
#        puts @board
#        200.times do
#          sleep 0.2
#          @snake.turn if rand(10) >= 5
#          @snake.move
#          puts @board
#        end
#      end

      def to_s
        @board.to_s
      end
    end

    class Board < Base::Board
      
      def clear
        @data = (0..size).collect{Cell.new(self)}
        addFood(10)
      end

      def randomCell
        self[rand(@x), rand(@y)]
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
          @snake.nil? ? @food > 0 ? @food.to_s : '.' : @snake.to_s(self)
        end
        
        def occupied?
          @snake != false
        end
      end
      
    end 
    
  end #of module Snake
end #of module BoardGames
