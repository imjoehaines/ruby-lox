# frozen_string_literal: true

class VariableStatement
  attr_reader :name, :initializer

  def initialize(name, initializer)
    @name = name
    @initializer = initializer
  end
end
