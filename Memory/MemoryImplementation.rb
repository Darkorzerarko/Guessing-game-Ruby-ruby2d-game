require 'put'

class MemoryImplementation

  def initialize
    @my_memory = Array.new
  end

  # Adding new score to the in game memory
  def add_user_score(game_score)
    @my_memory.push(game_score)
  end

  # Should be replaced with attr_accessor but i will leave it as it is
  def get_memory
    @my_memory
  end

  # A function that sorts the in game memory
  def sort_memory
    @my_memory = @my_memory.sort_by { |game_score|
      [
        Put.asc(game_score.score),
        Put.desc(game_score.date)
      ]
    }
    nil
  end

  # A function that reads memory.txt file and proceeds the data into RAM memory if its present
  # or creates an empty memory.txt file
  def read_file_to_memory(file_name)
    begin
      @memory_file = File.new(file_name, "r")
      @game_scores_array = @memory_file.readlines
      @memory_file.close
      if @game_scores_array.length > 0
        @game_scores_array.each do |line|
          # Splitting file data to fit into required GameScore data type
          line_split_by_coma = line.split(",")

          player_nick_var = line_split_by_coma[0]
          player_gameplay_score_data_var = line_split_by_coma[1].split(" ")

          player_gameplay_score_var = player_gameplay_score_data_var[0].to_i
          player_gameplay_score_date_split = player_gameplay_score_data_var[1].split "-"
          score_date_d = player_gameplay_score_date_split[0].to_i
          score_date_m = player_gameplay_score_date_split[1].to_i
          score_date_y = player_gameplay_score_date_split[2].to_i

          player_gameplay_score_time_split = player_gameplay_score_data_var[2].split ":"
          score_time_h = player_gameplay_score_time_split[0].to_i
          score_time_m = player_gameplay_score_time_split[1].to_i
          score_time_s = player_gameplay_score_time_split[2].to_i

          player_score = GameScore.new(player_nick_var, player_gameplay_score_var, Time.new(
            score_date_y, score_date_m, score_date_d, score_time_h, score_time_m, score_time_s
          ))

          add_user_score(player_score)
        end
      end
    rescue Errno::ENOENT
      @memory_file = File.new(file_name, "w+")
      @memory_file.close
    end
  end

  # A function to rewrite sorted GameScores into memory.txt file
  def save_memory(file_name)
    @memory_file = File.new(file_name, "w")
    @memory_file.truncate(0)
    @my_memory.each do |value|
      @memory_file.syswrite("#{value.nick}, #{value.score} #{value.date.strftime("%d-%m-%Y %H:%M:%S")}\n")
    end
    @memory_file.close
  end
end
