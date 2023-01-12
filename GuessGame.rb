load("Memory/MemoryImplementation.rb")
load("Memory/GameScore.rb")
require 'ruby2d'

# parametry startowe
set title: "Guess the number game"
set height: 1080
set width: 1920
set background: "black"

MENU_FONT_SIZE = 40
MENU_PADDING_SIZE = 20
RAND = Random.new
GUESSING_NUMBER_RANGE_LOW = 0
GUESSING_NUMBER_RANGE_HIGH = 99
$current_game_mode = "menu_start"

MEMORY = MemoryImplementation.new
MEMORY.read_file_to_memory("memory.txt")
#---------------------------------------------------------------------
#-------------------obiekty i metody animowanego tła------------------
#--------------------------------------------------------------------
# zmienne wysokości i szerokości okna
WIDTH_BACKGROUND = get :width
HEIGHT_BACKGROUND = get :height
animation_speed = 3

# funkcja zwracająca pseudo-losową pozycję (x lub y) do tła ekranu, która spełnia zasadę "pozycja%wysokość_czcionki=0"
def mod_15_num(length)
  loop do
    random_output = RAND.rand(0..length)
    if random_output % 15 == 0
      return random_output
    end
  end
end

# Tablica z losowymi numerami dla tła
background_numbers = Array.new
(0..2500).each do
  background_numbers.push(Text.new(
    RAND.rand(0..9),
    color: 'green',
    size: 15,
    x: mod_15_num(WIDTH_BACKGROUND),
    y: mod_15_num(HEIGHT_BACKGROUND)
  ))
end
# Początkowe ukrycie wszystkich numerów z tła
background_numbers.each do |v|
  v.remove
end
#--------------------------------------------------------------------
#--------------------obiekty i metody menu---------------------------
#--------------------------------------------------------------------
MENU_GAME_NAME_TEXT = Text.new(
  "Guess the number game",
  color: "white",
  size: 70,
  x: WIDTH_BACKGROUND / 2,
  y: HEIGHT_BACKGROUND / 4 - MENU_FONT_SIZE / 2 - 70 / 2,
  z: 99,
  opacity: 0
)
MENU_GAME_NAME_TEXT.x -= MENU_GAME_NAME_TEXT.width / 2
MENU_GAME_NAME_TEXT_BG = Rectangle.new(
  x: MENU_GAME_NAME_TEXT.x - MENU_PADDING_SIZE,
  y: MENU_GAME_NAME_TEXT.y - MENU_PADDING_SIZE,
  z: 98,
  width: MENU_GAME_NAME_TEXT.width + 2 * MENU_PADDING_SIZE,
  height: MENU_GAME_NAME_TEXT.height + 2 * MENU_PADDING_SIZE,
  color: "black",
  opacity: 0
)
#
MENU_BUTTON_PLAY_TEXT = Text.new(
  "Play",
  color: "white",
  size: MENU_FONT_SIZE,
  x: WIDTH_BACKGROUND / 2,
  y: HEIGHT_BACKGROUND / 2 - MENU_FONT_SIZE / 2 - 0,
  z: 99,
  opacity: 0
)
MENU_BUTTON_PLAY_TEXT.x -= MENU_BUTTON_PLAY_TEXT.width / 2
MENU_BUTTON_PLAY_BG = Rectangle.new(
  x: MENU_BUTTON_PLAY_TEXT.x - MENU_PADDING_SIZE,
  y: MENU_BUTTON_PLAY_TEXT.y - MENU_PADDING_SIZE,
  z: 98,
  width: MENU_BUTTON_PLAY_TEXT.width + 2 * MENU_PADDING_SIZE,
  height: MENU_BUTTON_PLAY_TEXT.height + 2 * MENU_PADDING_SIZE,
  color: "black",
  opacity: 0,
)
#
MENU_BUTTON_SCOREBOARD_TEXT = Text.new(
  "Scoreboard",
  color: "white",
  size: MENU_FONT_SIZE,
  x: WIDTH_BACKGROUND / 2,
  y: HEIGHT_BACKGROUND / 2 - MENU_FONT_SIZE / 2 + 150,
  z: 99,
  opacity: 0
)
MENU_BUTTON_SCOREBOARD_TEXT.x -= MENU_BUTTON_SCOREBOARD_TEXT.width / 2
MENU_BUTTON_SCOREBOARD_BG = Rectangle.new(
  x: MENU_BUTTON_SCOREBOARD_TEXT.x - MENU_PADDING_SIZE,
  y: MENU_BUTTON_SCOREBOARD_TEXT.y - MENU_PADDING_SIZE,
  z: 98,
  width: MENU_BUTTON_SCOREBOARD_TEXT.width + 2 * MENU_PADDING_SIZE,
  height: MENU_BUTTON_SCOREBOARD_TEXT.height + 2 * MENU_PADDING_SIZE,
  color: "black",
  opacity: 0,
)
#
MENU_BUTTON_EXIT_TEXT = Text.new(
  "Exit",
  color: "white",
  size: MENU_FONT_SIZE,
  x: WIDTH_BACKGROUND / 2,
  y: HEIGHT_BACKGROUND / 2 - MENU_FONT_SIZE / 2 + 300,
  z: 99,
  opacity: 0
)
MENU_BUTTON_EXIT_TEXT.x -= MENU_BUTTON_EXIT_TEXT.width / 2
MENU_BUTTON_EXIT_BG = Rectangle.new(
  x: MENU_BUTTON_EXIT_TEXT.x - MENU_PADDING_SIZE,
  y: MENU_BUTTON_EXIT_TEXT.y - MENU_PADDING_SIZE,
  z: 98,
  width: MENU_BUTTON_EXIT_TEXT.width + 2 * MENU_PADDING_SIZE,
  height: MENU_BUTTON_EXIT_TEXT.height + 2 * MENU_PADDING_SIZE,
  color: "black",
  opacity: 0,
)
#
def draw_menu_on
  MENU_GAME_NAME_TEXT.add
  MENU_GAME_NAME_TEXT_BG.add
  MENU_BUTTON_PLAY_TEXT.add
  MENU_BUTTON_PLAY_BG.add
  MENU_BUTTON_SCOREBOARD_TEXT.add
  MENU_BUTTON_SCOREBOARD_BG.add
  MENU_BUTTON_EXIT_TEXT.add
  MENU_BUTTON_EXIT_BG.add
end

def draw_menu_off
  MENU_GAME_NAME_TEXT.remove
  MENU_GAME_NAME_TEXT_BG.remove
  MENU_BUTTON_PLAY_TEXT.remove
  MENU_BUTTON_PLAY_BG.remove
  MENU_BUTTON_SCOREBOARD_TEXT.remove
  MENU_BUTTON_SCOREBOARD_BG.remove
  MENU_BUTTON_EXIT_TEXT.remove
  MENU_BUTTON_EXIT_BG.remove
end

#--------------------------------------------------------------------
#-------------obiekty i metody tabeli wyników rozgrywek--------------
#--------------------------------------------------------------------
SCOREBOARD_TEXT = Text.new(
  "Scoreboard",
  color: "white",
  size: 70,
  x: WIDTH_BACKGROUND / 2,
  y: HEIGHT_BACKGROUND / 5 - MENU_FONT_SIZE / 2 - 70,
  z: 99,
)
SCOREBOARD_TEXT.x -= SCOREBOARD_TEXT.width / 2
SCOREBOARD_TEXT.remove
SCOREBOARD_TEXT_BG = Rectangle.new(
  x: SCOREBOARD_TEXT.x - MENU_PADDING_SIZE,
  y: SCOREBOARD_TEXT.y - MENU_PADDING_SIZE,
  z: 98,
  width: SCOREBOARD_TEXT.width + 2 * MENU_PADDING_SIZE,
  height: SCOREBOARD_TEXT.height + 2 * MENU_PADDING_SIZE,
  color: "black",
  opacity: 0.8
)
SCOREBOARD_TEXT_BG.remove
#
SCOREBOARD_TEXT_BACK = Text.new(
  "back",
  color: "white",
  size: MENU_FONT_SIZE,
  x: WIDTH_BACKGROUND / 2,
  y: HEIGHT_BACKGROUND / 8 * 7,
  z: 99,
)
SCOREBOARD_TEXT_BACK.x -= SCOREBOARD_TEXT_BACK.width / 2
SCOREBOARD_TEXT_BACK.remove
SCOREBOARD_TEXT_BACK_BG = Rectangle.new(
  x: SCOREBOARD_TEXT_BACK.x - MENU_PADDING_SIZE,
  y: SCOREBOARD_TEXT_BACK.y - MENU_PADDING_SIZE,
  z: 98,
  width: SCOREBOARD_TEXT_BACK.width + 2 * MENU_PADDING_SIZE,
  height: SCOREBOARD_TEXT_BACK.height + 2 * MENU_PADDING_SIZE,
  color: "black",
  opacity: 0.8
)
SCOREBOARD_TEXT_BACK_BG.remove
#
$array_of_scores_to_render = Array.new
$array_of_nicks_to_render = Array.new
$scoreboard_bg = Rectangle.new
$scoreboard_bg.remove
#
def load_scores_to_render
  scores_array = MEMORY.get_memory
  if scores_array.length >= 10
    height_offset = HEIGHT_BACKGROUND / 2 - 10 * MENU_FONT_SIZE / 2 - MENU_PADDING_SIZE * 3
  else
    height_offset = HEIGHT_BACKGROUND / 2 - scores_array.length * MENU_FONT_SIZE / 2 - MENU_PADDING_SIZE * 2
  end

  scoreboard_array_nick = Array.new
  scoreboard_array_score = Array.new

  if scores_array.length >= 10
    (0...10).each { |i|
      scoreboard_array_nick.push(Text.new(
        (i + 1).to_s + ": " + scores_array[i].nick,
        size: MENU_FONT_SIZE,
        x: WIDTH_BACKGROUND / 5,
        y: height_offset,
        z: 100
      ))
      scoreboard_array_score.push(Text.new(
        scores_array[i].return_game_score,
        size: MENU_FONT_SIZE,
        x: scoreboard_array_nick[i].x + 500,
        y: height_offset,
        z: 100
      ))
      height_offset += MENU_FONT_SIZE + MENU_PADDING_SIZE
      scoreboard_array_nick[i].remove
      scoreboard_array_score[i].remove
    }
  else
    (0...scores_array.length).each { |i|
      scoreboard_array_nick.push(Text.new(
        (i + 1).to_s + ": " + scores_array[i].nick,
        size: MENU_FONT_SIZE,
        x: WIDTH_BACKGROUND / 5,
        y: height_offset,
        z: 100
      ))
      scoreboard_array_score.push(Text.new(
        scores_array[i].return_game_score,
        size: MENU_FONT_SIZE,
        x: scoreboard_array_nick[i].x + 500,
        y: height_offset,
        z: 100
      ))
      height_offset += MENU_FONT_SIZE + MENU_PADDING_SIZE
      scoreboard_array_nick[i].remove
      scoreboard_array_score[i].remove
    }
  end

  if scores_array.length >= 10
    height_offset = HEIGHT_BACKGROUND / 2 - 10 * MENU_FONT_SIZE / 2 - MENU_PADDING_SIZE * 3
  else
    height_offset = HEIGHT_BACKGROUND / 2 - scores_array.length * MENU_FONT_SIZE / 2 - MENU_PADDING_SIZE * 2
  end

  scoreboard_bg = Rectangle.new(
    x: WIDTH_BACKGROUND / 5 - MENU_PADDING_SIZE,
    y: height_offset - MENU_PADDING_SIZE,
    width: 500 + 2 * MENU_PADDING_SIZE + scoreboard_array_score[0].width,
    height: (scores_array.length >= 10 ? 10 : scores_array.length) * (MENU_PADDING_SIZE + MENU_FONT_SIZE) + MENU_PADDING_SIZE,
    color: "black",
    z: 99,
    opacity: 0.8
  )

  [scoreboard_array_nick, scoreboard_array_score, scoreboard_bg]
end

def draw_scoreboard_on
  SCOREBOARD_TEXT.add
  SCOREBOARD_TEXT_BG.add
  SCOREBOARD_TEXT_BACK.add
  SCOREBOARD_TEXT_BACK_BG.add

  $array_of_scores_to_render.each do |element|
    element.add
  end
  $array_of_nicks_to_render.each do |element|
    element.add
  end
  $scoreboard_bg.add
end

def draw_scoreboard_off
  SCOREBOARD_TEXT.remove
  SCOREBOARD_TEXT_BG.remove
  SCOREBOARD_TEXT_BACK.remove
  SCOREBOARD_TEXT_BACK_BG.remove

  $array_of_scores_to_render.each do |element|
    element.remove
  end
  $array_of_nicks_to_render.each do |element|
    element.remove
  end
  $scoreboard_bg.remove
end

#--------------------------------------------------------------------
#-----------------obiekty i metody rozgrywki-------------------------
#--------------------------------------------------------------------
GAMEPLAY_BEGIN_TEXT = Text.new(
  "Hello stranger, now you will be guessing my number in range #{GUESSING_NUMBER_RANGE_LOW} to #{GUESSING_NUMBER_RANGE_HIGH}",
  x: WIDTH_BACKGROUND / 2,
  y: HEIGHT_BACKGROUND / 5,
  z: 99,
  size: MENU_FONT_SIZE,
  color: "white",
)
GAMEPLAY_BEGIN_TEXT.x -= GAMEPLAY_BEGIN_TEXT.width / 2
GAMEPLAY_BEGIN_TEXT.remove
GAMEPLAY_BEGIN_TEXT_BG = Rectangle.new(
  x: GAMEPLAY_BEGIN_TEXT.x - MENU_PADDING_SIZE,
  y: GAMEPLAY_BEGIN_TEXT.y - MENU_PADDING_SIZE,
  z: 98,
  width: GAMEPLAY_BEGIN_TEXT.width + 2 * MENU_PADDING_SIZE,
  height: GAMEPLAY_BEGIN_TEXT.height + 2 * MENU_PADDING_SIZE,
  color: "black",
  opacity: 0.8
)
GAMEPLAY_BEGIN_TEXT_BG.remove
#
GAMEPLAY_HIGHER_TEXT = Text.new(
  "Higher!",
  x: WIDTH_BACKGROUND / 2,
  y: HEIGHT_BACKGROUND / 4 * 3,
  z: 99,
  size: MENU_FONT_SIZE,
  color: "white",
)
GAMEPLAY_HIGHER_TEXT.x -= GAMEPLAY_HIGHER_TEXT.width / 2
GAMEPLAY_HIGHER_TEXT.remove
GAMEPLAY_HIGHER_BG = Rectangle.new(
  x: GAMEPLAY_HIGHER_TEXT.x - MENU_PADDING_SIZE,
  y: GAMEPLAY_HIGHER_TEXT.y - MENU_PADDING_SIZE,
  z: 98,
  width: GAMEPLAY_HIGHER_TEXT.width + 2 * MENU_PADDING_SIZE,
  height: GAMEPLAY_HIGHER_TEXT.height + 2 * MENU_PADDING_SIZE,
  color: "black",
  opacity: 0.8
)
GAMEPLAY_HIGHER_BG.remove
#
GAMEPLAY_LOWER_TEXT = Text.new(
  "Lower!",
  x: WIDTH_BACKGROUND / 2,
  y: HEIGHT_BACKGROUND / 4 * 3,
  z: 99,
  size: MENU_FONT_SIZE,
  color: "white",
)
GAMEPLAY_LOWER_TEXT.x -= GAMEPLAY_LOWER_TEXT.width / 2
GAMEPLAY_LOWER_TEXT.remove
GAMEPLAY_LOWER_BG = Rectangle.new(
  x: GAMEPLAY_LOWER_TEXT.x - MENU_PADDING_SIZE,
  y: GAMEPLAY_LOWER_TEXT.y - MENU_PADDING_SIZE,
  z: 98,
  width: GAMEPLAY_LOWER_TEXT.width + 2 * MENU_PADDING_SIZE,
  height: GAMEPLAY_LOWER_TEXT.height + 2 * MENU_PADDING_SIZE,
  color: "black",
  opacity: 0.8
)
GAMEPLAY_LOWER_BG.remove

$gameplay_input_number = ""
$guessing_count = 1

$gameplay_input_number_text = Text.new(
  $gameplay_input_number,
  y: HEIGHT_BACKGROUND / 2,
  z: 99,
  size: MENU_FONT_SIZE,
  color: "white",
)
$gameplay_input_number_text.remove

$gameplay_input_number_bg = Rectangle.new(
  y: $gameplay_input_number_text.y - MENU_PADDING_SIZE,
  z: 98,
  height: $gameplay_input_number_text.height + 2 * MENU_PADDING_SIZE,
  color: "black",
  opacity: 0.8
)
$gameplay_input_number_bg.remove

GAMEPLAY_BUTTON_BACK_TEXT = Text.new(
  "back",
  color: "white",
  size: MENU_FONT_SIZE,
  x: WIDTH_BACKGROUND / 2,
  y: HEIGHT_BACKGROUND / 8 * 7,
  z: 99,
)
GAMEPLAY_BUTTON_BACK_TEXT.x -= GAMEPLAY_BUTTON_BACK_TEXT.width / 2
GAMEPLAY_BUTTON_BACK_TEXT.remove

GAMEPLAY_BUTTON_BACK_BG = Rectangle.new(
  x: GAMEPLAY_BUTTON_BACK_TEXT.x - MENU_PADDING_SIZE,
  y: GAMEPLAY_BUTTON_BACK_TEXT.y - MENU_PADDING_SIZE,
  z: 98,
  width: GAMEPLAY_BUTTON_BACK_TEXT.width + 2 * MENU_PADDING_SIZE,
  height: GAMEPLAY_BUTTON_BACK_TEXT.height + 2 * MENU_PADDING_SIZE,
  color: "black",
  opacity: 0.8
)
GAMEPLAY_BUTTON_BACK_BG.remove

# Funkcja odświeżająca input z klawiatury dla zgadywanej liczby
def update_input_number
  $gameplay_input_number_text.text = $gameplay_input_number
  $gameplay_input_number_text.x = WIDTH_BACKGROUND / 2 - $gameplay_input_number_text.width / 2
  $gameplay_input_number_bg.x = $gameplay_input_number_text.x - MENU_PADDING_SIZE
  $gameplay_input_number_bg.width = $gameplay_input_number_text.width + 2 * MENU_PADDING_SIZE
  nil
end

# Zmienna, liczba którą należy zgadnąć
$number_to_guess

# Funkcja, generująca nową liczbę dla każdej nowo rozpoczętej rozgrywki
def generate_new_gameplay
  RAND.rand(GUESSING_NUMBER_RANGE_LOW..GUESSING_NUMBER_RANGE_HIGH)
end

def draw_gameplay_on
  GAMEPLAY_BEGIN_TEXT.add
  GAMEPLAY_BEGIN_TEXT_BG.add
  GAMEPLAY_BUTTON_BACK_TEXT.add
  GAMEPLAY_BUTTON_BACK_BG.add

  $gameplay_input_number_text.add
  $gameplay_input_number_bg.add
end

def draw_gameplay_off
  GAMEPLAY_BEGIN_TEXT.remove
  GAMEPLAY_BEGIN_TEXT_BG.remove
  GAMEPLAY_HIGHER_TEXT.remove
  GAMEPLAY_HIGHER_BG.remove
  GAMEPLAY_LOWER_TEXT.remove
  GAMEPLAY_LOWER_BG.remove
  GAMEPLAY_BUTTON_BACK_TEXT.remove
  GAMEPLAY_BUTTON_BACK_BG.remove

  $gameplay_input_number_text.remove
  $gameplay_input_number_bg.remove
end

def guess_number
  number_guessed_int = $gameplay_input_number.to_i
  if number_guessed_int > $number_to_guess
    GAMEPLAY_HIGHER_TEXT.remove
    GAMEPLAY_HIGHER_BG.remove
    GAMEPLAY_LOWER_TEXT.add
    GAMEPLAY_LOWER_BG.add
  elsif number_guessed_int < $number_to_guess
    GAMEPLAY_LOWER_TEXT.remove
    GAMEPLAY_LOWER_BG.remove
    GAMEPLAY_HIGHER_TEXT.add
    GAMEPLAY_HIGHER_BG.add
  else
    GAMEPLAY_HIGHER_TEXT.remove
    GAMEPLAY_HIGHER_BG.remove
    GAMEPLAY_LOWER_TEXT.remove
    GAMEPLAY_LOWER_BG.remove
    $current_game_mode = "play_finish"
  end
end

#--------------------------------------------------------------------
#-------------Objects and methods of finish-game status--------------
#--------------------------------------------------------------------

$gameplay_input_nick = ""

GAMEPLAY_CONGRATS_TEXT = Text.new(
  "",
  color: "white",
  size: 70,
  y: HEIGHT_BACKGROUND / 5,
  z: 99,
)
GAMEPLAY_CONGRATS_TEXT.remove
GAMEPLAY_CONGRATS_BG = Rectangle.new(
  y: GAMEPLAY_CONGRATS_TEXT.y - MENU_PADDING_SIZE,
  z: 98,
  height: GAMEPLAY_CONGRATS_TEXT.height + 2 * MENU_PADDING_SIZE,
  color: "black",
  opacity: 0.8
)
GAMEPLAY_CONGRATS_BG.remove

GAMEPLAY_GUESSING_SCORE = Text.new(
  "",
  color: "white",
  size: MENU_FONT_SIZE,
  y: HEIGHT_BACKGROUND / 5 + 3 * MENU_FONT_SIZE,
  z: 99,
)
GAMEPLAY_GUESSING_SCORE.remove

GAMEPLAY_GUESSING_SCORE_BG = Rectangle.new(
  y: GAMEPLAY_GUESSING_SCORE.y - MENU_PADDING_SIZE,
  z: 98,
  height: GAMEPLAY_GUESSING_SCORE.height + 2 * MENU_PADDING_SIZE,
  color: "black",
  opacity: 0.8
)
GAMEPLAY_GUESSING_SCORE_BG.remove

$gameplay_input_nick_text = Text.new(
  $gameplay_input_number,
  y: HEIGHT_BACKGROUND / 2,
  z: 99,
  size: MENU_FONT_SIZE,
  color: "white",
)
$gameplay_input_nick_text.remove

$gameplay_input_nick_bg = Rectangle.new(
  y: $gameplay_input_nick_text.y - MENU_PADDING_SIZE,
  z: 98,
  height: $gameplay_input_nick_text.height + 2 * MENU_PADDING_SIZE,
  color: "black",
  opacity: 0.8
)
$gameplay_input_nick_bg.remove

def update_input_nick
  $gameplay_input_nick_text.text = $gameplay_input_nick
  $gameplay_input_nick_text.x = WIDTH_BACKGROUND / 2 - $gameplay_input_nick_text.width / 2
  $gameplay_input_nick_bg.x = $gameplay_input_nick_text.x - MENU_PADDING_SIZE
  $gameplay_input_nick_bg.width = $gameplay_input_nick_text.width + 2 * MENU_PADDING_SIZE
end

def draw_gameplay_finish_on
  GAMEPLAY_CONGRATS_TEXT.add
  GAMEPLAY_CONGRATS_BG.add
  GAMEPLAY_GUESSING_SCORE.add
  GAMEPLAY_GUESSING_SCORE_BG.add
  $gameplay_input_nick_text.add
  $gameplay_input_nick_bg.add
end

def draw_gameplay_finish_off
  GAMEPLAY_CONGRATS_TEXT.remove
  GAMEPLAY_CONGRATS_BG.remove
  GAMEPLAY_GUESSING_SCORE.remove
  GAMEPLAY_GUESSING_SCORE_BG.remove
  $gameplay_input_nick_text.remove
  $gameplay_input_nick_bg.remove
end

#--------------------------------------------------------------------

# Line.new(
#   x1: WIDTH_BACKGROUND / 2, y1: 0,
#   x2: WIDTH_BACKGROUND / 2, y2: HEIGHT_BACKGROUND,
#   width: 2,
#   color: 'red',
#   z: 100
# )
#
# Line.new(
#   x1: 0, y1: HEIGHT_BACKGROUND / 2,
#   x2: WIDTH_BACKGROUND, y2: HEIGHT_BACKGROUND / 2,
#   width: 2,
#   color: 'red',
#   z: 100
# )

# Keyboard Shift mode logic
$shift_mode = false

on :key_held do |event|
  if event.key == "left shift"
    $shift_mode = true
  end
end
on :key_up do |event|
  if event.key == "left shift"
    $shift_mode = false
  end
end

# Keyboard input logic
on :key_down do |event|
  # puts event.key
  if event.key == "escape"
    close
    #   # elsif event.key == 'm'
    #   #   $current_game_mode = "menu"D
  end

  # For menu mode:
  if $current_game_mode == "menu"
    if event.key == 'p'
      $current_game_mode = "play"
      $number_to_guess = generate_new_gameplay
      $gameplay_input_number = ""
      $guessing_count = 1
#-----------------------------------------------------
#-----------------|-----------------------------------
#-----------------|-----------------------------------
#-----Cheat only \|/----------------------------------
#-----------------------------------------------------
#       puts $number_to_guess
#-----------------------------------------------------
#-----------------------------------------------------
#-----------------------------------------------------
#-----------------------------------------------------
#-----------------------------------------------------
    end
    if event.key == "escape"
      close
    end
  end
  # For gameplay mode:
  if $current_game_mode == "play"
    if %w[1 2 3 4 5 6 7 8 9 0].include? event.key
      $gameplay_input_number += event.key
      update_input_number
    elsif event.key == "backspace"
      $gameplay_input_number = $gameplay_input_number.chop
      update_input_number
    elsif event.key == "return"
      guess_number
      $gameplay_input_number = ""
      $gameplay_input_number_text.text = $gameplay_input_number
      $gameplay_input_number_bg.width = 0
      GAMEPLAY_CONGRATS_TEXT.text = "Congratulation my number was: #{$number_to_guess}"
      GAMEPLAY_CONGRATS_TEXT.x = WIDTH_BACKGROUND / 2 - GAMEPLAY_CONGRATS_TEXT.width / 2
      GAMEPLAY_CONGRATS_BG.x = GAMEPLAY_CONGRATS_TEXT.x - MENU_PADDING_SIZE
      GAMEPLAY_CONGRATS_BG.width = GAMEPLAY_CONGRATS_TEXT.width + 2 * MENU_PADDING_SIZE
      GAMEPLAY_GUESSING_SCORE.text = "You successfully guessed in: #{$guessing_count} #{$guessing_count > 1 ? "tries" : "try"}"
      GAMEPLAY_GUESSING_SCORE.x = WIDTH_BACKGROUND / 2 - GAMEPLAY_GUESSING_SCORE.width / 2
      GAMEPLAY_GUESSING_SCORE_BG.x = GAMEPLAY_GUESSING_SCORE.x - MENU_PADDING_SIZE
      GAMEPLAY_GUESSING_SCORE_BG.width = GAMEPLAY_GUESSING_SCORE.width + 2 * MENU_PADDING_SIZE
      $guessing_count = $guessing_count + 1
    end
  end
  # For saving player score mode
  if $current_game_mode == "play_finish"
    if event.key == "return"
      if $gameplay_input_nick.length > 0
        MENU_BUTTON_PLAY_TEXT.text = "Play again?"
        MENU_BUTTON_PLAY_TEXT.x = WIDTH_BACKGROUND/2 - MENU_BUTTON_PLAY_TEXT.width / 2
        MENU_BUTTON_PLAY_BG.x = MENU_BUTTON_PLAY_TEXT.x - MENU_PADDING_SIZE
        MENU_BUTTON_PLAY_BG.width = MENU_BUTTON_PLAY_TEXT.width + 2 * MENU_PADDING_SIZE
        MEMORY.add_user_score(GameScore.new($gameplay_input_nick, $guessing_count-1))
        MEMORY.sort_memory
        MEMORY.save_memory("memory.txt")
        $gameplay_input_nick=""
        update_input_nick
        $current_game_mode = "menu"
      end
    else
      if $gameplay_input_nick.length < 20
        if $shift_mode
          if %w[a b c d e f g h i j k l m n o p q r s t u v w x y z - = . 1 2 3 4 5 6 7 8 9 0 ].include? event.key
            $gameplay_input_nick += event.key.upcase!
            update_input_nick
          end
        else
          if event.key == "space"
            $gameplay_input_nick += " "
            update_input_nick
          elsif %w[a b c d e f g h i j k l m n o p q r s t u v w x y z - = . 1 2 3 4 5 6 7 8 9 0 ].include? event.key
            $gameplay_input_nick += event.key
            update_input_nick
          end
        end
      end
      if event.key == "backspace"
        $gameplay_input_nick = $gameplay_input_nick.chop
        update_input_nick
      end
    end
  end
end

# Logika input'u myszki:
# Funkcja wykrywająca porządaną pozycję myszki dla hit-box'ów przycisków
def mouse_pos_in_range_x_y (menu_button, x, y)
  # if x >= menu_button.x && x <= menu_button.x + menu_button.width && y >= menu_button.y && y <= menu_button.y + menu_button.height
  #   return true
  # end
  # false
  menu_button.contains? x, y
end

on :mouse_down do |event|
  # -dla menu
  if $current_game_mode == "menu"
    if mouse_pos_in_range_x_y(MENU_BUTTON_EXIT_BG, event.x, event.y)
      close
    elsif mouse_pos_in_range_x_y(MENU_BUTTON_PLAY_BG, event.x, event.y)
      $current_game_mode = "play"
      $number_to_guess = generate_new_gameplay
      $gameplay_input_number = ""
      $guessing_count = 1
      puts $number_to_guess
    elsif mouse_pos_in_range_x_y(MENU_BUTTON_SCOREBOARD_BG, event.x, event.y)
      $current_game_mode = "scoreboard"
      $array_of_nicks_to_render, $array_of_scores_to_render, $scoreboard_bg = load_scores_to_render
    end
  elsif $current_game_mode == "scoreboard"
    if mouse_pos_in_range_x_y(SCOREBOARD_TEXT_BACK_BG, event.x, event.y)
      $current_game_mode = "menu"
    end
  elsif $current_game_mode == "play"
    if mouse_pos_in_range_x_y(GAMEPLAY_BUTTON_BACK_BG, event.x, event.y)
      $current_game_mode = "menu"
    end
  end

end

# tick = zmienna odświeżania gry
tick = 0
update do

  # Animacja tła (przesuwanie całego tła w dół)
  background_numbers.each do |value|
    value.y += animation_speed
    if value.y >= HEIGHT_BACKGROUND
      value.y = 0
    end
  end
  # Animacja tła (pokazywanie liczb z losowych miejsc)
  30.times do
    random_number_background = RAND.rand(0..2500)
    background_numbers[random_number_background].add
  end
  # Zanikanie losowych liczb z tła (aktywowane po ok 3 sekundach)
  if tick >= 90
    30.times do
      random_number_background = RAND.rand(0..2500)
      background_numbers[random_number_background].remove
    end
  end

  # Obiekty i logika "menu"
  if $current_game_mode == "menu_start"
    # Pojawiają się po ok 3 sek
    if tick >= 100
      if MENU_GAME_NAME_TEXT.color.opacity > 0.8
        $current_game_mode = "menu"
      end
      MENU_GAME_NAME_TEXT.color.opacity += 0.03
      MENU_GAME_NAME_TEXT_BG.color.opacity += 0.03
      MENU_BUTTON_PLAY_TEXT.color.opacity += 0.03
      MENU_BUTTON_PLAY_BG.color.opacity += 0.03
      MENU_BUTTON_SCOREBOARD_TEXT.color.opacity += 0.03
      MENU_BUTTON_SCOREBOARD_BG.color.opacity += 0.03
      MENU_BUTTON_EXIT_TEXT.color.opacity += 0.03
      MENU_BUTTON_EXIT_BG.color.opacity += 0.03
    end
  end
  if $current_game_mode == "menu"
    MENU_GAME_NAME_TEXT.color.opacity = 1
    MENU_GAME_NAME_TEXT_BG.color.opacity = 0.8
    MENU_BUTTON_PLAY_TEXT.color.opacity = 1
    MENU_BUTTON_PLAY_BG.color.opacity = 0.8
    MENU_BUTTON_SCOREBOARD_TEXT.color.opacity = 1
    MENU_BUTTON_SCOREBOARD_BG.color.opacity = 0.8
    MENU_BUTTON_EXIT_TEXT.color.opacity = 1
    MENU_BUTTON_EXIT_BG.color.opacity = 0.8

    draw_menu_on
    draw_scoreboard_off
    draw_gameplay_off
    draw_gameplay_finish_off
  end
  if $current_game_mode == "play"
    draw_menu_off
    draw_scoreboard_off
    draw_gameplay_on
    draw_gameplay_finish_off
    # MEMORY.add_user_score(GameScore.new("twoja_stara_to_gitara", 12))
    # MEMORY.sort_memory
    # MEMORY.save_memory("memory.txt")
  end
  if $current_game_mode == "play_finish"
    draw_menu_off
    draw_scoreboard_off
    draw_gameplay_off
    draw_gameplay_finish_on
  end
  if $current_game_mode == "scoreboard"
    draw_menu_off
    draw_scoreboard_on
    draw_gameplay_off
    draw_gameplay_finish_off
  end
  tick += 1
end
show
