class Player
  attr_accessor :pick_square, :human_pick

  def human_pick(ttboard, player)
    puts "pick a square"
    choice = gets.chomp.to_i
    open = false
    until open == true
      if ttboard[choice] == "A"
        if player == 0
          ttboard[choice,1] = ["X"]
        else
          ttboard[choice,1] = ["O"]
        end
        open = true
        return open
      end
      puts "that square is taken"
      puts "choose another square:"
      choice = gets.chomp.to_i
    end
    return ttboard
  end

  
  def pick_square(ttboard, player)
    choice = rand(0..9)
    open = false
    until open == true
      if ttboard[choice] == "A"
        if player == 0
          ttboard[choice,1] = ["X"]
        else
          ttboard[choice,1] = ["O"]
        end
        open = true
        return open
      end
      choice = rand(0..9)
    end
    return ttboard
  end
end

class RunGame
  attr_accessor :players, :game_board, :current_player_indice
  
  WINNING_COMBO = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

  def initialize
    @game_board = ["A","A","A","A","A","A","A","A","A",]
    @players = [Player.new,Player.new]
    @current_player_indice = 0
  end

  def current_player
    return @players[@current_player_indice]
  end

  def next_player
    @current_player_indice = (@current_player_indice+1) % @players.size   
  end

  def game_over?
    letter = ""
    @current_player_indice == 0 ? letter = "X" : letter = "O"
    WINNING_COMBO.any? do |winning_set|
      if winning_set.all? {|item| @game_board[item] == letter}      
        declare_winner(letter)
      end
    end
    tied = @game_board.all? {|space| space != "A"}
    if tied == true
      declare_cats
    end
  end
  
  def declare_winner(letter)
    puts "#{letter}'s have won"
    puts "gameboard: #{game_board}"
    play_again
  end

  def declare_cats
    puts "the game ended in a tie!"
    puts "gameboard: #{game_board}"
    play_again
  end

  def play_again
    puts "do you want to play again? (y/n)"
    answer = gets.chomp
    if answer == 'y'
      go = StartGame.new
      go.start_it
    else
      puts "thanks for playing!"
      exit
    end
  end
end

class StartGame

  def start_it
    newgame = RunGame.new
    newgame.current_player
    game_end = false
    until game_end == true
      newgame.current_player.human_pick(newgame.game_board, newgame.current_player_indice)
      if newgame.game_over?
        game_end = true
      end
      newgame.next_player
    end
  end
end

go = StartGame.new
go.start_it
