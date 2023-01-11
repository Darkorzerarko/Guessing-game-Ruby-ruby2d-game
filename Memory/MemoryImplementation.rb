require 'put'

class MemoryImplementation

  def initialize
    @my_memory = Array.new
  end

  def add_user_score(game_score)
    @my_memory.push(game_score)
  end

  def print_memory
    @my_memory.each do |value|
      print "#{value.get_game_score}"
      puts
    end
  end

  def get_memory
    @my_memory
  end


  def sort_memory
    @my_memory = @my_memory.sort_by {|game_score|
      [
        Put.asc(game_score.score),
        Put.desc(game_score.date)
      ]
    }
    nil
  end


  def read_file_to_memory(file_name)
    @memory_file = File.new(file_name, "r")
    @game_scores_array = @memory_file.readlines
    @memory_file.close
    @game_scores_array.each do |line|
      # Podzielenie zawartości pliku z wynikami rozgrywek
      line_split = line.split

      player_nick_var = line_split[0]
      player_score_var = line_split[1].to_i

      score_date_split = line_split[2].split("-")
      score_date_d = score_date_split[0].to_i
      score_date_m = score_date_split[1].to_i
      score_date_y = score_date_split[2].to_i

      score_time_split = line_split[3].split(":")
      score_time_h = score_time_split[0].to_i
      score_time_m = score_time_split[1].to_i
      score_time_s = score_time_split[2].to_i

      player_score = GameScore.new(player_nick_var, player_score_var, Time.new(
        score_date_y, score_date_m, score_date_d, score_time_h, score_time_m, score_time_s
      ))

      add_user_score(player_score)
    end
  end

  def save_memory(file_name)
    @memory_file = File.new(file_name, "w")
    @memory_file.truncate(0)
    @my_memory.each do |value|
      @memory_file.syswrite("#{value.nick} #{value.score} #{value.date.strftime("%d-%m-%Y %H:%M:%S")}\n")
    end
    @memory_file.close
  end

end

