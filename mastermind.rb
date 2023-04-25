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

  def check_incorrect_locations(code)

  end
end
