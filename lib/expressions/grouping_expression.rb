# typed: true
# frozen_string_literal: true

require_relative 'expression'

module Rlox
  class GroupingExpression < Expression
    attr_reader :expression

    def initialize(expression)
      @expression = expression
    end

    def to_s
      @expression.to_s
    end
  end
end
