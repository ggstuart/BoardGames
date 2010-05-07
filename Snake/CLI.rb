module BoardGames
  module Snake
    class CLI
    
      class InvalidRequest < StandardError
      end

      def initialize
        @session = Session.new()
        @name = "Graeme's \"Snake game\""
        @cursor = 'Snake>>'
      end

      #this one does an infinite loop
      def run!
        intro
        while true
          begin
            main
          rescue InvalidRequest => e
            puts "#{e.message} is not a valid command"
          end
        end
      end

      private

      #the main method displays a menu and controls the session with user input
      def main
        input = getInput("What now? [s]ize, [r]un", 'r')
        case input
        when /^s$/i
          getSize
        when /^s\d{1,}x\d{1,}$/i
          input = input.split(/s/i)[1]
          @session.size = parseSize(input)
        when /^r$/i
          iterate
        else
          raise InvalidRequest, input
        end
        puts @session.to_s
      end

      def parseSize(input)
        input.split('x').collect{|str| str.to_i}
      end

      def getSize
        size = @session.size
        while true
          input = getInput("Enter size as <width>x<height>", "#{size[0]}x#{size[1]}")
          if input =~ /^\d{1,}x\d{1,}$/i
            @session.size = parseSize(input)
            break
          end
        end
      end

      def iterate
        @session.iterate() do |str|
          begin
            puts str
            sleep 0.2
          rescue Interrupt
            puts ''
            break unless ['Y', 'y', 'Yes'].include?(getInput('Game interrupted. Continue? [y/n]'))
            puts ''
          end
        end
      end


      def getInput(prompt, default=nil)
        begin
          prompt << " (default: #{default})" if !default.nil?
          puts ''
          puts "#{@cursor}#{prompt}"
          print @cursor
          result = gets.chomp!
          quit if ['Quit', 'Exit', 'Q', 'q', 'exit', 'quit', 'x', 'X'].include?(result)
          result = default if result == ''
          result
        rescue Interrupt
          if ['Y', 'y', 'Yes', 'yes'].include?(getInput('Quit? [y/n]'))
            quit
          else
            retry
          end
        end
      end

      def intro
        puts ''
        puts ''
        puts "====================================="
        puts 'Welcome to...'
        puts @name
        puts "====================================="
        puts @session.to_s
      end

      def quit
        puts ''
        puts "====================================="
        puts "Thank's for trying"
        puts @name
        puts "====================================="
        puts ''
        puts ''
        exit(1)
      end
      
    end #class CLI
  end #module Snake
end #module BoardGames


if __FILE__ == $0
  require "#{File.dirname(__FILE__)}/../Base"
  require "#{File.dirname(__FILE__)}/GameOfLife"
  BoardGames::GameOfLife::CLI.new.run!
end
