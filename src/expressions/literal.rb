# frozen_string_literal: true

class Literal
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_s
    @value.to_s
  end
end
