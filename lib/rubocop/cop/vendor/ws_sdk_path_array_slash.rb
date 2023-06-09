# frozen_string_literal: true
require 'parser/current'

module RuboCop
  module Cop
    module Vendor
      # This cop checks for `Ws::Service#get,patch,post,put,delete,...` usage
      # where the array format is used, but it contains (probably not) intended slashes.
      # These slashes will be converted to %2f instead of a path component.
      #
      # @example
      #   # bad
      #   Ws::AccountService.post(["/test/foo"]) # forward flash will be converted to %2f
      #
      #   # good
      #   Ws::AccountService.post(["test", "foo"])
      #
      class WsSdkPathArraySlash < Base
        extend AutoCorrector

        MSG = <<-STR.strip
          When switching to array arguments, you must put each path component individually
        STR
        HTTP_METHODS = Set[:get, :patch, :put, :post, :delete, :head, :options, :trace]

        # @!method ws_sdk_service_call?(node)
        def_node_matcher :ws_sdk_service_call?, <<-PATTERN, method: HTTP_METHODS
          (send (const (const _ :Ws) _) %method $...)
        PATTERN

        def on_send(node)
          path, = ws_sdk_service_call?(node)
          return unless path && path.type == :array

          strings_with_slash = path.children.select { |n| n.str_type? && n.value.include?("/") }

          strings_with_slash.each do |str_node|
            add_offense(str_node) do |corrector|
              correct_path(corrector, path)
            end
          end
        end

        def correct_path(corrector, path)
          parts =
            path.children.flat_map do |child|
              if child.str_type? && child.value.include?("/")
                child.value.delete_prefix("/").delete_suffix("/").split("/").map { |v| "\"#{v}\"" }
              else
                [child.source]
              end
            end
            corrector.replace(path.loc.expression, "[#{parts.join(', ')}]")
        end
      end
    end
  end
end
