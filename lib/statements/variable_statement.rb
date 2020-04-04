# typed: strict
# frozen_string_literal: true

require_relative 'statement'
require_relative '../expressions/expression'

module Rlox
  class VariableStatement < Statement
    extend T::Sig

    sig {returns(Token)}
    attr_reader :name

    sig {returns(T.nilable(Expression))}
    attr_reader :initializer

    sig {params(name: Token, initializer: T.nilable(Expression)).void}
    def initialize(name, initializer)
      @name = name
      @initializer = initializer
    end
  end
end
