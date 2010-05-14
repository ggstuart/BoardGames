module BoardGames
  module GameOfLife
    class GUI
      require 'opengl'
      require 'glut'

      def initialize(dot_size = 7.0)
        @dot_size = dot_size
        @session = Session.new(80, 80)#(120,90)
        @shapes = ShapeWriter.new
        @alpha = AlphaWriter.new(@session[25,45])

#        @session.randomise()
#        5.times { @shapes.spaceShip(@session.randomCell) }
#        5.times { @shapes.glider(@session.randomCell) }
#        @shapes.flat(@session[40,30])
#        @shapes.dieHard(@session[40,30])
#        @shapes.acorn(@session[40,30])        
#        @shapes.f_pentomino(@session[40,30])
        @shapes.gun(@session[30,50])
#        @shapes.infinite1(@session[40,30])
#        @shapes.infinite2(@session[40,30])
#         @alpha.write!("TEXT")
        
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
          @display.call
          @session.iterate!
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
  require "#{File.dirname(__FILE__)}/Writer"
  require "#{File.dirname(__FILE__)}/ShapeWriter"
  require "#{File.dirname(__FILE__)}/AlphaWriter"
  BoardGames::GameOfLife::GUI.new.run!
end
