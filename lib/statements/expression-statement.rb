# typed: true
# frozen_string_literal: true

require_relative 'statement'

module Rlox
  class ExpressionStatement < Statement
    attr_reader :expression

    def initialize(expression)
      @expression = expression
    end
  end
end
