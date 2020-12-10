#!/usr/bin/env ruby
#
# Usage: getinput.rb year day
# Needs .env file with session cookie

require 'httparty'

year = ARGV[0] || Time.now.year
day = ARGV[1] || Time.now.day
cookie = File.read(".env")
url = "https://adventofcode.com/#{year}/day/#{day}/input"

loop do
  response = HTTParty.get(url, headers: { "Cookie" => cookie })
  case response.code
  when 404
    STDERR.puts "not ready yet..."
    sleep 1
  when 200
    puts response.body
    break
  else
    puts "something happened:"
    puts response.code
    puts response.body
    break
  end
end
