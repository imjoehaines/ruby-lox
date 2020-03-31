# frozen_string_literal: true

class UnaryExpression
  attr_reader :operator, :expression

  def initialize(operator, expression)
    @operator = operator
    @expression = expression
  end

  def to_s
    "#{@operator} #{@expression}"
  end
end
