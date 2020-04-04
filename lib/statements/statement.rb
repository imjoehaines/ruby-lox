# typed: strong
# frozen_string_literal: true

module Rlox
  class Statement
    extend T::Helpers
    extend T::Sig

    abstract!
  end
end
