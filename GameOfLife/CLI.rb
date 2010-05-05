module BoardGames
  module GameOfLife
    class CLI
    
      class InvalidRequest < StandardError
      end
    
      def initialize
        @session = Session.new()
        @name = "Graeme's \"Conway's Game of life\""
        @cursor = 'GOL>>'
        @active = true
        @iterations = 50
      end

      #this one does an infinite loop
      def run!
        intro
        while @active
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
        input = getInput("What now? [s]ize, [r]andomise, [i]terate", 'i')
        case input
        when /^s$/i
          getSize
        when /^s\d{1,}x\d{1,}$/i
          input = input.split(/s/i)[1]
          @session.size = parseSize(input)
        when /^r$/i
          getSeed
        when /^r\d{1}$/i
          @session.chance = 11 - input.split(/r/i)[1].to_i
        when /^i$/i
          getIterate
          iterate
        when /^i\d{1,}$/
          @iterations = input.split(/i/i)[1].to_i        
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
      
      def getSeed
        while true
          input = getInput("Seed [0-9]", '0')
          if input =~ /\d{1}/
            @session.chance = 11 - input.to_i
            break
          end
        end
      end

      def getIterate
        while true
          input = getInput("How many iterations?", @iterations.to_s)
          if input =~ /\d{1,}/
            @iterations = input.to_i
            break
          end
        end
      end

      def iterate
        w, h = @session.size
        spf = case w*h
        when 0..500
          0.05
        when 501..1500
          0.1
        when 1501..2000
          0.15
        else
          0.2
        end
        begin
          @session.iterate(@iterations) do |str|
            begin
              puts str
              sleep spf
            rescue Interrupt
              puts ''
              break unless ['Y', 'y', 'Yes'].include?(getInput('Iteration was interrupted. Continue? [y/n]'))
              puts ''
            end
          end
        rescue Interrupt
          
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
        puts "Graeme's \"Conway's Game of life\""
        puts "====================================="
        puts ''
        puts ''
        exit(1)
      end    
    end
  end
end
