# typed: strict
# frozen_string_literal: true

require_relative 'statement'
require_relative '../expressions/expression'

module Rlox
  class ExpressionStatement < Statement
    extend T::Sig

    sig {returns(Expression)}
    attr_reader :expression

    sig {params(expression: Expression).void}
    def initialize(expression)
      @expression = expression
    end
  end
end
