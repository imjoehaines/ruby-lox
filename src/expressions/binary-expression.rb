# frozen_string_literal: true

class BinaryExpression
  attr_reader :left, :operator, :right

  def initialize(left, operator, right)
    @left = left
    @operator = operator
    @right = right
  end

  def to_s
    "#{@left} #{@operator} #{@right}"
  end
end
