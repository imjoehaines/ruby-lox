# typed: true
# frozen_string_literal: true

require_relative 'expression'

module Rlox
  class LiteralExpression < Expression
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def to_s
      @value.to_s
    end
  end
end
