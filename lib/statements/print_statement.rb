# typed: true
# frozen_string_literal: true

require_relative 'statement'

module Rlox
  class PrintStatement < Statement
    attr_reader :value

    def initialize(value)
      @value = value
    end
  end
end
