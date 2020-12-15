#!/usr/bin/env ruby

require 'benchmark'
require 'minitest'
require 'pry'

TEST_STR = "\
0,3,6
"

class Test < MiniTest::Test
  def test_p1
    assert_equal(436, compute_p1(TEST_STR))
  end

  def test_p2
    assert_equal(175594, compute_p2(TEST_STR))
  end
end

class SeenMap
  def initialize
    @hash = Hash.new
  end

  def [](n)
    if @hash[n].nil?
      @hash[n] = []
    else
      @hash[n]
    end
  end

  def log(n, age)
    if @hash[n].nil?
      @hash[n] = []
    end
    @hash[n].append(age)
  end
end

def compute_p1(input, max=2020)
  starting_numbers = input.strip.split(',').map(&:to_i)
  seen = SeenMap.new

  starting_numbers.each_with_index do |n,i|
    seen.log(n, i+1) #+1 since turn numbers start at 1 instead of 0
  end

  last_number = starting_numbers.last
  (max-starting_numbers.size).times do |n|
    cur_turn = starting_numbers.size + n + 1
    next_number = if seen[last_number].size < 2
                    0
                  else
                    seen[last_number][-2..].reduce(&:-).abs
                  end
    seen.log(next_number, cur_turn)
    #puts "turn #{cur_turn}: #{next_number}"
    last_number = next_number
  end

  return last_number
end

def compute_p2(input)
  compute_p1(input, max=30000000)
end

if MiniTest.run
  puts "Test case OK, running..."

  @input = File.read(ARGV[0] || "input.txt")

  Benchmark.bm do |bm|
    bm.report("Part 1:") { @p1 = compute_p1(@input) }
    bm.report("Part 2:") { @p2 = compute_p2(@input) }
  end

  puts "\nResults:"
  puts "Part 1: %i" % @p1
  puts "Part 2: %i" % @p2

else
  puts "Test case ERR"
end
