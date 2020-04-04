# typed: strict
# frozen_string_literal: true

module Rlox
  class RuntimeError < ::RuntimeError
    extend T::Sig

    sig {returns(Token)}
    attr_reader :token

    sig {params(token: Token, message: String).void}
    def initialize(token, message)
      super(message)

      @token = token
    end
  end
end
