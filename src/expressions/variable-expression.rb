# frozen_string_literal: true

class VariableExpression
  attr_reader :name

  def initialize(name)
    @name = name
  end
end
