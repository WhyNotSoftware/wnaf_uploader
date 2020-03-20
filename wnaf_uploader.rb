#!/usr/bin/env ruby

require 'twitter'

def find_file(input_dir, output_dir)
    output_file = Dir.entries(output_dir).filter {|e| e =~ /-wnaf-/}.sort.last
    line = IO.readlines(File.join(output_dir, output_file))[2]
    num = line.match(/#(\d+):/).captures[0].to_i
    num += 1
    entries = Dir.entries(input_dir).filter {|e| e =~ /^wnaf-/}
    entries.filter {|e| IO.read(File.join(input_dir, e)) =~ /##{num}:/}.first
end

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

def tweet(input_file, input_dir, twitter_config)
    title = File.open(File.join(input_dir, input_file)) {|f| f.gets.chomp}
    client = Twitter::REST::Client.new(twitter_config)
    client.update("#{title} #Clojure 👉👉 https://whynotsoftware.github.io/#{input_file}/ #wnaf")
end

input_dir = 'CHANGE_IT'
output_dir = 'CHANGE_IT'
twitter_config = { 
    consumer_key: 'CHANGE_IT',
    consumer_secret: 'CHANGE_IT',
    access_token: 'CHANGE_IT',
    access_token_secret: 'CHANGE_IT'
}

input_file = find_file input_dir, output_dir
abort 'No file to upload' unless input_file
fmt input_file, input_dir, output_dir
upload input_file, output_dir
puts 'Uploaded, now sleeping for 15 minutes...'
sleep 15 * 60
tweet input_file, input_dir, twitter_config
puts 'Done!'
