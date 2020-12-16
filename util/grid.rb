#!/usr/bin/env ruby

class Grid
  attr_accessor :grid
  attr_reader :width
  attr_reader :height
  attr_reader :default

  def initialize(input, default: nil)
    @grid = input.lines
              .map(&:strip)
              .map(&:chars)
    @width = @grid[0].size
    @height = @grid.size
    @default = default
  end

  def get(x,y)
    if x < 0 || x >= @width || y < 0 || y >= @height
      @default
    else
      @grid[y][x]
    end
  end

  def set(x,y,val)
    if x < 0 || x >= @width || y < 0 || y >= @height
      raise "Tried to write out of bounds"
    else
      @grid[y][x] = val
    end
  end

  def each_index
    height.times do |y|
      width.times do |x|
        yield(x,y)
      end
    end
  end

  def ==(other)
    return false if other.class != Grid
    return other.grid == @grid
  end

  def neighbors(x,y)
    [
      [-1, -1], [0, -1], [+1, -1],
      [-1,  0],          [+1, 0],
      [-1, +1], [0, +1], [+1, +1]
    ].map { |dx, dy| get(x+dx, y+dy) }
  end

  def to_s
    s = ""
    height.times do |y|
      width.times do |x|
        s << get(x,y) || default.to_s
      end
      s << "\n"
    end
    return s
  end

  def count(value)
    @grid.flatten.count(value)
  end
end

class HashGrid < Grid
  attr_accessor :grid

  def initialize(input, default: nil)
    @grid = Hash.new(default)
    lines = input.lines
              .map(&:strip)
              .map(&:chars)
    lines.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        @grid[[x,y]] = cell
      end
    end
    @min_x = 0
    @min_y = 0
    @max_x = lines.first.size-1
    @max_y = lines.size-1
  end

  def get(x,y)
    @grid[[x,y]]
  end

  def set(x,y,val)
    @min_x = x if x < @min_x
    @min_y = y if y < @min_y
    @max_x = x if x > @max_x
    @max_y = y if y > @max_y

    @grid[[x,y]] = val
  end

  def width
    (@max_x - @min_x) +1
  end

  def height
    (@max_y - @min_y) +1
  end

  def to_s
    s = ""
    height.times do |y|
      width.times do |x|
        s << get(@min_x + x, @min_y + y) || default.to_s
      end
      s << "\n"
    end
    return s
  end

  def each_index
    @grid.keys.each { |k| yield k }
  end

  def count(value)
    @grid.values.count(value)
  end

  def ==(other)
    return false if other.class != HashGrid
    each_index do |x,y|
      return false unless get(x,y) == other.get(x,y)
    end
    return true
  end

end
