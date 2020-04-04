# typed: strict
# frozen_string_literal: true

require_relative 'expression'

module Rlox
  class UnaryExpression < Expression
    extend T::Sig

    sig {returns(Token)}
    attr_reader :operator

    sig {returns(Expression)}
    attr_reader :expression

    sig {params(operator: Token, expression: Expression).void}
    def initialize(operator, expression)
      @operator = operator
      @expression = expression
    end

    sig {returns(String)}
    def to_s
      "#{@operator} #{@expression}"
    end
  end
end
