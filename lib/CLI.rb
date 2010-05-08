module BoardGames
  module CLI
    class Board < Base::Board
      def clear
        @data = (0..size).collect{Cell.new(self)}
      end
      
      def to_s
        (0...@y).collect{|r| "#{@data[r*@x, @x].join(" ")}"}.join("\n")
      end

      class Cell < Board::Cell
        def to_s
          "^"
        end
      end
      
    end#class Board
    
  end#module CLI
end#module BoardGames
