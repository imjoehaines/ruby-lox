# frozen_string_literal: true

class Environment
  def initialize
    @values = {}
  end

  def define(name, value)
    @values[name] = value
  end

  def assign(token, value)
    name = token.lexeme

    unless @values.key?(name)
      raise RloxRuntimeError.new(token, "Undefined variable #{name}")
    end

    @values[name] = value
  end

  def get(token)
    name = token.lexeme

    return @values[name] if @values.key?(name)

    raise RloxRuntimeError.new(token, "Undefined variable '#{name}'.")
  end
end
