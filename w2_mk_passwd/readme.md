# date:
Wed Oct  1 16:09:05 JST 2025

# daddygongon: Rubyで"Hello wordl."と出力するcodeを書いて

GitHub Copilot: 

# daddygongon: write Ruby code for puts "Hello world."

GitHub Copilot: 
````ruby
puts "Hello world."
````

# daddygongon: Rubyでパスワードを生成するコードを書いてください。
ただし、大文字、小文字、数字、記号が必ず入っていて8文字以上の制約があります。

GitHub Copilot: 
````ruby
require 'securerandom'

def generate_password(length = 8)
  raise "Length must be at least 8" if length < 8

  upper = ('A'..'Z').to_a
  lower = ('a'..'z').to_a
  digits = ('0'..'9').to_a
  symbols = %w[! @ # $ % ^ & * ( ) _ + - =]

  # Ensure at least one of each
  password = [
    upper.sample,
    lower.sample,
    digits.sample,
    symbols.sample
  ]

  # Fill the rest randomly
  all = upper + lower + digits + symbols
  (length - 4).times { password << all.sample }

  # Shuffle to randomize order
  password.shuffle.join
end

puts generate_password(12)
````
