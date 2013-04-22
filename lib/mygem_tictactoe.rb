
class Gato

  module Patrones

    Ganando =
      [[(/ OO....../),0],[(/O..O.. ../),6],
       [(/......OO /),8],[(/.. ..O..O/),2],
       [(/ ..O..O../),0],[(/...... OO/),6],
       [(/..O..O.. /),8],[(/OO ....../),2],
       [(/ ...O...O/),0],[(/..O.O. ../),6],
       [(/O...O... /),8],[(/.. .O.O../),2],
       [(/O O....../),1],[(/O.. ..O../),3],
       [(/......O O/),7],[(/..O.. ..O/),5],
       [(/. ..O..O./),1],[(/... OO.../),3],
       [(/.O..O.. ./),7],[(/...OO .../),5]]

    Bloqueando =
      [[(/  X . X  /),1],[(/ XX....../),0],[(/X..X.. ../),6],
       [(/......XX /),8],[(/.. ..X..X/),2],[(/ ..X..X../),0],
       [(/...... XX/),6],[(/..X..X.. /),8],[(/XX ....../),2],
       [(/ ...X...X/),0],[(/..X.X. ../),6],[(/X...X... /),8],
       [(/.. .X.X../),2],[(/X X....../),1],[(/X.. ..X../),3],
       [(/......X X/),7],[(/..X.. ..X/),5],[(/. ..X..X./),1],
       [(/... XX.../),3],[(/.X..X.. ./),7],[(/...XX .../),5],
       [(/ X X.. ../),0],[(/ ..X.. X /),6],[(/.. ..X X /),8],
       [(/ X ..X.. /),2],[(/  XX.. ../),0],[(/X.. .. X /),6],
       [(/.. .XX   /),8],[(/X  ..X.. /),2],[(/ X  ..X../),0],
       [(/ ..X..  X/),6],[(/..X..  X /),8],[(/X  ..X.. /),2]]

    Gano =
      [[(/OOO....../),:O], [(/...OOO.../),:O],
       [(/......OOO/),:O], [(/O..O..O../),:O],
       [(/.O..O..O./),:O], [(/..O..O..O/),:O],
       [(/O...O...O/),:O], [(/..O.O.O../),:O],
       [(/XXX....../),:X], [(/...XXX.../),:X],
       [(/......XXX/),:X], [(/X..X..X../),:X],
       [(/.X..X..X./),:X], [(/..X..X..X/),:X],
       [(/X...X...X/),:X], [(/..X.X.X../),:X]]
  end


  def initialize
    @mapa = [].fill(0, 9) { " " }
    @jugadores = { :X => 'X', :O => 'O' }
    @turno = :X
  end


  def jugar
    banderaGanadora = false
    9.times do
      if @turno === :X
        mostrar
        movimientoJugador
      else
        movimientoCPU
      end
      ganador = posibleGanador
      unless ganador.nil?
        mostrar
        print "\n#{ganador} es el ganador!\n"
        banderaGanadora = true
        break
      end
      @turno = (@turno === :X) ? :O : :X
    end
    if (!banderaGanadora)
      mostrar
      print "\nJuego empate.\n"
    end
  end


  private

  def movimientoJugador  
    print "Haga su movimiento por favor [0-8]: "
    movimientoPosicion = gets.chomp.to_i
    unless (0..8) === movimientoPosicion
      print "\nMovimiento invalido: #{movimientoPosicion}. Por favor re-intentar.\n"
      movimientoJugador
      return
    end
    if @mapa.at(movimientoPosicion) != ' '
      print "\nEspacio ocupado. Por favor re-intentar.\n"
      movimientoJugador
      return
    end
    movimiento movimientoPosicion, 'X'
  end


  def movimientoCPU
    movimientoPosicion = movimientoPatronGanando
    if movimientoPosicion.nil?
      movimientoPosicion = movimientoPatronBloqueando
      if movimientoPosicion.nil?
        movimientoPosicion = primerMovimiento
      end
    end
    movimiento movimientoPosicion, 'O'
  end


  def movimiento(pos, piece)
    @mapa.delete_at(pos)
    @mapa.insert(pos, piece)
  end


  def mostrar
    print "\n\n"
    print " #{@mapa[0]} |"
    print " #{@mapa[1]} |"
    print " #{@mapa[2]}"
    print "\n---+---+---\n"
    print " #{@mapa[3]} |"
    print " #{@mapa[4]} |"
    print " #{@mapa[5]}"
    print "\n---+---+---\n"
    print " #{@mapa[6]} |"
    print " #{@mapa[7]} |"
    print " #{@mapa[8]}"
    print "\n\n"
  end


  def posibleGanador
    symbol = nil
    array = Patrones::Gano.find { |p| p.first =~ @mapa.join }
    unless array.nil?
      symbol = (array.last === :X) ? 'X' : 'O'
    end
    symbol
  end


  def movimientoPatronGanando
    movimientoPosicion = nil
    array = Patrones::Ganando.find { |p| p.first =~ @mapa.join }
    unless array.nil?
      movimientoPosicion = array.last
    end
    movimientoPosicion
  end


  def movimientoPatronBloqueando
    movimientoPosicion = nil
    array = Patrones::Bloqueando.find { |p| p.first =~ @mapa.join }
    unless array.nil?
      movimientoPosicion = array.last
    end
    movimientoPosicion
  end


  def primerMovimiento
    if @mapa.at(4) == ' '
      movimientoPosicion = 4
    else
      movimientoPosicion = @mapa.index(' ')
    end
    movimientoPosicion
  end
end


if __FILE__ == $0
  print "Digite su nombre: "
  nombre = gets.chomp
  print "\n\n#{nombre} Usted es X."
  Gato.new.jugar
end



