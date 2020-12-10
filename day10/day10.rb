#!/usr/bin/env ruby

require 'benchmark'
require 'minitest'
require 'pry'

TEST_STR = """\
16
10
15
5
1
11
7
19
6
12
4
"""

TEST_STR_2 = """\
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
"""

class Test < MiniTest::Test
  def test_p1
    assert_equal(7*5, compute_p1(TEST_STR))
  end

  def test_p2
    assert_equal(8, compute_p2(TEST_STR))
  end

  def test_p2_sample_2
    assert_equal(19208, compute_p2(TEST_STR_2))
  end
end

def find_adapter(available, target)
  available
    .map { |x| [x - target, x] }
    .sort
    .first
end

def compute_p1(input)
  adapters = input.lines.map(&:to_i).sort
  adapters << adapters.max + 3

  target = 0
  diff_counts = Hash.new(0)
  while ! adapters.empty?
    diff, a = find_adapter(adapters, target)
    #puts "%i -> %i (%i)" % [target, a, diff]
    diff_counts[diff] += 1
    adapters.delete(a)
    target = a
  end

  #puts diff_counts
  return diff_counts[1] * diff_counts[3]
end

def compute_p2(input)
  input = input.lines.map(&:to_i)
  adapters = [0] + input.sort + [input.max + 3]

  groups = adapters[...-1].zip(adapters[1...])
             .reduce([]) { |steps, pair| steps << pair[1]-pair[0] }
             .reduce([]) do |groups, n|
               if groups.last && groups.last.last == n
                 groups.last << n
               else
                 groups << [n]
               end
               groups
             end

  group_counts = groups
                   .find_all { |g| g.first == 1 }
                   .map { |g| g.size }
                   .each_with_object(Hash.new(0)) { |count, h| h[count] += 1 }

  # options per group size scale with sum of previous 3, so we precompute table
  # of options per group size
  #
  #        0  1  2
  table = [1, 1, 2]
  while table.size < 10
    table << table[-3..].sum
  end

  return group_counts.reduce(1) { |product, kv| product * table[kv[0]] ** kv[1] }
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
