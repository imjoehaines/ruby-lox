# typed: strict
# frozen_string_literal: true

require_relative 'expression'

module Rlox
  class AssignmentExpression < Expression
    extend T::Sig

    sig {returns(Token)}
    attr_reader :name

    sig {returns(T.untyped)}
    attr_reader :value

    sig {params(name: Token, value: T.untyped).void}
    def initialize(name, value)
      @name = name
      @value = value
    end

    sig {returns(String)}
    def to_s
      "#{@name} #{@value}"
    end
  end
end
