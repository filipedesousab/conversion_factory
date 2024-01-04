# frozen_string_literal: true

require 'ruby-filemagic'
require 'tmpdir'

module ConversionFactory
  class Build
    attr_reader   :input, :content_type, :output_path, :converters
    attr_accessor :output_filename

    def initialize(input: nil, content_type: nil, output_path: nil, output_filename: nil, converters: [])
      self.input = input if input
      self.content_type = content_type if content_type
      self.output_path = output_path
      @output_filename = output_filename
      self.converters = converters
    end

    def run
      converters.map do |converter_params|
        converter = converter_params[:converter]
        convert_output_path = converter_params[:output_path] || output_path
        convert_output_filename = converter_params[:output_filename] || output_filename

        converter.convert(input: input, content_type: content_type, output_path: convert_output_path,
                          output_filename: convert_output_filename)
      end
    end

    def input=(input)
      raise Errors::NonExistentFile unless File.exist?(input)

      @input = input.is_a?(File) ? input : File.new(input)
      set_content_type
      @input # rubocop:disable Lint/Void
    end

    def output_path=(output_path)
      @output_path = output_path ? Pathname.new(output_path) : Pathname.new(Dir.tmpdir)
    end

    def content_type=(content_type)
      @content_type = content_type || set_content_type
    end

    def converters=(converters)
      @converters = converters.map { |converter_params| converter_params.transform_keys(&:to_sym) }
    end

    private

    def set_content_type
      @content_type ||= FileMagic.mime.file(input.path, true) if input
    end
  end
end
