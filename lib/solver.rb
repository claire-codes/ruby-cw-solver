class Solver
  attr_accessor :word_list

  def initialize
    @word_list = []
    File.open("lib/dictionary") do |file|
      file.each do |line|
        @word_list.push line.strip
      end
    end
    # @word_list = ["cat", "cap", "lap", "at", "catch"]
  end

  def solve_clue(letter_array)
    find_matches(create_regex(take_input(letter_array)))
  end

  def take_input(letter_array)
    if (letter_array.respond_to?(:to_str))
      letter_array
    elsif letter_array.respond_to?(:join)
      letter_array.join
    else
      raise ArgumentError.new("Incorrect input")
    end
  end

  def create_regex(clue_word)
    unless clue_word.respond_to?(:to_str) then raise ArgumentError.new("Bad input, expected string") end
    puts "Clue word is: *" + clue_word + "*"
    blanks_subbed = clue_word.gsub(/ /, '.{1}')
    clue_regex = Regexp.new('^' + blanks_subbed + '$')
  end

  def find_matches(clue_regex)
    unless clue_regex.respond_to?(:match) then raise ArgumentError.new("Bad input, expected Regexp") end
    puts "Clue regex is: " + clue_regex.to_s
    answers = []
    word_list.each do |potential|
      answers.push(potential) if clue_regex.match(potential)
    end
    puts "Answers are: " + answers.to_s
    answers
  end
end