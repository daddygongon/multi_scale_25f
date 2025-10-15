# head
date: 2025-10-08
author: bob

# hello.rb -> hello
  shebang, chmod a+x

# mk_passwd
- ARGV 引数argument
- classify

## User
-dなどのoptionをoptparseで解析するようにrefactしてください

## Copilot
````ruby
#!/usr/bin/env ruby

require 'optparse'

class PasswordGenerator
  def initialize(length = 4)
    @length = length
    chars = Array('a'..'z')
    password = Array.new(length) { chars.sample }.join
    puts "Generated password: #{password}"
  end
end

options = { length: 4 }

OptionParser.new do |opts|
  opts.banner = "Usage: mk_passwd_optparse [options]"

  opts.on('-d LENGTH', Integer, 'Password length') do |len|
    options[:length] = len
  end
end.parse!

PasswordGenerator.new(options[:length])
````

## User
-dのlong optionとして'--digit'もとるように追加してください．

## Copilot
````ruby
OptionParser.new do |opts|
  opts.banner = "Usage: mk_passwd_optparse [options]"

  opts.on('-d', '--digit LENGTH', Integer, 'Password length') do |len|
    options[:length] = len
  end
end.parse!
````

## User
generateで大小英数字，記号を含むように拡張してください

## Copilot
````ruby
  def generate
    chars = []
    chars += ('a'..'z').to_a
    chars += ('A'..'Z').to_a
    chars += ('0'..'9').to_a
    chars += %w[! @ # $ % ^ & * ( ) _ + - = [ ] { } ; : , . / ?]
    password = Array.new(@length) { chars.sample }.join
    puts "Generated password: #{password}"
  end
````

## User
記号が入らないようにするoptionを'-S'で受けるようにしてください．

## Copilot
````ruby
class PasswordGenerator
  def initialize(length=4, symbol: true)
    @length = length
    @symbol = symbol
  end

  def generate
    chars = ('a'..'z').to_a
    chars += ('A'..'Z').to_a
    chars += ('0'..'9').to_a
    chars += %w[! @ # $ % ^ & * ( ) _ + - = [ ] { } ; : , . / ?] if @symbol
    password = Array.new(@length) { chars.sample }.join
    puts "Generated password: #{password}"
  end
end

options = { length: 4, symbol: true }

OptionParser.new do |opts|
  opts.banner = "Usage: mk_passwd_optparse [options]"

  opts.on('-d LENGTH', '--digit LENGTH', Integer, 'Password length') do |len|
    options[:length] = len
  end

  opts.on('-S', 'Exclude symbols from password') do
    options[:symbol] = false
  end
end.parse!

PasswordGenerator.new(options[:length], symbol: options[:symbol]).generate
````