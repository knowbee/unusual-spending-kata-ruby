# frozen_string_literal: true

module UnusualSpending
  module VERSION
    MAJOR = 0
    MINOR = 1
    TINY  = 2
    PRE   = nil

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join(".")

    SUMMARY = "unusual_spending #{STRING}"
  end
end
