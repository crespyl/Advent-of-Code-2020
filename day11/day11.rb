#!/usr/bin/env ruby

require 'benchmark'
require 'minitest'
require 'pry'

require '../util/grid.rb'

TEST_STR = """\
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
"""

class Test < MiniTest::Test
  def test_p1
    assert_equal(37, compute_p1(TEST_STR))
  end

  def test_p2
    assert_equal(26, compute_p2(TEST_STR))
  end
end

def get(grid, x, y)
  if x < 0 || x >= grid.first.size || y < 0 || y >= grid.size
    '.'
  else
    grid[y][x]
  end
end

def los_visible(grid, x, y)
  vectors = [[-1,-1],  [0, -1], [+1, -1],
             [-1, 0],           [+1, 0],
             [-1, +1], [0, +1], [+1, +1]]

  sum = 0
  vectors.each do |vec|
    cx, cy = x, y
    while cx >= 0 && cx < grid.first.size && cy >= 0 && cy < grid.size
      cx, cy = cx+vec[0], cy+vec[1]
      c = get(grid, cx, cy)
      if c == '#'
        sum += 1
        break
      elsif c == 'L'
        break
      end
    end
  end

  return sum
end

def compute_p1(input)
  grid = Grid.new(input)
  grid2 = Grid.new(input)

  loop do
    grid.each_index do |x,y|
      c = grid.get(x,y)
      n = grid.neighbors(x,y).count('#')
      if c == 'L' && n == 0
        grid2.set(x,y,'#')
      elsif c == '#' && n >= 4
        grid2.set(x,y,'L')
      else
        grid2.set(x,y,c)
      end
    end

    break if grid == grid2
    grid, grid2 = grid2, grid
  end

  return grid.count('#')
end

def compute_p2(input)
  grid = input.lines.map(&:chars)
  width, height = grid.first.size, grid.size

  loop do
    #puts grid.map { |row| row.join('') }

    grid2 = grid.map(&:clone)

    height.times do |y|
      width.times do |x|
        cur = get(grid, x,y)
        n = los_visible(grid, x, y)
        if cur == 'L' && n == 0
          grid2[y][x] = '#'
        elsif cur == '#' && n >= 5
          grid2[y][x] = 'L'
        end
      end
    end

    break if grid == grid2
    grid = grid2
  end

  return grid.flatten.count('#')
end

if $0 == __FILE__ && MiniTest.run
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
