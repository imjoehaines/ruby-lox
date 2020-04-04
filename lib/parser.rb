# typed: true
# frozen_string_literal: true

require_relative 'token'
require_relative 'interpreter'
require_relative 'rlox_parse_error'
require_relative 'expressions/assignment_expression'
require_relative 'expressions/binary_expression'
require_relative 'expressions/call_expression'
require_relative 'expressions/grouping_expression'
require_relative 'expressions/literal_expression'
require_relative 'expressions/unary_expression'
require_relative 'expressions/variable_expression'
require_relative 'statements/block_statement'
require_relative 'statements/expression_statement'
require_relative 'statements/print_statement'
require_relative 'statements/variable_statement'

module Rlox
  class Parser
    def initialize(tokens)
      @tokens = tokens
      @current = 0
    end

    def parse
      statements = []

      statements.push(declaration) until is_at_end?

      statements
    rescue RuntimeError => e
      nil
    end

    private

    def declaration
      return variable_declaration if matches?(Token::VAR)
      return BlockStatement.new(block) if matches?(Token::LEFT_BRACE)

      statement
    rescue RloxParseError => e
      synchronise

      nil
    end

    def block
      statements = []

      while !check?(Token::RIGHT_BRACE) && !is_at_end?
        statements.push(declaration)
      end

      consume(Token::RIGHT_BRACE, "Expect '}' after block.")

      statements
    end

    def variable_declaration
      name = consume(Token::IDENTIFIER, 'Expect variable name')

      initializer = nil

      initializer = expression if matches?(Token::EQUAL)

      consume(Token::SEMICOLON, "Expect ';' after variable declaration.")

      VariableStatement.new(name, initializer)
    end

    def statement
      return print_statement if matches?(Token::PRINT)

      expression_statement
    end

    def print_statement
      value = expression

      consume(Token::SEMICOLON, "Expect ';' after value")

      PrintStatement.new(value)
    end

    def expression_statement
      value = expression

      consume(Token::SEMICOLON, "Expect ';' after value")

      ExpressionStatement.new(value)
    end

    def expression
      assignment
    end

    def assignment
      expr = equality

      if matches?(Token::EQUAL)
        equals = previous
        value = assignment

        if expr.is_a?(VariableExpression)
          return AssignmentExpression.new(expr.name, value)
        end

        raise error(equals, 'Invalid assignment target')
      end

      expr
    end

    def equality
      expr = comparison

      while matches?(Token::BANG_EQUAL, Token::EQUAL_EQUAL)
        operator = previous
        right = comparison

        expr = BinaryExpression.new(expr, operator, right)
      end

      expr
    end

    def comparison
      expr = addition

      while matches?(Token::GREATER, Token::GREATER_EQUAL, Token::LESS, Token::LESS_EQUAL)
        operator = previous
        right = addition

        expr = BinaryExpression.new(expr, operator, right)
      end

      expr
    end

    def addition
      expr = multiplication

      while matches?(Token::MINUS, Token::PLUS)
        operator = previous
        right = multiplication

        expr = BinaryExpression.new(expr, operator, right)
      end

      expr
    end

    def multiplication
      expr = unary

      while matches?(Token::SLASH, Token::STAR)
        operator = previous
        right = unary

        expr = BinaryExpression.new(expr, operator, right)
      end

      expr
    end

    def unary
      if matches?(Token::BANG, Token::MINUS)
        operator = previous
        right = unary

        return UnaryExpression.new(operator, right)
      end

      primary
    end

    def primary
      return LiteralExpression.new(false) if matches?(Token::FALSE)

      return LiteralExpression.new(true) if matches?(Token::TRUE)

      return LiteralExpression.new(nil) if matches?(Token::NIL)

      if matches?(Token::NUMBER, Token::STRING)
        return LiteralExpression.new(previous.literal)
      end

      return VariableExpression.new(previous) if matches?(Token::IDENTIFIER)

      if matches?(Token::LEFT_PARENTHESIS)
        expr = expression
        consume(Token::RIGHT_PARENTHESIS, "Expect ')' after expression")

        return GroupingExpression.new(expr)
      end

      raise error(peek, 'Expect expression')
    end

    def matches?(*types)
      types.each do |type|
        next unless check?(type)

        advance

        return true
      end

      false
    end

    def check?(type)
      return false if is_at_end?

      peek.type == type
    end

    def advance
      @current += 1 unless is_at_end?

      previous
    end

    def consume(type, message)
      return advance if check?(type)

      raise error(peek, message)
    end

    def error(token, message)
      Rlox.parse_error(token, message)

      RuntimeError.new(message)
    end

    def is_at_end?
      peek.type == Token::EOF
    end

    def peek
      @tokens[@current]
    end

    def previous
      @tokens[@current - 1]
    end

    def synchronise
      advance

      case peek.type
      when Token::CLASS, Token::FUN, Token::VAR, Token::FOR, Token::IF, Token::WHILE, Token::PRINT, Token::RETURN
        return
      end

      advance
    end
  end
end
