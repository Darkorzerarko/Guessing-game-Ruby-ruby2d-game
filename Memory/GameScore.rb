class GameScore

  attr_accessor :nick, :score, :date
  def initialize(nick, score, time=Time.now)
    @nick = nick
    @score = score
    @date = time
  end

  def get_game_score
    nick_placeholder = "%-10s" % [@nick]
    print "#{nick_placeholder} score: #{@score.to_s}, " + @date.strftime("%d-%m-%Y %H:%M:%S")
  end

  def return_game_score
    " score: " + @score.to_s + ", " + @date.strftime("%d-%m-%Y %H:%M:%S")
  end
end
