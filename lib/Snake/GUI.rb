module BoardGames
  module Snake
    class GUI
      require 'opengl'
      require 'glut'

      def initialize
        @dot_size = 8.0
        @session = Session.new(100, 50)
        @name = "Graeme's Snake game"
        @food_size = 12.0
        @display = Proc.new do
          GL.Clear( GL::COLOR_BUFFER_BIT )
          GL.PushMatrix()
          
          GL.PointSize( @dot_size )
          GL.Begin( GL::POINTS )
            @session.y.times do |yi|
              @session.x.times do |xi|
                GL.Vertex2f( xi.to_f * @dot_size, yi.to_f * @dot_size ) if @session[xi,yi].occupied?
              end
            end
          GL.End()

          GL.PointSize( @food_size )
          GL.Begin( GL::POINTS )
            @session.y.times do |yi|
              @session.x.times do |xi|
                GL.Vertex2f( xi.to_f * @dot_size, yi.to_f * @dot_size ) if @session[xi,yi].food > 0
              end
            end
          GL.End()


          GL.PopMatrix()
          GLUT.SwapBuffers()
        end

        @idle = Proc.new do
          @session.iterate!
          @display.call
        end

        @key = Proc.new do |key, x, y|
          case key
          when 119  #W
            @session.turn(UP)
          when 115  #S
            @session.turn(DOWN)
          when 97   #A
            @session.turn(LEFT)
          when 100  #D
            @session.turn(RIGHT)
          when 27
            exit
          else
            puts key
          end
        end
        
      end

      def init
        GL.ClearColor( 0.0, 0.0, 0.0, 0.0 )
        GL.MatrixMode( GL::PROJECTION )
        GL.LoadIdentity()
        GLU.Ortho2D( 0.0, @dot_size * @session.x.to_f, 0.0, @dot_size * @session.y.to_f )
        GL.PointSize( @dot_size )
        GL.Enable( GL::POINT_SMOOTH )
        GL.Enable( GL::BLEND )
        GL.BlendFunc( GL::SRC_ALPHA, GL::ONE_MINUS_SRC_ALPHA )
      end

      def run!
        GLUT.Init()
        GLUT.InitDisplayMode( GLUT_DOUBLE | GLUT_RGB )
        GLUT.InitWindowSize( @dot_size.to_i * @session.x, @dot_size.to_i * @session.y )
        GLUT.InitWindowPosition( 0, 0 )
        GLUT.CreateWindow( @name )
        init
        GLUT.DisplayFunc( @display )
        GLUT.IdleFunc( @idle )
        GLUT.KeyboardFunc( @key )
        GLUT.MainLoop()      
      end      
    end
  end
end

if __FILE__ == $0
  require "#{File.dirname(__FILE__)}/../Base"
  require "#{File.dirname(__FILE__)}/Snake"
  BoardGames::Snake::GUI.new.run!
end
