# frozen_string_literal: true

module RuboCop
end

require_relative 'vendor/active_record_base_transaction_use'
require_relative 'vendor/active_record_connection_execute'
require_relative 'vendor/recursive_open_struct_gem'
require_relative 'vendor/sidekiq_throttled_gem'
require_relative 'vendor/recursive_open_struct_use'
require_relative 'vendor/rollbar_inside_rescue'
require_relative 'vendor/rollbar_interpolation'
require_relative 'vendor/rollbar_log'
require_relative 'vendor/rollbar_logger'
require_relative 'vendor/rollbar_with_exception'
require_relative 'vendor/strict_dry_struct'
require_relative 'vendor/ws_sdk_path_array_slash'
require_relative 'vendor/ws_sdk_path_injection'
