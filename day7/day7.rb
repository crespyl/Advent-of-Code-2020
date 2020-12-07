#!/usr/bin/env ruby
require "set"

input = File.read(ARGV[0] || "test2.txt")

rules = {}

input.lines.each do |line|
  outer_bag, inner = line.split("bags contain").map(&:strip)
  inner = inner.gsub(/\./,'')
            .split(',')
            .map(&:strip)
            .reject{ |s| s == "no other bags" }
            .map { |s| c = s.match(/(\d+)\s(\w+)\s(\w+)\s(.+)/).captures
                       [c[0].to_i, c[1] << " " << c[2]] }

  rules[outer_bag] = inner
end

def find_containers(rules, target)
  containers = Set.new
  rules.each do |container, contained|
    if contained.any? { |rule| rule[1] == target }
      #puts "found that #{container} can hold #{target}"
      containers.add(container)
      containers += find_containers(rules, container)
    end
  end
  return containers
end

def score_bag(rules, target)
  rules[target].reduce(1) do |sum, rule|
    sum + (rule[0] * score_bag(rules, rule[1]))
  end
end

puts "Part 1"
puts find_containers(rules, "shiny gold").size

puts "Part 2"
puts score_bag(rules, "shiny gold") - 1 #sub one for the gold bag itself
