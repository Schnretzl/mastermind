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
    display_guess_and_answer(guess)
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

  def display_guess_and_answer(guess)
    char_to_color_key = { 'r' => :red, 'b' => :blue, 'y' => :yellow, 'o' => :orange, 'g' => :green, 'p' => :purple, 'w' => :white }

    guess_display = guess.map { |char| char.colorize(:background => char_to_color_key[char]) }.join(' ')
    answer_display = answer.map { |char| char.colorize(:background => char_to_color_key[char]) }.join(' ')

    puts "#{guess_display}   #{answer_display}"
  end

end
