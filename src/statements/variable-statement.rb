# typed: true
# frozen_string_literal: true

require_relative 'statement'

module Rlox
  class VariableStatement < Statement
    attr_reader :name, :initializer

    def initialize(name, initializer)
      @name = name
      @initializer = initializer
    end
  end
end
