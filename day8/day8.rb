#!/usr/bin/env ruby
require "json"

input = File.read(ARGV[0] || "test.txt")

code = input.lines.map(&:strip).map { |l| l.split(' ') }

def run(code)
  acc = 0
  ptr = 0

  hits = Hash.new(0)

  while code[ptr] do
    instr = code[ptr]
    hits[ptr] += 1
    puts "%04i: %s %i (%i)" % [ptr, instr[0], instr[1], hits[ptr]]
    if hits[ptr] >= 2
      return [:loop, acc];
    end
    case instr[0]
    when "acc"
      acc += instr[1].to_i
    when "nop"

    when "jmp"
      ptr += instr[1].to_i
      next
    end
    ptr += 1
  end
  return [:ok, acc]
end

code.each_with_index do |_, i|
  changed = JSON.parse(JSON.generate(code)) #terrible lazy no good very bad deep copy
  case code[i][0]
  when "nop"
    changed[i][0] = "jmp"
  when "jmp"
    changed[i][0] = "nop"
  end
  puts "---"
  puts "changing [%s %i] to [%s %i]" % [code[i][0], code[i][1], changed[i][0], changed[i][1]]
  puts changed
  status, result = run(changed)
  puts status, result
  break if status == :ok
end
