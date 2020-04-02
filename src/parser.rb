# frozen_string_literal: true

require_relative 'token'
require_relative 'interpreter'
require_relative 'rlox-parse-error'
require_relative 'expressions/assignment-expression'
require_relative 'expressions/binary-expression'
require_relative 'expressions/call-expression'
require_relative 'expressions/grouping'
require_relative 'expressions/literal'
require_relative 'expressions/unary-expression'
require_relative 'expressions/variable-expression'
require_relative 'statements/expression-statement'
require_relative 'statements/print-statement'
require_relative 'statements/variable-statement'

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

    statement
  rescue RloxParseError => e
    synchronise

    nil
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
    return Literal.new(false) if matches?(Token::FALSE)

    return Literal.new(true) if matches?(Token::TRUE)

    return Literal.new(nil) if matches?(Token::NIL)

    if matches?(Token::NUMBER, Token::STRING)
      return Literal.new(previous.literal)
    end

    return VariableExpression.new(previous) if matches?(Token::IDENTIFIER)

    if matches?(Token::LEFT_PARENTHESIS)
      expr = expression
      consume(Token::RIGHT_PARENTHESIS, "Expect ')' after expression")

      return Grouping.new(expr)
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
