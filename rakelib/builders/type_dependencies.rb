# frozen_string_literal: true

require 'set'

module Builders
  # Decides which generated type references must be wrapped in Types.deferred:
  # referencing a union that can reach back to the referencing type would
  # evaluate the union constant mid-definition and fail to load.
  class TypeDependencies
    EMPTY = [].freeze

    def initialize(types)
      @known_types = types.keys.to_set(&:to_s)
      @dependencies = types.to_h { |name, definition| [name.to_s, references_in(definition)] }
      unions = types.select { |_, definition| definition[:type].is_a?(Array) }.keys
      @reachable_from_union = unions.to_h { |name| [name.to_s, reachable_from(name.to_s)] }
    end

    def deferred?(owner:, target:)
      @reachable_from_union[target.to_s]&.include?(owner.to_s) || false
    end

    private

    def references_in(value)
      case value
      when Hash
        value.values.flat_map { |item| references_in(item) }
      when Array
        value.flat_map { |item| references_in(item) }
      when String
        @known_types.include?(value) ? [value] : EMPTY
      else
        EMPTY
      end
    end

    def reachable_from(node, visited = Set.new)
      return visited unless visited.add?(node)

      @dependencies.fetch(node, EMPTY).each { |dependency| reachable_from(dependency, visited) }
      visited
    end
  end
end
