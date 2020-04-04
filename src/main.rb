# typed: strict
# frozen_string_literal: true

require_relative 'rlox'

module Rlox
  if ARGV.length > 1
    puts "Usage: #{$PROGRAM_NAME} [script]"
    exit 64
  end

  rlox = Rlox.new

  if ARGV.length == 1
    rlox.run_file(ARGV[0])
  else
    rlox.run_prompt
  end
end
