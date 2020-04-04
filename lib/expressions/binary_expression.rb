# typed: strict
# frozen_string_literal: true

require_relative 'expression'

module Rlox
  class BinaryExpression < Expression
    extend T::Sig

    sig {returns(Expression)}
    attr_reader :left

    sig {returns(Token)}
    attr_reader :operator

    sig {returns(Expression)}
    attr_reader :right

    sig {params(left: Expression, operator: Token, right: Expression).void}
    def initialize(left, operator, right)
      @left = left
      @operator = operator
      @right = right
    end

    sig {returns(String)}
    def to_s
      "#{@left} #{@operator} #{@right}"
    end
  end
end
