# frozen_string_literal: true

require 'ruby-filemagic'
require 'tmpdir'

module ConversionFactory
  module Entities
    class InputFile
      attr_reader :file, :content_type, :output_path, :output_filename

      def initialize(file: nil, content_type: nil, output_path: nil, output_filename: nil)
        self.file = file if file
        self.content_type = content_type if content_type
        self.output_path = output_path if output_path
        self.output_filename = output_filename
      end

      def file=(file)
        raise Errors::NonExistentFile, "Non existent file to path #{file}" \
          unless Pathname.new(file).file?

        @file = Pathname.new(file)
        set_content_type
        set_output_filename if output_filename.to_s.empty?
        @file # rubocop:disable Lint/Void
      end

      def content_type=(content_type)
        @content_type = content_type || set_content_type
      end

      def output_path=(output_path)
        @output_path = Pathname.new(output_path)
      end

      def output_filename=(output_filename = nil)
        @output_filename = output_filename || set_output_filename
      end

      private

      def set_content_type
        @content_type ||= FileMagic.mime.file(file.to_s, true) if file
      end

      def set_output_filename
        @output_filename = file&.basename&.to_s
      end
    end
  end
end
