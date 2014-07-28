class Game
  require 'yaml'

  def initialize
    print_title
    if new_game?
      @secret_word = ''
      @feedback = []
      @incorrect_letters = []
      @score = 7
      init_word
      init_feedback
      print_instructions
      controller
    else
      load_game
    end
  end

  def controller
    @game_over = false
    @win = true
    until @game_over
      print_title
      draw_gallow
      print_feedback
      get_letter
      check_letter
      check_game_over
    end
    print_title
    draw_gallow
    print_feedback
    if @win
      puts "You win!"
    else
      puts "The word was #{@secret_word.join}"
    end
  end

  def new_game?
    sleep(1)
    puts "Would you like to start a new game(1) or load the previous save(2)"
    input = gets.chomp
    if input == '1'
      true
    else
      false
    end
  end

  def check_game_over
     if @score == 0
       @win = false
       return @game_over = true
    end
    if @feedback.include? '_'
     @game_over = false 
   else
     @game_over = true

   end
  end

  def check_letter
    switch = false
    if @letter == "9"
      save_game
      return
      
    end
    @secret_word.each_with_index do |n, i|
      if n.include? @letter
       @feedback[i] = @letter
       switch = true
      end
    end
    unless switch
       @score = @score - 1
       @incorrect_letters << @letter
    end
  end

  def print_instructions
    clear
    puts "Try to guess the correct word.  You can save a game by inputting a '9'."
    sleep(3)
  end

  def get_letter
    print "Guess: "
    @letter = ''
    until @letter.length > 0 && @letter.length < 2
      @letter = gets.downcase.chomp
    end
  end

  def init_word
    words = File.readlines('5desk.txt')
      until  @secret_word.length > 5 && @secret_word.length < 12
        @secret_word = words.sample.chomp.downcase.split('')
      end
  end

  def init_feedback
    @secret_word.each do |n|
      @feedback << '_'
    end
  end

  def print_feedback
    @feedback.each do |letter| 
      print letter 
      print " "
    end
    print "   "
     print @incorrect_letters 
     puts ""
  end

  def save_gamestate!
  @gamestate = {
    secret_word: @secret_word, 
    score: @score,
    feedback: @feedback,
    incorrect_letters: @incorrect_letters,
    game_over: @game_over
  }
  end

  def load_gamestate!
    @secret_word = @gamestate[:secret_word]
    @score = @gamestate[:score]
    @feedback = @gamestate[:feedback]
    @incorrect_letters = @gamestate[:incorrect_letters]
    @game_over = @gamestate[:game_over]
  end

  def load_game 
    if File.exist?("save.yaml")
      f = File.open("save.yaml")
      data = f.read
      f.close
      @gamestate = YAML::load(data)
      load_gamestate!
      controller
    else
      puts "No current save file"
    end
  end

  def save_game
    save_gamestate!
    yaml = YAML::dump(@gamestate)
    File.open("save.yaml", "w") do |f|
      f.puts yaml
    end
    puts "Game Saved!"
    exit
  end

  def print_title
    clear
    puts "'Hangman' the Game"
  end

  def clear
    system "clear"
  end

  def draw_gallow
    case @score
      when 7
       puts %(\n

            ___     
           |   '
           |
           |
           |
           |
        -------)
      when 6
        puts %(\n

            ___     
           |   '
           |   O
           |
           |
           |
        -------)
      when 5
        puts %(\n

            ___     
           |   '
           |   O
           |   |
           |
           |
        -------)
      when 4
        puts %(\n

            ___     
           |   '
           |   O
           |  \\|
           |
           |
        -------)
      when 3
        puts %(\n

            ___     
           |   '
           |   O
           |  \\|/
           |   
           |
        -------)
      when 2
        puts %(\n

            ___     
           |   '
           |   O
           |  \\|/
           |   |
           |  
        -------)
      when 1
        puts %(\n

            ___     
           |   '
           |   O
           |  \\|/
           |   |
           |  / 
        -------)
      else
        puts %(\n

            ___     
           |   '
           |   O
           |  \\|/
           |   |
           |  / \\
        -------)
      end
  end
end

game = Game.new


