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

  private

  def check_correct_locations(guess)
    guess.each_with_index do |color, index|
      if color == guess[index]
        answer << 'r'
      end
    end
    answer
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
      next if color == @code[index]

      if count_for_color_guess[@code[index]] > count_for_color_code[@code[index]]
        answer << 'w'
        count_for_color_guess[@code[index]] -= 1
      end
    end
    answer
    end
  end
end
