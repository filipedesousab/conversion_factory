# frozen_string_literal: true

module ConversionFactory
  module Entities
    class Performer
      attr_accessor :converter
      attr_reader   :output_path

      def initialize(converter: nil, output_path: nil)
        @converter = converter
        self.output_path = output_path if output_path
      end

      def output_path=(output_path)
        @output_path = Pathname.new(output_path)
      end

      def run(input_file)
        convert_output_path = prepare_output_path(input_file)

        converter.convert(input: input_file.file, content_type: input_file.content_type,
                          output_filename: input_file.output_filename, output_path: convert_output_path)
      end

      private

      def prepare_output_path(input_file)
        convert_output_path = input_file.output_path || output_path

        raise Errors::EmptyOutputPath unless convert_output_path

        convert_output_path.mkdir unless convert_output_path.exist?
        convert_output_path
      end
    end
  end
end
