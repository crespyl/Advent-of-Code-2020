#!/usr/bin/env ruby

input = File.read(ARGV[0])

puts "Part 1"
def is_valid_p1?(line)
  min, max, char, password = line.match(/(\d+)-(\d+)\s+(\w):\s+(\w+)/).captures
  return password.count(char) >= min.to_i && password.count(char) <= max.to_i
end
puts input.lines.select { |line| is_valid_p1?(line) }.count

puts "Part 2"
def is_valid_p2?(line)
  pos1, pos2, char, password = line.match(/(\d+)-(\d+)\s+(\w):\s+(\w+)/).captures
  return (password[pos1.to_i - 1] == char) ^ (password[pos2.to_i - 1] == char)
end
puts input.lines.select { |line| is_valid_p2?(line) }.count
