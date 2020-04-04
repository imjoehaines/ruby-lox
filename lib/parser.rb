# typed: strict
# frozen_string_literal: true

require_relative 'token'
require_relative 'interpreter'
require_relative 'parse_error'
require_relative 'runtime_error'
require_relative 'expressions/assignment_expression'
require_relative 'expressions/binary_expression'
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
    extend T::Sig

    sig {params(tokens: T::Array[Token]).void}
    def initialize(tokens)
      @tokens = T.let(tokens, T::Array[Token])
      @current = T.let(0, Integer)
    end

    sig {returns(T::Array[Statement])}
    def parse
      statements = []

      until is_at_end?
        statement = declaration

        statements.push(declaration) unless statement.nil?
      end

      statements
    rescue RuntimeError => e
      []
    end

    private

    sig {returns(T.nilable(Statement))}
    def declaration
      return variable_declaration if matches?(Token::VAR)
      return BlockStatement.new(block) if matches?(Token::LEFT_BRACE)

      statement
    rescue ParseError => e
      synchronise

      nil
    end

    sig {returns(T::Array[Statement])}
    def block
      statements = []

      while !check?(Token::RIGHT_BRACE) && !is_at_end?
        statement = declaration

        statements.push(statement) unless statement.nil?
      end

      consume(Token::RIGHT_BRACE, "Expect '}' after block.")

      statements
    end

    sig {returns(VariableStatement)}
    def variable_declaration
      name = consume(Token::IDENTIFIER, 'Expect variable name')

      initializer = nil

      initializer = expression if matches?(Token::EQUAL)

      consume(Token::SEMICOLON, "Expect ';' after variable declaration.")

      VariableStatement.new(name, initializer)
    end

    sig {returns(Statement)}
    def statement
      return print_statement if matches?(Token::PRINT)

      expression_statement
    end

    sig {returns(PrintStatement)}
    def print_statement
      value = expression

      consume(Token::SEMICOLON, "Expect ';' after value")

      PrintStatement.new(value)
    end

    sig {returns(ExpressionStatement)}
    def expression_statement
      value = expression

      consume(Token::SEMICOLON, "Expect ';' after value")

      ExpressionStatement.new(value)
    end

    sig {returns(Expression)}
    def expression
      assignment
    end

    sig {returns(Expression)}
    def assignment
      expr = equality

      if matches?(Token::EQUAL)
        equals = previous
        value = assignment

        if expr.is_a? VariableExpression
          return AssignmentExpression.new(expr.name, value)
        end

        raise error(equals, 'Invalid assignment target')
      end

      expr
    end

    sig {returns(Expression)}
    def equality
      expr = comparison

      while matches?(Token::BANG_EQUAL, Token::EQUAL_EQUAL)
        operator = previous
        right = comparison

        expr = BinaryExpression.new(expr, operator, right)
      end

      expr
    end

    sig {returns(Expression)}
    def comparison
      expr = addition

      while matches?(Token::GREATER, Token::GREATER_EQUAL, Token::LESS, Token::LESS_EQUAL)
        operator = previous
        right = addition

        expr = BinaryExpression.new(expr, operator, right)
      end

      expr
    end

    sig {returns(Expression)}
    def addition
      expr = multiplication

      while matches?(Token::MINUS, Token::PLUS)
        operator = previous
        right = multiplication

        expr = BinaryExpression.new(expr, operator, right)
      end

      expr
    end

    sig {returns(Expression)}
    def multiplication
      expr = unary

      while matches?(Token::SLASH, Token::STAR)
        operator = previous
        right = unary

        expr = BinaryExpression.new(expr, operator, right)
      end

      expr
    end

    sig {returns(Expression)}
    def unary
      if matches?(Token::BANG, Token::MINUS)
        operator = previous
        right = unary

        return UnaryExpression.new(operator, right)
      end

      primary
    end

    sig {returns(Expression)}
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

    sig {params(types: String).returns(T::Boolean)}
    def matches?(*types)
      types.each do |type|
        next unless check?(type)

        advance

        return true
      end

      false
    end

    sig {params(type: String).returns(T::Boolean)}
    def check?(type)
      return false if is_at_end?

      peek.type == type
    end

    sig {returns(Token)}
    def advance
      @current += 1 unless is_at_end?

      previous
    end

    sig {params(type: String, message: String).returns(Token)}
    def consume(type, message)
      return advance if check?(type)

      raise error(peek, message)
    end

    sig {params(token: Token, message: String).returns(::RuntimeError)}
    def error(token, message)
      Rlox.parse_error(token, message)

      ::RuntimeError.new(message)
    end

    sig {returns(T::Boolean)}
    def is_at_end?
      peek.type == Token::EOF
    end

    sig {returns(Token)}
    def peek
      @tokens.fetch(@current)
    end

    sig {returns(Token)}
    def previous
      @tokens.fetch(@current - 1)
    end

    sig {void}
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
