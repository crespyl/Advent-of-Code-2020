#!/usr/bin/env ruby

require 'benchmark'
require 'minitest'
require 'pry'

TEST_STR = "\
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
"

TEST_STR_2 = "\
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
"

class Test < MiniTest::Test
  def test_p1
    assert_equal(165, compute_p1(TEST_STR))
  end

  def test_p2
    assert_equal(208, compute_p2(TEST_STR_2))
  end
end

def apply_mask_p1(mask, num)
  mask.reverse.chars.each_with_index do |c, i|
    case c
    when 'X'
      next
    when '0'
      num = num & ~(1 << i)
    when '1'
      num = num | (1 << i)
    end
  end
  return num
end

def compute_p1(input)
  prog = input.lines.map(&:strip)
  mem = Hash.new(0)
  mask = "";

  prog.each do |line|
    if line.start_with?("mask")
      mask = line.split(' ')[2]
    elsif line.start_with?('mem')
      c = line.match(/mem\[(\d+)\] = (\d+)/).captures
      mem[c[0].to_i] = apply_mask_p1(mask, c[1].to_i)
    end
  end

  return mem.values.reduce(:+)
end

def apply_mask_p2(mask, num)
  base = num | mask.tr("X","0").to_i(2)
  nums = []

  floating_bits = mask.reverse.chars.each_with_index.filter { |c, i| c == 'X' }.map { |c,i| i }
  (2 ** floating_bits.size).times do |i|
    num = base
    floating_bits.each_with_index do |b, j|
      bit = (i & (1 << j)) >> j
      case bit
      when 1
        num = num | (1 << b)
      when 0
        num = num & ~(1 << b)
      end
    end
    nums << num
  end

  return nums
end

def compute_p2(input)
  prog = input.lines.map(&:strip)
  mem = Hash.new(0)
  mask = "";

  prog.each_with_index do |line, i|
    if line.start_with?("mask")
      mask = line.split(' ')[2]
    elsif line.start_with?('mem')
      c = line.match(/mem\[(\d+)\] = (\d+)/).captures
      addrs = apply_mask_p2(mask, c[0].to_i)
      addrs.each do |a|
        mem[a] = c[1].to_i
      end
    end
  end

  return mem.values.reduce(:+)
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
