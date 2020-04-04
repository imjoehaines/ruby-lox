# typed: true
# frozen_string_literal: true

class BlockStatement
  attr_reader :statements

  def initialize(statements)
    @statements = statements
  end
end
