require 'lint_roller'

module RuboCop
  module Vendor
    # A plugin that integrates RuboCop Vendor with RuboCop's plugin system.
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: 'rubocop-vendor',
          version: VERSION,
          homepage: 'https://github.com/wealthsimple/rubocop-vendor',
          description: 'A collection of custom Wealthsimple specific RuboCop cops.',
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        LintRoller::Rules.new(
          type: :path,
          config_format: :rubocop,
          value: Pathname.new(__dir__).join('../../../config/default.yml'),
        )
      end
    end
  end
end
