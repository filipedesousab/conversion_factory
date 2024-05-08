# frozen_string_literal: true

module ConversionFactory
  module Adapters
    class Performer
      attr_accessor :converter, :output_extension, :output_type
      attr_reader   :output_path

      def initialize(converter: nil, output_path: nil, output_extension: nil, output_type: nil)
        @converter = converter
        self.output_path = output_path if output_path
        @output_extension = output_extension
        @output_type = output_type
      end

      def output_path=(output_path)
        @output_path = Pathname.new(output_path)
      end

      def run(input_file)
        defined_output_path = prepare_output_path(input_file)
        defined_output_extension = define_output_extension(input_file)
        defined_output_type = define_output_type(input_file)

        converter.convert(input: input_file.file, content_type: input_file.content_type,
                          output_filename: input_file.output_filename, output_path: defined_output_path,
                          output_extension: defined_output_extension, output_type: defined_output_type)
      end

      private

      def converter_name
        converter.name || converter.class
      end

      def prepare_output_path(input_file)
        defined_output_path = input_file.output_path || output_path

        raise Errors::EmptyOutputPath, "Empty output path to #{input_file.file} and #{converter_name}" \
          unless defined_output_path

        defined_output_path.mkdir unless defined_output_path.exist?
        defined_output_path
      end

      def define_output_extension(input_file)
        defined_output_extension = input_file.output_extension || output_extension || converter.default_output_extension

        raise Errors::EmptyOutputExtension unless defined_output_extension

        defined_output_extension
      rescue Errors::EmptyOutputExtension, NoMethodError
        raise Errors::EmptyOutputExtension, "Empty output extension to #{input_file.file} and #{converter_name}"
      end

      def define_output_type(input_file)
        defined_output_type = input_file.output_type || output_type || converter.default_output_type

        raise Errors::EmptyOutputType unless defined_output_type

        defined_output_type
      rescue Errors::EmptyOutputType, NoMethodError
        raise Errors::EmptyOutputType, "Empty output type to #{input_file.file} and #{converter_name}"
      end
    end
  end
end
