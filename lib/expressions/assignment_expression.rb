# typed: true
# frozen_string_literal: true

require_relative 'expression'

module Rlox
  class AssignmentExpression < Expression
    attr_reader :name, :value

    def initialize(name, value)
      @name = name
      @value = value
    end

    def to_s
      "#{@name} #{@value}"
    end
  end
end
