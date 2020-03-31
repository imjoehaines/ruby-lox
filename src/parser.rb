# frozen_string_literal: true

require_relative 'token'
require_relative 'expressions/assignment-expression'
require_relative 'expressions/binary-expression'
require_relative 'expressions/call-expression'
require_relative 'expressions/grouping'
require_relative 'expressions/literal'
require_relative 'expressions/unary-expression'

class Parser
  def initialize(tokens)
    @tokens = tokens
    @current = 0
  end

  def parse
    expression
  rescue RuntimeError => e
    nil
  end

  def expression
    equality
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

    if matches?(Token::LEFT_PARENTHESIS)
      expr = expression
      consume(Token::RIGHT_PARENTHESIS, "Expect ')' after expression")

      Grouping.new(expr)
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
