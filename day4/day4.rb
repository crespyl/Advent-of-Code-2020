#!/usr/bin/env ruby
require "set"

input = File.read(ARGV[0] || "test.txt")

passports = input.split("\n\n")
              .map(&:strip)
              .map{|p| p.split(' ')
                     .map{|f| f.split(':')}
                     .inject({}){|p, kv| p[kv[0].to_sym] = kv[1]; p}}

REQUIRED = [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid].to_set
OPTIONAL = [:cid].to_set

puts "Part 1"
valid_count = passports.reduce(0) do |count, passport|
  passport.keys.to_set.superset?(REQUIRED) ? count+1 : count
end
puts "Valid Passports: #{valid_count}"

def is_valid?(passport)
  return false unless
    passport.keys.to_set.superset?(REQUIRED) &&
    passport[:byr].to_i.between?(1920, 2002) &&
    passport[:iyr].to_i.between?(2010, 2020) &&
    passport[:eyr].to_i.between?(2020, 2030) &&
    passport[:hcl].match?(/^#[0-9a-f]{6}$/) &&
    passport[:ecl].match?(/^amb|blu|brn|gry|grn|hzl|oth$/) &&
    passport[:pid].match?(/^\d{9}$/) &&
    hgt = passport[:hgt].match(/^(\d+)(cm|in)$/)

  n, u = hgt.captures
  u == "cm" ? n.to_i.between?(150, 193) : n.to_i.between?(50, 76)
end

puts "Part 2"
valid_count = passports.reduce(0) do |count, passport|
  is_valid?(passport) ? count+1 : count
end
puts "Valid Passports: #{valid_count}"
