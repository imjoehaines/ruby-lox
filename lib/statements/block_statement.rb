# typed: true
# frozen_string_literal: true

require_relative 'statement'

module Rlox
  class BlockStatement < Statement
    attr_reader :statements

    def initialize(statements)
      @statements = statements
    end
  end
end
