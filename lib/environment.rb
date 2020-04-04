# typed: strict
# frozen_string_literal: true

module Rlox
  class Environment
    extend T::Sig

    sig {params(enclosing: T::nilable(Environment)).void}
    def initialize(enclosing = nil)
      @values = T.let({}, T::Hash[String, T.untyped])
      @enclosing = T.let(enclosing, T.nilable(Environment))
    end

    sig {params(name: String, value: T.untyped).void}
    def define(name, value)
      @values[name] = value
    end

    sig {params(token: Token, value: T.untyped).void}
    def assign(token, value)
      name = token.lexeme

      if @values.key?(name)
        @values[name] = value
        return
      end

      unless @enclosing.nil?
        @enclosing.assign(token, value)
        return
      end

      raise RuntimeError.new(token, "Undefined variable (assignment) '#{name}'.")
    end

    sig {params(token: Token).returns(T.untyped)}
    def get(token)
      name = token.lexeme

      return @values[name] if @values.key?(name)

      return @enclosing.get(token) unless @enclosing.nil?

      raise RuntimeError.new(token, "Undefined variable (get) '#{name}'.")
    end
  end
end
