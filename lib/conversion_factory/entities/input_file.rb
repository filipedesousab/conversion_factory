# frozen_string_literal: true

require 'ruby-filemagic'
require 'tmpdir'

module ConversionFactory
  module Entities
    class InputFile
      attr_reader   :file, :content_type, :output_path
      attr_accessor :output_filename

      def initialize(file: nil, content_type: nil, output_path: nil, output_filename: nil)
        self.file = file if file
        self.content_type = content_type if content_type
        self.output_path = output_path if output_path
        @output_filename = output_filename
      end

      def file=(file)
        raise Errors::NonExistentFile unless Pathname.new(file).file?

        @file = file.is_a?(Pathname) ? file : Pathname.new(file)
        set_content_type
        @file # rubocop:disable Lint/Void
      end

      def content_type=(content_type)
        @content_type = content_type || set_content_type
      end

      def output_path=(output_path)
        @output_path = output_path.is_a?(Pathname) ? output_path : Pathname.new(output_path)
      end

      private

      def set_content_type
        @content_type ||= FileMagic.mime.file(file.to_s, true) if file
      end
    end
  end
end
