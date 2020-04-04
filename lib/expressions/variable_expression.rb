# typed: true
# frozen_string_literal: true

require_relative 'expression'

module Rlox
  class VariableExpression < Expression
    attr_reader :name

    def initialize(name)
      @name = name
    end
  end
end
