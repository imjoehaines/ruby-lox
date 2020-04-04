# typed: strict
# frozen_string_literal: true

require_relative 'statement'
require_relative '../expressions/expression'

module Rlox
  class PrintStatement < Statement
    extend T::Sig

    sig {returns(Expression)}
    attr_reader :value

    sig {params(value: Expression).void}
    def initialize(value)
      @value = value
    end
  end
end
