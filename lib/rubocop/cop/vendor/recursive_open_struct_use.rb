# frozen_string_literal: true

module RuboCop
  module Cop
    module Vendor
      # This cop flags uses of RecursiveOpenStruct. RecursiveOpenStruct is a library used in the
      # Wealthsimple ecosystem that is being phased out due to security issues.
      #
      # RecursiveOpenStruct inherits from OpenStruct, which is now officially discouraged to be used
      # for performance, version compatibility, and security issues.
      #
      # @safety
      #
      #   Note that this cop may flag false positives; for instance, the following legal
      #   use of a hand-rolled `RecursiveOpenStruct` type would be considered an offense:
      #
      #   ```
      #   module MyNamespace
      #     class RecursiveOpenStruct # not the RecursiveOpenStruct we're looking for
      #     end
      #
      #     def new_struct
      #       RecursiveOpenStruct.new # resolves to MyNamespace::RecursiveOpenStruct
      #     end
      #   end
      #   ```
      #
      # @example
      #
      #   # bad
      #   point = RecursiveOpenStruct.new(x: 0, y: 1)
      #
      #   # good
      #   Point = Struct.new(:x, :y)
      #   point = Point.new(0, 1)
      #
      #   # also good
      #   point = { x: 0, y: 1 }
      #
      #   # bad
      #   test_double = RecursiveOpenStruct.new(a: 'b')
      #
      #   # good (assumes test using rspec-mocks)
      #   test_double = double
      #   allow(test_double).to receive(:a).and_return('b')
      #
      class RecursiveOpenStructUse < Base
        MSG = <<~MSG.strip
          Avoid using `RecursiveOpenStruct`; use `Struct`, `Hash`, a class or test doubles instead.
        MSG

        # @!method uses_recursive_open_struct?(node)
        def_node_matcher :uses_recursive_open_struct?, <<-PATTERN
          (const {nil? (cbase)} :RecursiveOpenStruct)
        PATTERN

        def on_const(node)
          return unless uses_recursive_open_struct?(node)
          return if custom_class_or_module_definition?(node)

          add_offense(node)
        end

        private

        def custom_class_or_module_definition?(node)
          parent = node.parent

          (parent.class_type? || parent.module_type?) && node.left_siblings.empty?
        end
      end
    end
  end
end
