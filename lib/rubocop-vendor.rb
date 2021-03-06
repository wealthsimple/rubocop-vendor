# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/vendor'
require_relative 'rubocop/vendor/version'
require_relative 'rubocop/vendor/inject'

RuboCop::Vendor::Inject.defaults!

require_relative 'rubocop/cop/vendor_cops'
