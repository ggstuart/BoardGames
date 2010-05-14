module BoardGames
  module GameOfLife

    module Rules
      #the fate of an entity
      #a live square will die if its lonely or overcrowded
      #a dead square will wake if its fertile
      def fate
        #REQUIREMENT
        #must define friends method
        n = friends
        @alive ? (overcrowded?(n) || lonely?(n)) : fertile?(n)
      end
      private
      #lonely squares have too few friends
      def lonely?(n)
        n < 2
      end    
      #overcrowded squares have too many friends
      def overcrowded?(n)
        n > 3
      end
      #fertile squares are surrounded by exactly three friends  
      def fertile?(n)
        n == 3
      end
    end

    #This just provides some simple functionality, not sure why its separated really
    #but it all seems to fit together and keeps the cell code clean
    module State
      Dead = ' '
      Alive = 'X'
      def alive?
        @alive
      end
      def wake!
        @alive = true
      end
      def kill!
        @alive = false
      end
      def toggle!
        @alive = !@alive
      end
      def to_s
        @alive ? Alive : Dead
      end
      def randomise(chance)
        toggle! if rand(chance) == 0
      end
    end


    #The GameOfLife::Board defines it own cells like a good BoardGames::Base::Board
    class Board < Base::Board

      attr :count

      def clear
        @data = (0..size).collect{Cell.new(self)}
        @count = 0
      end

      def killAll
        @data.each {|cell| cell.kill! }
      end

      def randomise(chance = 5)
        @data.each{|sq| sq.randomise(chance)}
      end

      def live_count
        @data.count{|sq| sq.alive?}
      end

      def iterate!
        @data.each { |sq| sq.prepare }  #prepare based on current neighbours
        @data.each { |sq| sq.execute }  #once its all done, change the state
        @count += 1                     #keep tabs of how many iterations have been done
      end

      def each
        @data.each { |cell| yield cell }
      end

      def to_s
        size_bar = bar(' ', "size: #{@x} x #{@y} = #{size}")
        count_bar = bar(' ', "iteration: #{@count}")
        str = ['', bar("_",''," "), size_bar, count_bar, bar('-'), bar(' '), (0...@y).collect{|r| "  | #{@data[r*@x, @x].join(" ")} |"}, bar('_'), ""].join("\n")
      end

      private

      def bar(char='=', start_with='', ends='|')   
        len = @x*2+1
        if start_with.length > len
          start_with = start_with[0, len]
        end
        "  #{ends}#{start_with}#{char*(len-start_with.length)}#{ends}"
      end
      
      class Cell
        include Base::Boardable #provides 'neighbours'
        include Rules           #provides 'fate'
        include State           #provides 'toggle!'

        def initialize(board, alive = false)
          @alive = alive
          @board = board
          @prepared = false
        end

        #friends are the number of live neighbours - required for GameOfLife::Rules to implement method fate
        #the neighbours method comes from the BoardGames::Base::Boardable module
        def friends
          @friends ||= neighbours.count{|sq| sq.alive?}
        end

        #determine whether I'm going to toggle and remember it but don't do it yet
        def prepare
          #this is the fate thing, its included with the Rules module
          @toggle = fate
          @prepared = true
        end

        #apply the stored transformation
        def execute
          raise NotReadyToExecute, "Call 'prepare' before 'execute'." if !@prepared
          if @toggle
            #the toggle! method comes from the State module along with a few other handy bits
            toggle!
          end
          @friends = nil
          @prepared = false
        end

        class NotReadyToExecute < StandardError #Make this a usage error of some kind, this should never be programmed
        end

      end #class Cell
      
    end #class Board

    #A session manages a board, it provides a simple interface to the world
    class Session
      attr :width
      attr :height
      attr :board
      def initialize(width = 100, height = 60, chance = 10)
        @width = width
        @height = height
        @chance = chance
        refresh
      end

      def size
        [@width, @height]
      end

      def chance=(chance)
        @chance = chance
        refresh
      end

      def size=(size)
        @width = size[0]
        @height = size[1]
        refresh
      end

      def randomise(chance)
        @chance = chance
        @board.randomise(@chance)
      end

      def refresh
        @board = Board.new(@width, @height)
        @board.randomise(@chance)
      end

      def iterate!
        @board.iterate!
      end

      def iterate(n)
        while (n -= 1) >= 0
          @board.iterate!
          yield @board
        end
      end
      
      def to_s
        @board.to_s
      end
    end #class Session
    
  end #module  GameOfLife
end #module BoardGames
