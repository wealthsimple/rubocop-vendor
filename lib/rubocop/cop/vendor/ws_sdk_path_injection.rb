# frozen_string_literal: true
require 'parser/current'

module RuboCop
  module Cop
    module Vendor
      # This cop checks for `Ws::Service#get,patch,post,put,delete,...` usage and suggests to use component based paths
      # instead of using interpolated values that could be user input.
      #
      # This is to avoid path injection, a potential security vulnerability!
      #
      # @example
      #   # bad
      #   # could post to /api/accounts with same credentials (e.g. by passing "?" as account_id)
      #   Ws::AccountService.post("/api/accounts/#{account_id}/details")
      #
      #   # good
      #   Ws::AccountService.post(["api","accounts", account_id, "details"])
      #
      #   # okay, but prefer above
      #   Ws::AccountService.post("/api/accounts/#{URI.encode_www_component(account_id)}")
      #
      class WsSdkPathInjection < Base
        extend AutoCorrector

        MSG = <<-STR.strip
          Use of paths with interpolated values is dangerous, as path injection can occur; prefer to use array of each path component
        STR
        HTTP_METHODS = Set[:get, :patch, :put, :post, :delete, :head, :options, :trace]

        # @!method ws_sdk_service_call?(node)
        def_node_matcher :ws_sdk_service_call?, <<-PATTERN, method: HTTP_METHODS
          (send (const (const _ :Ws) _) %method $...)
        PATTERN

        def on_send(node)
          return unless self.class.ws_sdk_supports_arrays?

          path, = ws_sdk_service_call?(node)
          return unless path && path.type != :array

          add_offense(path) do |corrector|
            correct_path(corrector, path)
          end
        end

        def correct_path(corrector, path)
          parts =
            if path.type == :send
              [path.source]
            else
              path.children.flat_map do |child|
                binding.irb if child == :join
                if child&.type == :str
                  child.value.delete_prefix("/").delete_suffix("/").split("/").map { |v| "\"#{v}\"" }
                elsif child&.type == :begin # begin interpolation
                  child.children.first.source
                elsif child&.type == :send
                  child.source
                else
                  return # do not know how to auto-correct
                end
              end
            end

          corrector.replace(path.loc.expression, "[#{parts.join(', ')}]")
        end

        def self.ws_sdk_supports_arrays?
          Gem.loaded_specs['ws-sdk'].version >= Gem::Version.new("13.3.0")
        end
      end
    end
  end
end
