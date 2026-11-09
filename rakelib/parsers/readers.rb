# frozen_string_literal: true

module Parsers
  module Readers
    private

    def reader(name, &block)
      ivar = "@#{name}"
      define_method(name) do
        return instance_variable_get(ivar) if instance_variable_defined?(ivar)

        instance_variable_set(ivar, instance_exec(&block))
      end
    end
  end
end
