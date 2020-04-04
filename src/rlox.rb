# typed: true
# frozen_string_literal: true

require_relative 'parser'
require_relative 'scanner'
require_relative 'token'

class Rlox
  def initialize
    @@had_error = false
    @had_runtime_error = false
    @interpreter = Interpreter.new
  end

  def run_file(path)
    contents = File.read(path)

    run(contents)

    exit 65 if @@had_error
    exit 70 if @@had_error
  end

  def run_prompt
    loop do
      print '> '
      $stdout.flush

      input = STDIN.gets

      run(input.chomp)

      @@had_error = false
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

  def self.runtime_error(error)
    puts "[line: #{error.token.line}] #{error.message}"

    @had_runtime_error = true
  end

  private

  def run(source)
    scanner = Scanner.new(source)

    tokens = scanner.scan_tokens

    parser = Parser.new(tokens)

    statements = parser.parse

    return if @@had_error

    @interpreter.interpret(statements)
  end

  def self.report(line, where, message)
    puts "[line #{line}] Error #{where}: #{message}"

    @@had_error = true
  end
end
