# frozen_string_literal: true

class Grouping
  attr_reader :expression

  def initialize(expression)
    @expression = expression
  end

  def to_s
    @expression.to_s
  end
end
