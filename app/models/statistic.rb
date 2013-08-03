class Statistic
  def self.r_visits_counter
    Redis::Counter.new(':statistic:visits_counter') 
  end
end
