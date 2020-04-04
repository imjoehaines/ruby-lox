# typed: true
# frozen_string_literal: true

require_relative 'token'
require_relative 'environment'
require_relative 'rlox_runtime_error'
require_relative 'expressions/assignment_expression'
require_relative 'expressions/binary_expression'
require_relative 'expressions/call_expression'
require_relative 'expressions/grouping_expression'
require_relative 'expressions/literal_expression'
require_relative 'expressions/unary_expression'
require_relative 'statements/block_statement'
require_relative 'statements/expression_statement'
require_relative 'statements/print_statement'

module Rlox
  class Interpreter
    def initialize
      @environment = Environment.new
    end

    def interpret(statements)
      statements.each do |statement|
        execute(statement)
      end
    rescue RloxRuntimeError => e
      Rlox.runtime_error(e)
    end

    private

    def interpret_literal_expression(expression)
      unless expression.is_a? LiteralExpression
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

      right = evaluate(expression.expression)

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
      !!value
    end

    def is_equal?(left, right)
      left == right
    end

    def evaluate(expression)
      case true
      when expression.is_a?(AssignmentExpression)
        value = evaluate(expression.value)

        @environment.assign(expression.name, value)

        value
      when expression.is_a?(BinaryExpression)
        interpret_binary_expression(expression)
      when expression.is_a?(CallExpression)

      when expression.is_a?(GroupingExpression)
        interpret_grouping_expression(expression)
      when expression.is_a?(LiteralExpression)
        interpret_literal_expression(expression)
      when expression.is_a?(UnaryExpression)
        interpret_unary_expression(expression)
      when expression.is_a?(VariableExpression)
        @environment.get(expression.name)
      else
        raise 'Invalid expression type'
      end
    end

    def execute(statement)
      case true
      when statement.is_a?(ExpressionStatement)
        evaluate(statement.expression)

        nil
      when statement.is_a?(PrintStatement)
        value = evaluate(statement.value)

        puts value.to_s

        nil
      when statement.is_a?(VariableStatement)
        value = nil

        value = evaluate(statement.initializer) unless statement.initializer.nil?

        @environment.define(statement.name.lexeme, value)

        nil
      when statement.is_a?(BlockStatement)
        execute_block(statement.statements, Environment.new(@environment))
      else
        raise 'Invalid statement type'
      end
    end

    def execute_block(statements, environment)
      previous = @environment

      begin
        @environment = environment

        statements.each do |statement|
          execute(statement)
        end
      ensure
        @environment = previous
      end
    end

    def assert_is_numeric(token, value)
      return if value.is_a? Numeric

      raise RloxRuntimeError.new(token, 'Operand must be numeric')
    end
  end
end
