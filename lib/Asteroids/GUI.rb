module BoardGames
  module Asteroids
    class GUI
      require 'opengl'
      require 'glut'

      def initialize
        @ship_size = 8.0
        @grid_size = 2.5
        @session = Session.new
        @ship = @session.ships[0]
        @name = "Graeme's Asteroids game"

        @display = Proc.new do
          GL.Clear( GL::COLOR_BUFFER_BIT )
          GL.PushMatrix()
          @session.ships.each do |ship|
            x, y = ship.location.coordinates.collect { |c| c.to_f*@grid_size }
            GL.Translate(x, y, 0.0)               #move cursor to centre of ship
            GL.Rotatef(ship.angle, 0.0, 0.0, 1.0) #rotate
            GL.Begin( GL::TRIANGLES )             #

              GL.Color3f(1.0, 1.0, 1.0)
              GL.Vertex3f( 0.0, 15.0, 0.0 )      #draw
              GL.Vertex3f( 10.0, -5.0, 0.0 )     #my
              GL.Vertex3f( -10.0, -5.0, 0.0 )    #ship
              GL.Color3f(0.1, 0.1, 0.1)
              GL.Vertex3f( 0.0, 5.0, 0.0 )      #draw
              GL.Vertex3f( 5.0, -4.0, 0.0 )     #my
              GL.Vertex3f( -5.0, -4.0, 0.0 )    #ship

              if ship.thruster.on
                GL.Color3f(1.0, 0.0, 0.0)
                GL.Vertex3f( 0.0, -(ship.thruster.power/2)-5.0, 0.0 )   #point of flame
                GL.Vertex3f( 5.0, -5.0, 0.0 )    #base of flame
                GL.Vertex3f( -5.0, -5.0, 0.0 )   #base of flame
              end

              if ship.thruster(Orientation::CLOCKWISE).on
                GL.Color3f(1.0, 0.0, 0.0)
                GL.Vertex3f( ship.thruster(Orientation::CLOCKWISE).power+10.0, -5.0, 0.0 )   #point of flame
                GL.Vertex3f( 10.0, -4.0, 0.0 )   #base of flame
                GL.Vertex3f( 10.0, -6.0, 0.0 )  #base of flame
              end

              if ship.thruster(Orientation::ANTICLOCKWISE).on
                GL.Color3f(1.0, 0.0, 0.0)
                GL.Vertex3f( -ship.thruster(Orientation::ANTICLOCKWISE).power-10.0, -5.0, 0.0 )   #point of flame
                GL.Vertex3f( -10.0, -4.0, 0.0 )   #base of flame
                GL.Vertex3f( -10.0, -6.0, 0.0 )  #base of flame
              end

            GL.End()                              #
          end
          GL.LoadIdentity()
          GL.PopMatrix()
          GLUT.SwapBuffers()
        end

        @idle = Proc.new do
          @display.call
          sleep 0.05
          @session.iterate!
        end

        @key = Proc.new do |key, x, y|
          case key.chr
          when ","
            @ship.thruster(Orientation::ANTICLOCKWISE).on = true
          when "."
            @ship.thruster(Orientation::CLOCKWISE).on = true
          when " "
            @ship.thruster.on = true
          else
            case key
            when 27
              exit
            else
              puts "#{key}: '#{key.chr}'"
            end
          end
        end

        @keyup = Proc.new do |key, x, y|
          case key.chr
          when ","
            @ship.thruster(Orientation::ANTICLOCKWISE).off
          when "."
            @ship.thruster(Orientation::CLOCKWISE).off
          when " "
            @ship.thruster.off
          end          
        end


      end

      def init
        GL.ClearColor( 0.0, 0.0, 0.0, 0.0 )
        GL.MatrixMode( GL::PROJECTION )
        GL.LoadIdentity()
        GLU.Ortho2D( 0.0, @grid_size * @session.x.to_f, 0.0, @grid_size * @session.y.to_f )
        GL.PointSize( @ship_size )
        GL.Enable( GL::POINT_SMOOTH )
        GL.Enable( GL::BLEND )
        GL.BlendFunc( GL::SRC_ALPHA, GL::ONE_MINUS_SRC_ALPHA )
      end



      def run!
        GLUT.Init()
        GLUT.InitDisplayMode( GLUT_DOUBLE | GLUT_RGB )
        GLUT.InitWindowSize( @grid_size.to_i * @session.x, @grid_size.to_i * @session.y )
        GLUT.InitWindowPosition( 0, 0 )
        GLUT.CreateWindow( @name )
        init
        GLUT.DisplayFunc( @display )
        GLUT.IdleFunc( @idle )
        GLUT.KeyboardFunc( @key )
        GLUT.KeyboardUpFunc( @keyup )
        GLUT.MainLoop()      
      end      
    end
  end
end

if __FILE__ == $0
  require "#{File.dirname(__FILE__)}/../Base"
  require "#{File.dirname(__FILE__)}/Asteroids"
  BoardGames::Asteroids::GUI.new.run!
end
