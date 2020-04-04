# typed: strict
# frozen_string_literal: true

if ARGV.length > 1
  puts "Usage: #{$PROGRAM_NAME} [script]"
  exit 64
end

require_relative 'rlox'

rlox = Rlox.new

if ARGV.length == 1
  rlox.run_file(ARGV[0])
else
  rlox.run_prompt
end
