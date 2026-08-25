# frozen_string_literal: true

module Docs
  # Raised when the documentation no longer has the shape the parsers expect.
  # Structural surprises are loud on purpose: a silent miss is how
  # getChatMemberCount went missing from the generated endpoints.
  Error = Class.new(StandardError)
end
