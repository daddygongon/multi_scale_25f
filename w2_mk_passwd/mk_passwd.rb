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
