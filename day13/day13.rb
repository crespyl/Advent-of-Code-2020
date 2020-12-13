#!/usr/bin/env ruby

require 'benchmark'
require 'minitest'
require 'pry'

TEST_STR = "\
939
7,13,x,x,59,x,31,19
"

class Test < MiniTest::Test
  def test_p1
    assert_equal(295, compute_p1(TEST_STR))
  end

  def test_p2
    assert_equal(1068781, compute_p2(TEST_STR))
  end
end

def compute_p1(input)
  start = input.lines.first.to_i
  bus_list = input.lines[1].strip.split(',').reject { |b| b == 'x' }.map(&:to_i)
  soonest = bus_list.map { |bus_id|
    x = bus_id
    while x < start
      x += bus_id
    end
    [x, bus_id]
  }.sort.first

  return (soonest[1] * (soonest[0]-start))
end

def check(num, bus_list)
  bus_list.each_with_index.reject{ |b,i| b == 1 }.all? { |b,i| ((num+i) % b) == 0}
end

def compute_p2(input)
  bus_list = input.lines[1]
               .strip
               .split(',')
               .map { |x| x == 'x' ? 1 : x.to_i }
  working = []
  step = 1
  t = 0

  bus_list.each do |bus|
    # add the next bus to our working set
    working << bus

    # advance by steps until we find a time that fits all the buses in our set
    t += step until check(t, working)

    # change our step so that we only ever advance by the LCM of all our previous
    # buses, which ensures that every new step we take continues to satisfy the
    # constraints
    step = working[...-1].reduce(1,:lcm)
  end

  return t
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
