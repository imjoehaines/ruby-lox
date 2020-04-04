# typed: true
# frozen_string_literal: true

class ExpressionStatement
  attr_reader :expression

  def initialize(expression)
    @expression = expression
  end
end
