# frozen_string_literal: true

require 'ruby-filemagic'
require 'tmpdir'
require_relative 'errors'

module ConversionFactory
  class Build
    include ConversionFactory::Errors

    attr_reader :input_files, :output_path, :performers

    def initialize(input_files: [], output_path: nil, performers: [])
      self.input_files = input_files if input_files
      self.output_path = output_path
      self.performers = performers
    end

    def run
      input_files.each do |input_file|
        performers.each do |performer|
          performer.run(input_file)
        rescue StandardError => e
          push_error(e)

          raise e if ConversionFactory.configuration.raise_exception
        end
      end
    end

    def input_files=(input_files)
      @input_files = input_files.map do |input_file|
        input_file.is_a?(Entities::InputFile) ? input_file : Entities::InputFile.new(**input_file)
      rescue StandardError => e
        push_error(e)

        raise e if ConversionFactory.configuration.raise_exception
      end
    end

    def output_path=(output_path)
      @output_path = output_path ? Pathname.new(output_path) : ConversionFactory.configuration.output_path
    end

    def performers=(performers)
      @performers = performers.map do |performer_params|
        performer_params = performer_params.transform_keys(&:to_sym)
        convert_output_path = performer_params[:output_path] || output_path

        Entities::Performer.new(**performer_params, output_path: convert_output_path)
      end
    end
  end
end
