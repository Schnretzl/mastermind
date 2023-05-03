require 'colorize'

MAX_GUESSES = 12

class Board
  attr_accessor :code
  attr_reader :answer

  def initialize(code)
    @code = code
    @answer = []
  end

  def check_guess(guess)
    @answer.clear
    check_correct_locations(guess)
    check_incorrect_locations(guess)
    display_guess_and_answer(guess)
  end

  def correct?(guess)
    guess == @code
  end

  private

  def display_guess_and_answer(guess)
    char_to_color_key = { 'r' => :red, 'b' => :blue, 'y' => :yellow, 'o' => :orange, 'g' => :green, 'p' => :purple, 'w' => :white }

    guess_display = guess.split('').map { |char| char.colorize(:background => char_to_color_key[char]) }.join(' ')
    answer_display = @answer.map { |char| char.colorize(:background => char_to_color_key[char]) }.join(' ')

    puts "#{guess_display}   #{answer_display}"
  end

  def check_correct_locations(guess)
    guess.split('').each_with_index do |color, index|
      if color == @code[index]
        answer << 'r'
      end
    end
  end

  def check_incorrect_locations(guess)
    count_for_color_guess = Hash.new(0)
    count_for_color_code = Hash.new(0)

    guess.split('').each do |color|
      count_for_color_guess[color] += 1
    end

    @code.split('').each do |color|
      count_for_color_code[color] += 1
    end

    guess.split('').each_with_index do |color, index|
      if color == @code[index]
        next
      end

      if count_for_color_guess[@code[index]] >= count_for_color_code[@code[index]]
        answer << 'w'
        count_for_color_guess[@code[index]] -= 1
      end
    end
  end
end

class CpuGuess
  attr_accessor: color, occurrences, known_locations

  def initialize(color)
    @color = color
    @occurrences = 0
    @known_locations = []
    @eliminated_locations = []
  end


end

def cpu_guess_game(board)
  colors = [CpuGuess.new('r'), CpuGuess.new('b'), CpuGuess.new('y'), CpuGuess.new('o'), CpuGuess.new('g'), CpuGuess.new('p')]
  
  add_known_colors_to_guess(colors)
  add_unknown_colors_to_guess(colors)

  
end

def player_guess_game(game_board)
  guess_number = 1

  loop do
    guess = prompt_for_valid_code("guess")
    puts "Guess number #{guess_number}:"

    if game_board.correct?(guess)
      puts "Correct! You got the code #{game_board.code} in #{guess_number} guesses."
      break
    end

    game_board.check_guess(guess)

    if guess_number == MAX_GUESSES
      puts "Game over. You didn't guess the code in time.  Code was #{game_board.code}"
      break
    end

    guess_number += 1
  end
end

def add_known_colors_to_guess(colors)
  guess = []
  colors.each do |color|
    color.known_locations.each do |location|
      guess[location] = color.color
    end
  end
  return guess
end

def add_unknown_colors_to_guess(colors)
  guess = []
  colors.each do |color|
    for i in 0..color.occurrences do
      if color.known_locations.include?(i)
        next
      end
      guess << color.color
    end
  end
  return guess
end

def prompt_for_valid_game_type
  play_type = $stdin.gets.chomp.downcase
  while play_type != 'b' && play_type != 'm'
    puts 'Invalid play type, please enter \'b\' or \'m\''
    play_type = $stdin.gets.chomp.downcase
  end
  play_type
end

def prompt_for_valid_code(prompt_type)
  puts "Please enter the 4 character #{prompt_type} (colors (r)ed, (b)lue, (y)ellow, (o)range, (g)reen, and (p)urple):"
  code = $stdin.gets.chomp.downcase
  unless code.match(/^[rbyogp]+$/) && code.length == 4
    puts "Please enter only a 4 character #{prompt_type} using valid colors ((r)ed, (b)lue, (y)ellow, (o)range, (g)reen, and (p)urple)"
    code = $stdin.gets.chomp.downcase
  end
  code
end

def generate_random_code
  colors = %w[r b y o g p]
  random_color = colors.sample(4).join
end

def game
  puts 'Play as code (b)reaker or (m)aker'
  play_type = prompt_for_valid_game_type

  if play_type == 'm'
    code = prompt_for_valid_code('code')
    cpu_guess_game(Board.new(code))
  else
    code = generate_random_code
    player_guess_game(Board.new(code))
  end
end

game