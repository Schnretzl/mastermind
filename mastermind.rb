class Board
  attr_accessor :code
  attr_reader :answer

  def initialize(code)
    @code = code
    @answer = []
  end

  def check_guess(guess)
    answer.clear
    check_correct_locations(guess)
    check_incorrect_locations(guess)
  end

  def display_guess_and_answer(guess)
    char_to_color_key = { 'r' => :red, 'b' => :blue, 'y' => :yellow, 'o' => :orange, 'g' => :green, 'p' => :purple, 'w' => :white }

    guess_display = guess.map { |char| char.colorize(:background => char_to_color_key[char]) }.join(' ')
    answer_display = answer.map { |char| char.colorize(:background => char_to_color_key[char]) }.join(' ')

    puts "#{guess_display}   #{answer_display}"
  end

  private

  def check_correct_locations(guess)
    guess.each_with_index do |color, index|
      if color == guess[index]
        answer << 'r'
      end
    end
  end

  def check_incorrect_locations(guess)
    count_for_color_guess = Hash.new(0)
    count_for_color_code = Hash.new(0)

    guess.each do |color|
      count_for_color_guess[color] += 1
    end

    @code.each do |color|
      count_for_color_code[color] += 1
    end

    guess.each_with_index do |color, index|
      if color == @code[index]
        next
      end

      if count_for_color_guess[@code[index]] > count_for_color_code[@code[index]]
        answer << 'w'
        count_for_color_guess[@code[index]] -= 1
      end
    end
  end
end

def cpu_guess(board)
  colors = %w[r b y o g p]
  combinations = colors.product(colors, colors, colors).map(&:join)
  count_of_each_color = {r: 0, b: 0, y: 0, o: 0, g: 0, p: 0}
  guess = 'rrrr'

  while answer != 'rrrr' do
    answer = board.check_guess(guess)
  end
end

def player_guess
  guess_number = 1
  puts 'Guess number #{guess_number}:'
  guess = prompt_for_valid_code('guess')
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
  puts 'Please enter the 4 character #{prompt_type} (colors (r)ed, (b)lue, (y)ellow, (o)range, (g)reen, and (p)urple):'
  code = $stdin.gets.chomp.downcase
  unless code.match(/^[rbyogp]+$/) && code.length == 4
    puts 'Please enter only a 4 character #{prompt_type} using valid colors ((r)ed, (b)lue, (y)ellow, (o)range, (g)reen, and (p)urple)'
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
    cpu_guess(Board.new(code))
  else
    code = generate_random_code
    player_guess(Board.new(code))
  end
end