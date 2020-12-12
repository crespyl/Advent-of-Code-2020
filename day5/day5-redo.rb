#!/usr/bin/env ruby

require 'benchmark'
require 'minitest'
require 'pry'

TEST_STR = "\
FBFBBFFRLR
"

class Test < MiniTest::Test
  def test_parse
    assert_equal(357, pass_to_seat_id(TEST_STR))
  end
end

def pass_to_seat_id(pass)
  Integer(pass.tr("FLBR", "0011"), 2)
end

def compute_p1(input)
  input
    .lines
    .map { |l| pass_to_seat_id(l) }
    .max
end

def compute_p2(input)
  input
    .lines
    .map { |l| pass_to_seat_id(l) }
    .sort
    .each_cons(2) do |a, b|
    if (b - a) > 1
      return a+1
    end
  end
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
