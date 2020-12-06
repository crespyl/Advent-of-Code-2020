#!/usr/bin/env ruby
#
# Usage: getinput.rb year day
# Needs .env file with session cookie

require 'httparty'

year = ARGV[0] || Time.now.year
day = ARGV[1] || Time.now.day

cookie = File.read(".env")
url = "https://adventofcode.com/#{year}/day/#{day}/input"
response = HTTParty.get(url, headers: { "Cookie" => cookie })

puts response.body
