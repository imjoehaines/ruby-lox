# typed: strict
# frozen_string_literal: true

require_relative 'expression'

module Rlox
  class LiteralExpression < Expression
    extend T::Sig

    sig {returns(T.untyped)}
    attr_reader :value

    sig {params(value: T.untyped).void}
    def initialize(value)
      @value = value
    end

    sig {returns(String)}
    def to_s
      @value.to_s
    end
  end
end
