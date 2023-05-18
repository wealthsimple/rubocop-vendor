# frozen_string_literal: true

module RuboCop
  module Cop
    module Vendor
      # This cop flags uses of the sidekiq-throttled gem.
      #
      # sidekiq-throttled overrides sidekiq-pro and sidekiq-enterprise features,
      # resulting in at-most once delivery of sidekiq jobs, instead of at-least once delivery
      # of sidekiq jobs. This means there is a relatively good chance you will LOSE JOBS that were enqueued
      # if the sidekiq-process runs out of memory or does not shutdown gracefully.
      #
      # https://wealthsimple.slack.com/archives/C19UB3HNZ/p1683721247371709 for more details
      class SidekiqThrottledGem < Base
        MSG = <<~MSG.strip
          Do not use the sidekiq-throttled gem. sidekiq-throttled overrides the fetcher of sidekiq-pro and sidekiq-enterprise resulting in the ability to lose jobs (switch to at-most once processing).
        MSG

        def on_new_investigation
          return if processed_source.blank?

          gem_declarations(processed_source.ast).each do |declaration|
            next unless declaration.first_argument.str_content.match?('sidekiq-throttled')

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
