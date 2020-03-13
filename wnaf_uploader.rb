#!/usr/bin/env ruby

def fmt(input_file, input_dir, output_dir)
    input = File.new(File.join(input_dir, input_file))
    output_name = "#{Time.now.strftime('%Y-%m-%d')}-#{input_file}.md"
    output = File.new(File.join(output_dir, output_name), 'w')
    output.puts '---'
    output.puts 'layout: post'
    output.puts "title: \"#{input.gets.chomp}\""
    output.puts '---'
    output.puts input.gets(nil)
ensure
    input.close
    output.close
end

def upload(input_file, output_dir)
    `cd "#{output_dir}" && git add . && git commit -m "Add #{input_file}"`
    `cd "#{output_dir}" && git push`
end

abort 'Arg: input_file_without_path' if ARGV.size != 1
input_dir = 'CHANGE_THIS'
output_dir = 'CHANGE_THIS'
fmt ARGV[0], input_dir, output_dir
upload ARGV[0], output_dir
puts 'Uploaded, now sleeping for 15 minutes...'
sleep 15 * 60
# TODO: https://github.com/sferik/twitter
