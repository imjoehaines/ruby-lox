# typed: strict
# frozen_string_literal: true

require_relative 'statement'

module Rlox
  class BlockStatement < Statement
    extend T::Sig

    sig {returns(T::Array[Statement])}
    attr_reader :statements

    sig {params(statements: T::Array[Statement]).void}
    def initialize(statements)
      @statements = statements
    end
  end
end
