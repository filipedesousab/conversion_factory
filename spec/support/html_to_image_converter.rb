# frozen_string_literal: true

class HTMLToImageConverter
  attr_reader :success

  ACCEPTED_TYPES = ['text/html'].freeze

  def convert(input:, content_type: nil, output_path: nil, output_filename: nil)
    raise Errors::InvalidType unless ACCEPTED_TYPES.include?(content_type)

    puts generate_message(input_file_path: input.path, output_path: output_path, output_filename: output_filename)
    @success = true
  end

  def generate_message(input_file_path:, output_path:, output_filename:)
    "Convert #{input_file_path} to Image and saving to #{output_path}/#{output_filename}"
  end
end
