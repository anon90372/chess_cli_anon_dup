# frozen_string_literal: true

require_relative 'lib/chess'
require 'pry-byebug'

# CONSTANTS
SAVE_FILE_PATH = 'save.marshal'
MAIN_MENU_OPTIONS = {
  '1' => 'New Game',
  '2' => 'Load Game',
  '3' => 'Exit'
}.freeze

# METHODS
def saved_game?
  !File.empty?(SAVE_FILE_PATH)
end

def clear_saved_game
  File.truncate(SAVE_FILE_PATH, 0)
end

def load_game
  Marshal.load(File.read(SAVE_FILE_PATH)) # rubocop:disable Security/MarshalLoad
end

def save_game(game)
  File.write(SAVE_FILE_PATH, Marshal.dump(game))
end

def valid_coord_input?(inp)
  inp.length == 2 &&
    Chess::BOARD_FILE_MARKERS.include?(inp[0]) &&
    Chess::BOARD_RANK_MARKERS.include?(inp[1].to_i)
end

def valid_quit_input?(inp)
  inp == 'quit'
end

def valid_escape_input?(inp)
  inp == 'esc'
end

def valid_source_input?(inp, game)
  valid_coord_input?(inp) && game.move_validator.legal_source?(Chess::Coord.from_s(inp))
end

def valid_destination_input?(source_inp, destination_inp, game)
  valid_coord_input?(source_inp) &&
    valid_coord_input?(destination_inp) &&
    game.move_validator.legal_move?(
      Chess::Coord.from_s(source_inp), Chess::Coord.from_s(destination_inp)
    )
end

def prompt_for_source(game)
  loop do
    print_source_prompt(game)
    inp = gets.chomp.downcase
    return inp if valid_source_input?(inp, game) || valid_quit_input?(inp)

    puts "Invalid input: #{inp}\n\n"
  end
end

def print_source_prompt(game)
  puts "#{game.to_active_player}, it's your turn."
  puts 'Your king is in check! Your next move must remove check.' if game.check?
  print 'Select one of your squares or input "quit" to save and exit the game: '
end

def prompt_for_destination(source_inp, game)
  loop do
    print_destination_prompt(game)
    inp = gets.chomp.downcase
    return inp if valid_destination_input?(source_inp, inp, game) || valid_escape_input?(inp)

    puts "Invalid input: #{inp}\n\n"
  end
end

def print_destination_prompt(game)
  puts "#{game.to_active_player}, it's your turn."
  print 'Select a destination or input "esc" to return and select another square: '
end

def prompt_with_main_menu(options)
  loop do
    print_main_menu(options)
    inp = gets.chomp.downcase
    return inp if options.key?(inp)

    puts "Invalid input: #{inp}\n\n"
  end
end

def print_main_menu(options)
  puts 'Chess CLI by REDACTED'
  options.each { |key, val| print "#{key}) #{val}\n" }
end

def prompt_for_player_name(color)
  loop do
    print_player_name_prompt(color)
    inp = gets.chomp
    if valid_player_name_input?(inp)
      puts "Welcome, #{inp}\n\n"
      return inp
    end

    puts "Invalid input: #{inp}\n\n"
  end
end

def print_player_name_prompt(color)
  puts "Input a name for the player who will play #{color}."
  print 'The name must be between two and twelve characters inclusive: '
end

def valid_player_name_input?(inp)
  inp.length.between?(2, 12)
end

def prompt_to_create_new_game
  player_white_name = prompt_for_player_name('white')
  player_black_name = prompt_for_player_name('black')
  Chess::Game.new(
    player_white: Chess::Player.new(player_white_name, :white),
    player_black: Chess::Player.new(player_black_name, :black)
  )
end

def prompt_with_overwrite_warning
  print 'Warning: starting a new game will overwrite your saved game. Proceed? [Y/n]: '
  gets.chomp.downcase
end

def valid_confirmation_input?(inp)
  %w[y yes].include?(inp)
end

# SCRIPT

# Main menu
processed_main_menu_inp = nil
loop do # rubocop:disable Metrics/BlockLength
  main_menu_inp = prompt_with_main_menu(MAIN_MENU_OPTIONS)

  case main_menu_inp
  when '1'
    if saved_game?
      overwrite_warning_inp = prompt_with_overwrite_warning
      unless valid_confirmation_input?(overwrite_warning_inp)
        puts "Aborting...\n\n"
        next
      end
    end
    puts "Starting...\n\n"
    processed_main_menu_inp = main_menu_inp
    break

  when '2'
    if saved_game?
      puts "Loading...\n\n"
      processed_main_menu_inp = main_menu_inp
      break
    elsif !saved_game?
      puts "No saved game\n\n"
      next
    end

  when '3'
    puts "See you soon\n\n"
    exit
  end
end

# Create a new game or load a saved game
game = nil
if processed_main_menu_inp == '1'
  clear_saved_game
  game = prompt_to_create_new_game
elsif processed_main_menu_inp == '2'
  game = load_game
end

# Pre game
puts <<~HEREDOC
  Let's play chess!

  Tips:
  - Input "quit" when prompted to save and exit the game.
  - Input "esc" when prompted to return and make another selection.
  - When prompted to select a source or destination, input your desired
    algebraic coordinates, e.g. "e4".

HEREDOC
print 'Ready? Input anything to continue: '
gets.chomp
system('clear')

# Play the game
loop do
  # Evaluate win/draw conditions
  break if game.over?

  # Play a turn
  loop do
    # Select a source
    system('clear')
    game.display_board
    source_inp = prompt_for_source(game)
    if valid_source_input?(source_inp, game)
      game.select_source(Chess::Coord.from_s(source_inp))
    elsif valid_quit_input?(source_inp)
      save_game(game)
      puts "See you soon\n\n"
      exit
    end
    system('clear')

    # Select a destination
    game.display_board
    destination_inp = prompt_for_destination(source_inp, game)
    if valid_destination_input?(source_inp, destination_inp, game)
      game.play_turn(Chess::Coord.from_s(source_inp), Chess::Coord.from_s(destination_inp))
      game.deselect_source
      break if game.over?
    elsif valid_escape_input?(destination_inp)
      game.deselect_source
      next
    end
  end
end

# Post game
system('clear')
game.display_board
if game.checkmate?
  puts "#{game.to_inactive_player} wins by checkmate!"
elsif game.stalemate?
  puts 'Draw by stalemate!'
elsif game.draw_by_fifty_move_rule?
  puts 'Draw by fifty move rule!'
elsif game.draw_by_threefold_repetition_rule?
  puts 'Draw by threefold repetition!'
end
save_game(game)
