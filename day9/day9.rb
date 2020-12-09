#!/usr/bin/env ruby
require('pry')

PREAMBLE_LENGTH = 25

def valid?(preamble, number)
  preamble.permutation(2).map { |a,b| a + b }.any?(number)
end

puts "Part 1"

input = File.read(ARGV[0] || "test.txt").lines.map(&:to_i)
buffer = input[0...PREAMBLE_LENGTH]
target = nil

input[PREAMBLE_LENGTH...].each do |n|
  if ! valid?(buffer, n)
    target = n
    break;
  else
    buffer.shift
    buffer << n
  end
end

puts target

puts "Part 2"

def check_contiguous(list, target)
  sum = list[0]
  list[1...].each_with_index do |n, i|
    sum += n
    return [true, i] if sum == target
    return [false, nil] if sum > target
  end
end

input.each_with_index do |n, i|
  match, len = check_contiguous(input[i...], target)
  if match
    span = input[i..i+len]
    puts span.min() + span.max()
    break
  end
end
