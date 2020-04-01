# frozen_string_literal: true

require_relative 'token'
require_relative 'rlox-runtime-error'
require_relative 'expressions/assignment-expression'
require_relative 'expressions/binary-expression'
require_relative 'expressions/call-expression'
require_relative 'expressions/grouping'
require_relative 'expressions/literal'
require_relative 'expressions/unary-expression'

class Interpreter
  def interpret(expression)
    value = evaluate(expression)

    puts value
  rescue RloxRuntimeError => e
    Rlox.runtime_error(e)
  end

  private

  def interpret_literal_expression(expression)
    unless expression.is_a? Literal
      raise "Expected Literal, not #{expression.class.name}"
    end

    expression.value
  end

  def interpret_grouping_expression(expression)
    unless expression.is_a? GroupingExpression
      raise "Expected GroupingExpression, not #{expression.class.name}"
    end

    evaluate(expression)
  end

  def interpret_unary_expression(expression)
    unless expression.is_a? UnaryExpression
      raise "Expected UnaryExpression, not #{expression.class.name}"
    end

    right = evaluate(expression.right)

    case expression.operator.type
    when Token::MINUS
      assert_is_numeric(expression.operator, right)

      return -right
    when Token::BANG
      return !is_truthy?(right)
    end

    raise "Unexpected #{expression.operator.type} in unary expression"
  end

  def interpret_binary_expression(expression)
    unless expression.is_a? BinaryExpression
      raise "Expected BinaryExpression, not #{expression.class.name}"
    end

    left = evaluate(expression.left)
    right = evaluate(expression.right)

    # These operators allow a mix of types
    case expression.operator.type
    when Token::PLUS
      if (left.is_a? Numeric) && (right.is_a? Numeric)
        return left + right
      elsif (left.is_a? String) && (right.is_a? String)
        return left + right
      end

      raise RloxRuntimeError.new(expression.operator, 'Operands must be two numbers or two strings')
    when Token::EQUAL_EQUAL
      return is_equal?(left, right)
    when Token::BANG_EQUAL
      return !is_equal?(left, right)
    end

    assert_is_numeric(expression.operator, left)
    assert_is_numeric(expression.operator, right)

    case expression.operator.type
    when Token::GREATER
      return left > right
    when Token::GREATER_EQUAL
      return left >= right
    when Token::LESS
      return left < right
    when Token::LESS_EQUAL
      return left <= right
    when Token::MINUS
      return left - right
    when Token::SLASH
      return left / right
    when Token::STAR
      return left * right
    end

    raise "Unexpected #{expression.operator.type} in binary expression"
  end

  def is_truthy?(value)
    !value.nil? && value != false
  end

  def is_equal?(left, right)
    # TODO: is this what we want?
    left == right
  end

  def evaluate(expression)
    case true
    when expression.is_a?(AssignmentExpression)

    when expression.is_a?(BinaryExpression)
      interpret_binary_expression(expression)
    when expression.is_a?(CallExpression)

    when expression.is_a?(Grouping)
      interpret_grouping_expression(expression)
    when expression.is_a?(Literal)
      interpret_literal_expression(expression)
    when expression.is_a?(UnaryExpression)
      interpret_unary_expression(expression)
    else
      raise 'Invalid expression type'
    end
  end

  def assert_is_numeric(token, value)
    return if value.is_a? Numeric

    raise RloxRuntimeError.new(token, 'Operand must be numeric')
  end
end
