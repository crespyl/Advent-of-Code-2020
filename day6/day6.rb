#!/usr/bin/env ruby
require "set"

input = File.read(ARGV[0] || "test.txt")

groups = input.split("\n\n")

yes_answers = groups.map { |g| g.lines.reduce(Set.new) { |set, line| set | line.strip.chars } }

puts "Part 1"
puts yes_answers.reduce(0) { |sum, group| sum + group.size }

puts "Part 2"
yes_answers = groups.map { |g| g.lines.reduce(Set.new(g.lines.first.strip.chars)) { |set, line| set & line.strip.chars } }
puts yes_answers.reduce(0) { |sum, group| sum + group.size }
