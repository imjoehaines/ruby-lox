# typed: strict
# frozen_string_literal: true

require_relative 'expression'

module Rlox
  class VariableExpression < Expression
    extend T::Sig

    sig {returns(Token)}
    attr_reader :name

    sig {params(name: Token).void}
    def initialize(name)
      @name = name
    end
  end
end
