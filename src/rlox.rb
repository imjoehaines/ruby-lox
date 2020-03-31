# frozen_string_literal: true

require_relative 'parser'
require_relative 'scanner'
require_relative 'token'

class Rlox
  @had_error = false

  def run_file(path)
    contents = File.read(path)

    run(contents)

    exit 65 if @had_error
  end

  def run_prompt
    loop do
      print '> '
      $stdout.flush

      input = gets

      run(input)

      @had_error = false
    end
  end

  def self.error(line, message)
    report(line, '', message)
  end

  def self.parse_error(token, message)
    if token.type == Token::EOF
      report(token.line, ' at end', message)
    else
      report(token.line, "at '#{token.lexeme}'", message)
    end
  end

  private

  def run(source)
    scanner = Scanner.new(source)

    tokens = scanner.scan_tokens

    puts 'tokens:'

    tokens.each do |token|
      puts "  #{token}"
    end

    puts "\n"

    parser = Parser.new(tokens)

    expression = parser.parse

    return if @had_error

    puts expression
  end

  def self.report(line, where, message)
    puts "[line #{line}] Error #{where}: #{message}"

    @had_error = true
  end
end
