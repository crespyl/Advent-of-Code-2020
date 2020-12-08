#!/usr/bin/env ruby
require "ostruct"

input = File.read(ARGV[0] || "test.txt")

def flip(instr)
  case instr.opcode
  when "nop"
    instr.opcode = "jmp"
  when "jmp"
    instr.opcode = "nop"
  end
  return instr
end

def run(code)
  acc = 0
  pc = 0
  hits = Hash.new(0)

  while instr = code[pc] do
    hits[pc] += 1

    #puts "%04i: %s %i (%i)" % [pc, instr.opcode, instr.value, hits[pc]]

    if hits[pc] >= 2
      return [:loop, acc]
    end
    case instr.opcode
    when "acc"
      acc += instr.value
      pc += 1
    when "nop"
      pc += 1
    when "jmp"
      pc += instr.value
      next
    end
  end
  return [:ok, acc]
end

code = input.lines.map(&:strip).map { |l| o, v = l.split(' '); OpenStruct.new(opcode: o, value: v.to_i) }
puts "Part 1"
puts run(code)[1]

puts "Part 2"

def flip(instr)
  case instr.opcode
  when "nop"
    instr.opcode = "jmp"
  when "jmp"
    instr.opcode = "nop"
  end
  return instr
end

result = -1
code.each do |instr|
  flip(instr)
  status, result = run(code)

  break if status == :ok
  flip(instr) #flip back before moving on
end
puts result
