#!/usr/bin/env ruby

def get(map, x, y)
  cols = map[0].size
  x = x % cols
  map[y][x]
end

def count_hits(map, slope_x, slope_y)
  x = 0
  y = 0
  hits = 0

  while y < map.size
    if get(map, x, y) == "#"
      hits += 1
    end
    x+=slope_x
    y+=slope_y
  end

  return hits
end

input = File.read(ARGV[0] || "input.txt")
map = input.lines.map(&:strip).map(&:chars)

puts "Part 1"
puts "Hits: #{count_hits(map, 3, 1)}"

puts "Part 2"
slopes = [[1,1],[3,1],[5,1],[7,1],[1,2]]
hits = slopes
  .map { |sx,sy| count_hits(map, sx, sy) }
  .inject(&:*)

puts "Hits: #{hits}"
