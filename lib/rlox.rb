# typed: strict
# frozen_string_literal: true

require_relative 'parser'
require_relative 'scanner'
require_relative 'token'

module Rlox
  class Rlox
    extend T::Sig

    @@had_error = T.let(false, T::Boolean)
    @@had_runtime_error = T.let(false, T::Boolean)

    sig {void}
    def initialize
      @interpreter = T.let(Interpreter.new, Interpreter)
    end

    sig {params(path: String).void}
    def run_file(path)
      contents = File.read(path)

      run(contents)

      exit 65 if @@had_error
      exit 70 if @@had_runtime_error
    end

    sig {void}
    def run_prompt
      loop do
        print '> '
        $stdout.flush

        input = STDIN.gets

        run(input.to_s.chomp)

        @@had_error = false
      end
    end

    sig {params(line: Integer, message: String).void}
    def self.error(line, message)
      report(line, '', message)
    end

    sig {params(token: Token, message: String).void}
    def self.parse_error(token, message)
      if token.type == Token::EOF
        report(token.line, ' at end', message)
      else
        report(token.line, "at '#{token.lexeme}'", message)
      end
    end

    sig {params(error: RuntimeError).void}
    def self.runtime_error(error)
      puts "[line: #{error.token.line}] #{error.message}"

      @@had_runtime_error = true
    end

    private

    sig {params(source: String).void}
    def run(source)
      scanner = Scanner.new(source)

      tokens = scanner.scan_tokens

      parser = Parser.new(tokens)

      statements = parser.parse

      return if @@had_error

      @interpreter.interpret(statements)
    end

    sig {params(line: Integer, where: String, message: String).void}
    def self.report(line, where, message)
      puts "[line #{line}] Error #{where}: #{message}"

      @@had_error = true
    end
  end
end
