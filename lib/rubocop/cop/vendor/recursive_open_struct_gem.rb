# frozen_string_literal: true

module RuboCop
  module Cop
    module Vendor
      # This cop flags uses of the recursive-open-struct gem.
      #
      # RecursiveOpenStruct inherits from OpenStruct, which is now officially discouraged to be used
      # for performance, version compatibility, and security issues.
      #
      # https://ruby-doc.org/stdlib-3.0.1/libdoc/ostruct/rdoc/OpenStruct.html#class-OpenStruct-label-Caveats
      class RecursiveOpenStructGem < Base
        MSG = <<~MSG.strip
          Do not use the recursive-open-struct gem. RecursiveOpenStruct inherits from OpenStruct, which is now officially discouraged from usage due to performance, version compatibility, and security issues.
        MSG

        def on_new_investigation
          return if processed_source.blank?

          gem_declarations(processed_source.ast).each do |declaration|
            next unless declaration.first_argument.str_content.match?('recursive-open-struct')

            add_offense(declaration)
          end
        end

        # @!method gem_declarations(node)
        def_node_search :gem_declarations, <<~PATTERN
          (:send nil? :gem str ...)
        PATTERN
      end
    end
  end
end
