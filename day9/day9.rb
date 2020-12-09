#!/usr/bin/env ruby

require 'benchmark'
require 'minitest'
require 'pry'

TEST_STR = """\
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
"""

class Test < MiniTest::Test
  def test_p1
    assert_equal(127, compute_p1(TEST_STR, 5))
  end

  def test_p2
    assert_equal(62, compute_p2(TEST_STR, compute_p1(TEST_STR, 5)))
  end
end

def valid?(preamble, number)
  preamble.combination(2).map { |a,b| a + b }.any?(number)
end

def check_contiguous(list, target)
  sum = list[0]
  list[1...].each_with_index do |n, i|
    sum += n
    return [true, i] if sum == target
    return [false, nil] if sum > target
  end
end

def compute_p1(input, preamble_length)
  input = input.lines.map(&:to_i)
  buffer = input[0...preamble_length]

  input[preamble_length...].each do |n|
    if ! valid?(buffer, n)
      return n
    else
      buffer.shift
      buffer << n
    end
  end
end

def compute_p2(input, target)
  input = input.lines.map(&:to_i)
  input.each_with_index do |n, i|
    match, len = check_contiguous(input[i...], target)
    if match
      span = input[i..i+len]
      return span.min() + span.max()
    end
  end
end

if MiniTest.run
  puts "Test case OK, running..."

  @input = File.read(ARGV[0] || "input.txt")

  Benchmark.bm do |bm|
    bm.report("Part 1:") { @p1 = compute_p1(@input, 25) }
    bm.report("Part 2:") { @p2 = compute_p2(@input, @p1) }
  end

  puts "\nResults:"
  puts "Part 1: %i" % @p1
  puts "Part 2: %i" % @p2

else
  puts "Test case ERR"
end
