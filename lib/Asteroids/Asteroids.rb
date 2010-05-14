module BoardGames

  #the game balances efficiency with power by having finite fuel
  #high power, low efficiency means no fuel left
  #fuel tank size etc, lots of upgrades possible
  #mass is affected by weapons and armour

  module Asteroids

    module Orientation
      CLOCKWISE = 0
      ANTICLOCKWISE = 1
    end

    #mass has its effect
    #mass x speed is preserved
    #f = ma
    module Mechanics
      attr_accessor :mass, :velocity, :angular_velocity, :location, :angle
      def accelerate(force, angle)
        acceleration = force.to_f/mass.to_f
        @velocity[0] += Math.cos(angle)*acceleration
        @velocity[1] += Math.sin(angle)*acceleration
      end

      def rotate(force, direction)
        @angular_velocity ||= 0.0
        case direction
        when Orientation::CLOCKWISE
          acc = -1.0 * force.to_f/mass.to_f
        when Orientation::ANTICLOCKWISE
          acc = force.to_f/mass.to_f
        end
        @angular_velocity += acc
      end

      #[x,y]
      def speed
        Math.sqrt(@velocity[0]*@velocity[0] + @velocity[1]*@velocity[1])
#        [Math.sin(@angle) * @speed, Math.cos(@angle) * @speed]
      end
    end

    #how fast can it take on energy
    class EnergyBank
      attr_accessor :capacity, :level
      def initialize(capacity)
        @capacity = capacity
        @level = capacity
      end
      
      def empty?
        @level == 0
      end
      
      def fill(amount)
        @level += amount
        @level = @capacity if @level > @capacity
      end
      
      def takeEnergy(energy)
        result = energy > @level ? @level : energy
        @level -= result
        result
      end
      
      def to_s
        len = @capacity/100
        empty = len - (@level/100)
        "|#{'='*(len-empty)}#{' '*empty}|"
      end
    end

    class Thruster
      attr :on, true
      attr_accessor :power, :bank
      def initialize(power, bank)
        @power = power
        @efficiency = 0.5
        @bank = bank
        @on = false
      end

      def off
        @on = false
      end
      
      def burn(request = nil)
        request ||= @power
        request = @power if @power < request
        @bank.takeEnergy(@power)*@efficiency
      end
      
      def energy
        @bank.level
      end
    end


    class Ship
      include Mechanics
      def initialize(location, mass, capacity, power)
        @location = location
        @location.ship = self
        @mass = mass        
        @velocity = [0, 0]
        bank = EnergyBank.new(capacity)
        @thruster = Thruster.new(power, bank)
        @cw_thruster = Thruster.new(7, bank)
        @acw_thruster = Thruster.new(7, bank)
        @angle = 0.0
      end
    
      def thruster(direction = nil)
        if direction.nil?
          @thruster
        else
          case direction
          when Orientation::CLOCKWISE
            @cw_thruster
          when Orientation::ANTICLOCKWISE
            @acw_thruster
          end
        end
      end

      def angle
        @angle/(2*Math::PI)*360
      end
      
      def thrust
        accelerate(@thruster.burn, @angle)
      end

      def move  #change location
        rotate(@cw_thruster.burn, Orientation::CLOCKWISE) if @cw_thruster.on
        rotate(@acw_thruster.burn, Orientation::ANTICLOCKWISE) if @acw_thruster.on
        accelerate(@thruster.burn, @angle) if @thruster.on
        @location.ship = false
        @velocity[0].abs.to_i.times do
          @location = velocity[0] > 0 ? @location.up : @location.down
        end
        @velocity[1].abs.to_i.times do
          @location = velocity[1] > 0 ? @location.left : @location.right
        end
        @location.ship = self
        @angle += @angular_velocity || 0.0
        @angle %= Math::PI*2
      end

      def energy
        @thruster.energy
      end
      
#      def turn(direction)
#        case direction
#        when Orientation::CLOCKWISE
#          @angle -= (2*Math::PI)/36
#        when Orientation::ANTICLOCKWISE
#          @angle += (2*Math::PI)/36
#        end
#        @angle %= Math::PI*2
#      end
      
      def to_s
        str = "\nMass: #{mass}\nAngle: #{@angle}\nSpeed: #{speed}\nVelocity: [#{@velocity.join(', ')}]\nPower: #{@thruster.power}\nFuel: #{@thruster.bank}\n"
      end
    end
    
    
    
    
    
    class Board < Base::Board
      
      def clear
        @data = (0..size).collect{Cell.new(self)}
      end

      def to_s
        [(0...@y).collect{|r| "#{@data[r*@x, @x].join(" ")}"}, '', ''].join("\n")
      end
      
      class Cell
        include Base::Boardable
        attr :ship, true
        def initialize(board)
          @board = board
          @ship = false
        end
        
        def to_s
          @ship.nil? ? '.' : @ship.to_s
        end
        
        def occupied?
          @ship != false
        end
      end
      
    end

    class Session
      attr :x
      attr :y
      attr :ships
      def initialize(x = 400, y = 250)
        @x = x
        @y = y
        refresh
      end

      def [](x, y)
        @board[x, y]
      end

      def refresh
        @board = Board.new(@x,@y)
        @ships = [] 
        @ships << Ship.new(@board[200, 125], 100, 10000, 50)
      end

      def size
        @board.size
      end

      def size=(size)
        @x = size[0]
        @y = size[1]
        refresh
      end

      def turn(direction)
        @ships[0].turn(direction)
      end

      def thrust
        @ships[0].thrust
      end

      def iterate!
        @ships.each do |ship|
#          ship.turn
#          ship.thrust
          ship.move
        end
      end

      def iterate
        while true
          iterate
          yield @board
        end
      end
      
      def to_s
        @board.to_s
      end
    end

    
  end #module  Asteroids

end #module BoardGames


