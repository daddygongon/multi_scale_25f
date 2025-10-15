daddygongon: optparseでoptionをhandligできるようにして，-d, --day=-7とかでdateを7日前に変更できるように修正．

GitHub Copilot: ### [chat_form](file:///Users/bob/bin/mk_cli_copilot/chat_form/chat_form)

`optparse`を使ってコマンドラインオプションを処理し、`-d`や`--day=-7`で日付を指定日数ずらせるように修正します。

````ruby
#!/usr/bin/env ruby
# ...existing code...

require 'optparse'
require 'date'

# ...existing code...

if __FILE__ == $0
  options = { day: 0 }
  OptionParser.new do |opts|
    opts.on('-dN', '--day=N', Integer, '日付をN日前/後にずらす (例: -d -7)') do |n|
      options[:day] = n
    end
  end.parse!

  input_file = ARGV[0] || "readme.md"
  base = File.basename(input_file, ".*")
  output_file = "#{base}_formatted.md"

  lines = File.exist?(input_file) ? File.readlines(input_file) : []
  formatted = format_chat(lines)

  # ここで日付と作成者を挿入
  author = ENV["USER"] || ENV["USERNAME"] || "unknown"
  date = (Date.today + options[:day]).strftime("%Y-%m-%d")
  header = "# head\ndate: #{date}\nauthor: #{author}\n\n"

  File.write(output_file, header + formatted)
end
````

Made changes.