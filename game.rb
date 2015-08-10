class Board
  attr_accessor :inputs

  def initialize
    @inputs = Array.new(9, String.new(""))
    @inputs.each_index { |space| @inputs[space] = space + 1}
  end

  def display_board
    puts ""
    puts " #{@inputs[0]} | #{@inputs[1]} | #{@inputs[2]} "
    puts "-----------"
    puts " #{@inputs[3]} | #{@inputs[4]} | #{@inputs[5]} "
    puts "-----------"    
    puts " #{@inputs[6]} | #{@inputs[7]} | #{@inputs[8]} "
    puts ""
  end

  def mark_board(space, mark)
    @inputs[space - 1] = mark 
  end
end

class Player
  attr_accessor :name, :player_number, :mark, :wins

  def initialize(player_number)
    @player_number = player_number
    @player_number == 1 ? @mark = "X" : @mark = "O"
    @wins = 0
    ask_name
    puts "#{@name} will be #{@mark}"

  end

  def ask_name 
    print "Player #{@player_number}, what is your name? "
    @name = gets.chomp
  end

  def ask_input
    print "(#{@mark}) #{@name}'s turn. Choose an unused space to mark: "
    input = gets.chomp.to_i

    return input
  end
end

class Game
  @@total_games ||= 0

  def self.start
    @new_game = Board.new
    # For rematches, we use the same objects
    @player_1 ||= Player.new(1)
    @player_2 ||= Player.new(2)

    @@total_games += 1
    print "\nGame ##{@@total_games}\n"
    @new_game.display_board

    @first_player_turn = true
    game_loop
  end

  def self.game_loop
    while true
      if @first_player_turn
        @new_game.mark_board(@player_1.ask_input, @player_1.mark)
      else
        @new_game.mark_board(@player_2.ask_input, @player_2.mark)
      end

      # Display the updated board
      @new_game.display_board

      # Check if the player whose turn it is just won
      if @first_player_turn 
        if check_winner(@player_1.mark, @new_game.inputs)
          puts "#{@player_1.name} won!"
          @player_1.wins += 1
          break
        end
      else
        if check_winner(@player_2.mark, @new_game.inputs)
          puts "#{@player_2.name} won!"
          @player_2.wins += 2
          break
        end 
      end

      # Change player's turn
      @first_player_turn = !@first_player_turn
    end

    # Another Game
    another_game
  end

  def self.another_game()
    print "Rematch? Enter 1 to do so or any other key to look at the final results: "
    input = gets.chomp
    if input == "1"
      start
    else
      puts "#{@player_1.name}'s total wins: #{@player_1.wins}"
      puts "#{@player_2.name}'s total wins: #{@player_2.wins}"
      puts "Thanks for playing!"
    end

  end

  def self.check_winner(player_mark, board_array)
    marks = 0

    hor_start = 0
    hor_finish = 2

    ver_start = 0
    ver_finish = 6

    # Top/Mid/Bottom Rows and First/Mid/Last Columns
    3.times do
      # Horizontal / Row
      (hor_start..hor_finish).each do |i|
        marks += 1 if board_array[i] == player_mark
      end
      if marks == 3
        return true
      else
        marks = 0
        hor_start += 3
        hor_finish += 3
      end

      # Vertical / Column
      (ver_start..ver_finish).step(3) do |i|
        marks += 1 if board_array[i] == player_mark
      end
      if marks == 3
        return true
      else
        marks = 0
        ver_start += 1
        ver_finish += 1
      end
    end

    # Forward and Diagonal "\"
    (0..8).step(4) do |i|
      marks += 1 if board_array[i] == player_mark
    end
    if marks == 3
      return true
    else
      marks = 0
    end

    # Backward and Diagonal "/"
    (2..6).step(2) do |i|
      marks += 1 if board_array[i] == player_mark
    end
    if marks == 3
      return true
    else
      marks = 0
    end

    return false
  end
end

Game.start