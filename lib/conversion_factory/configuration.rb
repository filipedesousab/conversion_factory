# frozen_string_literal: true

module ConversionFactory
  class Configuration
    attr_reader :output_path
    attr_accessor :raise_exception

    def initialize
      self.output_path = Dir.tmpdir
      self.raise_exception = true
    end

    def output_path=(output_path)
      @output_path = output_path && Pathname.new(output_path)
    end
  end
end
