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
current_game_mode = "menu_start"

MEMORY = MemoryImplementation.new
MEMORY.read_file_to_memory("memory.txt")
#---------------------------------------------------------------------
#-------------------obiekty i metody animowanego tła------------------
#--------------------------------------------------------------------
# zmienne wysokości i szerokości okna
WIDTH_BACKGROUND = get :width
HEIGHT_BACKGROUND = get :height
animation_speed = 3
# funkcja zwracająca pseudo-losową pozycję "y" do tła ekranu, która spełnia zasadę "pozycja%wysokość_czcionki=0"
def mod_15_num(height_background)
  loop do
    random_output = RAND.rand(0..height_background)
    if random_output % 15 == 0
      return random_output
    end
  end
end

# funkcja zwracająca pseudo-losową pozycję "x" do tła ekranu, która spełnia zasadę "pozycja%szerokość_czcionki=0"
def mod_10_num(width_background)
  loop do
    random_output = RAND.rand(0..width_background)
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
    x: mod_10_num(WIDTH_BACKGROUND),
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
ARRAY_OF_SCORES_TO_RENDER = Array.new
ARRAY_OF_NICKS_TO_RENDER = Array.new
SCOREBOARD_BG = Rectangle.new
SCOREBOARD_BG.remove
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
  SCOREBOARD_BG.add
  SCOREBOARD_TEXT.add
  SCOREBOARD_TEXT_BG.add
  SCOREBOARD_TEXT_BACK.add
  SCOREBOARD_TEXT_BACK_BG.add
  ARRAY_OF_SCORES_TO_RENDER.each do |element|
    element.add
  end
  ARRAY_OF_NICKS_TO_RENDER.each do |element|
    element.add
  end
end

def draw_scoreboard_off
  SCOREBOARD_BG.remove
  SCOREBOARD_TEXT.remove
  SCOREBOARD_TEXT_BG.remove
  SCOREBOARD_TEXT_BACK.remove
  SCOREBOARD_TEXT_BACK_BG.remove
  ARRAY_OF_SCORES_TO_RENDER.each do |element|
    element.remove
  end
  ARRAY_OF_NICKS_TO_RENDER.each do |element|
    element.remove
  end
end

#--------------------------------------------------------------------
#-----------------obiekty i metody rozgrywki-------------------------
#--------------------------------------------------------------------
GAMEPLAY_BEGIN_TEXT = Text.new(
  # "Witaj przybyszu, teraz będziesz zgadywać moją wylosowaną liczbę",
  "Hello stranger, now you will be guessing my number",
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

$number_guessed = ""
$gameplay_input_number_text = Text.new(
  $number_guessed,
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


$gameplay_text_back = Text.new(
  "back",
  color: "white",
  size: MENU_FONT_SIZE,
  x: WIDTH_BACKGROUND / 2,
  y: HEIGHT_BACKGROUND / 8 * 7,
  z: 99,
  )
$gameplay_text_back.x -= $gameplay_text_back.width / 2
$gameplay_text_back.remove

$gameplay_text_back_bg = Rectangle.new(
  x: $gameplay_text_back.x - MENU_PADDING_SIZE,
  y: $gameplay_text_back.y - MENU_PADDING_SIZE,
  z: 98,
  width: $gameplay_text_back.width + 2 * MENU_PADDING_SIZE,
  height: $gameplay_text_back.height + 2 * MENU_PADDING_SIZE,
  color: "black",
  opacity: 0.8
)
$gameplay_text_back_bg.remove


# Funkcja odświeżająca input z klawiatury dla zgadywanej liczby
def update_input_number
  $gameplay_input_number_text.text = $number_guessed
  $gameplay_input_number_text.x = WIDTH_BACKGROUND / 2 - $gameplay_input_number_text.width / 2
  $gameplay_input_number_bg.x = $gameplay_input_number_text.x - MENU_PADDING_SIZE
  $gameplay_input_number_bg.width = $gameplay_input_number_text.width + 2 * MENU_PADDING_SIZE
  nil
end

$number_to_guess

def generate_number_for_new_gameplay
  RAND.rand(0..99)
end

def draw_gameplay_on
  GAMEPLAY_BEGIN_TEXT.add
  GAMEPLAY_BEGIN_TEXT_BG.add

  $gameplay_text_back.add
  $gameplay_text_back_bg.add

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

  $gameplay_text_back.remove
  $gameplay_text_back_bg.remove

  $gameplay_input_number_text.remove
  $gameplay_input_number_bg.remove
end

def guess_number
  number_guessed_int = $number_guessed.to_i
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
    puts "congratulation you guessed correctly"
  end
  puts number_guessed_int
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

# Logika input'u klawiatury:
on :key_down do |event|
  # puts event.key
  if event.key == "escape"
    close
  elsif event.key == 'm'
    current_game_mode = "menu"
  end
  if current_game_mode == "menu"
    if event.key == 'p'
      current_game_mode = "play"
      $number_to_guess = generate_number_for_new_gameplay
      $number_guessed = ""
      puts $number_to_guess
    end
  end
  if current_game_mode == "play"
    if event.key == '1'
      $number_guessed += "1"
      update_input_number
    elsif event.key == '2'
      $number_guessed += "2"
      update_input_number
    elsif event.key == '3'
      $number_guessed += "3"
      update_input_number
    elsif event.key == '4'
      $number_guessed += "4"
      update_input_number
    elsif event.key == '5'
      $number_guessed += "5"
      update_input_number
    elsif event.key == '6'
      $number_guessed += "6"
      update_input_number
    elsif event.key == '7'
      $number_guessed += "8"
      update_input_number
    elsif event.key == '8'
      $number_guessed += "8"
      update_input_number
    elsif event.key == '9'
      $number_guessed += "9"
      update_input_number
    elsif event.key == '0'
      $number_guessed += "0"
      update_input_number
    elsif event.key == "return"
      guess_number
      $number_guessed = ""
      $gameplay_input_number_text.text = $number_guessed
      $gameplay_input_number_bg.width = 0
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
  if current_game_mode == "menu"
    if mouse_pos_in_range_x_y(MENU_BUTTON_EXIT_BG, event.x, event.y)
      close
    elsif mouse_pos_in_range_x_y(MENU_BUTTON_PLAY_BG, event.x, event.y)
      current_game_mode = "play"
      $number_to_guess = generate_number_for_new_gameplay
      $number_guessed = ""
      puts $number_to_guess
    elsif mouse_pos_in_range_x_y(MENU_BUTTON_SCOREBOARD_BG, event.x, event.y)
      current_game_mode = "scoreboard"
      ARRAY_OF_NICKS_TO_RENDER, ARRAY_OF_SCORES_TO_RENDER, SCOREBOARD_BG = load_scores_to_render
    end
  elsif current_game_mode == "scoreboard"
    if mouse_pos_in_range_x_y(SCOREBOARD_TEXT_BACK_BG, event.x, event.y)
      current_game_mode = "menu"
    end
  elsif current_game_mode == "play"
    if mouse_pos_in_range_x_y($gameplay_text_back_bg, event.x, event.y)
      current_game_mode = "menu"
    end
  end

end

# tick = zmienna odświeżania gry
tick = 0
update do
  # Animacja tła (pokazywanie liczb w losowych miejcach)
  background_numbers.each do |value|
    value.y += animation_speed
    if value.y >= HEIGHT_BACKGROUND
      value.y = 0
    end
  end

  40.times do
    random_number_background = RAND.rand(0..2500)
    background_numbers[random_number_background].add
  end
  # Zanikanie losowych liczb z tła (aktywowane po ok 3 sekundach)
  if tick >= 90
    40.times do
      random_number_background = RAND.rand(0..2500)
      background_numbers[random_number_background].remove
    end
  end

  # Obiekty i logika "menu"
  if current_game_mode == "menu_start"
    # Pojawiają się po ok 3 sek
    if tick >= 100
      if MENU_GAME_NAME_TEXT.color.opacity > 0.8
        current_game_mode = "menu"
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
  if current_game_mode == "menu"
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

  end
  if current_game_mode == "play"
    draw_menu_off
    draw_scoreboard_off
    draw_gameplay_on
    # MEMORY.add_user_score(GameScore.new("twoja_stara_to_gitara", 12))
    # MEMORY.sort_memory
    # MEMORY.save_memory("memory.txt")
  end
  if current_game_mode == "scoreboard"
    draw_menu_off
    draw_scoreboard_on
    draw_gameplay_off
  end
  tick += 1
end
show




