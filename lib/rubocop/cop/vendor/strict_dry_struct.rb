# frozen_string_literal: true

module RuboCop
  module Cop
    module Vendor
      # This cop flags uses of DryStruct without strict mode
      #
      # By default DryStruct will not throw an error if passed an attribute that wasn't defined.
      # We want to enfore strict mode which will throw an error in that case.
      class StrictDryStruct < RuboCop::Cop::Base
        MSG = 'Avoid using `Dry::Struct` without schema schema.strict'

        # @!method uses_dry_struct?(node)
        def_node_matcher :uses_dry_struct?, <<-PATTERN
          (const (const {nil? (cbase)} :Dry) :Struct)
        PATTERN

        # @!method uses_strict_mode?(node)
        def_node_search :uses_strict_mode?, <<-PATTERN
          (send nil? :schema (send (send nil? :schema) :strict))
        PATTERN

        def on_const(node)
          return unless uses_dry_struct?(node)
          return if uses_strict_mode?(node.parent)

          add_offense(node)
        end
      end
    end
  end
end
