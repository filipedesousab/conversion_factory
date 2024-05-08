# frozen_string_literal: true

require_relative 'conversion_factory/build'
require_relative 'conversion_factory/configuration'
require_relative 'conversion_factory/adapters'
require_relative 'conversion_factory/errors'
require_relative 'conversion_factory/version'

module ConversionFactory
  module_function

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield(configuration)
  end

  def build(**params)
    Build.new(**params)
  end
end
