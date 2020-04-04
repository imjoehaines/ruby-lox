# typed: true
# frozen_string_literal: true

require_relative 'expression'

module Rlox
  class UnaryExpression < Expression
    attr_reader :operator, :expression

    def initialize(operator, expression)
      @operator = operator
      @expression = expression
    end

    def to_s
      "#{@operator} #{@expression}"
    end
  end
end
