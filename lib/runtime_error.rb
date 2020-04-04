# typed: true
# frozen_string_literal: true

module Rlox
  class RuntimeError < ::RuntimeError
    attr_reader :token

    def initialize(token, message)
      super(message)

      @token = token
    end
  end
end
