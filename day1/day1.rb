#!/usr/bin/env ruby

def part_1(numbers)
  puts "Part 1"
  numbers.sort.combination(2).each do |a,b|
    if a+b == 2020
      puts "#{a} + #{b} = 2020"
      puts "#{a} * #{b} = #{a*b}"
      return
    end
  end
end

def part_2(numbers)
  puts "Part 2"
  numbers.sort.combination(3).each do |a,b,c|
    if a+b+c == 2020
      puts "#{a} + #{b} + #{c} = 2020"
      puts "#{a} * #{b} * #{c} = #{a*b*c}"
      return
    end
  end
end

input = ARGV[0]
numbers = File.read(input).lines.map { |l| l.to_i }

part_1(numbers)
part_2(numbers)
