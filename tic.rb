require 'pry'
require 'pry-byebug'

class Player
  attr_accessor :pick_square, :player_type

  def pick_square(ttboard, player_indice)
    player_indice == 0 ? @player_name = "X" : @player_name = "O"
    choice = pick_number
    open = false
    until open == true
      if ttboard[choice] == "_"
        if player_indice == 0
          ttboard[choice,1] = ["X"]
        else
          ttboard[choice,1] = ["O"]
        end
        open = true
        if @player_type == "robot"
          puts "Robo-Player #{@player_name} selects space #{choice}"
        end
        return open
      end
      if @player_type == "human"
        puts "that square is taken"
      end
      choice = pick_number
    end
    return ttboard
  end

  def pick_number
    if @player_type == "human"
      puts "Player #{@player_name}, pick a square"
      choice = gets.chomp.to_i
    else
      choice = rand(0..9)
    end
    return choice
  end
end

class Display
  def show_board(ttboard)
    puts "#{ttboard[0]}|#{ttboard[1]}|#{ttboard[2]}\n#{ttboard[3]}|#{ttboard[4]}|#{ttboard[5]}\n#{ttboard[6]}|#{ttboard[7]}|#{ttboard[8]}"
  end
end

class RunGame
  attr_accessor :players, :game_board, :current_player_indice
  
  WINNING_COMBO = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

  def initialize
    @game_board = ["_","_","_","_","_","_","_","_","_",]
    @players = [Player.new,Player.new]
    @current_player_indice = 0
    @letter = ''
  end

  def current_player
    return @players[@current_player_indice]
  end

  def next_player
    @current_player_indice = (@current_player_indice+1) % @players.size   
  end

  def game_over?
    @current_player_indice == 0 ? @letter = "X" : @letter = "O"
    WINNING_COMBO.any? do |winning_set|
      if winning_set.all? {|item| @game_board[item] == @letter}      
        declare_winner
      end
    end
    tied = @game_board.all? {|space| space != "_"}
    if tied == true
      declare_cats
    end
  end
  
  def declare_winner
    puts "#{@letter}'s have won"
    play_again
  end

  def declare_cats
    puts "the game ended in a tie!"
    play_again
  end

  def play_again
    puts "do you want to play again? (y/n)"
    answer = gets.chomp
    if answer == 'y'
      go = StartGame.new
      go.which_players
      go.start_it
    else
      puts "thanks for playing!"
      exit
    end
  end
end

class StartGame
  def which_players
    puts "how many human players?"
    @player_number = gets.chomp.to_i
    if @player_number > 2
      puts "can't have more than 2 human players."
      puts "how many human players?"
      @player_number = gets.chomp.to_i
    end
    @player_number
  end

  def start_it
    newgame = RunGame.new
    display = Display.new
    case @player_number
    when 2
      newgame.players[0].player_type, newgame.players[1].player_type = "human", "human"
    when 1
      newgame.players[0].player_type, newgame.players[1].player_type = "human", "robot"
    when 0
      newgame.players[0].player_type, newgame.players[1].player_type = "robot", "robot"
    end
    newgame.current_player
    game_end = false
    until game_end == true
      display.show_board(newgame.game_board)
      newgame.current_player.pick_square(newgame.game_board, newgame.current_player_indice)

      if newgame.game_over?
        game_end = true
      end
      newgame.next_player
    end
  end
end

go = StartGame.new
go.which_players
go.start_it
