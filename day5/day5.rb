#!/usr/bin/env ruby

def bstep(path, low, high)
  steps = path.chars
  while ! steps.empty?
    c = steps.shift
    case c
    when /F|L/
      high -= (high - low)/2
    when /B|R/
      low += (high - low)/2
    end
  end
  return low
end

def find_seat_score(pass)
  row = bstep(pass[0...7], 0, 128)
  col = bstep(pass[7...], 0, 8)
  return (row * 8) + col
end

input = File.read(ARGV[0] || "test.txt")

puts "Part 1"
puts input.lines.map { |line| find_seat_score(line) }.max

puts "Part 2"
seats = input.lines.map { |line| find_seat_score(line) }.sort
seats[1..].reduce(seats.first) do |prev, cur|
  if prev+1 != cur
    puts prev+1
    break
  else
    cur
  end
end

puts "--"

def pass_to_number(pass)
  Integer(pass.tr("FLBR", "0011"), 2)
end

puts "Part 1 (again)"
puts input.lines.map { |l| pass_to_number(l) }.max
