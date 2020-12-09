#!/usr/bin/env ruby

require 'benchmark'
require 'minitest'
require 'pry'

TEST_STR = """\
1721
979
366
299
675
1456
"""

class Test < MiniTest::Test
  def test_p1
    assert_equal(514579, compute_p1(TEST_STR))
  end

  def test_p2
    assert_equal(241861950, compute_p2(TEST_STR))
  end
end

def compute_p1(input)
  input.lines.map(&:to_i).combination(2).each do |x,y|
    return x * y if x + y == 2020
  end
end

def compute_p2(input)
  input.lines.map(&:to_i).combination(3).each do |x,y,z|
    return x * y * z if x + y + z == 2020
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
