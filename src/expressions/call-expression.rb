# frozen_string_literal: true

class CallExpression
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
