# typed: true
# frozen_string_literal: true

require_relative 'expression'

module Rlox
  class CallExpression < Expression
    attr_reader :callee, :paren, :arguments

    def initialize(callee, paren, arguments)
      @callee = callee
      @paren = paren
      @arguments = arguments
    end

    def to_s
      "#{@callee} #{@paren} #{@arguments}"
    end
  end
end
