# frozen_string_literal: true

class Environment
  def initialize(enclosing = nil)
    @values = {}
    @enclosing = enclosing
  end

  def define(name, value)
    @values[name] = value
  end

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

    raise RloxRuntimeError.new(token, "Undefined variable (assignment) '#{name}'.")
  end

  def get(token)
    name = token.lexeme

    return @values[name] if @values.key?(name)

    return @enclosing.get(token) unless @enclosing.nil?

    raise RloxRuntimeError.new(token, "Undefined variable (get) '#{name}'.")
  end
end
