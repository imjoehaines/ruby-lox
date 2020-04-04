# typed: strict
# frozen_string_literal: true

require_relative 'expression'

module Rlox
  class GroupingExpression < Expression
    extend T::Sig

    sig {returns(Expression)}
    attr_reader :expression

    sig {params(expression: Expression).void}
    def initialize(expression)
      @expression = expression
    end

    sig {returns(String)}
    def to_s
      @expression.to_s
    end
  end
end
