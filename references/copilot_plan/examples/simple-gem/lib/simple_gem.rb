require_relative "simple_gem/version"

module SimpleGem
  class Error < StandardError; end
  
  # 簡単な挨拶メソッド
  def self.hello(name = nil)
    if name
      "Hello, #{name}!"
    else
      "Hello from SimpleGem!"
    end
  end
  
  # 現在の時刻に応じた挨拶
  def self.time_greeting(name = nil)
    hour = Time.now.hour
    
    greeting = case hour
              when 5..11
                "Good morning"
              when 12..17
                "Good afternoon"
              when 18..21
                "Good evening"
              else
                "Good night"
              end
    
    if name
      "#{greeting}, #{name}!"
    else
      "#{greeting} from SimpleGem!"
    end
  end
end