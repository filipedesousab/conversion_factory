# frozen_string_literal: true

require_relative 'errors/invalid_input_type'
require_relative 'errors/invalid_output_type'
require_relative 'errors/non_existent_file'
require_relative 'errors/empty_output_path'
require_relative 'errors/empty_output_extension'
require_relative 'errors/empty_output_type'

module ConversionFactory
  class ErrorList < Array
    def to_s
      map(&:message)
    end
  end

  module Errors
    attr_reader :errors

    def push_error(error)
      @errors ||= ErrorList.new
      @errors << prepare_error(error) if error
    end

    def prepare_error(error)
      return error if error.is_a? StandardError

      StandardError.new(error)
    end
  end
end
