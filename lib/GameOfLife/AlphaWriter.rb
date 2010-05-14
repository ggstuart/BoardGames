module BoardGames
  module GameOfLife
    #A class for writing basic text
    class AlphaWriter < Writer
      attr :cursor, true
      def initialize(origin)
        @origin = origin
        @cursor = @origin      
      end
      
      def write!(text)
        text.each_char do |char|
          case char
          when ' '
            space
          when '.'
            point
          when '!'
            exclaim!
          when '\\'
            puts 'ESCAPE!'
          else
            raise UnsupportedCharacter, "What's a '#{char}'?" unless self.respond_to?(char)
            self.send(char) 
          end
        end
        @cursor
      end

      def space
        @cursor = @cursor.right.right.right.right.right
      end

      def tab
        @origin = @cursor.right.right.right.right.right
        @cursor = @origin
      end

      def newLine
        @origin = @origin.down.down.down.down.down.down
        @cursor = @origin
      end

      def exclaim!
        vert(@cursor, 3)
        @cursor.down.down.down.down.wake!
        @cursor = @cursor.right.right.right
      end

      def point
        @cursor.left.down.down.down.down.wake!
        @cursor.left.down.down.down.wake!
        @cursor.down.down.down.down.wake!
        @cursor.down.down.down.wake!
        @cursor = @cursor.right.right.right.right
      end
      
      def A
         ###
        #   #
        #####
        #   #
        #   #
        horiz(@cursor.left, 3)
        vert(@cursor.left.left.down, 4)
        vert(@cursor.right.right.down, 4)
        horiz(@cursor.left.down.down, 3)
        @cursor = @cursor.right.right.right.right.right.right
      end

      def B
        ####
        #   #
        ####
        #   #
        ####
        horiz(@cursor.left.down.down.down.down, 3)
        @cursor.right.right.down.down.down.wake!
        self.P
        @cursor
      end

      def C
         ###
        #   #
        #
        #   #
         ###
        vert(@cursor.left.left.down, 3)
        horiz(@cursor.left, 3)
        horiz(@cursor.left.down.down.down.down, 3)
        @cursor.right.right.down.wake!
        @cursor.right.right.down.down.down.wake!
        @cursor = @cursor.right.right.right.right.right.right
      end

      def D
        ##*#    
        #   #
        #   #
        #   #
        #### 
        self.O
        @cursor.left.left.left.left.left.left.left.left.wake!
        @cursor.left.left.left.left.left.left.left.left.down.down.down.down.wake!
      end

      def E
        #####
        #
        ####
        #
        #####
        horiz(@cursor.left.down.down.down.down, 4)
        self.F
        @cursor
      end

      def F
        #####
        #
        ####
        #
        #
        vert(@cursor.left.left, 5)
        horiz(@cursor.left, 4)
        horiz(@cursor.left.down.down, 3)        
        @cursor = @cursor.right.right.right.right.right.right        
      end

      def G
         ###
        #   
        #  ##
        #   #
         ###
        horiz(@cursor.left, 3)
        vert(@cursor.left.left.down, 3)
        horiz(@cursor.left.down.down.down.down, 3)
        horiz(@cursor.down.down.right, 2)
        @cursor.down.down.down.right.right.wake!
        @cursor = @cursor.right.right.right.right.right.right
      end

      def H
        vert(@cursor.left.left, 5)
        vert(@cursor.right.right, 5)
        horiz(@cursor.down.down.left, 3)
        @cursor = @cursor.right.right.right.right.right.right
      end

      def I
        horiz(@cursor.left.left, 3)
        vert(@cursor.left, 5)
        horiz(@cursor.down.down.down.down.left.left, 3)
        @cursor = @cursor.right.right.right.right
      end

      def J
        ###
         #
         #
         #
        #
        horiz(@cursor.left.left, 3)
        vert(@cursor.left.down, 3)
        @cursor.down.down.down.down.left.left.wake!
        @cursor = @cursor.right.right.right.right
      end
      
      def K
        #   #
        #  #
        ###
        #  #
        #   #
        vert(@cursor.left.left, 5)
        horiz(@cursor.left.down.down, 2)
        @cursor.right.right.wake!
        @cursor.right.down.wake!
        @cursor.right.down.down.down.wake!
        @cursor.right.right.down.down.down.down.wake!
        @cursor = @cursor.right.right.right.right.right.right
      end

      def L
        vert(@cursor.left.left, 5)
        horiz(@cursor.left.down.down.down.down, 4)        
        @cursor = @cursor.right.right.right.right.right.right
      end

      def M
        vert(@cursor.left.left, 5)
        vert(@cursor.right.right, 5)
        @cursor.down.left.wake!
        @cursor.down.right.wake!
        @cursor.down.down.wake!
        @cursor = @cursor.right.right.right.right.right.right
      end

      def N
        vert(@cursor.left.left, 5)
        vert(@cursor.right.right, 5)
        @cursor.down.left.wake!
        @cursor.down.down.wake!
        @cursor.down.down.down.right.wake!
        @cursor = @cursor.right.right.right.right.right.right
      end
      
      def O
         ###
        #   #
        #   #
        #   #
         ###
        horiz(@cursor.left, 3)
        horiz(@cursor.down.down.down.down.left, 3)
        vert(@cursor.down.left.left, 3)
        vert(@cursor.down.right.right, 3)
        @cursor = @cursor.right.right.right.right.right.right
      end

      def P
        ####
        #   #
        ####
        #   
        #
        vert(@cursor.left.left, 5)
        horiz(@cursor.left, 3)
        horiz(@cursor.left.down.down, 3)
        @cursor.right.right.down.wake!
        @cursor = @cursor.right.right.right.right.right.right
      end

      def Q
         #*#    
        #   #
        #   #
        #   # 
         ### #
        @cursor.right.right.right.down.down.down.down.wake!
        self.O   
        @cursor = @cursor.right     
      end

      def R
        ####
        #   #
        ####
        #   #
        #   #
        vert(@cursor.right.right.down.down.down, 2)
        self.P
        @cursor
      end

      def S
         #*##
        #   
        #####
            #
        ####
        horiz(@cursor.left, 4)
        @cursor.left.left.down.wake!
        horiz(@cursor.left.left.down.down, 5)
        @cursor.right.right.down.down.down.wake!
        horiz(@cursor.left.left.down.down.down.down, 4)
        @cursor = @cursor.right.right.right.right.right.right
      end


      def T
        #####
          #
          #
          #
          #
        horiz(@cursor.left.left, 5)
        vert(@cursor.down, 4)
        @cursor = @cursor.right.right.right.right.right.right      
      end

      def U
        vert(@cursor.left.left, 4)
        vert(@cursor.right.right, 4)
        horiz(@cursor.left.down.down.down.down, 3)        
        @cursor = @cursor.right.right.right.right.right.right
      end

      def V
        #   #
        #   #
        #   #
         # #
          #
        vert(@cursor.left.left, 3)
        vert(@cursor.right.right, 3)
        @cursor.left.down.down.down.wake!
        @cursor.right.down.down.down.wake!
        @cursor.down.down.down.down.wake!        
        @cursor = @cursor.right.right.right.right.right.right
      end

      def W
        vert(@cursor.left.left, 5)
        vert(@cursor.right.right, 5)
        @cursor.down.down.down.left.wake!
        @cursor.down.down.down.right.wake!
        @cursor.down.down.wake!
        @cursor = @cursor.right.right.right.right.right.right
      end

      def X
        #   #
         # #
          #
         # #
        #   #
        pattern_x(@cursor.left.left, 'XOOOX')
        pattern_x(@cursor.down.left, 'XOX')
        @cursor.down.down.wake!
        pattern_x(@cursor.down.down.down.left, 'XOX')
        pattern_x(@cursor.down.down.down.down.left.left, 'XOOOX')
        @cursor = @cursor.right.right.right.right.right.right
      end

      def Y
        #   #
         # #
          #
          #
          #
        pattern_x(@cursor.left.left, 'XOOOX')
        pattern_x(@cursor.down.left, 'XOX')
        vert(@cursor.down.down, 3)
        @cursor = @cursor.right.right.right.right.right.right
      end

      def Z
        #####
           #
          #
         #
        #####
        horiz(@cursor.left.left, 5)
        horiz(@cursor.down.down.down.down.left.left, 5)
        @cursor.down.right.wake!
        @cursor.down.down.wake!
        @cursor.down.down.down.left.wake!
        @cursor = @cursor.right.right.right.right.right.right
      end
    
    end

    class UnsupportedCharacter < ArgumentError
    end

  end
end
