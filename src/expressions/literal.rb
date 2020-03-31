# frozen_string_literal: true

class Literal
  attr_reader :literal

  def initialize(literal)
    @literal = literal
  end

  def to_s
    @literal.to_s
  end
end
