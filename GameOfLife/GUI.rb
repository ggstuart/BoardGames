module BoardGames
  module GameOfLife
    class GUI
      require 'opengl'
      require 'glut'

      def initialize(dot_size = 10.0, x = 100, y = 80)
        @dot_size = dot_size
        @session = Session.new(x, y)
        @name = "Graeme's \"Conway's Game of life\""
        
        @display = Proc.new do
          GL.Clear( GL::COLOR_BUFFER_BIT )
          GL.PushMatrix()
          GL.Begin( GL::POINTS )
            @session.height.times do |y|
              @session.width.times do |x|
                GL.Vertex2f( x.to_f * @dot_size, y.to_f * @dot_size ) if @session.board[x,y].alive?
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

      end

      def init
        GL.ClearColor( 0.0, 0.0, 0.0, 0.0 )
        GL.MatrixMode( GL::PROJECTION )
        GL.LoadIdentity()
        GLU.Ortho2D( 0.0, @dot_size * @session.width.to_f, 0.0, @dot_size * @session.height.to_f )
        GL.PointSize( @dot_size )
        GL.Enable( GL::POINT_SMOOTH )
        GL.Enable( GL::BLEND )
        GL.BlendFunc( GL::SRC_ALPHA, GL::ONE_MINUS_SRC_ALPHA )
      end



      def run!
        GLUT.Init()
        GLUT.InitDisplayMode( GLUT_DOUBLE | GLUT_RGB )
        GLUT.InitWindowSize( @dot_size.to_i * @session.width, @dot_size.to_i * @session.height )
        GLUT.InitWindowPosition( 0, 0 )
        GLUT.CreateWindow( @name )
        init
        GLUT.DisplayFunc( @display )
        GLUT.IdleFunc( @idle )
        GLUT.MainLoop()      
      end      
    end
  end
end

if __FILE__ == $0
  require "#{File.dirname(__FILE__)}/../Base"
  require "#{File.dirname(__FILE__)}/GameOfLife"
  BoardGames::GameOfLife::GUI.new.run!
end
