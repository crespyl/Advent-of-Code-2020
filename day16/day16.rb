#!/usr/bin/env ruby

require 'benchmark'
require 'minitest'
require 'pry'
require 'set'

TEST_STR = "\
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
"

TEST_STR_2 = "\
class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
"

class Test < MiniTest::Test
  def test_p1
    assert_equal(71, compute_p1(TEST_STR))
  end

  def test_p2
    assert_equal(12*11*13, compute_p2(TEST_STR_2, [:class, :row, :seat]))
  end
end

RULE_RE = /^([\w\s]+): (\d+-\d+) or (\d+-\d+)\n?$/

def parse_rule(line)
  binding.pry unless line.match?(RULE_RE)
  captures = line.match(RULE_RE).captures
  name = captures[0]
  r1 = captures[1].split('-').map(&:to_i)
  r2 = captures[2].split('-').map(&:to_i)
  return [name.to_sym, r1[0]..r1[1], r2[0]..r2[1]]
end

def compute_p1(input)
  lines = input.lines.enum_for

  # read rules
  rules = {}
  while (l = lines.next).strip.size > 0 do
    r = parse_rule(l)
    rules[r[0]] = r[1..]
  end

  # read my ticket
  l = lines.next until l.start_with?("your ticket:")
  my_ticket = lines.next.split(',').map(&:to_i)

  # read nearby tickets
  l = lines.next until l.start_with?("nearby tickets:")
  nearby_tickets = []
  begin
    while (l = lines.next.strip).size > 0 do
      nearby_tickets << l.split(',').map(&:to_i)
    end
  rescue StopIteration
  end

  # check each value in nearby_tickets for all rules
  invalid_values = []
  nearby_tickets.each do |ticket|
    ticket.each do |value|
      invalid_values << value unless rules.values.flatten.any? { |r| r.include?(value) }
    end
  end

  return invalid_values.sum
end

def compute_p2(input, return_fields=nil)
  lines = input.lines.enum_for

  # read rules
  rules = {}
  while (l = lines.next.strip).size > 0
    r = parse_rule(l)
    rules[r[0]] = r[1..]
  end

  # read my ticket
  l = lines.next until l.start_with?("your ticket:")
  my_ticket = lines.next.split(',').map(&:to_i)

  # read nearby tickets
  l = lines.next until l.start_with?("nearby tickets:")
  nearby_tickets = []
  begin
    while (l = lines.next.strip).size > 0
      nearby_tickets << l.split(',').map(&:to_i)
    end
  rescue StopIteration
  end

  # check each value in each of nearby_tickets against all rules to find the valid tickets
  valid_tickets = nearby_tickets.filter do |ticket|
    ticket.all? { |value| rules.values.flatten.any? { |r| r.include?(value) } }
  end

  unknown_fields = Set.new(rules.keys)
  fields_order = Array.new(my_ticket.size)

  while unknown_fields.size > 0
    # look at the nth field in each ticket, and find the rule that matches all values
    my_ticket.size.times do |n|
      matching_rules = valid_tickets.map { _1[n] }.reduce(unknown_fields) do |set, value|
        set & unknown_fields.filter { |k| rules[k].any? { |r| r.include? value } }
      end
      if matching_rules.size == 1
        fields_order[n] = matching_rules.first
        unknown_fields -= [matching_rules.first]
      end
    end
  end

  binding.pry if unknown_fields.size > 0

  if return_fields.nil?
    return_fields = fields_order.filter { |f| f.to_s.start_with?("departure") }
  end

  return return_fields.reduce(1) { |product, field| product * my_ticket[fields_order.index(field)] }
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
