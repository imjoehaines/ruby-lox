if ARGV.length > 1 then
  puts "Usage: #{$0} [script]"
  exit 64
end

require_relative 'rlox'

rlox = Rlox.new

if ARGV.length == 1 then
  rlox.run_file(ARGV[0])
else
  rlox.run_prompt()
end
