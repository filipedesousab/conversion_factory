# frozen_string_literal: true

class HTMLToImageConverter
  attr_reader :success

  ACCEPTED_INPUT_TYPES = ['text/html'].freeze
  ACCEPTED_OUTPUT_TYPES = %w[jpeg png].freeze

  def name
    'HTMLToImage'
  end

  def convert(input:, content_type:, output_path:, output_filename:, # rubocop:disable Metrics/ParameterLists
              output_extension:, output_prefix:, output_sufix:, output_type:)
    raise Errors::InvalidInputType unless ACCEPTED_INPUT_TYPES.include?(content_type.to_s)
    raise Errors::InvalidOutputType unless ACCEPTED_OUTPUT_TYPES.include?(output_type.to_s)

    puts generate_message(input_file_path: input.to_s, output_path: output_path, output_filename: output_filename,
                          output_extension: output_extension, output_prefix: output_prefix, output_sufix: output_sufix,
                          output_type: output_type)
    @success = true
  end

  def generate_message(input_file_path:, output_path:, output_filename:, output_extension:, # rubocop:disable Metrics/ParameterLists
                       output_type:, output_prefix: nil, output_sufix: nil)
    "Convert #{input_file_path} to Image(#{output_type}) and saving to \
    #{output_path}/#{output_prefix}#{output_filename}#{output_sufix}.#{output_extension}"
  end
end
