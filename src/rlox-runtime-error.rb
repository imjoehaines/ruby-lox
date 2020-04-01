# frozen_string_literal: true

class RloxRuntimeError < RuntimeError
  attr_reader :token

  def initialize(token, message)
    super(message)

    @token = token
  end
end
