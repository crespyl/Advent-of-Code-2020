#!/usr/bin/env ruby

require 'benchmark'
require 'minitest'
require 'pry'

TEST_STR = "\
F10
N3
F7
R90
F11
"

class Test < MiniTest::Test
  def test_p1
    assert_equal(25, compute_p1(TEST_STR))
  end

  def test_p2
    assert_equal(286, compute_p2(TEST_STR))
  end
end

def compute_p1(input)
  x, y = 0, 0
  dirs = [[+1, 0], [0, +1], [-1, 0], [0, -1]]
  dir = 0 # 0 = east, 1 = south, 2 = west, 3 = north
  input
    .lines
    .map { |l| l.match(/^([NSEWLRF])(\d+)\n$/).captures }
    .each do |action, value|
      value = value.to_i
      #puts "%s: %i" % [action, value]

      case action
      when "N"
        y -= value
      when "S"
        y += value
      when "E"
        x += value
      when "W"
        x -= value
      when "R"
        dir = (dir + (value / 90)) % 4
      when "L"
        dir = (dir - (value / 90)) % 4
      when "F"
        x += dirs[dir][0] * value
        y += dirs[dir][1] * value
      end

      #puts "  (%i, %i, %i)" % [x, y, dir]
  end

  return (x.abs) + (y.abs)
end

def compute_p2(input)
  wx, wy = 10, -1
  x, y = 0, 0

  input
    .lines
    .map { |l| l.match(/^([NSEWLRF])(\d+)\n$/).captures }
    .each do |action, value|
      value = value.to_i
      #puts "%s: %i" % [action, value]

      case action
      when "N"
        wy -= value
      when "S"
        wy += value
      when "E"
        wx += value
      when "W"
        wx -= value
      when "R"
        (value/90).times do
          wx, wy = wy * -1, wx
        end
      when "L"
        (value/90).times do
          wx, wy = wy, wx * -1
        end
      when "F"
        x += (wx * value)
        y += (wy * value)
      end

      #puts "  (%i, %i), (%i, %i)" % [x, y, wx, wy]
  end

  return (x.abs) + (y.abs)
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
